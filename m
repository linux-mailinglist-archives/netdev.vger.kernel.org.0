Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC43F2CE7
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 11:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387821AbfKGK5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 05:57:19 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44047 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbfKGK5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 05:57:18 -0500
Received: by mail-lj1-f193.google.com with SMTP id g3so1726480ljl.11
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 02:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k8OJfKDxG/XoNC2pbiUD5PT0YIFy3ifLKQUf4E98DHk=;
        b=Q/BbFhiHYDsrSiia+mXvjQj+0lqZuwANP6IRs4HUATjuvjQ/ghVdWKqetbHEXM3BM7
         vc8kBeWdze0Pl5eOXCaHjpbA5AHKysV5ptgTYCcPkxoDecVt8jX3KJhSfHM9maLa52y2
         BHe2n2hODSUjcN6rTYXS0oBi8z0HqJl8xGbKAWctHxNeOO4CJ5ag/FPmAgbhU3+hhsAD
         78dyDiRLZGr+UNITZKqI0KKrda184AumB0YQTMHuUhp+j7elJsxv2lWBQ9wV1mgyvNkI
         +y7pZlEOdyTH6DfA7WpZZN9EuvSJ3N4yiseheogzC5Jls3kgVnPgJIsHvef382nDaH3b
         GFsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k8OJfKDxG/XoNC2pbiUD5PT0YIFy3ifLKQUf4E98DHk=;
        b=IrEJllLk+LJYbPOkZ7mQs346TeclipHZvU/+W3TS+DmskZ3KeR4STfE33F868O9jHU
         6CnbGxqLEyIeh/fI/8YYj4mYeYNz9YeL102Z3celtRNiCe77sXIZydVHVZxsyWwNj+Zr
         pinQglTP86yMZjrggI0ouHVsPdXBaQF60NfoV0M7wmgozWRgkXLLoEYif9Hk9VWU50At
         DnJfxRVir9FJE3dJs5S21EtQ4qYeesHLyKzlBBpjmAstDkVijqdTFEZJFJWmqvD42n3b
         TRblepPPoyYm4w/2CvGc0SPMasyA8F0PFy0EFtNG//y+SAema3a8ojviKBCRI9y/bW/1
         0N2Q==
X-Gm-Message-State: APjAAAUyRH9qWIrh79VgwKIZjI3Fm81Yxadyg7OjKs+nTEyylwSk1ldH
        0OI3ArKrz4WTzzZ4vM8iVjpwSg==
X-Google-Smtp-Source: APXvYqz8WNMCpVcB8UeqGirNhbK2ngT/iK0QhJfUnWN2IxlleveUTgElFHZNJN/V0w/Ba10l53RKHA==
X-Received: by 2002:a2e:b604:: with SMTP id r4mr1915582ljn.134.1573124233050;
        Thu, 07 Nov 2019 02:57:13 -0800 (PST)
Received: from localhost.localdomain ([37.46.115.8])
        by smtp.gmail.com with ESMTPSA id x18sm768077ljc.39.2019.11.07.02.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 02:57:12 -0800 (PST)
From:   Aleksander Morgado <aleksander@aleksander.es>
To:     bjorn@mork.no, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] net: usb: qmi_wwan: add support for DW5821e with eSIM support
Date:   Thu,  7 Nov 2019 11:57:01 +0100
Message-Id: <20191107105701.1010823-1-aleksander@aleksander.es>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Exactly same layout as the default DW5821e module, just a different
vid/pid.

The QMI interface is exposed in USB configuration #1:

P:  Vendor=413c ProdID=81e0 Rev=03.18
S:  Manufacturer=Dell Inc.
S:  Product=DW5821e-eSIM Snapdragon X20 LTE
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option

Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
Cc: stable <stable@vger.kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 596428ec71df..56d334b9ad45 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1362,6 +1362,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 8)},	/* Dell Wireless 5811e */
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 10)},	/* Dell Wireless 5811e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 0)},	/* Dell Wireless 5821e */
+	{QMI_FIXED_INTF(0x413c, 0x81e0, 0)},	/* Dell Wireless 5821e with eSIM support*/
 	{QMI_FIXED_INTF(0x03f0, 0x4e1d, 8)},	/* HP lt4111 LTE/EV-DO/HSPA+ Gobi 4G Module */
 	{QMI_FIXED_INTF(0x03f0, 0x9d1d, 1)},	/* HP lt4120 Snapdragon X5 LTE */
 	{QMI_FIXED_INTF(0x22de, 0x9061, 3)},	/* WeTelecom WPD-600N */
-- 
2.24.0

