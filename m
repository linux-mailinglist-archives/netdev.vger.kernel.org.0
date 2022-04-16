Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA5A5032F9
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbiDPANs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 20:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349273AbiDPANp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 20:13:45 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167D842EF0
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:13 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d15so8174550pll.10
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DpO9Ix2mFS2OG61f0hih6hFxdr7S54fG/Ffisg0A5AI=;
        b=h58RfNiohXS54WjweSao5jCxuYQychtFyEW1I2G/vYf0GnFTcYpd9/EpSRJczm8CoI
         yRLMkscNK4syHtt5uzW7rrxKz+CTTAgK5Q81leyjV5NCHywj952krnmt9W+DoyURGN81
         tjNtyl5IDpuspEpbU6y14GqkrZb5tCh5+wjswhcTUqYpYjQ/J942wc0NL9+kUGB64oO6
         JJ4pDKTB8OCdx7+4UVgwtVRNeUOTkx1o0K5OLY2RMV0M8tx2A5APL1MAR9WT7mROhXlq
         1UqyufAwtlxS4LhFtzjakAyAMAbvYn4AB5wglqBahgXhronQP1FzOUgit4ZbgDMPL6WC
         uSUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DpO9Ix2mFS2OG61f0hih6hFxdr7S54fG/Ffisg0A5AI=;
        b=IZnJOPs2s7jm8pGmHSr5p6so7Q588K7KcnEFhT8T61VKU7IBGnl1zKlSueRbelQ6PH
         HsGkjic9DuS8R3cVMSDkAmu5kHoQI8BM5Cu8yW76jCoMzVmkp8S2PAjETLSy+wikzckN
         UMDtT6W33cEmG85nQbeuvg5iLl/kb0XHbNFniQtfRBDY1zpkNuJVYVElGWBZZ4AyJ9WW
         xCI7zCE5Cz/R283NuknlT9M5V+9OobAPEtM8p2GYhcbtKI8xXCpD7Ax5KQR/WZqCvbAw
         I9W0NSCiMpdQ5ErbhDBPoZZtjmdNYu+3N6lnlwqyUVDiIs/MWsGVDZAfhkIF5xki3tDL
         YkYg==
X-Gm-Message-State: AOAM530WSUHWhDSQseQU4CggKABlGA3aVaw/HIbuB3XjrPVQs7u7JsZ3
        ZkHeibx1cVhatO+t2U9fI2kyl9Y2bK8=
X-Google-Smtp-Source: ABdhPJxC8Xydr4NcDZ1yqiRpf3h5lGKKfH+n0Pi3Y1suGJg0bbfpt9tv1IvZWgpIVbCuwb7fA4hZMQ==
X-Received: by 2002:a17:903:d3:b0:158:bffa:b8d1 with SMTP id x19-20020a17090300d300b00158bffab8d1mr1460728plc.26.1650067872527;
        Fri, 15 Apr 2022 17:11:12 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:147b:581d:7b9d:b092])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090a31ca00b001cb87502e32sm5729514pjf.23.2022.04.15.17.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:11:12 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 03/10] tcp: add drop reason support to tcp_validate_incoming()
Date:   Fri, 15 Apr 2022 17:10:41 -0700
Message-Id: <20220416001048.2218911-4-eric.dumazet@gmail.com>
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

Creates four new drop reasons for the following cases:

1) packet being rejected by RFC 7323 PAWS check
2) packet being rejected by SEQUENCE check
3) Invalid RST packet
4) Invalid SYN packet

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h     | 6 ++++++
 include/trace/events/skb.h | 5 +++++
 net/ipv4/tcp_input.c       | 7 ++++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0ef11df1bc67f26a454a809396bd93299ce787ad..a903da1fa0ed897ba65a3edf6d74d7e5dc575b2e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -381,6 +381,12 @@ enum skb_drop_reason {
 					 * the ofo queue, corresponding to
 					 * LINUX_MIB_TCPOFOMERGE
 					 */
+	SKB_DROP_REASON_TCP_RFC7323_PAWS, /* PAWS check, corresponding to
+					   * LINUX_MIB_PAWSESTABREJECTED
+					   */
+	SKB_DROP_REASON_TCP_INVALID_SEQUENCE, /* Not acceptable SEQ field */
+	SKB_DROP_REASON_TCP_RESET,	/* Invalid RST packet */
+	SKB_DROP_REASON_TCP_INVALID_SYN, /* Incoming packet has unexpected SYN flag */
 	SKB_DROP_REASON_IP_OUTNOROUTES,	/* route lookup failed */
 	SKB_DROP_REASON_BPF_CGROUP_EGRESS,	/* dropped by
 						 * BPF_PROG_TYPE_CGROUP_SKB
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 2da72a9a576462bee9f3415141dfffd2eec8c258..820dacd14bad9ecb2b8ff6206cb33b392c0c442c 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -37,6 +37,11 @@
 	EM(SKB_DROP_REASON_TCP_OLD_DATA, TCP_OLD_DATA)		\
 	EM(SKB_DROP_REASON_TCP_OVERWINDOW, TCP_OVERWINDOW)	\
 	EM(SKB_DROP_REASON_TCP_OFOMERGE, TCP_OFOMERGE)		\
+	EM(SKB_DROP_REASON_TCP_RFC7323_PAWS, TCP_RFC7323_PAWS)	\
+	EM(SKB_DROP_REASON_TCP_INVALID_SEQUENCE,		\
+	   TCP_INVALID_SEQUENCE)				\
+	EM(SKB_DROP_REASON_TCP_RESET, TCP_RESET)		\
+	EM(SKB_DROP_REASON_TCP_INVALID_SYN, TCP_INVALID_SYN)	\
 	EM(SKB_DROP_REASON_IP_OUTNOROUTES, IP_OUTNOROUTES)	\
 	EM(SKB_DROP_REASON_BPF_CGROUP_EGRESS,			\
 	   BPF_CGROUP_EGRESS)					\
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b2d5fbef6ce3baa9426b3c9750002317a8915596..9a1cb3f48c3fb26beac4283001d38828ca15a4d9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5667,6 +5667,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 				  const struct tcphdr *th, int syn_inerr)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
+	SKB_DR(reason);
 
 	/* RFC1323: H1. Apply PAWS check first. */
 	if (tcp_fast_parse_options(sock_net(sk), skb, th, tp) &&
@@ -5678,6 +5679,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 						  LINUX_MIB_TCPACKSKIPPEDPAWS,
 						  &tp->last_oow_ack_time))
 				tcp_send_dupack(sk, skb);
+			SKB_DR_SET(reason, TCP_RFC7323_PAWS);
 			goto discard;
 		}
 		/* Reset is accepted even if it did not pass PAWS. */
@@ -5701,6 +5703,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		} else if (tcp_reset_check(sk, skb)) {
 			goto reset;
 		}
+		SKB_DR_SET(reason, TCP_INVALID_SEQUENCE);
 		goto discard;
 	}
 
@@ -5743,6 +5746,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		    sk->sk_state == TCP_ESTABLISHED)
 			tcp_fastopen_active_disable(sk);
 		tcp_send_challenge_ack(sk);
+		SKB_DR_SET(reason, TCP_RESET);
 		goto discard;
 	}
 
@@ -5757,6 +5761,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 			TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
 		tcp_send_challenge_ack(sk);
+		SKB_DR_SET(reason, TCP_INVALID_SYN);
 		goto discard;
 	}
 
@@ -5765,7 +5770,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 	return true;
 
 discard:
-	tcp_drop(sk, skb);
+	tcp_drop_reason(sk, skb, reason);
 	return false;
 
 reset:
-- 
2.36.0.rc0.470.gd361397f0d-goog

