Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864246D8A52
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 00:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbjDEWJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 18:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbjDEWJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 18:09:14 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A3C7A87;
        Wed,  5 Apr 2023 15:09:13 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso41011264pjb.0;
        Wed, 05 Apr 2023 15:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680732553; x=1683324553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=npUFrgc9AMRZVGcro/ogjr8k13SD8DOZ44oHkdjV4t4=;
        b=V0fqZva8Qkav6hpencV4NJBlp7pYdK5/FtKc0Rq+c45h9HXin2EoCq7Tld7HA/KqiE
         01Aws3AEKQmVP3nHNRW5Jj4Tgit99ictR7RIv/Xt6SbH57KOjqhFlua5xzMZ+m2KiK6N
         XptbStIjTXWnjSYJB7osl+t9G3Wi9ZTUqvxvRbWK18YoOZApX/pQmuRRkOWmxttu0ZRF
         MYHiCuVH+r1XsVwjGYbLWsijJUeGAxFU+R91SoitJ0jCuju6OY5BHkFV6984TwsM8MCD
         K/xhbaDMmacAsEX9RH4AnXwHg9hFtnVkQfkTKxX/hIQmNJav1u0latLM252IBuODpxXz
         m44w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680732553; x=1683324553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=npUFrgc9AMRZVGcro/ogjr8k13SD8DOZ44oHkdjV4t4=;
        b=RptCO1xU68DWFR6d240JFmcwfzaZ+XKx2vLnWtYgl6IAPzBZYshXgIm1VWLLpGng2U
         wBcBK+iklWUY/N1s9C+fofBqmF0K+XijfLX4zaZckp95Uw1RNl+Gz0Gn16o3tmGTis6C
         1sIlqV9e3nH6JiEXL6LO01Bnic+3G3mVCRtj4ro41VfSS27mDC7XRZpQi8nBUxkqvOLx
         SOX8bG3jsSF9fbKGZhG0CGwto2S9MCJKDbnOfUmCSZJtCfI50YnrPSSMqH2hmo/LvH1l
         +VQ3ZsVxsGHhl51xsYfw8RjseJceh2zfytqlcSrFlwD4VHAbrGN94x802bCqRScOO2Pv
         MJiw==
X-Gm-Message-State: AAQBX9dxBbEBjsvn+EEU5J/i2N+AKUveCvUuzfOxt48s6/W+6lVH2JlO
        PX20seLx+HST5PefkblOb5gK+A8kKz7RlA==
X-Google-Smtp-Source: AKy350aIlux8iCTSoRYUZb4JvmVNVgTbph0YR6TNdob5TlxKtszmfIPrn7aBl5MH4i6fyMYm0hQT7g==
X-Received: by 2002:a17:90b:1d83:b0:234:b8cb:512b with SMTP id pf3-20020a17090b1d8300b00234b8cb512bmr8269733pjb.30.1680732553395;
        Wed, 05 Apr 2023 15:09:13 -0700 (PDT)
Received: from john.lan ([2605:59c8:4c5:7110:5120:4bff:95ea:9ce0])
        by smtp.gmail.com with ESMTPSA id gz11-20020a17090b0ecb00b00230ffcb2e24sm1865697pjb.13.2023.04.05.15.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 15:09:12 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v4 04/12] bpf: sockmap, handle fin correctly
Date:   Wed,  5 Apr 2023 15:08:56 -0700
Message-Id: <20230405220904.153149-5-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230405220904.153149-1-john.fastabend@gmail.com>
References: <20230405220904.153149-1-john.fastabend@gmail.com>
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

