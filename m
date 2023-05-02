Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B2C6F47B6
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbjEBPwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbjEBPwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:52:18 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0FAE5E;
        Tue,  2 May 2023 08:52:12 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1aad55244b7so28339905ad.2;
        Tue, 02 May 2023 08:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683042731; x=1685634731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=chnbx0aexE84U6XPaCif+oK0SPIJniesfJ0+4Zw1ypA=;
        b=jrJVQ6GUzJ6FR7JPbQIV2Gs8CAEAlZLnWY06ODPxCyTh0mJfRWnowZuTEGNAKobJ03
         U5pNif7ypsv7drPb0W/CBW74rkYdmo3Z+CDPpE8LaP+h9/lCcHlRnYuZc1S3oQUMk6bi
         WsjaibHFaO3Fo0qcYVabYCCwAOfK0JswuVcjYjg2WwxgU2A8FTfDzUVImCNYU3aRDV78
         aOqFN3v15Jl2/gO3DwFkg582EtkWk/Izz3NzG3KpaG6Cj2dZSXTEAJgbHF5o85u7Cg7Q
         wQOYfFA876dIZ3qjLA5I2xhpIMXmZMv/Q+eDlJRBCrFObWWen0dSvngEu+ks2UlrhZXv
         nMRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683042731; x=1685634731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=chnbx0aexE84U6XPaCif+oK0SPIJniesfJ0+4Zw1ypA=;
        b=YXt0OKTkUhfKGSQMCg8ON5tY7LRO0bG8VVoMGrnLUH9sWezIgxX9ADR8SYpXZHf9Y3
         qLlbXO3PjY3I3SWGNYg46bRxk6hs3aCH0j5MhsD/NTCBzqAXqXV0aqlBMYxgsQaK1tbO
         aHCiR/Zw3ulpFjsKC4RHtpb1uDT4VWSaBrQxpDhPNu2HshR8VEqx+OftspovVUXMbZV9
         Ir1Tl/uzHLuypaDSVLQaHj/VC8dUXSsxDUmxAyA0nojf5baD0kfoe8SXUeD++bPKzwle
         Dl9lFR0W7q5nXR7PYSWHOOjBoY3IUME8tvXLUfSD77FyH+2QKeGV3603d2p7kQfJ6pSF
         3RlQ==
X-Gm-Message-State: AC+VfDyeRlOlqZcCanKvaSwwbkSKYt5NunOZ3X+AhnJshsqNOoO94pWw
        ENd8c2Pk1TSxGm1U64kPH0Q=
X-Google-Smtp-Source: ACHHUZ7UO/xEwRCflHJskiiAJAj/9mgv53a0rqVKseGINuZBrtvoju2+8UaTnGWZ0urP3vcdWbaTEg==
X-Received: by 2002:a17:902:7b94:b0:1a6:7ed8:84f7 with SMTP id w20-20020a1709027b9400b001a67ed884f7mr19045060pll.20.1683042731539;
        Tue, 02 May 2023 08:52:11 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:62ab:a7fd:a4e3:bd70])
        by smtp.gmail.com with ESMTPSA id o3-20020a170902778300b001a1a07d04e6sm19917212pll.77.2023.05.02.08.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 08:52:11 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v7 05/13] bpf: sockmap, handle fin correctly
Date:   Tue,  2 May 2023 08:51:51 -0700
Message-Id: <20230502155159.305437-6-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230502155159.305437-1-john.fastabend@gmail.com>
References: <20230502155159.305437-1-john.fastabend@gmail.com>
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
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
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

