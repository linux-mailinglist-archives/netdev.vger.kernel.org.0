Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B8C60EC98
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 01:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbiJZX2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 19:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJZX16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 19:27:58 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5925FC25;
        Wed, 26 Oct 2022 16:27:31 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id b20-20020a05600c4e1400b003cc28585e2fso2885782wmq.1;
        Wed, 26 Oct 2022 16:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5sjP64Qj3I5bM+4YXFPnF6jS8rNRlxRMcMkh4ovNirg=;
        b=hOW4gFulPjHAP04yJhIeyWaiuhS24jqmREX7c+IgE54LM2NKovz1FWlIqBhp01kQP1
         /S5eAyOVFQdE/ldiqdofL/W1Q3amz0NIb9YaZV14guxtSCAwF0DBhMEVEPUITmc7WxOe
         5MIpx3clK/qA/3lxYJjNHyM30IL3J2BhRAIewe+Iooe8c86LEXw13JetnFL9gHUbPSCn
         GCKe2fO4832tjBa+CD9xCK7f3z20IWsmuFvrt/6kq0A2U7WD1zNNag0hKDIFULCvsXYy
         rQviCY8w3JtRCQBCaIfM6Ikob6bkhiEjIwCq+hTpNoscSYTVJnf/FXCok7OLxVoSBAwZ
         CB4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5sjP64Qj3I5bM+4YXFPnF6jS8rNRlxRMcMkh4ovNirg=;
        b=X4SRcwjulpDWzL1Ywj+e8YcYEI+gvVLnmHtafSgV7nwp9fa9nfZxvuwnhdEtUTzI56
         X67MJLtUgyAaKDL1BRVbKinGj3S7R7K4eQOUuzW1a06vgz+LCdD/LIazBKvie7RrXPv0
         pwc88kXCh4oXyP0+Rylvp1/uUtKCxPWkctIyTjKnaOu0INpFwCPBfZUKt/NqF/3huf8m
         5VudJRzaQB62Pogs3DtVBCE9Ndz74P4SHz7H8lhF0rC/chNMs5EUQgZ2/fOiWAP1+UGP
         VJr+Yf5J2+1VLwstcYn0scWRY+xFLLzu7+9N7wasRO8V6sWcpKdSAqXjAB0Y+EaYiaFr
         3c1A==
X-Gm-Message-State: ACrzQf2JfR5bMgmlCKsy75Rf/u2vYqu+sUuQ52MpzN+yYyL9tEughAlo
        dY7J03qoVPeaAxYs3GF4q/sE+6FFYfIrGA==
X-Google-Smtp-Source: AMsMyM7sl2k4Z0mb2kqpOuPapuoryWhoK6WgF3TBhFHomHJnLiD10D/KOZa1konHqlOHkltrX9liyw==
X-Received: by 2002:a05:600c:3acd:b0:3ce:3f62:a8d1 with SMTP id d13-20020a05600c3acd00b003ce3f62a8d1mr3896899wms.78.1666826849603;
        Wed, 26 Oct 2022 16:27:29 -0700 (PDT)
Received: from 127.0.0.1localhost (213-205-70-130.net.novis.pt. [213.205.70.130])
        by smtp.gmail.com with ESMTPSA id y4-20020adfd084000000b002368424f89esm4897526wrh.67.2022.10.26.16.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 16:27:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, io-uring@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        asml.silence@gmail.com
Subject: [PATCH net 2/4] net: remove SOCK_SUPPORT_ZC from sockmap
Date:   Thu, 27 Oct 2022 00:25:57 +0100
Message-Id: <0d46741e883fd596d6d24a1445177bf0ba842f5f.1666825799.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666825799.git.asml.silence@gmail.com>
References: <cover.1666825799.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sockmap replaces ->sk_prot with its own callbacks, we should remove
SOCK_SUPPORT_ZC as the new proto doesn't support msghdr::ubuf_info.

Cc: <stable@vger.kernel.org> # 6.0
Reported-by: Jakub Kicinski <kuba@kernel.org>
Fixes: e993ffe3da4bc ("net: flag sockets supporting msghdr originated zerocopy")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/sock.h  | 7 +++++++
 net/ipv4/tcp_bpf.c  | 4 ++--
 net/ipv4/udp_bpf.c  | 4 ++--
 net/unix/unix_bpf.c | 8 ++++----
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 22f8bab583dd..5db02546941c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1889,6 +1889,13 @@ void sock_kfree_s(struct sock *sk, void *mem, int size);
 void sock_kzfree_s(struct sock *sk, void *mem, int size);
 void sk_send_sigurg(struct sock *sk);
 
+static inline void sock_replace_proto(struct sock *sk, struct proto *proto)
+{
+	if (sk->sk_socket)
+		clear_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
+	WRITE_ONCE(sk->sk_prot, proto);
+}
+
 struct sockcm_cookie {
 	u64 transmit_time;
 	u32 mark;
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index a1626afe87a1..c501c329b1db 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -607,7 +607,7 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 		} else {
 			sk->sk_write_space = psock->saved_write_space;
 			/* Pairs with lockless read in sk_clone_lock() */
-			WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+			sock_replace_proto(sk, psock->sk_proto);
 		}
 		return 0;
 	}
@@ -620,7 +620,7 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 	}
 
 	/* Pairs with lockless read in sk_clone_lock() */
-	WRITE_ONCE(sk->sk_prot, &tcp_bpf_prots[family][config]);
+	sock_replace_proto(sk, &tcp_bpf_prots[family][config]);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tcp_bpf_update_proto);
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index ff15918b7bdc..e5dc91d0e079 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -141,14 +141,14 @@ int udp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 
 	if (restore) {
 		sk->sk_write_space = psock->saved_write_space;
-		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+		sock_replace_proto(sk, psock->sk_proto);
 		return 0;
 	}
 
 	if (sk->sk_family == AF_INET6)
 		udp_bpf_check_v6_needs_rebuild(psock->sk_proto);
 
-	WRITE_ONCE(sk->sk_prot, &udp_bpf_prots[family]);
+	sock_replace_proto(sk, &udp_bpf_prots[family]);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(udp_bpf_update_proto);
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index 7cf14c6b1725..e9bf15513961 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -145,12 +145,12 @@ int unix_dgram_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool re
 
 	if (restore) {
 		sk->sk_write_space = psock->saved_write_space;
-		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+		sock_replace_proto(sk, psock->sk_proto);
 		return 0;
 	}
 
 	unix_dgram_bpf_check_needs_rebuild(psock->sk_proto);
-	WRITE_ONCE(sk->sk_prot, &unix_dgram_bpf_prot);
+	sock_replace_proto(sk, &unix_dgram_bpf_prot);
 	return 0;
 }
 
@@ -158,12 +158,12 @@ int unix_stream_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool r
 {
 	if (restore) {
 		sk->sk_write_space = psock->saved_write_space;
-		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+		sock_replace_proto(sk, psock->sk_proto);
 		return 0;
 	}
 
 	unix_stream_bpf_check_needs_rebuild(psock->sk_proto);
-	WRITE_ONCE(sk->sk_prot, &unix_stream_bpf_prot);
+	sock_replace_proto(sk, &unix_stream_bpf_prot);
 	return 0;
 }
 
-- 
2.38.0

