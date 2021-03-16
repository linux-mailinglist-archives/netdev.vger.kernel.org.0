Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2DE33CFF0
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbhCPIeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:34:22 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:15435 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbhCPId6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:33:58 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id E5FBCE01836;
        Tue, 16 Mar 2021 16:33:54 +0800 (CST)
From:   wenxu@ucloud.cn
To:     kuba@kernel.org, mleitner@redhat.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, davem@davemloft.net
Subject: [PATCH net] net/sched: act_api: fix miss set post_ct for ovs after do conntrack in act_ct
Date:   Tue, 16 Mar 2021 16:33:54 +0800
Message-Id: <1615883634-11064-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSUsZHx1NQxpNGR1OVkpNSk5DQ0hNSE9CTE1VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PAg6MBw5Sj09AyMsKTMiFCsL
        GggKFC1VSlVKTUpOQ0NITUhOSk5CVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU5LSEw3Bg++
X-HM-Tid: 0a783a2b891c20bdkuqye5fbce01836
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

When openvswitch conntrack offload with act_ct action. The first rule
do conntrack in the act_ct in tc subsystem. And miss the next rule in
the tc and fallback to the ovs datapath but miss set post_ct flag
which will lead the ct_state_key with -trk flag.

Fixes: 7baf2429a1a9 ("net/sched: cls_flower add CT_FLAGS_INVALID flag support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/linux/skbuff.h      | 1 +
 net/openvswitch/conntrack.c | 8 +++++---
 net/openvswitch/conntrack.h | 6 ++++--
 net/openvswitch/flow.c      | 4 +++-
 net/sched/cls_api.c         | 1 +
 5 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6d0a33d..f2c9ee7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -285,6 +285,7 @@ struct nf_bridge_info {
 struct tc_skb_ext {
 	__u32 chain;
 	__u16 mru;
+	bool post_ct;
 };
 #endif
 
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 5eddfe7..71cec03 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -271,9 +271,11 @@ static void ovs_ct_update_key(const struct sk_buff *skb,
 /* This is called to initialize CT key fields possibly coming in from the local
  * stack.
  */
-void ovs_ct_fill_key(const struct sk_buff *skb, struct sw_flow_key *key)
+void ovs_ct_fill_key(const struct sk_buff *skb,
+		     struct sw_flow_key *key,
+		     bool post_ct)
 {
-	ovs_ct_update_key(skb, NULL, key, false, false);
+	ovs_ct_update_key(skb, NULL, key, post_ct, false);
 }
 
 int ovs_ct_put_key(const struct sw_flow_key *swkey,
@@ -1332,7 +1334,7 @@ int ovs_ct_clear(struct sk_buff *skb, struct sw_flow_key *key)
 	if (skb_nfct(skb)) {
 		nf_conntrack_put(skb_nfct(skb));
 		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
-		ovs_ct_fill_key(skb, key);
+		ovs_ct_fill_key(skb, key, false);
 	}
 
 	return 0;
diff --git a/net/openvswitch/conntrack.h b/net/openvswitch/conntrack.h
index 59dc327..317e525 100644
--- a/net/openvswitch/conntrack.h
+++ b/net/openvswitch/conntrack.h
@@ -25,7 +25,8 @@ int ovs_ct_execute(struct net *, struct sk_buff *, struct sw_flow_key *,
 		   const struct ovs_conntrack_info *);
 int ovs_ct_clear(struct sk_buff *skb, struct sw_flow_key *key);
 
-void ovs_ct_fill_key(const struct sk_buff *skb, struct sw_flow_key *key);
+void ovs_ct_fill_key(const struct sk_buff *skb, struct sw_flow_key *key,
+		     bool post_ct);
 int ovs_ct_put_key(const struct sw_flow_key *swkey,
 		   const struct sw_flow_key *output, struct sk_buff *skb);
 void ovs_ct_free_action(const struct nlattr *a);
@@ -74,7 +75,8 @@ static inline int ovs_ct_clear(struct sk_buff *skb,
 }
 
 static inline void ovs_ct_fill_key(const struct sk_buff *skb,
-				   struct sw_flow_key *key)
+				   struct sw_flow_key *key,
+				   bool post_ct)
 {
 	key->ct_state = 0;
 	key->ct_zone = 0;
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index c7f34d6..e586424 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -857,6 +857,7 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	struct tc_skb_ext *tc_ext;
 #endif
+	bool post_ct = false;
 	int res, err;
 
 	/* Extract metadata from packet. */
@@ -895,6 +896,7 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 		tc_ext = skb_ext_find(skb, TC_SKB_EXT);
 		key->recirc_id = tc_ext ? tc_ext->chain : 0;
 		OVS_CB(skb)->mru = tc_ext ? tc_ext->mru : 0;
+		post_ct = tc_ext ? tc_ext->post_ct : false;
 	} else {
 		key->recirc_id = 0;
 	}
@@ -904,7 +906,7 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 
 	err = key_extract(skb, key);
 	if (!err)
-		ovs_ct_fill_key(skb, key);   /* Must be after key_extract(). */
+		ovs_ct_fill_key(skb, key, post_ct);   /* Must be after key_extract(). */
 	return err;
 }
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index e37556cc..13341e7 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1629,6 +1629,7 @@ int tcf_classify_ingress(struct sk_buff *skb,
 			return TC_ACT_SHOT;
 		ext->chain = last_executed_chain;
 		ext->mru = qdisc_skb_cb(skb)->mru;
+		ext->post_ct = qdisc_skb_cb(skb)->post_ct;
 	}
 
 	return ret;
-- 
1.8.3.1

