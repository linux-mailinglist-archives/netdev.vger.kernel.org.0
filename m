Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E558652BA31
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236601AbiERM1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236583AbiERM1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:27:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E48108A8C;
        Wed, 18 May 2022 05:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6349B61290;
        Wed, 18 May 2022 12:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B30CC34118;
        Wed, 18 May 2022 12:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876849;
        bh=3ttDH7Ouwvsv4SWQiq9osTp1Ju2Kv4XBmQr9tWoCqqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSFEGvJrCcXDf9fV9MclgvZ22p+7Go60Zmv6mb6ZBkzR9sxrId9jVw1456XCc3Slw
         BaRX7dB4Lzz4wwOCHZTQJytwKVFxB17YMvVN94/eSqVGLNTLvbK5b5LpdosH8kibbu
         E4Oe824dN7sPC/6j5nbMmr/rd8iYO2Y4jEJ9ceDfftuikDBXYYPdW2Qd/LH/zbzydv
         o48I5son5ROVvgl5g4QJgEhD1GAKMpzpLoJ+hc0ZU0w5vFs39YmbFqoSTQFApxfr5r
         PK0g6E0c3L7AXHtEM6R11bZMbg8zbjhRzUbePZNliPC3uK/+GDjKARJpJAPeacC8B1
         5ocTW4MYJOSyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, arnd@arndb.de,
        jgg@ziepe.ca, netdev@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 16/23] ethernet: tulip: fix missing pci_disable_device() on error in tulip_init_one()
Date:   Wed, 18 May 2022 08:26:29 -0400
Message-Id: <20220518122641.342120-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122641.342120-1-sashal@kernel.org>
References: <20220518122641.342120-1-sashal@kernel.org>
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
index 79df5a72877b..0040dcaab945 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1399,8 +1399,10 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* alloc_etherdev ensures aligned and zeroed private structures */
 	dev = alloc_etherdev (sizeof (*tp));
-	if (!dev)
+	if (!dev) {
+		pci_disable_device(pdev);
 		return -ENOMEM;
+	}
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	if (pci_resource_len (pdev, 0) < tulip_tbl[chip_idx].io_size) {
@@ -1785,6 +1787,7 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 err_out_free_netdev:
 	free_netdev (dev);
+	pci_disable_device(pdev);
 	return -ENODEV;
 }
 
-- 
2.35.1

