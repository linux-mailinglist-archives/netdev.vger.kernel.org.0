Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 379D564763
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 15:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfGJNpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 09:45:10 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:61750 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbfGJNpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 09:45:10 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 42A7841720;
        Wed, 10 Jul 2019 21:45:06 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, davem@davemloft.net
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net/sched: Fix kernel NULL pointer dereference
Date:   Wed, 10 Jul 2019 21:45:04 +0800
Message-Id: <1562766304-20272-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVPSUNCQkJCS0tDSkxDTFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pk06Gio5NDg8FA0WNTZREDM3
        FD0aFE1VSlVKTk1JTE1NSEtNSElIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhPTkg3Bg++
X-HM-Tid: 0a6bdc216bf12086kuqy42a7841720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

[  697.665184] BUG: kernel NULL pointer dereference, address: 0000000000000030
[  697.665550] #PF: supervisor read access in kernel mode
[  697.665906] #PF: error_code(0x0000) - not-present page
[  697.666297] PGD 800000104e636067 P4D 800000104e636067 PUD ff4b02067 PMD 0
[  697.666710] Oops: 0000 [#1] SMP PTI
[  697.667115] CPU: 31 PID: 24466 Comm: modprobe Kdump: loaded Tainted: G           O      5.2.0-rc6+ #1
[  697.667867] Hardware name: Huawei Technologies Co., Ltd. RH1288 V3/BC11HGSC0, BIOS 3.57 02/26/2017
[  697.668620] RIP: 0010:tc_indr_block_ing_cmd.isra.52+0x4c/0xb0
[  697.669029] Code: 83 ec 40 65 48 8b 04 25 28 00 00 00 48 89 45 e8 31 c0 f3 48 ab 48 8b 06 49 8b b3 e8 04 00 00 44 89 45 b0 c7 45 b4 01 00 00 00 <8b> 48 30 48 89 75 c0 85 c9 48 8d 4d b0 0f 95 45 b8 48 85 c0 4c 8d
[  697.670132] RSP: 0018:ffffc90007bf7958 EFLAGS: 00010246
[  697.670537] RAX: 0000000000000000 RBX: ffff88905e2cbae8 RCX: 0000000000000000
[  697.670938] RDX: ffff88905e2cbcd8 RSI: ffffffff823a8480 RDI: ffffc90007bf7990
[  697.671352] RBP: ffffc90007bf79a8 R08: 0000000000000000 R09: ffff88905e2cbcc0
[  697.671761] R10: ffff888107c07780 R11: ffff88902c249000 R12: ffff88905e2cbcd0
[  697.672173] R13: ffff88905e2cbac0 R14: ffff88885596bc00 R15: ffff88905e2cbcc0
[  697.672582] FS:  00007fe0b4095740(0000) GS:ffff88905fbc0000(0000) knlGS:0000000000000000
[  697.673335] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  697.673746] CR2: 0000000000000030 CR3: 0000000ff46b4005 CR4: 00000000001606e0
[  697.674156] Call Trace:
[  697.674563]  __tc_indr_block_cb_register+0x11e/0x3c0
[  697.674998]  mlx5e_nic_rep_netdevice_event+0x9e/0x110 [mlx5_core]
[  697.675411]  notifier_call_chain+0x53/0xa0
[  697.675812]  raw_notifier_call_chain+0x16/0x20
[  697.676223]  call_netdevice_notifiers_info+0x2d/0x60
[  697.676633]  register_netdevice+0x3fa/0x500

get indr_dev->block after check it.

Fixes: 955bcb6ea0df ("drivers: net: use flow block API")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/cls_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 638c1bc..be899f7 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -684,13 +684,14 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 		.command	= command,
 		.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
 		.net		= dev_net(indr_dev->dev),
-		.block_shared	= tcf_block_shared(indr_dev->block),
 	};
 	INIT_LIST_HEAD(&bo.cb_list);
 
 	if (!indr_dev->block)
 		return;
 
+	bo.block_shared	= tcf_block_shared(indr_dev->block);
+
 	indr_block_cb->cb(indr_dev->dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
 			  &bo);
 	tcf_block_setup(indr_dev->block, &bo);
-- 
1.8.3.1

