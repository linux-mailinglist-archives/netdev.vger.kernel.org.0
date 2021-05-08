Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EDD37743D
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 00:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhEHWKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 18:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhEHWKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 18:10:13 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3158AC061574;
        Sat,  8 May 2021 15:09:10 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id l129so12078036qke.8;
        Sat, 08 May 2021 15:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JM9PvYADBYWyKEwwlSvfdrhaqUsWknbhdHFklgI2YqQ=;
        b=bZyvvHB+/aARPmvIVL3mD6EBz0wh8NFFDofXhMRXXKyTONMvdIWurCaobYlpeAA01W
         BUl4ZPjmfWNIkoIfTvixTenRyYfSwhobSIUGxTaZn3/fgketRhnAC/abNPryyOBpzwZo
         PpDkKzUzB3VQ2NrNQqYYTAQAaoYbEsOw2g7omz9oLvE2KPdJ52EadJaMZ1YBuP78rVak
         js5gOAxRKODb8YV9NtO34M4OB/j/yicIdHs74KQzRj2dmxqAbyjVUNbJ32Qjxb/Fs9vN
         OrBOPP4+1xkF6l5DVIf/wv6VWN1+kmFbvuHuK4EXVwPhJ/4SX6L3a0IXYNMFrJCJ0kRi
         c/bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JM9PvYADBYWyKEwwlSvfdrhaqUsWknbhdHFklgI2YqQ=;
        b=B2OYa2nsPCuV9QfeWTDC2fnFmv5w7fPkbsr5ox0MH9mlm7ya41AaSkE7eFtavegLgN
         pOcGe71WWT7CFT6yuBq0CYMAD1QC38IvKtsFDsvlA6hTJibq7xeFdq/zlniG6IWfto7R
         XsC8BI9AQcbRYm/PA++2zZkbLLJ+h8ccGGNQZ0eQyRMIIaEK6ChsQcYfOs94gT3NYcZy
         +lotdO13Q74rgkqZ16kH/R21VzBX+13lf7xTT7uCGcYUcXTrBFotMERpl3MTKVQrHuFx
         78RAzLkZWeN03vCWtnyiMMbTUQAUZWQfT4U0gclUrXLWi5RMiYAFC4h6lG3NeewaTxaU
         WoAA==
X-Gm-Message-State: AOAM532aPFeTQqrPBjtvCkgZPpjYJSL2CV0jRE8pB+8PsN/VziAiNgmU
        +vYNN4z/i1sSupQEfKtM5rLccUVsj+EKHA==
X-Google-Smtp-Source: ABdhPJxpsVRos5s5jOVIJNwraUr3rZd/7fWgZEY3TiWTzjJlcMRf3+OHR7mMeJvyLdZSto9tRYcA2A==
X-Received: by 2002:a37:5ca:: with SMTP id 193mr15843663qkf.356.1620511749299;
        Sat, 08 May 2021 15:09:09 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:65fe:be14:6eed:46f])
        by smtp.gmail.com with ESMTPSA id 189sm8080797qkd.51.2021.05.08.15.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 15:09:08 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 02/12] af_unix: implement ->read_sock() for sockmap
Date:   Sat,  8 May 2021 15:08:25 -0700
Message-Id: <20210508220835.53801-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
References: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
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
 net/unix/af_unix.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 5a31307ceb76..26d18f948737 100644
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
@@ -2183,6 +2186,38 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
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
+			break;
+		} else if (used <= skb->len) {
+			copied += used;
+		}
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

