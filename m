Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C60B33354D
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhCJFdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhCJFdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 00:33:03 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A75EC0613D8;
        Tue,  9 Mar 2021 21:32:46 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id a14so207734qvj.7;
        Tue, 09 Mar 2021 21:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ktDD3wFfhTgzuwFfQ6FhKlNOYR4srlqkDAegPxHtcbc=;
        b=Mwuqp8jAxSRewGz0Nhx/5Q27Jnmh5/nbrBu0LCcbFLPt6TuTFfZzHIOk9liph1hDvv
         HxT9D+3fVcOMMUAhAKktP/8udwzaSP4BSvUT7zOSsXwkZ+ndpUuDqNmznnLJLIwxDSep
         u3uGaXR43cvxIJb8cUTQ06TWLOib6CaeHj/E7Skt0RWmeKEciee/neg5lac+56dQC7P0
         Cmxd5im82MZfcTWUbhu02DyQj/4R+WtMHCeizYIkt0tSUJ2Js0TsQOkp7AmCeBEs3XLJ
         lBFeZ6sFbtBbaBrJATk9Knm7LiCBFTjwmc0OnFQ/XnnjMDz/R0xH9ry3y6GYni+2XwpT
         g0Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktDD3wFfhTgzuwFfQ6FhKlNOYR4srlqkDAegPxHtcbc=;
        b=ljoz3Lmh/rafaRobvUnqrfJ0WJMs54LFK8FgdxzEc5Kh/8gWt2ElGJOFdzmqAoNrKB
         GLENAubLmp+zE/jH2WEu8/tyEGlFIdVAwYzGhK3RjOcCeBX0+2bnf//LzNTw7bOrOaMj
         h4/QOPPv+NjSevYHARHH/7j0qAoPOIccgZHjQqUllN5Qs7g5SnM8TbOWp7YXk1oIyOvE
         jzZ9WFIzB1Lr8F5AYo6vmBmwkyweEyV/REpfCTs77Fxm5Q6j8bPBxdyv6jKZCJzZ28zi
         FO+WzGuKr6l0e/yNfzvRvyT/aP5LFVnyZB4GN8RvX9ZJv+x3VMUmTTwTDNDd3eA2cMOX
         9UxA==
X-Gm-Message-State: AOAM533O9yOqIPURVhzJFdTuk244Ha/Y14x3R4UiC/90iC3m3+zA6F4u
        blklvOwjcs6IxRFaEHvFEvy5+Y9fC9QpyQ==
X-Google-Smtp-Source: ABdhPJy+mD/2lqmcUL0ICTB3KBNOCOHNLRLF0mV3Eab57GGL2rszzju41nHL7neX8f42q7uMFdQJ1Q==
X-Received: by 2002:ad4:5ecc:: with SMTP id jm12mr1451922qvb.33.1615354365302;
        Tue, 09 Mar 2021 21:32:45 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:91f3:e7ef:7f61:a131])
        by smtp.gmail.com with ESMTPSA id g21sm12118739qkk.72.2021.03.09.21.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 21:32:44 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 09/11] udp: implement udp_bpf_recvmsg() for sockmap
Date:   Tue,  9 Mar 2021 21:32:20 -0800
Message-Id: <20210310053222.41371-10-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
References: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
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
index 6001f93cd3a0..7d5c4ebf42fe 100644
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

