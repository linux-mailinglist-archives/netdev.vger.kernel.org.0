Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADE156C611
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 04:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiGICxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 22:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiGICxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 22:53:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44A97AB1D
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 19:53:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3529B82A36
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 02:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15491C341CB;
        Sat,  9 Jul 2022 02:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657335184;
        bh=C7b0R46WEiZCtvSkSda3jLY6eRh6KoKSBEyVqqGC3KM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1e0SqJ3woUlB43GTz2pBD+uBoTIgasTUkoh/KZVq9Q0LVHIP0YGJq0lUOVHe4TrX
         CCD2of9Ub80easOPUq+giLR0pcFpti8ZNl6+IGg0o718TrNySk01v0qCCl0tqt+P/q
         8FHVKzI/zTBUDSNUvoDfzFIpuNPBuxmI05Nqru6gcqvW/fHT8GemYoV+cBPCva7V6L
         i5elvs2nrEYKN0Qwv+HgjYtSnEcmOQcElJF+pRZ6g4nXo/U/moJCWUhpJ2F1v46R+q
         rLLa3ukya012v/UF2D+Kih9bCTFTmQsqggdUXdmyObViepAbOGJdpfThQaglroHAFJ
         bAkoRL9Znrbaw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/4] tls: rx: fix the NoPad getsockopt
Date:   Fri,  8 Jul 2022 19:52:54 -0700
Message-Id: <20220709025255.323864-4-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220709025255.323864-1-kuba@kernel.org>
References: <20220709025255.323864-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim reports do_tls_getsockopt_no_pad() will
always return an error. Indeed looks like refactoring
gone wrong - remove err and use value.

Reported-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Fixes: 88527790c079 ("tls: rx: add sockopt for enabling optimistic decrypt with TLS 1.3")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index f3d9dbfa507e..f71b46568112 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -539,8 +539,7 @@ static int do_tls_getsockopt_no_pad(struct sock *sk, char __user *optval,
 				    int __user *optlen)
 {
 	struct tls_context *ctx = tls_get_ctx(sk);
-	unsigned int value;
-	int err, len;
+	int value, len;
 
 	if (ctx->prot_info.version != TLS_1_3_VERSION)
 		return -EINVAL;
@@ -551,12 +550,12 @@ static int do_tls_getsockopt_no_pad(struct sock *sk, char __user *optval,
 		return -EINVAL;
 
 	lock_sock(sk);
-	err = -EINVAL;
+	value = -EINVAL;
 	if (ctx->rx_conf == TLS_SW || ctx->rx_conf == TLS_HW)
 		value = ctx->rx_no_pad;
 	release_sock(sk);
-	if (err)
-		return err;
+	if (value < 0)
+		return value;
 
 	if (put_user(sizeof(value), optlen))
 		return -EFAULT;
-- 
2.36.1

