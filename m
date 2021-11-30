Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E574638E2
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244585AbhK3PGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243504AbhK3O4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:56:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEC2C061D7E;
        Tue, 30 Nov 2021 06:51:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01A49CE1A4C;
        Tue, 30 Nov 2021 14:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A01EC53FCD;
        Tue, 30 Nov 2021 14:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283859;
        bh=+ug5frNLAhWmKn65zvB3H/+90mRBptjXOvLo4yejWA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJzYvxevuXGtVmWwPS38XGNkrQGdqC9SZ62tp123+wPt6MEScy526GCZimAakuQtm
         OWXtjWQyP8gY4/EnQvennnEIwZA97FUcKOZFy7+Dykn+SdvhJIwu1nNuMwecM8Hnbq
         3TcI5nK7OiZhL6qVdS2+ZHYq7OQKUx6f6PEbGRW8cKH6IpFyIZZdRukScyJnX130N8
         vIaOhs7QaKIA82YVTjdKEszD6trKuOasphNIQtQOpkok/XP60PUgkL4RB4lPm+Ph1M
         kLoRlzfxcERUul6olO1UUPZHDWWRMmhPHHlWmmsVHZ3SCMG2h6fBiiWs1D7hHdXJbW
         sZphZeOVo5vWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        Brendan Dolan-Gavitt <brendandg@nyu.edu>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 14/43] atlantic: fix double-free in aq_ring_tx_clean
Date:   Tue, 30 Nov 2021 09:49:51 -0500
Message-Id: <20211130145022.945517-14-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zekun Shen <bruceshenzk@gmail.com>

[ Upstream commit 6a405f6c372d14707b87d3097b361b69899a26c8 ]

We found this bug while fuzzing the device driver. Using and freeing
the dangling pointer buff->skb would cause use-after-free and
double-free.

This bug is triggerable with compromised/malfunctioning devices. We
found the bug with QEMU emulation and tested the patch by emulation.
We did NOT test on a real device.

Attached is the bug report.

BUG: KASAN: double-free or invalid-free in consume_skb+0x6c/0x1c0

Call Trace:
 dump_stack+0x76/0xa0
 print_address_description.constprop.0+0x16/0x200
 ? consume_skb+0x6c/0x1c0
 kasan_report_invalid_free+0x61/0xa0
 ? consume_skb+0x6c/0x1c0
 __kasan_slab_free+0x15e/0x170
 ? consume_skb+0x6c/0x1c0
 kfree+0x8c/0x230
 consume_skb+0x6c/0x1c0
 aq_ring_tx_clean+0x5c2/0xa80 [atlantic]
 aq_vec_poll+0x309/0x5d0 [atlantic]
 ? _sub_I_65535_1+0x20/0x20 [atlantic]
 ? __next_timer_interrupt+0xba/0xf0
 net_rx_action+0x363/0xbd0
 ? call_timer_fn+0x240/0x240
 ? __switch_to_asm+0x34/0x70
 ? napi_busy_loop+0x520/0x520
 ? net_tx_action+0x379/0x720
 __do_softirq+0x18c/0x634
 ? takeover_tasklets+0x5f0/0x5f0
 run_ksoftirqd+0x15/0x20
 smpboot_thread_fn+0x2f1/0x6b0
 ? smpboot_unregister_percpu_thread+0x160/0x160
 ? __kthread_parkme+0x80/0x100
 ? smpboot_unregister_percpu_thread+0x160/0x160
 kthread+0x2b5/0x3b0
 ? kthread_create_on_node+0xd0/0xd0
 ret_from_fork+0x22/0x40

Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
Reviewed-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 24122ccda614c..81b3756417ec2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -298,13 +298,14 @@ bool aq_ring_tx_clean(struct aq_ring_s *self)
 			}
 		}
 
-		if (unlikely(buff->is_eop)) {
+		if (unlikely(buff->is_eop && buff->skb)) {
 			u64_stats_update_begin(&self->stats.tx.syncp);
 			++self->stats.tx.packets;
 			self->stats.tx.bytes += buff->skb->len;
 			u64_stats_update_end(&self->stats.tx.syncp);
 
 			dev_kfree_skb_any(buff->skb);
+			buff->skb = NULL;
 		}
 		buff->pa = 0U;
 		buff->eop_index = 0xffffU;
-- 
2.33.0

