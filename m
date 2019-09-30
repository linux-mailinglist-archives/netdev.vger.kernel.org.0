Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118F6C2857
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732650AbfI3VLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:11:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41505 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731678AbfI3VLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:11:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id h7so12939710wrw.8;
        Mon, 30 Sep 2019 14:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Km4VVTEePyhHsFimVMjuG3mAp67V52rIi2SimlK34MU=;
        b=F2+krCW9h4/vWnl412e0O5+BiYynOmqsu1GTfc8j8T1hPDRh/+RAH2TS+9oShSfFht
         +DRLSK6QkQUf/q9kVU0q0Wjwa/b7b9EPcbkMCthJ69y2UmK0Q9ohogmqOrjvF3Faovgn
         +c+DRShui0gK74MGaLgAd+Mf6ouSNMGaMZtUGB974GaAdsw7mHblL4mtYB9yIaygJ98L
         wHtVcQy0rnKX+4Eg8KQdFXrAf+QZ225nTNmyyTIW9Y+3Tcwls5KigSdvTnen9WScAozr
         V1YfI0PzPyhC3A2E1YaljJhKI3DQ0gqiXoBGXQvDawlO+2yHbso2owB0J6vnmQjBJ596
         HWuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Km4VVTEePyhHsFimVMjuG3mAp67V52rIi2SimlK34MU=;
        b=hdUmpW5NtPz1aEE3eSuI2QLkdaVczahFRDjXhBwb/rUkcdAtjXpRhYxiLPDgnwn2FI
         OU8hYZxAncPCf1OHFMAlrVAUT2D0ybUl3pacMk0W46ONaJ530s+eSJsSA+3+XA+oFWjN
         OYHupB1OOnD+iiojEt4elJI0EJvnKHLhY1UCCE3aGzz5jmOfIjFcZY/y3QXc2ta3nmMk
         5LO1AU4b1KsUz1WqpzwV87IalgNml3xqsI3sYO0JAcrSy6oM434tmvXDyyWGJoNRCyq1
         t3E+8nqCwJc6PkagwONvC8lSV29Zv91uTPsxLoglBBeKak4cP3sfMIYjkPsQ/UorVJJY
         sSFw==
X-Gm-Message-State: APjAAAVrPRZ4XK7Ii0ZU3Cvc68xKIanmjtwhWDx3lW/fE3JPCWxZC8w/
        43XhK0HOhE8S5cfYzpoIRLgteVmFj/Cm7Q==
X-Google-Smtp-Source: APXvYqzy7y5NjgWswAUhrWkzobKoCPCU2cj3zemHxu/pZIy6qbKJmrWtc0rOICC1+bZexktMTIyuxA==
X-Received: by 2002:a5d:4d8c:: with SMTP id b12mr14184701wru.198.1569867973583;
        Mon, 30 Sep 2019 11:26:13 -0700 (PDT)
Received: from scw-93ddc8.cloud.online.net ([2001:bc8:4400:2400::302d])
        by smtp.googlemail.com with ESMTPSA id r20sm15672256wrg.61.2019.09.30.11.26.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 30 Sep 2019 11:26:13 -0700 (PDT)
From:   Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
To:     stefanha@redhat.com
Cc:     davem@davemloft.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, matiasevara@gmail.com,
        sgarzare@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH net-next v2] vsock/virtio: add support for MSG_PEEK
Date:   Mon, 30 Sep 2019 18:25:23 +0000
Message-Id: <1569867923-28200-1-git-send-email-matiasevara@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for MSG_PEEK. In such a case, packets are not
removed from the rx_queue and credit updates are not sent.

Signed-off-by: Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Tested-by: Stefano Garzarella <sgarzare@redhat.com>
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

