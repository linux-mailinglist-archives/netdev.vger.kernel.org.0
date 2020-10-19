Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A5D292438
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 11:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgJSJC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 05:02:56 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:32820 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729757AbgJSJC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 05:02:56 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@nvidia.com)
        with SMTP; 19 Oct 2020 12:02:53 +0300
Received: from dev-r-vrt-138.mtr.labs.mlnx (dev-r-vrt-138.mtr.labs.mlnx [10.212.138.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 09J92qOd024867;
        Mon, 19 Oct 2020 12:02:52 +0300
From:   Roi Dayan <roid@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paul Blakey <paulb@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net] net/sched: act_ct: Fix adding udp port mangle operation
Date:   Mon, 19 Oct 2020 12:02:44 +0300
Message-Id: <20201019090244.3015186-1-roid@nvidia.com>
X-Mailer: git-send-email 2.8.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Need to use the udp header type and not tcp.

Fixes: 9c26ba9b1f45 ("net/sched: act_ct: Instantiate flow table entry actions")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 net/sched/act_ct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index a780afdf570d..0bac241a4123 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -156,11 +156,11 @@ tcf_ct_flow_table_add_action_nat_udp(const struct nf_conntrack_tuple *tuple,
 	__be16 target_dst = target.dst.u.udp.port;
 
 	if (target_src != tuple->src.u.udp.port)
-		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_TCP,
+		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_UDP,
 					 offsetof(struct udphdr, source),
 					 0xFFFF, be16_to_cpu(target_src));
 	if (target_dst != tuple->dst.u.udp.port)
-		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_TCP,
+		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_UDP,
 					 offsetof(struct udphdr, dest),
 					 0xFFFF, be16_to_cpu(target_dst));
 }
-- 
2.8.4

