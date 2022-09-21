Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F7B5BF284
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 02:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiIUA7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 20:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiIUA7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 20:59:34 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52670F27;
        Tue, 20 Sep 2022 17:59:31 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id w2so3091963qtv.9;
        Tue, 20 Sep 2022 17:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=2a9zfDnHDp8v+TWqoFXXlEJw2dZ6+6f8B99krfO7sq8=;
        b=TFasKd16JpFp1SAV6lXBv66eyOBM6wkBRUYFyvh05hEurroqxrpJAmcpqVP3CZLMAV
         /vstiufhLPxzWjvEDufT7BGN8tY22O599KiKtph1SGnPUJ1Sp1s4o0oSFRfyVrGqneBe
         j60mH8nlktDoYXOZ1HdJWRNTzhNDLLfb0rrJMor/wCNHY7lroyikSBHLS+nFOElQzh5h
         ljT3Ttf61IChxdHJO5gYhWVAwP5+yTpn6T6NQbWeZ2lOqZTn//SQEiDPCGkbOa1kzEc9
         UBJ82Zz4i2/6A93NdcFEwX9hNAa1AePe9EYlvL7Hl2t4RuUQTho4uSxw48SgI85CosTk
         wzFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=2a9zfDnHDp8v+TWqoFXXlEJw2dZ6+6f8B99krfO7sq8=;
        b=fpu+Gah7IN4JXoDYqgmhZYU26sOQx3449QCEXEJy71eg5dVdoTYdFauMrcWm8U3aMi
         D6paL1w4WOrOf/sT5dXUxSZpthtSbR7UPihIUQn0mwPI8WoWrnOLT+4Dn9ncDT4YIqeG
         ygVg3tOdw5wLA3ExqkvlvAGgHje3zz3/JcR6fGAvxcM3hXZhgS+gLv5kbovIcL8UmRSn
         tR5Go2Nl85UNOWL5cb4N4/6gAyTq7ND14Yckk/lxNjISOpABetsLVm3rePPEQOQRE7yO
         1HlSirxF9A6DOxeOurWPCk/odzRBUYybMidoR0kO40IxLSLPLxhqZFS87LqtwjarPMDL
         bV7w==
X-Gm-Message-State: ACrzQf3di/kOM2/wgKGR8e3OGzA4gC2YLdLCbYxoF18ztLiljpm8UrHT
        SfgjvrzNfNQBo+e+Nf2DdA==
X-Google-Smtp-Source: AMsMyM5pQpBItci7qAMnH3K+LAj466I/ZoOkv3HgGo7usnS6HmpG9yWNLf5O/u+rWhsSCoYA06/pJg==
X-Received: by 2002:ac8:4e8f:0:b0:35c:f42e:5a64 with SMTP id 15-20020ac84e8f000000b0035cf42e5a64mr7677441qtp.680.1663721970305;
        Tue, 20 Sep 2022 17:59:30 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-3-231-65-244.compute-1.amazonaws.com. [3.231.65.244])
        by smtp.gmail.com with ESMTPSA id l15-20020ac8148f000000b0034456277e3asm627748qtj.89.2022.09.20.17.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 17:59:29 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net] udp: Use WARN_ON_ONCE() in udp_read_skb()
Date:   Tue, 20 Sep 2022 17:59:15 -0700
Message-Id: <20220921005915.2697-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
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

From: Peilin Ye <peilin.ye@bytedance.com>

Prevent udp_read_skb() from flooding the syslog.

Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/ipv4/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index cd72158e953a..560d9eadeaa5 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1821,7 +1821,7 @@ int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 			continue;
 		}
 
-		WARN_ON(!skb_set_owner_sk_safe(skb, sk));
+		WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
 		used = recv_actor(sk, skb);
 		if (used <= 0) {
 			if (!copied)
-- 
2.20.1

