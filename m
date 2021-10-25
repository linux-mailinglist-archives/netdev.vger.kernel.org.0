Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB63439CD1
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbhJYRGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234855AbhJYREm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:04:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 221716108C;
        Mon, 25 Oct 2021 17:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181298;
        bh=faspEgg5FVt2f9ngascZR3HcPRDTT4d+RY/lzZDFwbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hARd2Q7vSZqVF9sDPP7mT8rLXHNwYYjFZz99vMW3bI8vBDsfFuooEs+xzcIUPTRuX
         9WYqxK5/oLgUJRB4dtlabC1ZnU3v8MKZzil4oOUDlkfNE55duGXqVw5fNHCN0rDzAw
         3P04qgZFmNcy2cHFAtjWRyw3yG6EQPGpmlPwq6YnMpUstejU9WwrvV2jXD44XeQuAY
         kS/Z0V0SnavZkWn8Ue5exv3LuifbEwzH4XFg0Z3M6me8cwAaTT9Ggs+UBZ5xTpFuGs
         r/OhgET59/sSsxucA5xbOXDPwFDrRCoVd8WtWs6MHg+z6cB3QPoILgG8YxTo8VZOo1
         Ly896ANzMQcmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/4] usbnet: sanity check for maxpacket
Date:   Mon, 25 Oct 2021 13:01:31 -0400
Message-Id: <20211025170132.1394887-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170132.1394887-1-sashal@kernel.org>
References: <20211025170132.1394887-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 397430b50a363d8b7bdda00522123f82df6adc5e ]

maxpacket of 0 makes no sense and oopses as we need to divide
by it. Give up.

V2: fixed typo in log and stylistic issues

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
Reviewed-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211021122944.21816-1-oneukum@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/usbnet.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 0b5fd1499ac0..965e1a7b179f 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1740,6 +1740,10 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	if (!dev->rx_urb_size)
 		dev->rx_urb_size = dev->hard_mtu;
 	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
+	if (dev->maxpacket == 0) {
+		/* that is a broken device */
+		goto out4;
+	}
 
 	/* let userspace know we have a random address */
 	if (ether_addr_equal(net->dev_addr, node_id))
-- 
2.33.0

