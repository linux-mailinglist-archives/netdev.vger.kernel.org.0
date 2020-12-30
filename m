Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57A32E7AA8
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 16:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgL3PtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 10:49:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbgL3PtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 10:49:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DD8822242;
        Wed, 30 Dec 2020 15:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609343301;
        bh=xnHEVZDk0ZJjtLvsuNl+eC760CQNHfhFxMLs1isYStA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2cDiROy3YnSsBiAv3HhjBbtYwRtKUn4Ogyeo5T4BhVSHEkGOXNh6sR4WuMx3CMdx
         1S2H49Lp5og5b6E50QOwp4RoaqUDs3g+F1t9iPvSIssQiu7PrjAdo33qTB/xemmlCY
         u3o8mdPh+1EPNgM0B84zP2InapfwKGUy/I38sRb4L6JsevVrYybFabDBSvK6yK5L+b
         ASoyFa4OTdtVWCq/LxVpAkutCh0nMeFiKYB/uj2M/q/39bxs3kV77zNeGggniMqj0a
         WbNM6WjIkyZ7/Kmtkk/8sIxhFSmA8Uywof+BnW4bSvDweQ6qxg7QAk9hCrA1oijLIr
         mkqfFA3F73lJA==
Received: by pali.im (Postfix)
        id EC92D9F8; Wed, 30 Dec 2020 16:48:19 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] net: sfp: allow to use also SFP modules which are detected as SFF
Date:   Wed, 30 Dec 2020 16:47:53 +0100
Message-Id: <20201230154755.14746-3-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201230154755.14746-1-pali@kernel.org>
References: <20201230154755.14746-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some GPON SFP modules (e.g. Ubiquiti U-Fiber Instant) have set SFF phys_id
in their EEPROM. Kernel SFP subsystem currently does not allow to use
modules detected as SFF.

This change extends check for SFP modules so also those with SFF phys_id
are allowed. With this change also GPON SFP module Ubiquiti U-Fiber Instant
is recognized.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 drivers/net/phy/sfp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 490e78a72dd6..73f3ecf15260 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -273,7 +273,8 @@ static const struct sff_data sff_data = {
 
 static bool sfp_module_supported(const struct sfp_eeprom_id *id)
 {
-	return id->base.phys_id == SFF8024_ID_SFP &&
+	return (id->base.phys_id == SFF8024_ID_SFP ||
+		id->base.phys_id == SFF8024_ID_SFF_8472) &&
 	       id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP;
 }
 
-- 
2.20.1

