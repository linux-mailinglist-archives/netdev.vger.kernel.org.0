Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDA446372F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242547AbhK3OwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:52:01 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56870 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242540AbhK3Ovl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:51:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8C572CE1A3B;
        Tue, 30 Nov 2021 14:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B1AC53FD2;
        Tue, 30 Nov 2021 14:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283695;
        bh=y8NOEcY5kDlImIPmiTHA40JZIwhnWyfL7nfO8ohA3ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NeArPvzwOCjeYtrdEIh1/dKBdN7wRmH09cyVUlGbCRiFbpc29ggighin7wbD4oNzu
         zC8lK2d+q0Voaf63Gh8WYsj/Suor95wq80QXuxr6YYFFqKSeJXj3p5MHeB8Qq0BSJj
         vCvVMtnMu2EhjIKoX5B2hmT2KC+5TKiUCXKSN4K4le+g8MAiu4dMrkMi4LFyjCE3sl
         7r5CGJa8HwKa7niy8Cmw2CrZrrxScPHCrwCunz4mRaOQUIf8YilvLBQuQyyF+FEi8d
         YTeNAYVsNyV+Ng95TZ4ueyDBCNdEDfKY7szX0BBS6N0lDAbLWiJN8JwbjkxOVnpwrD
         8xDUDGs4Y/Hew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        Brendan Dolan-Gavitt <brendandg@nyu.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        kuba@kernel.org, mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 22/68] stmmac_pci: Fix underflow size in stmmac_rx
Date:   Tue, 30 Nov 2021 09:46:18 -0500
Message-Id: <20211130144707.944580-22-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zekun Shen <bruceshenzk@gmail.com>

[ Upstream commit 0f296e782f21dc1c55475a3c107ac68ab09cc1cf ]

This bug report came up when we were testing the device driver
by fuzzing. It shows that buf1_len can get underflowed and be
0xfffffffc (4294967292).

This bug is triggerable with a compromised/malfunctioning device.
We found the bug through QEMU emulation tested the patch with
emulation. We did NOT test it on real hardware.

Attached is the bug report by fuzzing.

BUG: KASAN: use-after-free in stmmac_napi_poll_rx+0x1c08/0x36e0 [stmmac]
Read of size 4294967292 at addr ffff888016358000 by task ksoftirqd/0/9

CPU: 0 PID: 9 Comm: ksoftirqd/0 Tainted: G        W         5.6.0 #1
Call Trace:
 dump_stack+0x76/0xa0
 print_address_description.constprop.0+0x16/0x200
 ? stmmac_napi_poll_rx+0x1c08/0x36e0 [stmmac]
 ? stmmac_napi_poll_rx+0x1c08/0x36e0 [stmmac]
 __kasan_report.cold+0x37/0x7c
 ? stmmac_napi_poll_rx+0x1c08/0x36e0 [stmmac]
 kasan_report+0xe/0x20
 check_memory_region+0x15a/0x1d0
 memcpy+0x20/0x50
 stmmac_napi_poll_rx+0x1c08/0x36e0 [stmmac]
 ? stmmac_suspend+0x850/0x850 [stmmac]
 ? __next_timer_interrupt+0xba/0xf0
 net_rx_action+0x363/0xbd0
 ? call_timer_fn+0x240/0x240
 ? __switch_to_asm+0x40/0x70
 ? napi_busy_loop+0x520/0x520
 ? __schedule+0x839/0x15a0
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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0ab20e2f984b9..348ad489f154c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5153,12 +5153,13 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		if (likely(!(status & rx_not_ls)) &&
 		    (likely(priv->synopsys_id >= DWMAC_CORE_4_00) ||
 		     unlikely(status != llc_snap))) {
-			if (buf2_len)
+			if (buf2_len) {
 				buf2_len -= ETH_FCS_LEN;
-			else
+				len -= ETH_FCS_LEN;
+			} else if (buf1_len) {
 				buf1_len -= ETH_FCS_LEN;
-
-			len -= ETH_FCS_LEN;
+				len -= ETH_FCS_LEN;
+			}
 		}
 
 		if (!skb) {
-- 
2.33.0

