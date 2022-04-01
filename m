Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3EA84EF2D5
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245425AbiDAOw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350050AbiDAOrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:47:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9B62A03F0;
        Fri,  1 Apr 2022 07:37:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85CF6B824D8;
        Fri,  1 Apr 2022 14:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1BBC340F2;
        Fri,  1 Apr 2022 14:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823786;
        bh=fG9MQxUZVJfuo423h37Uy9a7r2z2UmE9/ApwUfDq85M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fR24yzge4htB+kf5fKwd5FS/VYM07RxS+JN96C1ApphqoFUt6AsGWUdD5HKotJe2S
         Od36PFCFVwLN1TKwrwM+LpB4ENjNzcNkH0oS5/FXVH12CFflh8RfNe5XoMQKNwKdmk
         UiF6/2Z4WWhoGcpReOrFUPGZxzogcmux5A9grRLPdjOzhufgYurXxt9p3YCeRrZ7qh
         9GPkVBnR0laGdU9VQRjXJ/RCePBPReV0K6UA3XEVpJggxAyFrNZxWdlj2UgDCpB9Vc
         7QbMgoeY7xawRo1jJVXV0pLNdcv6hAQa4dVfZlGQELZBzN3NXC60OPhACrZpc0jhLG
         TtfzN0nyGcNow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dust Li <dust.li@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kgraul@linux.ibm.com,
        kuba@kernel.org, pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 076/109] net/smc: correct settings of RMB window update limit
Date:   Fri,  1 Apr 2022 10:32:23 -0400
Message-Id: <20220401143256.1950537-76-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
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
index d1cdc891c211..f1dc5b914771 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1904,7 +1904,7 @@ static struct smc_buf_desc *smc_buf_get_slot(int compressed_bufsize,
  */
 static inline int smc_rmb_wnd_update_limit(int rmbe_size)
 {
-	return min_t(int, rmbe_size / 10, SOCK_MIN_SNDBUF / 2);
+	return max_t(int, rmbe_size / 10, SOCK_MIN_SNDBUF / 2);
 }
 
 /* map an rmb buf to a link */
-- 
2.34.1

