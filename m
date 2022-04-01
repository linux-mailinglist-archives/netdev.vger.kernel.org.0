Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367CE4EF656
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350226AbiDAPde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349423AbiDAOzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:55:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC0C67D0A;
        Fri,  1 Apr 2022 07:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F638B8240E;
        Fri,  1 Apr 2022 14:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09C4C34111;
        Fri,  1 Apr 2022 14:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824230;
        bh=fq3ZZtKeifpYd3zu2lmjcZaw60oflSC8z9zx+ybjUGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0nIrSj8nwZ4nNsnBiIgEmu/oxfzT/OktdllKAP5KvaA9vT/Oo5AtpIbrOJkXkqlI
         9tNHdSPf5USVT1oz/rNCxdrkTTRz0fbBfb1ZYMPucB3lYr8Zb7OUbmVyp1tglNum2D
         VwDl1OzWhiyH5mQoQRDQy0/AUB2rzKnBvaX6Ku3rlz9eN8KH0dPmr24SH4/jAepoLV
         I4GeLaGGL16eJk9RHofk6pgc3av1oPjK9pECCgjcPsZknvOyKYQy/8qro7hPSMZIHh
         ndWxhlVUHWJr9bLO97IvtodK3vtJsjsucDfDN7Y6lk+Tvhp5Qm1AJa+0eKAOT8zWz7
         EZr1KSLKEbBOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dust Li <dust.li@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kgraul@linux.ibm.com,
        kuba@kernel.org, pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 41/65] net/smc: correct settings of RMB window update limit
Date:   Fri,  1 Apr 2022 10:41:42 -0400
Message-Id: <20220401144206.1953700-41-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dust Li <dust.li@linux.alibaba.com>

[ Upstream commit 6bf536eb5c8ca011d1ff57b5c5f7c57ceac06a37 ]

rmbe_update_limit is used to limit announcing receive
window updating too frequently. RFC7609 request a minimal
increase in the window size of 10% of the receive buffer
space. But current implementation used:

  min_t(int, rmbe_size / 10, SOCK_MIN_SNDBUF / 2)

and SOCK_MIN_SNDBUF / 2 == 2304 Bytes, which is almost
always less then 10% of the receive buffer space.

This causes the receiver always sending CDC message to
update its consumer cursor when it consumes more then 2K
of data. And as a result, we may encounter something like
"TCP silly window syndrome" when sending 2.5~8K message.

This patch fixes this using max(rmbe_size / 10, SOCK_MIN_SNDBUF / 2).

With this patch and SMC autocorking enabled, qperf 2K/4K/8K
tcp_bw test shows 45%/75%/40% increase in throughput respectively.

Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index d69aac6c1fce..ef2fd28999ba 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1426,7 +1426,7 @@ static struct smc_buf_desc *smc_buf_get_slot(int compressed_bufsize,
  */
 static inline int smc_rmb_wnd_update_limit(int rmbe_size)
 {
-	return min_t(int, rmbe_size / 10, SOCK_MIN_SNDBUF / 2);
+	return max_t(int, rmbe_size / 10, SOCK_MIN_SNDBUF / 2);
 }
 
 /* map an rmb buf to a link */
-- 
2.34.1

