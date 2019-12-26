Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA78512A9D0
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfLZCdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:33:43 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41126 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfLZCdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:33:43 -0500
Received: by mail-pg1-f194.google.com with SMTP id x8so12200616pgk.8
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 18:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l4iRoC8mesquwD3sEoRNvJ1v8/9g9MjPFjk/sxgFfMA=;
        b=ZYEm5tXCCc9cm9jLDtwRWif1EGwuxeH/TF69HcXC8kEguBSgwAmnOqZIgVJatwrx+N
         W3gw/3fse/IOP13Ckwu2zYyLhA64TM71M/zQjS+A+sIZWPechDNiSnNhDdAEu9Kag4Xn
         aQZErOHaYhZRUVp5wsR3qRcpSmU30PD4qDxj9++sWUjb9oAr7aRKiKkBaM9b+Y+WyOtu
         AxKiKfjJ7fcqXG6di2HzbB2kCtEW7kBIKQ1cS1m5zHTz2vG6Wea4oo7/PWgBEHzqR+UO
         fnGUCBHvlfyYt/TjFcCOqvK39eMAC8bU2CWgxSMJlI6sFfYAhRe5akeLZGMUsyU+W0gc
         w1Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l4iRoC8mesquwD3sEoRNvJ1v8/9g9MjPFjk/sxgFfMA=;
        b=nqOfBh7ZBa2fFmTUjyz9+rKTcltkHnwyBLhYbhoAMx6UV5UuUKo6DDO/SBVcxhbS0U
         QElhewzWgmNaSyPmiqOmRFp0uhHOc4tSA/90O6+WJii2FIsZcTfBcGrF0+sjhlM93zun
         a5woDYMn4lKmwUsSK2+gqSocJ5EKqAsg8vm/1GsL7YQgaEXZhNaLfhxctWtuEEwwspHU
         3EDVxc0r8d3kvR0lfhbjtEY/FxE7aLiF3GIkPYchtD0I+FsorsgnOnEOgPNsQP5TOWUJ
         7fslS9ICqT7ES1sQ1Ta18Iox7y6Ti58YKVAMOzw0SQ2d46R5ksYapmW5Hp55tFbht6SA
         CaiA==
X-Gm-Message-State: APjAAAUsol7TG0tGoOK8buLoxIdyH+ceTMMqzkGWj0s7gquG67d9cQpS
        2xRnziwGln/QxxHXNiRFCYc=
X-Google-Smtp-Source: APXvYqzJaf4MWQzoigjZj3TSg9ro9FUudWK41xRkjdibJLN+Z9FHe1tzTQ2H5sJIViggI0VSISG5rQ==
X-Received: by 2002:aa7:8d14:: with SMTP id j20mr31306754pfe.207.1577327622863;
        Wed, 25 Dec 2019 18:33:42 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id e6sm33865222pfh.32.2019.12.25.18.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:33:42 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
Subject: [RFC v2 net-next 08/12] tuntap: check tun_msg_ctl type at necessary places
Date:   Thu, 26 Dec 2019 11:31:56 +0900
Message-Id: <20191226023200.21389-9-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
References: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tun_msg_ctl is used by vhost_net to communicate with tuntap. We will
introduce another type in soon. As a preparation this patch adds
conditions to check tun_msg_ctl type at necessary places.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tap.c | 7 +++++--
 drivers/net/tun.c | 6 +++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index a6d63665ad03..a0a5dc18109a 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1203,6 +1203,7 @@ static int tap_sendmsg(struct socket *sock, struct msghdr *m,
 	struct tap_queue *q = container_of(sock, struct tap_queue, sock);
 	struct tun_msg_ctl *ctl = m->msg_control;
 	struct xdp_buff *xdp;
+	void *ptr = NULL;
 	int i;
 
 	if (ctl && (ctl->type == TUN_MSG_PTR)) {
@@ -1213,8 +1214,10 @@ static int tap_sendmsg(struct socket *sock, struct msghdr *m,
 		return 0;
 	}
 
-	return tap_get_user(q, ctl ? ctl->ptr : NULL, &m->msg_iter,
-			    m->msg_flags & MSG_DONTWAIT);
+	if (ctl && ctl->type == TUN_MSG_UBUF)
+		ptr = ctl->ptr;
+
+	return tap_get_user(q, ptr, &m->msg_iter, m->msg_flags & MSG_DONTWAIT);
 }
 
 static int tap_recvmsg(struct socket *sock, struct msghdr *m,
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 683d371e6e82..1e436d9ec4e1 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2529,6 +2529,7 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	struct tun_struct *tun = tun_get(tfile);
 	struct tun_msg_ctl *ctl = m->msg_control;
 	struct xdp_buff *xdp;
+	void *ptr = NULL;
 
 	if (!tun)
 		return -EBADFD;
@@ -2560,7 +2561,10 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 		goto out;
 	}
 
-	ret = tun_get_user(tun, tfile, ctl ? ctl->ptr : NULL, &m->msg_iter,
+	if (ctl && ctl->type == TUN_MSG_UBUF)
+		ptr = ctl->ptr;
+
+	ret = tun_get_user(tun, tfile, ptr, &m->msg_iter,
 			   m->msg_flags & MSG_DONTWAIT,
 			   m->msg_flags & MSG_MORE);
 out:
-- 
2.21.0

