Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA652963C3
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 19:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900087AbgJVR34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 13:29:56 -0400
Received: from correo.us.es ([193.147.175.20]:54138 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900130AbgJVR3i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 13:29:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9576E1C4384
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 19:29:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85771DA84A
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 19:29:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7B142DA704; Thu, 22 Oct 2020 19:29:37 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FA2ADA730;
        Thu, 22 Oct 2020 19:29:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 22 Oct 2020 19:29:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 01A8C42EE38E;
        Thu, 22 Oct 2020 19:29:34 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 4/7] netfilter: ebtables: Fixes dropping of small packets in bridge nat
Date:   Thu, 22 Oct 2020 19:29:22 +0200
Message-Id: <20201022172925.22770-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201022172925.22770-1-pablo@netfilter.org>
References: <20201022172925.22770-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Timothée COCAULT <timothee.cocault@orange.com>

Fixes an error causing small packets to get dropped. skb_ensure_writable
expects the second parameter to be a length in the ethernet payload.=20
If we want to write the ethernet header (src, dst), we should pass 0.
Otherwise, packets with small payloads (< ETH_ALEN) will get dropped.

Fixes: c1a831167901 ("netfilter: bridge: convert skb_make_writable to skb_ensure_writable")
Signed-off-by: Timothée COCAULT <timothee.cocault@orange.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebt_dnat.c     | 2 +-
 net/bridge/netfilter/ebt_redirect.c | 2 +-
 net/bridge/netfilter/ebt_snat.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 12a4f4d93681..3fda71a8579d 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -21,7 +21,7 @@ ebt_dnat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct ebt_nat_info *info = par->targinfo;
 
-	if (skb_ensure_writable(skb, ETH_ALEN))
+	if (skb_ensure_writable(skb, 0))
 		return EBT_DROP;
 
 	ether_addr_copy(eth_hdr(skb)->h_dest, info->mac);
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 0cad62a4052b..307790562b49 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -21,7 +21,7 @@ ebt_redirect_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct ebt_redirect_info *info = par->targinfo;
 
-	if (skb_ensure_writable(skb, ETH_ALEN))
+	if (skb_ensure_writable(skb, 0))
 		return EBT_DROP;
 
 	if (xt_hooknum(par) != NF_BR_BROUTING)
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 27443bf229a3..7dfbcdfc30e5 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -22,7 +22,7 @@ ebt_snat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct ebt_nat_info *info = par->targinfo;
 
-	if (skb_ensure_writable(skb, ETH_ALEN * 2))
+	if (skb_ensure_writable(skb, 0))
 		return EBT_DROP;
 
 	ether_addr_copy(eth_hdr(skb)->h_source, info->mac);
-- 
2.20.1

