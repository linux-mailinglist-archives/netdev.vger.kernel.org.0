Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61688439CCC
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbhJYRGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234640AbhJYRDz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:03:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD11560F70;
        Mon, 25 Oct 2021 17:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181278;
        bh=yAUPeMRMR5WBXzQ+VGOAyFWKkfCcGA1CA7S0hx/Gdls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9XQsdcYouWZgnR3sbK/V9UGAANy5NGhrImR6biQ4epPal848E6sOTx/ciURvZha/
         +T1apMmE20OP6BePV/O2Z0RfFfvZkb+pu9UbjZQnskcrb5bQurWISWC04L1TsF1KU9
         e1zbKJsPg/9IMnblr5AJX5rO2utrroMHC31kkj7mT8BC8Uwg97hETqyIVJ1CArgmqD
         O2uMc+1AcKgftcqPeZ3n4Xs5t+AxkQSR4KpR9l7GXhr64S93w4FTUxI/5OHqliHGVA
         J8f/S0mNzMwKfJr8aK2cM1DA3Ak/rYqwpDqzu2s6pNsP8mGXyOQU7hNJkXrDSgnxL+
         7GGunpZ7tF8Uw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 6/7] usbnet: sanity check for maxpacket
Date:   Mon, 25 Oct 2021 13:01:01 -0400
Message-Id: <20211025170103.1394651-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170103.1394651-1-sashal@kernel.org>
References: <20211025170103.1394651-1-sashal@kernel.org>
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
index 84b354f76dea..0598bc7aff89 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1784,6 +1784,10 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
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

