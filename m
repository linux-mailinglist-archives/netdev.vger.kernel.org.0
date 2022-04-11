Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99944FC4EE
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 21:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245615AbiDKTVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 15:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiDKTVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 15:21:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F141037
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:19:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 289A1B81880
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999BAC385A3;
        Mon, 11 Apr 2022 19:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649704763;
        bh=+8W2kxieqUVgaKFjxUVIIqoNA3mR6Dh1fOFgjVDkDCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kflmx18OBuRjdfMwIHutxQ0+P0K1fDV8BBKJqGmPzjeL23vRZncrBDg/QfCgAy/cz
         ld9GlL2TvFtln3BKMYdLtgrXpLe9/two8vPdHNKYNKLNAexi79UC4p8DlAsERAhy5o
         2gqhsNkk5039XSKkDiPXR4xIoxkghMeaK4FQypbeUxV1iFb21Z/HfG6/amwhjdM7wb
         jhyacZZjPCEMuLe6wMAsV0x2mPrvBZpySNNVz2xfY1k+5E6qpL+pld2TawbmnjEeay
         tfd4FXaVLsMVariVVqX/KMsNxk2w68QNddK7ipVSGHxBoAKnMdsvUshQo8meB7smBn
         NelAbQUMPDnoA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 05/10] tls: rx: assume crypto always calls our callback
Date:   Mon, 11 Apr 2022 12:19:12 -0700
Message-Id: <20220411191917.1240155-6-kuba@kernel.org>
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

If crypto didn't always invoke our callback for async
we'd not be clearing skb->sk and would crash in the
skb core when freeing it. This if must be dead code.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index b3a15dc3d4eb..fcecf4ef8922 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -268,9 +268,6 @@ static int tls_do_decryption(struct sock *sk,
 	if (ret == -EBADMSG)
 		TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
 
-	if (async)
-		atomic_dec(&ctx->decrypt_pending);
-
 	return ret;
 }
 
-- 
2.34.1

