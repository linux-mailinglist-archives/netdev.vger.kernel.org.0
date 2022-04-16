Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A4E503376
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbiDPANx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 20:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240560AbiDPANr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 20:13:47 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A5841F8B
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:17 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t13so9030627pgn.8
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jWTuTUE3yyARlgiYfWaqvvo/xhUSDcrqasLcQQqKlEI=;
        b=R3V7h4zdbh3AYQn/tVWTYfv5S+1V6VBCdn/zWviXBdQqC2NGjIwvvHEsV3tOsVKTu7
         +T+alenCeO3rpTqJpGknaYQoFqYoiK64l0CVPfeRh4GeDYTByC0zq+Yf6KokL33NlAuE
         XXiRzOMvifXgX1Jb6LaK+HAMaOiQwNA+jtfAcbFQaSD25ysrl2cmQwyGxGeTwpv5RD4n
         WeLWUn9ibfec+ENvERG3PVYaXN3d7HKMVyem45LCwbBnPbe8LnqAOztyUdVDM7hilDQa
         CyUw5BYSbZqPO+fh4pnChbcef/mFqDldcrlyMse5hvEP5uBboVAk7hEtlXRTUmbJe6Ee
         X65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jWTuTUE3yyARlgiYfWaqvvo/xhUSDcrqasLcQQqKlEI=;
        b=siIfY8R+4sQvoLifECROtLDRjpN+l+LtzvOtKtoAu7/si8awxI+RzmxkmY834YqfpX
         e8KgJGMEFbvtRN6aiT7pQpnN6wEdWK+7fHzS6jdCWyUE2lNnUiPpoK3eVqJF/uSy+x8n
         wZv/MIsDFWmniDtjg1AqABSRXdwHyVIeVC4pi8Yaqw8qFV1tPUigOdZEeV+MFpq8LQJ1
         ZbuN5gahlwJlSUXsIKhzN0kni247OfgEmbWam3Q1f/K1PAw+PFb1wmqD8CprQ5KKJwNM
         GTKjmSdGvX3lA1plfZHa4ILZm9/Oh/Ew5UddPHyDMBGhXg0nhJUThPzWvVrscCsh2+pk
         PR4Q==
X-Gm-Message-State: AOAM532H7mub1KQp7CrlL/93IsB5XTTenXFkIjOFv9Oiuu2DVlPWIa5/
        XbJ9bnvc5gNJSKsVVlTuaY8=
X-Google-Smtp-Source: ABdhPJyiVJb0ukcy0n2SSjxFFR5CE7QZjgJuzOLL2CnHU64cgmcNOnpOBhq+cRVjYvir1FqUPzncaA==
X-Received: by 2002:aa7:8241:0:b0:509:979d:c760 with SMTP id e1-20020aa78241000000b00509979dc760mr1281596pfn.84.1650067877329;
        Fri, 15 Apr 2022 17:11:17 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:147b:581d:7b9d:b092])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090a31ca00b001cb87502e32sm5729514pjf.23.2022.04.15.17.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:11:17 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 05/10] tcp: add drop reasons to tcp_rcv_state_process()
Date:   Fri, 15 Apr 2022 17:10:43 -0700
Message-Id: <20220416001048.2218911-6-eric.dumazet@gmail.com>
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

Add basic support for drop reasons in tcp_rcv_state_process()

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h     |  3 +++
 include/trace/events/skb.h |  3 +++
 net/ipv4/tcp_input.c       | 24 +++++++++++++++++-------
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a903da1fa0ed897ba65a3edf6d74d7e5dc575b2e..6f1410b5ff1372d9e1f7a75c303f8d7876c83ef0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -387,6 +387,9 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_INVALID_SEQUENCE, /* Not acceptable SEQ field */
 	SKB_DROP_REASON_TCP_RESET,	/* Invalid RST packet */
 	SKB_DROP_REASON_TCP_INVALID_SYN, /* Incoming packet has unexpected SYN flag */
+	SKB_DROP_REASON_TCP_CLOSE,	/* TCP socket in CLOSE state */
+	SKB_DROP_REASON_TCP_FASTOPEN,	/* dropped by FASTOPEN request socket */
+	SKB_DROP_REASON_TCP_OLD_ACK,	/* TCP ACK is old, but in window */
 	SKB_DROP_REASON_IP_OUTNOROUTES,	/* route lookup failed */
 	SKB_DROP_REASON_BPF_CGROUP_EGRESS,	/* dropped by
 						 * BPF_PROG_TYPE_CGROUP_SKB
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 820dacd14bad9ecb2b8ff6206cb33b392c0c442c..fbe21ad038bc6701ed04cb6be417c544de0dae84 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -42,6 +42,9 @@
 	   TCP_INVALID_SEQUENCE)				\
 	EM(SKB_DROP_REASON_TCP_RESET, TCP_RESET)		\
 	EM(SKB_DROP_REASON_TCP_INVALID_SYN, TCP_INVALID_SYN)	\
+	EM(SKB_DROP_REASON_TCP_CLOSE, TCP_CLOSE)		\
+	EM(SKB_DROP_REASON_TCP_FASTOPEN, TCP_FASTOPEN)		\
+	EM(SKB_DROP_REASON_TCP_OLD_ACK, TCP_OLD_ACK)		\
 	EM(SKB_DROP_REASON_IP_OUTNOROUTES, IP_OUTNOROUTES)	\
 	EM(SKB_DROP_REASON_BPF_CGROUP_EGRESS,			\
 	   BPF_CGROUP_EGRESS)					\
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index f95a8368981d319400d0f46b81ced954d941f718..85fae79c894d4b96820747c658bb4d884981c49e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6413,21 +6413,26 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	struct request_sock *req;
 	int queued = 0;
 	bool acceptable;
+	SKB_DR(reason);
 
 	switch (sk->sk_state) {
 	case TCP_CLOSE:
+		SKB_DR_SET(reason, TCP_CLOSE);
 		goto discard;
 
 	case TCP_LISTEN:
 		if (th->ack)
 			return 1;
 
-		if (th->rst)
+		if (th->rst) {
+			SKB_DR_SET(reason, TCP_RESET);
 			goto discard;
-
+		}
 		if (th->syn) {
-			if (th->fin)
+			if (th->fin) {
+				SKB_DR_SET(reason, TCP_FLAGS);
 				goto discard;
+			}
 			/* It is possible that we process SYN packets from backlog,
 			 * so we need to make sure to disable BH and RCU right there.
 			 */
@@ -6442,6 +6447,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			consume_skb(skb);
 			return 0;
 		}
+		SKB_DR_SET(reason, TCP_FLAGS);
 		goto discard;
 
 	case TCP_SYN_SENT:
@@ -6468,13 +6474,16 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		WARN_ON_ONCE(sk->sk_state != TCP_SYN_RECV &&
 		    sk->sk_state != TCP_FIN_WAIT1);
 
-		if (!tcp_check_req(sk, skb, req, true, &req_stolen))
+		if (!tcp_check_req(sk, skb, req, true, &req_stolen)) {
+			SKB_DR_SET(reason, TCP_FASTOPEN);
 			goto discard;
+		}
 	}
 
-	if (!th->ack && !th->rst && !th->syn)
+	if (!th->ack && !th->rst && !th->syn) {
+		SKB_DR_SET(reason, TCP_FLAGS);
 		goto discard;
-
+	}
 	if (!tcp_validate_incoming(sk, skb, th, 0))
 		return 0;
 
@@ -6487,6 +6496,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (sk->sk_state == TCP_SYN_RECV)
 			return 1;	/* send one RST */
 		tcp_send_challenge_ack(sk);
+		SKB_DR_SET(reason, TCP_OLD_ACK);
 		goto discard;
 	}
 	switch (sk->sk_state) {
@@ -6647,7 +6657,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 
 	if (!queued) {
 discard:
-		tcp_drop(sk, skb);
+		tcp_drop_reason(sk, skb, reason);
 	}
 	return 0;
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

