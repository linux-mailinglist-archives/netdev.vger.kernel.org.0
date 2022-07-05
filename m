Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3047567AFA
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 01:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiGEX7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 19:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGEX7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 19:59:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316DB183BE;
        Tue,  5 Jul 2022 16:59:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBF4261180;
        Tue,  5 Jul 2022 23:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB49C341C8;
        Tue,  5 Jul 2022 23:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657065575;
        bh=Ln0FurXcuUKBrZCr4kEssdaqud7WJg9xDuXtLI2q/0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVL0Gt9b7RgB7pScq8//jVJsGNCgegV9JS/v2TEr5qb5a1YXhKaTmc2evzMV7S4AV
         9d4cAEYTj305cluRcWOjukai7h8xFGwIC69oq4qMl7+m8ZbTm/9mYrrVdNA0DEnheU
         ho3PVoNLJvsrnFgdArQBINPIAjVhk7jQSQux0yrbiwc8hhFIU9Cyk2+BNP5WdzYKlO
         V7W96c7JmVqWV8sInQQsLnclmliaytUBAJ17mGjVvk0sa9HbXdQ9BslE7da6apUHfw
         29RNNiF9S/0m51s1ge+fF8PL6DJlfrleP20K/OIE2QeWExawiRmMyAcUMzQpp98/K8
         3d0OuNiAp9hqA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        john.fastabend@gmail.com, borisp@nvidia.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        maximmi@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/5] tls: rx: don't include tail size in data_len
Date:   Tue,  5 Jul 2022 16:59:22 -0700
Message-Id: <20220705235926.1035407-2-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220705235926.1035407-1-kuba@kernel.org>
References: <20220705235926.1035407-1-kuba@kernel.org>
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

To make future patches easier to review make data_len
contain the length of the data, without the tail.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 0513f82b8537..7fcb54e43a08 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1423,8 +1423,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	u8 *aad, *iv, *mem = NULL;
 	struct scatterlist *sgin = NULL;
 	struct scatterlist *sgout = NULL;
-	const int data_len = rxm->full_len - prot->overhead_size +
-			     prot->tail_size;
+	const int data_len = rxm->full_len - prot->overhead_size;
 	int iv_offset = 0;
 
 	if (darg->zc && (out_iov || out_sg)) {
@@ -1519,7 +1518,8 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 			sg_init_table(sgout, n_sgout);
 			sg_set_buf(&sgout[0], aad, prot->aad_size);
 
-			err = tls_setup_from_iter(out_iov, data_len,
+			err = tls_setup_from_iter(out_iov,
+						  data_len + prot->tail_size,
 						  &pages, &sgout[1],
 						  (n_sgout - 1));
 			if (err < 0)
@@ -1538,7 +1538,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 
 	/* Prepare and submit AEAD request */
 	err = tls_do_decryption(sk, skb, sgin, sgout, iv,
-				data_len, aead_req, darg);
+				data_len + prot->tail_size, aead_req, darg);
 	if (darg->async)
 		return 0;
 
-- 
2.36.1

