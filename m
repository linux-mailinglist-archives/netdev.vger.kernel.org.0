Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B98A224B03
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 13:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgGRLq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 07:46:27 -0400
Received: from mail-proxy25223.qiye.163.com ([103.129.252.23]:42148 "EHLO
        mail-proxy25223.qiye.163.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726493AbgGRLq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 07:46:27 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id CC8B641733;
        Sat, 18 Jul 2020 19:34:33 +0800 (CST)
From:   wenxu@ucloud.cn
To:     fw@strlen.de, xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] net/sched: act_ct: fix restore the qdisc_skb_cb after defrag
Date:   Sat, 18 Jul 2020 19:34:33 +0800
Message-Id: <1595072073-6268-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSRlPTEodSUgfTU8YVkpOQk5LTElLTEhDQ0lVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mz46CCo4Vj5CET8ZNB4aDDYq
        ITwwCyhVSlVKTkJOS0xJS0xIQkxCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlISk43Bg++
X-HM-Tid: 0a7361b450782086kuqycc8b641733
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

This patch resend followup with
"http://patchwork.ozlabs.org/project/netdev/cover/1594097711-9365-1-git-send-email-wenxu@ucloud.cn/"

 net/sched/act_ct.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 67504ae..e675e2d 100644
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
@@ -1014,6 +1017,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 
 out:
 	tcf_action_update_bstats(&c->common, skb);
+	qdisc_skb_cb(skb)->pkt_len = skb->len;
 	return retval;
 
 drop:
-- 
1.8.3.1

