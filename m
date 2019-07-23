Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87BE572064
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 22:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731770AbfGWUDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 16:03:49 -0400
Received: from mga06.intel.com ([134.134.136.31]:45017 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727648AbfGWUDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 16:03:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jul 2019 13:03:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,300,1559545200"; 
   d="scan'208";a="197248108"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 23 Jul 2019 13:03:45 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id DDC9981; Tue, 23 Jul 2019 23:03:44 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Sunil Goutham <sgoutham@cavium.com>,
        Robert Richter <rric@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] net: thunderx: Use fwnode_get_mac_address()
Date:   Tue, 23 Jul 2019 23:03:43 +0300
Message-Id: <20190723200344.69864-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the custom implementation with fwnode_get_mac_address,
which works on both DT and ACPI platforms.

While here, replace memcpy() by ether_addr_copy().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../net/ethernet/cavium/thunder/thunder_bgx.c  | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index ad22554857bf..acb016834f04 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1381,24 +1381,18 @@ static int acpi_get_mac_address(struct device *dev, struct acpi_device *adev,
 				u8 *dst)
 {
 	u8 mac[ETH_ALEN];
-	int ret;
+	u8 *addr;
 
-	ret = fwnode_property_read_u8_array(acpi_fwnode_handle(adev),
-					    "mac-address", mac, ETH_ALEN);
-	if (ret)
-		goto out;
-
-	if (!is_valid_ether_addr(mac)) {
+	addr = fwnode_get_mac_address(acpi_fwnode_handle(adev), mac, ETH_ALEN);
+	if (!addr) {
 		dev_err(dev, "MAC address invalid: %pM\n", mac);
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	dev_info(dev, "MAC address set to: %pM\n", mac);
 
-	memcpy(dst, mac, ETH_ALEN);
-out:
-	return ret;
+	ether_addr_copy(dst, mac);
+	return 0;
 }
 
 /* Currently only sets the MAC address. */
-- 
2.20.1

