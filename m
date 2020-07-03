Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918E6213AF2
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 15:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgGCN0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 09:26:38 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:63639 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgGCN0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 09:26:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593782797; x=1625318797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M/8OjpxBXA9Df1qwOeMkq4s3kPhfdX6fyC5NjM9SefM=;
  b=q2KrC9g7V59+JLBTP0IR3rfj+KJsRqHC+Pl5Ed39xEAS027NPMkxY9Iw
   /btnVGNn76WNIDwTD9vPih5mSk/8IyUdKwhY9VzBL7CEGi+ixHRIRZnGu
   g8CkLMJehHTF5ekGU4TMwU43X2IbMRVc9VrK614q/IhfXWzEqIgT4PaHV
   fwNMQRBNlO3gzj3jV3gE5K3cb+9fTNA2SNnfhmV1oqw10AJ5TjgpbOoVs
   RNTloAVNJNQYzs9ftqrsrsRxugYDNZB+01apj8Hl8LleZt3iSOiuLTkWb
   r/WzHVA2ReCZMcstGQHkjU9Udmosqu5a8KGVDJARBZsfyRe5NbDCEYlwY
   w==;
IronPort-SDR: wCWy2eXfDKFmOSZ72crT8FfKCRtUp0enFIlaCFbxnF58flmiHWF1Vp2cYV6h55vgVWwOdFY/PH
 jc+2TwYBzSO65QxDiHHvzoCuy8f9dEu9q55+bzNGGwh2wI/G1vUD0V3BcFPwKTpjAFWMjfJFib
 DeyT2l8bLZmoXJlUwPN0GWv9qImHB3WbHCXIGJWTFOyihKM3mWbDQADDTBZ27U61+6Bzouueou
 cxfYHdScsdF/xdYVw7WLODG0ObwXoInYRqcuN3dnP7jwJKF2350OJghnjtiZOfbXXuM6FZ/ent
 tQ0=
X-IronPort-AV: E=Sophos;i="5.75,308,1589266800"; 
   d="scan'208";a="80631894"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Jul 2020 06:26:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 3 Jul 2020 06:26:15 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 3 Jul 2020 06:26:35 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net 2/2] smsc95xx: avoid memory leak in smsc95xx_bind
Date:   Fri, 3 Jul 2020 15:25:06 +0200
Message-ID: <20200703132506.12359-3-andre.edich@microchip.com>
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

In a case where the ID_REV register read is failed, the memory for a
private data structure has to be freed before returning error from the
function smsc95xx_bind.

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

