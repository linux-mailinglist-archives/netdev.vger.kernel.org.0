Return-Path: <netdev+bounces-11757-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BF1D734512
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 08:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD6F71C20A85
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 06:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DD25139A;
	Sun, 18 Jun 2023 06:30:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEA31396
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 06:30:11 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703AC1719;
	Sat, 17 Jun 2023 23:30:06 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id 529DE5FD24;
	Sun, 18 Jun 2023 09:30:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1687069802;
	bh=4XeoB7uPdy2JNi6czfBT5EehboC5nIlTIqZ7j5KzL3A=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Aq8WrdxGMlS1oZqdbVFXPRwGxTmxyQZvKzGkLtBRjN8QJLa1ZSxUnqn+2tnPZN0Uv
	 P8UUJyNycKTAXUfHX9ba5Shg4Zcb1wfCcF0Qf1s45NE/QeGJ3On1Ql/WU2CPh8NbdZ
	 IQrwxjQ6Fix4/zHUJz5Ox/sOuO96pU1T8q/5ibBL3N+8HyaSt6B+Hb3ba8G8ZhtYmX
	 vmsrwKGxX/xTfn2vY1tWronMN3aOyKhzMpmTTwFVjz2+q2rJFKnXVl6MYdDt0teW5v
	 yYvF4trBxsgSro5y1+YYImgLOTuJGK2ZMafoGfnnW/7unfWbJqfCIMiu7L+8waB2qp
	 Jmazh8ElzIyJw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Sun, 18 Jun 2023 09:30:02 +0300 (MSK)
From: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@sberdevices.ru>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v1 1/4] virtio/vsock: rework MSG_PEEK for SOCK_STREAM
Date: Sun, 18 Jun 2023 09:24:48 +0300
Message-ID: <20230618062451.79980-2-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230618062451.79980-1-AVKrasnov@sberdevices.ru>
References: <20230618062451.79980-1-AVKrasnov@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/18 01:53:00 #21507494
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This reworks current implementation of MSG_PEEK logic:
1) Replaces 'skb_queue_walk_safe()' with 'skb_queue_walk()'. There is
   no need in the first one, as there are no removes of skb in loop.
2) Removes nested while loop - MSG_PEEK logic could be implemented
   without it: just iterate over skbs without removing it and copy
   data from each until destination buffer is not full.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 41 ++++++++++++-------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index b769fc258931..2ee40574c339 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -348,37 +348,34 @@ virtio_transport_stream_do_peek(struct vsock_sock *vsk,
 				size_t len)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
-	size_t bytes, total = 0, off;
-	struct sk_buff *skb, *tmp;
-	int err = -EFAULT;
+	struct sk_buff *skb;
+	size_t total = 0;
+	int err;
 
 	spin_lock_bh(&vvs->rx_lock);
 
-	skb_queue_walk_safe(&vvs->rx_queue, skb,  tmp) {
-		off = 0;
+	skb_queue_walk(&vvs->rx_queue, skb) {
+		size_t bytes;
 
-		if (total == len)
-			break;
+		bytes = len - total;
+		if (bytes > skb->len)
+			bytes = skb->len;
 
-		while (total < len && off < skb->len) {
-			bytes = len - total;
-			if (bytes > skb->len - off)
-				bytes = skb->len - off;
+		spin_unlock_bh(&vvs->rx_lock);
 
-			/* sk_lock is held by caller so no one else can dequeue.
-			 * Unlock rx_lock since memcpy_to_msg() may sleep.
-			 */
-			spin_unlock_bh(&vvs->rx_lock);
+		/* sk_lock is held by caller so no one else can dequeue.
+		 * Unlock rx_lock since memcpy_to_msg() may sleep.
+		 */
+		err = memcpy_to_msg(msg, skb->data, bytes);
+		if (err)
+			goto out;
 
-			err = memcpy_to_msg(msg, skb->data + off, bytes);
-			if (err)
-				goto out;
+		total += bytes;
 
-			spin_lock_bh(&vvs->rx_lock);
+		spin_lock_bh(&vvs->rx_lock);
 
-			total += bytes;
-			off += bytes;
-		}
+		if (total == len)
+			break;
 	}
 
 	spin_unlock_bh(&vvs->rx_lock);
-- 
2.25.1


