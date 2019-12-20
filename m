Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A094212809E
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 17:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfLTQ0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 11:26:50 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:53298 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727388AbfLTQ0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 11:26:49 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BA21B4C007B;
        Fri, 20 Dec 2019 16:26:47 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 20 Dec
 2019 16:26:42 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net 1/2] sfc: fix channel allocation with brute force
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <83c50994-18de-1d8f-67ce-b2322d226338@solarflare.com>
Message-ID: <dff9426f-c2e9-155c-4ee9-fc85dcbfbee1@solarflare.com>
Date:   Fri, 20 Dec 2019 16:26:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <83c50994-18de-1d8f-67ce-b2322d226338@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25114.003
X-TM-AS-Result: No-2.679600-8.000000-10
X-TMASE-MatchedRID: cTHn5jPiQZFiFXimBohg2TdfT4zyWoZSnrrV5UnUVY0B6+sPKj8EHKRG
        wX+NnBzgQzArtCOFCW4TiuGHAXN+1FfLVfbg7RvGIwk7p1qp3Jbwq1JQ5xF4krbirXPJS6s8r9Y
        /9i+8T9aF35Y+5Kr9cQutau39oYxDdBxnS9vVxvZuh7qwx+D6Twe5TGeGLGZP0SxMhOhuA0Rhn7
        T+c//ExiNxrxm6z+0qotvMT3aEnKCqgfwTRO/Tzhwu4QM/6Cpy3FYvKmZiVnNJfyfUaPjAAYvN+
        tnJlZmAMUcnR685wFw0uSYsteWBcgihmwiXCMoGPwKTD1v8YV5MkOX0UoduuVVkJxysad/IBl2L
        1/XRW5ypBBSPp0P4E6XxutkwBXxjtwikmZUyhU/uykw7cfAoIBiDIOPlOJG14w7R7P4I0tLPWHp
        UlNKF7K3Kpn6wAC89hgmjX17TATClVxitbVRsrglpVkdtt3WuAgvM6h73BtoJeMOJX8c9nO734x
        6nzMNil83wBMpcDeeRk6XtYogiau9c69BWUTGwbdTuPa9VRGvEQdG7H66TyHEqm8QYBtMOfdnpX
        43he5jJa7mGHqzYiJIZ9NOB3CvadLJbHuTGT9jkBdTCEkKxiya6JBX7lVlEvsMSweOJ8W/Xt9p5
        MHTNWeYMKhKgfjhHGhBWFwMpQfUlEjOZsGnBpCAkKbrKkYtniQWaoMYDBaY=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.679600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25114.003
X-MDID: 1576859208-bSNxntv5hxh4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was possible for channel allocation logic to get confused between what
 it had and what it wanted, and end up trying to use the same channel for
 both PTP and regular TX.  This led to a kernel panic:
    BUG: unable to handle page fault for address: 0000000000047635
    #PF: supervisor write access in kernel mode
    #PF: error_code(0x0002) - not-present page
    PGD 0 P4D 0
    Oops: 0002 [#1] SMP PTI
    CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W         5.4.0-rc3-ehc14+ #900
    Hardware name: Dell Inc. PowerEdge R710/0M233H, BIOS 6.4.0 07/23/2013
    RIP: 0010:native_queued_spin_lock_slowpath+0x188/0x1e0
    Code: f3 90 48 8b 32 48 85 f6 74 f6 eb e8 c1 ee 12 83 e0 03 83 ee 01 48 c1 e0 05 48 63 f6 48 05 c0 98 02 00 48 03 04 f5 a0 c6 ed 81 <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 32
    RSP: 0018:ffffc90000003d28 EFLAGS: 00010006
    RAX: 0000000000047635 RBX: 0000000000000246 RCX: 0000000000040000
    RDX: ffff888627a298c0 RSI: 0000000000003ffe RDI: ffff88861f6b8dd4
    RBP: ffff8886225c6e00 R08: 0000000000040000 R09: 0000000000000000
    R10: 0000000616f080c6 R11: 00000000000000c0 R12: ffff88861f6b8dd4
    R13: ffffc90000003dc8 R14: ffff88861942bf00 R15: ffff8886150f2000
    FS:  0000000000000000(0000) GS:ffff888627a00000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000000000047635 CR3: 000000000200a000 CR4: 00000000000006f0
    Call Trace:
     <IRQ>
     _raw_spin_lock_irqsave+0x22/0x30
     skb_queue_tail+0x1b/0x50
     sock_queue_err_skb+0x9d/0xf0
     __skb_complete_tx_timestamp+0x9d/0xc0
     efx_dequeue_buffer+0x126/0x180 [sfc]
     efx_xmit_done+0x73/0x1c0 [sfc]
     efx_ef10_ev_process+0x56a/0xfe0 [sfc]
     ? tick_sched_do_timer+0x60/0x60
     ? timerqueue_add+0x5d/0x70
     ? enqueue_hrtimer+0x39/0x90
     efx_poll+0x111/0x380 [sfc]
     ? rcu_accelerate_cbs+0x50/0x160
     net_rx_action+0x14a/0x400
     __do_softirq+0xdd/0x2d0
     irq_exit+0xa0/0xb0
     do_IRQ+0x53/0xe0
     common_interrupt+0xf/0xf
     </IRQ>

In the long run we intend to rewrite the channel allocation code, but for
 'net' fix this by allocating extra_channels, and giving them TX queues,
 even if we do not in fact need them (e.g. on NICs without MAC TX
 timestamping), and thereby using simpler logic to assign the channels
 once they're allocated.

Fixes: 3990a8fffbda ("sfc: allocate channels for XDP tx queues")
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c        | 37 +++++++++++++--------------
 drivers/net/ethernet/sfc/net_driver.h |  4 +--
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 992c773620ec..7a38d7f282a1 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1472,6 +1472,12 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 	n_xdp_tx = num_possible_cpus();
 	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, EFX_TXQ_TYPES);
 
+	vec_count = pci_msix_vec_count(efx->pci_dev);
+	if (vec_count < 0)
+		return vec_count;
+
+	max_channels = min_t(unsigned int, vec_count, max_channels);
+
 	/* Check resources.
 	 * We need a channel per event queue, plus a VI per tx queue.
 	 * This may be more pessimistic than it needs to be.
@@ -1493,11 +1499,6 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 			  n_xdp_tx, n_xdp_ev);
 	}
 
-	n_channels = min(n_channels, max_channels);
-
-	vec_count = pci_msix_vec_count(efx->pci_dev);
-	if (vec_count < 0)
-		return vec_count;
 	if (vec_count < n_channels) {
 		netif_err(efx, drv, efx->net_dev,
 			  "WARNING: Insufficient MSI-X vectors available (%d < %u).\n",
@@ -1507,11 +1508,9 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 		n_channels = vec_count;
 	}
 
-	efx->n_channels = n_channels;
+	n_channels = min(n_channels, max_channels);
 
-	/* Do not create the PTP TX queue(s) if PTP uses the MC directly. */
-	if (extra_channels && !efx_ptp_use_mac_tx_timestamps(efx))
-		n_channels--;
+	efx->n_channels = n_channels;
 
 	/* Ignore XDP tx channels when creating rx channels. */
 	n_channels -= efx->n_xdp_channels;
@@ -1531,11 +1530,10 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 		efx->n_rx_channels = n_channels;
 	}
 
-	if (efx->n_xdp_channels)
-		efx->xdp_channel_offset = efx->tx_channel_offset +
-					  efx->n_tx_channels;
-	else
-		efx->xdp_channel_offset = efx->n_channels;
+	efx->n_rx_channels = min(efx->n_rx_channels, parallelism);
+	efx->n_tx_channels = min(efx->n_tx_channels, parallelism);
+
+	efx->xdp_channel_offset = n_channels;
 
 	netif_dbg(efx, drv, efx->net_dev,
 		  "Allocating %u RX channels\n",
@@ -1550,6 +1548,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 static int efx_probe_interrupts(struct efx_nic *efx)
 {
 	unsigned int extra_channels = 0;
+	unsigned int rss_spread;
 	unsigned int i, j;
 	int rc;
 
@@ -1631,8 +1630,7 @@ static int efx_probe_interrupts(struct efx_nic *efx)
 	for (i = 0; i < EFX_MAX_EXTRA_CHANNELS; i++) {
 		if (!efx->extra_channel_type[i])
 			continue;
-		if (efx->interrupt_mode != EFX_INT_MODE_MSIX ||
-		    efx->n_channels <= extra_channels) {
+		if (j <= efx->tx_channel_offset + efx->n_tx_channels) {
 			efx->extra_channel_type[i]->handle_no_channel(efx);
 		} else {
 			--j;
@@ -1643,16 +1641,17 @@ static int efx_probe_interrupts(struct efx_nic *efx)
 		}
 	}
 
+	rss_spread = efx->n_rx_channels;
 	/* RSS might be usable on VFs even if it is disabled on the PF */
 #ifdef CONFIG_SFC_SRIOV
 	if (efx->type->sriov_wanted) {
-		efx->rss_spread = ((efx->n_rx_channels > 1 ||
+		efx->rss_spread = ((rss_spread > 1 ||
 				    !efx->type->sriov_wanted(efx)) ?
-				   efx->n_rx_channels : efx_vf_size(efx));
+				   rss_spread : efx_vf_size(efx));
 		return 0;
 	}
 #endif
-	efx->rss_spread = efx->n_rx_channels;
+	efx->rss_spread = rss_spread;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 1f88212be085..dfd5182d9e47 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1533,9 +1533,7 @@ static inline bool efx_channel_is_xdp_tx(struct efx_channel *channel)
 
 static inline bool efx_channel_has_tx_queues(struct efx_channel *channel)
 {
-	return efx_channel_is_xdp_tx(channel) ||
-	       (channel->type && channel->type->want_txqs &&
-		channel->type->want_txqs(channel));
+	return true;
 }
 
 static inline struct efx_tx_queue *

