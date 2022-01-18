Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B424919C9
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351925AbiARC4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:56:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37602 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348347AbiARCpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:45:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19B46612CE;
        Tue, 18 Jan 2022 02:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D96C36AF3;
        Tue, 18 Jan 2022 02:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473912;
        bh=LoTCXz3m/OT67ZXWMKudCikM2xU8jL2j7gLCbPmVYmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKL7F4qwDvVqDV+I0Sh//7GXAriHC/EUV8KkZCFyToKFajJOaCd/uUaFdnYC+hJUN
         xOLWiuk9UaSTHv4CziqKkMlZVx2748vzORr0hwX7kg6f3PyguO2Ugx+xJsQqGYNWzJ
         panYnJPmOdew1B/rZEFc6ZDUd3iZxU6gJxy1nUmtgfPIwZ3dg3mRfI5QzfBrZhWC+t
         k1WpUB4yiTrbv053WHsCRXYkfX8oNk628UZ1ttZ6ZXG7KMc9hHkV1wTOIduZgf0z8L
         HALihw4FbhCy62RIBzjY+XKBwwy4YEPKjI7I7K1Hiw5Jo/Hn/ulXCwtfBzNLWgTieb
         4ZSyExS3hMiPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        Brendan Dolan-Gavitt <brendandg@nyu.edu>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/73] mwifiex: Fix skb_over_panic in mwifiex_usb_recv()
Date:   Mon, 17 Jan 2022 21:43:38 -0500
Message-Id: <20220118024432.1952028-19-sashal@kernel.org>
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

[ Upstream commit 04d80663f67ccef893061b49ec8a42ff7045ae84 ]

Currently, with an unknown recv_type, mwifiex_usb_recv
just return -1 without restoring the skb. Next time
mwifiex_usb_rx_complete is invoked with the same skb,
calling skb_put causes skb_over_panic.

The bug is triggerable with a compromised/malfunctioning
usb device. After applying the patch, skb_over_panic
no longer shows up with the same input.

Attached is the panic report from fuzzing.
skbuff: skb_over_panic: text:000000003bf1b5fa
 len:2048 put:4 head:00000000dd6a115b data:000000000a9445d8
 tail:0x844 end:0x840 dev:<NULL>
kernel BUG at net/core/skbuff.c:109!
invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 PID: 198 Comm: in:imklog Not tainted 5.6.0 #60
RIP: 0010:skb_panic+0x15f/0x161
Call Trace:
 <IRQ>
 ? mwifiex_usb_rx_complete+0x26b/0xfcd [mwifiex_usb]
 skb_put.cold+0x24/0x24
 mwifiex_usb_rx_complete+0x26b/0xfcd [mwifiex_usb]
 __usb_hcd_giveback_urb+0x1e4/0x380
 usb_giveback_urb_bh+0x241/0x4f0
 ? __hrtimer_run_queues+0x316/0x740
 ? __usb_hcd_giveback_urb+0x380/0x380
 tasklet_action_common.isra.0+0x135/0x330
 __do_softirq+0x18c/0x634
 irq_exit+0x114/0x140
 smp_apic_timer_interrupt+0xde/0x380
 apic_timer_interrupt+0xf/0x20
 </IRQ>

Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/YX4CqjfRcTa6bVL+@Zekuns-MBP-16.fios-router.home
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index cb8a9ad40cfe9..39cf713d5054c 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -130,7 +130,8 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 		default:
 			mwifiex_dbg(adapter, ERROR,
 				    "unknown recv_type %#x\n", recv_type);
-			return -1;
+			ret = -1;
+			goto exit_restore_skb;
 		}
 		break;
 	case MWIFIEX_USB_EP_DATA:
-- 
2.34.1

