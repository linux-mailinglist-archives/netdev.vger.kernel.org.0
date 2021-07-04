Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25183BAE81
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 21:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhGDTFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 15:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhGDTFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 15:05:45 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E423FC061574;
        Sun,  4 Jul 2021 12:03:09 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id i26-20020a4ad39a0000b02902554d87361cso656975oos.13;
        Sun, 04 Jul 2021 12:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5UmOKMh5dgxL1HLBssAaZn3gGMXVb1tDd0vNc1d9yPI=;
        b=roj4691soHgoJr1ImmrkAr1zKJNxJ35SzD5gUV+npCb2oxneab4p/svk+30mdYw1ZZ
         4O1smcLzwBOBl2IC8Pvv9YeopvzwESz61c9YvBEfAKAt5TPHxtrcspjpZzQXNB5gOqt0
         mkSpQWc3mGt6DaxTa1BUEMCOZOqGfrBURwLUyT8umJxox/PIeN+Uvv/GeVxs48wgl6CO
         nDffA1Z3xYpPwQolqglMULKJ5YJlFSZEQZc6vJW1nnCtDSlOukLmTlbNqwA0zQHCeLDz
         4nH/MShH0jvxJiNkRlzqMK8tQTIUn3UDjSLwzpijUx6SISAksOdAg8+RzfTj9Ax7nODR
         W87Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5UmOKMh5dgxL1HLBssAaZn3gGMXVb1tDd0vNc1d9yPI=;
        b=Q8BxfCTjqJMY3y5rXvPrc1kva1/FqWxtkqaVzWHikNR/mrV1mjuShNUW/5CcBToNNe
         j2dzh5hjtUtl/LcIjFG3ZO6Iw9v1fobv4kpimvMF5CGyWjDld89PjEDAezbPuzU8sXop
         vbyooj7YoXqKAEfIu4WrmKKbh4vnzJsguKtpulnvfqyAVg/FFxQQK8xwLFe3uZpSd0tb
         mZw6uboBT5EqvPE1XhToRKMkxTKhDmY8gfcKG/QP9jJqwhmkHLOvO+ZQQbhyGSodcmXy
         8cr7YSAIPyrj+9tqzPrHfHK/hPG9n6MhnB5eRws4784Z4DmjrgKOEVUCaTfgjzzM3R0u
         qxhg==
X-Gm-Message-State: AOAM533y1Roe5MG26Ugv+rBhpTtg6c8DAlpzFLFCVi0UQHisSmfGvf9Q
        Y9zioEwhcnzgyPMCfCtikc80EHNFleE=
X-Google-Smtp-Source: ABdhPJyA0vOCYD8zxF3CVqYyZcXdbs0wkU5PB300w377VWrCtxEQN7lGpzBYxKq7dxxs7qjU7KMKAQ==
X-Received: by 2002:a4a:cb88:: with SMTP id y8mr7814042ooq.8.1625425389180;
        Sun, 04 Jul 2021 12:03:09 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id 186sm1865848ooe.28.2021.07.04.12.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 12:03:08 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v5 03/11] af_unix: implement ->read_sock() for sockmap
Date:   Sun,  4 Jul 2021 12:02:44 -0700
Message-Id: <20210704190252.11866-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Implement ->read_sock() for AF_UNIX datagram socket, it is
pretty much similar to udp_read_sock().

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/unix/af_unix.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 23c92ad15c61..38863468768a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -669,6 +669,8 @@ static ssize_t unix_stream_splice_read(struct socket *,  loff_t *ppos,
 				       unsigned int flags);
 static int unix_dgram_sendmsg(struct socket *, struct msghdr *, size_t);
 static int unix_dgram_recvmsg(struct socket *, struct msghdr *, size_t, int);
+static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
+			  sk_read_actor_t recv_actor);
 static int unix_dgram_connect(struct socket *, struct sockaddr *,
 			      int, int);
 static int unix_seqpacket_sendmsg(struct socket *, struct msghdr *, size_t);
@@ -746,6 +748,7 @@ static const struct proto_ops unix_dgram_ops = {
 	.listen =	sock_no_listen,
 	.shutdown =	unix_shutdown,
 	.sendmsg =	unix_dgram_sendmsg,
+	.read_sock =	unix_read_sock,
 	.recvmsg =	unix_dgram_recvmsg,
 	.mmap =		sock_no_mmap,
 	.sendpage =	sock_no_sendpage,
@@ -2188,6 +2191,40 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 	return err;
 }
 
+static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
+			  sk_read_actor_t recv_actor)
+{
+	int copied = 0;
+
+	while (1) {
+		struct unix_sock *u = unix_sk(sk);
+		struct sk_buff *skb;
+		int used, err;
+
+		mutex_lock(&u->iolock);
+		skb = skb_recv_datagram(sk, 0, 1, &err);
+		mutex_unlock(&u->iolock);
+		if (!skb)
+			return err;
+
+		used = recv_actor(desc, skb, 0, skb->len);
+		if (used <= 0) {
+			if (!copied)
+				copied = used;
+			kfree_skb(skb);
+			break;
+		} else if (used <= skb->len) {
+			copied += used;
+		}
+
+		kfree_skb(skb);
+		if (!desc->count)
+			break;
+	}
+
+	return copied;
+}
+
 /*
  *	Sleep until more data has arrived. But check for races..
  */
-- 
2.27.0

