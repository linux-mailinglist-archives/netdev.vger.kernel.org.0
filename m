Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572F74C885C
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 10:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbiCAJpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 04:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233974AbiCAJpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 04:45:04 -0500
Received: from out199-18.us.a.mail.aliyun.com (out199-18.us.a.mail.aliyun.com [47.90.199.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313623BF93;
        Tue,  1 Mar 2022 01:44:12 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V5x4ASj_1646127847;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V5x4ASj_1646127847)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Mar 2022 17:44:08 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next 4/7] net/smc: send directly on setting TCP_NODELAY
Date:   Tue,  1 Mar 2022 17:43:59 +0800
Message-Id: <20220301094402.14992-5-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <20220301094402.14992-1-dust.li@linux.alibaba.com>
References: <20220301094402.14992-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit ea785a1a573b("net/smc: Send directly when
TCP_CORK is cleared"), we don't use delayed work
to implement cork.

This patch use the same algorithm, removes the
delayed work when setting TCP_NODELAY and send
directly in setsockopt(). This also makes the
TCP_NODELAY the same as TCP.

Cc: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/smc/af_smc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 19b3066cf7af..e661b3747945 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2796,8 +2796,8 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		    sk->sk_state != SMC_CLOSED) {
 			if (val) {
 				SMC_STAT_INC(smc, ndly_cnt);
-				mod_delayed_work(smc->conn.lgr->tx_wq,
-						 &smc->conn.tx_work, 0);
+				smc_tx_pending(&smc->conn);
+				cancel_delayed_work(&smc->conn.tx_work);
 			}
 		}
 		break;
-- 
2.19.1.3.ge56e4f7

