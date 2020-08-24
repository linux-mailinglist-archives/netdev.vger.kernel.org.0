Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9992724FCC1
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 13:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgHXLkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 07:40:08 -0400
Received: from correo.us.es ([193.147.175.20]:41834 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgHXLj4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 07:39:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 03D0481A34
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 13:39:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C248DA72F
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 13:39:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E09A9DA73F; Mon, 24 Aug 2020 13:39:50 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3B5BE1511;
        Mon, 24 Aug 2020 13:39:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 24 Aug 2020 13:39:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 2649C42EE38E;
        Mon, 24 Aug 2020 13:39:49 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 6/6] netfilter: nf_tables: fix destination register zeroing
Date:   Mon, 24 Aug 2020 13:39:41 +0200
Message-Id: <20200824113941.25423-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200824113941.25423-1-pablo@netfilter.org>
References: <20200824113941.25423-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Following bug was reported via irc:
nft list ruleset
   set knock_candidates_ipv4 {
      type ipv4_addr . inet_service
      size 65535
      elements = { 127.0.0.1 . 123,
                   127.0.0.1 . 123 }
      }
 ..
   udp dport 123 add @knock_candidates_ipv4 { ip saddr . 123 }
   udp dport 123 add @knock_candidates_ipv4 { ip saddr . udp dport }

It should not have been possible to add a duplicate set entry.

After some debugging it turned out that the problem is the immediate
value (123) in the second-to-last rule.

Concatenations use 32bit registers, i.e. the elements are 8 bytes each,
not 6 and it turns out the kernel inserted

inet firewall @knock_candidates_ipv4
        element 0100007f ffff7b00  : 0 [end]
        element 0100007f 00007b00  : 0 [end]

Note the non-zero upper bits of the first element.  It turns out that
nft_immediate doesn't zero the destination register, but this is needed
when the length isn't a multiple of 4.

Furthermore, the zeroing in nft_payload is broken.  We can't use
[len / 4] = 0 -- if len is a multiple of 4, index is off by one.

Skip zeroing in this case and use a conditional instead of (len -1) / 4.

Fixes: 49499c3e6e18 ("netfilter: nf_tables: switch registers to 32 bit addressing")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 2 ++
 net/netfilter/nft_payload.c       | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index bf9491b77d16..224d194ad29d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -143,6 +143,8 @@ static inline u64 nft_reg_load64(const u32 *sreg)
 static inline void nft_data_copy(u32 *dst, const struct nft_data *src,
 				 unsigned int len)
 {
+	if (len % NFT_REG32_SIZE)
+		dst[len / NFT_REG32_SIZE] = 0;
 	memcpy(dst, src, len);
 }
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index ed7cb9f747f6..7a2e59638499 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -87,7 +87,9 @@ void nft_payload_eval(const struct nft_expr *expr,
 	u32 *dest = &regs->data[priv->dreg];
 	int offset;
 
-	dest[priv->len / NFT_REG32_SIZE] = 0;
+	if (priv->len % NFT_REG32_SIZE)
+		dest[priv->len / NFT_REG32_SIZE] = 0;
+
 	switch (priv->base) {
 	case NFT_PAYLOAD_LL_HEADER:
 		if (!skb_mac_header_was_set(skb))
-- 
2.20.1

