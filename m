Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A965D4B218D
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241634AbiBKJUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:20:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348573AbiBKJUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:20:13 -0500
X-Greylist: delayed 1895 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 11 Feb 2022 01:20:11 PST
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C4D1034
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 01:20:10 -0800 (PST)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4Jw6hx4vY8z9sSM;
        Fri, 11 Feb 2022 09:48:33 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id klDIzGqmxZ6I; Fri, 11 Feb 2022 09:48:33 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4Jw6hx4Bhzz9sSL;
        Fri, 11 Feb 2022 09:48:33 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 7ED5A8B77D;
        Fri, 11 Feb 2022 09:48:33 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id rtRKHQ_BcwTx; Fri, 11 Feb 2022 09:48:33 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.6.91])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 36EBB8B764;
        Fri, 11 Feb 2022 09:48:33 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 21B8mNGc936763
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 09:48:23 +0100
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 21B8mMRd936762;
        Fri, 11 Feb 2022 09:48:22 +0100
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH] net: Remove branch in csum_shift()
Date:   Fri, 11 Feb 2022 09:48:16 +0100
Message-Id: <efeeb0b9979b0377cd313311ad29cf0ac060ae4b.1644569106.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1644569294; l=1792; s=20211009; h=from:subject:message-id; bh=bn4qVlTEECkFmk/D3ReBpu/1ueTQNT/DDGPwdR54bMw=; b=YfWOLv3f7QPdV7JOLEvppeShwBCfk+aGgbZur22GW+m9WX6XeuSeUHvizGFhnuzg3csBcc4Zfcbu MOrUk6ZGDv8PKhpkllz2TJosNNk2sqMNIrrXLeIPI0EXjv6RY/gs
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Today's implementation of csum_shift() leads to branching based on
parity of 'offset'

	000002f8 <csum_block_add>:
	     2f8:	70 a5 00 01 	andi.   r5,r5,1
	     2fc:	41 a2 00 08 	beq     304 <csum_block_add+0xc>
	     300:	54 84 c0 3e 	rotlwi  r4,r4,24
	     304:	7c 63 20 14 	addc    r3,r3,r4
	     308:	7c 63 01 94 	addze   r3,r3
	     30c:	4e 80 00 20 	blr

Use first bit of 'offset' directly as input of the rotation instead of
branching.

	000002f8 <csum_block_add>:
	     2f8:	54 a5 1f 38 	rlwinm  r5,r5,3,28,28
	     2fc:	20 a5 00 20 	subfic  r5,r5,32
	     300:	5c 84 28 3e 	rotlw   r4,r4,r5
	     304:	7c 63 20 14 	addc    r3,r3,r4
	     308:	7c 63 01 94 	addze   r3,r3
	     30c:	4e 80 00 20 	blr

And change to left shift instead of right shift to skip one more
instruction. This has no impact on the final sum.

	000002f8 <csum_block_add>:
	     2f8:	54 a5 1f 38 	rlwinm  r5,r5,3,28,28
	     2fc:	5c 84 28 3e 	rotlw   r4,r4,r5
	     300:	7c 63 20 14 	addc    r3,r3,r4
	     304:	7c 63 01 94 	addze   r3,r3
	     308:	4e 80 00 20 	blr

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 include/net/checksum.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/net/checksum.h b/include/net/checksum.h
index 5218041e5c8f..9badcd5532ef 100644
--- a/include/net/checksum.h
+++ b/include/net/checksum.h
@@ -83,9 +83,7 @@ static inline __sum16 csum16_sub(__sum16 csum, __be16 addend)
 static inline __wsum csum_shift(__wsum sum, int offset)
 {
 	/* rotate sum to align it with a 16b boundary */
-	if (offset & 1)
-		return (__force __wsum)ror32((__force u32)sum, 8);
-	return sum;
+	return (__force __wsum)rol32((__force u32)sum, (offset & 1) << 3);
 }
 
 static inline __wsum
-- 
2.34.1

