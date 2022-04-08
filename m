Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92CF74F9CC6
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238760AbiDHSeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238736AbiDHSeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:34:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0735BF1E96
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF737B82CEF
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 18:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361A7C385A5;
        Fri,  8 Apr 2022 18:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649442702;
        bh=WNrn0CbN27hd7Ig/SopJQIJOO8Leq09D6reEy3BW7Ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlteVsjiDEwYmWusepe+2beE6PFn1/zG4Zjp19JS9hNooSq8j8C/ZHo/UJVNyrxgu
         Utori7yYDbtoEf/urjJSeDBbUs/Lom73H7a9GuBiVdej3qMcsKflFcKFmT4GKPl42c
         1qI3gtYh9kv7kqZ+JAbvYICLl+RzFZkQbueD6oZ1HM4QKn/AvcbA85iCKnbBRl0+2v
         lPmQn6Q4YQ8RJhfp+9w8woDqYQigOEvpM5aNz7FG0exroPzBZkSN4RyY2m0yCKdN1W
         F5TnZ0TtqbiexA0l4zO8zfeEO03ZYLzeU9cgTDYjPbgErQxAD4L/4L++UK6+tUZntw
         v4SGF/NqT53dg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 08/11] tls: rx: pull most of zc check out of the loop
Date:   Fri,  8 Apr 2022 11:31:31 -0700
Message-Id: <20220408183134.1054551-9-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220408183134.1054551-1-kuba@kernel.org>
References: <20220408183134.1054551-1-kuba@kernel.org>
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

Most of the conditions deciding if zero-copy can be used
do not change throughout the iterations, so pre-calculate
them.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 183e5ec292a8..5ad0b2505988 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1763,6 +1763,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
 	bool is_peek = flags & MSG_PEEK;
 	bool bpf_strp_enabled;
+	bool zc_capable;
 
 	flags |= nonblock;
 
@@ -1788,6 +1789,8 @@ int tls_sw_recvmsg(struct sock *sk,
 	len = len - copied;
 	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
+	zc_capable = !bpf_strp_enabled && !is_kvec && !is_peek &&
+		     prot->version != TLS_1_3_VERSION;
 	decrypted = 0;
 	while (len && (decrypted + copied < target || ctx->recv_pkt)) {
 		struct tls_decrypt_arg darg = {};
@@ -1814,10 +1817,8 @@ int tls_sw_recvmsg(struct sock *sk,
 
 		to_decrypt = rxm->full_len - prot->overhead_size;
 
-		if (to_decrypt <= len && !is_kvec && !is_peek &&
-		    tlm->control == TLS_RECORD_TYPE_DATA &&
-		    prot->version != TLS_1_3_VERSION &&
-		    !bpf_strp_enabled)
+		if (zc_capable && to_decrypt <= len &&
+		    tlm->control == TLS_RECORD_TYPE_DATA)
 			darg.zc = true;
 
 		/* Do not use async mode if record is non-data */
-- 
2.34.1

