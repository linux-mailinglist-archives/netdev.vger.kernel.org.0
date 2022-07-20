Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96B657BF40
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 22:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiGTUhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 16:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiGTUhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 16:37:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C2013D7B
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 13:37:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AE9FB81FAB
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 20:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3272C3411E;
        Wed, 20 Jul 2022 20:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658349425;
        bh=dJuXfTN+HXhHrJVphszdPFg1iqvz+4oNyUbvZK7eFbE=;
        h=From:To:Cc:Subject:Date:From;
        b=gTqCXXryE/uacy2aeC7juRPeEMQ2BQL52qL6Qqmp5ekUvz61uz4vJKTkMTQHyn5/1
         bloMuhSwJ3QDIoReKEUManyCQ2gRUVVt/bCDOSagR9ipE6h+pwfwbU12tVot50vlHJ
         2egOe0Lnl/qBJ6pfjsmej2yu+IrWj6BIFlj+QSONlQFjLagT5gdpr1sWgrOUSMOHhZ
         wOSUNf/5auuIDJ5jGkXRaYR3Z6E4fHK9YC9ja/eOPXDcyGfG7TSkrcM5gWSY4DmiLJ
         DMNAZD6prY2DKtr9oZgpk7yrr7Rp4vJOi3bQCUg+ddU8RdRcO5bIVwWymqNADVJ/0B
         Nr+UoMEZPlWvg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+16e72110feb2b653ef27@syzkaller.appspotmail.com
Subject: [PATCH net-next 1/2] tls: rx: release the sock lock on locking timeout
Date:   Wed, 20 Jul 2022 13:37:00 -0700
Message-Id: <20220720203701.2179034-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric reports we should release the socket lock if the entire
"grab reader lock" operation has failed. The callers assume
they don't have to release it or otherwise unwind.

Reported-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+16e72110feb2b653ef27@syzkaller.appspotmail.com
Fixes: 4cbc325ed6b4 ("tls: rx: allow only one reader at a time")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 518401997539..0fc24a5ce208 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1846,6 +1846,7 @@ static long tls_rx_reader_lock(struct sock *sk, struct tls_sw_context_rx *ctx,
 			       bool nonblock)
 {
 	long timeo;
+	int err;
 
 	lock_sock(sk);
 
@@ -1861,15 +1862,23 @@ static long tls_rx_reader_lock(struct sock *sk, struct tls_sw_context_rx *ctx,
 			      !READ_ONCE(ctx->reader_present), &wait);
 		remove_wait_queue(&ctx->wq, &wait);
 
-		if (!timeo)
-			return -EAGAIN;
-		if (signal_pending(current))
-			return sock_intr_errno(timeo);
+		if (timeo <= 0) {
+			err = -EAGAIN;
+			goto err_unlock;
+		}
+		if (signal_pending(current)) {
+			err = sock_intr_errno(timeo);
+			goto err_unlock;
+		}
 	}
 
 	WRITE_ONCE(ctx->reader_present, 1);
 
 	return timeo;
+
+err_unlock:
+	release_sock(sk);
+	return err;
 }
 
 static void tls_rx_reader_unlock(struct sock *sk, struct tls_sw_context_rx *ctx)
-- 
2.36.1

