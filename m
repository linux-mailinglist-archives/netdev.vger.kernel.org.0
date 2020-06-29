Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555E320D1C0
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgF2Snk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:43:40 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:18467 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgF2Sni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:43:38 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 744BB4165A;
        Mon, 29 Jun 2020 17:16:18 +0800 (CST)
From:   wenxu@ucloud.cn
To:     paulb@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 1/2] net/sched: act_ct: fix restore the qdisc_skb_cb after defrag
Date:   Mon, 29 Jun 2020 17:16:17 +0800
Message-Id: <1593422178-26949-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ0lCQkJCQklITEtNSllXWShZQU
        lCN1dZLVlBSVdZDwkaFQgSH1lBWRciNQs4HDhISCQfEggdFx4CDR4IOhxWVlVKKElZV1kJDhceCF
        lBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ni46NQw4GTg3Ny0xDEgKFSJC
        MksaFDBVSlVKTkJIT0lJSkxCSUJDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlOSkM3Bg++
X-HM-Tid: 0a72ff5ce8cd2086kuqy744bb4165a
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The fragment packets do defrag in tcf_ct_handle_fragments
will clear the skb->cb which make the qdisc_skb_cb clear
too and set the pkt_len to 0. The bytes always 0 when dump
the filter. And it also update the pkt_len after all the
fragments finish the defrag to one packet and make the
following action counter correct.

filter protocol ip pref 2 flower chain 0 handle 0x2
  eth_type ipv4
  dst_ip 1.1.1.1
  ip_flags frag/firstfrag
  skip_hw
  not_in_hw
 action order 1: ct zone 1 nat pipe
  index 2 ref 1 bind 1 installed 11 sec used 11 sec
 Action statistics:
 Sent 0 bytes 11 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
 cookie e04106c2ac41769b278edaa9b5309960

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/act_ct.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index e9f3576..2eaabdc 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -676,6 +676,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 				   u8 family, u16 zone)
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
@@ -717,6 +719,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 #endif
 	}
 
+	*qdisc_skb_cb(skb) = cb;
 	skb_clear_hash(skb);
 	skb->ignore_df = 1;
 	return err;
@@ -1012,6 +1015,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 
 out:
 	tcf_action_update_bstats(&c->common, skb);
+	qdisc_skb_cb(skb)->pkt_len = skb->len;
 	return retval;
 
 drop:
-- 
1.8.3.1

