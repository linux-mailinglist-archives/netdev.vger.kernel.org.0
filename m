Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C213D263ABD
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgIJCnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730586AbgIJCHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 22:07:31 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF82C06136E
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 17:51:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 129so3870933ybn.15
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 17:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=0DDsdUWkpeGDlcHTYL2blsH30ZZYfjjkwjdpdSOQiWE=;
        b=pEQVX3ItJxKCy4UrNyuy9fLtZ/MG7JnfGF3GluEGit5zgeFNmo5xJB8URMpZ96tXoj
         JFRnNWCfoZ5EG196lVv2nlcTpc6yRNjIJfxukD8ug7vj/jBtAu3HMYMsbSsIVPnVfNpL
         D2fuKJJecpIUnPNgqKvM6N546Dmyi8QYm6NEg2gTF3Sqh8xRz7TcVGK2+bsA4Sc0caam
         EIFMDCvma/yeqfSAQN0XOGmac51MQ2uJCUCaqoJxCovbtBuvLZazL1/9CgH08vzsdhQ7
         D6PgEbp+uHyZWr2jMMebu/T3FOnduB51MWYrNEOhcgSrpKJB+ZXtgwHRCBW6cmSI6LOv
         lmbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0DDsdUWkpeGDlcHTYL2blsH30ZZYfjjkwjdpdSOQiWE=;
        b=emz7Rt50NdBX1skpSguhBLMA4y7dqb79n0RS2cSEe7WFxwA2PO0IipGMnyblB4hzqU
         3SuH7GiS5w3RaxxNrOrpmk/F/7SSnVCQ1qFkWXAtBwx+2sWVqIV7g8ObTtqHtS2lVAxp
         iQf8yY7nOlEIsoPG6HjjtM+6kLMqjROkQdILKKpA/+vFndzlXDFyZex4ociSpmu1ev9/
         /10FdFwS4CuDPBVyzit3JSW2z/kPmzFF4g0v4TJS+cQwD+4Lb45hPUeAYg/kuUFtOBOj
         mkFamndZ5OQavuY8opvP7HNEs2xSQ/73tR+FQO7w7K7xvSGw9QlZDw/z6Ha63/Y5BkOY
         GMFQ==
X-Gm-Message-State: AOAM533w1F26HZRYhDNQAktqoznU9rBXvibf+VtPhDi9agopXuzAkKs0
        7yNMp8pN5Bgxy0t8EYkNUUk7RxxTN3A=
X-Google-Smtp-Source: ABdhPJywf8cWiEGTGUb0JRzwKaKhYD98mJzCMnMwLnzN3e4AtMbFlWAZEX8hsUvsSm0mmgtdLHL3MrJ8D5E=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a25:bcd2:: with SMTP id l18mr8919782ybm.290.1599699076196;
 Wed, 09 Sep 2020 17:51:16 -0700 (PDT)
Date:   Wed,  9 Sep 2020 17:50:46 -0700
In-Reply-To: <20200910005048.4146399-1-weiwan@google.com>
Message-Id: <20200910005048.4146399-2-weiwan@google.com>
Mime-Version: 1.0
References: <20200910005048.4146399-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH net-next 1/3] tcp: record received TOS value in the request socket
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new field is added to the request sock to record the TOS value
received on the listening socket during 3WHS:
When not under syn flood, it is recording the TOS value sent in SYN.
When under syn flood, it is recording the TOS value sent in the ACK.
This is a preparation patch in order to do TOS reflection in the later
commit.

Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/tcp.h   | 1 +
 net/ipv4/syncookies.c | 6 +++---
 net/ipv4/tcp_input.c  | 1 +
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 56ff2952edaf..2f87377e9af7 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -134,6 +134,7 @@ struct tcp_request_sock {
 						  * FastOpen it's the seq#
 						  * after data-in-SYN.
 						  */
+	u8				syn_tos;
 };
 
 static inline struct tcp_request_sock *tcp_rsk(const struct request_sock *req)
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index f0794f0232ba..c375c126f436 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -286,11 +286,10 @@ struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
 					    struct sock *sk,
 					    struct sk_buff *skb)
 {
+	struct tcp_request_sock *treq;
 	struct request_sock *req;
 
 #ifdef CONFIG_MPTCP
-	struct tcp_request_sock *treq;
-
 	if (sk_is_mptcp(sk))
 		ops = &mptcp_subflow_request_sock_ops;
 #endif
@@ -299,8 +298,9 @@ struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
 	if (!req)
 		return NULL;
 
-#if IS_ENABLED(CONFIG_MPTCP)
 	treq = tcp_rsk(req);
+	treq->syn_tos = TCP_SKB_CB(skb)->ip_dsfield;
+#if IS_ENABLED(CONFIG_MPTCP)
 	treq->is_mptcp = sk_is_mptcp(sk);
 	if (treq->is_mptcp) {
 		int err = mptcp_subflow_init_cookie_req(req, sk, skb);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 4337841faeff..3658ad84f0c6 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6834,6 +6834,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 
 	tcp_rsk(req)->snt_isn = isn;
 	tcp_rsk(req)->txhash = net_tx_rndhash();
+	tcp_rsk(req)->syn_tos = TCP_SKB_CB(skb)->ip_dsfield;
 	tcp_openreq_init_rwin(req, sk, dst);
 	sk_rx_queue_set(req_to_sk(req), skb);
 	if (!want_cookie) {
-- 
2.28.0.618.gf4bc123cb7-goog

