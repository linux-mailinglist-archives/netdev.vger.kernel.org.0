Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DE2227667
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 05:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgGUDJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 23:09:54 -0400
Received: from mail-proxy25223.qiye.163.com ([103.129.252.23]:28893 "EHLO
        mail-proxy25223.qiye.163.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726068AbgGUDJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 23:09:54 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id D275F41CB2
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 11:09:52 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Subject: [PATCH net] openvswitch: fix drop over mtu packet after defrag in act_ct
Date:   Tue, 21 Jul 2020 11:09:52 +0800
Message-Id: <1595300992-18381-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSk9NTxhDQxlMSUhMVkpOQk5IS0tCQklCSE1VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NTo6Nxw4Qj5PPz0RLFFJHyIL
        SwkwCgtVSlVKTkJOSEtLQkJIS05DVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhOT0w3Bg++
X-HM-Tid: 0a736f5957612086kuqyd275f41cb2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

When openvswitch conntrack offload with act_ct action. Fragment packets
defrag in the ingress tc act_ct action and miss the next chain. Then the
packet pass to the openvswitch datapath without the mru. The defrag over
mtu packet will be dropped in output of openvswitch for over mtu.

"kernel: net2: dropped over-mtu packet: 1508 > 1500"

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/linux/skbuff.h    | 1 +
 include/net/sch_generic.h | 1 +
 net/openvswitch/flow.c    | 1 +
 net/sched/act_ct.c        | 8 ++++++--
 net/sched/cls_api.c       | 1 +
 5 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0c0377f..0d842d6 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -283,6 +283,7 @@ struct nf_bridge_info {
  */
 struct tc_skb_ext {
 	__u32 chain;
+	__u16 mru;
 };
 #endif
 
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index c510b03..45401d5 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -384,6 +384,7 @@ struct qdisc_skb_cb {
 	};
 #define QDISC_CB_PRIV_LEN 20
 	unsigned char		data[QDISC_CB_PRIV_LEN];
+	u16			mru;
 };
 
 typedef void tcf_chain_head_change_t(struct tcf_proto *tp_head, void *priv);
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 9d375e7..03942c3 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -890,6 +890,7 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 	if (static_branch_unlikely(&tc_recirc_sharing_support)) {
 		tc_ext = skb_ext_find(skb, TC_SKB_EXT);
 		key->recirc_id = tc_ext ? tc_ext->chain : 0;
+		OVS_CB(skb)->mru = tc_ext ? tc_ext->mru : 0;
 	} else {
 		key->recirc_id = 0;
 	}
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 5928efb..69445ab 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -706,8 +706,10 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 		if (err && err != -EINPROGRESS)
 			goto out_free;
 
-		if (!err)
+		if (!err) {
 			*defrag = true;
+			cb.mru = IPCB(skb)->frag_max_size;
+		}
 	} else { /* NFPROTO_IPV6 */
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
@@ -717,8 +719,10 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 		if (err && err != -EINPROGRESS)
 			goto out_free;
 
-		if (!err)
+		if (!err) {
 			*defrag = true;
+			cb.mru = IP6CB(skb)->frag_max_size;
+		}
 #else
 		err = -EOPNOTSUPP;
 		goto out_free;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index e62beec..a4d9eaa 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1628,6 +1628,7 @@ int tcf_classify_ingress(struct sk_buff *skb,
 		if (WARN_ON_ONCE(!ext))
 			return TC_ACT_SHOT;
 		ext->chain = last_executed_chain;
+		ext->mru = qdisc_skb_cb(skb)->mru;
 	}
 
 	return ret;
-- 
1.8.3.1

