Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEEB343C8E
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 10:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhCVJTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 05:19:35 -0400
Received: from outbound-smtp46.blacknight.com ([46.22.136.58]:53151 "EHLO
        outbound-smtp46.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229884AbhCVJTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 05:19:03 -0400
Received: from mail.blacknight.com (pemlinmail05.blacknight.ie [81.17.254.26])
        by outbound-smtp46.blacknight.com (Postfix) with ESMTPS id CE28DFBBCC
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 09:18:45 +0000 (GMT)
Received: (qmail 16087 invoked from network); 22 Mar 2021 09:18:45 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 22 Mar 2021 09:18:45 -0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 0/3 v5] Introduce a bulk order-0 page allocator
Date:   Mon, 22 Mar 2021 09:18:42 +0000
Message-Id: <20210322091845.16437-1-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is based on top of Matthew Wilcox's series "Rationalise
__alloc_pages wrapper" and does not apply to 5.12-rc2. If you want to
test and are not using Andrew's tree as a baseline, I suggest using the
following git tree

git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v5r9

The users of the API have been dropped in this version as the callers
need to check whether they prefer an array or list interface (whether
preference is based on convenience or performance).

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

This series introduces a bulk order-0 page allocator with the
intent that sunrpc and the network page pool become the first users.
The implementation is not particularly efficient and the intention is to
iron out what the semantics of the API should have for users. Despite
that, this is a performance-related enhancement for users that require
multiple pages for an operation without multiple round-trips to the page
allocator. Quoting the last patch for the prototype high-speed networking
use-case.

    For XDP-redirect workload with 100G mlx5 driver (that use page_pool)
    redirecting xdp_frame packets into a veth, that does XDP_PASS to
    create an SKB from the xdp_frame, which then cannot return the page
    to the page_pool. In this case, we saw[1] an improvement of 18.8%
    from using the alloc_pages_bulk API (3,677,958 pps -> 4,368,926 pps).

Both potential users in this series are corner cases (NFS and high-speed
networks) so it is unlikely that most users will see any benefit in the
short term. Other potential other users are batch allocations for page
cache readahead, fault around and SLUB allocations when high-order pages
are unavailable. It's unknown how much benefit would be seen by converting
multiple page allocation calls to a single batch or what difference it may
make to headline performance. It's a chicken and egg problem given that
the potential benefit cannot be investigated without an implementation
to test against.

Light testing passed, I'm relying on Chuck and Jesper to test their
implementations, choose whether to use lists or arrays and document
performance gains/losses in the changelogs.

Patch 1 renames a variable name that is particularly unpopular

Patch 2 adds a bulk page allocator

Patch 3 adds an array-based version of the bulk allocator

 include/linux/gfp.h |  18 +++++
 mm/page_alloc.c     | 171 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 185 insertions(+), 4 deletions(-)

-- 
2.26.2

