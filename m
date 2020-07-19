Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067DD2251DE
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 14:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgGSMdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 08:33:09 -0400
Received: from mail-proxy25223.qiye.163.com ([103.129.252.23]:32906 "EHLO
        mail-proxy25223.qiye.163.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725836AbgGSMdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 08:33:08 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 77D6F4185D;
        Sun, 19 Jul 2020 20:30:37 +0800 (CST)
From:   wenxu@ucloud.cn
To:     fw@strlen.de, xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net v3] net/sched: act_ct: fix restore the qdisc_skb_cb after defrag
Date:   Sun, 19 Jul 2020 20:30:37 +0800
Message-Id: <1595161837-25502-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZHkpCHUodQkxDTEtNVkpOQk5KTUpDSExOTU5VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mz46MBw6CD5DFT41FyMQUUss
        PBxPFCpVSlVKTkJOSk1KQ0hMTUNDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhOQkg3Bg++
X-HM-Tid: 0a73670dffbe2086kuqy77d6f4185d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The fragment packets do defrag in tcf_ct_handle_fragments
will clear the skb->cb which make the qdisc_skb_cb clear
too. So the qdsic_skb_cb should be store before defrag and
restore after that.
It also update the pkt_len after all the
fragments finish the defrag to one packet and make the
following actions counter correct.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: update qdisc_skb_cb(skb)->pkt_len only for reassembled skbs
v3: fix uninit defrag data

 net/sched/act_ct.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 67504ae..5928efb 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -673,9 +673,10 @@ static int tcf_ct_ipv6_is_fragment(struct sk_buff *skb, bool *frag)
 }
 
 static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
-				   u8 family, u16 zone)
+				   u8 family, u16 zone, bool *defrag)
 {
 	enum ip_conntrack_info ctinfo;
+	struct qdisc_skb_cb cb;
 	struct nf_conn *ct;
 	int err = 0;
 	bool frag;
@@ -693,6 +694,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 		return err;
 
 	skb_get(skb);
+	cb = *qdisc_skb_cb(skb);
 
 	if (family == NFPROTO_IPV4) {
 		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
@@ -703,6 +705,9 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 		local_bh_enable();
 		if (err && err != -EINPROGRESS)
 			goto out_free;
+
+		if (!err)
+			*defrag = true;
 	} else { /* NFPROTO_IPV6 */
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
@@ -711,12 +716,16 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 		err = nf_ct_frag6_gather(net, skb, user);
 		if (err && err != -EINPROGRESS)
 			goto out_free;
+
+		if (!err)
+			*defrag = true;
 #else
 		err = -EOPNOTSUPP;
 		goto out_free;
 #endif
 	}
 
+	*qdisc_skb_cb(skb) = cb;
 	skb_clear_hash(skb);
 	skb->ignore_df = 1;
 	return err;
@@ -914,6 +923,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	int nh_ofs, err, retval;
 	struct tcf_ct_params *p;
 	bool skip_add = false;
+	bool defrag = false;
 	struct nf_conn *ct;
 	u8 family;
 
@@ -946,7 +956,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	 */
 	nh_ofs = skb_network_offset(skb);
 	skb_pull_rcsum(skb, nh_ofs);
-	err = tcf_ct_handle_fragments(net, skb, family, p->zone);
+	err = tcf_ct_handle_fragments(net, skb, family, p->zone, &defrag);
 	if (err == -EINPROGRESS) {
 		retval = TC_ACT_STOLEN;
 		goto out;
@@ -1014,6 +1024,8 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 
 out:
 	tcf_action_update_bstats(&c->common, skb);
+	if (defrag)
+		qdisc_skb_cb(skb)->pkt_len = skb->len;
 	return retval;
 
 drop:
-- 
1.8.3.1

