Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1EFC4BB3DB
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbiBRIEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:04:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbiBRIEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:04:33 -0500
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2352B3193;
        Fri, 18 Feb 2022 00:04:14 -0800 (PST)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4K0PNY208qz9sSk;
        Fri, 18 Feb 2022 09:04:13 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Fq9FW965M6c2; Fri, 18 Feb 2022 09:04:13 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4K0PNQ4NP6z9sSW;
        Fri, 18 Feb 2022 09:04:06 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 87A728B77E;
        Fri, 18 Feb 2022 09:04:06 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id YVOvsXPQXqcg; Fri, 18 Feb 2022 09:04:06 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.6.249])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5E2DF8B76C;
        Fri, 18 Feb 2022 09:04:06 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 21I83vcf629117
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 09:03:57 +0100
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 21I83uNR629115;
        Fri, 18 Feb 2022 09:03:56 +0100
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v2] net: core: Use csum_replace_by_diff() and csum_sub() instead of opencoding
Date:   Fri, 18 Feb 2022 09:03:48 +0100
Message-Id: <491e9d549dd6b5d1b50e4540536f4fa4ce4e968f.1645171288.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1645171426; l=1013; s=20211009; h=from:subject:message-id; bh=x636t5s1uODfJH8cUj5743LAzap6ceTOL8W8qpPRzlU=; b=mHsVpTfRV993Nrf91cioIx45fRCmGKf9uP2YnCi9LNYl9sCF5WfkF5XXXsdwyHrQvbhBkzbDpY3J WMh5CQZcAhNh1OP2+6pmtKcfcnrxAi6O4litj+tuygxPvTBX2kQ1
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

Open coded calculation can be avoided and replaced by the
equivalent csum_replace_by_diff() and csum_sub().

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
v2: Dropped the change in nft_csum_replace() as it would
require nasty casts.
---
 net/core/utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
-- 
2.34.1

