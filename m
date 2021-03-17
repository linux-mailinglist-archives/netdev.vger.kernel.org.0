Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8450533E6C0
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhCQCXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhCQCW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:22:56 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7C5C061764;
        Tue, 16 Mar 2021 19:22:56 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id l23-20020a05683004b7b02901b529d1a2fdso379339otd.8;
        Tue, 16 Mar 2021 19:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ktDD3wFfhTgzuwFfQ6FhKlNOYR4srlqkDAegPxHtcbc=;
        b=Uzcp4HXGcHn/bcqT6kqjIX2MkF/NezvkMu4M2OXJK2fJQXQB/SDa74hzf0s8UqUAZg
         QBiLrRu1jbJzMOwivNstzebEMPszsQKk57GrQq6RUvPmIKB/kIeAvkgQr/dcWuWcDzEX
         cdrfe+GOF9Uvc/pK2bLamgmOBR8TnL2z4AI7Dwf/Gpjt49z4+RiSkhUJkUeq4POi50SL
         LH/1RNYmqSlZVO88A1idZmXyr4+NNbFLDAHM/bzknsy5Qk9f7Wb50CZSSrCNfUqarAgR
         QTizbmDfNLVWZrlPACot9aAws/WJADDFqMby6B/TgKb61DOXHa+Nae285N1woP8pEEjD
         zy+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktDD3wFfhTgzuwFfQ6FhKlNOYR4srlqkDAegPxHtcbc=;
        b=HG6SggQMMZb+ACISOi55PPdHfOpGWMuml70XxHCtfaoZ4Htnjo78wM0G1HZsODh6em
         TbOiWXI1Sr0BF8v59x+1hEmvxnFqdedmgptHfwWD11YkxyYoLE1GDHkMUj3J+XWKR7mb
         5VaSmJGVVLspbGVUabWZQ1xMb09ngvquKko5RTRupqdTbqyIm0YRGlyttMtZ1q7u1UUX
         9dN20ODzV6zI5/A+zIm6gky0UblnUBhLATQN87jEF8kTM7/fQleI77KIy/ncnHDhP3qK
         J9vd8dj2Cx1g04dG7bDEji7TXb46dfQysXtKaLdXktMZZ4aDkHirFm5WHlnnp2fxz6kh
         Jc/A==
X-Gm-Message-State: AOAM533eMbH4xrVSWU/DEGolvdj/5SnaFH4sdgBgk3AzSG+J1wux2Rpu
        d9uLIi9UDYpX4LiUBuJb1bNlJk5FoYwqZg==
X-Google-Smtp-Source: ABdhPJxuodxdrrlUcAx0LXxwnpnst6CPOJr0/9XkY/83EfbV+319NtSVxGycAi068lFg3X4CqBWXIQ==
X-Received: by 2002:a05:6830:558:: with SMTP id l24mr1470704otb.209.1615947775405;
        Tue, 16 Mar 2021 19:22:55 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:517b:5634:5d8e:ff09])
        by smtp.gmail.com with ESMTPSA id i3sm8037858oov.2.2021.03.16.19.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 19:22:55 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v5 09/11] udp: implement udp_bpf_recvmsg() for sockmap
Date:   Tue, 16 Mar 2021 19:22:17 -0700
Message-Id: <20210317022219.24934-10-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
References: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
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

