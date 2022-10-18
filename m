Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42336027BB
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiJRJAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiJRI7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 04:59:52 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82BF1C104
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 01:59:32 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c24so13197965pls.9
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 01:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SyYgnWapL79xSGbWpqYMsssi6Z5UWEMZCCJiBQWYB4E=;
        b=HESG1GP8bzrjSt/N/3biOxlPGGIiOnjZz7pL+YQNIzKoN6I+tjDC2Pp/uhHC2z4Vs5
         aGzRvgHCUubVN8NGAjkTNHZ87zzBdFYkpHDd3e4o8LjWLUqMjpqz3WlVjyqFQs2gPvwO
         j+TfsLtFgE7q5r2dDeTn1JsFxJEDhZiBVK/VY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SyYgnWapL79xSGbWpqYMsssi6Z5UWEMZCCJiBQWYB4E=;
        b=HMamNUsmcTlhw000i9HW8Cyx4B1yEShbh/IIgEtNM1ddRJIRgi69L3svaL2w/MPfBh
         s207t7kOSjBO74KjggmQRtQqS1Qv1DynF5Q41huZeFTp2B8pn4mjZN+JT2fGaPaGa5KG
         SXQOucxnyibHF2mVdgzW+D6Uk3pAuaIyHJOya3ye+HNqTkAudrsaeVuZPPGHGzzbnIqf
         DWMYrJXFmHupVs9flSaFlB5Yht6RjIj+FKhcYWLERvQ1qdG4QPOnvL6Vwmu7WlRJve4C
         GFDLtrPNS2o2HmQgTtUPla/IOQJWjTYr5kyDV1K1jCW0/iDES0fWC1QPyaWkcRozJgUv
         6FJw==
X-Gm-Message-State: ACrzQf2oz9fUhcgF6FscaL+eTHG8QZTA0dWSy1RTLErDEzShb9pvqxN7
        mAnhYJsAq3v7mnX+DqTsqmp9RA==
X-Google-Smtp-Source: AMsMyM4nSRh7exYZnqzoianMYgY8zRtCYF+gY02raaBn1ZvuKqIPaVLoRweAhr1hoJ0whFsFPiYQPA==
X-Received: by 2002:a17:903:2410:b0:17a:b32:dbec with SMTP id e16-20020a170903241000b0017a0b32dbecmr1919815plo.163.1666083571999;
        Tue, 18 Oct 2022 01:59:31 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d25-20020aa797b9000000b00561f8fdba8esm8997458pfq.12.2022.10.18.01.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 01:59:31 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Rasesh Mody <rmody@marvell.com>
Cc:     Kees Cook <keescook@chromium.org>, GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] bnx2: Pass allocation size to build_skb()
Date:   Tue, 18 Oct 2022 01:59:29 -0700
Message-Id: <20221018085911.never.761-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1102; h=from:subject:message-id; bh=0iHouSVWi0PwtUaYPQkq5H19VoFAe1X0ZNyWzn5SCiM=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjTmrxhlbZceUvuakDoLe7hd916D4/myuLK08nIiua YaUGddiJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY05q8QAKCRCJcvTf3G3AJpR4EA CSTtT9LieM6D3o4tx5ZJ7a+zK3I/9WqHD2KIdka3We7XaR1IpSrnbypJUI70xheIXyARK5Zn80tsLE k7/i2X/PNQNJv9jzpb026t0x2BXhHogl/tlXrP4PrLQlYvBAL7XEn23/bri3WzBRbhgSsoPkeNfhlQ QKGVsgMLCItyteG6u/d5pTfNIh98Tm1hf9jG/GL6WAe/7+D8BF8BZGBwAOjiOv3Q8GbrSEHX0U/6pH /hg88vrHL6GJT8mTrn9dc6pgNB3fsn5fhIYs4/MLZ1Ahq2x81aqlRYfa5EaeSkAUEt9OQpm8TmjWQ2 nXpSqNi259io2cnMCSNpiSYSTPQ5ZhMQdDJnuwo4XCFN34OCPo3OZZu3Oyc3ZwTwmZmjrqElELGdY4 SfwSJAr3fuDULYYC3lL12WtPpGPRvJDVaODhLTcD7GLTOPDSCQx+twqsxNCH95pVm8YlHIpQ0yTSbZ bvjv9wViG6B0yqtZE+W1buh4DWWGIDVAJN1U0jCul+euwN0z8+hhYTtUDmDucD8JJyY2VEAQsqFdlZ D1xiDdO0FrU6GNtxtlAA85AfBfkUJlSKZSTDQjldvi8L//k34b7eK6Mok96/EqRa2qGd0TYnFnd1P+ ShmDVyS57kEFJJnIC/Y6S0Hp0E+cSRlSXShV8nJUBGoJsvYcz0yiQ1KeHnPA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for requiring that build_skb() have a non-zero size
argument, pass the actual data allocation size explicitly into
build_skb().

Cc: Rasesh Mody <rmody@marvell.com>
Cc: GR-Linux-NIC-Dev@marvell.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/broadcom/bnx2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index fec57f1982c8..0b2d4972343a 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -3045,7 +3045,8 @@ bnx2_rx_skb(struct bnx2 *bp, struct bnx2_rx_ring_info *rxr, u8 *data,
 
 	dma_unmap_single(&bp->pdev->dev, dma_addr, bp->rx_buf_use_size,
 			 DMA_FROM_DEVICE);
-	skb = build_skb(data, 0);
+
+	skb = build_skb(data, bp->rx_buf_size);
 	if (!skb) {
 		kfree(data);
 		goto error;
-- 
2.34.1

