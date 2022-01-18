Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAAE491502
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343515AbiARCZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245427AbiARCX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:23:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C571C061771;
        Mon, 17 Jan 2022 18:23:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C44F60AF8;
        Tue, 18 Jan 2022 02:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12574C36AE3;
        Tue, 18 Jan 2022 02:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472625;
        bh=tgMxk0poZY5zYAaPiVwW6ZLGXckdFm/KF9btJSEKfHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KeW+FELCAEKNx0GhgJH9Jq4Hlee4jOWboqDBEuJMcZ7Ha+2R6+tJha/rWRYOyGD5o
         UDGadh2GakCwu4j1iWYxJGRW1lXz6BiHeo9qCODkBPOqGbmEApbrS1BVj+BQyZJlO0
         kZYdZS23RF+WbjlzcEQ2FnFFDfSWgPnNrlmgnyTvcZ+lBQl897sjrJruEZJD4V47Wq
         9bAUZ92ztCGBRsQ8P9NisNJoRR9YbWzDuMX3nD75/3ttkqd0azLjgCC1aKvqvDiph5
         P10iB1YNni75BCQ4IlpYZvyNKeAJmpr76nGpgrgEHFws0Y1JH8GjM8thv7dGU2eLob
         mhrsGamTZK+Mw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        Brendan Dolan-Gavitt <brendandg@nyu.edu>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, amitkarwar@gmail.com,
        siva8118@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 078/217] rsi: Fix out-of-bounds read in rsi_read_pkt()
Date:   Mon, 17 Jan 2022 21:17:21 -0500
Message-Id: <20220118021940.1942199-78-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zekun Shen <bruceshenzk@gmail.com>

[ Upstream commit f1cb3476e48b60c450ec3a1d7da0805bffc6e43a ]

rsi_get_* functions rely on an offset variable from usb
input. The size of usb input is RSI_MAX_RX_USB_PKT_SIZE(3000),
while 2-byte offset can be up to 0xFFFF. Thus a large offset
can cause out-of-bounds read.

The patch adds a bound checking condition when rcv_pkt_len is 0,
indicating it's USB. It's unclear whether this is triggerable
from other type of bus. The following check might help in that case.
offset > rcv_pkt_len - FRAME_DESC_SZ

The bug is trigerrable with conpromised/malfunctioning USB devices.
I tested the patch with the crashing input and got no more bug report.

Attached is the KASAN report from fuzzing.

BUG: KASAN: slab-out-of-bounds in rsi_read_pkt+0x42e/0x500 [rsi_91x]
Read of size 2 at addr ffff888019439fdb by task RX-Thread/227

CPU: 0 PID: 227 Comm: RX-Thread Not tainted 5.6.0 #66
Call Trace:
 dump_stack+0x76/0xa0
 print_address_description.constprop.0+0x16/0x200
 ? rsi_read_pkt+0x42e/0x500 [rsi_91x]
 ? rsi_read_pkt+0x42e/0x500 [rsi_91x]
 __kasan_report.cold+0x37/0x7c
 ? rsi_read_pkt+0x42e/0x500 [rsi_91x]
 kasan_report+0xe/0x20
 rsi_read_pkt+0x42e/0x500 [rsi_91x]
 rsi_usb_rx_thread+0x1b1/0x2fc [rsi_usb]
 ? rsi_probe+0x16a0/0x16a0 [rsi_usb]
 ? _raw_spin_lock_irqsave+0x7b/0xd0
 ? _raw_spin_trylock_bh+0x120/0x120
 ? __wake_up_common+0x10b/0x520
 ? rsi_probe+0x16a0/0x16a0 [rsi_usb]
 kthread+0x2b5/0x3b0
 ? kthread_create_on_node+0xd0/0xd0
 ret_from_fork+0x22/0x40

Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/YXxXS4wgu2OsmlVv@10-18-43-117.dynapool.wireless.nyu.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_main.c | 4 ++++
 drivers/net/wireless/rsi/rsi_91x_usb.c  | 1 -
 drivers/net/wireless/rsi/rsi_usb.h      | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index f1bf71e6c6081..5d1490fc32db4 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -23,6 +23,7 @@
 #include "rsi_common.h"
 #include "rsi_coex.h"
 #include "rsi_hal.h"
+#include "rsi_usb.h"
 
 u32 rsi_zone_enabled = /* INFO_ZONE |
 			INIT_ZONE |
@@ -168,6 +169,9 @@ int rsi_read_pkt(struct rsi_common *common, u8 *rx_pkt, s32 rcv_pkt_len)
 		frame_desc = &rx_pkt[index];
 		actual_length = *(u16 *)&frame_desc[0];
 		offset = *(u16 *)&frame_desc[2];
+		if (!rcv_pkt_len && offset >
+			RSI_MAX_RX_USB_PKT_SIZE - FRAME_DESC_SZ)
+			goto fail;
 
 		queueno = rsi_get_queueno(frame_desc, offset);
 		length = rsi_get_length(frame_desc, offset);
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 3cca1823c458a..66fe386ec9cc6 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -330,7 +330,6 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter, u8 ep_num, gfp_t mem_flags)
 	struct sk_buff *skb;
 	u8 dword_align_bytes = 0;
 
-#define RSI_MAX_RX_USB_PKT_SIZE	3000
 	skb = dev_alloc_skb(RSI_MAX_RX_USB_PKT_SIZE);
 	if (!skb)
 		return -ENOMEM;
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index 254d19b664123..961851748bc4c 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -44,6 +44,8 @@
 #define RSI_USB_BUF_SIZE	     4096
 #define RSI_USB_CTRL_BUF_SIZE	     0x04
 
+#define RSI_MAX_RX_USB_PKT_SIZE	3000
+
 struct rx_usb_ctrl_block {
 	u8 *data;
 	struct urb *rx_urb;
-- 
2.34.1

