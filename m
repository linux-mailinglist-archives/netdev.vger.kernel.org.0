Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE7023CE34
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 20:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgHESUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 14:20:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39478 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729209AbgHESTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 14:19:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596651563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sGspvq2bANhw7H74r6YT1ZIMx3dmhcJZp7Gu5pxscH0=;
        b=HgD+yrQ/5/Z3Zm1l3sRnzBegzgzTF8v8gB3w3lMzQtigDL753w51ZaTvKcjSuV+C94XeKq
        3MqiH6uybqGY+AzvVnlztN1PJVzcqk0yddMHKZqkLR+Nh5lfOVlV4Ik5o3Ta+Yn5NkgxUS
        scmutzGtEE/Cw1SgvUhJoO87G/d7H9s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-onEicqqQN6mImgqZpJqVwA-1; Wed, 05 Aug 2020 14:19:22 -0400
X-MC-Unique: onEicqqQN6mImgqZpJqVwA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD60980BCD0;
        Wed,  5 Aug 2020 18:19:20 +0000 (UTC)
Received: from blue.redhat.com (ovpn-112-186.phx2.redhat.com [10.3.112.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 253752E020;
        Wed,  5 Aug 2020 18:19:20 +0000 (UTC)
From:   Dean Nelson <dnelson@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Sunil Goutham <sgoutham@marvell.com>,
        Robert Richter <rrichter@marvell.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next] net: thunderx: initialize VF's mailbox mutex before first usage
Date:   Wed,  5 Aug 2020 13:18:48 -0500
Message-Id: <20200805181848.237132-1-dnelson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A VF's mailbox mutex is not getting initialized by nicvf_probe() until after
it is first used. And such usage is resulting in...

[   28.270927] ------------[ cut here ]------------
[   28.270934] DEBUG_LOCKS_WARN_ON(lock->magic != lock)
[   28.270980] WARNING: CPU: 9 PID: 675 at kernel/locking/mutex.c:938 __mutex_lock+0xdac/0x12f0
[   28.270985] Modules linked in: ast(+) nicvf(+) i2c_algo_bit drm_vram_helper drm_ttm_helper ttm nicpf(+) drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm ixgbe(+) sg thunder_bgx mdio i2c_thunderx mdio_thunder thunder_xcv mdio_cavium dm_mirror dm_region_hash dm_log dm_mod
[   28.271064] CPU: 9 PID: 675 Comm: systemd-udevd Not tainted 4.18.0+ #1
[   28.271070] Hardware name: GIGABYTE R120-T34-00/MT30-GS2-00, BIOS F02 08/06/2019
[   28.271078] pstate: 60000005 (nZCv daif -PAN -UAO)
[   28.271086] pc : __mutex_lock+0xdac/0x12f0
[   28.271092] lr : __mutex_lock+0xdac/0x12f0
[   28.271097] sp : ffff800d42146fb0
[   28.271103] x29: ffff800d42146fb0 x28: 0000000000000000
[   28.271113] x27: ffff800d24361180 x26: dfff200000000000
[   28.271122] x25: 0000000000000000 x24: 0000000000000002
[   28.271132] x23: ffff20001597cc80 x22: ffff2000139e9848
[   28.271141] x21: 0000000000000000 x20: 1ffff001a8428e0c
[   28.271151] x19: ffff200015d5d000 x18: 1ffff001ae0f2184
[   28.271160] x17: 0000000000000000 x16: 0000000000000000
[   28.271170] x15: ffff800d70790c38 x14: ffff20001597c000
[   28.271179] x13: ffff20001597cc80 x12: ffff040002b2f779
[   28.271189] x11: 1fffe40002b2f778 x10: ffff040002b2f778
[   28.271199] x9 : 0000000000000000 x8 : 00000000f1f1f1f1
[   28.271208] x7 : 00000000f2f2f2f2 x6 : 0000000000000000
[   28.271217] x5 : 1ffff001ae0f2186 x4 : 1fffe400027eb03c
[   28.271227] x3 : dfff200000000000 x2 : ffff1001a8428dbe
[   28.271237] x1 : c87fdfac7ea11d00 x0 : 0000000000000000
[   28.271246] Call trace:
[   28.271254]  __mutex_lock+0xdac/0x12f0
[   28.271261]  mutex_lock_nested+0x3c/0x50
[   28.271297]  nicvf_send_msg_to_pf+0x40/0x3a0 [nicvf]
[   28.271316]  nicvf_register_misc_interrupt+0x20c/0x328 [nicvf]
[   28.271334]  nicvf_probe+0x508/0xda0 [nicvf]
[   28.271344]  local_pci_probe+0xc4/0x180
[   28.271352]  pci_device_probe+0x3ec/0x528
[   28.271363]  driver_probe_device+0x21c/0xb98
[   28.271371]  device_driver_attach+0xe8/0x120
[   28.271379]  __driver_attach+0xe0/0x2a0
[   28.271386]  bus_for_each_dev+0x118/0x190
[   28.271394]  driver_attach+0x48/0x60
[   28.271401]  bus_add_driver+0x328/0x558
[   28.271409]  driver_register+0x148/0x398
[   28.271416]  __pci_register_driver+0x14c/0x1b0
[   28.271437]  nicvf_init_module+0x54/0x10000 [nicvf]
[   28.271447]  do_one_initcall+0x18c/0xc18
[   28.271457]  do_init_module+0x18c/0x618
[   28.271464]  load_module+0x2bc0/0x4088
[   28.271472]  __se_sys_finit_module+0x110/0x188
[   28.271479]  __arm64_sys_finit_module+0x70/0xa0
[   28.271490]  el0_svc_handler+0x15c/0x380
[   28.271496]  el0_svc+0x8/0xc
[   28.271502] irq event stamp: 52649
[   28.271513] hardirqs last  enabled at (52649): [<ffff200011b4d790>] _raw_spin_unlock_irqrestore+0xc0/0xd8
[   28.271522] hardirqs last disabled at (52648): [<ffff200011b4d3c4>] _raw_spin_lock_irqsave+0x3c/0xf0
[   28.271530] softirqs last  enabled at (52330): [<ffff200010082af4>] __do_softirq+0xacc/0x117c
[   28.271540] softirqs last disabled at (52313): [<ffff20001019b354>] irq_exit+0x3cc/0x500
[   28.271545] ---[ end trace a9b90324c8a0d4ee ]---

This problem is resolved by moving the call to mutex_init() up earlier
in nicvf_probe().

Fixes: 609ea65c65a0 ("net: thunderx: add mutex to protect mailbox from concurrent calls for same VF")
Signed-off-by: Dean Nelson <dnelson@redhat.com>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index d22c9d350355..c1378b5c780c 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2177,6 +2177,9 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		nic->max_queues *= 2;
 	nic->ptp_clock = ptp_clock;
 
+	/* Initialize mutex that serializes usage of VF's mailbox */
+	mutex_init(&nic->rx_mode_mtx);
+
 	/* MAP VF's configuration registers */
 	nic->reg_base = pcim_iomap(pdev, PCI_CFG_REG_BAR_NUM, 0);
 	if (!nic->reg_base) {
@@ -2253,7 +2256,6 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	INIT_WORK(&nic->rx_mode_work.work, nicvf_set_rx_mode_task);
 	spin_lock_init(&nic->rx_mode_wq_lock);
-	mutex_init(&nic->rx_mode_mtx);
 
 	err = register_netdev(netdev);
 	if (err) {
-- 
2.26.2

