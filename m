Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A00491CD2
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354941AbiARDST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:18:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42114 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235790AbiARDIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:08:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CAFAB81195;
        Tue, 18 Jan 2022 03:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB776C36AEB;
        Tue, 18 Jan 2022 03:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642475328;
        bh=R+egNYGbRmltRhDCPHVWNkHEUf6HAsx1h7zm+wAUvEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeWa+Cq8AqmX9cDOTDmwFP8DVp17XQriphtKYpunh7eX8PdEYOO6Wwy4+68mpJKv8
         GUinc/QmiFslqT1XaVpN/WdTTS2YlX+9z10j7brhx78BC5h/uNzovsPq1iA2ICQ6DF
         274OlRMcReKBLTt8PyAJ1ZroqSupZXPodXbIpx7SvLQIzCqGEDeMOXfcUaIb4/z7cq
         ITqpvGvig6aUx4gxLDz6Ex9bhDeMkwkUlLOW1dOygtmg9+zR29dsH+okknclF2cCTY
         bqF94uuE3eO30XgS/zaksPwY+Hp110oCpAeh2OPrNur7AawuCUNORqdxWZcdOIgB24
         ukrFf7/TIOU9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        Brendan Dolan-Gavitt <brendandg@nyu.edu>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 08/29] mwifiex: Fix skb_over_panic in mwifiex_usb_recv()
Date:   Mon, 17 Jan 2022 22:08:01 -0500
Message-Id: <20220118030822.1955469-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118030822.1955469-1-sashal@kernel.org>
References: <20220118030822.1955469-1-sashal@kernel.org>
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
 drivers/net/wireless/mwifiex/usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 1be7b219cb202..4cdf6450aeedd 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -132,7 +132,8 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
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

