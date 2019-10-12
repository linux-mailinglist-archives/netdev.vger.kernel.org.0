Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C10C4D4BF1
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 03:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbfJLByi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 21:54:38 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44887 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfJLByh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 21:54:37 -0400
Received: by mail-pf1-f195.google.com with SMTP id q21so7069980pfn.11;
        Fri, 11 Oct 2019 18:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h6RM8n/hu+J01s3SNVKgH78hp/SMvdzMYgpkm9Vlc0E=;
        b=Psj7J/Xdrx87uLc77BzjrgDpkUPccWetrIkFZW93JzYvCYb1wY3EQIuXyEGQf2XoZ5
         VWbbD3m4zz7iY7EXZ0V7FR6VWXX0N7/EAYwPjdEigFRR52DAc5TWAyxV9lwGBVbRytKQ
         3V+FUTg4NJnpqK0gUR6ti3cklY8zuV+zUnG7Pu7VFmGVMGMpFF6suFUlFpXeUX0c4TC/
         854p0MP4bC1ODOJKqcv5mzDgr/teGKMUJYh39+uA+ui6qebIgvuQBfkCt/3tdo71IW9s
         yAO9mXCT8fx+ZnNeWm0QkFx2cJdB0XzMf2gc3pPSZprP+XCXiT6NKn5t85hoJEuhMi81
         eK5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h6RM8n/hu+J01s3SNVKgH78hp/SMvdzMYgpkm9Vlc0E=;
        b=RX7kDauASOESQjJH83QVH6GxtUK1Kwp7BYLviN20ka7btnpRRo1zhnuHIpHjSmCM7c
         LMQzX1Ol/vo4zbdSWf2B/dVzhf9eGdEOWZpbEShLt0aSI/ocZ3PwA0PyH8ykW0NQWTTu
         X7oQWMBwzejviuG19XaknnxWNbsUrhhORIitiALz+o3uVpV248PecCx14sEy1W8wvcCK
         lnVrdu5425a3U1cJsSUTsfelxYw1beqUHpD4vG+Hwjgm0HCY6eAS0fbQoHBsNSthxn+u
         ttMLM8q0711kAZ6Jdf8ilOVDJdDhyPQB8r/a0L56m7iP+BY+xrtYmtcBB9wT4DXXSZTO
         xQCQ==
X-Gm-Message-State: APjAAAVn7OOyO2NvcAdh1MBZTJIxgTvilCF/lvh9DQM7EuMPYw37Sqal
        pcbVKahBfZg1iDgk5Vf17j1L6IgE
X-Google-Smtp-Source: APXvYqwzr4g9BpxV8IvNgAMPr4eoJ3NUv72g45jMas1+qQDBwpTTEv6qQRhPd7yL5zVM1vx636sy9w==
X-Received: by 2002:aa7:956a:: with SMTP id x10mr19835260pfq.114.1570845276837;
        Fri, 11 Oct 2019 18:54:36 -0700 (PDT)
Received: from localhost.localdomain (KD124211219252.ppp-bb.dion.ne.jp. [124.211.219.252])
        by smtp.gmail.com with ESMTPSA id e127sm10992187pfe.37.2019.10.11.18.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 18:54:36 -0700 (PDT)
From:   prashantbhole.linux@gmail.com
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        David Ahern <dsahern@gmail.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] tuntap: reorganize tun_msg_ctl usage
Date:   Sat, 12 Oct 2019 10:53:55 +0900
Message-Id: <20191012015357.1775-2-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191012015357.1775-1-prashantbhole.linux@gmail.com>
References: <20191012015357.1775-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Bhole <prashantbhole.linux@gmail.com>

In order to extend the usage of tun_msg_ctl structure, this patch
changes the member name from type to cmd. Also following definitions
are changed:
TUN_MSG_PTR : TUN_CMD_BATCH
TUN_MSG_UBUF: TUN_CMD_PACKET

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tap.c      | 9 ++++++---
 drivers/net/tun.c      | 8 ++++++--
 drivers/vhost/net.c    | 4 ++--
 include/linux/if_tun.h | 6 +++---
 4 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 3ae70c7e6860..01bd260ce60c 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1213,9 +1213,10 @@ static int tap_sendmsg(struct socket *sock, struct msghdr *m,
 	struct tap_queue *q = container_of(sock, struct tap_queue, sock);
 	struct tun_msg_ctl *ctl = m->msg_control;
 	struct xdp_buff *xdp;
+	void *ptr = NULL;
 	int i;
 
-	if (ctl && (ctl->type == TUN_MSG_PTR)) {
+	if (ctl && ctl->cmd == TUN_CMD_BATCH) {
 		for (i = 0; i < ctl->num; i++) {
 			xdp = &((struct xdp_buff *)ctl->ptr)[i];
 			tap_get_user_xdp(q, xdp);
@@ -1223,8 +1224,10 @@ static int tap_sendmsg(struct socket *sock, struct msghdr *m,
 		return 0;
 	}
 
-	return tap_get_user(q, ctl ? ctl->ptr : NULL, &m->msg_iter,
-			    m->msg_flags & MSG_DONTWAIT);
+	if (ctl && ctl->cmd == TUN_CMD_PACKET)
+		ptr = ctl->ptr;
+
+	return tap_get_user(q, ptr, &m->msg_iter, m->msg_flags & MSG_DONTWAIT);
 }
 
 static int tap_recvmsg(struct socket *sock, struct msghdr *m,
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 0413d182d782..29711671959b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2529,11 +2529,12 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	struct tun_struct *tun = tun_get(tfile);
 	struct tun_msg_ctl *ctl = m->msg_control;
 	struct xdp_buff *xdp;
+	void *ptr = NULL;
 
 	if (!tun)
 		return -EBADFD;
 
-	if (ctl && (ctl->type == TUN_MSG_PTR)) {
+	if (ctl && ctl->cmd == TUN_CMD_BATCH) {
 		struct tun_page tpage;
 		int n = ctl->num;
 		int flush = 0;
@@ -2560,7 +2561,10 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 		goto out;
 	}
 
-	ret = tun_get_user(tun, tfile, ctl ? ctl->ptr : NULL, &m->msg_iter,
+	if (ctl && ctl->cmd == TUN_CMD_PACKET)
+		ptr = ctl->ptr;
+
+	ret = tun_get_user(tun, tfile, ptr, &m->msg_iter,
 			   m->msg_flags & MSG_DONTWAIT,
 			   m->msg_flags & MSG_MORE);
 out:
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 1a2dd53caade..5946d2775bd0 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -462,7 +462,7 @@ static void vhost_tx_batch(struct vhost_net *net,
 			   struct msghdr *msghdr)
 {
 	struct tun_msg_ctl ctl = {
-		.type = TUN_MSG_PTR,
+		.cmd = TUN_CMD_BATCH,
 		.num = nvq->batched_xdp,
 		.ptr = nvq->xdp,
 	};
@@ -902,7 +902,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 			ubuf->desc = nvq->upend_idx;
 			refcount_set(&ubuf->refcnt, 1);
 			msg.msg_control = &ctl;
-			ctl.type = TUN_MSG_UBUF;
+			ctl.cmd = TUN_CMD_PACKET;
 			ctl.ptr = ubuf;
 			msg.msg_controllen = sizeof(ctl);
 			ubufs = nvq->ubufs;
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 5bda8cf457b6..bdfa671612db 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -11,10 +11,10 @@
 
 #define TUN_XDP_FLAG 0x1UL
 
-#define TUN_MSG_UBUF 1
-#define TUN_MSG_PTR  2
+#define TUN_CMD_PACKET 1
+#define TUN_CMD_BATCH  2
 struct tun_msg_ctl {
-	unsigned short type;
+	unsigned short cmd;
 	unsigned short num;
 	void *ptr;
 };
-- 
2.21.0

