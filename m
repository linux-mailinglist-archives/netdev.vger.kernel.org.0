Return-Path: <netdev+bounces-3504-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33CED707977
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 07:15:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEC53281191
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 05:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B699F137A;
	Thu, 18 May 2023 05:15:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A146A649
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 05:15:19 +0000 (UTC)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5141981;
	Wed, 17 May 2023 22:15:16 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VivOQl2_1684386895;
Received: from h68b04305.sqa.eu95.tbsite.net(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VivOQl2_1684386895)
          by smtp.aliyun-inc.com;
          Thu, 18 May 2023 13:15:11 +0800
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
	linux-kernel@vger.kernel.org,
	liuyacan@corp.netease.com
Subject: [PATCH net] net/smc: Reset connection when trying to use SMCRv2 fails.
Date: Thu, 18 May 2023 13:14:55 +0800
Message-Id: <1684386895-112162-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

We found a crash when using SMCRv2 with 2 Mellanox ConnectX-4. It
can be reproduced by:

- smc_run nginx
- smc_run wrk -t 32 -c 500 -d 30 http://<ip>:<port>

 BUG: kernel NULL pointer dereference, address: 0000000000000014
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 8000000108713067 P4D 8000000108713067 PUD 151127067 PMD 0
 Oops: 0000 [#1] PREEMPT SMP PTI
 CPU: 4 PID: 2441 Comm: kworker/4:249 Kdump: loaded Tainted: G        W   E      6.4.0-rc1+ #42
 Workqueue: smc_hs_wq smc_listen_work [smc]
 RIP: 0010:smc_clc_send_confirm_accept+0x284/0x580 [smc]
 RSP: 0018:ffffb8294b2d7c78 EFLAGS: 00010a06
 RAX: ffff8f1873238880 RBX: ffffb8294b2d7dc8 RCX: 0000000000000000
 RDX: 00000000000000b4 RSI: 0000000000000001 RDI: 0000000000b40c00
 RBP: ffffb8294b2d7db8 R08: ffff8f1815c5860c R09: 0000000000000000
 R10: 0000000000000400 R11: 0000000000000000 R12: ffff8f1846f56180
 R13: ffff8f1815c5860c R14: 0000000000000001 R15: 0000000000000001
 FS:  0000000000000000(0000) GS:ffff8f1aefd00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000014 CR3: 00000001027a0001 CR4: 00000000003706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <TASK>
  ? mlx5_ib_map_mr_sg+0xa1/0xd0 [mlx5_ib]
  ? smcr_buf_map_link+0x24b/0x290 [smc]
  ? __smc_buf_create+0x4ee/0x9b0 [smc]
  smc_clc_send_accept+0x4c/0xb0 [smc]
  smc_listen_work+0x346/0x650 [smc]
  ? __schedule+0x279/0x820
  process_one_work+0x1e5/0x3f0
  worker_thread+0x4d/0x2f0
  ? __pfx_worker_thread+0x10/0x10
  kthread+0xe5/0x120
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x2c/0x50
  </TASK>

During the CLC handshake, server sequentially tries available SMCRv2
and SMCRv1 devices in smc_listen_work().

If an SMCRv2 device is found. SMCv2 based link group and link will be
assigned to the connection. Then assumed that some buffer assignment
errors happen later in the CLC handshake, such as RMB registration
failure, server will give up SMCRv2 and try SMCRv1 device instead. But
the resources assigned to the connection won't be reset.

When server tries SMCRv1 device, the connection creation process will
be executed again. Since conn->lnk has been assigned when trying SMCRv2,
it will not be set to the correct SMCRv1 link in
smcr_lgr_conn_assign_link(). So in such situation, conn->lgr points to
correct SMCRv1 link group but conn->lnk points to the SMCRv2 link
mistakenly.

Then in smc_clc_send_confirm_accept(), conn->rmb_desc->mr[link->link_idx]
will be accessed. Since the link->link_idx is not correct, the related
MR may not have been initialized, so crash happens.

 | Try SMCRv2 device first
 |     |-> conn->lgr:	assign existed SMCRv2 link group;
 |     |-> conn->link:	assign existed SMCRv2 link (link_idx may be 1 in SMC_LGR_SYMMETRIC);
 |     |-> sndbuf & RMB creation fails, quit;
 |
 | Try SMCRv1 device then
 |     |-> conn->lgr:	create SMCRv1 link group and assign;
 |     |-> conn->link:	keep SMCRv2 link mistakenly;
 |     |-> sndbuf & RMB creation succeed, only RMB->mr[link_idx = 0]
 |         initialized.
 |
 | Then smc_clc_send_confirm_accept() accesses
 | conn->rmb_desc->mr[conn->link->link_idx, which is 1], then crash.
 v

This patch tries to fix this by cleaning conn->lnk before assigning
link. In addition, it is better to reset the connection and clean the
resources assigned if trying SMCRv2 failed in buffer creation or
registration.

Fixes: e49300a6bf62 ("net/smc: add listen processing for SMC-Rv2")
Link: https://lore.kernel.org/r/20220523055056.2078994-1-liuyacan@corp.netease.com/
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/af_smc.c   | 9 +++++++--
 net/smc/smc_core.c | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 50c38b6..538e9c6 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2000,8 +2000,10 @@ static int smc_listen_rdma_init(struct smc_sock *new_smc,
 		return rc;
 
 	/* create send buffer and rmb */
-	if (smc_buf_create(new_smc, false))
+	if (smc_buf_create(new_smc, false)) {
+		smc_conn_abort(new_smc, ini->first_contact_local);
 		return SMC_CLC_DECL_MEM;
+	}
 
 	return 0;
 }
@@ -2217,8 +2219,11 @@ static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
 	smcr_version = ini->smcr_version;
 	ini->smcr_version = SMC_V2;
 	rc = smc_listen_rdma_init(new_smc, ini);
-	if (!rc)
+	if (!rc) {
 		rc = smc_listen_rdma_reg(new_smc, ini->first_contact_local);
+		if (rc)
+			smc_conn_abort(new_smc, ini->first_contact_local);
+	}
 	if (!rc)
 		return;
 	ini->smcr_version = smcr_version;
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 4543567..3f465fa 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -127,6 +127,7 @@ static int smcr_lgr_conn_assign_link(struct smc_connection *conn, bool first)
 	int i, j;
 
 	/* do link balancing */
+	conn->lnk = NULL;	/* reset conn->lnk first */
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		struct smc_link *lnk = &conn->lgr->lnk[i];
 
-- 
1.8.3.1


