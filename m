Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F87FF0BF
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbfKPQHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:07:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730532AbfKPPua (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:50:30 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69410214E0;
        Sat, 16 Nov 2019 15:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919429;
        bh=bhdA9kNRhnLawkQQEg6MRHgImVL95/eiUfk8//boD7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJrmBEeVMlN7LSIW/hsJWFHAsYRKfcuuUgdkPEhj/KqYAtrmb/hKo4mNPi+/i69ml
         xwD+68lkdGz9Y0D3bMGS1mC4G6YJAWF1Zmz005cVueGwVobPkuiPkWzwP3ilRn1Wpj
         g97z95ef60cT4aA7qvkHt61GrGsJdH8e6iyaLeFg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 126/150] net: dsa: bcm_sf2: Turn on PHY to allow successful registration
Date:   Sat, 16 Nov 2019 10:47:04 -0500
Message-Id: <20191116154729.9573-126-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit c04a17d2a9ccf1eaba1c5a56f83e997540a70556 ]

We are binding to the PHY using the SF2 slave MDIO bus that we create,
binding involves reading the PHY's MII_PHYSID1/2 which won't be possible
if the PHY is turned off. Temporarily turn it on/off for the bus probing
to succeeed. This fixes unbind/bind problems where the port connecting
to that PHY would be in error since it could not connect to it.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 604c5abc08eb8..af666951a9592 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1196,12 +1196,16 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	bcm_sf2_gphy_enable_set(priv->dev->ds, true);
+
 	ret = bcm_sf2_mdio_register(ds);
 	if (ret) {
 		pr_err("failed to register MDIO bus\n");
 		return ret;
 	}
 
+	bcm_sf2_gphy_enable_set(priv->dev->ds, false);
+
 	ret = bcm_sf2_cfp_rst(priv);
 	if (ret) {
 		pr_err("failed to reset CFP\n");
-- 
2.20.1

