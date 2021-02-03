Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1247530D290
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbhBCEUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbhBCES4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:18:56 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EC8C0617AB;
        Tue,  2 Feb 2021 20:17:16 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id z36so5707810ooi.6;
        Tue, 02 Feb 2021 20:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qGgIBOZxfhj4RQXaRAJW/z/oxERFBXXb52q9pb05GWg=;
        b=ktAWrgMwRW/oX/JdYmeAPZuH2HFw7cuWSH4dOAlO7VW8gFmpW+kaA/GT+ySqF7FfI+
         P90ifZbOQIdsDr+1cMVlOnFTHRBKzGU0WoB31s+LW3O9Z6jaUK305UZ4xvDi9gMG9gt4
         IWgfx8fnOoF9ztmE2oSynaNmzxJWT3r+xVH0RoSIiK/S2MCGU3jkqX8wtj1NStIyIUOC
         bxvSGW09PiGA0eoB2FV7jw2yKTT3srNMoeKvuTnLtoS8Z1dnfeW5rQPKFRQSJZdqIpQL
         ylnuwHdHqP2LHfGMzVFIJXromVHNRyp4It9KONBshrPFB0UOwtYqwTCHQj9Nkf3bHy4Y
         PLqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qGgIBOZxfhj4RQXaRAJW/z/oxERFBXXb52q9pb05GWg=;
        b=UYz1AwaeAwgp9JcoSsYkcNCYfnyOCTQkY317QCWYlieO0ZSelm1H48/wQnR1oisrrV
         74jhy5cDTTM/+YKHM6LVvSltyHTg2EMO6PLL8wluSqJ/UEUs9kfxH+w5MAYBQi0Ti08M
         Z9uTZaU2VS1PLB3AfUTPjKAlpHuRpiG42f8Oo3IygeWzS17OMLduoS/BKzfhqnQ8rJ7D
         dDLks7kh32zT641UvS4Jr5SJmSq/XPhjF78UZ11uwFugHtZnElPdAA7DLbggcjaMpcNL
         SPnGQUtkC1/CaMOQE6bCmJq9J69rIGSMTFaQK5R283Ck2OYAEhhdsnxPcEc/GvsRQteB
         U0BA==
X-Gm-Message-State: AOAM533yC4zykTZaY3/hAojVk7y2hrTK48WVriC50nKC4w3JLpB8+Css
        H7vL+ryQVF7jHGnls6hvRmLuKFrSDsm0YQ==
X-Google-Smtp-Source: ABdhPJzau0g7y3LgHF18hGPSqwt1wkCbsH3h2Tu/zVHKYAhvMRvHiRS0Ytu5Dp4X33E+nyRYNNiUKA==
X-Received: by 2002:a4a:870c:: with SMTP id z12mr802907ooh.15.1612325836069;
        Tue, 02 Feb 2021 20:17:16 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:17:15 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 15/19] udp: implement udp_bpf_recvmsg() for sockmap
Date:   Tue,  2 Feb 2021 20:16:32 -0800
Message-Id: <20210203041636.38555-16-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
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

