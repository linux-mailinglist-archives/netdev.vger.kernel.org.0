Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D4155246E
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 21:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245289AbiFTTOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 15:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243729AbiFTTOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 15:14:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75153186DF
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 12:13:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25F97B8159F
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 19:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA2EC3411B;
        Mon, 20 Jun 2022 19:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655752436;
        bh=6nuGh2x7y8XjANkScnnQ62/aRk6Zq9kebVXfj7gkmTE=;
        h=From:To:Cc:Subject:Date:From;
        b=TxolPoXUmyw6j4zRR0q10IJe4VMZTQ2raKydGwwGt8SefONvZ/YwDrtpsjcU/qj6y
         UGPSqyiJhz7F3O/FLs4TbBuv8StMSwDAQNqAiDFVU2ahAzi0jRpOHhBZV2ePo8Qnnz
         yQ1DehzkRf31wCCdMdeDD4qJC9890q8VAgQT7JQ0D1SS2GYeq8gEReUkouPncJceMj
         qN/0DGDRvohpGkMt0wa/INcDZEi1RAFswjXQvMEKiNECTZasIpUXibHCeDqyoO+Jp4
         zHF3QAb7rGmw28eB+C0z5JqcbgNXW/v29bRHNLroi90I1Snc1Md295oiNvQh1G4hWZ
         UMEN0DUoAvyeA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, borisp@nvidia.com,
        john.fastabend@gmail.com, william.xuanziyang@huawei.com
Subject: [PATCH net 1/2] Revert "net/tls: fix tls_sk_proto_close executed repeatedly"
Date:   Mon, 20 Jun 2022 12:13:52 -0700
Message-Id: <20220620191353.1184629-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 69135c572d1f84261a6de2a1268513a7e71753e2.

This commit was just papering over the issue, ULP should not
get ->update() called with its own sk_prot. Each ULP would
need to add this check.

Fixes: 69135c572d1f ("net/tls: fix tls_sk_proto_close executed repeatedly")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: borisp@nvidia.com
CC: john.fastabend@gmail.com
CC: william.xuanziyang@huawei.com
---
 net/tls/tls_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 46bd5f26338b..da176411c1b5 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -921,9 +921,6 @@ static void tls_update(struct sock *sk, struct proto *p,
 {
 	struct tls_context *ctx;
 
-	if (sk->sk_prot == p)
-		return;
-
 	ctx = tls_get_ctx(sk);
 	if (likely(ctx)) {
 		ctx->sk_write_space = write_space;
-- 
2.36.1

