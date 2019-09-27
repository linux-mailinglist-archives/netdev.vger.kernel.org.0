Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28E5C09CA
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 18:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbfI0QpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 12:45:11 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39125 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfI0QpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 12:45:10 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so3942678wrj.6;
        Fri, 27 Sep 2019 09:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=og90qbQAXOicdq5w4qtLw6dYo5vnyUk8y6wc3hp/goU=;
        b=RcW3JOWX3CaxFUDNoQDHbdGdVcFVnBOj7k7rc3z1VvB6lT5ldwqAICaj7FIaWmmLBa
         E3822z+bFuwc702xgCM2HYqCKR9wEOFKHpYR/ZP6ZTdL2lvmPnI6k3K9hvJQgeRY5yTC
         yMA5u4+AINc1hPUvJkP6yjv18x6r1XpxWZsXDcsqcGsGVCWWGTGlWudM0Ti6KMQoXvQf
         gL6MmMMALNqvxqz0Gg5Uq0k7NSNR+drcdLv5LJSN5eVRCkmMN0XiKC29r7quWU2erzOe
         xfNdMTKgKJs89lS7tv4BTRQhubJS/UTaAzzDX+mXoZc7ZTyvy8uqF98Zryq8oEGAWHgN
         cVwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=og90qbQAXOicdq5w4qtLw6dYo5vnyUk8y6wc3hp/goU=;
        b=j2PElocYRW0Krd2xB3KV5FYDdDbGWQwsjohA8ivRvoxQ+yggRVCPJofldnYnErNlKp
         szWWV0UaFt3xyUTnJAaV/jJiEy/Vk7cpGGKnn58qn9wIxYoo+LeOdD1hgqEvz3G+2LOf
         V692jqoG6hu6c9gVKLwsr9ijI5mYazEeqs0XMmoVhjuauK00Fo5gW3/pn3kCAOhlN88F
         QiFXuXoPYfAM9igXfAr88Q6pV1vSWgfTYWm346tDJcmIbNmLmPXb1rBwBa38+jCZBl8V
         K1O1nRgD1qk5fAkQqBxnL5dRZ8d1H4nEPDjN3KDSshvG5I0LuHesz6zvwxmE3MTVSh4L
         5Bcg==
X-Gm-Message-State: APjAAAUot2x48quyhH/cfrtu7oVLcd3Rl/VLfaEhT2kg19fnM/EuEVyZ
        kEwigqDMOTHsAnqHlqZKxLk=
X-Google-Smtp-Source: APXvYqzB8omaq85cbWYuSm9buXKmXpapBFdkbhwBVUoZfj9O4XopENPYw/IDgrNoGyrxG2qggAUQdQ==
X-Received: by 2002:a1c:cb05:: with SMTP id b5mr7750360wmg.79.1569602706717;
        Fri, 27 Sep 2019 09:45:06 -0700 (PDT)
Received: from scw-93ddc8.cloud.online.net ([2001:bc8:4400:2400::302d])
        by smtp.googlemail.com with ESMTPSA id h125sm11889243wmf.31.2019.09.27.09.45.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 27 Sep 2019 09:45:05 -0700 (PDT)
From:   Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
To:     stefanha@redhat.com
Cc:     davem@davemloft.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, matiasevara@gmail.com,
        sgarzare@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH v2] vsock/virtio: add support for MSG_PEEK
Date:   Fri, 27 Sep 2019 16:44:23 +0000
Message-Id: <1569602663-16815-1-git-send-email-matiasevara@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569522214-28223-1-git-send-email-matiasevara@gmail.com>
References: <1569522214-28223-1-git-send-email-matiasevara@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for MSG_PEEK. In such a case, packets are not
removed from the rx_queue and credit updates are not sent.

Signed-off-by: Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
---
 net/vmw_vsock/virtio_transport_common.c | 55 +++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 94cc0fa..cf15751 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -264,6 +264,55 @@ static int virtio_transport_send_credit_update(struct vsock_sock *vsk,
 }
 
 static ssize_t
+virtio_transport_stream_do_peek(struct vsock_sock *vsk,
+				struct msghdr *msg,
+				size_t len)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct virtio_vsock_pkt *pkt;
+	size_t bytes, total = 0, off;
+	int err = -EFAULT;
+
+	spin_lock_bh(&vvs->rx_lock);
+
+	list_for_each_entry(pkt, &vvs->rx_queue, list) {
+		off = pkt->off;
+
+		if (total == len)
+			break;
+
+		while (total < len && off < pkt->len) {
+			bytes = len - total;
+			if (bytes > pkt->len - off)
+				bytes = pkt->len - off;
+
+			/* sk_lock is held by caller so no one else can dequeue.
+			 * Unlock rx_lock since memcpy_to_msg() may sleep.
+			 */
+			spin_unlock_bh(&vvs->rx_lock);
+
+			err = memcpy_to_msg(msg, pkt->buf + off, bytes);
+			if (err)
+				goto out;
+
+			spin_lock_bh(&vvs->rx_lock);
+
+			total += bytes;
+			off += bytes;
+		}
+	}
+
+	spin_unlock_bh(&vvs->rx_lock);
+
+	return total;
+
+out:
+	if (total)
+		err = total;
+	return err;
+}
+
+static ssize_t
 virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 				   struct msghdr *msg,
 				   size_t len)
@@ -330,9 +379,9 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
 				size_t len, int flags)
 {
 	if (flags & MSG_PEEK)
-		return -EOPNOTSUPP;
-
-	return virtio_transport_stream_do_dequeue(vsk, msg, len);
+		return virtio_transport_stream_do_peek(vsk, msg, len);
+	else
+		return virtio_transport_stream_do_dequeue(vsk, msg, len);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
 
-- 
2.7.4

