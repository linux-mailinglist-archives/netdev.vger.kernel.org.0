Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BCC3391A4
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhCLPoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:44:04 -0500
Received: from outbound-smtp29.blacknight.com ([81.17.249.32]:46696 "EHLO
        outbound-smtp29.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231709AbhCLPnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 10:43:32 -0500
Received: from mail.blacknight.com (pemlinmail06.blacknight.ie [81.17.255.152])
        by outbound-smtp29.blacknight.com (Postfix) with ESMTPS id 9F65DBEC33
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 15:43:31 +0000 (GMT)
Received: (qmail 19736 invoked from network); 12 Mar 2021 15:43:31 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 12 Mar 2021 15:43:31 -0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 0/7 v4] Introduce a bulk order-0 page allocator with two in-tree users
Date:   Fri, 12 Mar 2021 15:43:24 +0000
Message-Id: <20210312154331.32229-1-mgorman@techsingularity.net>
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

git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v4r2

Note to Chuck and Jesper -- as this is a cross-subsystem series, you may
want to send the sunrpc and page_pool pre-requisites (patches 4 and 6)
directly to the subsystem maintainers. While sunrpc is low-risk, I'm
vaguely aware that there are other prototype series on netdev that affect
page_pool. The conflict should be obvious in linux-next.

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
particularly efficient and the intention is to iron out what the semantics
of the API should have for users. Once the semantics are ironed out, it
can be made more efficient. Despite that, this is a performance-related
for users that require multiple pages for an operation without multiple
round-trips to the page allocator. Quoting the last patch for the
high-speed networking use-case.

    For XDP-redirect workload with 100G mlx5 driver (that use page_pool)
    redirecting xdp_frame packets into a veth, that does XDP_PASS to
    create an SKB from the xdp_frame, which then cannot return the page
    to the page_pool. In this case, we saw[1] an improvement of 18.8%
    from using the alloc_pages_bulk API (3,677,958 pps -> 4,368,926 pps).

Both users in this series are corner cases (NFS and high-speed networks)
so it is unlikely that most users will see any benefit in the short
term. Potential other users are batch allocations for page cache
readahead, fault around and SLUB allocations when high-order pages are
unavailable. It's unknown how much benefit would be seen by converting
multiple page allocation calls to a single batch or what difference it may
make to headline performance. It's a chicken and egg problem given that
the potential benefit cannot be investigated without an implementation
to test against.

Light testing passed, I'm relying on Chuck and Jesper to test the target
users more aggressively but both report performance improvements with
the initial RFC.

Patch 1 moves GFP flag initialision to prepare_alloc_pages

Patch 2 renames a variable name that is particularly unpopular

Patch 3 adds a bulk page allocator

Patch 4 is a sunrpc cleanup that is a pre-requisite.

Patch 5 is the sunrpc user. Chuck also has a patch which further caches
	pages but is not included in this series. It's not directly
	related to the bulk allocator and as it caches pages, it might
	have other concerns (e.g. does it need a shrinker?)

Patch 6 is a preparation patch only for the network user

Patch 7 converts the net page pool to the bulk allocator for order-0 pages.

 include/linux/gfp.h   |  12 ++++
 mm/page_alloc.c       | 149 +++++++++++++++++++++++++++++++++++++-----
 net/core/page_pool.c  | 101 +++++++++++++++++-----------
 net/sunrpc/svc_xprt.c |  47 +++++++++----
 4 files changed, 240 insertions(+), 69 deletions(-)

-- 
2.26.2

