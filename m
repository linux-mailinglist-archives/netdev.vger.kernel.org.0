Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B3432062
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 20:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfFASY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 14:24:28 -0400
Received: from mail.us.es ([193.147.175.20]:40024 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbfFASYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 14:24:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0F9A5FEFB2
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1ED1DA729
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1FB37DA71F; Sat,  1 Jun 2019 20:23:59 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D4E6FF15E;
        Sat,  1 Jun 2019 20:23:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 20:23:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.178.197])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2B3F44265A31;
        Sat,  1 Jun 2019 20:23:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 12/15] netfilter: xt_HL: prefer skb_ensure_writable
Date:   Sat,  1 Jun 2019 20:23:37 +0200
Message-Id: <20190601182340.2662-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601182340.2662-1-pablo@netfilter.org>
References: <20190601182340.2662-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Also, make the argument to be only the needed size of the header
we're altering, no need to pull in the full packet into linear area.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_HL.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_HL.c
index 4653b071bed4..a37b8824221f 100644
--- a/net/netfilter/xt_HL.c
+++ b/net/netfilter/xt_HL.c
@@ -32,7 +32,7 @@ ttl_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct ipt_TTL_info *info = par->targinfo;
 	int new_ttl;
 
-	if (!skb_make_writable(skb, skb->len))
+	if (skb_ensure_writable(skb, sizeof(*iph)))
 		return NF_DROP;
 
 	iph = ip_hdr(skb);
@@ -72,7 +72,7 @@ hl_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct ip6t_HL_info *info = par->targinfo;
 	int new_hl;
 
-	if (!skb_make_writable(skb, skb->len))
+	if (skb_ensure_writable(skb, sizeof(*ip6h)))
 		return NF_DROP;
 
 	ip6h = ipv6_hdr(skb);
-- 
2.11.0

