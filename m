Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFD73F695A
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 20:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbhHXS6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 14:58:14 -0400
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:18657 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233192AbhHXS6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 14:58:08 -0400
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 83506101751;
        Tue, 24 Aug 2021 18:57:23 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-16-112.trex-nlb.outbound.svc.cluster.local [100.96.16.112])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 00306100865;
        Tue, 24 Aug 2021 18:57:21 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.16.112 (trex/6.4.3);
        Tue, 24 Aug 2021 18:57:23 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Oafish-Share: 4b7400846682ab39_1629831443214_1785834749
X-MC-Loop-Signature: 1629831443214:3231507777
X-MC-Ingress-Time: 1629831443214
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dezi+B1VxHsWtBg/TBGqPOSRkDg62L1A8BXxTHF3L1M=; b=A6rEaypQdOAFE0TB8wzexOA+/a
        AJBFGjSFZFiykyrAagjvoxnRmdRX0kLBmWxGorJLiObRp3yzOVYT8VevlkkmsfOKgoxlBU59H3bLK
        Y8q25Rsbj8Ox1shpzDC98ilhhY/fSoTqxNFxhR+GpynGwijlOnB0ejU2i2rrxRi7iFMgBdYEgQoO8
        J5LmZm0Y6IN08+ssBpYroE5EKk+18f/Z2bQCw1sQ5grmmuhysp0EdIrV3EkGDni488y20XraN9k+4
        KvtiUn7qvfRt9gHCCZhkiipfW4xqVTN/eEcL2lt6gUcR++2GmIoX6aEZjjBLJ8iNKVSuxP0tczYN0
        WQ0GF3cA==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:51816 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIbbt-00BQSi-4Y; Tue, 24 Aug 2021 19:57:20 +0100
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-usb@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next v2 10/10] lan78xx: Limit number of driver warning messages
Date:   Tue, 24 Aug 2021 19:56:13 +0100
Message-Id: <20210824185613.49545-11-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824185613.49545-1-john.efstathiades@pebblebay.com>
References: <20210824185613.49545-1-john.efstathiades@pebblebay.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device removal can result in a large burst of driver warning messages
(20 - 30) sent to the kernel log. Most of these are register read/write
failures.

This change limits the rate at which these messages are emitted.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 4ec752d9751a..793f8fbe0069 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -462,7 +462,7 @@ static int lan78xx_read_reg(struct lan78xx_net *dev, u32 index, u32 *data)
 	if (likely(ret >= 0)) {
 		le32_to_cpus(buf);
 		*data = *buf;
-	} else {
+	} else if (net_ratelimit()) {
 		netdev_warn(dev->net,
 			    "Failed to read register index 0x%08x. ret = %d",
 			    index, ret);
@@ -492,7 +492,8 @@ static int lan78xx_write_reg(struct lan78xx_net *dev, u32 index, u32 data)
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
2.25.1

