Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDABC233D6E
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 04:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731194AbgGaCpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 22:45:05 -0400
Received: from mail-proxy25223.qiye.163.com ([103.129.252.23]:11600 "EHLO
        mail-proxy25223.qiye.163.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731124AbgGaCpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 22:45:04 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E5DD241A45;
        Fri, 31 Jul 2020 10:45:01 +0800 (CST)
From:   wenxu@ucloud.cn
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net v2] net/sched: act_ct: fix miss set mru for ovs after defrag in act_ct
Date:   Fri, 31 Jul 2020 10:45:01 +0800
Message-Id: <1596163501-7113-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZQkIZT0oeSENKHkpDVkpOQk1KTUhOS0pCQklVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Oj46ARw4Cj5OLzciHSNKCgEZ
        ECtPChxVSlVKTkJNSk1ITktJSUhNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9JS0I3Bg++
X-HM-Tid: 0a73a2c22f802086kuqye5dd241a45
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

When openvswitch conntrack offload with act_ct action. Fragment packets
defrag in the ingress tc act_ct action and miss the next chain. Then the
packet pass to the openvswitch datapath without the mru. The over
mtu packet will be dropped in output action in openvswitch for over mtu.

"kernel: net2: dropped over-mtu packet: 1528 > 1500"

This patch add mru in the tc_skb_ext for adefrag and miss next chain
situation. And also add mru in the qdisc_skb_cb. The act_ct set the mru
to the qdisc_skb_cb when the packet defrag. And When the chain miss,
The mru is set to tc_skb_ext which can be got by ovs datapath.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/linux/skbuff.h    | 1 +
 include/net/sch_generic.h | 3 ++-
 net/openvswitch/flow.c    | 1 +
 net/sched/act_ct.c        | 8 ++++++--
 net/sched/cls_api.c       | 1 +
 5 files changed, 11 insertions(+), 3 deletions(-)

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
index c510b03..d60e7c3 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -384,6 +384,7 @@ struct qdisc_skb_cb {
 	};
 #define QDISC_CB_PRIV_LEN 20
 	unsigned char		data[QDISC_CB_PRIV_LEN];
+	u16			mru;
 };
 
 typedef void tcf_chain_head_change_t(struct tcf_proto *tp_head, void *priv);
@@ -463,7 +464,7 @@ static inline void qdisc_cb_private_validate(const struct sk_buff *skb, int sz)
 {
 	struct qdisc_skb_cb *qcb;
 
-	BUILD_BUG_ON(sizeof(skb->cb) < offsetof(struct qdisc_skb_cb, data) + sz);
+	BUILD_BUG_ON(sizeof(skb->cb) < sizeof(*qcb));
 	BUILD_BUG_ON(sizeof(qcb->data) < sz);
 }
 
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
index 4619cb3..eb6acc5 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1627,6 +1627,7 @@ int tcf_classify_ingress(struct sk_buff *skb,
 		if (WARN_ON_ONCE(!ext))
 			return TC_ACT_SHOT;
 		ext->chain = last_executed_chain;
+		ext->mru = qdisc_skb_cb(skb)->mru;
 	}
 
 	return ret;
-- 
1.8.3.1

