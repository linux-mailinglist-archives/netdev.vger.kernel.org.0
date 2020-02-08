Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2031564D6
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 15:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgBHOux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Feb 2020 09:50:53 -0500
Received: from canardo.mork.no ([148.122.252.1]:33285 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgBHOux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Feb 2020 09:50:53 -0500
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 018Eofn9020906
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 8 Feb 2020 15:50:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1581173443; bh=Vpr/GB20/4ALG01Sw1UOYk+VG6zHovjJ+L9SZllYKxI=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        b=N3OQMJ1oQNno2DzX0hIREKfHHc5ZHO3qlTeOBX+pC3kf1/qxTC6z0h/6RfwzEckQC
         EotTIXacF3H6lAyDarWUZMBx3Dzi9qfts1tRO6ligUvtG69VJSOpTFAUaAqCtLjKYA
         skjKkq9iBwR38c+yF8IpK7UmLQsUgF+u/e1fyMaA=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1j0RRR-0007DP-LO; Sat, 08 Feb 2020 15:50:41 +0100
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, Lars Melin <larsm17@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Aleksander Morgado <aleksander@aleksander.es>
Subject: [PATCH net,stable] qmi_wwan: re-add DW5821e pre-production variant
Date:   Sat,  8 Feb 2020 15:50:36 +0100
Message-Id: <20200208145036.27696-1-bjorn@mork.no>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit f25e1392fdb5 removed the support for the pre-production variant
of the Dell DW5821e to avoid probing another USB interface unnecessarily.
However, the pre-production samples are found in the wild, and this lack
of support is causing problems for users of such samples.  It is therefore
necessary to support both variants.

Matching on both interfaces 0 and 1 is not expected to cause any problem
with either variant, as only the QMI function will be probed successfully
on either.  Interface 1 will be rejected based on the HID class for the
production variant:

T:  Bus=01 Lev=03 Prnt=04 Port=00 Cnt=01 Dev#= 16 Spd=480 MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  2
P:  Vendor=413c ProdID=81d7 Rev=03.18
S:  Manufacturer=DELL
S:  Product=DW5821e Snapdragon X20 LTE
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#= 1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option

And interface 0 will be rejected based on too few endpoints for the
pre-production variant:

T: Bus=01 Lev=02 Prnt=02 Port=03 Cnt=03 Dev#= 7 Spd=480 MxCh= 0
D: Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs= 2
P: Vendor=413c ProdID=81d7 Rev= 3.18
S: Manufacturer=DELL
S: Product=DW5821e Snapdragon X20 LTE
S: SerialNumber=0123456789ABCDEF
C: #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
I: If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=
I: If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I: If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I: If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I: If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option

Fixes: f25e1392fdb5 ("qmi_wwan: fix interface number for DW5821e production firmware")
Link: https://whrl.pl/Rf0vNk
Reported-by: Lars Melin <larsm17@gmail.com>
Cc: Aleksander Morgado <aleksander@aleksander.es>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
What do you think Aleksander?  As expected, pre-production modems
are sold in large quantities by the usual suspects...  These do
typically end up in a Linux system, like the OpenWrt based ROOter
as proven by the given link.

I believe we have no choice but to support both variants.  If the
vendor doesn't like that, then they should start using unique
class/subclass/protocol labels for QMI functions.

I plan to followup with a patch to make the QCDM (2 EP) interface
rejects faster and less noisy, by simply enabling the Quectel quirk 
unconditionally.  This should be harmless. But it is not stable
material IMHO so it is a separate thing.


 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 9485c8d1de8a..839cef720cf6 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1363,6 +1363,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 8)},	/* Dell Wireless 5811e */
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 10)},	/* Dell Wireless 5811e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 0)},	/* Dell Wireless 5821e */
+	{QMI_FIXED_INTF(0x413c, 0x81d7, 1)},	/* Dell Wireless 5821e preproduction config */
 	{QMI_FIXED_INTF(0x413c, 0x81e0, 0)},	/* Dell Wireless 5821e with eSIM support*/
 	{QMI_FIXED_INTF(0x03f0, 0x4e1d, 8)},	/* HP lt4111 LTE/EV-DO/HSPA+ Gobi 4G Module */
 	{QMI_FIXED_INTF(0x03f0, 0x9d1d, 1)},	/* HP lt4120 Snapdragon X5 LTE */
-- 
2.20.1

