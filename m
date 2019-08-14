Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F33828C847
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbfHNCaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:30:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727302AbfHNCRV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:17:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33CEA20843;
        Wed, 14 Aug 2019 02:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749040;
        bh=Bxrj4Oq4PbybT5IomXenT8sU7chCRKb66GKZVQ+kHuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPAWqKbCINywA4IWIKYZ+xNLdnDkEtA9CjiGz1atyPyZKzwFGg+K1P32KqioZ7LTH
         p2HuIh5vSz3pCl95JHeynjp2fG9ve1+zDomqY1ov5Ja8wT6W0QA1ZVjAhI2Pft+tfG
         p4NASU3VLkrrVxVOCguw/xnEbsG0/N6hyVNCNXnA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiangfeng Xiao <xiaojiangfeng@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 55/68] net: hisilicon: make hip04_tx_reclaim non-reentrant
Date:   Tue, 13 Aug 2019 22:15:33 -0400
Message-Id: <20190814021548.16001-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>

[ Upstream commit 1a2c070ae805910a853b4a14818481ed2e17c727 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 6127697ede120..57c0afa25f9fb 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -497,6 +497,9 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
 	u16 len;
 	u32 err;
 
+	/* clean up tx descriptors */
+	tx_remaining = hip04_tx_reclaim(ndev, false);
+
 	while (cnt && !last) {
 		buf = priv->rx_buf[priv->rx_head];
 		skb = build_skb(buf, priv->rx_buf_size);
@@ -557,8 +560,7 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
 	}
 	napi_complete_done(napi, rx);
 done:
-	/* clean up tx descriptors and start a new timer if necessary */
-	tx_remaining = hip04_tx_reclaim(ndev, false);
+	/* start a new timer if necessary */
 	if (rx < budget && tx_remaining)
 		hip04_start_tx_timer(priv);
 
-- 
2.20.1

