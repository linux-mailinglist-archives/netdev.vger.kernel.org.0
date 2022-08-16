Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69129594F38
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 05:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiHPD7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 23:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiHPD62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 23:58:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E51341FA0
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 17:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25B36B8124C
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 00:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C364C433C1;
        Tue, 16 Aug 2022 00:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660609445;
        bh=MphNuGbR3AIrF2JRL4XaNjWpnqJFSEM2UU9IJX7/j70=;
        h=From:To:Cc:Subject:Date:From;
        b=tysU8/On9VDaENVAki6hW7yvt8w0fD2/7pQA0EKiw9LjdkakdocHiv9znu4lQdkbp
         aOmKyIVMD+6MUf1InOcCpnCGzJe5ntEVOjKmDT3hHm4kVgwK2Ai72mTslYhfXGYSOF
         thUwXO7BTBRXZhJq4L7eFNYUkbLVm/vkZdzoMbOz6Eyax1Xv3JgggXPXy/iD8UIePd
         tGjTQMKGc8S0M1pSWJ6RZr3/W7skTw7D9YbRlNoU39MRpPG2Jala3zEnFdlkxs7//Y
         9vYSXNKLZcVzNQInUGw0lhjGP2AMankpRLDwVviiQrzywXnagTeRJWKoqycbOo/ttd
         l5mXCznSCH4Rg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+abd45eb849b05194b1b6@syzkaller.appspotmail.com,
        borisp@nvidia.com, john.fastabend@gmail.com
Subject: [PATCH net] tls: rx: react to strparser initialization errors
Date:   Mon, 15 Aug 2022 17:23:58 -0700
Message-Id: <20220816002358.509148-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
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

Even though the normal strparser's init function has a return
value we got away with ignoring errors until now, as it only
validates the parameters and we were passing correct parameters.

tls_strp can fail to init on memory allocation errors, which
syzbot duly induced and reported.

Reported-by: syzbot+abd45eb849b05194b1b6@syzkaller.appspotmail.com
Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: borisp@nvidia.com
CC: john.fastabend@gmail.com
---
 net/tls/tls_sw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index f76119f62f1b..fe27241cd13f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2702,7 +2702,9 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 			crypto_info->version != TLS_1_3_VERSION &&
 			!!(tfm->__crt_alg->cra_flags & CRYPTO_ALG_ASYNC);
 
-		tls_strp_init(&sw_ctx_rx->strp, sk);
+		rc = tls_strp_init(&sw_ctx_rx->strp, sk);
+		if (rc)
+			goto free_aead;
 	}
 
 	goto out;
-- 
2.37.2

