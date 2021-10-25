Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B2A439CDE
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbhJYRHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234459AbhJYREO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:04:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69B13610D2;
        Mon, 25 Oct 2021 17:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181290;
        bh=400Nh6Ud5p6IB0VRpwhYfffj5ss6oI+bK9BzysJ6Fis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkc7qW5sC5ynkXgsd5L3fIeQKYz5oJMUiUJT7IvuzlkJoWUDFovjUpoMq8y/X+b+W
         T7xazzTr1mRo0uB0xDrGyfN6gpinkBXTwu7sjPYrYpZtOkhqEiMEAH2LsU/vM+IacF
         VOCY8sUyI9+cz8Kgr7ZXadpDSOyxMjQbJsPbUT3lZZE3DLSRQHoE3vKUpsOPT2n2f+
         HGJXCbzBI5qaYoXWJbcsjWMaX/BCnz/rGzVV27FiuxZqMqzbhceNRgmksSWOlme6CC
         zNcM8YvtdbkRsgsNLNXBqG2OoAAlGNVrZXcRHedSSQ3BQeBkm+eJ9fMkG5/DJzzd9Z
         jfgYIHnyO7CAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 6/7] usbnet: sanity check for maxpacket
Date:   Mon, 25 Oct 2021 13:01:19 -0400
Message-Id: <20211025170120.1394792-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170120.1394792-1-sashal@kernel.org>
References: <20211025170120.1394792-1-sashal@kernel.org>
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
index cb9a18eda798..1703da29bdee 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1788,6 +1788,10 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
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

