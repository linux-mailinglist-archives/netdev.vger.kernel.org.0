Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7625A5204F7
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 21:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240448AbiEITNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240431AbiEITM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:12:56 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A862C5107
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 12:09:00 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id s16so2725687pgs.3
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 12:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/z4M3GBGw6/WGXULFKw/7yx8sXpcmNAe2LOaka9wT5k=;
        b=P4PNCkNxZzf+Qp+/hcaor5d4IiBBYo198uaFWDrEPBrihRc99+d1kdRvulgT2Gt4VZ
         L8qqOLgBWYRlE/DPuCn+f6E674unzOR2fPQfyeD0oXeRyRAE1Ps3ASfEL0qhNA+qgbYL
         u8E0GL8mScLV87hwy6UYDX67F0XzoZPrc8XGbuCtfBjc/Iuzhi/TxsX42AssUUJ43AeL
         62lCmqQwJyBdaU5q3Xf9cxvjbgTkLJ4Rd2ltMVY1D/J4/fZKf+PuzhSJv1Jb8BCjPDCH
         2suYkqUlLPcAVNhF3zY+lWoMXcFfjqK2PL29Xywq+a/gmnaUw2IbMuihMTCsCo2Yd9q9
         m8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/z4M3GBGw6/WGXULFKw/7yx8sXpcmNAe2LOaka9wT5k=;
        b=gW+LRH0oTyw/1zDgfYkoBkKJmAF6plNbZLIgKRpKaqrhoLRZ4mI6ZpdI1hoU6VRS5o
         stG1OjWnqVxdahZVwkiLmvPrayQd4oe0GI79UN9Nghm5K2iDTFNzW1odX1O+5+RN2oYM
         XX/IXVPCR62GRZ1qCMhp1CwOnjLoQtzLY+SO5JsNPzKWZl3GMQ5X1QggYSODS6PbZzW1
         GQ7xNMHMiM8W2oGaBxR2aMgrfi3ULGV7yECe67wee4u9Uk77k5nYdCu9RLde2Rgd16Gj
         ujPcg/xIy6OdHAXlywX1MIOIE/dkww2mG/HJZMTVzip7vv9AzYJCjsq3jyvoCVyVX44S
         R6Ug==
X-Gm-Message-State: AOAM533F+jALWlCNDVfsNQxAcIHOnLLjqo3Q/UzREX5/UUojtkms5bRF
        agnj9mvRai46ehfSTCLF8NA=
X-Google-Smtp-Source: ABdhPJypJATFp8RkOv6KYmXmuEg+IWzP6NTqkPWFypxNVMz/4mcGgVzUcAprUmR8/DK4olIpEZrgSw==
X-Received: by 2002:a63:41c1:0:b0:3c6:e382:c125 with SMTP id o184-20020a6341c1000000b003c6e382c125mr1491668pga.383.1652123340014;
        Mon, 09 May 2022 12:09:00 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id a6-20020aa79706000000b0050dc7628174sm9032631pfg.78.2022.05.09.12.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 12:08:59 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/4] net: warn if transport header was not set
Date:   Mon,  9 May 2022 12:08:50 -0700
Message-Id: <20220509190851.1107955-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220509190851.1107955-1-eric.dumazet@gmail.com>
References: <20220509190851.1107955-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

Make sure skb_transport_header() and skb_transport_offset() uses
are not fooled if the transport header has not been set.

This change will likely expose existing bugs in linux networking stacks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index d58669d6cb91aa30edc70d59a0a7e9d4e2298842..a1c73fccccc68641fe46066e6d1195b31483ca4c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -42,6 +42,7 @@
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <linux/netfilter/nf_conntrack_common.h>
 #endif
+#include <net/net_debug.h>
 
 /* The interface for checksum offload between the stack and networking drivers
  * is as follows...
@@ -2804,6 +2805,7 @@ static inline bool skb_transport_header_was_set(const struct sk_buff *skb)
 
 static inline unsigned char *skb_transport_header(const struct sk_buff *skb)
 {
+	DEBUG_NET_WARN_ON_ONCE(!skb_transport_header_was_set(skb));
 	return skb->head + skb->transport_header;
 }
 
-- 
2.36.0.512.ge40c2bad7a-goog

