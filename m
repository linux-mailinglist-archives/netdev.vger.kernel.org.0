Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C0130F2D1
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 13:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbhBDMCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 07:02:38 -0500
Received: from ares.krystal.co.uk ([77.72.0.130]:35078 "EHLO
        ares.krystal.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235799AbhBDMCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 07:02:37 -0500
Received: from [51.148.178.73] (port=37344 helo=pbcl-dsk8.fritz.box)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1l7cro-008lpZ-2s; Thu, 04 Feb 2021 11:32:08 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next 6/9] lan78xx: reduce number of register access failure warnings
Date:   Thu,  4 Feb 2021 11:31:18 +0000
Message-Id: <20210204113121.29786-7-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
References: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ares.krystal.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - pebblebay.com
X-Get-Message-Sender-Via: ares.krystal.co.uk: authenticated_id: john.efstathiades@pebblebay.com
X-Authenticated-Sender: ares.krystal.co.uk: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the device is disconnected attempts to access device registers
via the control endpoint will fail. This can result in a stream
of warning messages in the kernel log.

Use net_ratelimit() to limit the number of warning messages emitted
following device disconnection.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 7c815061e02e..a4278f9dc319 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -624,7 +624,7 @@ static int lan78xx_read_reg(struct lan78xx_net *dev, u32 index, u32 *data)
 	if (likely(ret >= 0)) {
 		le32_to_cpus(buf);
 		*data = *buf;
-	} else {
+	} else if (net_ratelimit()) {
 		netdev_warn(dev->net,
 			    "Failed to read register index 0x%08x. ret = %d",
 			    index, ret);
@@ -654,7 +654,8 @@ static int lan78xx_write_reg(struct lan78xx_net *dev, u32 index, u32 data)
 			      USB_VENDOR_REQUEST_WRITE_REGISTER,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      0, index, buf, 4, USB_CTRL_SET_TIMEOUT);
-	if (unlikely(ret < 0)) {
+	if (unlikely(ret < 0) &&
+	    net_ratelimit()) {
 		netdev_warn(dev->net,
 			    "Failed to write register index 0x%08x. ret = %d",
 			    index, ret);
-- 
2.17.1

