Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093352AD329
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 11:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgKJKHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 05:07:00 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:30804 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729518AbgKJKG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 05:06:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605002818; x=1636538818;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=QEu3DFmQoPTTcPOvRiqtur5CeOCrmq72y1qW9mxA3lg=;
  b=QQlqr8EFV5GXA8IGC6kv9Ep+YKLItCQaCKvDjFmiFPOEGDMXEbLVndfp
   boA0htuU9F7fTHOlrCh4XGd85tIFX0K3Yh84j/CAw6hbEFygfJyUZFVBI
   Sq5QAKb1lRurtM0lWxhvU6hZP4aw0ReHt/Lac88Vw55pUYGJhYGIcupK2
   9tKgHWTJWArVNojbDkuvQR4x6eWWfT/dwxaO76ZPT7JXuJLQBlxUBzJkQ
   rVG361eOwc3pF9MLyT9knlHXali+2Y22Vz5HFYOLPtWlBrSuV7PnIEswn
   3egiiavC/xHiQVulc6Kl8eIXNQQuZbkT7alp3cHjm/THdYyTMGPmjFdVS
   A==;
IronPort-SDR: 9/8A2lQQ8xCIYT3KWDnJJgD2Qo4+mZIIdd4s6MY0jLoovRJ7u8jn1ILmsRgN0lqN2BUuGEzUHA
 sN02zrJg2CKn5xaBzEXZ73uaMnbX9x3zVml0c/hSWM8kUt5yzDGL7HOdNCXk0108HZex9h9/yk
 EIeDfBI7Nrjc/gAbFVe9CdOizFiL4HZ4tccHgL5V3Ucz7KCZcStQSbuju1+aymzZ26Ccs4ijLD
 139AxFUyE+7u76M1FnODOkVUos8mo+oJb/vjHsHKk1eFhR5KHRbs0b10bk2Q9wpJA4JP8oqvxa
 6Gc=
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="33053859"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Nov 2020 03:06:58 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 10 Nov 2020 03:06:58 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 10 Nov 2020 03:06:56 -0700
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH] phy: phylink: Fix CuSFP issue in phylink
Date:   Tue, 10 Nov 2020 11:06:42 +0100
Message-ID: <20201110100642.2153-1-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is an issue with the current phylink driver and CuSFPs which
results in a callback to the phylink validate function without any
advertisement capabilities.  The workaround (in this changeset)
is to assign capabilities if a 1000baseT SFP is identified.

Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
---
 drivers/net/phy/phylink.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 32f4e8ec96cf..76e25f7f6934 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2196,6 +2196,14 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 		mode = MLO_AN_INBAND;
 
 	/* Do the initial configuration */
+	if (phylink_test(pl->sfp_support, 1000baseT_Full)) {
+		pr_info("%s:%d: adding 1000baseT to PHY\n", __func__, __LINE__);
+		phylink_set(phy->supported, 1000baseT_Half);
+		phylink_set(phy->supported, 1000baseT_Full);
+		phylink_set(phy->advertising, 1000baseT_Half);
+		phylink_set(phy->advertising, 1000baseT_Full);
+	}
+
 	ret = phylink_sfp_config(pl, mode, phy->supported, phy->advertising);
 	if (ret < 0)
 		return ret;
-- 
2.17.1

