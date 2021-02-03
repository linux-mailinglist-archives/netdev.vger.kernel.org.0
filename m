Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1905C30D284
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbhBCET5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbhBCES1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:18:27 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA5EC061797;
        Tue,  2 Feb 2021 20:17:10 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id d7so22161932otf.3;
        Tue, 02 Feb 2021 20:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FbcI6wt1YBzeWqrusTkpbaZfnU8cH2xe50gLcZjha8Y=;
        b=bTgpZ8EpJ+U6hBDnEOA1mhM+6MfCw0fSbK9KY39fKP6MA1CytaAePTJjaFfL2nBkU2
         +TmPYYU3yeWxWm/U2JfCk2zrDl+JHfIFKisv7oQXxFdALRcLiQ1rqoeqcFUstb06eCb2
         N/roDNssfhs33lO730uAnym3KqWZqACvrwJSSWataNBTMEwVc/Ff3szcNQkpxE8ERFdY
         C31QPsTmdd4IJwKCXn2OjFrI19fUH0j+6LXAvRJ/TAcEtl09ztHoQqfGD6fCZUdg01Oa
         vNXxZEwGpB4L1WwaXKfuyZu5gBoQJ8h1qzFib3gL+SxXvSVurgwX6vyYuZSk7YFK3TQK
         0TFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FbcI6wt1YBzeWqrusTkpbaZfnU8cH2xe50gLcZjha8Y=;
        b=eZGnXsqzuDOArdUdpaAB5zMNBzQa5mkJU9YtoK8T2VPM4VOplJ5hNlRBp/wsZn/hQg
         QYH9dYN46A1m1wqXx47LMEsHzcXMcflyEExS7bULxUZmteDORUrdIMWAi1sOARsMcbLp
         5fhGmFRPjB6YVZXZx+y8LAZEa4jRwVuhRJyH+rV4puuycU3oHuuo2CaGQuFAOKHHbqjR
         4Q8NJFHeXdzZ3WZS6bATuXEHukN2U6dxCo0sRZeeA+yYEUA7Rz8NkvM96Ky6G8ItUmTb
         3jOQUrtnRpwAOdJAvN9UUf5nDYpMfOZVnCzKc4WFXss/CiNyogRME/eD2tiJlMXjmhCn
         GqoA==
X-Gm-Message-State: AOAM532K5SXXEr/562ywzybQzK+MdwMDWybg7xMmO/bBLy1Lx0X/cz0I
        0wYyf1jVxG7I9G4KMyz/DzREyJV3tBBELQ==
X-Google-Smtp-Source: ABdhPJxzQ9wsLkDoFo4vhjLHrIA+8tYBqV99ZetqsvSJCXTrcFWw0ItPVRG9mIMxga/h5rlJzLfaIg==
X-Received: by 2002:a9d:6c85:: with SMTP id c5mr760176otr.300.1612325830009;
        Tue, 02 Feb 2021 20:17:10 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:17:09 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 11/19] af_unix: implement ->read_sock() for sockmap
Date:   Tue,  2 Feb 2021 20:16:28 -0800
Message-Id: <20210203041636.38555-12-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/unix/af_unix.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 4e1fa4ecbcfb..9315c4f4c27a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -662,6 +662,7 @@ static ssize_t unix_stream_splice_read(struct socket *,  loff_t *ppos,
 static int __unix_dgram_sendmsg(struct sock*, struct msghdr *, size_t);
 static int unix_dgram_sendmsg(struct socket *, struct msghdr *, size_t);
 static int unix_dgram_recvmsg(struct socket *, struct msghdr *, size_t, int);
+int unix_read_sock(struct sock *sk, read_descriptor_t *desc, sk_read_actor_t recv_actor);
 static int unix_dgram_connect(struct socket *, struct sockaddr *,
 			      int, int);
 static int unix_seqpacket_sendmsg(struct socket *, struct msghdr *, size_t);
@@ -739,6 +740,7 @@ static const struct proto_ops unix_dgram_ops = {
 	.listen =	sock_no_listen,
 	.shutdown =	unix_shutdown,
 	.sendmsg =	unix_dgram_sendmsg,
+	.read_sock =	unix_read_sock,
 	.sendmsg_locked = __unix_dgram_sendmsg,
 	.recvmsg =	unix_dgram_recvmsg,
 	.mmap =		sock_no_mmap,
@@ -2190,6 +2192,50 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 	return err;
 }
 
+int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
+		   sk_read_actor_t recv_actor)
+{
+	unsigned int flags = MSG_DONTWAIT;
+	struct unix_sock *u = unix_sk(sk);
+	struct sk_buff *skb;
+	int copied = 0;
+
+	while (1) {
+		int offset, err;
+
+		mutex_lock(&u->iolock);
+		skb = __skb_recv_datagram(sk, &sk->sk_receive_queue, flags,
+					  &offset, &err);
+		if (!skb) {
+			mutex_unlock(&u->iolock);
+			break;
+		}
+
+		if (offset < skb->len) {
+			int used;
+			size_t len;
+
+			len = skb->len - offset;
+			used = recv_actor(desc, skb, offset, len);
+			if (used <= 0) {
+				if (!copied)
+					copied = used;
+				mutex_unlock(&u->iolock);
+				break;
+			} else if (used <= len) {
+				copied += used;
+				offset += used;
+			}
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

