Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F8B230943
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 13:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgG1L6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 07:58:15 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36502 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729257AbgG1L6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 07:58:14 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with SMTP; 28 Jul 2020 14:58:10 +0300
Received: from dev-r-vrt-138.mtr.labs.mlnx (dev-r-vrt-138.mtr.labs.mlnx [10.212.138.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06SBw9Qt028102;
        Tue, 28 Jul 2020 14:58:10 +0300
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net 2/2] net/sched: act_ct: Set offload timeout when setting the offload bit
Date:   Tue, 28 Jul 2020 14:57:59 +0300
Message-Id: <20200728115759.426667-3-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20200728115759.426667-1-roid@mellanox.com>
References: <20200728115759.426667-1-roid@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On heavily loaded systems the GC can take time to go over all existing
conns and reset their timeout. At that time other calls like from
nf_conntrack_in() can call of nf_ct_is_expired() and see the conn as
expired. To fix this when we set the offload bit we should also reset
the timeout instead of counting on GC to finish first iteration over
all conns before the initial timeout.

Fixes: 64ff70b80fd4 ("net/sched: act_ct: Offload established connections to flow table")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
---
 net/sched/act_ct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index e9f3576cbf71..650c2d78a346 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -366,6 +366,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 	if (err)
 		goto err_add;
 
+	nf_ct_offload_timeout(ct);
+
 	return;
 
 err_add:
-- 
2.8.4

