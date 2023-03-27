Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F27E6CAC64
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbjC0RzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbjC0Ry7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:54:59 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899C03AAC;
        Mon, 27 Mar 2023 10:54:56 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id z18so5634428pgj.13;
        Mon, 27 Mar 2023 10:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679939696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y5tqObSMAtHNVK29HuvTPLgGUtx1E+Ad7BIcyyykhH0=;
        b=C6/0yBFeM8BHKJbCVN8wpZb508TlBLlmCCgmQBBzYr09CH+jqkRNbnBN5GHo3325T9
         ZgUBsaA7XcUfruoty6pKpAIEkosZnBIHmCBPRvgjw29kkcxRg+5tZ3dlSc7e40xdeu4q
         pPuUO/ge7WwdVQxX5LITXywJgyVB4ugoUYqnRAPLYPcwa4WKWibxobnzDYoh61PN0paD
         peYe0qMNI9JlZovlyILXYgycrKUJ4t20W7TMWbjah9UDD4Lchx5z4aHTKcn7ynqZEbN3
         Cd9WlYK1fDPDurLk2Lu+l8psLNZHR6BSSimqXqC/OtBzHaFYBGYBrHweESV8N4hybYtV
         nU3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679939696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y5tqObSMAtHNVK29HuvTPLgGUtx1E+Ad7BIcyyykhH0=;
        b=DwFGX8uPCA31a0F/uYhzPvxa+yHerhOt8aOjug89fJGWbCRnGkoOkCSP1yP9z/gcCF
         p7DNvVV+dj/+hI2DXBLwTS3ZEDRh+DVN3kxwbRzKZ1mX5lQ8A/s1+0AZTIz7Q8iGvDPF
         AqqAkOb1CGs//Rbk/mdNkI1uRQFNZr+aksaG+KEHNt0U28Qe1gbuoOSymTGYC56Rjwe5
         ALY95swy2l1iLfFvTkudEdYk04zym54WuDe2USmo5jWJfzJEQxzYnbSzsCmTqTrazCl9
         h+TUBrNhXRuWtCxrLEtrKGZY+dSG7fCd8fhm90LoC/+ec3dhbhoJwdi2Sf3Ob1C3v3m0
         Xf3A==
X-Gm-Message-State: AO0yUKVbFHgCgV3twmm5sYeuEafx6Pw+fGBI1Koa+xDxOeARACqJf3ro
        k5rPeT66wieh4RM3WcjzJ5A=
X-Google-Smtp-Source: AK7set94V1FjHwxvalM+ftwDbvy0vMdUTn4GBWzD8uCyrN4sX2np/1MLnoOk70huPA0FrdAYrXsapA==
X-Received: by 2002:a05:6a00:1da8:b0:5a8:c913:b108 with SMTP id z40-20020a056a001da800b005a8c913b108mr18335585pfw.9.1679939696074;
        Mon, 27 Mar 2023 10:54:56 -0700 (PDT)
Received: from john.lan ([98.97.117.131])
        by smtp.gmail.com with ESMTPSA id r1-20020a62e401000000b005a8ba70315bsm19408316pfh.6.2023.03.27.10.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 10:54:55 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     cong.wang@bytedance.com, jakub@cloudflare.com,
        daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v2 04/12] bpf: sockmap, handle fin correctly
Date:   Mon, 27 Mar 2023 10:54:38 -0700
Message-Id: <20230327175446.98151-5-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230327175446.98151-1-john.fastabend@gmail.com>
References: <20230327175446.98151-1-john.fastabend@gmail.com>
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
index cf26d65ca389..3a0f43f3afd8 100644
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
@@ -193,6 +211,19 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
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

