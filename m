Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9469A2AFF4B
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgKLFco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:32:44 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:16360 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbgKLDeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 22:34:21 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 0B92A5C19DA;
        Thu, 12 Nov 2020 11:24:58 +0800 (CST)
From:   wenxu@ucloud.cn
To:     kuba@kernel.org, marcelo.leitner@gmail.com, vladbu@nvidia.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH v10 net-next 1/3] net/sched: fix miss init the mru in qdisc_skb_cb
Date:   Thu, 12 Nov 2020 11:24:55 +0800
Message-Id: <1605151497-29986-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605151497-29986-1-git-send-email-wenxu@ucloud.cn>
References: <1605151497-29986-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSkxPTB1NH01CSkxPVkpNS05KTkpPQkNLQkJVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OTI6NDo6Mj0zUT8aCzQvKgkX
        HDkwC0JVSlVKTUtOSk5KT0JDTkJDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpCSUw3Bg++
X-HM-Tid: 0a75ba7c1f602087kuqy0b92a5c19da
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The mru in the qdisc_skb_cb should be init as 0. Only defrag packets in the
act_ct will set the value.

Fixes: 038ebb1a713d ("net/sched: act_ct: fix miss set mru for ovs after defrag in act_ct")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v10: no change

 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 751e526..a40de66 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3865,6 +3865,7 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
 		return skb;
 
 	/* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
+	qdisc_skb_cb(skb)->mru = 0;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
 	switch (tcf_classify(skb, miniq->filter_list, &cl_res, false)) {
@@ -4950,6 +4951,7 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 	}
 
 	qdisc_skb_cb(skb)->pkt_len = skb->len;
+	qdisc_skb_cb(skb)->mru = 0;
 	skb->tc_at_ingress = 1;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
-- 
1.8.3.1

