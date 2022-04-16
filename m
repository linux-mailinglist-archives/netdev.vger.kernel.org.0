Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E1D503360
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344227AbiDPANk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 20:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbiDPANh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 20:13:37 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABFB41332
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:07 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s137so9030443pgs.5
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0T6Pv25KNqD6Qm26oE/uG+HtT+P6NupR7dYzjUxtIek=;
        b=D5Fz13nsuTknxo4Rdd8rcIudfvdNHRjWcomMatDSEyxMZiO8L08ziaG20UDW9BTVrl
         ao0vH8p9MfTApJJfgQBjDzqXW49YWNBWQtOzfcUWtfLWZcbrbQq5AKALLRAdzqeACn4d
         VyqFNaoRy1FrlOeW4ubE+m8B8GJOMMlv1y2OcFOPjI0YExJgqZ+KdUh1vTf0b08EdYqH
         yyjm6KhhnLN4+sykVGnoCQc9YEb9axMZB3KuJGfb4Do9fXq7X34iVDy/aWEGl/Mwl4on
         SMjNsUakIR61sy+eqtOp/lPjk+fC3DMzsKAC8uAmKVPcSXq2f//Z9lj20bPBvVpcnAXs
         ZUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0T6Pv25KNqD6Qm26oE/uG+HtT+P6NupR7dYzjUxtIek=;
        b=EB/yBg81DHsPVR6w2J2ICAUINjLqBkluJrzluvQCqsRdEGUJLRKDLnu/Yn6d7G90cd
         oaShfKlJTVLXX/rrRv7S7mQTunP+84cv8jy1x8g7POCZUhNJcO3l+PGMKb9wKvb2Dzlb
         TVBwq7xmx5cpCPTxg03HDnQ0ynEpFv7PBFwgG9GAZ67sjmKAhwTUEZSNsaQU2mcz6j+O
         PkF+WxDHgOORptfWK+4jbe6rbwpcuu7WalZbo2Fc7+jUz4VdXpEc0175nF0GkUKubIds
         R6SO9mEnYGZk7sDQLROntSDvYUAOmgsLABMftjudGgaOO9HUZjkKER6bfGowPnwYtRk0
         JwVA==
X-Gm-Message-State: AOAM532Ik9rM0RKoFJwFGUkwKV7imxH+Jn0uKDQbRXWJrps7GnJQbJED
        +mmY26OaQmOMNHXATQqTT3o=
X-Google-Smtp-Source: ABdhPJzFmRZMEdgKxugPJdvGF8M0o+loHTukMGzUYVlCQP875/NW2aPZe8djtzsl6wSRbGLhcKgSUA==
X-Received: by 2002:a05:6a02:184:b0:373:a24e:5ab with SMTP id bj4-20020a056a02018400b00373a24e05abmr1119576pgb.400.1650067867482;
        Fri, 15 Apr 2022 17:11:07 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:147b:581d:7b9d:b092])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090a31ca00b001cb87502e32sm5729514pjf.23.2022.04.15.17.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:11:07 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 01/10] tcp: consume incoming skb leading to a reset
Date:   Fri, 15 Apr 2022 17:10:39 -0700
Message-Id: <20220416001048.2218911-2-eric.dumazet@gmail.com>
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

Whenever tcp_validate_incoming() handles a valid RST packet,
we should not pretend the packet was dropped.

Create a special section at the end of tcp_validate_incoming()
to handle this case.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 1595b76ea2bea195b8896f4cd533beb14b56dd96..d4bc717791704795a9a159baf4ccd501a9471609 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5700,7 +5700,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 						  &tp->last_oow_ack_time))
 				tcp_send_dupack(sk, skb);
 		} else if (tcp_reset_check(sk, skb)) {
-			tcp_reset(sk, skb);
+			goto reset;
 		}
 		goto discard;
 	}
@@ -5736,17 +5736,16 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		}
 
 		if (rst_seq_match)
-			tcp_reset(sk, skb);
-		else {
-			/* Disable TFO if RST is out-of-order
-			 * and no data has been received
-			 * for current active TFO socket
-			 */
-			if (tp->syn_fastopen && !tp->data_segs_in &&
-			    sk->sk_state == TCP_ESTABLISHED)
-				tcp_fastopen_active_disable(sk);
-			tcp_send_challenge_ack(sk);
-		}
+			goto reset;
+
+		/* Disable TFO if RST is out-of-order
+		 * and no data has been received
+		 * for current active TFO socket
+		 */
+		if (tp->syn_fastopen && !tp->data_segs_in &&
+		    sk->sk_state == TCP_ESTABLISHED)
+			tcp_fastopen_active_disable(sk);
+		tcp_send_challenge_ack(sk);
 		goto discard;
 	}
 
@@ -5771,6 +5770,11 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 discard:
 	tcp_drop(sk, skb);
 	return false;
+
+reset:
+	tcp_reset(sk, skb);
+	__kfree_skb(skb);
+	return false;
 }
 
 /*
-- 
2.36.0.rc0.470.gd361397f0d-goog

