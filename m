Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA13212F48
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 15:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfECNd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 09:33:26 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:49187 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfECNdZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 09:33:25 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 44wY4227SZz9vFVh;
        Fri,  3 May 2019 15:33:22 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=MLCbpg9y; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id Tp_i2hZzxNse; Fri,  3 May 2019 15:33:22 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 44wY420zb5z9vFVd;
        Fri,  3 May 2019 15:33:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1556890402; bh=hTun7QmxD7QN3BZXt2ymPZq2huMQ5BkypWc0/gQLp/Q=;
        h=From:Subject:To:Cc:Date:From;
        b=MLCbpg9yyE/h6cG7ku7p0gW9ISgGHNoSLH2UbV3W80a1/gzOJ+sGSfNYbK5g2HqKP
         KePFyEeyHxmjEZ9i4wqS8eTGPDxgN+CdjbHfu3BSnnbGX1s6BYBZohNeyxg/POVULF
         LyAFWGyhYw/8or3YrRsYoeELV4NUOGHkO+iIhSuI=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 8A9298B91E;
        Fri,  3 May 2019 15:33:23 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id H7UEVSWKGAVB; Fri,  3 May 2019 15:33:23 +0200 (CEST)
Received: from po16846vm.idsi0.si.c-s.fr (po15451.idsi0.si.c-s.fr [172.25.231.6])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 54B6E8B906;
        Fri,  3 May 2019 15:33:23 +0200 (CEST)
Received: by po16846vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 33EF5672C7; Fri,  3 May 2019 13:33:23 +0000 (UTC)
Message-Id: <ba66f38ff44b95e82925fd0500eb32fe03895496.1556889892.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH] net: ucc_geth - fix Oops when changing number of buffers in
 the ring
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Date:   Fri,  3 May 2019 13:33:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When changing the number of buffers in the RX ring while the interface
is running, the following Oops is encountered due to the new number
of buffers being taken into account immediately while their allocation
is done when opening the device only.

[   69.882706] Unable to handle kernel paging request for data at address 0xf0000100
[   69.890172] Faulting instruction address: 0xc033e164
[   69.895122] Oops: Kernel access of bad area, sig: 11 [#1]
[   69.900494] BE PREEMPT CMPCPRO
[   69.907120] CPU: 0 PID: 0 Comm: swapper Not tainted 4.14.115-00006-g179ade8ce3-dirty #269
[   69.915956] task: c0684310 task.stack: c06da000
[   69.920470] NIP:  c033e164 LR: c02e44d0 CTR: c02e41fc
[   69.925504] REGS: dfff1e20 TRAP: 0300   Not tainted  (4.14.115-00006-g179ade8ce3-dirty)
[   69.934161] MSR:  00009032 <EE,ME,IR,DR,RI>  CR: 22004428  XER: 20000000
[   69.940869] DAR: f0000100 DSISR: 20000000
[   69.940869] GPR00: c0352d70 dfff1ed0 c0684310 f00000a4 00000040 dfff1f68 00000000 0000001f
[   69.940869] GPR08: df53f410 1cc00040 00000021 c0781640 42004424 100c82b6 f00000a4 df53f5b0
[   69.940869] GPR16: df53f6c0 c05daf84 00000040 00000000 00000040 c0782be4 00000000 00000001
[   69.940869] GPR24: 00000000 df53f400 000001b0 df53f410 df53f000 0000003f df708220 1cc00044
[   69.978348] NIP [c033e164] skb_put+0x0/0x5c
[   69.982528] LR [c02e44d0] ucc_geth_poll+0x2d4/0x3f8
[   69.987384] Call Trace:
[   69.989830] [dfff1ed0] [c02e4554] ucc_geth_poll+0x358/0x3f8 (unreliable)
[   69.996522] [dfff1f20] [c0352d70] net_rx_action+0x248/0x30c
[   70.002099] [dfff1f80] [c04e93e4] __do_softirq+0xfc/0x310
[   70.007492] [dfff1fe0] [c0021124] irq_exit+0xd0/0xd4
[   70.012458] [dfff1ff0] [c000e7e0] call_do_irq+0x24/0x3c
[   70.017683] [c06dbe80] [c0006bac] do_IRQ+0x64/0xc4
[   70.022474] [c06dbea0] [c001097c] ret_from_except+0x0/0x14
[   70.027964] --- interrupt: 501 at rcu_idle_exit+0x84/0x90
[   70.027964]     LR = rcu_idle_exit+0x74/0x90
[   70.037585] [c06dbf60] [20000000] 0x20000000 (unreliable)
[   70.042984] [c06dbf80] [c004bb0c] do_idle+0xb4/0x11c
[   70.047945] [c06dbfa0] [c004bd14] cpu_startup_entry+0x18/0x1c
[   70.053682] [c06dbfb0] [c05fb034] start_kernel+0x370/0x384
[   70.059153] [c06dbff0] [00003438] 0x3438
[   70.063062] Instruction dump:
[   70.066023] 38a00000 38800000 90010014 4bfff015 80010014 7c0803a6 3123ffff 7c691910
[   70.073767] 38210010 4e800020 38600000 4e800020 <80e3005c> 80c30098 3107ffff 7d083910
[   70.081690] ---[ end trace be7ccd9c1e1a9f12 ]---

This patch forbids the modification of the number of buffers in the
ring while the interface is running.

Fixes: ac421852b3a0 ("ucc_geth: add ethtool support")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
index 0beee2cc2ddd..722b6de24816 100644
--- a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
+++ b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
@@ -252,14 +252,12 @@ uec_set_ringparam(struct net_device *netdev,
 		return -EINVAL;
 	}
 
+	if (netif_running(netdev))
+		return -EBUSY;
+
 	ug_info->bdRingLenRx[queue] = ring->rx_pending;
 	ug_info->bdRingLenTx[queue] = ring->tx_pending;
 
-	if (netif_running(netdev)) {
-		/* FIXME: restart automatically */
-		netdev_info(netdev, "Please re-open the interface\n");
-	}
-
 	return ret;
 }
 
-- 
2.13.3

