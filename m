Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF309668C6F
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbjAMGUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239005AbjAMGT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:19:28 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B108C1ADB2;
        Thu, 12 Jan 2023 22:19:15 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30CNQvAD015973;
        Thu, 12 Jan 2023 22:19:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=vcvaXIxm8VoCVqBzy152plEY4O4C6l50HsiNo8UrGjs=;
 b=JOQBIVgXYT4LE5yjchU7kxkonAV5SwjQopjsdYpD+DjeTIpOQ/SQdWY52XFOhnWnBb5v
 3m7pj4PYAMQWvdjf9LGNMGtyXwarvXCrRSS9627mIn0i3hR0RP1xb8FxxQXtOwoSXKqN
 myZoIZSoSox8BwSltAWeFv4t/VkD33k6sJXBZqwXj8aYRpJwK/12AsmYXeBQ0snD/sLU
 pxd4jyBGiWJET9Q44G8KubDVqGavfscYtH3Uh/etvLdY1NXcrUZkwfqZnQZKsG0NNkeP
 uNelS19nrdNwbzPs+oVLOIDn9rVlGMoef4AcroA58dyQl/rvINgeROhL2euIMryhp2Hk Eg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n1k573pt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 22:19:08 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 12 Jan
 2023 22:19:06 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Thu, 12 Jan 2023 22:19:06 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 44C103F7073;
        Thu, 12 Jan 2023 22:19:03 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <gakula@marvell.com>, <sgoutham@marvell.com>
Subject: [net PATCH v2] octeontx2-pf: Avoid use of GFP_KERNEL in atomic context
Date:   Fri, 13 Jan 2023 11:49:02 +0530
Message-ID: <20230113061902.6061-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: uIVel31LeyPoIc0OA-MOk8Uuau4Tbwr9
X-Proofpoint-GUID: uIVel31LeyPoIc0OA-MOk8Uuau4Tbwr9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_14,2023-01-12_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using GFP_KERNEL in preemption disable context, causing below warning
when CONFIG_DEBUG_ATOMIC_SLEEP is enabled.

[   32.542271] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:274
[   32.550883] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
[   32.558707] preempt_count: 1, expected: 0
[   32.562710] RCU nest depth: 0, expected: 0
[   32.566800] CPU: 3 PID: 1 Comm: swapper/0 Tainted: G        W          6.2.0-rc2-00269-gae9dcb91c606 #7
[   32.576188] Hardware name: Marvell CN106XX board (DT)
[   32.581232] Call trace:
[   32.583670]  dump_backtrace.part.0+0xe0/0xf0
[   32.587937]  show_stack+0x18/0x30
[   32.591245]  dump_stack_lvl+0x68/0x84
[   32.594900]  dump_stack+0x18/0x34
[   32.598206]  __might_resched+0x12c/0x160
[   32.602122]  __might_sleep+0x48/0xa0
[   32.605689]  __kmem_cache_alloc_node+0x2b8/0x2e0
[   32.610301]  __kmalloc+0x58/0x190
[   32.613610]  otx2_sq_aura_pool_init+0x1a8/0x314
[   32.618134]  otx2_open+0x1d4/0x9d0

To avoid use of GFP_ATOMIC for memory allocation, disable preemption 
after all memory allocation is done.

Fixes: 4af1b64f80fb ("octeontx2-pf: Fix lmtst ID used in aura free")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
v1-v2:
- Moved get_cpu to avolid use of GFP_ATOMIC. 
- reworked commit message.

 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 88f8772a61cd..497b777b6a34 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1370,7 +1370,6 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 	if (err)
 		goto fail;
 
-	get_cpu();
 	/* Allocate pointers and free them to aura/pool */
 	for (qidx = 0; qidx < hw->tot_tx_queues; qidx++) {
 		pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
@@ -1388,13 +1387,14 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 			err = otx2_alloc_rbuf(pfvf, pool, &bufptr);
 			if (err)
 				goto err_mem;
+			get_cpu();
 			pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr);
+			put_cpu();
 			sq->sqb_ptrs[sq->sqb_count++] = (u64)bufptr;
 		}
 	}
 
 err_mem:
-	put_cpu();
 	return err ? -ENOMEM : 0;
 
 fail:
-- 
2.25.1

