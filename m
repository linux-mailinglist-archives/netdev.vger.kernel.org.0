Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66C16D51C0
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbjDCUB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbjDCUBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:01:53 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F963A81;
        Mon,  3 Apr 2023 13:01:48 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f22so25057849plr.0;
        Mon, 03 Apr 2023 13:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680552108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=npUFrgc9AMRZVGcro/ogjr8k13SD8DOZ44oHkdjV4t4=;
        b=Vv5eQmpqsFvbhSsAmUhf16VvcgvMNELn6OtmP5GsctKUBuflpbYq5kbNar0MSEoojB
         fCH+kWW1uJUuyBo3x6eGeWvL8zDBYD1O7Y33WUXok2QLLczlOggROUOsobzvxxuGIyp7
         FrVHvldPDlSURHKmiYxB0QtyuIr3jtT+K/S8QIeN3jh5UxdREW3WT4MSHF74qST72E4N
         2H+Euv3bc/xitZdFCzhWDgtuiU4uY0zL22+/j6hGNyhvNzvT/e1SRanft4J6d00CyTDI
         HJ8HYalJ2LsLjXVKmfoUqsHoopzAJSDj4ezkJMf7C3pEEf6at112viOXj5w9DhH1CD9F
         13pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680552108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=npUFrgc9AMRZVGcro/ogjr8k13SD8DOZ44oHkdjV4t4=;
        b=Gsc5obtthQkQ7nuufjzwAxycLqmVzQC8Zdb4q1mixhWBIrXE2kPZ8RI6dVgPutSUdZ
         JobHMoCYg8Yx54gonIahHx7RhHH928oPnuUxzPZnERLswxCK00tusrw769Yd0KxwvzBG
         ub523TZGYbLd2gSba5hhvyuDAeYHZti0HE846xYIBQOL2OI9F/kYlU0MvyWWBVlWToN4
         szGb+0hHbj0kQ3FefcylU8sYcxVWjFjcqzkEoV9Hy8/PokGaCYn3NFdJ6cMfdreUp4GZ
         wNcGuUunikZxeSJB5sO5Bb+cblpg3+opNgqu6PxMdbQU3qwQEIwAMmphfI609ewAs8yi
         oFWw==
X-Gm-Message-State: AAQBX9dFBGXdmytPhXniUTvjQ//7J7SEG2xZY9Frtk9uh7WVCqvl8jiZ
        7mQ1uma/tMhqAbDahQZph3s=
X-Google-Smtp-Source: AKy350YrtipM4Ip6r4aILOTXAJtcaGu8XSbxCH7WhNXbHCuWG9aEz1jQxTj/IjpekbxvMlzOrULeJw==
X-Received: by 2002:a17:90a:190d:b0:240:95a9:923d with SMTP id 13-20020a17090a190d00b0024095a9923dmr26004055pjg.48.1680552107665;
        Mon, 03 Apr 2023 13:01:47 -0700 (PDT)
Received: from localhost.localdomain ([2605:59c8:4c5:7110:3da7:5d97:f465:5e01])
        by smtp.gmail.com with ESMTPSA id t18-20020a1709028c9200b0019c2b1c4db1sm6948835plo.239.2023.04.03.13.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:01:47 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     cong.wang@bytedance.com, jakub@cloudflare.com,
        daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v3 04/12] bpf: sockmap, handle fin correctly
Date:   Mon,  3 Apr 2023 13:01:30 -0700
Message-Id: <20230403200138.937569-5-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230403200138.937569-1-john.fastabend@gmail.com>
References: <20230403200138.937569-1-john.fastabend@gmail.com>
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

