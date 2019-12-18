Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E7312412A
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfLRIMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:12:40 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38932 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfLRIMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:12:39 -0500
Received: by mail-pf1-f193.google.com with SMTP id q10so785008pfs.6
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 00:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l4iRoC8mesquwD3sEoRNvJ1v8/9g9MjPFjk/sxgFfMA=;
        b=IlDG0ZZJJb9Pre75/5vwSqRKxU36uV2qdhNrCIgYg0+qN3iLAGfMDkbTjtuW5+jltg
         3mhe0q+7NwJc5S6I3c0yELROqpXEKASD+ipm8oHRK1sm29n7HmjiOvfH13eemq3kxaLL
         KYN/kYl6QRQGLkvBZH6Sm4pX4bBokX851J1WkGp2D4OeQnQmoF1zMYdlyoTq5HDzz08A
         cRIaIv65+OtrQX13ZORr2MX9eihsWND+TRisW1Zb5OkEbI7U6kspQDXeuLyjMXYm0AG1
         MfP3AqaMo7cdHlbTQ9mqylMvawkjVJ4mzRwAnLj9VlfX6CgAJIv+/8dRN9WgOecftg1K
         tFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l4iRoC8mesquwD3sEoRNvJ1v8/9g9MjPFjk/sxgFfMA=;
        b=W0Tr8B4icEmi1twLsxKQ0qWfBvYd4/7fE/Cevfxp7CytmAZMtgvPnARbsyeOuekKUh
         +J3giMq7HsS7CasHKLGMMu4Nb49AImlyTa86rucaAUsKALRSm1Lu6iuK7paj3vsHboLo
         Kq6sRI5mdWycOLsIQSkOESghCLhyqSGa2cbF0dR4sfmqwYmq/dqdPfL2TuQhFRm5GMmY
         2gHH1ztYf5gUR8bslrSNMVO/8uhy8PebC3NErEfZBXktEPJmOp/AyDqtiDmB1OF4uyyM
         nspMtTLKCKVRpmIi9DMY0T7mGPt/aGyUa22iHY39VF4Hl29ZejYtDn2p6mSfSuJ7IbSA
         d/nA==
X-Gm-Message-State: APjAAAUbJ6JFHI2W4Ht/MmexSbja1kdX6ujm89eY1zyACyL/Y4Ib78Wg
        3yOobQ36fcANbRkMxXh8BwY=
X-Google-Smtp-Source: APXvYqzKWeuaPyKxCItmw3aEvfJ5aUD5LEO0GJkp0O15myJgAma26F+K5ir655Hbx4LIyBNoslxqMA==
X-Received: by 2002:a63:f24b:: with SMTP id d11mr1549784pgk.381.1576656759200;
        Wed, 18 Dec 2019 00:12:39 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s1sm1799181pgv.87.2019.12.18.00.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 00:12:38 -0800 (PST)
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
Subject: [RFC net-next 07/14] tuntap: check tun_msg_ctl type at necessary places
Date:   Wed, 18 Dec 2019 17:10:43 +0900
Message-Id: <20191218081050.10170-8-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
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

