Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1078D48A503
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346342AbiAKBZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346277AbiAKBY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:24:58 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CF5C061212;
        Mon, 10 Jan 2022 17:24:55 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id r28so1717663wrc.3;
        Mon, 10 Jan 2022 17:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u7C5kpsi9JrnwpLE6F+x2Sk2xvwwtL0J8QqF8lH/geA=;
        b=mcVOCfu6sXLiAEXb5zG8Oc7E4y3xSWA+m3yGfqSbGHoARMcRkCk7TmJq3I8ANy1UI0
         ftVeblEbsDXvBg8cSxdtQP7M2ZI+IXIvorJWwQMuGH208MOQJYMKQm8IYsEGLRidypi7
         rva6J/FLcxjL/b1yuwYMSoTH1DFw4uY2zGvdzVUHSQWFvYiWFxGcD3Vp+DizLU7HBcBA
         KetFGDE7oGTTjOTZ7p+R5GxbrGVuGRfRllVGehSFxgycvLo4HLXM8zF+SkKbg6UB0+pV
         ZOpL5SDs7G5RW574KRYgEl/shQH/v1TttJ/MwOBxXoyGz+0A3SBX+suUFc9IrxUSW1+9
         xTWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u7C5kpsi9JrnwpLE6F+x2Sk2xvwwtL0J8QqF8lH/geA=;
        b=o8vRnKOHJ4JQfqAFoymGxOKPexqB/FUrSifwhUvf/8WoRjRHZ/s4IHW8z9XjFwaT0a
         Dkxh64Y4u6FXl8+8K201Q+5XsWqTgmeTqy+wbIqhddOrtTnR1qB3Cb7Jycl1jdO5ib71
         xttAA/VCjIns29gC3FDTxM3QYKH9wctsWbiLbDmGZFteBl5OA8D4CwQUnKnJI1RzutHA
         grXNPLX//IKNXkM0mULHGvN6BX7TdV3nrMELTBp0ErupPFkm5aSrwQQQb6h2JYGGzqpC
         oo2qhx5Gx17z7SzuCgwCFag2Ues3/dYlbCf8Zzap9eqx0KAGHbgjZO0LKLTiVM7ORGu+
         yEnQ==
X-Gm-Message-State: AOAM531pn+gsd5epayNlvN4Po2O+AGhqxcv6ri1/spMVikE/v7ycoG2J
        keK/uJDFJsKOcKYFujYdTvf+qIVAx5w=
X-Google-Smtp-Source: ABdhPJzFs8FnSx0Oq52b7ssQdi+Ukdaebs5ctHAkxFP4q+FDLn9BGECXCe0p5PXVcICt7eUmA+4CGg==
X-Received: by 2002:adf:e410:: with SMTP id g16mr1666142wrm.17.1641864293833;
        Mon, 10 Jan 2022 17:24:53 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm709886wru.26.2022.01.10.17.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:24:53 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 10/14] skbuff: drop zero check from skb_zcopy_set
Date:   Tue, 11 Jan 2022 01:21:43 +0000
Message-Id: <d9a6ae91295e88f15d73b42823f1d67906bc52ab.1641863490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1641863490.git.asml.silence@gmail.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only two skb_zcopy_set() callers may pass a NULL skb, so kill the zero
check from inside the function, which can't be compiled out, and place
it where needed. It's also needed by the following patch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 2 +-
 net/ipv4/ip_output.c   | 3 ++-
 net/ipv6/ip6_output.c  | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 642acb0d1646..8a7d0d03a100 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1499,7 +1499,7 @@ static inline void skb_zcopy_init(struct sk_buff *skb, struct ubuf_info *uarg)
 static inline void skb_zcopy_set(struct sk_buff *skb, struct ubuf_info *uarg,
 				 bool *have_ref)
 {
-	if (skb && uarg && !skb_zcopy(skb)) {
+	if (uarg && !skb_zcopy(skb)) {
 		if (unlikely(have_ref && *have_ref))
 			*have_ref = false;
 		else
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 57c1d8431386..87d4472545a5 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1010,7 +1010,8 @@ static int __ip_append_data(struct sock *sk,
 			paged = true;
 		} else {
 			uarg->zerocopy = 0;
-			skb_zcopy_set(skb, uarg, &extra_uref);
+			if (skb)
+				skb_zcopy_set(skb, uarg, &extra_uref);
 		}
 	}
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 6a7bba4dd04d..9881b61da493 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1522,7 +1522,8 @@ static int __ip6_append_data(struct sock *sk,
 			paged = true;
 		} else {
 			uarg->zerocopy = 0;
-			skb_zcopy_set(skb, uarg, &extra_uref);
+			if (skb)
+				skb_zcopy_set(skb, uarg, &extra_uref);
 		}
 	}
 
-- 
2.34.1

