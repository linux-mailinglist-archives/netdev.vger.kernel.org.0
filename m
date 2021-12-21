Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0893347B722
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 02:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbhLUB6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 20:58:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60976 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbhLUB6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:58:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABD8DB810FE;
        Tue, 21 Dec 2021 01:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C884C36AE5;
        Tue, 21 Dec 2021 01:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051890;
        bh=uFuz8wrQ+Y47LNxnAx89/Xwnpp91IXRM33Z54EUuc4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Md5VglJuN+zbJnkoesebJQSXKH9e0Z4Af2qUXiTZpyl9jb/iu4nfIr1UaZPM3BvYX
         2SQZTVi/fGTWIDu4c/t6wGNbUlZ86gvy+1mov/43cDbde76ZxbgfiEm99qvGxeYwaZ
         EpW2H9QYuJhtUAMSD90s6R3i4lZ89Je2lJeLXtLkbhQb6kkq5SyDUrSmCSS9qebxOZ
         qLxYrtdXkKUqMkfp/l4/qviJ9Qj22oFPPLOWHSdltZG6YayRLEWIYsr7uTiCZFhU+9
         1r5d8StgvnhNbtCcm7z6bM8wKXrnkf1MvcRqdvLRrtTS9msPne0VdwirGyfVXps/WK
         z2KnjBJ+Nhrpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqian Lin <linmq006@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, opendmb@gmail.com,
        kuba@kernel.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 12/29] net: bcmgenet: Fix NULL vs IS_ERR() checking
Date:   Mon, 20 Dec 2021 20:57:33 -0500
Message-Id: <20211221015751.116328-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
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
index 89d16c587bb7d..50ea9401f123d 100644
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

