Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8677F131E9D
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 05:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgAGEXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 23:23:10 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34259 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727493AbgAGEXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 23:23:10 -0500
Received: by mail-pl1-f194.google.com with SMTP id x17so22676691pln.1
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 20:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7sdYEEdWKIHcigZDGjeKamKrFeCwvmgv9bOzZ4kn1XM=;
        b=N4VMsmUDrzkK84FdmxBbpdgfMBgxJ/o/NybCvSos5lvruEU0BARhwOtQ/nxJGIGWL5
         Pqu6XR671mxQALZ43i3GKSgyk8CtAqmvgglgyhcOKfAx2u6gEIdWHfLtO0kgUGGM98Ip
         fZnsHQMQI6hZzPu383mqn4pwGltqlgG7UqSuFo3bcwwHoNtimUDtGtkISkT7wAgglOIV
         oA9hmhjnYvpY4cMvRyXtu411i8/9pyxx5EQEw0BJ2le02k08+t6SPtGKR/BBXaifqE3h
         BlJCDsqGtFnwgWAwcw3TnF4RXb4B3Mlm+8JGdQn5ftoeBL/DWtwQkj7lnEeuJrIYLL4r
         Wrxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7sdYEEdWKIHcigZDGjeKamKrFeCwvmgv9bOzZ4kn1XM=;
        b=V2r3JD4MjOQAPUNJRnHzHW208UEug6uCJBLo3E/flPLPKfYFmWfwsRfgcaAfg9pNVA
         T8phNyqMAy8H7d0BEzB04+ZSIXCrWTJmlo2kh0VqCgUoKs0jio1aKN7rOpE1illD/WG1
         ciI5vHrY769ncjqPHV4AW/7gy05snCPopBlZbYKE6Lwutj6Y1FAzWqtu8hIwLQIH/56/
         Q99uYCZ8RrH2qfKlklXQZU9FKt11Iusu0u4naYZpExcxQR/dUCAsM/cwi5fWFL9HSsLT
         4w0yjcEkzOv8fzrUZ6zlZdo+yv/3xe5emYcosP7oApxmLYRAsiIpyqC/rB9bR4oE3KIs
         n3Rw==
X-Gm-Message-State: APjAAAWYOGxeQUq/+WXnWuW41Tdq6iJbeQS9QvnvlX9vYHiGtI6wCflu
        aKPyBvI/4a6dKfRdam3xX8vll13J3Njq5A==
X-Google-Smtp-Source: APXvYqzVaBtjo7cRt3bBylINFitaMEpU5IVvRGpJLFGO937emYmLZheKs0hRbMYha0Z13rcWq4lotA==
X-Received: by 2002:a17:902:9a95:: with SMTP id w21mr87187173plp.91.1578370989946;
        Mon, 06 Jan 2020 20:23:09 -0800 (PST)
Received: from localhost.localdomain ([150.109.61.200])
        by smtp.gmail.com with ESMTPSA id 65sm83415006pfu.140.2020.01.06.20.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 20:23:09 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.or, Lingpeng Chen <forrest0579@gmail.com>
Subject: [PATCH] bpf/sockmap: read psock ingress_msg before sk_receive_queue
Date:   Tue,  7 Jan 2020 12:22:47 +0800
Message-Id: <20200107042247.16614-1-forrest0579@gmail.com>
X-Mailer: git-send-email 2.17.1
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

Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
---
 net/ipv4/tcp_bpf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index e38705165ac9..cd4b699d3d0d 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -123,8 +123,6 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
-	if (!skb_queue_empty(&sk->sk_receive_queue))
-		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
 
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
@@ -139,7 +137,7 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
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

