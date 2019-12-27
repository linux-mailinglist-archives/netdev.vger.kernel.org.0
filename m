Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5638D12B66F
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfL0Rmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:42:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:39760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727947AbfL0Rmm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A4AD21744;
        Fri, 27 Dec 2019 17:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468561;
        bh=btxijgQeafxrlBq6FrXQk6LgJOls1zIVVBq1KL4GIBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2bt21LKRHsJvtgLdzqViMGZofI2Kxs4HG/AvYEJP+iSWRkRk3ua03pq00GAXxxNB
         +TvmJE15844w+FP7DwpdqHdUvwYuafdQFXL7FxLOWiawc6RTWfV6oaGndqphW+PujP
         gCME2iz26L2V4WwDhPSrcSWyQB8H+TyDjdt+nA+I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Birsan <cristian.birsan@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 087/187] net: usb: lan78xx: Fix suspend/resume PHY register access error
Date:   Fri, 27 Dec 2019 12:39:15 -0500
Message-Id: <20191227174055.4923-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cristian Birsan <cristian.birsan@microchip.com>

[ Upstream commit 20032b63586ac6c28c936dff696981159913a13f ]

Lan78xx driver accesses the PHY registers through MDIO bus over USB
connection. When performing a suspend/resume, the PHY registers can be
accessed before the USB connection is resumed. This will generate an
error and will prevent the device to resume correctly.
This patch adds the dependency between the MDIO bus and USB device to
allow correct handling of suspend/resume.

Fixes: ce85e13ad6ef ("lan78xx: Update to use phylib instead of mii_if_info.")
Signed-off-by: Cristian Birsan <cristian.birsan@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index f24a1b0b801f..0becc79fd431 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1808,6 +1808,7 @@ static int lan78xx_mdio_init(struct lan78xx_net *dev)
 	dev->mdiobus->read = lan78xx_mdiobus_read;
 	dev->mdiobus->write = lan78xx_mdiobus_write;
 	dev->mdiobus->name = "lan78xx-mdiobus";
+	dev->mdiobus->parent = &dev->udev->dev;
 
 	snprintf(dev->mdiobus->id, MII_BUS_ID_SIZE, "usb-%03d:%03d",
 		 dev->udev->bus->busnum, dev->udev->devnum);
-- 
2.20.1

