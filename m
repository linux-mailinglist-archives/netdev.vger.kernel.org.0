Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB00935393
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 01:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbfFDX0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 19:26:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbfFDXZq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 19:25:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4072E2085A;
        Tue,  4 Jun 2019 23:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690746;
        bh=7u/5WAQMZbc5TkreaeLjW0MfISjWR/sDS4GUnk1Atfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GId6dOHDggegOoWjrr1gR0jNvAPJisJXyxytRUkPpM2oDo0kTeh09V0XdyseIqp/E
         doa2Nal4c3RgLnsLYdy3Q+s/uk9+QoJGCNVo+nGW7XmRwZ+KvSfpWImNfxIxa6OS+l
         TPsMphMI6dko/NKezoCxWjPlKZqwui4qGJ9OZkcU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kloetzke Jan <Jan.Kloetzke@preh.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 08/10] usbnet: fix kernel crash after disconnect
Date:   Tue,  4 Jun 2019 19:25:29 -0400
Message-Id: <20190604232532.7953-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232532.7953-1-sashal@kernel.org>
References: <20190604232532.7953-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kloetzke Jan <Jan.Kloetzke@preh.de>

[ Upstream commit ad70411a978d1e6e97b1e341a7bde9a79af0c93d ]

When disconnecting cdc_ncm the kernel sporadically crashes shortly
after the disconnect:

  [   57.868812] Unable to handle kernel NULL pointer dereference at virtual address 00000000
  ...
  [   58.006653] PC is at 0x0
  [   58.009202] LR is at call_timer_fn+0xec/0x1b4
  [   58.013567] pc : [<0000000000000000>] lr : [<ffffff80080f5130>] pstate: 00000145
  [   58.020976] sp : ffffff8008003da0
  [   58.024295] x29: ffffff8008003da0 x28: 0000000000000001
  [   58.029618] x27: 000000000000000a x26: 0000000000000100
  [   58.034941] x25: 0000000000000000 x24: ffffff8008003e68
  [   58.040263] x23: 0000000000000000 x22: 0000000000000000
  [   58.045587] x21: 0000000000000000 x20: ffffffc68fac1808
  [   58.050910] x19: 0000000000000100 x18: 0000000000000000
  [   58.056232] x17: 0000007f885aff8c x16: 0000007f883a9f10
  [   58.061556] x15: 0000000000000001 x14: 000000000000006e
  [   58.066878] x13: 0000000000000000 x12: 00000000000000ba
  [   58.072201] x11: ffffffc69ff1db30 x10: 0000000000000020
  [   58.077524] x9 : 8000100008001000 x8 : 0000000000000001
  [   58.082847] x7 : 0000000000000800 x6 : ffffff8008003e70
  [   58.088169] x5 : ffffffc69ff17a28 x4 : 00000000ffff138b
  [   58.093492] x3 : 0000000000000000 x2 : 0000000000000000
  [   58.098814] x1 : 0000000000000000 x0 : 0000000000000000
  ...
  [   58.205800] [<          (null)>]           (null)
  [   58.210521] [<ffffff80080f5298>] expire_timers+0xa0/0x14c
  [   58.215937] [<ffffff80080f542c>] run_timer_softirq+0xe8/0x128
  [   58.221702] [<ffffff8008081120>] __do_softirq+0x298/0x348
  [   58.227118] [<ffffff80080a6304>] irq_exit+0x74/0xbc
  [   58.232009] [<ffffff80080e17dc>] __handle_domain_irq+0x78/0xac
  [   58.237857] [<ffffff8008080cf4>] gic_handle_irq+0x80/0xac
  ...

The crash happens roughly 125..130ms after the disconnect. This
correlates with the 'delay' timer that is started on certain USB tx/rx
errors in the URB completion handler.

The problem is a race of usbnet_stop() with usbnet_start_xmit(). In
usbnet_stop() we call usbnet_terminate_urbs() to cancel all URBs in
flight. This only makes sense if no new URBs are submitted
concurrently, though. But the usbnet_start_xmit() can run at the same
time on another CPU which almost unconditionally submits an URB. The
error callback of the new URB will then schedule the timer after it was
already stopped.

The fix adds a check if the tx queue is stopped after the tx list lock
has been taken. This should reliably prevent the submission of new URBs
while usbnet_terminate_urbs() does its job. The same thing is done on
the rx side even though it might be safe due to other flags that are
checked there.

Signed-off-by: Jan Klötzke <Jan.Kloetzke@preh.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/usbnet.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 9710cf71054a..2502681369cd 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -499,6 +499,7 @@ static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
 
 	if (netif_running (dev->net) &&
 	    netif_device_present (dev->net) &&
+	    test_bit(EVENT_DEV_OPEN, &dev->flags) &&
 	    !test_bit (EVENT_RX_HALT, &dev->flags) &&
 	    !test_bit (EVENT_DEV_ASLEEP, &dev->flags)) {
 		switch (retval = usb_submit_urb (urb, GFP_ATOMIC)) {
@@ -1385,6 +1386,11 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
 		spin_unlock_irqrestore(&dev->txq.lock, flags);
 		goto drop;
 	}
+	if (netif_queue_stopped(net)) {
+		usb_autopm_put_interface_async(dev->intf);
+		spin_unlock_irqrestore(&dev->txq.lock, flags);
+		goto drop;
+	}
 
 #ifdef CONFIG_PM
 	/* if this triggers the device is still a sleep */
-- 
2.20.1

