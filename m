Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA54127164
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 00:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfLSXZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 18:25:03 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41386 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfLSXZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 18:25:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jeHwLRnfBL+oN8ref8YNqUH8S2pU5x9v1UJNMamNly4=; b=o2VlUb8mbGE0CMxjeskzkNf77l
        XFgpdfKx9s7iaxQ6lbeYK9ipcREzFEu3eeef4TyFjnlJgg8Bc2+oCzehWKETCPJR6f+NEC6hnkPQK
        XI8THg3PG817pRFqad0Z4Q6te5A49L6yF9unkud/KpHVeZNEUmjG7/VMB7NYsZTvYOVrLkcLl9Hfk
        D/3yrQKhIPN+mdxPk+yzELxY8COYZ2p7LcsWPwnd8IK/smdRokzMAS/j95CjPM8MHuEAObyfo48AQ
        ShGEG0wuJNyTA3ftPgscRUUOKFNJxcR3kr0sDOYWQjTUHsoQDuzW2ZI3ca1poPsX+6YRwik7Sksx8
        80LFL3aw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:51566 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ii5A0-0005MD-Fy; Thu, 19 Dec 2019 23:24:48 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ii59z-0003Na-Rb; Thu, 19 Dec 2019 23:24:47 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andy Fleming <afleming@freescale.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH net v2] mod_devicetable: fix PHY module format
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ii59z-0003Na-Rb@rmk-PC.armlinux.org.uk>
Date:   Thu, 19 Dec 2019 23:24:47 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a PHY is probed, if the top bit is set, we end up requesting a
module with the string "mdio:-10101110000000100101000101010001" -
the top bit is printed to a signed -1 value. This leads to the module
not being loaded.

Fix the module format string and the macro generating the values for
it to ensure that we only print unsigned types and the top bit is
always 0/1. We correctly end up with
"mdio:10101110000000100101000101010001".

Fixes: 8626d3b43280 ("phylib: Support phy module autoloading")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 include/linux/mod_devicetable.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 5714fd35a83c..e3596db077dc 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -587,9 +587,9 @@ struct platform_device_id {
 #define MDIO_NAME_SIZE		32
 #define MDIO_MODULE_PREFIX	"mdio:"
 
-#define MDIO_ID_FMT "%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d"
+#define MDIO_ID_FMT "%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u"
 #define MDIO_ID_ARGS(_id) \
-	(_id)>>31, ((_id)>>30) & 1, ((_id)>>29) & 1, ((_id)>>28) & 1,	\
+	((_id)>>31) & 1, ((_id)>>30) & 1, ((_id)>>29) & 1, ((_id)>>28) & 1, \
 	((_id)>>27) & 1, ((_id)>>26) & 1, ((_id)>>25) & 1, ((_id)>>24) & 1, \
 	((_id)>>23) & 1, ((_id)>>22) & 1, ((_id)>>21) & 1, ((_id)>>20) & 1, \
 	((_id)>>19) & 1, ((_id)>>18) & 1, ((_id)>>17) & 1, ((_id)>>16) & 1, \
-- 
2.20.1

