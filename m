Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E194F8EAC
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiDHDkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiDHDkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:40:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A7F84EF7
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:38:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EC4261D6A
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 03:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379EEC385A9;
        Fri,  8 Apr 2022 03:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649389106;
        bh=sqVkYMlRL6/j0T2/MoaDDQQMEaZ/I+lYjb2vUSAS8w4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTdVFUW4JQ65ctgAPPL07nR4rq3AyynSmax6Vqg3m6WHT3X1dU1wFpFSpx7NbQxKh
         5FweUc/4tTntKMhzF+K5PXy9ejHX/vyjtfHOCK1/eY21rmAqQvRMaGZk3cQz1vNuqk
         0CggiMzNzh/V1ap9x1FLtP3swtXdLei6Mcfny6XxIqVyOC30dOvD6obuMdV83qqNfz
         NxYhWqwT/5lvBy5hBQugdchWO4pU9kiVeLrtlyAnsV7DyBlkda0wvUYazsOj9N5uw/
         h73HcwSIw6dfF4QosQ7H7SWPiGWGTXUl9lFJ8fADTPihPMZ9M8wkK1G/uJpCl1hmf6
         Yp/WP0uPRv7TA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 01/10] tls: rx: jump to a more appropriate label
Date:   Thu,  7 Apr 2022 20:38:14 -0700
Message-Id: <20220408033823.965896-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220408033823.965896-1-kuba@kernel.org>
References: <20220408033823.965896-1-kuba@kernel.org>
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

'recv_end:' checks num_async and decrypted, and is then followed
by the 'end' label. Since we know that decrypted and num_async
are 0 at the start we can jump to 'end'.

Move the init of decrypted and num_async to let the compiler
catch if I'm wrong.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 0024a692f0f8..3b3fe455d680 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1760,6 +1760,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct sk_psock *psock;
+	int num_async, pending;
 	unsigned char control = 0;
 	ssize_t decrypted = 0;
 	struct strp_msg *rxm;
@@ -1772,8 +1773,6 @@ int tls_sw_recvmsg(struct sock *sk,
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
 	bool is_peek = flags & MSG_PEEK;
 	bool bpf_strp_enabled;
-	int num_async = 0;
-	int pending;
 
 	flags |= nonblock;
 
@@ -1795,12 +1794,14 @@ int tls_sw_recvmsg(struct sock *sk,
 	}
 
 	if (len <= copied)
-		goto recv_end;
+		goto end;
 
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
 	len = len - copied;
 	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
+	decrypted = 0;
+	num_async = 0;
 	while (len && (decrypted + copied < target || ctx->recv_pkt)) {
 		bool retain_skb = false;
 		bool zc = false;
-- 
2.34.1

