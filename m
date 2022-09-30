Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B66D5F0256
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 03:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiI3BpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 21:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiI3BpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 21:45:21 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AFB7FE5F
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 18:45:20 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id i6so2992330pfb.2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 18:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=ab96djSY818iftx5EmYfKZ6PEENFx7gyUwnvW4X/OAk=;
        b=SdCi/wdaVzr+RnfESbL34Ophc7X4XUBEmzzV48E6XzL03mrsszvoVgWHRUWH28H2Bg
         8S0EzWMs1dLPo2W4Ec7fHJxbC2kI15g70S5shUhcI1uIhQRfycTmmASTTs6vuK2Nqcjr
         YR29M38YHeK8kada8KvL3kowj5yf8r+BDthAhy7yWqfDzRcrCBruo7gh9DSoDJCuOJLu
         RLByann8+KOGtSBI0RAS1G+UCBG0yjY4/FgzQ00v9geEUY73fIoYbJs9XD+pLXAy9zEX
         exG325SsGRjJDPEslal7pDnzYFrrcPrNDQeIinJw88YY9DsqqvO0DAUCUf6svXrGHW2g
         892A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=ab96djSY818iftx5EmYfKZ6PEENFx7gyUwnvW4X/OAk=;
        b=kL/4QO2ro/GDhu5q3pfRnu5PpF1ABhay/v5afn/4nqIWaSqocIri3k+ZcgQfAYqgyc
         fzh+Ten1f1EGQOfle5XWA3Wvdt2ddbJGWxbdCeXjDEAa6w0Q1nJRgQJDV+GKgZUcCd5t
         09h+r2ikex03P6V2HNNrjIa0dbWbROpJZSPII2a5oTmaBX5TGK05/6gIr9Flw4vVI1fX
         GbsF1d7mjyD2UL58EhyWpsza342bbI1FjvfwLCjURjbP3tAQA/EK44w1S2S1B69SooSE
         JylUOZP76d0P/D75wnRP26KWmZPLy/xfhscij5wP7ub4bLMSgDpycahDByh3uWELIUvQ
         3swQ==
X-Gm-Message-State: ACrzQf1+bljNfErhhYpKWp+pgRn4oVlZtkQnxIM31zTaPZMBtto4ss//
        U/yfNQDyVdji1lThTR4dPB4=
X-Google-Smtp-Source: AMsMyM6OdkI15vr1tm52Mpm6818QqA/7ViJRAVNdWxhls6SWF1vBhZjrFthC8XB63FtH566RV5naBg==
X-Received: by 2002:a63:1f49:0:b0:43b:a2df:857 with SMTP id q9-20020a631f49000000b0043ba2df0857mr5572575pgm.137.1664502319845;
        Thu, 29 Sep 2022 18:45:19 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f8c8:e01a:bc61:a007])
        by smtp.gmail.com with ESMTPSA id w3-20020a170902ca0300b00176e8f85147sm562920pld.83.2022.09.29.18.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 18:45:19 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Coco Li <lixiaoyan@google.com>
Subject: [PATCH net-next] gro: add support of (hw)gro packets to gro stack
Date:   Thu, 29 Sep 2022 18:44:58 -0700
Message-Id: <20220930014458.1219217-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
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

From: Coco Li <lixiaoyan@google.com>

Current GRO stack only supports incoming packets containing
one frame/MSS.

This patch changes GRO to accept packets that are already GRO.

HW-GRO (aka RSC for some vendors) is very often limited in presence
of interleaved packets. Linux SW GRO stack can complete the job
and provide larger GRO packets, thus reducing rate of ACK packets
and cpu overhead.

This also means BIG TCP can be used, even if HW-GRO/RSC was
able to cook ~64 KB GRO packets.

Co-Developed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Coco Li <lixiaoyan@google.com>
---
 net/core/gro.c         | 13 +++++++++----
 net/ipv4/tcp_offload.c |  7 ++++++-
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index b4190eb084672fb4f2be8b437eccb4e8507ff63f..d8e159c4bdf553508cd123bee4f5251908ede9fe 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -160,6 +160,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	unsigned int gro_max_size;
 	unsigned int new_truesize;
 	struct sk_buff *lp;
+	int segs;
 
 	/* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
 	gro_max_size = READ_ONCE(p->dev->gro_max_size);
@@ -175,6 +176,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 			return -E2BIG;
 	}
 
+	segs = NAPI_GRO_CB(skb)->count;
 	lp = NAPI_GRO_CB(p)->last;
 	pinfo = skb_shinfo(lp);
 
@@ -265,7 +267,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	lp = p;
 
 done:
-	NAPI_GRO_CB(p)->count++;
+	NAPI_GRO_CB(p)->count += segs;
 	p->data_len += len;
 	p->truesize += delta_truesize;
 	p->len += len;
@@ -496,8 +498,10 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 		BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
 					 sizeof(u32))); /* Avoid slow unaligned acc */
 		*(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;
-		NAPI_GRO_CB(skb)->flush = skb_is_gso(skb) || skb_has_frag_list(skb);
+		NAPI_GRO_CB(skb)->flush = skb_has_frag_list(skb);
 		NAPI_GRO_CB(skb)->is_atomic = 1;
+		NAPI_GRO_CB(skb)->count = max_t(u16, 1,
+						skb_shinfo(skb)->gso_segs);
 
 		/* Setup for GRO checksum validation */
 		switch (skb->ip_summed) {
@@ -545,10 +549,10 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 	else
 		gro_list->count++;
 
-	NAPI_GRO_CB(skb)->count = 1;
 	NAPI_GRO_CB(skb)->age = jiffies;
 	NAPI_GRO_CB(skb)->last = skb;
-	skb_shinfo(skb)->gso_size = skb_gro_len(skb);
+	if (!skb_is_gso(skb))
+		skb_shinfo(skb)->gso_size = skb_gro_len(skb);
 	list_add(&skb->list, &gro_list->list);
 	ret = GRO_HELD;
 
@@ -660,6 +664,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 
 	skb->encapsulation = 0;
 	skb_shinfo(skb)->gso_type = 0;
+	skb_shinfo(skb)->gso_size = 0;
 	if (unlikely(skb->slow_gro)) {
 		skb_orphan(skb);
 		skb_ext_reset(skb);
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index a844a0d38482d916251f3aca4555c75c9770820c..0223bbfe9568064b47bc6227d342a4d25c9edfa7 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -255,7 +255,12 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 	mss = skb_shinfo(p)->gso_size;
 
-	flush |= (len - 1) >= mss;
+	if (skb_is_gso(skb)) {
+		flush |= (mss != skb_shinfo(skb)->gso_size);
+		flush |= ((skb_gro_len(p) % mss) != 0);
+	} else {
+		flush |= (len - 1) >= mss;
+	}
 	flush |= (ntohl(th2->seq) + skb_gro_len(p)) ^ ntohl(th->seq);
 #ifdef CONFIG_TLS_DEVICE
 	flush |= p->decrypted ^ skb->decrypted;
-- 
2.38.0.rc1.362.ged0d419d3c-goog

