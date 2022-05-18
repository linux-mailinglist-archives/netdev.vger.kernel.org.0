Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C7E52BA79
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbiERMfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237220AbiERMeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:34:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F183C19CB79;
        Wed, 18 May 2022 05:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A260361666;
        Wed, 18 May 2022 12:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A56BC385A5;
        Wed, 18 May 2022 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652877012;
        bh=U3MCaPU4KcqqPQx9TyAhzv+aeX5+rNSIakb60lLPjGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCFfTjqNZ55el+4Q29UCl86uNw3uXPVFWY+0bMYe0SDMhZQeAt/JrwMnWxNKQME83
         aTPtw7gykRdLnetsLGbmfEA9Et4Nc/xuXsgTWA7XhvWTE3wD1IrkIx2azLMb8kYFfr
         IXvvP8u/jH1JVpOz5LnOxaZrf3Pg6tKpjFY0/OIo4vvKVSlbouhFXCvV+Pt+mNQSch
         0yciW5AugL9lAXnPzXpoiw/AaAMttMK0u3ruqZMZgvl5ninejuWT8QMaZwWbzUcX17
         gLq6amQc38ET/BmBNhhMexp//CSA4qd3QlFVPhg0SCDncrEMy31BAPAFJl2nIpeudx
         qrmlPhGkv0cag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 4/5] net: stmmac: fix missing pci_disable_device() on error in stmmac_pci_probe()
Date:   Wed, 18 May 2022 08:29:59 -0400
Message-Id: <20220518123000.343787-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518123000.343787-1-sashal@kernel.org>
References: <20220518123000.343787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0807ce0b010418a191e0e4009803b2d74c3245d5 ]

Switch to using pcim_enable_device() to avoid missing pci_disable_device().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220510031316.1780409-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index cc1e887e47b5..3dec109251ad 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -261,7 +261,7 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 
 	/* Enable pci device */
-	ret = pci_enable_device(pdev);
+	ret = pcim_enable_device(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "%s: ERROR: failed to enable device\n",
 			__func__);
@@ -313,8 +313,6 @@ static void stmmac_pci_remove(struct pci_dev *pdev)
 		pcim_iounmap_regions(pdev, BIT(i));
 		break;
 	}
-
-	pci_disable_device(pdev);
 }
 
 static int __maybe_unused stmmac_pci_suspend(struct device *dev)
-- 
2.35.1

