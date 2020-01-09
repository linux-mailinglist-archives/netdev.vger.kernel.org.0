Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54DA8135115
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 02:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgAIByd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 20:54:33 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46559 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgAIByd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 20:54:33 -0500
Received: by mail-pl1-f195.google.com with SMTP id y8so1860566pll.13;
        Wed, 08 Jan 2020 17:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oTyqhoIX3DQ+f9hJq5TbGda1i2+Ze2UfFAEdDafc8q8=;
        b=GmDO/WGd93UwUu1yW3PvrXncmirI1deCSL4bb2jBkwJiEYaJJDe2PbxRj4l125ei+r
         hy5/0Sh3jdmoq2v49c8oT7SZYXjSJ/EwrRyHRulT85suNST5bT7mi6ooviV+lJux9lpC
         IGAVxaJSyXs4JeTbt4CBcHYFja8bniih5mgRaQe41sMEzOwFfm86iHCoSmzXQRbPVs4e
         EBrtlAhayhpiTsFWq3hjqSQKuyuVGSoHxhjRUmpc5/ptVOhn/81aZuJ1J20rNbn6GbAv
         wikuOlgGDtPX4xaj/AfvZ9oRsatt11siQmhA8FCI3MHy8vZHB3wZKQ7gUv3o6xpgeAOg
         YTKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oTyqhoIX3DQ+f9hJq5TbGda1i2+Ze2UfFAEdDafc8q8=;
        b=J73BOpMmL+GXB9xSo+x5YnKlepV9qoi6t7HwuUhJ7wZDm6qPg8xGogJbT4ApuWLnz9
         VpFdO1E1LdVPTIrEcZh0wz1I83yiYE6PpXH2IkzTjh6Y5peQDhrwbGrcFrRMn6zBGGuc
         rxhRbAnrbqqIJL5D8yMSrtNcJy0G2uJ9u/6ohe4XHbWePMUWGJNF8JURRM2WDLSdqL3K
         8eRKopZ4f3kezF9Gx4yb8CSkswnzIvFvajY1Ktx8FlEqONVcLfLTdqeJlYAVfjD3MubB
         H8AvrlCudDY41k7mM5kjLnXE9y8rneNvoC2eeisnIxldls90UjrDzXF4iaXAKGPZ0SKW
         xbOQ==
X-Gm-Message-State: APjAAAWzzKB07WWvq7MS4yLGCJ3tSzmPY9MdvlT3QtCfHBrmm5jlHzK5
        /XmH8v8QxfGnJzoPqpxB504=
X-Google-Smtp-Source: APXvYqxgSaZlh8DNyp/Ta+6TiAGMk7UVF2E/i9VnUsKohjyQ972AWVLZTjak/sDUHFtrb5N/aE3BQg==
X-Received: by 2002:a17:90a:b30b:: with SMTP id d11mr2186521pjr.22.1578534570464;
        Wed, 08 Jan 2020 17:49:30 -0800 (PST)
Received: from localhost.localdomain ([150.109.61.200])
        by smtp.gmail.com with ESMTPSA id j20sm4725635pfe.168.2020.01.08.17.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 17:49:29 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Lingpeng Chen <forrest0579@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] bpf/sockmap: read psock ingress_msg before sk_receive_queue
Date:   Thu,  9 Jan 2020 09:48:33 +0800
Message-Id: <20200109014833.18951-1-forrest0579@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <5e1620c332f3c_159a2af0aa9505b861@john-XPS-13-9370.notmuch>
References: <5e1620c332f3c_159a2af0aa9505b861@john-XPS-13-9370.notmuch>
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
Cc: stable@vger.kernel.org # v4.20+
Acked-by: Song Liu <songliubraving@fb.com>
---
 net/ipv4/tcp_bpf.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index e38705165ac9..e6b08b5a0895 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -121,14 +121,14 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	struct sk_psock *psock;
 	int copied, ret;
 
-	if (unlikely(flags & MSG_ERRQUEUE))
-		return inet_recv_error(sk, msg, len, addr_len);
-	if (!skb_queue_empty(&sk->sk_receive_queue))
-		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
-
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+	if (unlikely(flags & MSG_ERRQUEUE))
+		return inet_recv_error(sk, msg, len, addr_len);
+	if (!skb_queue_empty(&sk->sk_receive_queue) &&
+	    sk_psock_queue_empty(psock))
+		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
 	lock_sock(sk);
 msg_bytes_ready:
 	copied = __tcp_bpf_recvmsg(sk, psock, msg, len, flags);
@@ -139,7 +139,7 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
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

