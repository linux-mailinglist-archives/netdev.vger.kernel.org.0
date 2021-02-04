Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69DE630F2C2
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235669AbhBDLzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:55:50 -0500
Received: from ares.krystal.co.uk ([77.72.0.130]:54316 "EHLO
        ares.krystal.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235652AbhBDLzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 06:55:48 -0500
X-Greylist: delayed 1373 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Feb 2021 06:55:48 EST
Received: from [51.148.178.73] (port=37344 helo=pbcl-dsk8.fritz.box)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1l7crn-008lpZ-Ss; Thu, 04 Feb 2021 11:32:07 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next 4/9] lan78xx: disable MAC address filter before updating entry
Date:   Thu,  4 Feb 2021 11:31:16 +0000
Message-Id: <20210204113121.29786-5-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
References: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ares.krystal.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - pebblebay.com
X-Get-Message-Sender-Via: ares.krystal.co.uk: authenticated_id: john.efstathiades@pebblebay.com
X-Authenticated-Sender: ares.krystal.co.uk: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable the station MAC address entry in the perfect address filter
table before updating the table entry with a new MAC address.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 776d84d2b513..d2fcc3c5eff2 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2493,9 +2493,12 @@ static int lan78xx_set_mac_addr(struct net_device *netdev, void *p)
 	lan78xx_write_reg(dev, RX_ADDRL, addr_lo);
 	lan78xx_write_reg(dev, RX_ADDRH, addr_hi);
 
-	/* Added to support MAC address changes */
-	lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
-	lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
+	/* The station MAC address in the perfect address filter table
+	 * must also be updated to ensure frames are received
+	 */
+	ret = lan78xx_write_reg(dev, MAF_HI(0), 0);
+	ret = lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
+	ret = lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
 
 	return 0;
 }
-- 
2.17.1

