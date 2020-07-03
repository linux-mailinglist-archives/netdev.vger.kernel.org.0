Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A783E213AEF
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 15:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgGCNZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 09:25:49 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:46299 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgGCNZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 09:25:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593782748; x=1625318748;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aXH7cCcyLAfZIki7F52vHIfuToOqAN4pwM7AwEcDW+I=;
  b=NyT+PZTjIGutLprJj5GHgsE6cR1SoZtXDMVOh5JI3LsvsPq5L3j5stBk
   VA2zCRSt+cxJUtfvagyld5jyCqWMclK/Xfg8103ZIWYvJtFiKaOoHdFyF
   UhjqEWASkKgNwevDr65UGIst8J03XEZhQug3Zula+zSXeI6ffyqvZ/adQ
   RoOAORJcuqlbdbGJj9eKKuocIUNdapXjV0G5Y2EWpbmcEe/BbbTB5Zfps
   JhLwRR62/+i+YdVTx9eqG5WzS88LrJdq6bAgM29nDgioUjYFAfg1JkFVr
   /QtyuSPRbnSuiCBCVF4g/NYlbXCFloiJvBN24R5mYZk38xTkT8Jsg+X6x
   g==;
IronPort-SDR: 4Lcsp5cbFIRD+dbK1IMgKZ+XMjzuirKxDBUUYy/dIvm6fW7QwYYhnX5XQoL8duaEMfpsE71xRm
 /6Azscd1Kvj8pS6FJc3btOzFRLHW/Do5ewkRWvZ3Q1JfZsbJML8hz/x4nmsN/3WdGWn6zBwLmt
 9MfMwXFIt+cLwjey0NSCL4WUJVcSnUUwtPv0EWP+9OSb6wNpVzVQ074fr27BKcj6xcaWWyLNgf
 q7yubHBfeZ4Yv3oFkRQ7urVseAR4qi2WUn7efJFwQIpoPSTEQBzx+PT6dLg2OkcsqqlDZ/44lS
 0xo=
X-IronPort-AV: E=Sophos;i="5.75,308,1589266800"; 
   d="scan'208";a="86143875"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Jul 2020 06:25:48 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 3 Jul 2020 06:25:47 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 3 Jul 2020 06:25:45 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net 1/2] smsc95xx: check return value of smsc95xx_reset
Date:   Fri, 3 Jul 2020 15:25:05 +0200
Message-ID: <20200703132506.12359-2-andre.edich@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200703132506.12359-1-andre.edich@microchip.com>
References: <20200703132506.12359-1-andre.edich@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of the function smsc95xx_reset() must be checked
to avoid returning false success from the function smsc95xx_bind().

Signed-off-by: Andre Edich <andre.edich@microchip.com>
Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/usb/smsc95xx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 3cf4dc3433f9..eb404bb74e18 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1287,6 +1287,8 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	/* Init all registers */
 	ret = smsc95xx_reset(dev);
+	if (ret)
+		goto free_pdata;
 
 	/* detect device revision as different features may be available */
 	ret = smsc95xx_read_reg(dev, ID_REV, &val);
@@ -1317,6 +1319,10 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	schedule_delayed_work(&pdata->carrier_check, CARRIER_CHECK_DELAY);
 
 	return 0;
+
+free_pdata:
+	kfree(pdata);
+	return ret;
 }
 
 static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
-- 
2.27.0

