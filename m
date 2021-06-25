Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F823B3F42
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 10:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhFYIaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 04:30:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51981 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230050AbhFYIaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 04:30:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624609674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IV+VmA/elBSs786WpbHfNowCubs6ZCeMxoRo6uDG+4c=;
        b=Urnq9JO63x0nblnNlmhwXKqWymHtoZJzRGfxl7Qeyw5pudAwX875XgcFd1UMxnPH2wCel4
        x6K2FFxl8dUe1rrWdcJhouCzOvqrP3R++tz4BxOEsUb1zN2XQ5EA3Ec1VNq+NvkQMprBmL
        6prZti9wgbPKmo5mRAxVBwHSQUuXH14=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-v1G7-ABAPWCGMqXn5rU5nw-1; Fri, 25 Jun 2021 04:27:50 -0400
X-MC-Unique: v1G7-ABAPWCGMqXn5rU5nw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA3D0804141;
        Fri, 25 Jun 2021 08:27:48 +0000 (UTC)
Received: from hive.redhat.com (ovpn-113-96.ams2.redhat.com [10.36.113.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57C8B5D9F0;
        Fri, 25 Jun 2021 08:27:46 +0000 (UTC)
From:   Petr Oros <poros@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        davem@davemloft.net, kuba@kernel.org, kda@linux-powerpc.org
Subject: [PATCH net] Revert "be2net: disable bh with spin_lock in be_process_mcc"
Date:   Fri, 25 Jun 2021 10:27:45 +0200
Message-Id: <20210625082745.1761296-1-poros@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch was based on wrong presumption that be_poll can be called only
from bh context. It reintroducing old regression (also reverted) and
causing deadlock when we use netconsole with benet in bonding.

Old revert: commit 072a9c486004 ("netpoll: revert 6bdb7fe3104 and fix
be_poll() instead")

[  331.269715] bond0: (slave enp0s7f0): Releasing backup interface
[  331.270121] CPU: 4 PID: 1479 Comm: ifenslave Not tainted 5.13.0-rc7+ #2
[  331.270122] Call Trace:
[  331.270122] [c00000001789f200] [c0000000008c505c] dump_stack+0x100/0x174 (unreliable)
[  331.270124] [c00000001789f240] [c008000001238b9c] be_poll+0x64/0xe90 [be2net]
[  331.270125] [c00000001789f330] [c000000000d1e6e4] netpoll_poll_dev+0x174/0x3d0
[  331.270127] [c00000001789f400] [c008000001bc167c] bond_poll_controller+0xb4/0x130 [bonding]
[  331.270128] [c00000001789f450] [c000000000d1e624] netpoll_poll_dev+0xb4/0x3d0
[  331.270129] [c00000001789f520] [c000000000d1ed88] netpoll_send_skb+0x448/0x470
[  331.270130] [c00000001789f5d0] [c0080000011f14f8] write_msg+0x180/0x1b0 [netconsole]
[  331.270131] [c00000001789f640] [c000000000230c0c] console_unlock+0x54c/0x790
[  331.270132] [c00000001789f7b0] [c000000000233098] vprintk_emit+0x2d8/0x450
[  331.270133] [c00000001789f810] [c000000000234758] vprintk+0xc8/0x270
[  331.270134] [c00000001789f850] [c000000000233c28] printk+0x40/0x54
[  331.270135] [c00000001789f870] [c000000000ccf908] __netdev_printk+0x150/0x198
[  331.270136] [c00000001789f910] [c000000000ccfdb4] netdev_info+0x68/0x94
[  331.270137] [c00000001789f950] [c008000001bcbd70] __bond_release_one+0x188/0x6b0 [bonding]
[  331.270138] [c00000001789faa0] [c008000001bcc6f4] bond_do_ioctl+0x42c/0x490 [bonding]
[  331.270139] [c00000001789fb60] [c000000000d0d17c] dev_ifsioc+0x17c/0x400
[  331.270140] [c00000001789fbc0] [c000000000d0db70] dev_ioctl+0x390/0x890
[  331.270141] [c00000001789fc10] [c000000000c7c76c] sock_do_ioctl+0xac/0x1b0
[  331.270142] [c00000001789fc90] [c000000000c7ffac] sock_ioctl+0x31c/0x6e0
[  331.270143] [c00000001789fd60] [c0000000005b9728] sys_ioctl+0xf8/0x150
[  331.270145] [c00000001789fdb0] [c0000000000336c0] system_call_exception+0x160/0x2f0
[  331.270146] [c00000001789fe10] [c00000000000d35c] system_call_common+0xec/0x278
[  331.270147] --- interrupt: c00 at 0x7fffa6c6ec00
[  331.270147] NIP:  00007fffa6c6ec00 LR: 0000000105c4185c CTR: 0000000000000000
[  331.270148] REGS: c00000001789fe80 TRAP: 0c00   Not tainted  (5.13.0-rc7+)
[  331.270148] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 28000428  XER: 00000000
[  331.270155] IRQMASK: 0
[  331.270156] GPR00: 0000000000000036 00007fffd494d5b0 00007fffa6d57100 0000000000000003
[  331.270158] GPR04: 0000000000008991 00007fffd494d6d0 0000000000000008 00007fffd494f28c
[  331.270161] GPR08: 0000000000000003 0000000000000000 0000000000000000 0000000000000000
[  331.270164] GPR12: 0000000000000000 00007fffa6dfa220 0000000000000000 0000000000000000
[  331.270167] GPR16: 0000000105c44880 0000000000000000 0000000105c60088 0000000105c60318
[  331.270170] GPR20: 0000000105c602c0 0000000105c44560 0000000000000000 0000000000000000
[  331.270172] GPR24: 00007fffd494dc50 00007fffd494d6a8 0000000105c60008 00007fffd494d6d0
[  331.270175] GPR28: 00007fffd494f27e 0000000105c6026c 00007fffd494f284 0000000000000000
[  331.270178] NIP [00007fffa6c6ec00] 0x7fffa6c6ec00
[  331.270178] LR [0000000105c4185c] 0x105c4185c
[  331.270179] --- interrupt: c00

This reverts commit d0d006a43e9a7a796f6f178839c92fcc222c564d.

Fixes: d0d006a43e9a7a ("be2net: disable bh with spin_lock in be_process_mcc")
Signed-off-by: Petr Oros <poros@redhat.com>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c | 6 ++++--
 drivers/net/ethernet/emulex/benet/be_main.c | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 701c12c9e03371..649c5c429bd7cf 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -550,7 +550,7 @@ int be_process_mcc(struct be_adapter *adapter)
 	int num = 0, status = 0;
 	struct be_mcc_obj *mcc_obj = &adapter->mcc_obj;
 
-	spin_lock_bh(&adapter->mcc_cq_lock);
+	spin_lock(&adapter->mcc_cq_lock);
 
 	while ((compl = be_mcc_compl_get(adapter))) {
 		if (compl->flags & CQE_FLAGS_ASYNC_MASK) {
@@ -566,7 +566,7 @@ int be_process_mcc(struct be_adapter *adapter)
 	if (num)
 		be_cq_notify(adapter, mcc_obj->cq.id, mcc_obj->rearm_cq, num);
 
-	spin_unlock_bh(&adapter->mcc_cq_lock);
+	spin_unlock(&adapter->mcc_cq_lock);
 	return status;
 }
 
@@ -581,7 +581,9 @@ static int be_mcc_wait_compl(struct be_adapter *adapter)
 		if (be_check_error(adapter, BE_ERROR_ANY))
 			return -EIO;
 
+		local_bh_disable();
 		status = be_process_mcc(adapter);
+		local_bh_enable();
 
 		if (atomic_read(&mcc_obj->q.used) == 0)
 			break;
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 7968568bbe2140..361c1c87c18306 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5501,7 +5501,9 @@ static void be_worker(struct work_struct *work)
 	 * mcc completions
 	 */
 	if (!netif_running(adapter->netdev)) {
+		local_bh_disable();
 		be_process_mcc(adapter);
+		local_bh_enable();
 		goto reschedule;
 	}
 
-- 
2.31.1

