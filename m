Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236CF52C8D0
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 02:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiESAnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 20:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbiESAnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 20:43:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D80166696
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 17:43:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B68EC617C7
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 00:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DEFC385A9;
        Thu, 19 May 2022 00:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652920989;
        bh=BkOqniSPPohJWv1t7N4Mz2ZTMuMqUZmZsdj8DsbuXC8=;
        h=From:To:Cc:Subject:Date:From;
        b=Eu6bsgwcmkgp/Eef1GeVHzBTScwy7QmgzvSuOXfulFffYoBcQ4SPDIjOTlr3rmRZB
         EnAGyUSPYpoT4fNXVb236tOp8Vyvz5gkOpglXVNvWv30qdRHOStf0ycJRQrBw7vm6S
         XNDsF0qUh2fAurAxlhv/2r1S+HoRau5s9QTYmUe0AioJJUJXQFNBAkZ+NMuleEE/E/
         JWWgFdv82TxJzYntHu0o4klVDSeX25Svi+O2VhoCeq7ivWu4yLKcpPIeMQu4ikbgSA
         c08zbUAlKTIkOpSAOAfnD5fpcDZPuN4J9uRx9Lxy3tIkUwmsONwA9PMaWe4KXgZqGu
         nHS13N266YJaQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Subject: [PATCH net] net: stmmac: fix out-of-bounds access in a selftest
Date:   Wed, 18 May 2022 17:43:05 -0700
Message-Id: <20220519004305.2109708-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC 12 points out that struct tc_action is smaller than
struct tcf_action:

drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c: In function ‘stmmac_test_rxp’:
drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:1132:21: warning: array subscript ‘struct tcf_gact[0]’ is partly outside array bounds of ‘unsigned char[272]’ [-Warray-bounds]
 1132 |                 gact->tcf_action = TC_ACT_SHOT;
      |                     ^~

Fixes: ccfc639a94f2 ("net: stmmac: selftests: Add a selftest for Flexible RX Parser")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: peppe.cavallaro@st.com
CC: alexandre.torgue@foss.st.com
CC: joabreu@synopsys.com
CC: mcoquelin.stm32@gmail.com
---
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c  | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 9f1759593b94..2fc51dc5eb0b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1084,8 +1084,9 @@ static int stmmac_test_rxp(struct stmmac_priv *priv)
 	unsigned char addr[ETH_ALEN] = {0xde, 0xad, 0xbe, 0xef, 0x00, 0x00};
 	struct tc_cls_u32_offload cls_u32 = { };
 	struct stmmac_packet_attrs attr = { };
-	struct tc_action **actions, *act;
+	struct tc_action **actions;
 	struct tc_u32_sel *sel;
+	struct tcf_gact *gact;
 	struct tcf_exts *exts;
 	int ret, i, nk = 1;
 
@@ -1110,8 +1111,8 @@ static int stmmac_test_rxp(struct stmmac_priv *priv)
 		goto cleanup_exts;
 	}
 
-	act = kcalloc(nk, sizeof(*act), GFP_KERNEL);
-	if (!act) {
+	gact = kcalloc(nk, sizeof(*gact), GFP_KERNEL);
+	if (!gact) {
 		ret = -ENOMEM;
 		goto cleanup_actions;
 	}
@@ -1126,9 +1127,7 @@ static int stmmac_test_rxp(struct stmmac_priv *priv)
 	exts->nr_actions = nk;
 	exts->actions = actions;
 	for (i = 0; i < nk; i++) {
-		struct tcf_gact *gact = to_gact(&act[i]);
-
-		actions[i] = &act[i];
+		actions[i] = (struct tc_action *)&gact[i];
 		gact->tcf_action = TC_ACT_SHOT;
 	}
 
@@ -1152,7 +1151,7 @@ static int stmmac_test_rxp(struct stmmac_priv *priv)
 	stmmac_tc_setup_cls_u32(priv, priv, &cls_u32);
 
 cleanup_act:
-	kfree(act);
+	kfree(gact);
 cleanup_actions:
 	kfree(actions);
 cleanup_exts:
-- 
2.34.3

