Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE60A493E46
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 17:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356066AbiASQ2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 11:28:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55936 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiASQ2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 11:28:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CEB9B81A62
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 16:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FF8C004E1;
        Wed, 19 Jan 2022 16:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642609677;
        bh=4eBjvNo6BPPGThhmM3sQ0t2HSuT+q76Vuv3XRFOFlcM=;
        h=From:To:Cc:Subject:Date:From;
        b=AnB+SVsUjKLfgGzEPaYX8SbMEf4GpJkK5KNb751TwQKrRzC4Smh37aFHquYgk8N6q
         ZcPap31qYg9pA7BTteKLYfLM8o9KhPx/mzFQ8b+ObflcngtrnlM3sHceoOKxVEcw/+
         /8lGhaxEOQFLJ1lYsPd6v6OS0vFORe9sSXGYcLalW14JoIUnmW6DeEoL1VyPvKGcbb
         fcGZezw7TopnQI7uDSBYWU5fs2F/WdfU939oRVtx8N3YKZPpfz4tnhJxXFr5ECZ8Pw
         hfMYlGazSJHAqbpQuVX0fWQDTCfDHeJ3U0Vwh3j+cezzaBWTJO8ZQEbB/tL0INzeYJ
         wFqdg87CG0D8g==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net] phylib: fix potential use-after-free
Date:   Wed, 19 Jan 2022 17:27:48 +0100
Message-Id: <20220119162748.32418-1-kabel@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit bafbdd527d56 ("phylib: Add device reset GPIO support") added call
to phy_device_reset(phydev) after the put_device() call in phy_detach().

The comment before the put_device() call says that the phydev might go
away with put_device().

Fix potential use-after-free by calling phy_device_reset() before
put_device().

Fixes: bafbdd527d56 ("phylib: Add device reset GPIO support")
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/phy_device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 74d8e1dc125f..ce0bb5951b81 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1746,6 +1746,9 @@ void phy_detach(struct phy_device *phydev)
 	    phy_driver_is_genphy_10g(phydev))
 		device_release_driver(&phydev->mdio.dev);
 
+	/* Assert the reset signal */
+	phy_device_reset(phydev, 1);
+
 	/*
 	 * The phydev might go away on the put_device() below, so avoid
 	 * a use-after-free bug by reading the underlying bus first.
@@ -1757,9 +1760,6 @@ void phy_detach(struct phy_device *phydev)
 		ndev_owner = dev->dev.parent->driver->owner;
 	if (ndev_owner != bus->owner)
 		module_put(bus->owner);
-
-	/* Assert the reset signal */
-	phy_device_reset(phydev, 1);
 }
 EXPORT_SYMBOL(phy_detach);
 
-- 
2.34.1

