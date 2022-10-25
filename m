Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399D260D418
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 20:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiJYSvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 14:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbiJYSvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 14:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58436D2580
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 11:51:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5F4561AEF
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 18:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF737C433D7;
        Tue, 25 Oct 2022 18:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666723888;
        bh=VoCQJaWSkJxjjJRmFFZiVdP+oYzF9wSjJxCsK9dVUE8=;
        h=From:To:Cc:Subject:Date:From;
        b=CzVac96YJuad70rFtgTudyCBExBKSsooYCQ32Xu/yt7t5mK9UvsPlZxAqTvxd4vy/
         DSD1DVbPdWbKg1shtxBHlp6yJg0cgJnaDEpz4efG1lb5T9dX/ji2y4Bg/5Rd7tu8DF
         pSKCrWmcuCR4nrxxxexsrAmiFhgFDjXR+eTS2VsNx4wxqfejcAYj54itzxCFERYQAk
         n9zAxDjpSAqwvvXrt5ouaQ3TniuehN9HDMXcPRxTxtcEzlToess4EbdZv4KOLeqIpA
         AbHogMC8EnMep5i7aB4a1jKLpfPCdyDszxecgawr6mpM1sJAbpN5+6Up0ViTlaUZCU
         sttfWMOJIM5Sw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, sean.anderson@seco.com,
        rmk+kernel@armlinux.org.uk
Subject: [PATCH net-next] phylink: require valid state argument to phylink_validate_mask_caps()
Date:   Tue, 25 Oct 2022 11:51:26 -0700
Message-Id: <20221025185126.1720553-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

state is deferenced earlier in the function, the NULL check
is pointless. Since we don't have any crash reports presumably
it's safe to assume state is not NULL.

Fixes: f392a1846489 ("net: phylink: provide phylink_validate_mask_caps() helper")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: linux@armlinux.org.uk
CC: andrew@lunn.ch
CC: hkallweit1@gmail.com
CC: sean.anderson@seco.com
CC: rmk+kernel@armlinux.org.uk
---
 drivers/net/phy/phylink.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 62106c9e9a9d..88f60e98b760 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -564,7 +564,7 @@ EXPORT_SYMBOL_GPL(phylink_get_capabilities);
 /**
  * phylink_validate_mask_caps() - Restrict link modes based on caps
  * @supported: ethtool bitmask for supported link modes.
- * @state: an (optional) pointer to a &struct phylink_link_state.
+ * @state: pointer to a &struct phylink_link_state.
  * @mac_capabilities: bitmask of MAC capabilities
  *
  * Calculate the supported link modes based on @mac_capabilities, and restrict
@@ -585,8 +585,7 @@ void phylink_validate_mask_caps(unsigned long *supported,
 	phylink_caps_to_linkmodes(mask, caps);
 
 	linkmode_and(supported, supported, mask);
-	if (state)
-		linkmode_and(state->advertising, state->advertising, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 }
 EXPORT_SYMBOL_GPL(phylink_validate_mask_caps);
 
-- 
2.37.3

