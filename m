Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0F657497E
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 11:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238437AbiGNJqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 05:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238438AbiGNJpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 05:45:43 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC2F12D26;
        Thu, 14 Jul 2022 02:45:41 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VJIcqMy_1657791934;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VJIcqMy_1657791934)
          by smtp.aliyun-inc.com;
          Thu, 14 Jul 2022 17:45:38 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 4/6] net/smc: Use sysctl-specified types of buffers in new link group
Date:   Thu, 14 Jul 2022 17:44:03 +0800
Message-Id: <1657791845-1060-5-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1657791845-1060-1-git-send-email-guwen@linux.alibaba.com>
References: <1657791845-1060-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a new SMC-R specific element buf_type
in struct smc_link_group, for recording the value of sysctl
smcr_buf_type when link group is created.

New created link group will create and reuse buffers of the
type specified by buf_type.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_core.c | 1 +
 net/smc/smc_core.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index fa3a7a8..86afbbc 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -907,6 +907,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		lgr->net = smc_ib_net(lnk->smcibdev);
 		lgr_list = &smc_lgr_list.list;
 		lgr_lock = &smc_lgr_list.lock;
+		lgr->buf_type = lgr->net->smc.sysctl_smcr_buf_type;
 		atomic_inc(&lgr_cnt);
 	}
 	smc->conn.lgr = lgr;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 7652dfa..0261124 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -284,6 +284,7 @@ struct smc_link_group {
 						/* used rtoken elements */
 			u8			next_link_id;
 			enum smc_lgr_type	type;
+			enum smcr_buf_type	buf_type;
 						/* redundancy state */
 			u8			pnet_id[SMC_MAX_PNETID_LEN + 1];
 						/* pnet id of this lgr */
-- 
1.8.3.1

