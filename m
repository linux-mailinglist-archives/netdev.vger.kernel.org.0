Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E24336AACD
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhDZCvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbhDZCu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:50:58 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A6BC061760;
        Sun, 25 Apr 2021 19:50:15 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id q4so12280179qtn.5;
        Sun, 25 Apr 2021 19:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qzD/xWdYKCAtAGq/PFWrbtTo6WB0A0cwxYkJe/1XiYo=;
        b=JwioIylIXCdnBwVwnOlwx9rTpEHy9ANtriYvilBZsbUJlP8rc1bi3rBf1+9zCS75Z5
         EcGotz5Nii6JAIsTQwHnVccuuPN17GSKOXn4JZq31KMeIDKx35HI7a+3xMauxfQnLYgX
         mECXBhIxTvu5Qk2wgn0YaQB4NPAyXjxNloVFY6uSiiXSwwiNrw41RdkifzJAX0I1gpEt
         k0g36VAYiYsfibOy96B7Qqv/a/3kceFBrcjiS3W1hUw0eWufB/VpVDkujzauYyAWiVtU
         9zK8vW1+kto7caocPcBBtcTsCkJ73QF+JoX3ie+OqHBPoyTbqigbMeyttlmqdmrMP94C
         pFCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qzD/xWdYKCAtAGq/PFWrbtTo6WB0A0cwxYkJe/1XiYo=;
        b=dZJ6bFUzNm2pzD1Z0dVb1RztKTY//X3K4NQluuLY3mCthDB5e1DAu3/qJtWH8jAmCc
         /7GsWqVKxE5HSholOktlbJFe7kEAFJo+ud3Cithd5A6RkrqZQI1PQkC15Th47G9w2VoK
         5mLlnjNs511H45kApuc9wl5aEXyWWDCQOXi+Xv4M4fDRFbqdkhsMhsT3GlCIi6oJPtjS
         ER8aW6Q6lKwLsFdowhrxVfM8Y7iPN8+YT6rDmSciSIUgyPMSefjUVLuaEHSSGlZUYufu
         Ntxj17tXU+WKDE8oLNrbJ9YWGR3ldqMP1wgy8reUjjOdgJ9BL48NJAfP7wD55R1OmsVP
         1Q6Q==
X-Gm-Message-State: AOAM530e5eX/ImIlSjaKjD3qYpMKyPR3Yq9uxgaNZtxemGcMI+FY8R1+
        jN0kIxHw/vr0rZzDBqTkvkLLt6j5/v1fRA==
X-Google-Smtp-Source: ABdhPJwzEnzIHVeMo0pKppHtgiNCufGwmU57hpySHw0P12rlwWG4ffPnpCS7byP4IB4SZiy/RILqoA==
X-Received: by 2002:ac8:6685:: with SMTP id d5mr14756078qtp.60.1619405414373;
        Sun, 25 Apr 2021 19:50:14 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:9050:63f8:875d:8edf])
        by smtp.gmail.com with ESMTPSA id e15sm9632969qkm.129.2021.04.25.19.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 19:50:14 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 02/10] af_unix: implement ->read_sock() for sockmap
Date:   Sun, 25 Apr 2021 19:49:53 -0700
Message-Id: <20210426025001.7899-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
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
 net/unix/af_unix.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 5a31307ceb76..f4dc22db371d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -661,6 +661,8 @@ static ssize_t unix_stream_splice_read(struct socket *,  loff_t *ppos,
 				       unsigned int flags);
 static int unix_dgram_sendmsg(struct socket *, struct msghdr *, size_t);
 static int unix_dgram_recvmsg(struct socket *, struct msghdr *, size_t, int);
+static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
+			  sk_read_actor_t recv_actor);
 static int unix_dgram_connect(struct socket *, struct sockaddr *,
 			      int, int);
 static int unix_seqpacket_sendmsg(struct socket *, struct msghdr *, size_t);
@@ -738,6 +740,7 @@ static const struct proto_ops unix_dgram_ops = {
 	.listen =	sock_no_listen,
 	.shutdown =	unix_shutdown,
 	.sendmsg =	unix_dgram_sendmsg,
+	.read_sock =	unix_read_sock,
 	.recvmsg =	unix_dgram_recvmsg,
 	.mmap =		sock_no_mmap,
 	.sendpage =	sock_no_sendpage,
@@ -2183,6 +2186,41 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
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

