Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B268A4B2303
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 11:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348886AbiBKKZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 05:25:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348880AbiBKKZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 05:25:09 -0500
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA93E47;
        Fri, 11 Feb 2022 02:25:09 -0800 (PST)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4Jw8rK15wZz9sSL;
        Fri, 11 Feb 2022 11:25:05 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RVC_5M6K9gs6; Fri, 11 Feb 2022 11:25:05 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4Jw8rJ088Lz9sSM;
        Fri, 11 Feb 2022 11:25:04 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id E74F28B77E;
        Fri, 11 Feb 2022 11:25:03 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id avygUaqL76b8; Fri, 11 Feb 2022 11:25:03 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.6.91])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id A38D28B764;
        Fri, 11 Feb 2022 11:25:03 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 21BAOsOZ946508
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 11:24:54 +0100
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 21BAOq8A946507;
        Fri, 11 Feb 2022 11:24:52 +0100
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
Subject: [PATCH 1/2] net: Allow csum_sub() to be provided in arch
Date:   Fri, 11 Feb 2022 11:24:48 +0100
Message-Id: <0c8eaab8f0685d2a70d125cf876238c70afd4fb6.1644574987.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1644575088; l=989; s=20211009; h=from:subject:message-id; bh=RUCXz7rcwV3vtRjuwGPzOWG1MqwEYlRVJE5g+0Z10T0=; b=eADc4aCLdklo7HvFbLsm7mGATs8mPnBrP4sXzi8ylYEqFq0APBPHpYUY+C3ha30J+ZcvLukGCpHz n6af84NTDAWj2ByZb/YbwA6p1bUFrsK2r9w+YrLcIqegfq86tYCK
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

In the same spirit as commit 07064c6e022b ("net: Allow csum_add to be
provided in arch"), allow csum_sub() to be provided by arch.

The generic implementation of csum_sub() call csum_add() with the
complement of the addendum.

Some architectures can do it directly.

This will also avoid getting several copies of csum_sub() outlined
when building with -Os.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 include/net/checksum.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/checksum.h b/include/net/checksum.h
index 9badcd5532ef..735d98724145 100644
--- a/include/net/checksum.h
+++ b/include/net/checksum.h
@@ -62,10 +62,12 @@ static inline __wsum csum_add(__wsum csum, __wsum addend)
 }
 #endif
 
+#ifndef HAVE_ARCH_CSUM_SUB
 static inline __wsum csum_sub(__wsum csum, __wsum addend)
 {
 	return csum_add(csum, ~addend);
 }
+#endif
 
 static inline __sum16 csum16_add(__sum16 csum, __be16 addend)
 {
-- 
2.34.1

