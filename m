Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8E44C9AA6
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 02:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbiCBBor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 20:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiCBBoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 20:44:46 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B115A3B014
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 17:44:04 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V6.ye8n_1646185441;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V6.ye8n_1646185441)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Mar 2022 09:44:02 +0800
Date:   Wed, 2 Mar 2022 09:44:01 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: smc: fix different types in min()
Message-ID: <20220302014401.GB9417@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20220301222446.1271127-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220301222446.1271127-1-kuba@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 02:24:46PM -0800, Jakub Kicinski wrote:
>Fix build:
>
> include/linux/minmax.h:45:25: note: in expansion of macro ‘__careful_cmp’
>   45 | #define min(x, y)       __careful_cmp(x, y, <)
>      |                         ^~~~~~~~~~~~~
> net/smc/smc_tx.c:150:24: note: in expansion of macro ‘min’
>  150 |         corking_size = min(sock_net(&smc->sk)->smc.sysctl_autocorking_size,
>      |                        ^~~

Really sorry for the break and thanks for the fix !
I found my compiler didn't complain about this, I will try to fix my
development environment.

>
>Fixes: 12bbb0d163a9 ("net/smc: add sysctl for autocorking")
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
> net/smc/smc_tx.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
>index 257dc0d0aeb1..98ca9229fe87 100644
>--- a/net/smc/smc_tx.c
>+++ b/net/smc/smc_tx.c
>@@ -147,8 +147,8 @@ static bool smc_should_autocork(struct smc_sock *smc)
> 	struct smc_connection *conn = &smc->conn;
> 	int corking_size;
> 
>-	corking_size = min(sock_net(&smc->sk)->smc.sysctl_autocorking_size,
>-			   conn->sndbuf_desc->len >> 1);
>+	corking_size = min_t(unsigned int, conn->sndbuf_desc->len >> 1,
>+			     sock_net(&smc->sk)->smc.sysctl_autocorking_size);
> 
> 	if (atomic_read(&conn->cdc_pend_tx_wr) == 0 ||
> 	    smc_tx_prepared_sends(conn) > corking_size)
>-- 
>2.34.1
