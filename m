Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A600431522
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 21:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfEaTSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 15:18:33 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:36704 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbfEaTSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 15:18:32 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x4VJICmc025650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 13:18:13 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x4VJI9W8010639
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 31 May 2019 13:18:11 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next] net: sfp: Use smaller chunk size when reading I2C data
Date:   Fri, 31 May 2019 13:18:03 -0600
Message-Id: <1559330285-30246-3-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SFP driver was reading up to 256 bytes of I2C data from the SFP
module in a single chunk. However, some I2C controllers do not support
reading that many bytes in a single transaction. Change to use a more
compatible 16-byte chunk size, since this is not performance critical.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/phy/sfp.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 6b6c83d..23a40a7 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1651,7 +1651,7 @@ static int sfp_module_info(struct sfp *sfp, struct ethtool_modinfo *modinfo)
 static int sfp_module_eeprom(struct sfp *sfp, struct ethtool_eeprom *ee,
 			     u8 *data)
 {
-	unsigned int first, last, len;
+	unsigned int first, last;
 	int ret;
 
 	if (ee->len == 0)
@@ -1659,26 +1659,36 @@ static int sfp_module_eeprom(struct sfp *sfp, struct ethtool_eeprom *ee,
 
 	first = ee->offset;
 	last = ee->offset + ee->len;
-	if (first < ETH_MODULE_SFF_8079_LEN) {
-		len = min_t(unsigned int, last, ETH_MODULE_SFF_8079_LEN);
-		len -= first;
 
-		ret = sfp_read(sfp, false, first, data, len);
+	while (first < last) {
+		bool a2;
+		unsigned int this_addr, len;
+
+		if (first < ETH_MODULE_SFF_8079_LEN) {
+			len = min_t(unsigned int, last,
+				    ETH_MODULE_SFF_8079_LEN);
+			len -= first;
+			a2 = false;
+			this_addr = first;
+		} else {
+			len = min_t(unsigned int, last,
+				    ETH_MODULE_SFF_8472_LEN);
+			len -= first;
+			a2 = true;
+			this_addr = first - ETH_MODULE_SFF_8079_LEN;
+		}
+		/* Some I2C adapters cannot read 256 bytes in a single read.
+		 * Use a smaller chunk size to ensure we are within limits.
+		 */
+		len = min_t(unsigned int, len, 16);
+
+		ret = sfp_read(sfp, a2, this_addr, data, len);
 		if (ret < 0)
 			return ret;
 
 		first += len;
 		data += len;
 	}
-	if (first < ETH_MODULE_SFF_8472_LEN && last > ETH_MODULE_SFF_8079_LEN) {
-		len = min_t(unsigned int, last, ETH_MODULE_SFF_8472_LEN);
-		len -= first;
-		first -= ETH_MODULE_SFF_8079_LEN;
-
-		ret = sfp_read(sfp, true, first, data, len);
-		if (ret < 0)
-			return ret;
-	}
 	return 0;
 }
 
-- 
1.8.3.1

