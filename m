Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20AB652431C
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 05:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245112AbiELDMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 23:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244914AbiELDMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 23:12:09 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E1A66AEF;
        Wed, 11 May 2022 20:12:08 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=guangguan.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VCysWBv_1652325125;
Received: from localhost.localdomain(mailfrom:guangguan.wang@linux.alibaba.com fp:SMTPD_---0VCysWBv_1652325125)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 May 2022 11:12:05 +0800
From:   Guangguan Wang <guangguan.wang@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, tonylu@linux.alibaba.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/2] net/smc: non blocking recvmsg() return -EAGAIN when no data and signal_pending
Date:   Thu, 12 May 2022 11:11:55 +0800
Message-Id: <20220512031156.74054-2-guangguan.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20220512031156.74054-1-guangguan.wang@linux.alibaba.com>
References: <20220512031156.74054-1-guangguan.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Non blocking sendmsg will return -EAGAIN when any signal pending
and no send space left, while non blocking recvmsg return -EINTR
when signal pending and no data received. This may makes confused.
As TCP returns -EAGAIN in the conditions described above. Align the
behavior of smc with TCP.

Fixes: 846e344eb722 ("net/smc: add receive timeout check")
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/smc_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 51e8eb2933ff..338b9ef806e8 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -355,12 +355,12 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 				}
 				break;
 			}
+			if (!timeo)
+				return -EAGAIN;
 			if (signal_pending(current)) {
 				read_done = sock_intr_errno(timeo);
 				break;
 			}
-			if (!timeo)
-				return -EAGAIN;
 		}
 
 		if (!smc_rx_data_available(conn)) {
-- 
2.24.3 (Apple Git-128)

