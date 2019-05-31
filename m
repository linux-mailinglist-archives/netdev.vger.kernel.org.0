Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07D05313CB
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfEaR0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:26:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8011 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbfEaR0g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 13:26:36 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E746830C31A5;
        Fri, 31 May 2019 17:26:35 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06CA6101E660;
        Fri, 31 May 2019 17:26:33 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     shuali@redhat.com, Eli Britstein <elibr@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net v3 1/3] net/sched: act_csum: pull all VLAN headers before checksumming
Date:   Fri, 31 May 2019 19:26:07 +0200
Message-Id: <a773fd1d70707d03861be674f7692a0148f6bb40.1559322531.git.dcaratti@redhat.com>
In-Reply-To: <cover.1559322531.git.dcaratti@redhat.com>
References: <cover.1559322531.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 31 May 2019 17:26:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TC 'csum' action needs to read the packets' ethertype. In case the value
is encoded in unstripped/nested VLAN headers, call pskb_may_pull() to be
sure that all tags are in the linear part of skb. While at it, move this
code in a helper function: other TC actions (like 'pedit' and 'skbedit')
might need to read the innermost ethertype.

Fixes: 2ecba2d1e45b ("net: sched: act_csum: Fix csum calc for tagged packets")
CC: Eli Britstein <elibr@mellanox.com>
CC: Li Shuang <shuali@redhat.com>
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/net/pkt_cls.h |  2 ++
 net/sched/act_csum.c  | 14 ++------------
 net/sched/cls_api.c   | 22 ++++++++++++++++++++++
 3 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 514e3c80ecc1..344f51eee1a8 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -953,4 +953,6 @@ struct tc_root_qopt_offload {
 	bool ingress;
 };
 
+int tc_skb_pull_vlans(struct sk_buff *skb, unsigned int *hdr_count,
+		      __be16 *proto);
 #endif
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 14bb525e355e..e8308ddcae9d 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -574,7 +574,6 @@ static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
 			struct tcf_result *res)
 {
 	struct tcf_csum *p = to_tcf_csum(a);
-	bool orig_vlan_tag_present = false;
 	unsigned int vlan_hdr_count = 0;
 	struct tcf_csum_params *params;
 	u32 update_flags;
@@ -604,17 +603,8 @@ static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
 		break;
 	case cpu_to_be16(ETH_P_8021AD): /* fall through */
 	case cpu_to_be16(ETH_P_8021Q):
-		if (skb_vlan_tag_present(skb) && !orig_vlan_tag_present) {
-			protocol = skb->protocol;
-			orig_vlan_tag_present = true;
-		} else {
-			struct vlan_hdr *vlan = (struct vlan_hdr *)skb->data;
-
-			protocol = vlan->h_vlan_encapsulated_proto;
-			skb_pull(skb, VLAN_HLEN);
-			skb_reset_network_header(skb);
-			vlan_hdr_count++;
-		}
+		if (tc_skb_pull_vlans(skb, &vlan_hdr_count, &protocol))
+			goto drop;
 		goto again;
 	}
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d4699156974a..382ee69fb1a5 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3300,6 +3300,28 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
 }
 EXPORT_SYMBOL(tcf_exts_num_actions);
 
+int tc_skb_pull_vlans(struct sk_buff *skb, unsigned int *hdr_count,
+		      __be16 *proto)
+{
+	if (skb_vlan_tag_present(skb))
+		*proto = skb->protocol;
+
+	while (eth_type_vlan(*proto)) {
+		struct vlan_hdr *vlan;
+
+		if (unlikely(!pskb_may_pull(skb, VLAN_HLEN)))
+			return -ENOMEM;
+
+		vlan = (struct vlan_hdr *)skb->data;
+		*proto = vlan->h_vlan_encapsulated_proto;
+		skb_pull(skb, VLAN_HLEN);
+		skb_reset_network_header(skb);
+		(*hdr_count)++;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(tc_skb_pull_vlans);
+
 static __net_init int tcf_net_init(struct net *net)
 {
 	struct tcf_net *tn = net_generic(net, tcf_net_id);
-- 
2.20.1

