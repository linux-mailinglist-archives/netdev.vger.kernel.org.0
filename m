Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B82B6A55AC
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 10:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbjB1JZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 04:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjB1JZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 04:25:08 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14AF274B1;
        Tue, 28 Feb 2023 01:25:05 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0Vcix4zH_1677576302;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Vcix4zH_1677576302)
          by smtp.aliyun-inc.com;
          Tue, 28 Feb 2023 17:25:02 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 3/4] net/smc: add BPF injection on smc negotiation
Date:   Tue, 28 Feb 2023 17:24:53 +0800
Message-Id: <1677576294-33411-4-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1677576294-33411-1-git-send-email-alibuda@linux.alibaba.com>
References: <1677576294-33411-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

This patch try add BPF injection on smc negotiation, so that
the application can decided whether to use smc or not through
eBPF progs.

In particular, some applications may need global dynamic information
to make decision. Therefore, we also inject a information collect
point into smc_release.

Note that, in order to make negotiation can be decided by application,
sockets must have SMC_LIMIT_HS set.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/af_smc.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index a4cccdf..7ebe5e8 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -166,6 +166,9 @@ static bool smc_hs_congested(const struct sock *sk)
 	if (workqueue_congested(WORK_CPU_UNBOUND, smc_hs_wq))
 		return true;
 
+	if (!smc_sock_should_select_smc(smc))
+		return true;
+
 	return false;
 }
 
@@ -320,6 +323,9 @@ static int smc_release(struct socket *sock)
 	sock_hold(sk); /* sock_put below */
 	smc = smc_sk(sk);
 
+	/* trigger info gathering if needed.*/
+	smc_sock_perform_collecting_info(sk, SMC_SOCK_CLOSED_TIMING);
+
 	old_state = sk->sk_state;
 
 	/* cleanup for a dangling non-blocking connect */
@@ -1627,7 +1633,14 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
 	}
 
 	smc_copy_sock_settings_to_clc(smc);
-	tcp_sk(smc->clcsock->sk)->syn_smc = 1;
+	/* accept out connection as SMC connection */
+	if (smc_sock_should_select_smc(smc) == SK_PASS) {
+		tcp_sk(smc->clcsock->sk)->syn_smc = 1;
+	} else {
+		tcp_sk(smc->clcsock->sk)->syn_smc = 0;
+		smc_switch_to_fallback(smc, /* just a chooice */ 0);
+	}
+
 	if (smc->connect_nonblock) {
 		rc = -EALREADY;
 		goto out;
-- 
1.8.3.1

