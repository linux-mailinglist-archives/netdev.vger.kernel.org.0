Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDBB4F8DC1
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbiDHDkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbiDHDke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:40:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87998FC889
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:38:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28EE0B829BF
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 03:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A01C385AA;
        Fri,  8 Apr 2022 03:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649389109;
        bh=3pY0gCIrmjgOPfuzSZtfrU9lnvl+03+MazXPcbut1ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivuB9ede8YQR+yMVPoBmxK8+noBfdPnWKdINUB66yQm1D6Yuev804VwjYCleWAJHw
         hAd2GCBIiw5HAzY0NCs3Fbj5NkRk+gbghqOo/gzdpyEy0v7XzzVRQBhqOSPK/qbQf/
         AlxWktFNwz2U3KGZW/oSi87YVGQHqRpottgxqo+XIDX7en5tpxXRKe70fiubuO4/Bm
         LTKi3Da9zY0D293Vv3M1n8iz2Xn7wmEnfnrV8yNPZIP8I1AE/XGm1rLhymINz0VcU7
         QMKgkQHeV2Hcc51WFI5FY8z/d06mdJCpALrnM6x2zyKtWOqyroANyRiKnw1/NRv5oo
         b1+6Z8jCG3wHQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 08/10] tls: rx: don't issue wake ups when data is decrypted
Date:   Thu,  7 Apr 2022 20:38:21 -0700
Message-Id: <20220408033823.965896-9-kuba@kernel.org>
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

We inform the applications that data is available when
the record is received. Decryption happens inline inside
recvmsg or splice call. Generating another wakeup inside
the decryption handler seems pointless as someone must
be actively reading the socket if we are executing this
code.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 9729244ce3fc..1f6bb1f67f41 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1561,7 +1561,6 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 			      bool async)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct strp_msg *rxm = strp_msg(skb);
 	struct tls_msg *tlm = tls_msg(skb);
@@ -1600,7 +1599,6 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		rxm->full_len -= prot->overhead_size;
 		tls_advance_record_sn(sk, prot, &tls_ctx->rx);
 		tlm->decrypted = 1;
-		ctx->saved_data_ready(sk);
 	} else {
 		*zc = false;
 	}
-- 
2.34.1

