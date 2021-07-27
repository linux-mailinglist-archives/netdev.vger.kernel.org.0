Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB003D6AD2
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 02:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbhGZXdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 19:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbhGZXdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 19:33:22 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46510C061765
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 17:13:50 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gv20-20020a17090b11d4b0290173b9578f1cso1410127pjb.0
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 17:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6v2cO07pZaqjXfgdg+SOPKEU9Efn8uqVDDElKkkvBL8=;
        b=IMqRiqtDaOhyQ7vgbqqpSVwSm9yU1bSfki5L0pKGwM90wqrvrJkjwoOE98PqEXB5Uf
         51+IIYX/GSxmwY3cXyuW1w2/6Ikjq816h46SWBtxSTQmbYdDmgJiymOzUd7uVEbFhM9N
         TTwkp8Hqw3qRvThYZWCumIXC1zaKgVFtrhxuU/oI1748IpyZn9+5gWAE8GVrwag8zwGH
         EBwC4Tnc4Iej3wjuLKq8DReSs/dI8PIcy8YyXSdj6Vvp+LycsbmcXx8emcU6BxFBjuRb
         9TCuYMOWZeKtpfC+pQITa0Am+FDsZAp0BkvWFugI6gVvRJ/Ew9TacznbNOaUMqP87UNG
         zWMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6v2cO07pZaqjXfgdg+SOPKEU9Efn8uqVDDElKkkvBL8=;
        b=p6BF/O1+jAdHmL8Se6OMGKZBCBkq7y5qG7ppJphGSnRiWIBhVJ3AJ3T88sQgO9Qp5d
         QjL04z+dhWope+siquOz2kk22jZy1nJ97Opcg0KMrnbY2UP/pEcF2rQEH6lpl9RmSULc
         auFLqkGt7QsLz0V7g1lRK9yb2We/3je8u+JwxMHiWOnweevDsoZfp4QGzDzbVVcXxpvt
         Svrpc3m/Xhq7qNVcNwp1cMvnYoqifO8bWmE6gdNcHpXVCLg/7QyFMSoUZ8+x0UW+AbSo
         JmSftS2XbCFAEjh4PbbU2DVdQRcJNIWZatfebJu23/LobXNSv7Hf0bvj+NF9xDVbX77Y
         sw2w==
X-Gm-Message-State: AOAM533VfBrmxRmp+svj7fqXiu8RZ36+wDVBtFUbNH2b6t28SGhNar5y
        OkAWB4G2WtyPixb6X7yiU1+geqZtj8+WLQ==
X-Google-Smtp-Source: ABdhPJy7v/+l+Q65PPCJv9H5V2CblYT0wQEcsMbsqcDd5CgMx18SLjs3xQkAUniZZJO4vk3IoDfXuw==
X-Received: by 2002:a63:e841:: with SMTP id a1mr20737703pgk.197.1627344829709;
        Mon, 26 Jul 2021 17:13:49 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id k1sm1079452pga.70.2021.07.26.17.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 17:13:49 -0700 (PDT)
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
Subject: [PATCH bpf-next v1 1/5] af_unix: add read_sock for stream socket types
Date:   Tue, 27 Jul 2021 00:12:48 +0000
Message-Id: <20210727001252.1287673-2-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210727001252.1287673-1-jiang.wang@bytedance.com>
References: <20210727001252.1287673-1-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support sockmap for af_unix stream type, implement
read_sock, which is similar to the read_sock for unix
dgram sockets.

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>.
---
 net/unix/af_unix.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 89927678c..32eeb4a6a 100644
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
+		return -EINVAL;
+
+	return unix_read_sock(sk, desc, recv_actor);
+}
+
 static int unix_stream_read_generic(struct unix_stream_read_state *state,
 				    bool freezable)
 {
-- 
2.20.1

