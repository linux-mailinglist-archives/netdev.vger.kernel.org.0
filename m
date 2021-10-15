Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F89F42FDFE
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238875AbhJOWTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:19:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238815AbhJOWTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:19:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 545F86120D;
        Fri, 15 Oct 2021 22:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634336222;
        bh=JaopO1MbDCUObFcjPUAtpGLUuJP3a6deYO5ssIwQCo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IllUyJNFcX6QeOsWocB6DfamaEj27znRGPITCuNm3Kqt4Lv6iOJuuBz2muVCMC5Ct
         wm1y4Yx8/+stWK3LjLXg2fxxlJO83z8gGghVM46kXfLPcbO3ObYzxe2AxiZUmh8w0G
         PeprX1Y2UW1gWbojYd6wKMfare5LsrgSjReatCHG/a8oddJnlU2H+du0Q7jx2MYb+O
         OWsy+fsFVfG1CjgR3xtbapiX7WpgTDP+b4ROEQKaG1RxAyvX6k/i/CMWy17zh0z5N0
         ID3vSDNfzLxyF6hofwHxxs8LQ6mhQZdd5pAnVeEjGmqD0P30+G+0jUH02xaDpi/RU8
         bJv6wXBAf1RPg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        opendmb@gmail.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH net-next 07/12] ethernet: bcmgenet: use eth_hw_addr_set()
Date:   Fri, 15 Oct 2021 15:16:47 -0700
Message-Id: <20211015221652.827253-8-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015221652.827253-1-kuba@kernel.org>
References: <20211015221652.827253-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Read the address into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: opendmb@gmail.com
CC: f.fainelli@gmail.com
CC: bcm-kernel-feedback-list@broadcom.com
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index ed53859b6f7d..5da9c00b43b1 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4085,8 +4085,12 @@ static int bcmgenet_probe(struct platform_device *pdev)
 		eth_hw_addr_set(dev, pd->mac_address);
 	else
 		if (device_get_ethdev_address(&pdev->dev, dev))
-			if (has_acpi_companion(&pdev->dev))
-				bcmgenet_get_hw_addr(priv, dev->dev_addr);
+			if (has_acpi_companion(&pdev->dev)) {
+				u8 addr[ETH_ALEN];
+
+				bcmgenet_get_hw_addr(priv, addr);
+				eth_hw_addr_set(dev, addr);
+			}
 
 	if (!is_valid_ether_addr(dev->dev_addr)) {
 		dev_warn(&pdev->dev, "using random Ethernet MAC\n");
-- 
2.31.1

