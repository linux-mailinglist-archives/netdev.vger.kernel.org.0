Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD0C4EB1A7
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 14:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbfJaNxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 09:53:11 -0400
Received: from mailout3.hostsharing.net ([176.9.242.54]:60621 "EHLO
        mailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727719AbfJaNxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 09:53:11 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id D84C1101E6B11;
        Thu, 31 Oct 2019 14:44:26 +0100 (CET)
Received: from localhost (pd95be530.dip0.t-ipconnect.de [217.91.229.48])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 75857613C8DC;
        Thu, 31 Oct 2019 14:44:26 +0100 (CET)
X-Mailbox-Line: From ba3cc38580d4cb43aa5599524ec5e5205d6dfa77 Mon Sep 17 00:00:00 2001
Message-Id: <ba3cc38580d4cb43aa5599524ec5e5205d6dfa77.1572528496.git.lukas@wunner.de>
In-Reply-To: <cover.1572528496.git.lukas@wunner.de>
References: <cover.1572528496.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 31 Oct 2019 14:41:01 +0100
Subject: [PATCH nf-next,RFC 1/5] netfilter: Clean up unnecessary #ifdef
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Daniel Borkmann <daniel@iogearbox.net>
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
 net/core/dev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 74f593986524..e555a8656c47 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5013,7 +5013,6 @@ static bool skb_pfmemalloc_protocol(struct sk_buff *skb)
 static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
 			     int *ret, struct net_device *orig_dev)
 {
-#ifdef CONFIG_NETFILTER_INGRESS
 	if (nf_hook_ingress_active(skb)) {
 		int ingress_retval;
 
@@ -5027,7 +5026,6 @@ static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
 		rcu_read_unlock();
 		return ingress_retval;
 	}
-#endif /* CONFIG_NETFILTER_INGRESS */
 	return 0;
 }
 
-- 
2.23.0

