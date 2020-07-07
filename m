Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8FD2165A4
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 06:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgGGEzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 00:55:16 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:7556 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbgGGEzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 00:55:15 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 3509541AED;
        Tue,  7 Jul 2020 12:55:13 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: [PATCH net-next v2 3/3] net/sched: act_ct: fix clobber qdisc_skb_cb in defrag
Date:   Tue,  7 Jul 2020 12:55:11 +0800
Message-Id: <1594097711-9365-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594097711-9365-1-git-send-email-wenxu@ucloud.cn>
References: <1594097711-9365-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlNS0tLSkNCTENKSkJZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkdIjULOBw6SBUDGAM6OikdOjABLzocVlZVSklPSShJWVdZCQ
        4XHghZQVk1NCk2OjckKS43PllXWRYaDxIVHRRZQVk0MFkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NRA6MQw6TD4BFk0vNCJRAgo1
        NElPCRdVSlVKTkJPS0JMTEpISUxCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpDQkw3Bg++
X-HM-Tid: 0a7327a0c04c2086kuqy3509541aed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

using ip_defrag_ignore_cb to defrag in act_ct to elide CB clear.
Avoid serious crashes and problems in ct subsystem. Because Some packet
schedulers store pointers in the qdisc CB private area and Parallel
accesses to the SKB.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/act_ct.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 20f3d11..a8e9e62 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -697,10 +697,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 	if (family == NFPROTO_IPV4) {
 		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
 
-		memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
-		local_bh_disable();
-		err = ip_defrag(net, skb, user);
-		local_bh_enable();
+		err = ip_defrag_ignore_cb(net, skb, user, NULL);
 		if (err && err != -EINPROGRESS)
 			goto out_free;
 	} else { /* NFPROTO_IPV6 */
-- 
1.8.3.1

