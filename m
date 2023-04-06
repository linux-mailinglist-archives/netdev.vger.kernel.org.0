Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2336D8C53
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 03:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbjDFBBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 21:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbjDFBBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 21:01:14 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E17B7DBF;
        Wed,  5 Apr 2023 18:00:43 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id f22so31941841plr.0;
        Wed, 05 Apr 2023 18:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680742842; x=1683334842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=npUFrgc9AMRZVGcro/ogjr8k13SD8DOZ44oHkdjV4t4=;
        b=nwKVcuNlPRCXwo8dLBTy6ZIeKS1FMcrFI+lj2PxB+wFfaf3Fqc6D9YnPgb6HIlEyCO
         hg/Ah8wqsxFdH/ypgmpsd2W1pavJuGuJib02+mm1McCtzNuQJ9mx69LVtry+Z2MQfhoQ
         MSyMGXdI5ZC9XG+A6uEKOUJucNrZkkKScUgwkl2Yx1oxuD68uJ7bpE9mlPshPbdk/+VO
         5JN8r2HF0Ej54k3N2zrA+nRV54ztPMitCjo1zkrYJMqoLnsxLFdn+LRd1nqfoqTcPC5Q
         MOmAJvUu+xENdx43D7nPZ6KqCnKh1rwKUHx1UciocK9KQJzElsyhq/9hv+s8PleGvuwg
         9qPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680742842; x=1683334842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=npUFrgc9AMRZVGcro/ogjr8k13SD8DOZ44oHkdjV4t4=;
        b=WngS9/UFoK7BYM3wPHrUbFZEF3v3AM7DNucZ0VU1XF6UJARNcMEQl4IVgiHgzIaTZs
         d9n244U0ik/2kzMuDJS/jzEfVXLp+HAMsdBGbILwcipz1OiMU6t+pfOzysSnv3k4xYr2
         C9termpDG1VlKJFLCkqlhVBXc3vQyYf6NKCP8k5Pbn4bSWg02cjRtp5DXdEHar01K/Yf
         336YEV5H1ocze2a0fTrs6TXxGPohacTJh0cqKLPI4sXttvrlcmKmehe0SaquJFanhzYK
         z8qHf0y0maLRq0H4ba94tWqUNbCOQ+BmTCQDfTo/zAHFL+oVGxPEpdPImXx0Ls+kphJ0
         LRLw==
X-Gm-Message-State: AAQBX9ccv3JN3TaU2Vdm0xKYWEBcBMj1b/Ae17u1giIPSBz4rPdlIwdF
        WZ/W8TZQlYPCeLMN4cLAn0g=
X-Google-Smtp-Source: AKy350ZWsNS8HiykhNC84TR/zCLepZsyIFkUAwGg+pCgj1us5Qyv/H3HjlgDM5XF/6FtpiPXNT12qg==
X-Received: by 2002:a05:6a20:b88:b0:d6:26a3:98d with SMTP id i8-20020a056a200b8800b000d626a3098dmr961630pzh.46.1680742842458;
        Wed, 05 Apr 2023 18:00:42 -0700 (PDT)
Received: from john.lan ([98.97.117.85])
        by smtp.gmail.com with ESMTPSA id c14-20020aa78c0e000000b0062c0c3da6b8sm35377pfd.13.2023.04.05.18.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 18:00:42 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v5 04/12] bpf: sockmap, handle fin correctly
Date:   Wed,  5 Apr 2023 18:00:23 -0700
Message-Id: <20230406010031.3354-5-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230406010031.3354-1-john.fastabend@gmail.com>
References: <20230406010031.3354-1-john.fastabend@gmail.com>
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

