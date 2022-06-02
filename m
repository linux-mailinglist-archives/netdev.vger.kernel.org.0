Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A96453B101
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbiFBBVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiFBBVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:21:15 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11803DFF4E;
        Wed,  1 Jun 2022 18:21:15 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id hh4so2473386qtb.10;
        Wed, 01 Jun 2022 18:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xbpoU2l5r45xw+H3KPQxXCkUA1MJk08XLfcITDKBoqE=;
        b=h88Rxu5xYYOwyjVOPiL0TS2j73TFJzpezE2bVAneSsNsmhA3KtTaXl3y/f4+SmifDC
         U8/O0HsjljroQKIxcfyARkDeYHXzB6RO4unPNTvqnUkl7oUBy0Cd97657k9qo2+vZoBj
         DQcCgX0xp66MUNk0SHHWhlGARHInJid7hlf33zkQWnEf5v/VRL0zSC9r9zFPhRAu1bjm
         SwH4AQxPf8r9Se+v5vrdEUX4FHvWWjUT/0ZomY7FDvP+gOQgDaCmqukxY8HCZS4Apn00
         yS0HOIYcnajn2gYz8VfBKovLCHFp9dzPUolKE6HBC8W0wfEnnZ7o9133jbBdob39X7Ku
         EKlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xbpoU2l5r45xw+H3KPQxXCkUA1MJk08XLfcITDKBoqE=;
        b=Vsj9mnUM3Ix0359hGexbJGUIuHP9swMdFDnHi30Ad3htjqmcvk3E1uolIp0HWbPTe5
         ICQS30nJuJ3zRwXEsMYmyzwoOU/F+FHE72jLtGfMG12NutE9cI0Os2bJk0Ty3lNxYqjj
         TpH+Ni6CkUevfPDFSwpSNaGXNN2R6kOhlUqFnbrs5lXXU3VGVz8Dk3HG3t8Ofu7/ftKP
         3nrtb3/lBSd3XMQ+Y6/WeCMKRbW+PZn5yAIXYJueZNpRGi9i9AxMVl0W+9vKZ8eSoGTe
         Gp/j3m7km+qQpWxyQ/b1zA2iTA6YTIyqEPtYcCA/3bsnXisd348z1fyz4HCud4b7AroF
         xFcg==
X-Gm-Message-State: AOAM532sL29LKm1vfDneWxiS49Y/emkWSPbdHkHQjnwN1QJVWcO2pTk0
        OWhS9tSz9vvqH/irmwnHahS1x/XjWoQ=
X-Google-Smtp-Source: ABdhPJwMYn+sIJRNymEs7Mef1oMsz6fskgwf5iCG1TAMqM7+BRW4hrtsTGRFVYnpNaecWWPKtVf6JQ==
X-Received: by 2002:a05:622a:181a:b0:2fc:41c0:72eb with SMTP id t26-20020a05622a181a00b002fc41c072ebmr2016461qtc.397.1654132873965;
        Wed, 01 Jun 2022 18:21:13 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:a168:6dba:43b7:3240])
        by smtp.gmail.com with ESMTPSA id x4-20020ac87304000000b002f39b99f670sm2077654qto.10.2022.06.01.18.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 18:21:13 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v3 1/4] tcp: introduce tcp_read_skb()
Date:   Wed,  1 Jun 2022 18:21:02 -0700
Message-Id: <20220602012105.58853-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220602012105.58853-1-xiyou.wangcong@gmail.com>
References: <20220602012105.58853-1-xiyou.wangcong@gmail.com>
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
index 9984d23a7f3e..a18e9ababf54 100644
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
+			kfree_skb(skb);
+			++seq;
+			break;
+		}
+		kfree_skb(skb);
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

