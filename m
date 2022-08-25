Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5625C5A0FF6
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 14:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbiHYMId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 08:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbiHYMIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 08:08:32 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE56FAA4DC
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 05:08:31 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id u9so10122701ejy.5
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 05:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=XxpYlizTZAXVh4l+2YqYcozws9Z58fUnSTOS7GSGYMg=;
        b=gDZlGdRCUANUDC/zA8Pz5hK9+teS3y06IxR6cBk3QJ/jLLJ3nOsdiHGke+jTxYWfzb
         tyqufoVKBW/yaR5EzvgF0RwHXY060yP7iPxMXRTMj8oV0GCaI70vicYDm1ulgu4vNWt5
         q5v2233CsGTN4kVogEZhztZcQqZMPRjIW0MEcv0dZr9dB9AgPxiaQd1Qto4fKQLm018N
         k2cidmenN/H+yBnUYv+unsTiARQy2lmBomhGDAul3s8vaTwuTdAde6h1EaOPt2Ggfsln
         YrE2y/4PeVMxwLe2yhbVA0lUhgpo5rFjjqYJAOCBl5TiKvKJ1eaPjwSEMY8TdFzFrQVB
         fRmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=XxpYlizTZAXVh4l+2YqYcozws9Z58fUnSTOS7GSGYMg=;
        b=p6+ZPc51jh0KOVyGvft8PtmsDhenrg9HjhUo4EJbyuZBhWs+EFlJMjM9sukZiKo9GR
         hL5PrWPJlYU6XYiv1fZCbAGIF0dC7OMfMlR9HhleT+Qmj+m9U88Qq9vHs1FPchsZ7jXs
         bUwzZNEycX2SHbdV+POlbhBxiWqvClB53s61+kVT3utsCPT3D0fHeNXEbJqsPpocFAzN
         +aZ/DUraNyc3qzP9deO6p/IIGlHx8mExItoxRq/zipqdCna9sHmPA1R6MhvmGHxwPjgK
         jP4bgH8ctX45R671qVQdcKIffRdqlrwZMJMxoxT+749dFRklVvhX14vxaqaGi868qDgP
         Lalw==
X-Gm-Message-State: ACgBeo3YfNC+2h8G1sub2NFiImpPN5YJFdNP6cdG8YC5mNHA7kJCP+4Y
        o9BP/W0zDdT5XL+EFdQCf0468V3VAAMrjQ==
X-Google-Smtp-Source: AA6agR4sUZlcm/ey6yKKgn0PyYqOqZ2fcYC0VlR3fLtZcWIdNuuhdDKLmOCPIVmz1rpVmlUImT+Cdg==
X-Received: by 2002:a17:906:3a15:b0:73d:80bf:542c with SMTP id z21-20020a1709063a1500b0073d80bf542cmr2250090eje.633.1661429309692;
        Thu, 25 Aug 2022 05:08:29 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:6d47])
        by smtp.gmail.com with ESMTPSA id k15-20020a1709063e0f00b0073c1e339a37sm2395351eji.149.2022.08.25.05.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 05:08:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] net: unify alloclen calculation for paged requests
Date:   Thu, 25 Aug 2022 13:06:31 +0100
Message-Id: <b0e4edb7b91f171c7119891d3c61040b8c56596e.1661428921.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consolidate alloclen and pagedlen calculation for zerocopy and normal
paged requests. The current non-zerocopy paged version can a bit
overallocate and unnecessary copy a small chunk of data into the linear
part.

Cc: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/netdev/CA+FuTSf0+cJ9_N_xrHmCGX_KoVCWcE0YQBdtgEkzGvcLMSv7Qw@mail.gmail.com/
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/ip_output.c  | 5 +----
 net/ipv6/ip6_output.c | 5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index d7bd1daf022b..14f7c4dadbf3 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1109,10 +1109,7 @@ static int __ip_append_data(struct sock *sk,
 				 (fraglen + alloc_extra < SKB_MAX_ALLOC ||
 				  !(rt->dst.dev->features & NETIF_F_SG)))
 				alloclen = fraglen;
-			else if (!zc) {
-				alloclen = min_t(int, fraglen, MAX_HEADER);
-				pagedlen = fraglen - alloclen;
-			} else {
+			else {
 				alloclen = fragheaderlen + transhdrlen;
 				pagedlen = datalen - transhdrlen;
 			}
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index f152e51242cb..a60176e913a8 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1648,10 +1648,7 @@ static int __ip6_append_data(struct sock *sk,
 				 (fraglen + alloc_extra < SKB_MAX_ALLOC ||
 				  !(rt->dst.dev->features & NETIF_F_SG)))
 				alloclen = fraglen;
-			else if (!zc) {
-				alloclen = min_t(int, fraglen, MAX_HEADER);
-				pagedlen = fraglen - alloclen;
-			} else {
+			else {
 				alloclen = fragheaderlen + transhdrlen;
 				pagedlen = datalen - transhdrlen;
 			}
-- 
2.37.2

