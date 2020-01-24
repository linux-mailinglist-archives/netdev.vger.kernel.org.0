Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30521487F2
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389737AbgAXOZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:25:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388098AbgAXOVn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:21:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 683B322464;
        Fri, 24 Jan 2020 14:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875703;
        bh=Ufy2MMjY30X1FGM35OjV2uZmCn3u6e5Cout7ObfjLxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TG2gprGm4K68Y7Azl99Gm203/xD+3z6a3YRsCj4QrcH65UuIb6gEbfrQkRSIBlakR
         MJMvwirO/XNwr6lBqHdn3CrJUyCd6PEMhb60RY9Xf35e4BkXGtA+uVVZJ/dhwpDbQ0
         YhaGUYNet3lAqb7n5rRuOZRci1FUBD9r3ez/7uJs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>, hayeswang <hayeswang@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 20/32] r8152: add missing endpoint sanity check
Date:   Fri, 24 Jan 2020 09:21:07 -0500
Message-Id: <20200124142119.30484-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142119.30484-1-sashal@kernel.org>
References: <20200124142119.30484-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 86f3f4cd53707ceeec079b83205c8d3c756eca93 ]

Add missing endpoint sanity check to probe in order to prevent a
NULL-pointer dereference (or slab out-of-bounds access) when retrieving
the interrupt-endpoint bInterval on ndo_open() in case a device lacks
the expected endpoints.

Fixes: 40a82917b1d3 ("net/usb/r8152: enable interrupt transfer")
Cc: hayeswang <hayeswang@realtek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 6a86a03c5e95a..0083c60f5cdff 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5158,6 +5158,9 @@ static int rtl8152_probe(struct usb_interface *intf,
 		return -ENODEV;
 	}
 
+	if (intf->cur_altsetting->desc.bNumEndpoints < 3)
+		return -ENODEV;
+
 	usb_reset_device(udev);
 	netdev = alloc_etherdev(sizeof(struct r8152));
 	if (!netdev) {
-- 
2.20.1

