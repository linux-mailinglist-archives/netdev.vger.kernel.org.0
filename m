Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA743DAE3C
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 23:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhG2VYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 17:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbhG2VY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 17:24:26 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC90AC0613D3
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 14:24:22 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n10so8531671plf.4
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 14:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gB7YFrieIpmwVCmE7FizVML0zcWrHXYydeLPQdihUz4=;
        b=aEN3o4qhlxi3dIZxBQ43eTWGCPh7EmlV5ZH+6tV3nIocmZClxRaV6lLAdf5A7RUU5I
         8syfVFwSO5AZimhl6S6dlv74/PX0cTnbGHBT41NZs0MlEHaK08mpul5OMByI2Gtz22g4
         l/wz/Qi/spTgzaa2dLlCUQrqPtLMvo8RsXfjUnv8I2prJpyIIeA4mss2IHhaHKkqqn5u
         kegTxFxaffSbI8d1BQrxUhF1Z0f2QaMlguHWszVW8GwH7jOkeE2ED2W80uu/zWAtyVU9
         1gVmBAFglvrYFo73cSmMRMVjAS9CzNuzOK0aMzxwXBdOnAB0uygNR3e1meOvxy5+zd/q
         65ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gB7YFrieIpmwVCmE7FizVML0zcWrHXYydeLPQdihUz4=;
        b=IECEsCPtCrOEHyIH8ED8nDhNYJEBkE+6OMy77/qAJFvuQs6wru9wOKgP0ts+GkJ6dR
         Hie28pzjIv5jZOOuvPQY3yZj62QgfCENRKHa37JoFUTjCclooV/d7jpXLczmis+Rw3Wi
         nAMx5mzIN3f74Anuv8LVDjUsvQQsAxcztNtXeAuWehPZWCjryrnU730tZc38hEKnEo59
         qhOCfcn7pRbRuqB41yrzPtFaRa0sdyZ8dYfGMeb5LArvL4OBghCfhr0kTx6ZqdGXp+jK
         7duAyaUvSxnZVuXDoBExAeafoLToXexe78bU71jRarxwvGrcNDnNOhfYQoSzk0W7ELrT
         rkxg==
X-Gm-Message-State: AOAM532rdbh8pqMF0ZR9BznyXaUgLnF5Il3qfH7Gmfj9+LS+YjLrdjaG
        cVjRfYAzfNC8a3CpE6Hu3beQIVoh4rs3ow==
X-Google-Smtp-Source: ABdhPJyaxd0xyLTDqD9c7GdG+AM2kgCDouxXH3dXHAsz7fKd8O6Py86zt56jJLW5jKZGwwzkJCrV5g==
X-Received: by 2002:a17:90a:138f:: with SMTP id i15mr7373597pja.173.1627593862272;
        Thu, 29 Jul 2021 14:24:22 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id c15sm4686258pfl.181.2021.07.29.14.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 14:24:21 -0700 (PDT)
From:   Jiang Wang <jiang.wang@bytedance.com>
To:     netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, duanxiongchun@bytedance.com,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v2 1/5] af_unix: add read_sock for stream socket types
Date:   Thu, 29 Jul 2021 21:23:57 +0000
Message-Id: <20210729212402.1043211-2-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210729212402.1043211-1-jiang.wang@bytedance.com>
References: <20210729212402.1043211-1-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support sockmap for af_unix stream type, implement
read_sock, which is similar to the read_sock for unix
dgram sockets.

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
---
 net/unix/af_unix.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 89927678c..0ae3fc4c8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -672,6 +672,8 @@ static int unix_dgram_sendmsg(struct socket *, struct msghdr *, size_t);
 static int unix_dgram_recvmsg(struct socket *, struct msghdr *, size_t, int);
 static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
 			  sk_read_actor_t recv_actor);
+static int unix_stream_read_sock(struct sock *sk, read_descriptor_t *desc,
+				 sk_read_actor_t recv_actor);
 static int unix_dgram_connect(struct socket *, struct sockaddr *,
 			      int, int);
 static int unix_seqpacket_sendmsg(struct socket *, struct msghdr *, size_t);
@@ -725,6 +727,7 @@ static const struct proto_ops unix_stream_ops = {
 	.shutdown =	unix_shutdown,
 	.sendmsg =	unix_stream_sendmsg,
 	.recvmsg =	unix_stream_recvmsg,
+	.read_sock =	unix_stream_read_sock,
 	.mmap =		sock_no_mmap,
 	.sendpage =	unix_stream_sendpage,
 	.splice_read =	unix_stream_splice_read,
@@ -2311,6 +2314,15 @@ struct unix_stream_read_state {
 	unsigned int splice_flags;
 };
 
+static int unix_stream_read_sock(struct sock *sk, read_descriptor_t *desc,
+				 sk_read_actor_t recv_actor)
+{
+	if (unlikely(sk->sk_state != TCP_ESTABLISHED))
+		return -ENOTCONN;
+
+	return unix_read_sock(sk, desc, recv_actor);
+}
+
 static int unix_stream_read_generic(struct unix_stream_read_state *state,
 				    bool freezable)
 {
-- 
2.20.1

