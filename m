Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3051597732
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238247AbiHQTzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241607AbiHQTzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:55:15 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8137A50D2;
        Wed, 17 Aug 2022 12:55:14 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id cr9so11198311qtb.13;
        Wed, 17 Aug 2022 12:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=B7sPlt37vrxKCjfrcuQ+CW6DYIRjy+luc779zWnqrCI=;
        b=XZEH4IGouPKMrgJGT9OYGOzupVFM3IXqxxth86VOKGy8iIcXQpeYwUaSoNWbPACpBb
         hg3A6N9QMn4zo0WWWZN/1u6Rxx9Jq30Oq3HncORfFWpdmnnzY1RxVoRIAEg8Ntalt9ck
         3T9JAFTN1vmfOUoXajECTxVb8FYSUksmsYgZP7/61lO4x9903A1w2Mf4S0n8j579Zwb8
         tNzSqWt3Stlqt/W42Ujatf7iCtzfunvGEK0D0KvT3dWZAtkAxPShwozsMg2+dtHwazHp
         GKxx0CWa9bwxthi4jByJCoSeJdmGSLw9C2PoASpm3d35LEMMP6bJhh3SjSIy8rooEQJ9
         vELw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=B7sPlt37vrxKCjfrcuQ+CW6DYIRjy+luc779zWnqrCI=;
        b=sRf5aL0AjQrN2rvUsayv4bfm77Pd4jj4HBYZduR8LZOtsfm1+bMMVJaDnUzsiMxJnj
         h+VPfpkf68eLjQd9gUgGzUPJ9UcIa4XXFr1NGwm6NByIkUirIrEKs1ABCctVEkd1rIp6
         yYbn0Usk9OOwIFs2SCsk133kkm45/sqp6zFgf2NlE1svPmaJuD5sXT63KPH0UjfW+6sG
         BqnFvSi5JspjJeOgt+AZtbjrg/2MWSMU0CpZFio/wSl/DWgZ+j6ANiivZn8nUpMTUmRd
         hvz3FBq0/tHodJixc5lZ4J/BoQiBfjylgw2VsMirMvdgeWKH7bOcGI4vAWePl/K1Qwlb
         g4/A==
X-Gm-Message-State: ACgBeo0jLj7H/QK5KmVhIaBKEXjW9eLGQm0KU6rrFKJawfhW/UFyBn4x
        WWtgjl7F0NphbQPTozAmgvLhhNG4S3s=
X-Google-Smtp-Source: AA6agR4EbOShgSbje1JLsoHR17FSKmH1qwnA9Bhp8UEKaVwh1s0V+B2ViiGHp/mK1nASdmS9YSWPww==
X-Received: by 2002:ac8:5ad1:0:b0:31f:1c49:e1ee with SMTP id d17-20020ac85ad1000000b0031f1c49e1eemr24067636qtd.624.1660766113773;
        Wed, 17 Aug 2022 12:55:13 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:b87a:4308:21ec:d026])
        by smtp.gmail.com with ESMTPSA id az30-20020a05620a171e00b006bb8b5b79efsm2225473qkb.129.2022.08.17.12.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 12:55:13 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch net v3 3/4] tcp: refactor tcp_read_skb() a bit
Date:   Wed, 17 Aug 2022 12:54:44 -0700
Message-Id: <20220817195445.151609-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220817195445.151609-1-xiyou.wangcong@gmail.com>
References: <20220817195445.151609-1-xiyou.wangcong@gmail.com>
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

From: Cong Wang <cong.wang@bytedance.com>

As tcp_read_skb() only reads one skb at a time, the while loop is
unnecessary, we can turn it into an if. This also simplifies the
code logic.

Cc: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/ipv4/tcp.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 181a0d350123..56a554b49caa 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1761,25 +1761,17 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 	if (sk->sk_state == TCP_LISTEN)
 		return -ENOTCONN;
 
-	while ((skb = tcp_recv_skb(sk, seq, &offset)) != NULL) {
-		int used;
-
-		__skb_unlink(skb, &sk->sk_receive_queue);
-		WARN_ON(!skb_set_owner_sk_safe(skb, sk));
-		used = recv_actor(sk, skb);
-		if (used <= 0) {
-			if (!copied)
-				copied = used;
-			break;
-		}
-		seq += used;
-		copied += used;
+	skb = tcp_recv_skb(sk, seq, &offset);
+	if (!skb)
+		return 0;
 
-		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
+	__skb_unlink(skb, &sk->sk_receive_queue);
+	WARN_ON(!skb_set_owner_sk_safe(skb, sk));
+	copied = recv_actor(sk, skb);
+	if (copied > 0) {
+		seq += copied;
+		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
 			++seq;
-			break;
-		}
-		break;
 	}
 	consume_skb(skb);
 	WRITE_ONCE(tp->copied_seq, seq);
-- 
2.34.1

