Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAE96DB164
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 19:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjDGRRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 13:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjDGRRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 13:17:05 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE63AD13;
        Fri,  7 Apr 2023 10:17:04 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j14-20020a17090a7e8e00b002448c0a8813so4058839pjl.0;
        Fri, 07 Apr 2023 10:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680887824; x=1683479824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=npUFrgc9AMRZVGcro/ogjr8k13SD8DOZ44oHkdjV4t4=;
        b=XMjaFxT4qPJZ/qPHHviVTKJbV7gm8wzXRihKy4mXI07ldiKjeoyNpjqkhIip8Zn2pI
         V/RhMz4vgx17AnS9Yi1BdKkSu8gX5bBaIZj8JRT7T3vJhmSyJjz5sTr08eBaDx+6VFAV
         Fk5cMpae1cowigmoO0ouJQpOXNo5MlLmkg0VsUltB/VjjrLz/0xMVZp4Fzzrztz+g2fF
         LjgMhEB7rOYkV/SsXuOpyNJd4CWWJi7W/fDpNWUa4NImEjPDQvQrQYa2uOYYO6MnMh26
         34Ob5cpOYjcF64NzWRRNdfw6DRSB4BUqzvpOZchy0lJLEtH8U2VQ28FuDujmBTSnjwgS
         2u/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680887824; x=1683479824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=npUFrgc9AMRZVGcro/ogjr8k13SD8DOZ44oHkdjV4t4=;
        b=q9lVefT4MO+9VP8hplN5wfE2PSNtxO45FgJ12i6PRrmM2XnHv7bQRexSO5vQudd/V+
         /0N0j8hiz1EgesVp0RWHXbbERsT7K0UDvJQchfjwhuwLHbNGaLaow98GbgFmHjgfoyFY
         WcajamsPaHD8TsYM5k/V4dEdYQMiUBcMxxqfzfOBdd0IQcY7/JoksoAkzeDFNdCKpiSN
         mN2JNBftivmC9kZUvYLZ5v7Pl4zMI+LraEsGqZDgbPHDyi4wMgBlGYvtbPDBUgt9vEqK
         qZtBV8nhJeGYTjoOjDXEHQSkof0VvL8eIhZTeszHsyhdDZamRpl9lDGBoF7phVeiMJfs
         JJ2g==
X-Gm-Message-State: AAQBX9dhb2OvPvQEEY0ME0zFJHXp0hwJYfvAXzQyJL5gUyg0Hkio08mr
        3XrbHV9ZRV4vgvzFjpjetfw=
X-Google-Smtp-Source: AKy350Z4ogj2gKuE7PmxSmHZ1tsiSQTaiGrFwRsWzacWeUNk/G2wKxD07oY5isLrlQ7WS1HnJPB9mg==
X-Received: by 2002:a17:902:e850:b0:1a5:7ce:2015 with SMTP id t16-20020a170902e85000b001a507ce2015mr4202537plg.16.1680887823869;
        Fri, 07 Apr 2023 10:17:03 -0700 (PDT)
Received: from john.lan ([98.97.116.126])
        by smtp.gmail.com with ESMTPSA id p1-20020a1709028a8100b0019b0937003esm3185425plo.150.2023.04.07.10.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 10:17:03 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v6 04/12] bpf: sockmap, handle fin correctly
Date:   Fri,  7 Apr 2023 10:16:46 -0700
Message-Id: <20230407171654.107311-5-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230407171654.107311-1-john.fastabend@gmail.com>
References: <20230407171654.107311-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sockmap code is returning EAGAIN after a FIN packet is received and no
more data is on the receive queue. Correct behavior is to return 0 to the
user and the user can then close the socket. The EAGAIN causes many apps
to retry which masks the problem. Eventually the socket is evicted from
the sockmap because its released from sockmap sock free handling. The
issue creates a delay and can cause some errors on application side.

To fix this check on sk_msg_recvmsg side if length is zero and FIN flag
is set then set return to zero. A selftest will be added to check this
condition.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Tested-by: William Findlay <will@isovalent.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index ebf917511937..804bd0c247d0 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -174,6 +174,24 @@ static int tcp_msg_wait_data(struct sock *sk, struct sk_psock *psock,
 	return ret;
 }
 
+static bool is_next_msg_fin(struct sk_psock *psock)
+{
+	struct scatterlist *sge;
+	struct sk_msg *msg_rx;
+	int i;
+
+	msg_rx = sk_psock_peek_msg(psock);
+	i = msg_rx->sg.start;
+	sge = sk_msg_elem(msg_rx, i);
+	if (!sge->length) {
+		struct sk_buff *skb = msg_rx->skb;
+
+		if (skb && TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
+			return true;
+	}
+	return false;
+}
+
 static int tcp_bpf_recvmsg_parser(struct sock *sk,
 				  struct msghdr *msg,
 				  size_t len,
@@ -196,6 +214,19 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 	lock_sock(sk);
 msg_bytes_ready:
 	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
+	/* The typical case for EFAULT is the socket was gracefully
+	 * shutdown with a FIN pkt. So check here the other case is
+	 * some error on copy_page_to_iter which would be unexpected.
+	 * On fin return correct return code to zero.
+	 */
+	if (copied == -EFAULT) {
+		bool is_fin = is_next_msg_fin(psock);
+
+		if (is_fin) {
+			copied = 0;
+			goto out;
+		}
+	}
 	if (!copied) {
 		long timeo;
 		int data;
-- 
2.33.0

