Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEF21068C3
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 10:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfKVJXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 04:23:03 -0500
Received: from mail.intenta.de ([178.249.25.132]:44062 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbfKVJXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 04:23:03 -0500
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Nov 2019 04:23:02 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=Content-Type:MIME-Version:Message-ID:Subject:CC:To:From:Date; bh=QoGoLrw+yd0OesTC5GBNZu06g/ri4zVDSm36TdL3rLw=;
        b=pf9FVhFny2MItH0BpjPM3KHNDrj3+KoU8YnLyDf/BZbFHVL44u8PH71CyGKmF62VDWnMW4/gf94nqkcz55EGUR6/35F61VxsDi3p1BRjvX5k+geqswdyyF+Be00azFCuN1bIf4eFRlLUnaQ7bLMVqBxRI2/5DbTGsqJ+1kdlqFBAshqSMho7SA9x002Gek4PsLmLORCf20gIzAMRyUoPfWhljhlzDIHXC1lQng8f8+k8G4HjrWRCH1Qw3z07Osr6zHuVFYKLlyzMrsotNQRkjI7P731fuiDg7yGEC8qfmuNIi/ruvqc4YIdMwpyWAasObQJ47qF9FJ6uG+uwga04jQ==;
Date:   Fri, 22 Nov 2019 10:17:13 +0100
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     YueHaibing <yuehaibing@huawei.com>, <davem@davemloft.net>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] mdio_bus: revert inadvertent error code change
Message-ID: <20191122091711.GA31495@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fixed commit inadvertently changes the error code from ENOTSUPP to
ENOSYS. Doing so breaks (among other things) probing of macb, which
returns -ENOTSUPP as it is now returned from mdiobus_register_reset.

Fixes: 1d4639567d97 ("mdio_bus: Fix PTR_ERR applied after initialization to constant")
Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
---
 drivers/net/phy/mdio_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 35876562e32a..dbacb0031877 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -65,7 +65,7 @@ static int mdiobus_register_reset(struct mdio_device *mdiodev)
 		reset = devm_reset_control_get_exclusive(&mdiodev->dev,
 							 "phy");
 	if (IS_ERR(reset)) {
-		if (PTR_ERR(reset) == -ENOENT || PTR_ERR(reset) == -ENOSYS)
+		if (PTR_ERR(reset) == -ENOENT || PTR_ERR(reset) == -ENOTSUPP)
 			reset = NULL;
 		else
 			return PTR_ERR(reset);
-- 
2.20.1

