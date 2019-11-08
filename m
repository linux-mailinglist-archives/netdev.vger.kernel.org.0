Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B430F4787
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391617AbfKHLrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:47:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391588AbfKHLrk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:47:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09B57222C5;
        Fri,  8 Nov 2019 11:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213659;
        bh=uIXzy5NaSb2l3HTFOk/ZUs1O/o+lkruU8kvNmDUkF+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCxoZEHQOhBfNjec29KelrmEF3Yv6n5UQCtuq+ma0dbqqxS+jHQBLThjcar0oHtP3
         dXUnjkEOX5zFSfWyUrjJD3qSzzKh2LpZR3rVYupqUpRZLRD75mzezq3DLb4uWqVSuz
         JYeReGrkDAvtRu9xfLAvIy+yebCIn8bAMWHhhNFc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Raghuram Chary Jallipalli 
        <raghuramchary.jallipalli@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 14/44] net: lan78xx: Bail out if lan78xx_get_endpoints fails
Date:   Fri,  8 Nov 2019 06:46:50 -0500
Message-Id: <20191108114721.15944-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114721.15944-1-sashal@kernel.org>
References: <20191108114721.15944-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit fa8cd98c06407b5798b927cd7fd14d30f360ed02 ]

We need to bail out if lan78xx_get_endpoints() fails, otherwise the
result is overwritten.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Reviewed-by: Raghuram Chary Jallipalli <raghuramchary.jallipalli@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 45a6a7cae4bfc..fc922f8122801 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2246,6 +2246,11 @@ static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 	int i;
 
 	ret = lan78xx_get_endpoints(dev, intf);
+	if (ret) {
+		netdev_warn(dev->net, "lan78xx_get_endpoints failed: %d\n",
+			    ret);
+		return ret;
+	}
 
 	dev->data[0] = (unsigned long)kzalloc(sizeof(*pdata), GFP_KERNEL);
 
-- 
2.20.1

