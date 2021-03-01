Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0FF328346
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 17:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbhCAQO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 11:14:58 -0500
Received: from outbound-smtp50.blacknight.com ([46.22.136.234]:33065 "EHLO
        outbound-smtp50.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237664AbhCAQND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 11:13:03 -0500
Received: from mail.blacknight.com (pemlinmail02.blacknight.ie [81.17.254.11])
        by outbound-smtp50.blacknight.com (Postfix) with ESMTPS id 69F1DFA8FF
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 16:12:01 +0000 (GMT)
Received: (qmail 30423 invoked from network); 1 Mar 2021 16:12:01 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 1 Mar 2021 16:12:01 -0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 0/5] Introduce a bulk order-0 page allocator with two in-tree users
Date:   Mon,  1 Mar 2021 16:11:55 +0000
Message-Id: <20210301161200.18852-1-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces a bulk order-0 page allocator with sunrpc and
the network page pool being the first users. The implementation is not
particularly efficient and the intention is to iron out what the semantics
of the API should have for users. Once the semantics are ironed out, it can
be made more efficient.

Improving the implementation requires fairly deep surgery in numerous
places. The lock scope would need to be significantly reduced, particularly
as vmstat, per-cpu and the buddy allocator have different locking protocol
that overall -- e.g. all partially depend on irqs being disabled at
various points. Secondly, the core of the allocator deals with single
pages where as both the bulk allocator and per-cpu allocator operate in
batches. All of that has to be reconciled with all the existing users and
their constraints (memory offline, CMA and cpusets being the trickiest).

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

 include/linux/gfp.h   |  13 +++++
 mm/page_alloc.c       | 113 +++++++++++++++++++++++++++++++++++++++++-
 net/core/page_pool.c  | 102 +++++++++++++++++++++++---------------
 net/sunrpc/svc_xprt.c |  47 ++++++++++++------
 4 files changed, 220 insertions(+), 55 deletions(-)

-- 
2.26.2

