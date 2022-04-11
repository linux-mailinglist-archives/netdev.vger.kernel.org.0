Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308454FC4F6
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 21:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349496AbiDKTV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 15:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239383AbiDKTVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 15:21:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7CF103B
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:19:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51811B81850
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87082C385A3;
        Mon, 11 Apr 2022 19:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649704766;
        bh=j1e0SPjzhz38M19+G6O/kdCeqKsR36rYWkCm7o3ONfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZqp0SFJfgXzoLJ7WkwdevSSco26WBt/7uMe24ilMbD3Fm52TfRAqjEFWBnRvG1WO
         UZiW80voqO4mCCJJfUT3VwPlP62EM1bZJLb4HmcwOrjeyTaQfgg8hFQT3jdcVUO633
         EWAVxednDughKBD22Buh5mCNPpAjZEsYwKamZhW5EqEYwF+8AVNYpvYF4OZl0J/SDg
         ESKGO1p7C46CUuIKXMujPwqTIlgi6Efx1C7qvWhPrJKDFhalCE/VD4NH7nRblkzkey
         k6H0KPIRv2EkIFoWC9iVGqiXVlDB2eAF9Ojlrp9Fhet/hAIXiBjDHjY6xDSr/XUSn2
         DGb18VxRJNVhQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 09/10] tls: rx: use MAX_IV_SIZE for allocations
Date:   Mon, 11 Apr 2022 12:19:16 -0700
Message-Id: <20220411191917.1240155-10-kuba@kernel.org>
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

IVs are 8 or 16 bytes, no point reading out the exact value
for quantities this small.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 6b906b0cb2fd..fcbb0e078d79 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1452,7 +1452,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	aead_size = sizeof(*aead_req) + crypto_aead_reqsize(ctx->aead_recv);
 	mem_size = aead_size + (nsg * sizeof(struct scatterlist));
 	mem_size = mem_size + prot->aad_size;
-	mem_size = mem_size + crypto_aead_ivsize(ctx->aead_recv);
+	mem_size = mem_size + MAX_IV_SIZE;
 
 	/* Allocate a single block of memory which contains
 	 * aead_req || sgin[] || sgout[] || aad || iv.
-- 
2.34.1

