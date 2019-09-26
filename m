Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E837BBF91C
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbfIZSYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 14:24:01 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35802 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728344AbfIZSYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 14:24:01 -0400
Received: by mail-wm1-f67.google.com with SMTP id y21so3624667wmi.0;
        Thu, 26 Sep 2019 11:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wFzdQhWIvc4o013rKOjzXnkI0hw4CN3pNRalveb6WiY=;
        b=mlp9FZYjOcggNH5ah+Qu7XKJxpriLOVjPbYSJUxzDQE8StmLy/n03BoLkT0LvUWjja
         e5tEkQoSBIZSG+LRNf2ZwwauoeqWgj1ej4+saLQORMZ/cUaMprLri8l9hro+6lK48We2
         0X27RKQomTIS4EI7rP9ZRw7nbZ+DscF2TqUY3402NDsR3nJPeMC3M4qfEos7bSQ2fQMe
         kWBPIELUdz2FEmQWBzI7PUxGCMld6sqKBPWf/P7pQ3ybgW0mL3SItSsOMhlNGgBcjEkG
         dFxwGjUZKZy4cLc8687J0pjtKJCc3j0YNLzVrewtKir/+eC/FtcwTQ14mBa+63qhAkbS
         jGrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wFzdQhWIvc4o013rKOjzXnkI0hw4CN3pNRalveb6WiY=;
        b=lJi49zV9u6O2a35dDSJjO+/WNb+MqqNfhRFVNir54o4DsqfII9Za+dsFkwMY3/4o+j
         fKOIFpZIzw9MXyNJg+llCFlnVr1QsQOGcsnHahNkRu8Il0aCS83bErvtEO2KXmokX7Z7
         cFJE4k7wGHfuyyJE/TTi8W+SgnE3ahPKaHH77HMIc0pa1ZG/J3QwGkagFs0rlOq/cGBq
         o4+Fdnimznt/p8Nd6Miu7FBObfJd+HWznZaI9IvMlWXRBBdjnQax0pZwA4rC2I2Tyu0v
         gaI30CzOok7EtsjzMkn7A48NPyXL1EKGX8H/gyMCDIVMPcNzYj1L2yNTPKzCCJIOuveV
         A54g==
X-Gm-Message-State: APjAAAXNckww9Xl36peVe5YQnywWYTQ0f6VVkcs5l5KHBud85qGEkVM0
        qQ4mIM73C7Q7g0o+1UTGMbM=
X-Google-Smtp-Source: APXvYqy32luIXUjI1tWlLHkiv6GgGQPfBm9QTxPNQ0lhqDsuVqOaSF3mmVMHuM4QQNFD40ARFyIDag==
X-Received: by 2002:a7b:c10b:: with SMTP id w11mr3932165wmi.108.1569522238802;
        Thu, 26 Sep 2019 11:23:58 -0700 (PDT)
Received: from scw-93ddc8.cloud.online.net ([2001:bc8:4400:2400::302d])
        by smtp.googlemail.com with ESMTPSA id t13sm4890wra.70.2019.09.26.11.23.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 26 Sep 2019 11:23:57 -0700 (PDT)
From:   Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
To:     stefanha@redhat.com
Cc:     davem@davemloft.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, matiasevara@gmail.com,
        sgarzare@redhat.com
Subject: [PATCH] vsock/virtio: add support for MSG_PEEK
Date:   Thu, 26 Sep 2019 18:23:34 +0000
Message-Id: <1569522214-28223-1-git-send-email-matiasevara@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for MSG_PEEK. In such a case, packets are not
removed from the rx_queue and credit updates are not sent.

Signed-off-by: Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
---
 net/vmw_vsock/virtio_transport_common.c | 50 +++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 94cc0fa..938f2ed 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -264,6 +264,50 @@ static int virtio_transport_send_credit_update(struct vsock_sock *vsk,
 }
 
 static ssize_t
+virtio_transport_stream_do_peek(struct vsock_sock *vsk,
+				struct msghdr *msg,
+				size_t len)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct virtio_vsock_pkt *pkt;
+	size_t bytes, total = 0;
+	int err = -EFAULT;
+
+	spin_lock_bh(&vvs->rx_lock);
+
+	list_for_each_entry(pkt, &vvs->rx_queue, list) {
+		if (total == len)
+			break;
+
+		bytes = len - total;
+		if (bytes > pkt->len - pkt->off)
+			bytes = pkt->len - pkt->off;
+
+		/* sk_lock is held by caller so no one else can dequeue.
+		 * Unlock rx_lock since memcpy_to_msg() may sleep.
+		 */
+		spin_unlock_bh(&vvs->rx_lock);
+
+		err = memcpy_to_msg(msg, pkt->buf + pkt->off, bytes);
+		if (err)
+			goto out;
+
+		spin_lock_bh(&vvs->rx_lock);
+
+		total += bytes;
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
@@ -330,9 +374,9 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
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

