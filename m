Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C142921541A
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 10:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgGFIkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 04:40:40 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:4623 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbgGFIkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 04:40:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594024839; x=1625560839;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FfbsgHoQA2MGVmKdQEXkE5ueBUq3COrRk73C0HBm2I8=;
  b=rCE+CHazqJVeABMyJzWnidLQdP2lwgLd34ofqmm42rPb7V70trC5lrgP
   tsH6yN6GUXfaqo70LpmT0EZAKumJxZZnJBLekwCNeqwaeHoLnuLe52T5L
   HLNpRfBykvsZf3mozspb9fb5Wn2qeLVKE6GlL1X+LGqBUqlTAnIJ5d5oT
   uEIUw/9YwzaFxn5DxHSor5R+LUk+zUis7pP5W69umA9skwDXRENgyw6Ra
   Nn6umvTb28TPteVC/X2W7jylIAXywL7iUe9LCcB++3rmfb5BLizO+SmEv
   8CNH/WRbKskVWghONPILS+NquMic4FaPdAiKIi8Xw6JROfWNHv7NEN14W
   A==;
IronPort-SDR: 4f/GgNqsGzqaJ4mtPsP5G/Pd0JC0/PH6HCNNaOl1wDxzKAmTdwrpgjYl9AqBIZDxU5wA1BFaOv
 aMRQ/3tNObqWiMO4p5oD8H2gmqjaplHl/NQGf+3TAsdJrXiGOor8gvxlvVowqA+3vlCO5nwH4/
 7HaBXPJIhItQG8V/QwvNTiNHbVZHunVPfJ9TE29MEaAT92qP7DUkBReYEjBLbh7OGsZ1TcCw2Q
 4G0K4NCctLXyGEmC1j9LuhPpWbpyVc2Z287M1E0w5CYvcN0PpBY7h2FXYDE9VufnOeG91Dvo9Q
 eoQ=
X-IronPort-AV: E=Sophos;i="5.75,318,1589266800"; 
   d="scan'208";a="86314679"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2020 01:40:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 6 Jul 2020 01:40:39 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 6 Jul 2020 01:40:14 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net v2 2/2] smsc95xx: avoid memory leak in smsc95xx_bind
Date:   Mon, 6 Jul 2020 10:39:35 +0200
Message-ID: <20200706083935.19040-3-andre.edich@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706083935.19040-1-andre.edich@microchip.com>
References: <20200706083935.19040-1-andre.edich@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a case where the ID_REV register read is failed, the memory for a
private data structure has to be freed before returning error from the
function smsc95xx_bind.

Fixes: bbd9f9ee69242 ("smsc95xx: add wol support for more frame types")
Signed-off-by: Andre Edich <andre.edich@microchip.com>
Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/usb/smsc95xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index eb404bb74e18..bb4ccbda031a 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1293,7 +1293,8 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	/* detect device revision as different features may be available */
 	ret = smsc95xx_read_reg(dev, ID_REV, &val);
 	if (ret < 0)
-		return ret;
+		goto free_pdata;
+
 	val >>= 16;
 	pdata->chip_id = val;
 	pdata->mdix_ctrl = get_mdix_status(dev->net);
-- 
2.27.0

