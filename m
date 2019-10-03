Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBC5CA629
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 18:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404925AbfJCQke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 12:40:34 -0400
Received: from vsmx012.vodafonemail.xion.oxcs.net ([153.92.174.90]:60421 "EHLO
        vsmx012.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731501AbfJCQkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 12:40:32 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Oct 2019 12:40:31 EDT
Received: from vsmx004.vodafonemail.xion.oxcs.net (unknown [192.168.75.198])
        by mta-8-out.mta.xion.oxcs.net (Postfix) with ESMTP id 0C0D1F34DD8;
        Thu,  3 Oct 2019 16:35:04 +0000 (UTC)
Received: from arcor.de (unknown [91.40.26.191])
        by mta-8-out.mta.xion.oxcs.net (Postfix) with ESMTPA id B70B019A6ED;
        Thu,  3 Oct 2019 16:34:59 +0000 (UTC)
Date:   Thu, 3 Oct 2019 18:34:39 +0200
From:   Reinhard Speyerer <rspmn@arcor.de>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] qmi_wwan: add support for Cinterion CLS8 devices
Message-ID: <20191003163439.GA1556@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-VADE-STATUS: LEGIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Cinterion CLS8 devices.
Use QMI_QUIRK_SET_DTR as required for Qualcomm MDM9x07 chipsets. 

T:  Bus=01 Lev=03 Prnt=05 Port=01 Cnt=02 Dev#= 25 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1e2d ProdID=00b0 Rev= 3.18
S:  Manufacturer=GEMALTO
S:  Product=USB Modem
C:* #Ifs= 5 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=89(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
---
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index b6dc5d714b5e..3d77cd402ba9 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1350,6 +1350,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x1e2d, 0x0082, 4)},	/* Cinterion PHxx,PXxx (2 RmNet) */
 	{QMI_FIXED_INTF(0x1e2d, 0x0082, 5)},	/* Cinterion PHxx,PXxx (2 RmNet) */
 	{QMI_FIXED_INTF(0x1e2d, 0x0083, 4)},	/* Cinterion PHxx,PXxx (1 RmNet + USB Audio)*/
+	{QMI_QUIRK_SET_DTR(0x1e2d, 0x00b0, 4)},	/* Cinterion CLS8 */
 	{QMI_FIXED_INTF(0x413c, 0x81a2, 8)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a3, 8)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a4, 8)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */
