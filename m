Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0EA2A594F
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731148AbgKCWGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731016AbgKCWGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:06:43 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB83CC061A04
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 14:06:42 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ka4Rs-0006Ui-VI; Tue, 03 Nov 2020 23:06:41 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 04/27] can: rx-offload: don't call kfree_skb() from IRQ context
Date:   Tue,  3 Nov 2020 23:06:13 +0100
Message-Id: <20201103220636.972106-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103220636.972106-1-mkl@pengutronix.de>
References: <20201103220636.972106-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A CAN driver, using the rx-offload infrastructure, is reading CAN frames
(usually in IRQ context) from the hardware and placing it into the rx-offload
queue to be delivered to the networking stack via NAPI.

In case the rx-offload queue is full, trying to add more skbs results in the
skbs being dropped using kfree_skb(). If done from hard-IRQ context this
results in the following warning:

[  682.552693] ------------[ cut here ]------------
[  682.557360] WARNING: CPU: 0 PID: 3057 at net/core/skbuff.c:650 skb_release_head_state+0x74/0x84
[  682.566075] Modules linked in: can_raw can coda_vpu flexcan dw_hdmi_ahb_audio v4l2_jpeg imx_vdoa can_dev
[  682.575597] CPU: 0 PID: 3057 Comm: cansend Tainted: G        W         5.7.0+ #18
[  682.583098] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[  682.589657] [<c0112628>] (unwind_backtrace) from [<c010c1c4>] (show_stack+0x10/0x14)
[  682.597423] [<c010c1c4>] (show_stack) from [<c06c481c>] (dump_stack+0xe0/0x114)
[  682.604759] [<c06c481c>] (dump_stack) from [<c0128f10>] (__warn+0xc0/0x10c)
[  682.611742] [<c0128f10>] (__warn) from [<c0129314>] (warn_slowpath_fmt+0x5c/0xc0)
[  682.619248] [<c0129314>] (warn_slowpath_fmt) from [<c0b95dec>] (skb_release_head_state+0x74/0x84)
[  682.628143] [<c0b95dec>] (skb_release_head_state) from [<c0b95e08>] (skb_release_all+0xc/0x24)
[  682.636774] [<c0b95e08>] (skb_release_all) from [<c0b95eac>] (kfree_skb+0x74/0x1c8)
[  682.644479] [<c0b95eac>] (kfree_skb) from [<bf001d1c>] (can_rx_offload_queue_sorted+0xe0/0xe8 [can_dev])
[  682.654051] [<bf001d1c>] (can_rx_offload_queue_sorted [can_dev]) from [<bf001d6c>] (can_rx_offload_get_echo_skb+0x48/0x94 [can_dev])
[  682.666007] [<bf001d6c>] (can_rx_offload_get_echo_skb [can_dev]) from [<bf01efe4>] (flexcan_irq+0x194/0x5dc [flexcan])
[  682.676734] [<bf01efe4>] (flexcan_irq [flexcan]) from [<c019c1ec>] (__handle_irq_event_percpu+0x4c/0x3ec)
[  682.686322] [<c019c1ec>] (__handle_irq_event_percpu) from [<c019c5b8>] (handle_irq_event_percpu+0x2c/0x88)
[  682.695993] [<c019c5b8>] (handle_irq_event_percpu) from [<c019c64c>] (handle_irq_event+0x38/0x5c)
[  682.704887] [<c019c64c>] (handle_irq_event) from [<c01a1058>] (handle_fasteoi_irq+0xc8/0x180)
[  682.713432] [<c01a1058>] (handle_fasteoi_irq) from [<c019b2c0>] (generic_handle_irq+0x30/0x44)
[  682.722063] [<c019b2c0>] (generic_handle_irq) from [<c019b8f8>] (__handle_domain_irq+0x64/0xdc)
[  682.730783] [<c019b8f8>] (__handle_domain_irq) from [<c06df4a4>] (gic_handle_irq+0x48/0x9c)
[  682.739158] [<c06df4a4>] (gic_handle_irq) from [<c0100b30>] (__irq_svc+0x70/0x98)
[  682.746656] Exception stack(0xe80e9dd8 to 0xe80e9e20)
[  682.751725] 9dc0:                                                       00000001 e80e8000
[  682.759922] 9de0: e820cf80 00000000 ffffe000 00000000 eaf08fe4 00000000 600d0013 00000000
[  682.768117] 9e00: c1732e3c c16093a8 e820d4c0 e80e9e28 c018a57c c018b870 600d0013 ffffffff
[  682.776315] [<c0100b30>] (__irq_svc) from [<c018b870>] (lock_acquire+0x108/0x4e8)
[  682.783821] [<c018b870>] (lock_acquire) from [<c0e938e4>] (down_write+0x48/0xa8)
[  682.791242] [<c0e938e4>] (down_write) from [<c02818dc>] (unlink_file_vma+0x24/0x40)
[  682.798922] [<c02818dc>] (unlink_file_vma) from [<c027a258>] (free_pgtables+0x34/0xb8)
[  682.806858] [<c027a258>] (free_pgtables) from [<c02835a4>] (exit_mmap+0xe4/0x170)
[  682.814361] [<c02835a4>] (exit_mmap) from [<c01248e0>] (mmput+0x5c/0x110)
[  682.821171] [<c01248e0>] (mmput) from [<c012e910>] (do_exit+0x374/0xbe4)
[  682.827892] [<c012e910>] (do_exit) from [<c0130888>] (do_group_exit+0x38/0xb4)
[  682.835132] [<c0130888>] (do_group_exit) from [<c0130914>] (__wake_up_parent+0x0/0x14)
[  682.843063] irq event stamp: 1936
[  682.846399] hardirqs last  enabled at (1935): [<c02938b0>] rmqueue+0xf4/0xc64
[  682.853553] hardirqs last disabled at (1936): [<c0100b20>] __irq_svc+0x60/0x98
[  682.860799] softirqs last  enabled at (1878): [<bf04cdcc>] raw_release+0x108/0x1f0 [can_raw]
[  682.869256] softirqs last disabled at (1876): [<c0b8f478>] release_sock+0x18/0x98
[  682.876753] ---[ end trace 7bca4751ce44c444 ]---

This patch fixes the problem by replacing the kfree_skb() by
dev_kfree_skb_any(), as rx-offload might be called from threaded IRQ handlers
as well.

Fixes: ca913f1ac024 ("can: rx-offload: can_rx_offload_queue_sorted(): fix error handling, avoid skb mem leak")
Fixes: 6caf8a6d6586 ("can: rx-offload: can_rx_offload_queue_tail(): fix error handling, avoid skb mem leak")
Link: http://lore.kernel.org/r/20201019190524.1285319-3-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rx-offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index 3b180269a92d..6e95193b215b 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -245,7 +245,7 @@ int can_rx_offload_queue_sorted(struct can_rx_offload *offload,
 
 	if (skb_queue_len(&offload->skb_queue) >
 	    offload->skb_queue_len_max) {
-		kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		return -ENOBUFS;
 	}
 
@@ -290,7 +290,7 @@ int can_rx_offload_queue_tail(struct can_rx_offload *offload,
 {
 	if (skb_queue_len(&offload->skb_queue) >
 	    offload->skb_queue_len_max) {
-		kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		return -ENOBUFS;
 	}
 
-- 
2.28.0

