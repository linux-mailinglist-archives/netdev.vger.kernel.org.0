Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD0448A4EB
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346216AbiAKBYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346209AbiAKBYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:24:46 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B915C06173F;
        Mon, 10 Jan 2022 17:24:46 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id d18-20020a05600c251200b0034974323cfaso490517wma.4;
        Mon, 10 Jan 2022 17:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tq/iukreOG79JdYNe8HVV6T7x3H7rgMjUtsugvlEjlE=;
        b=pH6t7FlwLfwvt95KSgS+H8thrkFdfgDt4OTXvQAzPe6vleFfa/aF5R6Ief3Yqq5DN6
         xb73XSqyFVZhfXNoZjud0iQ/IP9AOr04imo8r9GpXKDWUlgL7PQVxU/O4XbaQwCMx0q7
         AZ53bEGEq7xZncNe6xK5DFpK1NJ2t8HKM/Jl22GAzx5w1CmS9bqwXMfEVqrmei+CuSnN
         s3A9FzwWpbn6iLQBE5HV4F/lzOA1ZXH2p9mZh6xkI45a0i2Z90YlEzoko8yXnbsv/9Ek
         a1G/w3Ee3AHX8kJ3k+pAVGlcTgLA/bF5u+bITNp1h0upctMvPyyy2rc8eWvhorkQm2Be
         1FnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tq/iukreOG79JdYNe8HVV6T7x3H7rgMjUtsugvlEjlE=;
        b=j8IAwEz6MucwbEtnNRLuYnt6Q7Pj5rD3j3QBJbOodlYOQkM7/3Ry3I0dnlo7haLMaV
         8PX4VQ2m7sDxSVDF7TDrjuPzoJ+6IENITCOdYMhJm8Q0De3EhHgAyqEFSTJRqyUblJxv
         qWDBFaCmKOo5yczRTiZbrxxYERfLX3kreU5EzTxu4K9eunpSKshMlwz/zFcv5QRY+kD2
         3K14CsdmubH1iharDyjKMmNpN3F5mJqM3ng8vKZTu2q+BCy7UNJHtNxA4hPdfORBdLVZ
         VwtXY+mN77sWpR3QwOjtvR2zOdHNp6MYt/qDGsBqXjrL9mf5Nfm6YpUSY0XqOUqCrZ7i
         5i9g==
X-Gm-Message-State: AOAM532FfyF+mtSh2ZfTCPbtKebXSTi/CtyCoBsQVN/Ojo+IISG2wEQK
        F1pFpm2NM/ZaM8bBvo5Et9z9CpsaBNc=
X-Google-Smtp-Source: ABdhPJwBq/cSc1x977yGly5mi7ozjF+H29JNvFK1yuBmYkHAPR/OP//iPlqYtFeqdFU5zOMvlbraZQ==
X-Received: by 2002:a7b:c449:: with SMTP id l9mr336355wmi.160.1641864284825;
        Mon, 10 Jan 2022 17:24:44 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm709886wru.26.2022.01.10.17.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:24:44 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 01/14] ipv6: optimise dst referencing
Date:   Tue, 11 Jan 2022 01:21:33 +0000
Message-Id: <6ed8db52c96c8775fd311715d2b6d5e20d5dd9a5.1641863490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1641863490.git.asml.silence@gmail.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__ip6_make_skb() initialises skb's dst by taking an additional reference
to cork->dst. However, cork->dst comes into the function holding a ref,
which will be put shortly at the end of the function in
ip6_cork_release().

Avoid this extra pair of get/put atomics by stealing cork->dst and
NULL'ing the field, ip6_cork_release() already handles zero values.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 2995f8d89e7e..14d607ccfeea 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1807,6 +1807,15 @@ int ip6_append_data(struct sock *sk,
 }
 EXPORT_SYMBOL_GPL(ip6_append_data);
 
+static void ip6_cork_steal_dst(struct sk_buff *skb, struct inet_cork_full *cork)
+{
+	struct dst_entry *dst = cork->base.dst;
+
+	cork->base.dst = NULL;
+	cork->base.flags &= ~IPCORK_ALLFRAG;
+	skb_dst_set(skb, dst);
+}
+
 static void ip6_cork_release(struct inet_cork_full *cork,
 			     struct inet6_cork *v6_cork)
 {
@@ -1889,7 +1898,7 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 
 	skb->tstamp = cork->base.transmit_time;
 
-	skb_dst_set(skb, dst_clone(&rt->dst));
+	ip6_cork_steal_dst(skb, cork);
 	IP6_UPD_PO_STATS(net, rt->rt6i_idev, IPSTATS_MIB_OUT, skb->len);
 	if (proto == IPPROTO_ICMPV6) {
 		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
-- 
2.34.1

