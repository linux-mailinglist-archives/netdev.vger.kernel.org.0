Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FA34F8E7F
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbiDHDkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiDHDkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:40:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36386266
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:38:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4B4DB829B7
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 03:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D302C385A9;
        Fri,  8 Apr 2022 03:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649389108;
        bh=GVZXC7mH0g+U1BZHOapUcIhphyCEffZDHkjiOClfcdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btN4TBQbtjXhLBCr1vj9xYs1j7L1J8mGf/reMyDTwLkb13wvuPgmbgmhzTYC+Sbn6
         l1E0709J0qfBESQPcj48ZpXAC75SR7dYAwJWCZ5PFS7e5gPbQUz58dHAfD/nSv9X/u
         HtFs1SOcjtQSLUj2q1qRUXqx63I4xbC/p9K+qcQNJPUtduvK3ciP3jF5ptJZGRhur3
         Y4D+Op9fm1sV4mWt4o0zKi4eS/zgB7MI2MGmmp4nw3PH4UL/ctRKesDhRgMK8oIEC1
         RjuYdIUEz4Vu0u3LuLWBYdvGiX3pYFDvuTaBtcqUgdQycFhqFlsKS1/9v/qXU05vgo
         d8EyRoAERt1RQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 05/10] tls: rx: init decrypted status in tls_read_size()
Date:   Thu,  7 Apr 2022 20:38:18 -0700
Message-Id: <20220408033823.965896-6-kuba@kernel.org>
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

We set the record type in tls_read_size(), can as well init
the tlm->decrypted field there.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 167bd133b7f8..eb2e8495aa62 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2101,10 +2101,10 @@ static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
 
 	/* Linearize header to local buffer */
 	ret = skb_copy_bits(skb, rxm->offset, header, prot->prepend_size);
-
 	if (ret < 0)
 		goto read_failure;
 
+	tlm->decrypted = 0;
 	tlm->control = header[0];
 
 	data_len = ((header[4] & 0xFF) | (header[3] << 8));
@@ -2145,9 +2145,6 @@ static void tls_queue(struct strparser *strp, struct sk_buff *skb)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(strp->sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
-	struct tls_msg *tlm = tls_msg(skb);
-
-	tlm->decrypted = 0;
 
 	ctx->recv_pkt = skb;
 	strp_pause(strp);
-- 
2.34.1

