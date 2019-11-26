Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397C1109BC8
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfKZKI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:08:58 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:43737 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727733AbfKZKI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:08:58 -0500
Received: by mail-pj1-f67.google.com with SMTP id a10so8054624pju.10;
        Tue, 26 Nov 2019 02:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V/KNFyebQK7C43tEw7YnjUgOQj/Np7ljq5WcxHdrR0c=;
        b=dzBZCOnaWE7Ha7XRUgoI1TMso7rPaEIgzx/qbfK80VCj2jnRcx784yIM+tcJz7c1W4
         SX24el6V4d3P89iqBPTFv2AmbDubMl9yoJqacCzuZhlnR3Bk050iQx1k6m6poXeq+bfl
         nCsgtrM1+U9l5Ye2fGXuufDnG0O2Gs/JqEuATOJ5p/18g7oqYF+NooT1+Mdardio8ul3
         GV1l4Qd/F5C3N0Vmi+3MI6zR9VuP0jtaYWvbvIgF8HfBcTH1gioMVf0mIhU757jNqbji
         SVXIEm14A7LiPCXAPyyVnHOhayKjwJrvX2PGeac7T9Z21XmzwuLidD9Nq6gJQVhxwP8a
         f/wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V/KNFyebQK7C43tEw7YnjUgOQj/Np7ljq5WcxHdrR0c=;
        b=cejOk3ja3NqpeZUH/u+SlJRMKpwPIHXVwmQq1KF9PusatRovsbKMK8rUCRUDcC3SwU
         qVkOYfqVgUuMNTZs9O2JKAh2AVHBeqzWqHyB9dGSRTXjIS2+3fj4Pm6bmg2AqsSjOXoM
         bR5/UOaAYpPVQOrAc+Kb1IQWuizcgIqBednAWgsouAlRPqVqkgUqeV8LpUtxX2kE45RS
         5qbnkNhKsY/w4vGreYly0CV3d9BPRVTi/VLCI3s6mPzt1o5Nj32qwhPgNFsVqnI6sOud
         T46fpG2dZZV0KVy6DJbhKj3po9JOl+zSsfXIN1qsDh74vrdn+QzfsGJrbgkrbK9/44sS
         +dUw==
X-Gm-Message-State: APjAAAXIatkt2pDVJG0p35ypysy1IlQeNz48wbzMpWDTdDXSt0vh6seD
        YIziqVcbolf0U71psjMWAQ0=
X-Google-Smtp-Source: APXvYqwzcOMViqGh/CDqZ6GTDBF1yWFhOG4mwf7CZlGyeqi/dlAtJKkC4MdApMy1ZQ7I10+ijRtVKw==
X-Received: by 2002:a17:90a:d58e:: with SMTP id v14mr5946678pju.142.1574762937533;
        Tue, 26 Nov 2019 02:08:57 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:08:57 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC net-next 04/18] tuntap: check tun_msg_ctl type at necessary places
Date:   Tue, 26 Nov 2019 19:07:30 +0900
Message-Id: <20191126100744.5083-5-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
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
index 3ae70c7e6860..4df7bf00af66 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1213,6 +1213,7 @@ static int tap_sendmsg(struct socket *sock, struct msghdr *m,
 	struct tap_queue *q = container_of(sock, struct tap_queue, sock);
 	struct tun_msg_ctl *ctl = m->msg_control;
 	struct xdp_buff *xdp;
+	void *ptr = NULL;
 	int i;
 
 	if (ctl && (ctl->type == TUN_MSG_PTR)) {
@@ -1223,8 +1224,10 @@ static int tap_sendmsg(struct socket *sock, struct msghdr *m,
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
2.20.1

