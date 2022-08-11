Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9CFC5903DC
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238386AbiHKQ15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238132AbiHKQ0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:26:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9AB9F752;
        Thu, 11 Aug 2022 09:08:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19F6461422;
        Thu, 11 Aug 2022 16:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22665C43142;
        Thu, 11 Aug 2022 16:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234084;
        bh=EWa3bwI+V1YrVciEjnomw0UKhr33J/rWdkBvFxADRlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxUEQNF4gpjsej6BV5By0babKMI23NkNV0ocd5gKVrnFOOnkw4L40nvgTXx9wL60X
         6csMJ6cz/X5pAJfKHEY0GfTuB6JWKO0IHOh+HCBR+l4K5ssWk0/ai3ZUzITjdAwA6a
         Z92JrwdFNH8Ea5fLF6/cIof5Kh1ma7JdeNyXE1THr3e/KKJOlX5HQBqTVbKooISOQn
         EOOLhx0CLJ+I2hmTjgrNsNyw9bS1B+a2Jg6MoVqjsAlvFDcU+dcPvA2GtmkYJvNZix
         01ZiGZFYLVp4wmOet1SljGwLU+XvuF5WpU9Xncv2k/tJO78QR8+pqzaYn6TgfslXfZ
         CL1hv7C6sSjyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 41/46] net: ethernet: stmicro: stmmac: first disable all queues and disconnect in release
Date:   Thu, 11 Aug 2022 12:04:05 -0400
Message-Id: <20220811160421.1539956-41-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit 7028471edb646bfc532fec0973e50e784cdcb7c6 ]

Disable all queues and disconnect before tx_disable in stmmac_release to
prevent a corner case where packet may be still queued at the same time
tx_disable is called resulting in kernel panic if some packet still has
to be processed.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 27b7bb64a028..46c2db220542 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3001,6 +3001,8 @@ static int stmmac_release(struct net_device *dev)
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
 		del_timer_sync(&priv->tx_queue[chan].txtimer);
 
+	netif_tx_disable(dev);
+
 	/* Free the IRQ lines */
 	free_irq(dev->irq, dev);
 	if (priv->wol_irq != dev->irq)
-- 
2.35.1

