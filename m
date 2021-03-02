Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07D132A312
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378150AbhCBIq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444134AbhCBCjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:39:45 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13494C0617A9;
        Mon,  1 Mar 2021 18:38:04 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id 105so18645289otd.3;
        Mon, 01 Mar 2021 18:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qGgIBOZxfhj4RQXaRAJW/z/oxERFBXXb52q9pb05GWg=;
        b=Xub6m/fqWy9UDYtuvuotNM4hF3wsViKZZy/0QYUrz2l4g2C00eAzj9YId2jPs8Hodh
         JlU++zKNbc8vtm9e5pUAoYTrAYaxvjono/Em+4cAps5lYmWWFadvKjIY1QzSFhBt6n5z
         DYDa/XUMOM8lbrRzNVzh0pihxBGtNhBfGHebdYO378rG82Z/ezXQwtHC7YptEXnJ9bqQ
         BaXVKNAJxswXI+o/zKtZ8pK5fGST1XM7K84n8sTW7HtKm93H+39Xls/r/P+izaV8UX8U
         6uAPzJPPqcsIzeIyJ8RTxndu3l7H2YXAPi3uL1J2Mr/G51kL25SX/4vwTrude8EFjFt1
         a72w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qGgIBOZxfhj4RQXaRAJW/z/oxERFBXXb52q9pb05GWg=;
        b=OwbE/U/3jQyOW8fh9dTf7pfp7sayWr8rnhxYg/s6+4TiKGPElx9XiOMhYj6y+KG3X3
         ReHvyanZw0s7iVBQMWHb0mbohyuGOy620zWUxOO8M/BxQ/yg7wIwQECPa/BcKSVObkAM
         fRvgSd8bf/2EJRNbaWYuJIwJ5ra+hLqnEsx3WvnhsT6tmeviRPFtJIzZzIFWtD15QF1F
         LYB/aH7SzaZYVQumpoxfdgIMGVltlv+ljFXoFeJ3GJQIoTXQZ5ydaATeGck5vHl+ZjLa
         JWZVgr3Uebplvr678x6A27lMHvJ23xwwGG304VsbCs7vJ4sbnEhSOV3THZMDrM+4vbVm
         hvgg==
X-Gm-Message-State: AOAM53088v72wVdLQYj1UOi15pf3doYOtuj32MkhQfGjAuCZKWkDxp2D
        FCZZFA465wgPg+k08kGWw4SA8dnH9Bj18Q==
X-Google-Smtp-Source: ABdhPJx3H6Ao6rDPhVOoJO9vXVYk78Y0zbb9gZGhYu9ZTh+L7vGMPVipRBeq3QQZ5Su3yA/pQ3A0BQ==
X-Received: by 2002:a05:6830:1502:: with SMTP id k2mr11650604otp.166.1614652683268;
        Mon, 01 Mar 2021 18:38:03 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1bb:8d29:39ef:5fe5])
        by smtp.gmail.com with ESMTPSA id a30sm100058oiy.42.2021.03.01.18.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:38:02 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 7/9] udp: implement udp_bpf_recvmsg() for sockmap
Date:   Mon,  1 Mar 2021 18:37:41 -0800
Message-Id: <20210302023743.24123-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

We have to implement udp_bpf_recvmsg() to replace the ->recvmsg()
to retrieve skmsg from ingress_msg.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/ipv4/udp_bpf.c | 64 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 595836088e85..9a37ba056575 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -4,6 +4,68 @@
 #include <linux/skmsg.h>
 #include <net/sock.h>
 #include <net/udp.h>
+#include <net/inet_common.h>
+
+#include "udp_impl.h"
+
+static struct proto *udpv6_prot_saved __read_mostly;
+
+static int sk_udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
+			  int noblock, int flags, int *addr_len)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family == AF_INET6)
+		return udpv6_prot_saved->recvmsg(sk, msg, len, noblock, flags,
+						 addr_len);
+#endif
+	return udp_prot.recvmsg(sk, msg, len, noblock, flags, addr_len);
+}
+
+static int udp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
+			   int nonblock, int flags, int *addr_len)
+{
+	struct sk_psock *psock;
+	int copied, ret;
+
+	if (unlikely(flags & MSG_ERRQUEUE))
+		return inet_recv_error(sk, msg, len, addr_len);
+
+	psock = sk_psock_get(sk);
+	if (unlikely(!psock))
+		return sk_udp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+
+	lock_sock(sk);
+	if (sk_psock_queue_empty(psock)) {
+		ret = sk_udp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+		goto out;
+	}
+
+msg_bytes_ready:
+	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
+	if (!copied) {
+		int data, err = 0;
+		long timeo;
+
+		timeo = sock_rcvtimeo(sk, nonblock);
+		data = sk_msg_wait_data(sk, psock, flags, timeo, &err);
+		if (data) {
+			if (!sk_psock_queue_empty(psock))
+				goto msg_bytes_ready;
+			ret = sk_udp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+			goto out;
+		}
+		if (err) {
+			ret = err;
+			goto out;
+		}
+		copied = -EAGAIN;
+	}
+	ret = copied;
+out:
+	release_sock(sk);
+	sk_psock_put(sk, psock);
+	return ret;
+}
 
 enum {
 	UDP_BPF_IPV4,
@@ -11,7 +73,6 @@ enum {
 	UDP_BPF_NUM_PROTS,
 };
 
-static struct proto *udpv6_prot_saved __read_mostly;
 static DEFINE_SPINLOCK(udpv6_prot_lock);
 static struct proto udp_bpf_prots[UDP_BPF_NUM_PROTS];
 
@@ -20,6 +81,7 @@ static void udp_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
 	*prot        = *base;
 	prot->unhash = sock_map_unhash;
 	prot->close  = sock_map_close;
+	prot->recvmsg = udp_bpf_recvmsg;
 }
 
 static void udp_bpf_check_v6_needs_rebuild(struct proto *ops)
-- 
2.25.1

