Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7EF6E3837
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 14:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjDPMmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 08:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjDPMmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 08:42:40 -0400
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB951739;
        Sun, 16 Apr 2023 05:42:38 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id B4EEA4542C;
        Sun, 16 Apr 2023 12:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1681648956; bh=yD2+V/6602TyeACtf+m7TBnMWq/Sw60NZXOpbCGsSqg=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc;
        b=AiCTa6wc4QW9XlF0ho5bUUiy9lL3GXpG1qxIXq/FxqT1NtkfplOJSRLQuGmVgKrl7
         jNgW+FKGh8lH11fOHwes8piDE3z68CPPCHPq0tocRTivc8GwA86pc1KJcRM2k6RogH
         9mmBDkxu8KQiHa6zWcPAs0QIps57nmyhAwd+KBhDcxBA9diTIuzPm06FHtItC1g1yE
         tZwdRFAIY15sPZgWCTubhFaz8ikm387jr6JQKIKIE/uFKjvswfpLPGqtL/iK1e50mT
         DziFt+w0PJOAQZ3e82AZw3UnbcWv6/21rYWHrvAp6PIpXep5lprbEeafI22HyZ83ja
         Xz9MFIiB6bmcg==
From:   Hector Martin <marcan@marcan.st>
Date:   Sun, 16 Apr 2023 21:42:18 +0900
Subject: [PATCH 2/2] wifi: brcmfmac: Demote p2p unknown frame error to info
 (once)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230416-brcmfmac-noise-v1-2-f0624e408761@marcan.st>
References: <20230416-brcmfmac-noise-v1-0-f0624e408761@marcan.st>
In-Reply-To: <20230416-brcmfmac-noise-v1-0-f0624e408761@marcan.st>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
        Hector Martin <marcan@marcan.st>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1085; i=marcan@marcan.st;
 h=from:subject:message-id; bh=yD2+V/6602TyeACtf+m7TBnMWq/Sw60NZXOpbCGsSqg=;
 b=owGbwMvMwCEm+yP4NEe/cRLjabUkhhTrt3oMF5/Lbl/yODR8+vXl531+/t5d7/g5VZPhyNIPt
 gy73RxvdJSyMIhxMMiKKbI0nug91e05/Zy6asp0mDmsTGBDuDgFYCJCrxgZ9p3hq1z6a/npbXMn
 iF/7dea1YVC4jq9i69EFiaEz+dr+zWH4X/GjeYXylFMPNvwMeBu/4PaW4JtvNfovPVA42BGV8+X
 XYnYA
X-Developer-Key: i=marcan@marcan.st; a=openpgp;
 fpr=FC18F00317968B7BE86201CBE22A629A4C515DD5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This one is also spooking people when they see it in their boot console.
It's not fatal, so it shouldn't really be a noisy error.

Fixes: 18e2f61db3b7 ("brcmfmac: P2P action frame tx.")
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index d4492d02e4ea..071b0706d137 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -1793,8 +1793,8 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 		/* do not configure anything. it will be */
 		/* sent with a default configuration     */
 	} else {
-		bphy_err(drvr, "Unknown Frame: category 0x%x, action 0x%x\n",
-			 category, action);
+		bphy_info_once(drvr, "Unknown Frame: category 0x%x, action 0x%x\n",
+			       category, action);
 		return false;
 	}
 

-- 
2.40.0

