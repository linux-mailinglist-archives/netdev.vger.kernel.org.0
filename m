Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D36D34BEDB
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 22:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhC1UU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 16:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbhC1UUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 16:20:32 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3707EC061756;
        Sun, 28 Mar 2021 13:20:32 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id m13so11199560oiw.13;
        Sun, 28 Mar 2021 13:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ktDD3wFfhTgzuwFfQ6FhKlNOYR4srlqkDAegPxHtcbc=;
        b=AZvem2vjN6QCfupveqPPy/9VUQuH5BQmgmIA0KO2OqTkG/aGS8/Daa5U91lG5iZ24a
         D9d8IYHVUlsORcpJYnb7W5uKdeB/HPgOofOZepdo+opI0HTCuo5anESRk7lG1O/V+xSQ
         cHo2OwsFb1GXDysh1J3etX6FfTqBWyAodmsoCfM2Tn5RY1ngVWsARuTg/dSRCFhMwR9J
         YuluQaN/MmWuEVlc27TA5GiX6NdJovFfSgNGQfLHqYOJyrdvgWC5eM5e+HVY4JRbFnK7
         f2iiK1keKCAUrEqoNTADUjuZfTAfsO5gwUOZJngk0FVacKaA6nKeziGACN+511Nqqa2i
         p2bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktDD3wFfhTgzuwFfQ6FhKlNOYR4srlqkDAegPxHtcbc=;
        b=ulchueEyN1iwK8iGfoxzzYFy/gZX5dNTZ3fXOP0EJcRrWgHiv3bHPIBDZqiCnLxgDe
         BBBPGcYTkFeZGh/pJbcVZanjrpduRmXKDp5qjq7vFqNmBN5SRNmFOwak+NWSLTJ99Bpb
         3v3ANRTIApDcM4xTUV4TGfVVi+kXl9iLFtaOCNTY9OL8ETd6wTjpAWcqBbvpzNyrtqV/
         ibFb5Y5Y6q1A1u3LkCYmSaX9hZuTgEMlGnbX4T1wGkrkYx8C9mXHfk9np9K3dwRX/Cj0
         OMBYNUHTPEBsarDolPhejfLm1tlBEoGRJWUP+TBhz989subRlsS7RWzpQUiT+nBylfUQ
         5JvQ==
X-Gm-Message-State: AOAM532dHsG7MVEY8n3KLhgBQ1qjonqqVgYf5KH2XvFC+zpEBTAAiwxV
        3Kn70IQ1HzQaK+MDTRi9XXOrhDpOKES+Ug==
X-Google-Smtp-Source: ABdhPJxJ8GwEoVwRlGEvN5S0VR79hjXFo0Uyd6/fRJ05rF8+qL1Qf/buCMyJy3SJAKnGQFt874lw/w==
X-Received: by 2002:aca:b506:: with SMTP id e6mr16127413oif.70.1616962831531;
        Sun, 28 Mar 2021 13:20:31 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:bca7:4b69:be8f:21bb])
        by smtp.gmail.com with ESMTPSA id v30sm3898240otb.23.2021.03.28.13.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 13:20:31 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v7 11/13] udp: implement udp_bpf_recvmsg() for sockmap
Date:   Sun, 28 Mar 2021 13:20:11 -0700
Message-Id: <20210328202013.29223-12-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
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

