Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43E9214D1D
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 16:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgGEO2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 10:28:48 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:54055 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgGEO2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 10:28:47 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 8EE75410AB;
        Sun,  5 Jul 2020 22:28:35 +0800 (CST)
From:   wenxu@ucloud.cn
To:     davem@davemloft.net, pablo@netfilter.org
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH net-next 3/3] net/sched: act_ct: fix clobber qdisc_skb_cb in defrag
Date:   Sun,  5 Jul 2020 22:28:32 +0800
Message-Id: <1593959312-6135-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593959312-6135-1-git-send-email-wenxu@ucloud.cn>
References: <1593959312-6135-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSU9CS0tLSkJKTUNDTk9ZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXIjULOBw5SCsrGi9PDD0dTQ4zMjocVlZVQk9ITShJWVdZCQ
        4XHghZQVk1NCk2OjckKS43PllXWRYaDxIVHRRZQVk0MFkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PDI6Hxw5Dj5CFk0QETgdLTRI
        KRkaCjFVSlVKTkJIQk5CSEpOTU1OVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlPQ0k3Bg++
X-HM-Tid: 0a731f60f88f2086kuqy8ee75410ab
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

using nf_ct_frag_gather to defrag in act_ct to elide CB clear.
Avoid serious crashes and problems in ct subsystem. Because Some packet
schedulers store pointers in the qdisc CB private area and Parallel
accesses to the SKB.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/act_ct.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 20f3d11..75562f4 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -31,6 +31,7 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_acct.h>
+#include <net/netfilter/ipv4/nf_defrag_ipv4.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <uapi/linux/netfilter/nf_nat.h>
 
@@ -695,14 +696,18 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 	skb_get(skb);
 
 	if (family == NFPROTO_IPV4) {
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
 		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
 
-		memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
 		local_bh_disable();
-		err = ip_defrag(net, skb, user);
+		err = nf_ct_frag_gather(net, skb, user, NULL);
 		local_bh_enable();
 		if (err && err != -EINPROGRESS)
 			goto out_free;
+#else
+		err = -EOPNOTSUPP;
+		goto out_free;
+#endif
 	} else { /* NFPROTO_IPV6 */
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
-- 
1.8.3.1

