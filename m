Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF6418062B
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 14:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390583AbfHCMcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 08:32:03 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4164 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390359AbfHCMcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Aug 2019 08:32:03 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 847F6BB1ED0ED0E2D3AB;
        Sat,  3 Aug 2019 20:31:58 +0800 (CST)
Received: from huawei.com (10.67.189.167) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Sat, 3 Aug 2019
 20:31:50 +0800
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
To:     <davem@davemloft.net>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <xiaojiangfeng@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <leeyou.li@huawei.com>, <xiaowei774@huawei.com>,
        <nixiaoming@huawei.com>
Subject: [PATCH v1 1/3] net: hisilicon: make hip04_tx_reclaim non-reentrant
Date:   Sat, 3 Aug 2019 20:31:39 +0800
Message-ID: <1564835501-90257-2-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: git-send-email 1.8.5.6
In-Reply-To: <1564835501-90257-1-git-send-email-xiaojiangfeng@huawei.com>
References: <1564835501-90257-1-git-send-email-xiaojiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.167]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If hip04_tx_reclaim is interrupted while it is running
and then __napi_schedule continues to execute
hip04_rx_poll->hip04_tx_reclaim, reentrancy occurs
and oops is generated. So you need to mask the interrupt
during the hip04_tx_reclaim run.

The kernel oops exception stack is as follows:

Unable to handle kernel NULL pointer dereference
at virtual address 00000050
pgd = c0003000
[00000050] *pgd=80000000a04003, *pmd=00000000
Internal error: Oops: 206 [#1] SMP ARM
Modules linked in: hip04_eth mtdblock mtd_blkdevs mtd
ohci_platform ehci_platform ohci_hcd ehci_hcd
vfat fat sd_mod usb_storage scsi_mod usbcore usb_common
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           O    4.4.185 #1
Hardware name: Hisilicon A15
task: c0a250e0 task.stack: c0a00000
PC is at hip04_tx_reclaim+0xe0/0x17c [hip04_eth]
LR is at hip04_tx_reclaim+0x30/0x17c [hip04_eth]
pc : [<bf30c3a4>]    lr : [<bf30c2f4>]    psr: 600e0313
sp : c0a01d88  ip : 00000000  fp : c0601f9c
r10: 00000000  r9 : c3482380  r8 : 00000001
r7 : 00000000  r6 : 000000e1  r5 : c3482000  r4 : 0000000c
r3 : f2209800  r2 : 00000000  r1 : 00000000  r0 : 00000000
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 32c5387d  Table: 03d28c80  DAC: 55555555
Process swapper/0 (pid: 0, stack limit = 0xc0a00190)
Stack: (0xc0a01d88 to 0xc0a02000)
[<bf30c3a4>] (hip04_tx_reclaim [hip04_eth]) from [<bf30d2e0>]
                                                (hip04_rx_poll+0x88/0x368 [hip04_eth])
[<bf30d2e0>] (hip04_rx_poll [hip04_eth]) from [<c04c2d9c>] (net_rx_action+0x114/0x34c)
[<c04c2d9c>] (net_rx_action) from [<c021eed8>] (__do_softirq+0x218/0x318)
[<c021eed8>] (__do_softirq) from [<c021f284>] (irq_exit+0x88/0xac)
[<c021f284>] (irq_exit) from [<c0240090>] (msa_irq_exit+0x11c/0x1d4)
[<c0240090>] (msa_irq_exit) from [<c02677e0>] (__handle_domain_irq+0x110/0x148)
[<c02677e0>] (__handle_domain_irq) from [<c0201588>] (gic_handle_irq+0xd4/0x118)
[<c0201588>] (gic_handle_irq) from [<c0551700>] (__irq_svc+0x40/0x58)
Exception stack(0xc0a01f30 to 0xc0a01f78)
1f20:                                     c0ae8b40 00000000 00000000 00000000
1f40: 00000002 ffffe000 c0601f9c 00000000 ffffffff c0a2257c c0a22440 c0831a38
1f60: c0a01ec4 c0a01f80 c0203714 c0203718 600e0213 ffffffff
[<c0551700>] (__irq_svc) from [<c0203718>] (arch_cpu_idle+0x20/0x3c)
[<c0203718>] (arch_cpu_idle) from [<c025bfd8>] (cpu_startup_entry+0x244/0x29c)
[<c025bfd8>] (cpu_startup_entry) from [<c054b0d8>] (rest_init+0xc8/0x10c)
[<c054b0d8>] (rest_init) from [<c0800c58>] (start_kernel+0x468/0x514)
Code: a40599e5 016086e2 018088e2 7660efe6 (503090e5)
---[ end trace 1db21d6d09c49d74 ]---
Kernel panic - not syncing: Fatal exception in interrupt
CPU3: stopping
CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D    O    4.4.185 #1

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index d604528..1e1b154 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -585,6 +585,9 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
 	u16 len;
 	u32 err;
 
+	/* clean up tx descriptors */
+	tx_remaining = hip04_tx_reclaim(ndev, false);
+
 	while (cnt && !last) {
 		buf = priv->rx_buf[priv->rx_head];
 		skb = build_skb(buf, priv->rx_buf_size);
@@ -645,8 +648,7 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
 	}
 	napi_complete_done(napi, rx);
 done:
-	/* clean up tx descriptors and start a new timer if necessary */
-	tx_remaining = hip04_tx_reclaim(ndev, false);
+	/* start a new timer if necessary */
 	if (rx < budget && tx_remaining)
 		hip04_start_tx_timer(priv);
 
-- 
1.8.5.6

