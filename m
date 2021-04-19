Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52E6364954
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 19:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240375AbhDSR5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 13:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233851AbhDSR5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 13:57:12 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FAEC061761;
        Mon, 19 Apr 2021 10:56:40 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id m6-20020a17090a8586b02901507e1acf0fso3492224pjn.3;
        Mon, 19 Apr 2021 10:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KoooA+wJKm09yw9keUKD9QS45BXENny998i7q2qmpKg=;
        b=Oo869W6qJhAtm8VZSiVH1nMLjI/1FlSXATRsf90ErCaqFUySsmS1rpLK8ASr0EzkVc
         xu4jzbqJxWOc0llPz38OUPbu669Lwb+0T7BwuDNnkOUcFoZ/lE/TIqdWzyMVj+kI1g8Y
         Q/uWPDyegd7DHk/WfILIDvjxiHn6p7tME0LjxaE3tUz60pojRaFbuN5abIZQ5HctyeOu
         0GdZRurIFBuUINxLSq0T2WxJ2yw2XxVJXw29iMuJpa6dIAuYNhYZ31qEkJ0gcGOK8Lo6
         ctEHJhqDynchldiecaFO1LzMxZhh67CDTTJfmpQDOEYY+Pd8kiidUiApAU4uoRaebkXB
         wuKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KoooA+wJKm09yw9keUKD9QS45BXENny998i7q2qmpKg=;
        b=DBXf/xqj7WMEqwDabHRXdZH6CiPvsrRPXzFktzUcRUVfBFFe5r3LJLyK9IRk1jIPAv
         2LTJymY1WEZIDxHOU+xsc+AyAsXAj/l96S3BsKK1yFGZSDh53lZs0YQZm6QVBGPPDFFJ
         KkhnqXleJPj8VMf6gzu55vi3pi3+Bcu8SYgYrFFspu0q4PO4ieVZcDI3Jn5KTV1nF+BS
         X1qBUwlkmj/rHvZtSXyOLNvhpzhJEUICaW/tN/pKKojeactNDq5jXMwn6QZBlCy7qsnM
         d8WoQLebW4eHL/6MhR1M0iBXC5CVwM+Lv/M689Z6mXgmBeRJSEHVyDUwRO5hJgyxnbbl
         p4iQ==
X-Gm-Message-State: AOAM532iGkuon2DhDzV4gn+F8nqJVZL+C8UEIMF0woata8H5ZqtOXWuX
        7vWoqv3PaJnKnxYS+wA+NUYtxnMqsa62uw==
X-Google-Smtp-Source: ABdhPJxpgcAprKCSKg+A7ecFr/ita/Sjx0mp8YXtDK7as3VRTW2Q/SPD9xth/yv2fi0ghqLDaudEPw==
X-Received: by 2002:a17:90b:188e:: with SMTP id mn14mr310886pjb.148.1618855000415;
        Mon, 19 Apr 2021 10:56:40 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:e9c9:f92c:88fa:755e])
        by smtp.gmail.com with ESMTPSA id g2sm119660pju.18.2021.04.19.10.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 10:56:40 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 1/9] af_unix: implement ->read_sock() for sockmap
Date:   Mon, 19 Apr 2021 10:55:55 -0700
Message-Id: <20210419175603.19378-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210419175603.19378-1-xiyou.wangcong@gmail.com>
References: <20210419175603.19378-1-xiyou.wangcong@gmail.com>
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
index 5a31307ceb76..966359b64a56 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -661,6 +661,7 @@ static ssize_t unix_stream_splice_read(struct socket *,  loff_t *ppos,
 				       unsigned int flags);
 static int unix_dgram_sendmsg(struct socket *, struct msghdr *, size_t);
 static int unix_dgram_recvmsg(struct socket *, struct msghdr *, size_t, int);
+int unix_read_sock(struct sock *sk, read_descriptor_t *desc, sk_read_actor_t recv_actor);
 static int unix_dgram_connect(struct socket *, struct sockaddr *,
 			      int, int);
 static int unix_seqpacket_sendmsg(struct socket *, struct msghdr *, size_t);
@@ -738,6 +739,7 @@ static const struct proto_ops unix_dgram_ops = {
 	.listen =	sock_no_listen,
 	.shutdown =	unix_shutdown,
 	.sendmsg =	unix_dgram_sendmsg,
+	.read_sock =	unix_read_sock,
 	.recvmsg =	unix_dgram_recvmsg,
 	.mmap =		sock_no_mmap,
 	.sendpage =	sock_no_sendpage,
@@ -2183,6 +2185,41 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 	return err;
 }
 
+int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
+		   sk_read_actor_t recv_actor)
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
+		if (!skb) {
+			mutex_unlock(&u->iolock);
+			return err;
+		}
+
+		used = recv_actor(desc, skb, 0, skb->len);
+		if (used <= 0) {
+			if (!copied)
+				copied = used;
+			mutex_unlock(&u->iolock);
+			break;
+		} else if (used <= skb->len) {
+			copied += used;
+		}
+		mutex_unlock(&u->iolock);
+
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
2.25.1

