Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0490F52BAAD
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237133AbiERMeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237132AbiERMeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:34:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BC01957A5;
        Wed, 18 May 2022 05:29:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99651B81FBE;
        Wed, 18 May 2022 12:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6250C36AE3;
        Wed, 18 May 2022 12:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876996;
        bh=U3MCaPU4KcqqPQx9TyAhzv+aeX5+rNSIakb60lLPjGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEgGsavpmFNllTJ6A+A7tcwVo7yC9fEykOE7ieN0uDPU/CdRY+pvkLwVQ6mdWU0pv
         gIjX3vLxq1280a9V478u7Z5H+I9ZLffmHALU3zIyB6E5bPVnQDv9j3dI9DcMX09lrz
         RkgGPYSCir78QgYesO3Dx99FKXUSk/+bYaA8LasIyZF7III/7vETbz4Os+viOu7B3g
         8NkJIG3Rx4OQraqmlA1Fiemrclm9mhiM1gnbvjfdPgP5A8ONfDTU2/dk8Tg9Kj8dYK
         /cNsVhfJwOUv2lQw0oeb6mAicbwXoTP4JTg1yO9FuRYuMbH0icVbqvbQk65lUzn+jf
         5/Ix+D49PQvzA==
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
Subject: [PATCH AUTOSEL 4.19 4/5] net: stmmac: fix missing pci_disable_device() on error in stmmac_pci_probe()
Date:   Wed, 18 May 2022 08:29:44 -0400
Message-Id: <20220518122946.343712-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122946.343712-1-sashal@kernel.org>
References: <20220518122946.343712-1-sashal@kernel.org>
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

