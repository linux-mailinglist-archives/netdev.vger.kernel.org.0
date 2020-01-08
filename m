Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE22133AA3
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 05:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgAHE5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 23:57:35 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:40240 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgAHE5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 23:57:34 -0500
Received: by mail-pj1-f67.google.com with SMTP id bg7so532254pjb.5;
        Tue, 07 Jan 2020 20:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m44dl7x3yj9tSaGx90GMMD8DB8B0At1oc8yRgAas6R4=;
        b=JPvKYAAsITPbOs0K3JHyudWUya8Z2965e3sSKlAx8wpoL0ADpTZeEBBzgRJrDQBWT4
         /FYUZoqJv38aXfDO7VvrouMU8aT+twvOb/c5elUZn95gS6oAKYXSs/Yjh2xBj/gViHWP
         HLhZPHWsMTJgaOwEBHteWObUFZa+ozNIDyQcm0V7RCjF9KXkmRoAh0tnvTl2No35LEe3
         RmrfeE1yEIJhxEzXjVK1aE4kx9Agl/clT1h/nC/4CRazmncJd+DAowqtpOymVO/PgNrL
         TTH2cFp/3dXoSCmvZOgusTRWovyfum7tA0UUf4skNrPd5u6GQUNRP8XgcakU6T4jhAiP
         tVeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=m44dl7x3yj9tSaGx90GMMD8DB8B0At1oc8yRgAas6R4=;
        b=AjoUbUcASd+aLqxTUwLFYLy04h6Sd8s84GpFr2u6Qr2KddI03ze+9XHbXhivXRagHA
         OW64VMvj9h1pT4oXumOY3XlhjdnkMYdX5xjQdJSOco0ZHSGpiVifYLWUsUb6adLVYmpH
         RuBOnHO6jYrzJPhRK9XnQ9nBVNJfKxUSG095UoOV1Wu4iDWYiuZoKGK1ftMUyybURPU2
         JG7r8JQp3zyCoxKjRe6f1b+Gca0wN2s7IOrRqzVTa654HD33RGgZunnfXC1LElpvj3dX
         bx3js3fVKDBMiDQdfJYHMTZc3WUV6sx76U4KkKDmdXPp7uZzMYMewNy/GBsJ5AsYwoDd
         0TvQ==
X-Gm-Message-State: APjAAAVuVtxzDOQ7HpLF7uq+Gdi9F6kIHjb+EbkM8JTKtzQtBu5/BndQ
        FFpkgX1md9VUnejnDQC+4M5qbKLuGNg=
X-Google-Smtp-Source: APXvYqx0623rZY4Fw6qW70WOdQ0IR+MsBERVAIMuxZLpf1r82C2am8FafrT4FAcdBeWKLpvEQEKAtA==
X-Received: by 2002:a17:902:b186:: with SMTP id s6mr3493629plr.333.1578459453787;
        Tue, 07 Jan 2020 20:57:33 -0800 (PST)
Received: from localhost.localdomain ([150.109.61.200])
        by smtp.gmail.com with ESMTPSA id v7sm1224280pjs.2.2020.01.07.20.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 20:57:33 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Lingpeng Chen <forrest0579@gmail.com>
Subject: [PATCH] bpf/sockmap: read psock ingress_msg before sk_receive_queue
Date:   Wed,  8 Jan 2020 12:57:08 +0800
Message-Id: <20200108045708.31240-1-forrest0579@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <5e15526d2ebb6_68832ae93d7145c08c@john-XPS-13-9370.notmuch>
References: <5e15526d2ebb6_68832ae93d7145c08c@john-XPS-13-9370.notmuch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now in tcp_bpf_recvmsg, sock read data first from sk_receive_queue
if not empty than psock->ingress_msg otherwise. If a FIN packet arrives
and there's also some data in psock->ingress_msg, the data in
psock->ingress_msg will be purged. It is always happen when request to a
HTTP1.0 server like python SimpleHTTPServer since the server send FIN
packet after data is sent out.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Reported-by: Arika Chen <eaglesora@gmail.com>
Suggested-by: Arika Chen <eaglesora@gmail.com>
Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index e38705165ac9..f7e902868fce 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -123,12 +123,13 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
-	if (!skb_queue_empty(&sk->sk_receive_queue))
-		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
 
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+	if (!skb_queue_empty(&sk->sk_receive_queue) &&
+	    sk_psock_queue_empty(psock))
+		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
 	lock_sock(sk);
 msg_bytes_ready:
 	copied = __tcp_bpf_recvmsg(sk, psock, msg, len, flags);
@@ -139,7 +140,7 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		timeo = sock_rcvtimeo(sk, nonblock);
 		data = tcp_bpf_wait_data(sk, psock, flags, timeo, &err);
 		if (data) {
-			if (skb_queue_empty(&sk->sk_receive_queue))
+			if (!sk_psock_queue_empty(psock))
 				goto msg_bytes_ready;
 			release_sock(sk);
 			sk_psock_put(sk, psock);
-- 
2.17.1

