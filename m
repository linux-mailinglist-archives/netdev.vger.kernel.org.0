Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43B83371B3
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 12:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhCKLuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 06:50:01 -0500
Received: from outbound-smtp09.blacknight.com ([46.22.139.14]:40333 "EHLO
        outbound-smtp09.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232777AbhCKLtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 06:49:51 -0500
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp09.blacknight.com (Postfix) with ESMTPS id 953351C3FEC
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 11:49:35 +0000 (GMT)
Received: (qmail 21490 invoked from network); 11 Mar 2021 11:49:35 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 11 Mar 2021 11:49:35 -0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 0/5 v3] Introduce a bulk order-0 page allocator with two in-tree users
Date:   Thu, 11 Mar 2021 11:49:30 +0000
Message-Id: <20210311114935.11379-1-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changelog since v3
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
users more aggressively but both report performance improvements with the
initial RFC.

Patch 1 of this series is a cleanup to sunrpc, it could be merged
	separately but is included here as a pre-requisite.

Patch 2 is the prototype bulk allocator

Patch 3 is the sunrpc user. Chuck also has a patch which further caches
	pages but is not included in this series. It's not directly
	related to the bulk allocator and as it caches pages, it might
	have other concerns (e.g. does it need a shrinker?)

Patch 4 is a preparation patch only for the network user

Patch 5 converts the net page pool to the bulk allocator for order-0 pages.

There is no obvious impact to the existing paths as only new users of the
API should notice a difference between multiple calls to the allocator
and a single bulk allocation.

 include/linux/gfp.h   |  13 +++++
 mm/page_alloc.c       | 118 +++++++++++++++++++++++++++++++++++++++++-
 net/core/page_pool.c  | 102 ++++++++++++++++++++++--------------
 net/sunrpc/svc_xprt.c |  47 ++++++++++++-----
 4 files changed, 225 insertions(+), 55 deletions(-)

-- 
2.26.2

