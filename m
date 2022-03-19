Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F324DE785
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 12:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242274AbiCSLGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 07:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbiCSLF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 07:05:57 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F07BA1A5;
        Sat, 19 Mar 2022 04:04:36 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q1-20020a17090a4f8100b001c6575ae105so7143255pjh.0;
        Sat, 19 Mar 2022 04:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ziw5CJhDRZqUL3LNhkYQbYf/R/d1yl0g1A3sF/TdmjA=;
        b=WChYIdMiyOy6xX0u63bVHRUfpVCzFAXwqS+9h5yuM/drwScx59WS/SncuRNaeRQISK
         yvvdqpqxlGV0ptyKRugJNkIHjzXMZKRI/aR9ihLh7YQcHpgb9wJvsozf+klSItc+98ct
         JS5eFTqvi6VSrF1tgaCM9uoapsvulF8TtOem4mt4YCDNmHh1upoTtREiinCN4aC4px8P
         d1parz2XdFrr4iwDtyB0FN0bCLMNSK1IDJ74GLMBawKYUzpLeNxr08Jf/g9HWo0SlZol
         KRYq3yIb7Gp/daLisuXM80r7vQPa0/m3fgdjyZ6jSQq5mvD+mUxQU6wQvP4ZFmKgvjBR
         z+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ziw5CJhDRZqUL3LNhkYQbYf/R/d1yl0g1A3sF/TdmjA=;
        b=fBa0cBbGpY53vOHbThsqlwNU+VXeYr6Nd8G2TeG1wMd72revvlE4ZeO0jpZEePj9Tb
         8izd+I93keHpzmil60lN5A4KNmmcu/Our8igrG5ga6CrgW9qMdeuayR8mEyIyjpdYLxM
         GLyZBMzeuc+k9qEXJteFC87iRqUcUhQXnXvVFtplzwZ7M+jWSn5mKHuXvO2LwA+FJ9aq
         UTq2xkVmtZXvYnF7IeiYhvW4ao5OkZJ1w7Tlv72jRLjYzAT+2QPzb5/CJj4J5VW9lu4Y
         cb+o4QQMfAC5STzipizQ69PNJ8Cb+cbBDt0BCb+MjYBxrdAuN6cC1lnM5yxAIC8r1Kih
         +seA==
X-Gm-Message-State: AOAM53357NdQUsOOg86xbMSz4hRzeRoWfpMBzZK6jZKOA5dEeMy4Njmw
        SSgWT0Wul3ytG0uuyP8jgDs=
X-Google-Smtp-Source: ABdhPJxRr6mPntlgJVKrhCsVUHWkAy2VjiL8+hlvEKiBzLkEIvTZzRz4+CRPrBTOeWC5oP5YyXllJQ==
X-Received: by 2002:a17:902:ec87:b0:151:c3f3:ddd5 with SMTP id x7-20020a170902ec8700b00151c3f3ddd5mr3730347plg.154.1647687875848;
        Sat, 19 Mar 2022 04:04:35 -0700 (PDT)
Received: from localhost.localdomain ([85.203.23.81])
        by smtp.gmail.com with ESMTPSA id 2-20020a17090a034200b001bfc572d018sm10432001pjf.48.2022.03.19.04.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 04:04:35 -0700 (PDT)
From:   zhouzhouyi@gmail.com
To:     fw@strlen.de, edumazet@google.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Zhouyi Zhou <zhouzhouyi@gmail.com>, Wei Xu <xuweihf@ustc.edu.cn>
Subject: [PATCH v2] net:ipv4: send an ack when seg.ack > snd.nxt
Date:   Sat, 19 Mar 2022 19:04:22 +0800
Message-Id: <20220319110422.8261-1-zhouzhouyi@gmail.com>
X-Mailer: git-send-email 2.25.1
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

From: Zhouyi Zhou <zhouzhouyi@gmail.com>

In RFC 793, page 72: "If the ACK acks something not yet sent
(SEG.ACK > SND.NXT) then send an ACK, drop the segment,
and return."

Fix Linux's behavior according to RFC 793.

Reported-by: Wei Xu <xuweihf@ustc.edu.cn>
Signed-off-by: Wei Xu <xuweihf@ustc.edu.cn>
Signed-off-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
---
Thank Florian Westphal for pointing out
the potential duplicated ack bug in patch version 1.
--
 net/ipv4/tcp_input.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index bfe4112e000c..4bbf85d7ea8c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3771,11 +3771,13 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		goto old_ack;
 	}
 
-	/* If the ack includes data we haven't sent yet, discard
-	 * this segment (RFC793 Section 3.9).
+	/* If the ack includes data we haven't sent yet, then send
+	 * an ack, drop this segment, and return (RFC793 Section 3.9 page 72).
 	 */
-	if (after(ack, tp->snd_nxt))
-		return -1;
+	if (after(ack, tp->snd_nxt)) {
+		tcp_send_ack(sk);
+		return -2;
+	}
 
 	if (after(ack, prior_snd_una)) {
 		flag |= FLAG_SND_UNA_ADVANCED;
@@ -6385,6 +6387,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	struct request_sock *req;
 	int queued = 0;
 	bool acceptable;
+	int ret;
 
 	switch (sk->sk_state) {
 	case TCP_CLOSE:
@@ -6451,14 +6454,16 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		return 0;
 
 	/* step 5: check the ACK field */
-	acceptable = tcp_ack(sk, skb, FLAG_SLOWPATH |
-				      FLAG_UPDATE_TS_RECENT |
-				      FLAG_NO_CHALLENGE_ACK) > 0;
+	ret = tcp_ack(sk, skb, FLAG_SLOWPATH |
+				FLAG_UPDATE_TS_RECENT |
+				FLAG_NO_CHALLENGE_ACK);
+	acceptable = ret > 0;
 
 	if (!acceptable) {
 		if (sk->sk_state == TCP_SYN_RECV)
 			return 1;	/* send one RST */
-		tcp_send_challenge_ack(sk);
+		if (ret > -2)
+			tcp_send_challenge_ack(sk);
 		goto discard;
 	}
 	switch (sk->sk_state) {
-- 
2.25.1

