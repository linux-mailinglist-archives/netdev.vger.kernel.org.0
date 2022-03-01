Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6B64C8C66
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 14:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbiCANSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 08:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbiCANSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 08:18:09 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6937BE000;
        Tue,  1 Mar 2022 05:17:27 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V5zi5sz_1646140644;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V5zi5sz_1646140644)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Mar 2022 21:17:24 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net] net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error
Date:   Tue,  1 Mar 2022 21:17:24 +0800
Message-Id: <1646140644-121649-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

Remove connections from link group is not synchronous with handling
SMC_LLC_DELETE_RKEY, which means that even the number of connections is
less that SMC_RMBS_PER_LGR_MAX, it does not mean that the connection can
register rtoken successfully later, in other words, the rtoken entry may
have not been released. This will cause an unexpected
SMC_CLC_DECL_ERR_REGRMB to be reported, and then ths smc connection have
to fallback to TCP.

We found that the main reason for the problem dues to following execution
sequence:

Server Conn A:           Server Conn B:			Client Conn B:

smc_lgr_unregister_conn
                        smc_lgr_register_conn
                        smc_clc_send_accept     ->
                                                        smc_rtoken_add
smcr_buf_unuse
		->		Client Conn A:
				smc_rtoken_delete

smc_lgr_unregister_conn() makes current link available to assigned to new
incoming connection, while smcr_buf_unuse() has not executed yet, which
means that smc_rtoken_add may fail because of insufficient rtoken_entry,
reversing their execution order will avoid this problem.

Fixes: 3e034725c0d8 ("net/smc: common functions for RMBs and send buffers")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/smc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 2f321d2..c9c3a68 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1161,8 +1161,8 @@ void smc_conn_free(struct smc_connection *conn)
 			cancel_work_sync(&conn->abort_work);
 	}
 	if (!list_empty(&lgr->list)) {
-		smc_lgr_unregister_conn(conn);
 		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
+		smc_lgr_unregister_conn(conn);
 	}
 
 	if (!lgr->conns_num)
-- 
1.8.3.1

