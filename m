Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D84585A42
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 13:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbiG3Lkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 07:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiG3Lkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 07:40:31 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D98DF7A;
        Sat, 30 Jul 2022 04:40:30 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id a18-20020a05600c349200b003a30de68697so5108731wmq.0;
        Sat, 30 Jul 2022 04:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n7XzjcJpXfeDeN0N6bD2rYAtzteaNAW8TEQ70M39WGE=;
        b=nsvGR89Exucsj6s6UQyamXy53TNOhzxln9vKRIqDxDr0UKXzdeu5WDvTtFYg052SVd
         hC8m28n4qkzv8CrerqL8Y5zkKggrZg0JGCONh3iitbo+WI7XCTgC44p1M+7hMOWsHRVU
         5c8NmnuyCxIBZ9Ho1e13XjUW2dOFNEX3bR5nXk/euNZpdEU1TLOvYQXOpSRwdXYGzJ1Q
         FJAH5pbvXJcPtWTLRZpBcD2SPHAOeamd6TgingwkBm3ebQ5lHqJILYQ37m029ZDlMLwe
         wSDpbM0Oa8EbrvQF1Mb1h0W7EWnG1kFvZ0Ziks43g0ASQp8n4blxGy7jDfIwsL4wKFCm
         kVeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n7XzjcJpXfeDeN0N6bD2rYAtzteaNAW8TEQ70M39WGE=;
        b=CPSrqc2yWwxF/2oremBOQjnBE8UsW+35EpZoA3Y/z01JokGmlc/3IXPYcB03hM2xi6
         S8wFxMT1IVEd+NCHrHz3trAjcrpPIZZRjgweWqPkrOlCuPmUMozat2qYmmpKi/Oo6chm
         4Pnmyi/C/twElBS5btA+B+jrnHWooFDKwKGmQmkJmRpNOo9rvpKPuzqWpWnlOTXzOL68
         cra2cuV1Fxx9HE+2iu8Kz13SdtfVJgutbXo1V8MDYV9dxITn4Bg5FULyXP8pdzErXnWT
         EyHBYnIgk6SpLPXpH4Xt7/GvM1sLhKOCOrtTLMQ0WnSnOdF9lchrSmWQK3Uig3+ceY40
         cKLg==
X-Gm-Message-State: AJIora8F3Hv6s1JYECcVtCgY22N03kqRsHsaayS/0KxV9hZyNnsoOfv3
        uzt5b6qNSFNAr/s/qppDi2k=
X-Google-Smtp-Source: AGRyM1tAU/z7TliT3qoqSCY9k9rrs7Z1Hvc8puGpUeHnxnyYJg5vVyncTVdsHHbwqFKR74nBUTKPBQ==
X-Received: by 2002:a05:600c:22c7:b0:3a3:6dfb:49eb with SMTP id 7-20020a05600c22c700b003a36dfb49ebmr5279513wmg.99.1659181229326;
        Sat, 30 Jul 2022 04:40:29 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id b2-20020a5d4b82000000b0021e5bec14basm6278099wrt.5.2022.07.30.04.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 04:40:28 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] tls: rx: Fix less than zero check on unsigned variable sz
Date:   Sat, 30 Jul 2022 12:40:27 +0100
Message-Id: <20220730114027.142376-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable sz is declared as an unsigned size_t and is being checked
for an less than zero error return on a call to tls_rx_msg_size.
Fix this by making sz an int.

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 net/tls/tls_strp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index b945288c312e..2b9c42b8064c 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -187,7 +187,8 @@ static int tls_strp_copyin(read_descriptor_t *desc, struct sk_buff *in_skb,
 			   unsigned int offset, size_t in_len)
 {
 	struct tls_strparser *strp = (struct tls_strparser *)desc->arg.data;
-	size_t sz, len, chunk;
+	int sz;
+	size_t len, chunk;
 	struct sk_buff *skb;
 	skb_frag_t *frag;
 
@@ -215,7 +216,7 @@ static int tls_strp_copyin(read_descriptor_t *desc, struct sk_buff *in_skb,
 
 		/* We may have over-read, sz == 0 is guaranteed under-read */
 		if (sz > 0)
-			chunk =	min_t(size_t, chunk, sz - skb->len);
+			chunk =	min_t(size_t, chunk, (size_t)sz - skb->len);
 
 		skb->len += chunk;
 		skb->data_len += chunk;
-- 
2.35.3

