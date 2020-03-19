Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 643D218AC94
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 06:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgCSF7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 01:59:31 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46530 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgCSF7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 01:59:30 -0400
Received: by mail-lf1-f67.google.com with SMTP id a28so587382lfr.13;
        Wed, 18 Mar 2020 22:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4AbHLBURcg70iEWU76CnCq8iJIf343eM2hhp8ZJ9uIs=;
        b=WJie2FFqqnjkHSs7KRUyot9wFIe/zORBUT6bNUlWZiD15hdkbXDt2Bz6Z9urRfN5Ms
         V7jm7TUtBh5LivuF6ukKuhwi8nowZgTdkfJ/S2blg3RIkBzclxMIKe6JUaLrDSj600kS
         XgkvJ9sm7QnxNMNaLYmiecvfhrR+iERPRPSwfPITv6UflMhtHti4Tgor28gtpCnYmxd0
         Y0avHBoL3qmTr7BrhnpFltnlo5VVDA9aRj6WUf0dD9DtKH8z2JUXxDL5bdZ5kb8OEXW1
         R7OFWd8zLzU1wJqQ3LI5vtS7ay2iKZ/ICwp54BFBoqQjD1aWRJs9qeN/E/TQp1ae9A46
         CGqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4AbHLBURcg70iEWU76CnCq8iJIf343eM2hhp8ZJ9uIs=;
        b=pZxLJcs4OFRcn4L19N46r/n9a4mQg19J2o3d3arnnmqfn02+UUbWIx7vZYPEuertQs
         ZfnmZ4yCIw8oAQl7rbqKhVQSs0Eq3j7Mlf09Sm2MKVIFhYWPZP0nO5hLITR+qv9PcUN4
         GxD2np1dtM7H7qhY2W8EPU4yxLoND4TRzJn/4TxNVTJs9XNkBD3yEBygJtshmiGONF7F
         KyDN2AkRtpmJcgYmjC/oV+1zNsZB7+mpHx6dXEd90kH5lC8Z/UelaQ0fVLx6W/q4B1jF
         TUs3ByU5DCn8jxOE1reOAmVnkD2Wdp5ISyAvXbIg+6JbkVJXCw6LEa9g/4mFJhWao9dg
         WIFA==
X-Gm-Message-State: ANhLgQ0aQIWMJqiBsFp7g0qnuLBpXKN66C4i3QoxRr/21P5g3InPOVJa
        0v8EdRIuNsEkGYNIBGqXDY3h1F1jARjpJA==
X-Google-Smtp-Source: ADFU+vtffu02yPuSwfMvRqzYoFHvAnQpPa5NGlmqCKfTHzfqmex3xIco+kCqUplRSHES4MDsakSH8w==
X-Received: by 2002:ac2:5187:: with SMTP id u7mr1055273lfi.153.1584597566619;
        Wed, 18 Mar 2020 22:59:26 -0700 (PDT)
Received: from localhost.localdomain ([185.188.71.122])
        by smtp.gmail.com with ESMTPSA id o15sm604393ljj.55.2020.03.18.22.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 22:59:26 -0700 (PDT)
From:   Pawel Dembicki <paweldembicki@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     Pawel Dembicki <paweldembicki@gmail.com>,
        Cezary Jackiewicz <cezary@eko.one.pl>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: qmi_wwan: add support for ASKEY WWHC050
Date:   Thu, 19 Mar 2020 06:58:45 +0100
Message-Id: <20200319055845.6431-1-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ASKEY WWHC050 is a mcie LTE modem.
The oem configuration states:

T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1690 ProdID=7588 Rev=ff.ff
S:  Manufacturer=Android
S:  Product=Android
S:  SerialNumber=813f0eef6e6e
C:* #Ifs= 6 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=84(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=86(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=88(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 5 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=(none)
E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=125us

Tested on openwrt distribution.

Signed-off-by: Cezary Jackiewicz <cezary@eko.one.pl>
[add commit message]
Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
---
 drivers/net/usb/qmi_wwan.c  | 1 +
 drivers/usb/serial/option.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 5754bb6ca0ee..6c738a271257 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1210,6 +1210,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x1435, 0xd182, 5)},	/* Wistron NeWeb D18 */
 	{QMI_FIXED_INTF(0x1435, 0xd191, 4)},	/* Wistron NeWeb D19Q1 */
 	{QMI_QUIRK_SET_DTR(0x1508, 0x1001, 4)},	/* Fibocom NL668 series */
+	{QMI_FIXED_INTF(0x1690, 0x7588, 4)},    /* ASKEY WWHC050 */
 	{QMI_FIXED_INTF(0x16d8, 0x6003, 0)},	/* CMOTech 6003 */
 	{QMI_FIXED_INTF(0x16d8, 0x6007, 0)},	/* CMOTech CHE-628S */
 	{QMI_FIXED_INTF(0x16d8, 0x6008, 0)},	/* CMOTech CMU-301 */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 084cc2fff3ae..809e6ba85045 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2016,6 +2016,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(4) | RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0105, 0xff),			/* Fibocom NL678 series */
 	  .driver_info = RSVD(6) },
+	{ USB_DEVICE(0x1690, 0x7588),                                           /* ASKEY WWHC050 */
+	  .driver_info = RSVD(1) | RSVD(4) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
-- 
2.20.1

