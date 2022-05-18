Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027BF52BA93
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237135AbiERMeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236972AbiERMdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:33:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFA612817E;
        Wed, 18 May 2022 05:29:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 297CFB81FB6;
        Wed, 18 May 2022 12:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65670C385A5;
        Wed, 18 May 2022 12:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876944;
        bh=8om2/fhiG8TXweqUp72Yv+T68LoNLXS196P2AH48xG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zd4NkuCygGR1hIAOxTX9Opv0MZ70e0GmXaf7h3UY1z2rTFrKPEtQu4zqmP0M9zZoe
         X/ir8JftiHLVrGFDrK4ErRVlzmTGqZPIPgAx2uPmtIr1tPFqxlq0IxGfTWXP9gJxtD
         Grr0YkN9O5x4POB5ORwP2dGmgfaV0ussHZq0ZILx0jvnfVCYyFpaLn58viapnbXofB
         wPF21/D/9ZrgIzV+ULFmOr7Y4h4FuzBbFYG/d1uz7G2bDphHXqBTmRKefpEKX3tHgU
         d5y492bKY7qHXfsOuZo9CuNGWu8hg7IMLPIShljNlt7XuRQCzvSGxjDDu8anfmgVqO
         X0oZ7BrXQaSAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, jgg@ziepe.ca,
        arnd@arndb.de, netdev@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/13] ethernet: tulip: fix missing pci_disable_device() on error in tulip_init_one()
Date:   Wed, 18 May 2022 08:28:37 -0400
Message-Id: <20220518122844.343220-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122844.343220-1-sashal@kernel.org>
References: <20220518122844.343220-1-sashal@kernel.org>
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

[ Upstream commit 51ca86b4c9c7c75f5630fa0dbe5f8f0bd98e3c3e ]

Fix the missing pci_disable_device() before return
from tulip_init_one() in the error handling case.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220506094250.3630615-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dec/tulip/tulip_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index e7b0d7de40fd..c22d945a79fd 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1396,8 +1396,10 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* alloc_etherdev ensures aligned and zeroed private structures */
 	dev = alloc_etherdev (sizeof (*tp));
-	if (!dev)
+	if (!dev) {
+		pci_disable_device(pdev);
 		return -ENOMEM;
+	}
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	if (pci_resource_len (pdev, 0) < tulip_tbl[chip_idx].io_size) {
@@ -1774,6 +1776,7 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 err_out_free_netdev:
 	free_netdev (dev);
+	pci_disable_device(pdev);
 	return -ENODEV;
 }
 
-- 
2.35.1

