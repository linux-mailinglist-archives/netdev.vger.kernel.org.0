Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1BD354C02D
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 05:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352000AbiFOD1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 23:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351586AbiFOD13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 23:27:29 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFA94B1F0;
        Tue, 14 Jun 2022 20:27:21 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h192so10236258pgc.4;
        Tue, 14 Jun 2022 20:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=+vZnS8Jw84zF/TVL4AsTQVpMK63h4KtHF4A6QNX+nwo=;
        b=MmisO9JwawCFfanLdvjRHkmOchm/G7BSBUyHcpZ/IRasg5PygTAY031pKfKyWixEHT
         uBA8MhUFcPJT/gSPIc8ZHfhYep3ceccGNxwcmUtiVsny/64m6+SDxlp4YX0yWGyC50hX
         0a05L8t9zBGHjmA06sRXhAFYpmNDNSYURz/xyYS98NZWxOI1JKgVWSWlBJKqWQyDPMQx
         c99PiQ4BkL3B/YiHQR44uLXeho+lfxsYKYgUswZvz17/GCyW3jz6bGjCt3AoOS9Hd7xH
         AL+Q2YGpQFbpurH2n77JV5ASvZZRinu/k9rwtrfCuoHZ1+7qI3fnFGJCI7PhRQvKuqkL
         +m6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+vZnS8Jw84zF/TVL4AsTQVpMK63h4KtHF4A6QNX+nwo=;
        b=rossS+OF3VVahX4MIjBis7qJ3JN/3yfCqJU/DryvaxwraV/L/DaLtOxOfvpZg25AOR
         YMn115wepk4ZZDj6w6xWa+DgEWZ4EJ3anV4Tr4MzAXlllCpfEbMD1AR4MZOxyCxjpd/r
         4RE6GI42psbP9NI8Kz6gwBNYz8FbRpmoknL6YIFNlz57eJ6P0roJz1ipxnvF87RMuvl3
         H+VkwSwAZh5n1YcglT2ykUewyjHTgBlHKWvqBOuf5Au7dJWb+73Yii2nsfJ6nMwH06T1
         ZGl0MCMIKnDnzZtbBsJLtCiSUWtMbLDeR3VeYFxe3/28mqKAJxBjHmPbm1uuva4Oz+go
         +4Vg==
X-Gm-Message-State: AOAM530hLdKOtCjOkSMn4WIHXXtFGC0nIW2GQWjt6hcZVxZBVxoOWqNo
        BO87AVMfgWN1/boFNaoyso0=
X-Google-Smtp-Source: ABdhPJxA7ono5ovOa3M/nqLYt0HqcvcKG1CEcZ0naf4MTyFvwH8OMJ3Q8Nw0azb8vhqJRleTVofuxQ==
X-Received: by 2002:a62:e116:0:b0:51b:c452:47e6 with SMTP id q22-20020a62e116000000b0051bc45247e6mr7800417pfh.25.1655263640660;
        Tue, 14 Jun 2022 20:27:20 -0700 (PDT)
Received: from DESKTOP-8REGVGF.localdomain ([211.25.125.254])
        by smtp.gmail.com with ESMTPSA id z19-20020aa79593000000b0050dc76281ddsm8371447pfj.183.2022.06.14.20.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 20:27:20 -0700 (PDT)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sieng Piaw Liew <liew.s.piaw@gmail.com>
Subject: [PATCH] net: don't check skb_count twice
Date:   Wed, 15 Jun 2022 11:24:26 +0800
Message-Id: <20220615032426.17214-1-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NAPI cache skb_count is being checked twice without condition. Change to
checking the second time only if the first check is run.

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 net/core/skbuff.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5b3559cb1d82..c426adff6d96 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -172,13 +172,14 @@ static struct sk_buff *napi_skb_cache_get(void)
 	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
 	struct sk_buff *skb;
 
-	if (unlikely(!nc->skb_count))
+	if (unlikely(!nc->skb_count)) {
 		nc->skb_count = kmem_cache_alloc_bulk(skbuff_head_cache,
 						      GFP_ATOMIC,
 						      NAPI_SKB_CACHE_BULK,
 						      nc->skb_cache);
-	if (unlikely(!nc->skb_count))
-		return NULL;
+		if (unlikely(!nc->skb_count))
+			return NULL;
+	}
 
 	skb = nc->skb_cache[--nc->skb_count];
 	kasan_unpoison_object_data(skbuff_head_cache, skb);
-- 
2.17.1

