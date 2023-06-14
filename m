Return-Path: <netdev+bounces-10682-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1AB272FC0F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 199FF280FCD
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 261298BEF;
	Wed, 14 Jun 2023 11:10:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9E579D5
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:10:30 +0000 (UTC)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1F91BF8;
	Wed, 14 Jun 2023 04:10:29 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-3f7368126a6so4440265e9.0;
        Wed, 14 Jun 2023 04:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686741027; x=1689333027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yc88muMtZ5aM3IzShu9BL/RZOvuDqFEnp6zrvGSRn1A=;
        b=lCGDgBpjVoHWjtVL+jFcdLuj6zQq44H9cEy/NwrKQEew8Okc5Z6Fcod9wDJpHkrlAQ
         06SPd67KDa0PirISrBgFnPFCFlZtCrEQ2pKpAN8cl5isSedqJlEtlCFFXUZmFAHSigcr
         8uSMIcaxyaAab2XbwmgEnLjOxgvCJ9CkWg9bJ6yd/eOVwM0BDOHDAx00o3GXAEQT+0Ii
         1IsMqRtcV8KuSrZ4g4uTzgyDsYwozl0348bg83wsj/HkfhWE19pmfYrx1oPcWhS793T2
         N/aWo8WZJGXZtgqHnX1gzCmkgbgTw95m9LsHvKgStRAgq5MisHs0RPm6kp5q36oxumaj
         1Faw==
X-Gm-Message-State: AC+VfDzIF7HQK1EIitcpL/zadnjCPRHnfu3IjiSrHdSFX96sFgkSYL0i
	IzKhpz0DZzhWomasRp0qm7BbajfjPt4W8w==
X-Google-Smtp-Source: ACHHUZ4k4bNVhAwwh4cWI5s0XnVNt2ZSgMEAItWI6KF3CDfDaNTq6g3yXmyXIxm5Jr2zHNeQlfIsMg==
X-Received: by 2002:a05:600c:364f:b0:3f6:d09:5d46 with SMTP id y15-20020a05600c364f00b003f60d095d46mr9656122wmq.20.1686741027064;
        Wed, 14 Jun 2023 04:10:27 -0700 (PDT)
Received: from localhost (fwdproxy-cln-020.fbsv.net. [2a03:2880:31ff:14::face:b00c])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c290a00b003f819dfa0ddsm9941676wmd.28.2023.06.14.04.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 04:10:26 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	David Ahern <dsahern@kernel.org>
Cc: leit@fb.com,
	asml.silence@gmail.com,
	matthieu.baerts@tessares.net,
	martineau@kernel.org,
	marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dccp@vger.kernel.org,
	mptcp@lists.linux.dev,
	linux-sctp@vger.kernel.org,
	ast@kernel.org,
	kuniyu@amazon.com,
	martin.lau@kernel.org
Subject: [RFC PATCH v2 4/4] net: add uring_cmd callback to raw "protocol"
Date: Wed, 14 Jun 2023 04:07:57 -0700
Message-Id: <20230614110757.3689731-5-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230614110757.3689731-1-leitao@debian.org>
References: <20230614110757.3689731-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is the implementation of uring_cmd for the raw "protocol". It
basically encompasses SOCKET_URING_OP_SIOCOUTQ and
SOCKET_URING_OP_SIOCINQ, which call raw_ioctl with SIOCOUTQ and SIOCINQ.

These two commands (SIOCOUTQ and SIOCINQ), are the only two commands
that are handled by raw_ioctl().

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/net/raw.h |  3 +++
 net/ipv4/raw.c    | 23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/net/raw.h b/include/net/raw.h
index 32a61481a253..5d5ec63274a8 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -96,4 +96,7 @@ static inline bool raw_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 #endif
 }
 
+int raw_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+		  unsigned int issue_flags);
+
 #endif	/* _RAW_H */
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 7782ff5e6539..31c3f9c41354 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -75,6 +75,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/compat.h>
 #include <linux/uio.h>
+#include <linux/io_uring.h>
 
 struct raw_frag_vec {
 	struct msghdr *msg;
@@ -885,6 +886,27 @@ static int raw_ioctl(struct sock *sk, int cmd, int *karg)
 	}
 }
 
+int raw_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
+		  unsigned int issue_flags)
+{
+	int ret;
+
+	switch (cmd->sqe->cmd_op) {
+	case SOCKET_URING_OP_SIOCINQ: {
+		if (raw_ioctl(sk, SIOCINQ, &ret))
+			return -EFAULT;
+		return ret;
+	}
+	case SOCKET_URING_OP_SIOCOUTQ:
+		if (raw_ioctl(sk, SIOCOUTQ, &ret))
+			return -EFAULT;
+		return ret;
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+EXPORT_SYMBOL_GPL(raw_uring_cmd);
+
 #ifdef CONFIG_COMPAT
 static int compat_raw_ioctl(struct sock *sk, unsigned int cmd, unsigned long arg)
 {
@@ -924,6 +946,7 @@ struct proto raw_prot = {
 	.connect	   = ip4_datagram_connect,
 	.disconnect	   = __udp_disconnect,
 	.ioctl		   = raw_ioctl,
+	.uring_cmd	   = raw_uring_cmd,
 	.init		   = raw_sk_init,
 	.setsockopt	   = raw_setsockopt,
 	.getsockopt	   = raw_getsockopt,
-- 
2.34.1


