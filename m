Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67417293F3D
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 17:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408438AbgJTPGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 11:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727760AbgJTPGY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 11:06:24 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1972F22258;
        Tue, 20 Oct 2020 15:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603206384;
        bh=P59ZBcgLP9CaPsjS1lVVy9tVYMSJ5YRBakB2YG0Mwu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MAw9KgdqLL6Mi1UCm+lBlGpgCeLX1bKhAS3/MOPg+RPvmbMjGNJx3NY/gz0/MAjH
         4doU2NzkTUK+5r02YLcTo8w2pJGFWWMiAeW63D8eEdhhA4VNvNToUNAXi7tfMkEUtM
         S3ax1PQc8fAWOwkbr5VrYAUFDFbAG8Ue9vMHh9UI=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH russell-kings-net-queue v2 3/3] net: phylink: don't fail attaching phy on 1000base-x/2500base-x mode
Date:   Tue, 20 Oct 2020 17:06:15 +0200
Message-Id: <20201020150615.11969-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020150615.11969-1-kabel@kernel.org>
References: <20201020150615.11969-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some SFPs may contain an internal PHY which may in some cases want to
connect with the host interface in 1000base-x/2500base-x mode.
Do not fail if such PHY is being attached in one of these PHY interface
modes.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/phylink.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 6680de39e338..37b40db04526 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1017,9 +1017,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
 			      phy_interface_t interface)
 {
-	if (WARN_ON(pl->cfg_link_an_mode == MLO_AN_FIXED ||
-		    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
-		     phy_interface_mode_is_8023z(interface))))
+	if (WARN_ON(pl->cfg_link_an_mode == MLO_AN_FIXED))
 		return -EINVAL;
 
 	if (pl->phydev)
-- 
2.26.2

