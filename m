Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20514FC4F1
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 21:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349458AbiDKTVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 15:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242989AbiDKTVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 15:21:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6D01093
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:19:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36A54B8187F
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AD1C385A4;
        Mon, 11 Apr 2022 19:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649704763;
        bh=mjw3myvdYADAC5TpuWCMH9HiR0Xh9T0hQjjKi+AoZeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWBADKfowf4yp1i6Ry425us5Ar3yKhOkZlBONlJR3rPkWkah593rpvZRutPSY7n+2
         5+BFi9nyBOuGzLasvF53Ugn/jbQM+oTQn2vwTV6jibIOr4hzT/owcWzn8l5vKCsS2Y
         qDp2oYe+LuOjalrVc5/zjXQSLe+59HvXTm/cTzXH4Kq81JVuHOEuRuJOICwbR7ZVWo
         78RUJedtSUVEghCJlRi3UydmHRj8OfXP9uAja/hzKXdgQ4tcYIX4w7giP1X6SuXn4c
         YrZHeQ6OGiyVbPK3EPqAR12P5uvWXp+eBW+ZE58HfdT5SDYoghSQVJDGSU5CVZ27R8
         i3B2dW/bsyrKQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 03/10] tls: rx: move counting TlsDecryptErrors for sync
Date:   Mon, 11 Apr 2022 12:19:10 -0700
Message-Id: <20220411191917.1240155-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220411191917.1240155-1-kuba@kernel.org>
References: <20220411191917.1240155-1-kuba@kernel.org>
MIME-Version: 1.0
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

Move counting TlsDecryptErrors to tls_do_decryption()
where differences between sync and async crypto are
reconciled.

No functional changes, this code just always gave
me a pause.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 42ac605d48bb..c8378396e616 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -270,6 +270,8 @@ static int tls_do_decryption(struct sock *sk,
 
 		ret = crypto_wait_req(ret, &ctx->async_wait);
 	}
+	if (ret == -EBADMSG)
+		TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
 
 	if (async)
 		atomic_dec(&ctx->decrypt_pending);
@@ -1584,8 +1586,6 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	if (err < 0) {
 		if (err == -EINPROGRESS)
 			tls_advance_record_sn(sk, prot, &tls_ctx->rx);
-		else if (err == -EBADMSG)
-			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
 		return err;
 	}
 
-- 
2.34.1

