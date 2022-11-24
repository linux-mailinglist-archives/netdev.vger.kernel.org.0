Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7EC637821
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiKXLyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiKXLyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:54:37 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EFEC6060;
        Thu, 24 Nov 2022 03:54:36 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id c65-20020a1c3544000000b003cfffd00fc0so3783086wma.1;
        Thu, 24 Nov 2022 03:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G6iVGny6VRURevBsyqO7R1HKaQUKuUiW86Zp2Vq5Tz8=;
        b=Mv2M6G4Ij/EMwkUN8XHPEd4TyhXrEXpyfevG3WSgfcAUlmWOjNWT7Ik0QX8IeF1QEd
         CmdNn9Uh2h7aEgb6168ozGZngN11XWJwGPeHxtOwLDsCPkHw5yTnDToMvFbWxeFTf/nC
         OSK15MP9OU4n38ZYbK6AnIYqLHOc53vVMGXny8gixoZ+MdmC1QLa5oFzCC0BAuXF3tHQ
         GGuMBqu8DGtDDpNYtcdBSfHQ9wKLUyWtk94r3ZhokIMaolM5JJv9H7x78fyYKBHXnpxD
         4Nt6xnFUFLNxC3St0Y0ihqPSKXa+manVYUu9/sLnsUAjE5iX6LSsR6wgwiz4RdmtQ1xF
         cn8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G6iVGny6VRURevBsyqO7R1HKaQUKuUiW86Zp2Vq5Tz8=;
        b=ZaQW6DjQNKSXsAPfMp/0P2M9b/zQ7GWjzvpspD6N+OtgkxSgNoaW+G/l+I0pQ0kr0e
         DcF0LmUDi7BjEPCiVAjuf8UKj+IxGyfZ6d5shnsN4U9YVJvBVgzsV0P+2KKhl7q8fxMd
         O2Ct3Xf1wwygA90/hYNMvZTnXk15ST2FvO8s7oriKfnY55wqcNaYbvZOq1lLQs9bDPum
         9tNyhB2NNN1zAPQULMGe2wCM7phEONjjV10yj8x+K2a2r3JKQqc+weC0Jw0SzoZVLgi2
         2MQqNu0jB7lumGLCLvDyvaoU9QAccm/Vh02SRQRFn6WYRbc1KjM8InfMBobg/3OmAFps
         +kRw==
X-Gm-Message-State: ANoB5pmnU6nM1vFMuFyNTAAv+bGJGU2Oup9RHOnz5llOA83XPepN65S2
        Wn0bMWYUo0HtNXsbJWtPPGs=
X-Google-Smtp-Source: AA0mqf6qRyquuCAMR5ZdIUnl363lEg/aKyK7jwgZiKYvaUlNpVpQKw1t3jNjY7OkRsqC9bGly01+5w==
X-Received: by 2002:a05:600c:1e1a:b0:3cf:7959:d8be with SMTP id ay26-20020a05600c1e1a00b003cf7959d8bemr15674994wmb.85.1669290875517;
        Thu, 24 Nov 2022 03:54:35 -0800 (PST)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id f14-20020a05600c154e00b003c6f3e5ba42sm6228191wmg.46.2022.11.24.03.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 03:54:34 -0800 (PST)
Date:   Thu, 24 Nov 2022 12:54:19 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] gro: simplify flush logic
Message-ID: <20221124115316.GA73682@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tcp_gro_receive, the variable mss is sometimes assigned 1 to make the check
"flush = len < mss" fail, and indirectly set flush to 0.

This somewhat obfuscates the meaning of the code. Also, setting mss to 1 doesn't
influence the value of flush in the case when skb_is_gso(skb) is true.

This patch changes the code to set flush to 0 directly. The out_check_final can
then be moved, which avoids unnecessary conditions.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 net/ipv4/tcp_offload.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 45dda7889387..f17271e5c7c5 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -187,7 +187,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 	unsigned int len;
 	unsigned int thlen;
 	__be32 flags;
-	unsigned int mss = 1;
+	unsigned int mss;
 	unsigned int hlen;
 	unsigned int off;
 	int flush = 1;
@@ -229,6 +229,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 		goto found;
 	}
 	p = NULL;
+	flush = 0;
 	goto out_check_final;
 
 found:
@@ -270,19 +271,19 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 #endif
 
 	if (flush || skb_gro_receive(p, skb)) {
-		mss = 1;
+		flush = 0;
 		goto out_check_final;
 	}
 
 	tcp_flag_word(th2) |= flags & (TCP_FLAG_FIN | TCP_FLAG_PSH);
 
-out_check_final:
 	/* Force a flush if last segment is smaller than mss. */
 	if (unlikely(skb_is_gso(skb)))
 		flush = len != NAPI_GRO_CB(skb)->count * skb_shinfo(skb)->gso_size;
 	else
 		flush = len < mss;
 
+out_check_final:
 	flush |= (__force int)(flags & (TCP_FLAG_URG | TCP_FLAG_PSH |
 					TCP_FLAG_RST | TCP_FLAG_SYN |
 					TCP_FLAG_FIN));
-- 
2.36.1

