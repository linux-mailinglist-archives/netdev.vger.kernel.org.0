Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8654C9858
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 23:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237420AbiCAWZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 17:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237763AbiCAWZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 17:25:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54900710F9
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 14:24:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9257B81E65
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 22:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E56DC340EF;
        Tue,  1 Mar 2022 22:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646173491;
        bh=ee2gQiKfqz2tw/42Oq8NDiyisfs8ndXqh7hOlIs+2BQ=;
        h=From:To:Cc:Subject:Date:From;
        b=XKPUAXF/TIsaJc0bxCiWfasIRLoqo4vqbVDr4dOXp7L5A9WerYawHoprwROJHTJ38
         gKcyFpRqRy1lTMT7ZNLU4div/HEX1ZWd1t65PlKzztV4CPdnJ8kgHI5r8t6DkMRuUY
         31zbIcQ4eOU6wxc0IyV1NUc9LtObY/Jvu1Tp8RQX13vMQFJQQfm+AL+jKyeJFTjXF2
         ZnZTRTN/4xCD+u9fyi0+c+Yvj/YiQl3rAxy5xiGRQA8gUJh/5JHZI9aKBhyPM8scJZ
         kxvMU6TcBK+pDdvnaDr9MNGlO8WjRvctY+ysLwo2r7WAHFJFL/YkOefhzuss1ggaqv
         5T35G39YUN53A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Dust Li <dust.li@linux.alibaba.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: smc: fix different types in min()
Date:   Tue,  1 Mar 2022 14:24:46 -0800
Message-Id: <20220301222446.1271127-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build:

 include/linux/minmax.h:45:25: note: in expansion of macro ‘__careful_cmp’
   45 | #define min(x, y)       __careful_cmp(x, y, <)
      |                         ^~~~~~~~~~~~~
 net/smc/smc_tx.c:150:24: note: in expansion of macro ‘min’
  150 |         corking_size = min(sock_net(&smc->sk)->smc.sysctl_autocorking_size,
      |                        ^~~

Fixes: 12bbb0d163a9 ("net/smc: add sysctl for autocorking")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/smc/smc_tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 257dc0d0aeb1..98ca9229fe87 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -147,8 +147,8 @@ static bool smc_should_autocork(struct smc_sock *smc)
 	struct smc_connection *conn = &smc->conn;
 	int corking_size;
 
-	corking_size = min(sock_net(&smc->sk)->smc.sysctl_autocorking_size,
-			   conn->sndbuf_desc->len >> 1);
+	corking_size = min_t(unsigned int, conn->sndbuf_desc->len >> 1,
+			     sock_net(&smc->sk)->smc.sysctl_autocorking_size);
 
 	if (atomic_read(&conn->cdc_pend_tx_wr) == 0 ||
 	    smc_tx_prepared_sends(conn) > corking_size)
-- 
2.34.1

