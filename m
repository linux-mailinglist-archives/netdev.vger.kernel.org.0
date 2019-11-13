Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 492F9FAE26
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 11:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfKMKLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 05:11:17 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35935 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfKMKLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 05:11:17 -0500
Received: by mail-wm1-f66.google.com with SMTP id c22so1329768wmd.1
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 02:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+WeywjYhif8cbDEqMOV9DoOxbQ0mSoumc3+tLKw1uLM=;
        b=H4cg+YZkn91KQnCu6mBp6aYcM6J1FTJ2Nx1UCRlGMBcC7vGLScX1L623Mp/ugSGMgF
         BKu01xFWg8RZDf/qyhPH9EC2ZfRzylzJYMg2w5rAlL7G6jckM1fn/gS4QDqxcyLixycS
         2Z3XsDxqlZejK5hp71L8Jqu7I7eqHz2TfY6gBGQbEvm/GdZTexGJH/M9AKKhnvQQND5C
         FSp7te8fAZRfzQFihdNGMrOuDSNUMWa5rbHrHISIwmPrDS4NzecStq1pMB+WKWjHFxhS
         eyLrKJT1L/PXDljA4hIN0iFTDMTbBGyasH5COY1vmYpOvB4CK9d62cKLslGA8nIwS8Av
         cTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+WeywjYhif8cbDEqMOV9DoOxbQ0mSoumc3+tLKw1uLM=;
        b=tzuzw4u7Fx/SO6Ms8KNioxqL4/7IKEWew9fnZHX414kkwyKeLSPp/ixDtSOb4ZuZDC
         Qwk9V1yHOPly7nPrF0xhuzWpByIAPta4GJ/XiEkXjgUkr+uVD9U+4Pewv/FTXFN6HpVI
         leXJBa0eoNHkG4j1UJI/thxMkWWn8YjbOJbpcBXxzkMjO/5zVEWZ746SgZrTHe7xUc+1
         tiJU3ppcRwUUo27tTbmcbI4oQImij7qaUNVgLJP4h0LAUJNDO26ekk8kfhYMpwSwquBR
         UbJ2FRZEhglzYedlMbsncdcaCkGwPeGamsLHE7bNWG9GcAr9IsunEt5kbHY2/PdJLycS
         68ow==
X-Gm-Message-State: APjAAAW7p9KcV+Rz/pe33I46B8B1+TqbHZDZKjUa12wwW0/Cg7lwEbrb
        mQufBTkzYEXmOCTXKRmKZ4hM+A==
X-Google-Smtp-Source: APXvYqwst42K3LwIDuk0tBKtjOq4ShX05R4CRWd8xFX1teo1ExSOwBayxYOUvI9Fdmk6xfk9T6RxKA==
X-Received: by 2002:a1c:ed16:: with SMTP id l22mr1918443wmh.151.1573639875005;
        Wed, 13 Nov 2019 02:11:15 -0800 (PST)
Received: from ares.lan (232.red-88-3-18.dynamicip.rima-tde.net. [88.3.18.232])
        by smtp.gmail.com with ESMTPSA id k4sm1896719wmk.26.2019.11.13.02.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 02:11:14 -0800 (PST)
From:   Aleksander Morgado <aleksander@aleksander.es>
To:     bjorn@mork.no, davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc:     Aleksander Morgado <aleksander@aleksander.es>
Subject: [PATCH] net: usb: qmi_wwan: add support for Foxconn T77W968 LTE modules
Date:   Wed, 13 Nov 2019 11:11:10 +0100
Message-Id: <20191113101110.496306-1-aleksander@aleksander.es>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are the Foxconn-branded variants of the Dell DW5821e modules,
same USB layout as those.

The QMI interface is exposed in USB configuration #1:

P:  Vendor=0489 ProdID=e0b4 Rev=03.18
S:  Manufacturer=FII
S:  Product=T77W968 LTE
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option

Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
---
 drivers/net/usb/qmi_wwan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 56d334b9ad45..4196c0e32740 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1371,6 +1371,8 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0191, 4)},	/* Quectel EG91 */
 	{QMI_FIXED_INTF(0x2c7c, 0x0296, 4)},	/* Quectel BG96 */
 	{QMI_QUIRK_SET_DTR(0x2cb7, 0x0104, 4)},	/* Fibocom NL678 series */
+	{QMI_FIXED_INTF(0x0489, 0xe0b4, 0)},	/* Foxconn T77W968 LTE */
+	{QMI_FIXED_INTF(0x0489, 0xe0b5, 0)},	/* Foxconn T77W968 LTE with eSIM support*/
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-- 
2.24.0

