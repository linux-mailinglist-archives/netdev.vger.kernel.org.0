Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2612541F8C0
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 02:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhJBAjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 20:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbhJBAi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 20:38:59 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64827C061775;
        Fri,  1 Oct 2021 17:37:14 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id z11so13543630oih.1;
        Fri, 01 Oct 2021 17:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mjh66l7EjiKQtKP9c2a3KtPXE8PrCUDOCdt6/27IAc4=;
        b=ktzhE6e9xHvZ9Tx4keKPokaynKMNqE4C2JVNMKAkG3LjNRNBtEpLCPpRx027vuikFw
         31ca97C4E9ADyp3ZB6VWl6d69ilAmCepkVK+NaIiMXYkOE3mfCWpzG0cvcrMH+Sxs0qD
         ywe6KcYe/0SBqjMHtefq5GDnGmiit35jxhpBfEj6dvVMXaycT6lzBAQUOGGM3txTSfoI
         E4VeFgjDye4utaSMw4gSKvrlPIZeWIkc6Yy9awba0o0k77R8mZjEBTUaaes9jY2NPr4L
         Pi8lDEarTenbHgu3XYoRch7XdzJiLufvNJrlYwldMSQCZ51ov49tsdszr/iboOAe0Q2x
         VZ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mjh66l7EjiKQtKP9c2a3KtPXE8PrCUDOCdt6/27IAc4=;
        b=TQqW1RtK+JoJA19KY/NdaycCkfWU3HRDTO1eH9XcFopGRCdmlV4dmgnnQqv1OVDDlF
         4bGL6J7jsc+7Fvqa/VSW6WvoKADiPyS4WSep1DLImTW6nQ/B0rs9cyS44IMQ+5L9le+v
         QP90nOHwwu4i3G+v0vC6VapCKSaRuLf771NbJ+ikKjMXIM6Wg/tqJ42AshgPedWLbIwL
         oPOlCPMjR3teT6MoyiV5B9QtqD3Y6MKJuO2hIFAqaVUlo9hF+SMV5/Mz6crYvv3aCLH9
         lKapLHN21fuE+2Dw8AvaYMsV8/pGXsIYf3OBZEnEcreOXK20IlT1xPURuwFmZ8BmzRhv
         otew==
X-Gm-Message-State: AOAM533ez5KF9XFeQkgGqPYZmD5RHE1jezNMaNKMot/Z5t40mmvVEOtd
        +dXNT+9Imuv49olwDb/GwH/ZjktnJc0=
X-Google-Smtp-Source: ABdhPJzEPWu9hLtS11XNId6wfzPzxTNPM9/oRoQcCKCCWQVQ2mu0dGyKv6viGkBUwBd7V614ZCljJQ==
X-Received: by 2002:a05:6808:130f:: with SMTP id y15mr6133489oiv.33.1633135033725;
        Fri, 01 Oct 2021 17:37:13 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a62e:a53d:c4bc:b137])
        by smtp.gmail.com with ESMTPSA id p18sm1545017otk.7.2021.10.01.17.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 17:37:13 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v3 2/4] skmsg: extract and reuse sk_msg_is_readable()
Date:   Fri,  1 Oct 2021 17:37:04 -0700
Message-Id: <20211002003706.11237-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211002003706.11237-1-xiyou.wangcong@gmail.com>
References: <20211002003706.11237-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

tcp_bpf_sock_is_readable() is pretty much generic,
we can extract it and reuse it for non-TCP sockets.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h |  1 +
 net/core/skmsg.c      | 14 ++++++++++++++
 net/ipv4/tcp_bpf.c    | 15 +--------------
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 14ab0c0bc924..1ce9a9eb223b 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -128,6 +128,7 @@ int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
 			     struct sk_msg *msg, u32 bytes);
 int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		   int len, int flags);
+bool sk_msg_is_readable(struct sock *sk);
 
 static inline void sk_msg_check_to_free(struct sk_msg *msg, u32 i, u32 bytes)
 {
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 2d6249b28928..a86ef7e844f8 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -474,6 +474,20 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 }
 EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
 
+bool sk_msg_is_readable(struct sock *sk)
+{
+	struct sk_psock *psock;
+	bool empty = true;
+
+	rcu_read_lock();
+	psock = sk_psock(sk);
+	if (likely(psock))
+		empty = list_empty(&psock->ingress_msg);
+	rcu_read_unlock();
+	return !empty;
+}
+EXPORT_SYMBOL_GPL(sk_msg_is_readable);
+
 static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
 						  struct sk_buff *skb)
 {
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 0175dbcb7722..dabbc93e31b6 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -150,19 +150,6 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
 EXPORT_SYMBOL_GPL(tcp_bpf_sendmsg_redir);
 
 #ifdef CONFIG_BPF_SYSCALL
-static bool tcp_bpf_sock_is_readable(struct sock *sk)
-{
-	struct sk_psock *psock;
-	bool empty = true;
-
-	rcu_read_lock();
-	psock = sk_psock(sk);
-	if (likely(psock))
-		empty = list_empty(&psock->ingress_msg);
-	rcu_read_unlock();
-	return !empty;
-}
-
 static int tcp_msg_wait_data(struct sock *sk, struct sk_psock *psock,
 			     long timeo)
 {
@@ -479,7 +466,7 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 	prot[TCP_BPF_BASE].unhash		= sock_map_unhash;
 	prot[TCP_BPF_BASE].close		= sock_map_close;
 	prot[TCP_BPF_BASE].recvmsg		= tcp_bpf_recvmsg;
-	prot[TCP_BPF_BASE].sock_is_readable	= tcp_bpf_sock_is_readable;
+	prot[TCP_BPF_BASE].sock_is_readable	= sk_msg_is_readable;
 
 	prot[TCP_BPF_TX]			= prot[TCP_BPF_BASE];
 	prot[TCP_BPF_TX].sendmsg		= tcp_bpf_sendmsg;
-- 
2.30.2

