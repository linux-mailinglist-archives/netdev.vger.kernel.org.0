Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62950581E0D
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 05:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240228AbiG0DPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 23:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240233AbiG0DPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 23:15:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7531F2CA
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:15:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA3E0617A9
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 03:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F911C433D7;
        Wed, 27 Jul 2022 03:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658891729;
        bh=AW+Sap8ycYjiZrtDINHqc4G+mA1E+2LpjtoTBYUdA4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwN9GAljFGcYCtgt7SfDE8mEkT7Fi8Th7QWYdkyOms6LZqpryL8TfyjRH3H6Feo0L
         o+2SOlKQ8dJTM3J/YmqV6aebykhx1leitdlEkOxC27W28Wal+37NDGmMAfU7jyVSND
         Ddet6yNKTgZjkDOykJWZ3Dgj7rp8gwo5+J5Uj5uJX7AwFyDRYOVyYoQ71NG39/VSQd
         T2zRgJfc3v3JDGoGmcxMoy3eVlJbSOVfbvPzHACSBmipHng9Fa3cKxFEc61BDWO0ua
         hSxeplUJ+9R69+r67mjZQGD+Z72I/EhcUtIeYntI7WDB08Ys2DYVC6Yh4zSGXVg9EH
         HhWIVGbjr3FHA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/4] tls: rx: fix the false positive warning
Date:   Tue, 26 Jul 2022 20:15:24 -0700
Message-Id: <20220727031524.358216-5-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727031524.358216-1-kuba@kernel.org>
References: <20220727031524.358216-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I went too far in the accessor conversion, we can't use tls_strp_msg()
after decryption because the message may not be ready. What we care
about on this path is that the output skb is detached, i.e. we didn't
somehow just turn around and used the input skb with its TCP data
still attached. So look at the anchor directly.

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 8bac7ea2c264..17db8c8811fa 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2026,7 +2026,7 @@ int tls_sw_recvmsg(struct sock *sk,
 			bool partially_consumed = chunk > len;
 			struct sk_buff *skb = darg.skb;
 
-			DEBUG_NET_WARN_ON_ONCE(darg.skb == tls_strp_msg(ctx));
+			DEBUG_NET_WARN_ON_ONCE(darg.skb == ctx->strp.anchor);
 
 			if (async) {
 				/* TLS 1.2-only, to_decrypt must be text len */
-- 
2.37.1

