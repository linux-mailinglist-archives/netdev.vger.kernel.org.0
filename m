Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE4147B81A
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhLUCEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235122AbhLUCCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:02:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6401CC061376;
        Mon, 20 Dec 2021 18:01:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0954BB81113;
        Tue, 21 Dec 2021 02:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE52EC36AE8;
        Tue, 21 Dec 2021 02:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052073;
        bh=38I45wHgL7cFlR/OJ10E6Lmql+pn9lhAX8Jxce9RIt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hE1DPET+kxoB25QSSp3cfGLJzFTmHf4/5R+F8qjrUenambCCfvs0ZyFhInq4FbQ0q
         9tL3+NdizmRfAcs9cfXjKZyqR680QvnCa+Fk3sJ45Peg7ZWI2Yf5j6vn/KgBG8dpXt
         NXjDEO3+RtMaPM5HFdJYXO1FTeIcJHFAwZdqGZsAcffP9HVJXKT8I5U7DVZ/0hyIJ6
         wbhCv2HbAyp6CYAU2GNDpP/JcICz69/9Y+zodeEGFj5Y7dwEFiQQTW8IwavipHUWEd
         tLDkWbAeuZkGy7Z2SiQrSJOcSwJjMrott7bCroyF45BAYeNg6yK788k+4Ygxd3/dUE
         lPRFZrwem/HOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqian Lin <linmq006@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, opendmb@gmail.com,
        kuba@kernel.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/11] net: bcmgenet: Fix NULL vs IS_ERR() checking
Date:   Mon, 20 Dec 2021 21:00:24 -0500
Message-Id: <20211221020030.117225-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221020030.117225-1-sashal@kernel.org>
References: <20211221020030.117225-1-sashal@kernel.org>
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
index 494601c39b847..0b6f6a3fd7347 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -549,9 +549,9 @@ static int bcmgenet_mii_pd_init(struct bcmgenet_priv *priv)
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

