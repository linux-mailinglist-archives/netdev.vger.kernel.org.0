Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B246E1038CC
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 12:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbfKTLfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 06:35:36 -0500
Received: from mailout3.hostsharing.net ([176.9.242.54]:34703 "EHLO
        mailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727586AbfKTLfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 06:35:36 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id 8A9A6101E6ABA;
        Wed, 20 Nov 2019 12:35:34 +0100 (CET)
Received: from localhost (pd95be530.dip0.t-ipconnect.de [217.91.229.48])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 2B95460E00CD;
        Wed, 20 Nov 2019 12:35:34 +0100 (CET)
X-Mailbox-Line: From 4362209712369ea47ac39b06a9fc93fc4ce3a25c Mon Sep 17 00:00:00 2001
Message-Id: <4362209712369ea47ac39b06a9fc93fc4ce3a25c.1574247376.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Wed, 20 Nov 2019 12:33:59 +0100
Subject: [PATCH nf-next] netfilter: Clean up unnecessary #ifdef
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_NETFILTER_INGRESS is not enabled, nf_ingress() becomes a no-op
because it solely contains an if-clause calling nf_hook_ingress_active(),
for which an empty inline stub exists in <linux/netfilter_ingress.h>.

All the symbols used in the if-clause's body are still available even if
CONFIG_NETFILTER_INGRESS is not enabled.

The additional "#ifdef CONFIG_NETFILTER_INGRESS" in nf_ingress() is thus
unnecessary, so drop it.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
---
Resending this patch without RFC tag on Pablo's request since it's just
an uncontroversial cleanup.

Previous submission:
https://lore.kernel.org/netfilter-devel/ba3cc38580d4cb43aa5599524ec5e5205d6dfa77.1572528496.git.lukas@wunner.de/

 net/core/dev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index da78a433c10c..330c6d21cc1c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4932,7 +4932,6 @@ static bool skb_pfmemalloc_protocol(struct sk_buff *skb)
 static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
 			     int *ret, struct net_device *orig_dev)
 {
-#ifdef CONFIG_NETFILTER_INGRESS
 	if (nf_hook_ingress_active(skb)) {
 		int ingress_retval;
 
@@ -4946,7 +4945,6 @@ static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
 		rcu_read_unlock();
 		return ingress_retval;
 	}
-#endif /* CONFIG_NETFILTER_INGRESS */
 	return 0;
 }
 
-- 
2.24.0

