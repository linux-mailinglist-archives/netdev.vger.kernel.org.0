Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE843F4BE9
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 15:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhHWNyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 09:54:23 -0400
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:26438 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230084AbhHWNyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 09:54:21 -0400
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id DA2BF121DBB;
        Mon, 23 Aug 2021 13:53:34 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-18-119.trex.outbound.svc.cluster.local [100.96.18.119])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 954A712147C;
        Mon, 23 Aug 2021 13:53:33 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.18.119 (trex/6.3.3);
        Mon, 23 Aug 2021 13:53:34 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Macabre-Exultant: 63718730000a654d_1629726814548_2147413481
X-MC-Loop-Signature: 1629726814548:209663884
X-MC-Ingress-Time: 1629726814547
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=39woZpFfvrae85q5+Ed+TW75pkcJJzb9hM71pK77olc=; b=g40O337tkItC5/YXHobG+62VkX
        h/0Jc7Jjoc7OH+3SjPSXCoFwOJMMDMwb3kYwxj+XUeCoiZ+YBP0qrNPByPx+gQ046Exo+cwt0pj9K
        v10t0K4W5MOUUuKyd5ba7oE9Lf1tDEvv2uoGFhZFnKqhuhZFwiIqY3n45ygJntaBp/mzSeAWWqoJO
        Wa//w5xDMJqWz0pmr0Qzed0SwF+Y92YtMoLaof1UT79TQWw6BchHIKOHPoQKHQp2cAksYLZIFPbMX
        8MzR8ADN+az8ns0dvVTg034pABg/LKqkCNNuykdc2LacC3hL5lJDxNp+xLZ0gO2TtQqVl9Uvovvef
        Xsslo4QA==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:51812 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIAOK-003PzY-0O; Mon, 23 Aug 2021 14:53:31 +0100
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        john.efstathiades@pebblebay.com
Subject: [PATCH net-next 10/10] lan78xx: Limit number of driver warning messages
Date:   Mon, 23 Aug 2021 14:52:29 +0100
Message-Id: <20210823135229.36581-11-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210823135229.36581-1-john.efstathiades@pebblebay.com>
References: <20210823135229.36581-1-john.efstathiades@pebblebay.com>
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
index c4e5b643b809..9a51ab881047 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -468,7 +468,7 @@ static int lan78xx_read_reg(struct lan78xx_net *dev, u32 index, u32 *data)
 	if (likely(ret >= 0)) {
 		le32_to_cpus(buf);
 		*data = *buf;
-	} else {
+	} else if (net_ratelimit()) {
 		netdev_warn(dev->net,
 			    "Failed to read register index 0x%08x. ret = %d",
 			    index, ret);
@@ -498,7 +498,8 @@ static int lan78xx_write_reg(struct lan78xx_net *dev, u32 index, u32 data)
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

