Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57AE360E20A
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiJZNXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbiJZNWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:22:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4AC7A4DF2B;
        Wed, 26 Oct 2022 06:22:46 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 02/10] netfilter: nf_tables: reduce nft_pktinfo by 8 bytes
Date:   Wed, 26 Oct 2022 15:22:19 +0200
Message-Id: <20221026132227.3287-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221026132227.3287-1-pablo@netfilter.org>
References: <20221026132227.3287-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

structure is reduced from 32 to 24 bytes.  While at it, also check
that iphdrlen is sane, this is guaranteed for NFPROTO_IPV4 but not
for ingress or bridge, so add checks for this.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      | 4 ++--
 include/net/netfilter/nf_tables_ipv4.h | 4 ++++
 include/net/netfilter/nf_tables_ipv6.h | 6 +++---
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index cdb7db9b0e25..f6db510689a8 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -32,8 +32,8 @@ struct nft_pktinfo {
 	u8				flags;
 	u8				tprot;
 	u16				fragoff;
-	unsigned int			thoff;
-	unsigned int			inneroff;
+	u16				thoff;
+	u16				inneroff;
 };
 
 static inline struct sock *nft_sk(const struct nft_pktinfo *pkt)
diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index c4a6147b0ef8..112708f7a6b4 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -35,6 +35,8 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 		return -1;
 	else if (len < thoff)
 		return -1;
+	else if (thoff < sizeof(*iph))
+		return -1;
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = iph->protocol;
@@ -69,6 +71,8 @@ static inline int nft_set_pktinfo_ipv4_ingress(struct nft_pktinfo *pkt)
 		return -1;
 	} else if (len < thoff) {
 		goto inhdr_error;
+	} else if (thoff < sizeof(*iph)) {
+		return -1;
 	}
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index ec7eaeaf4f04..467d59b9e533 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -13,7 +13,7 @@ static inline void nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt)
 	unsigned short frag_off;
 
 	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, &flags);
-	if (protohdr < 0) {
+	if (protohdr < 0 || thoff > U16_MAX) {
 		nft_set_pktinfo_unspec(pkt);
 		return;
 	}
@@ -47,7 +47,7 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 		return -1;
 
 	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, &flags);
-	if (protohdr < 0)
+	if (protohdr < 0 || thoff > U16_MAX)
 		return -1;
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
@@ -93,7 +93,7 @@ static inline int nft_set_pktinfo_ipv6_ingress(struct nft_pktinfo *pkt)
 	}
 
 	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, &flags);
-	if (protohdr < 0)
+	if (protohdr < 0 || thoff > U16_MAX)
 		goto inhdr_error;
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
-- 
2.30.2

