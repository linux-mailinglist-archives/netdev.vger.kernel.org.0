Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D59323A9F
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 11:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbhBXKfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 05:35:34 -0500
Received: from outbound-smtp53.blacknight.com ([46.22.136.237]:38357 "EHLO
        outbound-smtp53.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234674AbhBXKfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 05:35:14 -0500
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp53.blacknight.com (Postfix) with ESMTPS id 2A4E2FA803
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 10:26:04 +0000 (GMT)
Received: (qmail 23429 invoked from network); 24 Feb 2021 10:26:04 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 24 Feb 2021 10:26:03 -0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [RFC PATCH 0/3] Introduce a bulk order-0 page allocator for sunrpc
Date:   Wed, 24 Feb 2021 10:26:00 +0000
Message-Id: <20210224102603.19524-1-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a prototype series that introduces a bulk order-0 page allocator
with sunrpc being the first user. The implementation is not particularly
efficient and the intention is to iron out what the semantics of the API
should be. That said, sunrpc was reported to have reduced allocation
latency when refilling a pool.

As a side-note, while the implementation could be more efficient, it
would require fairly deep surgery in numerous places. The lock scope would
need to be significantly reduced, particularly as vmstat, per-cpu and the
buddy allocator have different locking protocol that overal -- e.g. all
partially depend on irqs being disabled at various points. Secondly,
the core of the allocator deals with single pages where as both the bulk
allocator and per-cpu allocator operate in batches. All of that has to
be reconciled with all the existing users and their constraints (memory
offline, CMA and cpusets being the trickiest).

In terms of semantics required by new users, my preference is that a pair
of patches be applied -- the first which adds the required semantic to
the bulk allocator and the second which adds the new user.

Patch 1 of this series is a cleanup to sunrpc, it could be merged
	separately but is included here for convenience.

Patch 2 is the prototype bulk allocator

Patch 3 is the sunrpc user. Chuck also has a patch which further caches
	pages but is not included in this series. It's not directly
	related to the bulk allocator and as it caches pages, it might
	have other concerns (e.g. does it need a shrinker?)

This has only been lightly tested on a low-end NFS server. It did not break
but would benefit from an evaluation to see how much, if any, the headline
performance changes. The biggest concern is that a light test case showed
that there are a *lot* of bulk requests for 1 page which gets delegated to
the normal allocator.  The same criteria should apply to any other users.

 include/linux/gfp.h   |  13 +++++
 mm/page_alloc.c       | 113 +++++++++++++++++++++++++++++++++++++++++-
 net/sunrpc/svc_xprt.c |  47 ++++++++++++------
 3 files changed, 157 insertions(+), 16 deletions(-)

-- 
2.26.2

