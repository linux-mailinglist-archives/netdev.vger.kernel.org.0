Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4A03490FF
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 12:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhCYLni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 07:43:38 -0400
Received: from outbound-smtp47.blacknight.com ([46.22.136.64]:54307 "EHLO
        outbound-smtp47.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232220AbhCYLml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 07:42:41 -0400
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp47.blacknight.com (Postfix) with ESMTPS id 50C8FFA826
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:42:39 +0000 (GMT)
Received: (qmail 14641 invoked from network); 25 Mar 2021 11:42:39 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 25 Mar 2021 11:42:39 -0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 0/9 v6] Introduce a bulk order-0 page allocator with two in-tree users
Date:   Thu, 25 Mar 2021 11:42:19 +0000
Message-Id: <20210325114228.27719-1-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is based on top of Matthew Wilcox's series "Rationalise
__alloc_pages wrapper" and does not apply to 5.14-rc4. If Andrew's tree
is not the testing baseline then the following git tree will work.

git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v6r7

Changelog since v5
o Add micro-optimisations from Jesper
o Add array-based versions of the sunrpc and page_pool users
o Allocate 1 page if local zone watermarks are not met
o Fix statistics
o prep_new_pages as they are allocated. Batching prep_new_pages with
  IRQs enabled limited how the API could be used (e.g. list must be
  empty) and added too much complexity.

Changelog since v4
o Drop users of the API
o Remove free_pages_bulk interface, no users
o Add array interface
o Allocate single page if watermark checks on local zones fail

Changelog since v3
o Rebase on top of Matthew's series consolidating the alloc_pages API
o Rename alloced to allocated
o Split out preparation patch for prepare_alloc_pages
o Defensive check for bulk allocation or <= 0 pages
o Call single page allocation path only if no pages were allocated
o Minor cosmetic cleanups
o Reorder patch dependencies by subsystem. As this is a cross-subsystem
  series, the mm patches have to be merged before the sunrpc and net
  users.

Changelog since v2
o Prep new pages with IRQs enabled
o Minor documentation update

Changelog since v1
o Parenthesise binary and boolean comparisons
o Add reviewed-bys
o Rebase to 5.12-rc2

This series introduces a bulk order-0 page allocator with sunrpc and
the network page pool being the first users. The implementation is not
efficient as semantics needed to be ironed out first. If no other semantic
changes are needed, it can be made more efficient.  Despite that, this
is a performance-related for users that require multiple pages for an
operation without multiple round-trips to the page allocator. Quoting
the last patch for the high-speed networking use-case

            Kernel          XDP stats       CPU     pps           Delta
            Baseline        XDP-RX CPU      total   3,771,046       n/a
            List            XDP-RX CPU      total   3,940,242    +4.49%
            Array           XDP-RX CPU      total   4,249,224   +12.68%

From the SUNRPC traces of svc_alloc_arg()

	Single page: 25.007 us per call over 532,571 calls
	Bulk list:    6.258 us per call over 517,034 calls
	Bulk array:   4.590 us per call over 517,442 calls

Both potential users in this series are corner cases (NFS and high-speed
networks) so it is unlikely that most users will see any benefit in the
short term. Other potential other users are batch allocations for page
cache readahead, fault around and SLUB allocations when high-order pages
are unavailable. It's unknown how much benefit would be seen by converting
multiple page allocation calls to a single batch or what difference it may
make to headline performance.

Light testing of my own running dbench over NFS passed. Chuck and Jesper
conducted their own tests and details are included in the changelogs.

Patch 1 renames a variable name that is particularly unpopular

Patch 2 adds a bulk page allocator

Patch 3 adds an array-based version of the bulk allocator

Patches 4-5 adds micro-optimisations to the implementation

Patches 6-7 SUNRPC user

Patches 8-9 Network page_pool user

 include/linux/gfp.h     |  18 +++++
 include/net/page_pool.h |   2 +-
 mm/page_alloc.c         | 157 ++++++++++++++++++++++++++++++++++++++--
 net/core/page_pool.c    | 111 ++++++++++++++++++----------
 net/sunrpc/svc_xprt.c   |  38 +++++-----
 5 files changed, 263 insertions(+), 63 deletions(-)

-- 
2.26.2

