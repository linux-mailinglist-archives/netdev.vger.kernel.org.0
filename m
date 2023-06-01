Return-Path: <netdev+bounces-7037-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34EEB7195D6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:42:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83CCF1C21032
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51235C13A;
	Thu,  1 Jun 2023 08:42:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A79A923
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:42:09 +0000 (UTC)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5078E7;
	Thu,  1 Jun 2023 01:42:05 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Vk3oFOT_1685608912;
Received: from h68b04305.sqa.eu95.tbsite.net(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Vk3oFOT_1685608912)
          by smtp.aliyun-inc.com;
          Thu, 01 Jun 2023 16:42:02 +0800
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
Subject: [PATCH net] net/smc: Avoid to access invalid RMBs' MRs in SMCRv1 ADD LINK CONT
Date: Thu,  1 Jun 2023 16:41:52 +0800
Message-Id: <1685608912-124996-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
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

SMCRv1 has a similar issue to SMCRv2 (see link below) that may access
invalid MRs of RMBs when construct LLC ADD LINK CONT messages.

 BUG: kernel NULL pointer dereference, address: 0000000000000014
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP PTI
 CPU: 5 PID: 48 Comm: kworker/5:0 Kdump: loaded Tainted: G W   E      6.4.0-rc3+ #49
 Workqueue: events smc_llc_add_link_work [smc]
 RIP: 0010:smc_llc_add_link_cont+0x160/0x270 [smc]
 RSP: 0018:ffffa737801d3d50 EFLAGS: 00010286
 RAX: ffff964f82144000 RBX: ffffa737801d3dd8 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff964f81370c30
 RBP: ffffa737801d3dd4 R08: ffff964f81370000 R09: ffffa737801d3db0
 R10: 0000000000000001 R11: 0000000000000060 R12: ffff964f82e70000
 R13: ffff964f81370c38 R14: ffffa737801d3dd3 R15: 0000000000000001
 FS:  0000000000000000(0000) GS:ffff9652bfd40000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000014 CR3: 000000008fa20004 CR4: 00000000003706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <TASK>
  smc_llc_srv_rkey_exchange+0xa7/0x190 [smc]
  smc_llc_srv_add_link+0x3ae/0x5a0 [smc]
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
to the new link. Then the RMBs' MRs corresponding to the new link will
be filled into LLC messages. For SMCRv1, they are ADD LINK CONT messages.

However smc_llc_add_link_cont() may mistakenly access to unused RMBs which
haven't been mapped to the new link and have no valid MRs, thus causing a
crash. So this patch fixes it.

Fixes: 87f88cda2128 ("net/smc: rkey processing for a new link as SMC client")
Link: https://lore.kernel.org/r/1685101741-74826-3-git-send-email-guwen@linux.alibaba.com
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_llc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 7a8d916..90f0b60 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -851,6 +851,8 @@ static int smc_llc_add_link_cont(struct smc_link *link,
 	addc_llc->num_rkeys = *num_rkeys_todo;
 	n = *num_rkeys_todo;
 	for (i = 0; i < min_t(u8, n, SMC_LLC_RKEYS_PER_CONT_MSG); i++) {
+		while (*buf_pos && !(*buf_pos)->used)
+			*buf_pos = smc_llc_get_next_rmb(lgr, buf_lst, *buf_pos);
 		if (!*buf_pos) {
 			addc_llc->num_rkeys = addc_llc->num_rkeys -
 					      *num_rkeys_todo;
@@ -867,8 +869,6 @@ static int smc_llc_add_link_cont(struct smc_link *link,
 
 		(*num_rkeys_todo)--;
 		*buf_pos = smc_llc_get_next_rmb(lgr, buf_lst, *buf_pos);
-		while (*buf_pos && !(*buf_pos)->used)
-			*buf_pos = smc_llc_get_next_rmb(lgr, buf_lst, *buf_pos);
 	}
 	addc_llc->hd.common.llc_type = SMC_LLC_ADD_LINK_CONT;
 	addc_llc->hd.length = sizeof(struct smc_llc_msg_add_link_cont);
-- 
1.8.3.1


