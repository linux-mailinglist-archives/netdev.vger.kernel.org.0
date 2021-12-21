Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5095347B781
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbhLUCAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbhLUB7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:59:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFCDC0698C3;
        Mon, 20 Dec 2021 17:59:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A982AB81110;
        Tue, 21 Dec 2021 01:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A925C36AEA;
        Tue, 21 Dec 2021 01:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051967;
        bh=jRj2pfNJvSAPC6UUJR4dO4oURiSedMsZlrfQ5x9kkus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7E+JbczsfEUZGIpKCijqYEp6FEMuPxMhfMEF24MVR59BqBctawJoG4fPxD3hmi6G
         H9kqMIK9dvtnziHeGCdqZASD7+ceDiaHBvnG4w+WU6k60izZHCb1q0ITQFvHoeLcFC
         a/iqdiebgMEdbCFTSWZqlv1QKZ6X+i6r2Ye+Oafl2PQRV0jMhFFLqg6AEAYSxOg+P9
         Bfe0QR8Ypvye+VXwERUn/7PgWjjyYrbgdA6iVK13bWd0s+4bgN3Wis886AZK8M9Oun
         ixCrInbynWWzikViY4JkesMYG4NoQW9DOVznX5QIh+IdGv2wqZnaCMWDQrHZIHy0H6
         1iKaQLCTU0PKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqian Lin <linmq006@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, opendmb@gmail.com,
        kuba@kernel.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/19] net: bcmgenet: Fix NULL vs IS_ERR() checking
Date:   Mon, 20 Dec 2021 20:59:03 -0500
Message-Id: <20211221015914.116767-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015914.116767-1-sashal@kernel.org>
References: <20211221015914.116767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit ab8eb798ddabddb2944401bf31ead9671cb97d95 ]

The phy_attach() function does not return NULL. It returns error pointers.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index f9e91304d2327..2b67e335bc54e 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -557,9 +557,9 @@ static int bcmgenet_mii_pd_init(struct bcmgenet_priv *priv)
 		 * Internal or external PHY with MDIO access
 		 */
 		phydev = phy_attach(priv->dev, phy_name, pd->phy_interface);
-		if (!phydev) {
+		if (IS_ERR(phydev)) {
 			dev_err(kdev, "failed to register PHY device\n");
-			return -ENODEV;
+			return PTR_ERR(phydev);
 		}
 	} else {
 		/*
-- 
2.34.1

