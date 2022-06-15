Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC93A54CE82
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 18:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354769AbiFOQU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354819AbiFOQUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:20:24 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C104335;
        Wed, 15 Jun 2022 09:20:23 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id p63so9080334qkd.10;
        Wed, 15 Jun 2022 09:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YwLawl/4zZ8T1eVXZ9RLM+u5R3sy+ZfydBh5GxBZmMA=;
        b=IEZZioPZnHcgdCMQzwCI7x1L1X+xt0h3NkQLb1Z0k9Ui9/XLi9ULN5SjRrWEExpjjV
         V5EI6BvvX5bEfXc0N6VLtam4VtV1sZCRfhKoAZ4gJKQW9kAqeLMMGdwh+5Eq88gCWMA+
         m46olnCRqkwYP+M+Grx9555jddX+graVhpjIOnTwWDIZjSoZP45SEzBlMtlz9Gew7F9E
         e/5s+ECy9EKTxtO29gBO3GUWYFMaopF683AIZtG0h830rKV7hG3NEE+CNc1dvoOjx1NI
         onJeMVhlXy4VazHop5GWsuJQ+uqUghOzQZiEuXwhZPfETlFoh/3D4NMsnuD7kaYdPAWZ
         u2aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YwLawl/4zZ8T1eVXZ9RLM+u5R3sy+ZfydBh5GxBZmMA=;
        b=mvkn9CnW70CkNaRf2g7lEwNfRj6hM3o9n2+HKxS7st26f8kcvZKOnpb3zxa8sT9D+9
         3iCOThDKmk6Xf1vlbKrTf03Sgn5kDhUqGcMJthlfaMSW24zyWwmTxfYmE5q+BI7Ul5u+
         b43Qfx2W5iXTriJxVeLTF7blGjSLeTRulUHHNEYHQln1aqesixVh6kAR5MYh3cO93VE4
         e/ywIxDrNgqnZ8xIagwTFO04PTHVSFtrn5OkNnJ0wwybw0BazXHwxvNh+CKcsUwuLpbU
         S0qlVNPqQ0+nIYoO6NE8rLzt9edlflWXDQRLrPWMblNhwQjf4CLtNP4I2Ebo+Kq5GDfr
         dr6Q==
X-Gm-Message-State: AJIora8gSqBBUjmMgdPFrl7l6Ft7c0DUnfgS7kwG0snwyYDzPxBymMML
        4NL/FH8HN3XFkOrGq3F/2Ne2x1NMqVI=
X-Google-Smtp-Source: AGRyM1vDUfJRUg1hpBu3q+Y6z7sKhw2ZVFIUJvo+3KEZB844Gz/Hmp7NxsITFwq1q98vP5KWUrLugg==
X-Received: by 2002:a05:620a:1535:b0:6a6:8fdb:29e4 with SMTP id n21-20020a05620a153500b006a68fdb29e4mr389383qkk.126.1655310022299;
        Wed, 15 Jun 2022 09:20:22 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:a62b:b216:9d84:9f87])
        by smtp.gmail.com with ESMTPSA id az7-20020a05620a170700b006a69ee117b6sm11893918qkb.97.2022.06.15.09.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:20:21 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v4 1/4] tcp: introduce tcp_read_skb()
Date:   Wed, 15 Jun 2022 09:20:11 -0700
Message-Id: <20220615162014.89193-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220615162014.89193-1-xiyou.wangcong@gmail.com>
References: <20220615162014.89193-1-xiyou.wangcong@gmail.com>
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

From: Cong Wang <cong.wang@bytedance.com>

This patch inroduces tcp_read_skb() based on tcp_read_sock(),
a preparation for the next patch which actually introduces
a new sock ops.

TCP is special here, because it has tcp_read_sock() which is
mainly used by splice(). tcp_read_sock() supports partial read
and arbitrary offset, neither of them is needed for sockmap.

Cc: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/net/tcp.h |  2 ++
 net/ipv4/tcp.c    | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1e99f5c61f84..878544d0f8f9 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -669,6 +669,8 @@ void tcp_get_info(struct sock *, struct tcp_info *);
 /* Read 'sendfile()'-style from a TCP socket */
 int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		  sk_read_actor_t recv_actor);
+int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
+		 sk_read_actor_t recv_actor);
 
 void tcp_initialize_rcv_mss(struct sock *sk);
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9984d23a7f3e..e4adbdb0a5c4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1709,6 +1709,53 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 }
 EXPORT_SYMBOL(tcp_read_sock);
 
+int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
+		 sk_read_actor_t recv_actor)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	u32 seq = tp->copied_seq;
+	struct sk_buff *skb;
+	int copied = 0;
+	u32 offset;
+
+	if (sk->sk_state == TCP_LISTEN)
+		return -ENOTCONN;
+
+	while ((skb = tcp_recv_skb(sk, seq, &offset)) != NULL) {
+		int used;
+
+		__skb_unlink(skb, &sk->sk_receive_queue);
+		used = recv_actor(desc, skb, 0, skb->len);
+		if (used <= 0) {
+			if (!copied)
+				copied = used;
+			break;
+		}
+		seq += used;
+		copied += used;
+
+		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
+			consume_skb(skb);
+			++seq;
+			break;
+		}
+		consume_skb(skb);
+		if (!desc->count)
+			break;
+		WRITE_ONCE(tp->copied_seq, seq);
+	}
+	WRITE_ONCE(tp->copied_seq, seq);
+
+	tcp_rcv_space_adjust(sk);
+
+	/* Clean up data we have read: This will do ACK frames. */
+	if (copied > 0)
+		tcp_cleanup_rbuf(sk, copied);
+
+	return copied;
+}
+EXPORT_SYMBOL(tcp_read_skb);
+
 int tcp_peek_len(struct socket *sock)
 {
 	return tcp_inq(sock->sk);
-- 
2.34.1

