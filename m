Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF86A4BA4BB
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 16:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242667AbiBQPol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 10:44:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242677AbiBQPog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 10:44:36 -0500
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B9C2B1025;
        Thu, 17 Feb 2022 07:44:21 -0800 (PST)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4Jzzdp0n13z9sSQ;
        Thu, 17 Feb 2022 16:44:14 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YORT1PJT__e6; Thu, 17 Feb 2022 16:44:14 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4Jzzdn72n8z9sQx;
        Thu, 17 Feb 2022 16:44:13 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id D9A6A8B77C;
        Thu, 17 Feb 2022 16:44:13 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id EOIxpR6cf71e; Thu, 17 Feb 2022 16:44:13 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.6.239])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id A8D7D8B763;
        Thu, 17 Feb 2022 16:44:13 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 21HFi4WD603563
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 16:44:04 +0100
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 21HFi2uT603562;
        Thu, 17 Feb 2022 16:44:02 +0100
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH net-next v1] net: Use csum_replace_... and csum_sub() helpers instead of opencoding
Date:   Thu, 17 Feb 2022 16:43:55 +0100
Message-Id: <fe60030b6f674d9bf41f56426a4b0a8a9db0d20f.1645112415.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1645112634; l=1582; s=20211009; h=from:subject:message-id; bh=qDaGxyd/pqGG9s1E0j72Fi43hJ/XYgHZbSIbmrxq7S0=; b=aKRMITAt6QN7aUpMRIAs5kbGVOO1OkfwH/B12QUYMkgfwVp4huQwNbORsqVKepw3y6j8zXnWa9a9 9pHC23uNA0ruYXBUcQZ/+bEpYn3OqXO9TCCKlDT2+/gN74V6ylxF
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a couple places, open coded calculation can be avoided
and replaced by the equivalent csum_replace4() and
csum_replace_by_diff().

There's also one place where csum_sub() should be used instead of
csum_add().

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 net/core/utils.c            | 4 ++--
 net/netfilter/nft_payload.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/utils.c b/net/core/utils.c
index 1f31a39236d5..938495bc1d34 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -476,9 +476,9 @@ void inet_proto_csum_replace_by_diff(__sum16 *sum, struct sk_buff *skb,
 				     __wsum diff, bool pseudohdr)
 {
 	if (skb->ip_summed != CHECKSUM_PARTIAL) {
-		*sum = csum_fold(csum_add(diff, ~csum_unfold(*sum)));
+		csum_replace_by_diff(sum, diff);
 		if (skb->ip_summed == CHECKSUM_COMPLETE && pseudohdr)
-			skb->csum = ~csum_add(diff, ~skb->csum);
+			skb->csum = ~csum_sub(diff, skb->csum);
 	} else if (pseudohdr) {
 		*sum = ~csum_fold(csum_add(diff, csum_unfold(*sum)));
 	}
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 5cc06aef4345..b6cfd0759bc5 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -557,7 +557,7 @@ const struct nft_expr_ops nft_payload_fast_ops = {
 
 static inline void nft_csum_replace(__sum16 *sum, __wsum fsum, __wsum tsum)
 {
-	*sum = csum_fold(csum_add(csum_sub(~csum_unfold(*sum), fsum), tsum));
+	csum_replace4(sum, fsum, tsum);
 	if (*sum == 0)
 		*sum = CSUM_MANGLED_0;
 }
-- 
2.34.1

