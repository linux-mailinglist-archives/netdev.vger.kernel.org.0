Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF52313CF
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfEaR0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:26:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfEaR0v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 13:26:51 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3A8B930BC58D;
        Fri, 31 May 2019 17:26:51 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75A0A101E661;
        Fri, 31 May 2019 17:26:49 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     shuali@redhat.com, Eli Britstein <elibr@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net v3 3/3] net/sched: act_skbedit: fix 'inheritdsfield' in case of QinQ packet
Date:   Fri, 31 May 2019 19:26:09 +0200
Message-Id: <7b081d3ece27a867a213d2d61dcfcac5e9bb59ad.1559322531.git.dcaratti@redhat.com>
In-Reply-To: <cover.1559322531.git.dcaratti@redhat.com>
References: <cover.1559322531.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 31 May 2019 17:26:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

like it was previously done on TC 'csum' (see commit 2ecba2d1e45b ("net:
sched: act_csum: Fix csum calc for tagged packets")), TC 'skbedit' might
need to adjust the network offset, if the packet has unstripped/multiple
tags: otherwise 'inheritdsfield' will just be skipped for QinQ packets.

Fixes: e7e3728bd776 ("net:sched: add action inheritdsfield to skbedit")
CC: Li Shuang <shuali@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_skbedit.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 7ec159b95364..34a0c661c8c5 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -39,6 +39,7 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 {
 	struct tcf_skbedit *d = to_skbedit(a);
 	struct tcf_skbedit_params *params;
+	unsigned int vlan_hdr_count = 0;
 	int action;
 
 	tcf_lastuse_update(&d->tcf_tm);
@@ -50,9 +51,17 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 	if (params->flags & SKBEDIT_F_PRIORITY)
 		skb->priority = params->priority;
 	if (params->flags & SKBEDIT_F_INHERITDSFIELD) {
-		int wlen = skb_network_offset(skb);
-
-		switch (tc_skb_protocol(skb)) {
+		__be16 proto = tc_skb_protocol(skb);
+		int wlen;
+
+again:
+		wlen = skb_network_offset(skb);
+		switch (proto) {
+		case htons(ETH_P_8021AD): /* Fall Through */
+		case htons(ETH_P_8021Q):
+			if (tc_skb_pull_vlans(skb, &vlan_hdr_count, &proto))
+				goto err;
+			goto again;
 		case htons(ETH_P_IP):
 			wlen += sizeof(struct iphdr);
 			if (!pskb_may_pull(skb, wlen))
@@ -77,11 +86,18 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 	}
 	if (params->flags & SKBEDIT_F_PTYPE)
 		skb->pkt_type = params->ptype;
+
+out:
+	while (vlan_hdr_count--) {
+		skb_push(skb, VLAN_HLEN);
+		skb_reset_network_header(skb);
+	}
 	return action;
 
 err:
 	qstats_drop_inc(this_cpu_ptr(d->common.cpu_qstats));
-	return TC_ACT_SHOT;
+	action = TC_ACT_SHOT;
+	goto out;
 }
 
 static const struct nla_policy skbedit_policy[TCA_SKBEDIT_MAX + 1] = {
-- 
2.20.1

