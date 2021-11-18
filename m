Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215E0456521
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 22:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhKRVpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 16:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhKRVpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 16:45:52 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9575DC061574;
        Thu, 18 Nov 2021 13:42:51 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id a2so7560464qtx.11;
        Thu, 18 Nov 2021 13:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=bozUgf/JVDF2e98+kGGhI0ahPdp4o4xUb4tT8hjMa9U=;
        b=fH70x1KjXkm8uy3kmKPOTiZnE/rXw9bnp9IGFoT6JpzTna6lLNGEUDXFNUA5+k6CNR
         vNiFUuAD3BcGAXp8eoAvx0jtcU+pftXPljd4AOMGOjyn/QOb2ICo7/Qfa8DYFSV+OLuA
         CgQGXdEmZ7S8A9PcSGOT++N8of31R4Hki9/k0OeUZ+MaECZ3AX3jLkRLONiDCXGcr5A6
         uAHhw/js1ZOfXHwBvAbFyoFZAJ3Tp/lfQGxu2HJP52DG6M3aIboV82ruOOQm+PWJ5vSl
         vjhe1VAW2DD1Ip7q6PP/YgdwW8RY+987CoCdaVGO/FTgXGdDPpDdvkrKM4pv3cHkOKGk
         w6vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=bozUgf/JVDF2e98+kGGhI0ahPdp4o4xUb4tT8hjMa9U=;
        b=4aZJRLcJHqqdZJaYYsF50+PhlhRZHroNrvCOfVX/ntguaGIpM3SFXvvC3CeUgTiQtR
         a6dUN6WfC2d4O14fawzCDP4n7j8rny4CcrqiZnMLPZv1XXa1kWb3ziMH6qg4MsuIicFO
         a7xCY74mcjjhvf2dr/sMI9mmGEUW0kX797flq/xa133oITdhSNHWegZCeaOwYv6YRtPI
         DHtie+o1pdtCS/KyK66pXb+REiM6PSj/B2PBtvgSDSMJ2RoyWnOwkvuCCoTNqHFLonGM
         QewMZ7sAneKxPDSd7MEzniKtepZUtp2pYV3CSyOn9XoR46bG4t6d4XMBH0t6xASDxylK
         4T5g==
X-Gm-Message-State: AOAM531Ppf0S8R4jZL6KbXg3DZGki+88RfdzeVEVl6ltkI5I6miQuhq4
        PyAW6x12H/oE/DtJZtLS1ZnCNGe7nXV4QuU0
X-Google-Smtp-Source: ABdhPJx2j983TdsJHGBzYG1RBGVSh/tKIu6Ok29h5ntWsS4UxYP0c+eQXGFl2kzxAVfPBqMiMLLOHw==
X-Received: by 2002:ac8:57ca:: with SMTP id w10mr830467qta.88.1637271770675;
        Thu, 18 Nov 2021 13:42:50 -0800 (PST)
Received: from a-10-27-17-117.dynapool.vpn.nyu.edu (vpnrasa-wwh-pat-01.natpool.nyu.edu. [216.165.95.84])
        by smtp.gmail.com with ESMTPSA id t11sm528153qkm.96.2021.11.18.13.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 13:42:50 -0800 (PST)
Date:   Thu, 18 Nov 2021 16:42:47 -0500
From:   Zekun Shen <bruceshenzk@gmail.com>
To:     bruceshenzk@gmail.com
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        brendandg@nyu.edu
Subject: [PATCH] stmmac_pci: Fix underflow size in stmmac_rx
Message-ID: <YZbI12/g04GlzdIU@a-10-27-17-117.dynapool.vpn.nyu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d3f350c25b9b..bb35378d93bc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5164,12 +5164,13 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
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
2.25.1

