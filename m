Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56349503380
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244765AbiDPANu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 20:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237029AbiDPANo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 20:13:44 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7AC4339E
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:10 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id bg9so9014862pgb.9
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1sHaqTtYvmcIs/oUCIOZjafImQ79kQw8G0/TmQWihB8=;
        b=Tg6n9tL5dQBdE7HdNe54kMFnBtq72qtACymM1Y0v7wchy0brUSJGum/QypTLfudrFr
         5Fvttyl6T5w0JHLboUPDeEMauCFGkDRhxlZ8S7N8RknlheyJIZfO8GCQJ40/JBa1P3WS
         xVVrkGl+NNvVikY7Fq5j3pPG9ChR3+7Zljwc6G3CTr9nO5WjrbyDm1sOS6GBwIrwVsSd
         roPacSyLcQLwEoDkgeQVXeIfV8RzoyZmaPgPtz3mZK31Rb9T1xjBvIWK9aJFs9IkQirC
         i1+09410b3Nk7s/nYYkJXCI1uV6I9EkTxJxjlY9qX2LOfRBlygJHDBP9dxD4CH8fC+rg
         HJ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1sHaqTtYvmcIs/oUCIOZjafImQ79kQw8G0/TmQWihB8=;
        b=gat9RusPgI6hgk+MNG3GXZySIYQIh8d6a5/a+Gll7+f9OCl2Rvx2TksMRT6zNH0gDa
         7jPqDO/i5whm/vuexYicI0rSmfWAUTEXF3Dr5gK2IZ7Yp6vFROkmzsXNpyweSe9G4IER
         TSFMS4druue1igfTAJmciSArhTvo3aMOKh/lMERQ47+fnaH17eURwAHnDPQE8yof4rfx
         F6qhtgNg6j3UIkzQCt0K1eTYAepBdDcTYGmCPLAiauUeZ1Uy5H8CexuzXP46HrTaUuQ3
         9X1zvHsTH8GwjFoyiVOPlVAkcQ/7whCXyOhoUv1KbIsnPlRfur/583daOspMNM8qW+hZ
         nkGQ==
X-Gm-Message-State: AOAM533ZJ5VdgZIetDtyh7mrWipWasKWshVn+RvCZP/L2sZ24lTfUqR4
        lVuIhWnGi6w4JDX34IVKhUw=
X-Google-Smtp-Source: ABdhPJwdta1lpwmIKyjGKDe/lQ63xxaIvpV13aZrpFv75jmKL7eom6qvqzX3SQOFOwqpQflVzNLYpg==
X-Received: by 2002:a62:e210:0:b0:508:3708:9c20 with SMTP id a16-20020a62e210000000b0050837089c20mr1266614pfi.29.1650067869947;
        Fri, 15 Apr 2022 17:11:09 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:147b:581d:7b9d:b092])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090a31ca00b001cb87502e32sm5729514pjf.23.2022.04.15.17.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:11:09 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 02/10] tcp: get rid of rst_seq_match
Date:   Fri, 15 Apr 2022 17:10:40 -0700
Message-Id: <20220416001048.2218911-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220416001048.2218911-1-eric.dumazet@gmail.com>
References: <20220416001048.2218911-1-eric.dumazet@gmail.com>
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

Small cleanup in tcp_validate_incoming(), no need for rst_seq_match
setting and testing.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d4bc717791704795a9a159baf4ccd501a9471609..b2d5fbef6ce3baa9426b3c9750002317a8915596 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5667,7 +5667,6 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 				  const struct tcphdr *th, int syn_inerr)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
-	bool rst_seq_match = false;
 
 	/* RFC1323: H1. Apply PAWS check first. */
 	if (tcp_fast_parse_options(sock_net(sk), skb, th, tp) &&
@@ -5717,9 +5716,10 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		 *     Send a challenge ACK
 		 */
 		if (TCP_SKB_CB(skb)->seq == tp->rcv_nxt ||
-		    tcp_reset_check(sk, skb)) {
-			rst_seq_match = true;
-		} else if (tcp_is_sack(tp) && tp->rx_opt.num_sacks > 0) {
+		    tcp_reset_check(sk, skb))
+			goto reset;
+
+		if (tcp_is_sack(tp) && tp->rx_opt.num_sacks > 0) {
 			struct tcp_sack_block *sp = &tp->selective_acks[0];
 			int max_sack = sp[0].end_seq;
 			int this_sack;
@@ -5732,12 +5732,9 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 			}
 
 			if (TCP_SKB_CB(skb)->seq == max_sack)
-				rst_seq_match = true;
+				goto reset;
 		}
 
-		if (rst_seq_match)
-			goto reset;
-
 		/* Disable TFO if RST is out-of-order
 		 * and no data has been received
 		 * for current active TFO socket
-- 
2.36.0.rc0.470.gd361397f0d-goog

