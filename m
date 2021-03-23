Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22118345408
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhCWAjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbhCWAic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 20:38:32 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F32C061574;
        Mon, 22 Mar 2021 17:38:31 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id 7so12707308qka.7;
        Mon, 22 Mar 2021 17:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ktDD3wFfhTgzuwFfQ6FhKlNOYR4srlqkDAegPxHtcbc=;
        b=gCwCuwwVAIPAWFdKIHS2cH/MCoVfPSeZ2Xm4SDOlgug6/RYQvtrN1A+kJOdOgLrYMR
         bbzOCzJXjjnFmlbj4MfqFSu805EGPGxg3AXSsh08pNgBEEFp1WyLBt8DQR9dSKSf9IK8
         OGwhq8duzfg3X13ADicjD1naoZR9Tw4r8JfPn34LnJUqyF0IzaPWeQfg6irwDeAvQdrB
         m2wG7ja4p9c+QqBk2/paCZgly63ieuUgNU7h4lcSX//dSasGlbihaRvs6nIVJ2RIFZA8
         7R1bLoNR87N3RFcHtfax263LoHZiRJrCqKq/lsHsLEdti4Gu1CWCEkMblrcE8RkIbyqn
         iXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktDD3wFfhTgzuwFfQ6FhKlNOYR4srlqkDAegPxHtcbc=;
        b=QF6DwdrYsOsXtpe5943lJ2yv7547SPbGePNA9yf5K8hCcLRuXbW8YCBHnhccIJuGmn
         GIbc6tfcoCSwGHWkNvQ7o878fQxAFItl4y0njWvCvLauRqpRwM09aE/1K4rPcu5XCAP/
         DN3isbt7R4YfGrq1BzLwluhFtGpQwTfrdfX+XHedA20WVSB99a56X/pb8Ngmnp2m/t9V
         EW+39krGz9ODdyolbP7ZHx/CSRTWzOF5wGxziTfaD+0B5SdBK573VYaAR5WiCAk+eNtb
         CFlFU8oBGV8J7bzHA+Fa8zijvpyl6WEvmmsco11Dq4ZRsQQwfgKBLC+vzxtretIT8Y4E
         eBCw==
X-Gm-Message-State: AOAM533/rD7agTILJIeLLb3o8m/zhUvHx2nDFFLgJJb1J0dPtTJDhyVT
        SbXl1b/e/Rnu/Io7VWAuBlbO1dYcd9hZfA==
X-Google-Smtp-Source: ABdhPJyyRtG+yM9dxcT/jUVWLrzuyV3mNODLgD9sq5sMhH/i3LIDYlMtmUaSCnt8twqNVwYrkAieUA==
X-Received: by 2002:a37:6312:: with SMTP id x18mr2844368qkb.193.1616459910944;
        Mon, 22 Mar 2021 17:38:30 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:fda6:6522:f108:7bd8])
        by smtp.gmail.com with ESMTPSA id 184sm12356403qki.97.2021.03.22.17.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 17:38:30 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v6 10/12] udp: implement udp_bpf_recvmsg() for sockmap
Date:   Mon, 22 Mar 2021 17:38:06 -0700
Message-Id: <20210323003808.16074-11-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
References: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
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

