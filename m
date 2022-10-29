Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338E7612327
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 15:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJ2NLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 09:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiJ2NLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 09:11:09 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF2C68CE7;
        Sat, 29 Oct 2022 06:11:06 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso12202759pjg.5;
        Sat, 29 Oct 2022 06:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/X4FUMErTbSXHi7NztKKgHeZBiz/PANDAO+0/r0jpSo=;
        b=FwtcjpMMhXktv2Q5T+BzKd+LQYO2JAIc77TSXa7VNqsJyPNQ9vUMasTrM2hj/vM8/3
         x/1LAtjeS7rcyhPhBFP4z3fmNE6Es2lGxSAJnGZq2P+EPb3UFsTkyTHXUrZbxImwcK6A
         4pBl5A8Z0+mBeN3smBxLaOC4ZrKoyEeg98pjsQz0pEl/6RrLlqcfjl2vaH3X1quacz22
         uxF3EbA5GPE9L9b2MVGJrK4u41ukNP/9cH0yz/RxozSW6x2qJO9SgikuYp48sb8fxiPt
         4TQwYOqi44QjtIszjY9cZdggfeM0HDNb3308fQBbnqgRb+kQuba0nbumU3ildGccdl9N
         +xZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/X4FUMErTbSXHi7NztKKgHeZBiz/PANDAO+0/r0jpSo=;
        b=jN5QkKEGl9rrAn3TPhu1qbJZX312Wo5GeGyqjns+fqkQdNv2X9juALWVsbJ0xDcUFP
         BJ9seZJZc3VUvspqU4HqlaSUhM6e0srj1PDNoDT7meqah0jTJQg61znYzeRNHnjs51Pe
         ZRdzKhF4O9wekKZOy6ZL1rt4f8Vxn1tKWRYXhmKYUYeNXbEgWnoe6Cyd+TG+6v/kJuSX
         NlNvbICjjEeuM7Z+h6JB23sA21BfTtNTXLfhsNv9J2ONxw2xxHy9uyuAbXJ6Dl6MWIDm
         OA24KGwl44J6tOOvkMw9SClJU+DAfoJ9PuGBAOp1CXSETk6oxraWeEfF0OAWDxL9DuTs
         3zIA==
X-Gm-Message-State: ACrzQf2sgasB/yBS7c7qikvwFy8Nw46fEyFoKCWnVREiGmcNavMhmc+V
        yCxe+d4aa8FdSooUXmHz2FU=
X-Google-Smtp-Source: AMsMyM5xEF5e1zevoBBWI+C+FJ5nVIKRCTu27WL4xS7HzsRQkE0S7pnLzLpzxDFiUDqUfcI5pXiw6A==
X-Received: by 2002:a17:903:50e:b0:182:631b:df6f with SMTP id jn14-20020a170903050e00b00182631bdf6fmr4297256plb.66.1667049066487;
        Sat, 29 Oct 2022 06:11:06 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.21])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b001811a197797sm1244069plp.194.2022.10.29.06.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 06:11:05 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com, kuba@kernel.org
Cc:     davem@davemloft.net, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, imagedong@tencent.com, kafai@fb.com,
        asml.silence@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/9] net: skb: introduce try_kfree_skb()
Date:   Sat, 29 Oct 2022 21:09:49 +0800
Message-Id: <20221029130957.1292060-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221029130957.1292060-1-imagedong@tencent.com>
References: <20221029130957.1292060-1-imagedong@tencent.com>
MIME-Version: 1.0
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

From: Menglong Dong <imagedong@tencent.com>

In order to simply the code, introduce try_kfree_skb(), which allow
SKB_NOT_DROPPED_YET to be passed. When the reason is SKB_NOT_DROPPED_YET,
consume_skb() will be called to free the skb normally. Otherwise,
kfree_skb_reason() will be called.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 59c9fd55699d..f722accc054e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1236,6 +1236,15 @@ static inline void consume_skb(struct sk_buff *skb)
 }
 #endif
 
+static inline void try_kfree_skb(struct sk_buff *skb,
+				 enum skb_drop_reason reason)
+{
+	if (reason != SKB_NOT_DROPPED_YET)
+		kfree_skb_reason(skb, reason);
+	else
+		consume_skb(skb);
+}
+
 void __consume_stateless_skb(struct sk_buff *skb);
 void  __kfree_skb(struct sk_buff *skb);
 extern struct kmem_cache *skbuff_head_cache;
-- 
2.37.2

