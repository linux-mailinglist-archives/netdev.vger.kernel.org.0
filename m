Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633E54B2308
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 11:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241413AbiBKKZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 05:25:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiBKKZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 05:25:06 -0500
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B198BE5A;
        Fri, 11 Feb 2022 02:25:05 -0800 (PST)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4Jw8rJ0vXkz9sSQ;
        Fri, 11 Feb 2022 11:25:04 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xBMWOrU8Izvi; Fri, 11 Feb 2022 11:25:04 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4Jw8rJ07xLz9sSL;
        Fri, 11 Feb 2022 11:25:04 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id E78998B780;
        Fri, 11 Feb 2022 11:25:03 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 1ZAD8N-JTl7t; Fri, 11 Feb 2022 11:25:03 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.6.91])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id A3A568B77D;
        Fri, 11 Feb 2022 11:25:03 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 21BAOtqD946512
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 11:24:55 +0100
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 21BAOtsG946511;
        Fri, 11 Feb 2022 11:24:55 +0100
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH 2/2] powerpc/32: Implement csum_sub
Date:   Fri, 11 Feb 2022 11:24:49 +0100
Message-Id: <c2a3f87d97f0903fdef3bbcb84661f75619301bf.1644574987.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <0c8eaab8f0685d2a70d125cf876238c70afd4fb6.1644574987.git.christophe.leroy@csgroup.eu>
References: <0c8eaab8f0685d2a70d125cf876238c70afd4fb6.1644574987.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1644575088; l=1588; s=20211009; h=from:subject:message-id; bh=pXcr+Jwxdt7vu5J4mP6ZswUtbWBzwIEJ1PdZV31QSE0=; b=HSZVvXJkPmCF8TxbXSiWKLDoI7psAxRjgWG87bMYX2pCsi30PB7LXU1q5qLFV51bzViRqYFS/GZw ZhVN0EtRBTO0QIYTyu3aBjMk6XMUkzaYl4DbtnndhKhdeIBqjSD8
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

When building kernel with CONFIG_CC_OPTIMISE_FOR_SIZE, several
copies of csum_sub() are generated, with the following code:

	00000170 <csum_sub>:
	     170:	7c 84 20 f8 	not     r4,r4
	     174:	7c 63 20 14 	addc    r3,r3,r4
	     178:	7c 63 01 94 	addze   r3,r3
	     17c:	4e 80 00 20 	blr

Let's define a PPC32 version with subc/addme, and for it's inlining.

It will return 0 instead of 0xffffffff when subtracting 0x80000000 to itself,
this is not an issue as 0 and ~0 are equivalent, refer to RFC 1624.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/include/asm/checksum.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/powerpc/include/asm/checksum.h b/arch/powerpc/include/asm/checksum.h
index 350de8f90250..3288a1bf5e8d 100644
--- a/arch/powerpc/include/asm/checksum.h
+++ b/arch/powerpc/include/asm/checksum.h
@@ -112,6 +112,22 @@ static __always_inline __wsum csum_add(__wsum csum, __wsum addend)
 #endif
 }
 
+#ifdef CONFIG_PPC32
+#define HAVE_ARCH_CSUM_SUB
+static __always_inline __wsum csum_sub(__wsum csum, __wsum addend)
+{
+	if (__builtin_constant_p(csum) && (csum == 0 || csum == ~0))
+		return ~addend;
+	if (__builtin_constant_p(addend) && (addend == 0 || addend == ~0))
+		return csum;
+
+	asm("subc %0,%0,%1;"
+	    "addme %0,%0;"
+	    : "+r" (csum) : "r" (addend) : "xer");
+	return csum;
+}
+#endif
+
 /*
  * This is a version of ip_compute_csum() optimized for IP headers,
  * which always checksum on 4 octet boundaries.  ihl is the number
-- 
2.34.1

