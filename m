Return-Path: <netdev+bounces-5667-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F30B7125EE
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:49:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 395A9280BEF
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE379168A1;
	Fri, 26 May 2023 11:49:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C76742EA
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:49:14 +0000 (UTC)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6CC1B4;
	Fri, 26 May 2023 04:49:10 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VjWOl8u_1685101745;
Received: from h68b04305.sqa.eu95.tbsite.net(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VjWOl8u_1685101745)
          by smtp.aliyun-inc.com;
          Fri, 26 May 2023 19:49:05 +0800
From: Wen Gu <guwen@linux.alibaba.com>
To: kgraul@linux.ibm.com,
	wenjia@linux.ibm.com,
	jaka@linux.ibm.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net/smc: Don't use RMBs not mapped to new link in SMCRv2 ADD LINK
Date: Fri, 26 May 2023 19:49:01 +0800
Message-Id: <1685101741-74826-3-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1685101741-74826-1-git-send-email-guwen@linux.alibaba.com>
References: <1685101741-74826-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

We encountered a crash when using SMCRv2. It is caused by a logical
error in smc_llc_fill_ext_v2().

 BUG: kernel NULL pointer dereference, address: 0000000000000014
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP PTI
 CPU: 7 PID: 453 Comm: kworker/7:4 Kdump: loaded Tainted: G        W   E      6.4.0-rc3+ #44
 Workqueue: events smc_llc_add_link_work [smc]
 RIP: 0010:smc_llc_fill_ext_v2+0x117/0x280 [smc]
 RSP: 0018:ffffacb5c064bd88 EFLAGS: 00010282
 RAX: ffff9a6bc1c3c02c RBX: ffff9a6be3558000 RCX: 0000000000000000
 RDX: 0000000000000002 RSI: 0000000000000002 RDI: 000000000000000a
 RBP: ffffacb5c064bdb8 R08: 0000000000000040 R09: 000000000000000c
 R10: ffff9a6bc0910300 R11: 0000000000000002 R12: 0000000000000000
 R13: 0000000000000002 R14: ffff9a6bc1c3c02c R15: ffff9a6be3558250
 FS:  0000000000000000(0000) GS:ffff9a6eefdc0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000014 CR3: 000000010b078003 CR4: 00000000003706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <TASK>
  smc_llc_send_add_link+0x1ae/0x2f0 [smc]
  smc_llc_srv_add_link+0x2c9/0x5a0 [smc]
  ? cc_mkenc+0x40/0x60
  smc_llc_add_link_work+0xb8/0x140 [smc]
  process_one_work+0x1e5/0x3f0
  worker_thread+0x4d/0x2f0
  ? __pfx_worker_thread+0x10/0x10
  kthread+0xe5/0x120
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x2c/0x50
  </TASK>

When an alernate RNIC is available in system, SMC will try to add a new
link based on the RNIC for resilience. All the RMBs in use will be mapped
to the new link. Then the RMBs' MRs corresponding to the new link will be
filled into SMCRv2 LLC ADD LINK messages.

However, smc_llc_fill_ext_v2() mistakenly accesses to unused RMBs which
haven't been mapped to the new link and have no valid MRs, thus causing
a crash. So this patch fixes the logic.

Fixes: b4ba4652b3f8 ("net/smc: extend LLC layer for SMC-Rv2")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_llc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 8423e8e..7a8d916 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -617,6 +617,8 @@ static int smc_llc_fill_ext_v2(struct smc_llc_msg_add_link_v2_ext *ext,
 		goto out;
 	buf_pos = smc_llc_get_first_rmb(lgr, &buf_lst);
 	for (i = 0; i < ext->num_rkeys; i++) {
+		while (buf_pos && !(buf_pos)->used)
+			buf_pos = smc_llc_get_next_rmb(lgr, &buf_lst, buf_pos);
 		if (!buf_pos)
 			break;
 		rmb = buf_pos;
@@ -626,8 +628,6 @@ static int smc_llc_fill_ext_v2(struct smc_llc_msg_add_link_v2_ext *ext,
 			cpu_to_be64((uintptr_t)rmb->cpu_addr) :
 			cpu_to_be64((u64)sg_dma_address(rmb->sgt[lnk_idx].sgl));
 		buf_pos = smc_llc_get_next_rmb(lgr, &buf_lst, buf_pos);
-		while (buf_pos && !(buf_pos)->used)
-			buf_pos = smc_llc_get_next_rmb(lgr, &buf_lst, buf_pos);
 	}
 	len += i * sizeof(ext->rt[0]);
 out:
-- 
1.8.3.1


