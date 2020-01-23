Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 634BE14607F
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 02:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgAWBmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 20:42:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729019AbgAWBmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 20:42:21 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 903F02468A;
        Thu, 23 Jan 2020 01:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579743741;
        bh=U8ODLYj/sLyLWIq6KpacW6tlw57pEYxVZ7AXnwitXFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbClA1KP3XmNt0irt6qORORmC/f/kXMqTDzqGNk7hki+Ntw8kn4uhmceBL4zsy+4D
         z05yMpgEsvu86opgCS3GO0tvTVy1q18o/6/zqhUCDxkg0nzyWnmnzCVUmEnuAYflxV
         M1MAT8vDMcncktntNS//63NWqO3Hxq23qVd+UbZk=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jbrouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: [PATCH bpf-next 05/12] tuntap: check tun_msg_ctl type at necessary places
Date:   Wed, 22 Jan 2020 18:42:03 -0700
Message-Id: <20200123014210.38412-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200123014210.38412-1-dsahern@kernel.org>
References: <20200123014210.38412-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Bhole <prashantbhole.linux@gmail.com>

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
index 3a5a6c655dda..c3155bc3fc7f 100644
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
2.21.1 (Apple Git-122.3)

