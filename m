Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E02FABA36B
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 19:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388179AbfIVRtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 13:49:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36284 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387763AbfIVRtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 13:49:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id y19so11501431wrd.3;
        Sun, 22 Sep 2019 10:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kgK/X3VpGqcc/rbAkUKNZHLXDiQ7XmfvEOywGehD8yU=;
        b=H+GyNtLHVe2ZakTKP/bsSjH0/Gi0i5izt5gM/rHOMVP3Dz0AeZ3BoVNcx+cWDuaIHB
         C1DIjU0MtLOqK2go/PhR5DahYAeV0IDOeFteazOG5RkWoFS55Qyi04nFqoSBRPiCF0Bf
         Xh8b8FJ6r3JM9xyPj4T9kQ2KeRKaxr8TiHerwHf+72ZvfT+Jvoy/4mE/P/Tymssc36db
         dA4K7kS3AxFw+7DpbD6tmK0ciS5NgtLT13nwj5bkqTD7NsrXPKeT+LBZAZ+VrlcNSM/t
         kzonjUt6xih7e5JDYUZC39tYY2AkC5C3ZBkRcMgB0aX9dJdRVRFbnbPf1gmDR0CNJCqU
         NIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kgK/X3VpGqcc/rbAkUKNZHLXDiQ7XmfvEOywGehD8yU=;
        b=FiqPdxhJt4kiuGHTRe1EukHeOp03SkirwHFt5lSQk4fNJaSvoU1ehSxtNz9ZDHh+Bz
         0/kbjy63mMh6XNgSkKWf/pmgZcl5oSQYS4bpLDgqzzm/IDbXGzEGayscZ7200EskBEnq
         LiJOiiuViTZ14NN5dnNSQ8a3HwMIJwSD4iwsZuQMwaFSMMUx4B2P5IG0qpP+Me23J6Fl
         9LjXfdj45NUEwogKMIHBqbnlOe2Arqfs1e+NfbYCPL9HIqSTQaDv5elxzNYZwbg3TiTB
         qHwMb7BuDoQyXuiWTOEcuSgsXwkK2CWjv05Bv1A7VbQsbKMoL+vy3nGJudre1CnOiSby
         C7Ow==
X-Gm-Message-State: APjAAAWYYpTgPB1qHReZzzT4smF9PBzycSTwBLK9T0HKh41QZlwnlWFw
        RJeBkgzX4Xn+IYP+vxoZK4c=
X-Google-Smtp-Source: APXvYqw4urp6Mlx9fYHi/K3lMzE3HWmXRgBADCilF3JF8mWnQnOwK/j7Ve01dELAQcd+cItgUx1feg==
X-Received: by 2002:a5d:678a:: with SMTP id v10mr18451194wru.145.1569174586586;
        Sun, 22 Sep 2019 10:49:46 -0700 (PDT)
Received: from scw-93ddc8.cloud.online.net ([2001:bc8:4400:2400::302d])
        by smtp.googlemail.com with ESMTPSA id t8sm8065763wrx.76.2019.09.22.10.49.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 22 Sep 2019 10:49:45 -0700 (PDT)
From:   Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
To:     stefanha@redhat.com
Cc:     davem@davemloft.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, matiasevara@gmail.com,
        sgarzare@redhat.com
Subject: [RFC] VSOCK: add support for MSG_PEEK
Date:   Sun, 22 Sep 2019 17:48:27 +0000
Message-Id: <1569174507-15267-1-git-send-email-matiasevara@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for MSG_PEEK. In such a case, packets are not
removed from the rx_queue and credit updates are not sent.

Signed-off-by: Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
---
 net/vmw_vsock/virtio_transport_common.c | 59 +++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 94cc0fa..830e890 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -264,6 +264,59 @@ static int virtio_transport_send_credit_update(struct vsock_sock *vsk,
 }
 
 static ssize_t
+virtio_transport_stream_do_peek(struct vsock_sock *vsk,
+				struct msghdr *msg,
+				size_t len)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct virtio_vsock_pkt *pkt;
+	size_t bytes, off = 0, total = 0;
+	int err = -EFAULT;
+
+	spin_lock_bh(&vvs->rx_lock);
+
+	if (list_empty(&vvs->rx_queue)) {
+		spin_unlock_bh(&vvs->rx_lock);
+		return 0;
+	}
+
+	pkt = list_first_entry(&vvs->rx_queue,
+			       struct virtio_vsock_pkt, list);
+	do {
+		bytes = len - total;
+		if (bytes > pkt->len - off)
+			bytes = pkt->len - off;
+
+		/* sk_lock is held by caller so no one else can dequeue.
+		 * Unlock rx_lock since memcpy_to_msg() may sleep.
+		 */
+		spin_unlock_bh(&vvs->rx_lock);
+
+		err = memcpy_to_msg(msg, pkt->buf + off, bytes);
+		if (err)
+			goto out;
+
+		spin_lock_bh(&vvs->rx_lock);
+
+		total += bytes;
+		off += bytes;
+		if (off == pkt->len) {
+			pkt = list_next_entry(pkt, list);
+			off = 0;
+		}
+	} while ((total < len) && !list_is_first(&pkt->list, &vvs->rx_queue));
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
@@ -330,9 +383,9 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
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

