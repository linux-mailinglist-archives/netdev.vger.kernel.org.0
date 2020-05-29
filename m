Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BDD1E7473
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgE2ESt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:18:49 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:45169 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgE2ESs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 00:18:48 -0400
X-Greylist: delayed 659 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 May 2020 00:18:47 EDT
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 093115C1E27;
        Fri, 29 May 2020 12:07:46 +0800 (CST)
From:   wenxu@ucloud.cn
To:     paulb@mellanox.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH] net/sched: act_ct: add nat mangle action only for NAT-conntrack
Date:   Fri, 29 May 2020 12:07:45 +0800
Message-Id: <1590725265-17136-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ01LS0tLSkhITkpPT1lXWShZQU
        lCN1dZLVlBSVdZDwkaFQgSH1lBWR0iNQs4HDkzMxMeKBIPOR4DQ0sPOhxWVlVJTUwoSVlXWQkOFx
        4IWUFZNTQpNjo3JCkuNz5ZV1kWGg8SFR0UWUFZNDBZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nkk6KSo5Ojg0Mzg8DQEdOS4W
        OChPCTRVSlVKTkJLTElOSU1NSkNKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlPSE03Bg++
X-HM-Tid: 0a725e9d4a882087kuqy093115c1e27
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Currently add nat mangle action with comparing invert and ori tuple.
It is better to check IPS_NAT_MASK flags first to avoid non necessary
memcmp for non-NAT conntrack.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/act_ct.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index c50a86a..d621152 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -198,18 +198,21 @@ static int tcf_ct_flow_table_add_action_nat(struct net *net,
 					    struct flow_action *action)
 {
 	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
+	bool nat = ct->status & IPS_NAT_MASK;
 	struct nf_conntrack_tuple target;
 
 	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
 
 	switch (tuple->src.l3num) {
 	case NFPROTO_IPV4:
-		tcf_ct_flow_table_add_action_nat_ipv4(tuple, target,
-						      action);
+		if (nat)
+			tcf_ct_flow_table_add_action_nat_ipv4(tuple, target,
+							      action);
 		break;
 	case NFPROTO_IPV6:
-		tcf_ct_flow_table_add_action_nat_ipv6(tuple, target,
-						      action);
+		if (nat)
+			tcf_ct_flow_table_add_action_nat_ipv6(tuple, target,
+							      action);
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -217,10 +220,14 @@ static int tcf_ct_flow_table_add_action_nat(struct net *net,
 
 	switch (nf_ct_protonum(ct)) {
 	case IPPROTO_TCP:
-		tcf_ct_flow_table_add_action_nat_tcp(tuple, target, action);
+		if (nat)
+			tcf_ct_flow_table_add_action_nat_tcp(tuple, target,
+							     action);
 		break;
 	case IPPROTO_UDP:
-		tcf_ct_flow_table_add_action_nat_udp(tuple, target, action);
+		if (nat)
+			tcf_ct_flow_table_add_action_nat_udp(tuple, target,
+							     action);
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
1.8.3.1

