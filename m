Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C42D226D16
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbgGTR1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728939AbgGTR1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 13:27:06 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE695C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 10:27:05 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id n22so15987498ejy.3
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 10:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rDS5RadgM+88ebV/IjHnQPHJzE3H9IdhwHwO6IZPaFs=;
        b=o4610EUID5mHvOY/XBTvVmUzq2VVeaTnxHbjQjwbyJepdWsMJMnOBF/3liFacUQG4C
         YD5qLmLxCV1zsxMbZ0qF2PfcG1c8/i+kFgZvmFjMyauULl3DiRBs87Jy9cIswfulpw2i
         iSebvTucT/2vZVvOB/RfRgy1whiyBXmLHB9XLqMYKMGYO81cL0NDdIjfbMl+gt5KO+lF
         /csaT4dfu/aMqCgeM7TPME4dP/AGh9So9Csb/bQYMCMKQQhOBM4RaMyAPlrkFiG1ybhx
         hdtODZZfQw0EDitqHbMd9QVFonTxsG5hOp9xuf9KLmrYWIFNG1pjv112dtd3y67gZqmb
         iEqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rDS5RadgM+88ebV/IjHnQPHJzE3H9IdhwHwO6IZPaFs=;
        b=dwEzA8RQOBUQsX+yQ6nZ/CVQtQMv41Zp9cLtfD3kbDv989XrxY+v/y5o/6yAVivGtI
         KTdHMRVrKVvqf6Ns2d9cPYK9CKFMe8KEblktv36DT6lWo3XmmyDRTH2UQ30crud33XCz
         HxnzXLaU2haEKeiI20BmVASWmL+TS2QWrtTJOb8XxRVmFFWAlJ2RQf5LIynGkxC2MOg+
         A4Jhb9p2umyVnf2u/+Z9zeClD5sZgWw9nvxHlO7lf4Wt12kYOxebNFECbkW9kVhaarnB
         P+mrcCM1dP/DIf8F5iWU0Qd6Uiw2teZ/gvkIJB8Bk3qP3AhF8cQT73YBcLxyLdGTMSqS
         Tuwg==
X-Gm-Message-State: AOAM5328SMjlbShJanwye8XnruXphCcwtTJGHplYr24A3cQq0i/xbN1G
        1zuUgjYOO/VZjQty9MJXnBI=
X-Google-Smtp-Source: ABdhPJygRkpdpXvs8sz8i9ZwANoZiL4gI5BB38XTQgmXVB56vK5gwIidzRbKrjQGnoHOx+2CcG4gLg==
X-Received: by 2002:a17:906:ce3c:: with SMTP id sd28mr20856892ejb.382.1595266024305;
        Mon, 20 Jul 2020 10:27:04 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id w19sm1813703ejv.92.2020.07.20.10.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 10:27:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com,
        michael@walle.cc, colin.king@canonical.com
Subject: [PATCH net-next] net: phy: fix check in get_phy_c45_ids
Date:   Mon, 20 Jul 2020 20:26:54 +0300
Message-Id: <20200720172654.1193241-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

After the patch below, the iteration through the available MMDs is
completely short-circuited, and devs_in_pkg remains set to the initial
value of zero.

Due to devs_in_pkg being zero, the rest of get_phy_c45_ids() is
short-circuited too: the following loop never reaches below this point
either (it executes "continue" for every device in package, failing to
retrieve PHY ID for any of them):

	/* Now probe Device Identifiers for each device present. */
	for (i = 1; i < num_ids; i++) {
		if (!(devs_in_pkg & (1 << i)))
			continue;

So c45_ids->device_ids remains populated with zeroes. This causes an
Aquantia AQR412 PHY (same as any C45 PHY would, in fact) to be probed by
the Generic PHY driver.

The issue seems to be a case of submitting partially committed work (and
therefore testing something other than was submitted).

The intention of the patch was to delay exiting the loop until one more
condition is reached (the devs_in_pkg read from hardware is either 0, OR
mostly f's). So fix the patch to reflect that.

Tested with traffic on a LS1028A-QDS, the PHY is now probed correctly
using the Aquantia driver. The devs_in_pkg bit field is set to
0xe000009a, and the MMDs that are present have the following IDs:

[    5.600772] libphy: get_phy_c45_ids: device_ids[1]=0x3a1b662
[    5.618781] libphy: get_phy_c45_ids: device_ids[3]=0x3a1b662
[    5.630797] libphy: get_phy_c45_ids: device_ids[4]=0x3a1b662
[    5.654535] libphy: get_phy_c45_ids: device_ids[7]=0x3a1b662
[    5.791723] libphy: get_phy_c45_ids: device_ids[29]=0x3a1b662
[    5.804050] libphy: get_phy_c45_ids: device_ids[30]=0x3a1b662
[    5.816375] libphy: get_phy_c45_ids: device_ids[31]=0x0

[    7.690237] mscc_felix 0000:00:00.5: PHY [0.5:00] driver [Aquantia AQR412] (irq=POLL)
[    7.704739] mscc_felix 0000:00:00.5: PHY [0.5:01] driver [Aquantia AQR412] (irq=POLL)
[    7.718918] mscc_felix 0000:00:00.5: PHY [0.5:02] driver [Aquantia AQR412] (irq=POLL)
[    7.733044] mscc_felix 0000:00:00.5: PHY [0.5:03] driver [Aquantia AQR412] (irq=POLL)

Fixes: bba238ed037c ("net: phy: continue searching for C45 MMDs even if first returned ffff:ffff")
Reported-by: Colin King <colin.king@canonical.com>
Reported-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/phy_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 49e98a092b96..1b9523595839 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -734,8 +734,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
 	/* Find first non-zero Devices In package. Device zero is reserved
 	 * for 802.3 c45 complied PHYs, so don't probe it at first.
 	 */
-	for (i = 1; i < MDIO_MMD_NUM && devs_in_pkg == 0 &&
-	     (devs_in_pkg & 0x1fffffff) == 0x1fffffff; i++) {
+	for (i = 1; i < MDIO_MMD_NUM && (devs_in_pkg == 0 ||
+	     (devs_in_pkg & 0x1fffffff) == 0x1fffffff); i++) {
 		if (i == MDIO_MMD_VEND1 || i == MDIO_MMD_VEND2) {
 			/* Check that there is a device present at this
 			 * address before reading the devices-in-package
-- 
2.25.1

