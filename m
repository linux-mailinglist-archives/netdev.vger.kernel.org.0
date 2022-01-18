Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FEF4919D1
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351934AbiARC4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:56:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53564 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348380AbiARCpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:45:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C75EB811CF;
        Tue, 18 Jan 2022 02:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A03C36AEB;
        Tue, 18 Jan 2022 02:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473914;
        bh=ZtDKUt8zQi4O7Km6XjhQhnQ9cR3FhiXrj238XpOzWF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xutnl80TeKSY253wGrdVLrKXD9JaPsmCwAlVzTe5/8jI6EM+Xtvx0/zIhCh6jBypX
         OUMmNkYpWFrhddX+Frw5f60rTzliOwX6/nB7nVjSz9my3XIJLwbt4QZwrOZUQ57XjH
         9QANgBsNPbgmsCCINePHoRoaO1m0SQitkm/hEBHKmniyA1ex84drC6mIk1K22IJ+W6
         gyzWAykUGZoXbWfQFGgpC0K4WgbMV+xFAbmxr1Ks5MQ1yotooI94dhYH/KKN2Gn4lh
         RXqOWvNHL4ri46hBF5v6NbdX7Ajn1ZFqBXBPI9NkKw2RkgT4/wAmGveV8RfbCOloI2
         RUyTALKffdYaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        Brendan Dolan-Gavitt <brendandg@nyu.edu>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, amitkarwar@gmail.com,
        siva8118@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 20/73] rsi: Fix use-after-free in rsi_rx_done_handler()
Date:   Mon, 17 Jan 2022 21:43:39 -0500
Message-Id: <20220118024432.1952028-20-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zekun Shen <bruceshenzk@gmail.com>

[ Upstream commit b07e3c6ebc0c20c772c0f54042e430acec2945c3 ]

When freeing rx_cb->rx_skb, the pointer is not set to NULL,
a later rsi_rx_done_handler call will try to read the freed
address.
This bug will very likley lead to double free, although
detected early as use-after-free bug.

The bug is triggerable with a compromised/malfunctional usb
device. After applying the patch, the same input no longer
triggers the use-after-free.

Attached is the kasan report from fuzzing.

BUG: KASAN: use-after-free in rsi_rx_done_handler+0x354/0x430 [rsi_usb]
Read of size 4 at addr ffff8880188e5930 by task modprobe/231
Call Trace:
 <IRQ>
 dump_stack+0x76/0xa0
 print_address_description.constprop.0+0x16/0x200
 ? rsi_rx_done_handler+0x354/0x430 [rsi_usb]
 ? rsi_rx_done_handler+0x354/0x430 [rsi_usb]
 __kasan_report.cold+0x37/0x7c
 ? dma_direct_unmap_page+0x90/0x110
 ? rsi_rx_done_handler+0x354/0x430 [rsi_usb]
 kasan_report+0xe/0x20
 rsi_rx_done_handler+0x354/0x430 [rsi_usb]
 __usb_hcd_giveback_urb+0x1e4/0x380
 usb_giveback_urb_bh+0x241/0x4f0
 ? __usb_hcd_giveback_urb+0x380/0x380
 ? apic_timer_interrupt+0xa/0x20
 tasklet_action_common.isra.0+0x135/0x330
 __do_softirq+0x18c/0x634
 ? handle_irq_event+0xcd/0x157
 ? handle_edge_irq+0x1eb/0x7b0
 irq_exit+0x114/0x140
 do_IRQ+0x91/0x1e0
 common_interrupt+0xf/0xf
 </IRQ>

Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/YXxQL/vIiYcZUu/j@10-18-43-117.dynapool.wireless.nyu.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 68ce3d2bc5357..730d7bf86c40c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -261,8 +261,12 @@ static void rsi_rx_done_handler(struct urb *urb)
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)rx_cb->data;
 	int status = -EINVAL;
 
+	if (!rx_cb->rx_skb)
+		return;
+
 	if (urb->status) {
 		dev_kfree_skb(rx_cb->rx_skb);
+		rx_cb->rx_skb = NULL;
 		return;
 	}
 
@@ -286,8 +290,10 @@ static void rsi_rx_done_handler(struct urb *urb)
 	if (rsi_rx_urb_submit(dev->priv, rx_cb->ep_num, GFP_ATOMIC))
 		rsi_dbg(ERR_ZONE, "%s: Failed in urb submission", __func__);
 
-	if (status)
+	if (status) {
 		dev_kfree_skb(rx_cb->rx_skb);
+		rx_cb->rx_skb = NULL;
+	}
 }
 
 static void rsi_rx_urb_kill(struct rsi_hw *adapter, u8 ep_num)
-- 
2.34.1

