Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE055F15C9
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 00:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbiI3WJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 18:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbiI3WJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 18:09:11 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E11C7F0AD
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 15:09:10 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id b2so186028plc.7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 15:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=27UB+I6sGG/UOtb2I69uGfMIGN3se8cqI1qEIHdNyeg=;
        b=IzKIY1Pmsprsg1GWQYtkiy+iJD2mNKPVQcqjhUsoVhQz83zS1/SBwzMsO0uTHC1DbK
         TberjHJ6fIYjv89n/IChiffMX7qMD9uEFpHxVAtVoImf7V8dzwx/taEfBlsusPPaWyTp
         AILSWzkaHQ+LrNozxHEAbkZLDUmbLJgqMRT9nb1ThKNQiSG/yqCxcvgZ1uqo/WLgK9xU
         q44i5xg7+G4GU+hWvS/iKQ7185Z1iHAC4Vhz3S1aAf5OqQ1lPrDkCpExlwfqkXlozgmr
         AmZqzl9ICJ2Vv6qchZoEHAglw4UMAvE04WIA1LNrRtuVK4+Z4b28pnhdM+EO+UW8Z2fO
         a88g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=27UB+I6sGG/UOtb2I69uGfMIGN3se8cqI1qEIHdNyeg=;
        b=BHY/T6sBep//Xhzc78C9bKxI7bXx1CsW+qGukMsKvv/e1TCmTPePMPQS/+xU1/2Az2
         X6vdqsMu/sovO9qxOAUL3NSA9SpEDNxA4g6k8B3V1lcn83azvFwdLruvXeSeyN/jIK/z
         YlCYUoFohHOKuNn8UpC2p+E+Rcqun7CuXdWadkOV8GJNNX3+90WcccnIOdIs2BjwR275
         BAaHPXC9NyXQhSc82NydsUM0qgr+f63ZceJeE8/9Cp/M4J1qx6OmtE+gowuRM/d97sWQ
         korLJ/pO4OxE+X0q3o/3ItEzu879tiy6l1T68BT2yG5ryVHl/Q/pfXVC8NRsrfUF0lF4
         ZW4w==
X-Gm-Message-State: ACrzQf1g/1/A5ajOZZdSzFt9LxSesOhhola3hEY1wHkMTEBg4+UzlbjT
        5FJbu3Q1rektw0W57BSErJc=
X-Google-Smtp-Source: AMsMyM5ISbCVUNet8cxI/GFQJMjmJVOvGTJ+wQ/KQwvctEj7Rap500pHlPMaPbt+W1/Tm7LKR/pzGQ==
X-Received: by 2002:a17:902:ab01:b0:178:fee:c607 with SMTP id ik1-20020a170902ab0100b001780feec607mr10524891plb.20.1664575749713;
        Fri, 30 Sep 2022 15:09:09 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:1b:5511:db8e:ab67])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902f54200b00172ad9674e5sm2379653plf.291.2022.09.30.15.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 15:09:09 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Coco Li <lixiaoyan@google.com>
Subject: [PATCH v2 net-next] gro: add support of (hw)gro packets to gro stack
Date:   Fri, 30 Sep 2022 15:09:05 -0700
Message-Id: <20220930220905.2019461-1-eric.dumazet@gmail.com>
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

This also means BIG TCP can still be used, even if HW-GRO/RSC was
able to cook ~64 KB GRO packets.

v2: fix logic in tcp_gro_receive()

    Only support TCP for the moment (Paolo)

Co-Developed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Coco Li <lixiaoyan@google.com>
---
 net/core/gro.c         | 18 ++++++++++++++----
 net/ipv4/tcp_offload.c | 17 +++++++++++++++--
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index b4190eb084672fb4f2be8b437eccb4e8507ff63f..bc9451743307bc380cca96ae6995aa0a3b83d185 100644
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
@@ -496,8 +498,15 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 		BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
 					 sizeof(u32))); /* Avoid slow unaligned acc */
 		*(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;
-		NAPI_GRO_CB(skb)->flush = skb_is_gso(skb) || skb_has_frag_list(skb);
+		NAPI_GRO_CB(skb)->flush = skb_has_frag_list(skb);
 		NAPI_GRO_CB(skb)->is_atomic = 1;
+		NAPI_GRO_CB(skb)->count = 1;
+		if (unlikely(skb_is_gso(skb))) {
+			NAPI_GRO_CB(skb)->count = skb_shinfo(skb)->gso_segs;
+			/* Only support TCP at the moment. */
+			if (!skb_is_gso_tcp(skb))
+				NAPI_GRO_CB(skb)->flush = 1;
+		}
 
 		/* Setup for GRO checksum validation */
 		switch (skb->ip_summed) {
@@ -545,10 +554,10 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
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
 
@@ -660,6 +669,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 
 	skb->encapsulation = 0;
 	skb_shinfo(skb)->gso_type = 0;
+	skb_shinfo(skb)->gso_size = 0;
 	if (unlikely(skb->slow_gro)) {
 		skb_orphan(skb);
 		skb_ext_reset(skb);
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index a844a0d38482d916251f3aca4555c75c9770820c..45dda788938704c3f762256266d9ea29b6ded4a5 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -255,7 +255,15 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 	mss = skb_shinfo(p)->gso_size;
 
-	flush |= (len - 1) >= mss;
+	/* If skb is a GRO packet, make sure its gso_size matches prior packet mss.
+	 * If it is a single frame, do not aggregate it if its length
+	 * is bigger than our mss.
+	 */
+	if (unlikely(skb_is_gso(skb)))
+		flush |= (mss != skb_shinfo(skb)->gso_size);
+	else
+		flush |= (len - 1) >= mss;
+
 	flush |= (ntohl(th2->seq) + skb_gro_len(p)) ^ ntohl(th->seq);
 #ifdef CONFIG_TLS_DEVICE
 	flush |= p->decrypted ^ skb->decrypted;
@@ -269,7 +277,12 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 	tcp_flag_word(th2) |= flags & (TCP_FLAG_FIN | TCP_FLAG_PSH);
 
 out_check_final:
-	flush = len < mss;
+	/* Force a flush if last segment is smaller than mss. */
+	if (unlikely(skb_is_gso(skb)))
+		flush = len != NAPI_GRO_CB(skb)->count * skb_shinfo(skb)->gso_size;
+	else
+		flush = len < mss;
+
 	flush |= (__force int)(flags & (TCP_FLAG_URG | TCP_FLAG_PSH |
 					TCP_FLAG_RST | TCP_FLAG_SYN |
 					TCP_FLAG_FIN));
-- 
2.38.0.rc1.362.ged0d419d3c-goog

