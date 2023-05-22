Return-Path: <netdev+bounces-4154-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F366E70B6C5
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:45:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE9C11C209C1
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 07:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6504863DF;
	Mon, 22 May 2023 07:44:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563BB63D7
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:44:49 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6CBAC;
	Mon, 22 May 2023 00:44:47 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id 9F45B5FD4A;
	Mon, 22 May 2023 10:44:44 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1684741484;
	bh=igltWeKmorgVWzwhU5OIAduVRvDTNdsf6zEVkCG3inE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Z61DpywJ0aT4k7vpr4q4nrwqmpD6kiZ2SfnxKz+zTSGjz8n1yOYZVCaCymWCYnu0I
	 tk/sZtUpfdgvkalLW3u+ICAbImUVU7OCm/VDJsgUSoul2+wv5LyYsMJYD2YKj1AqsL
	 IZflFp3NnZNy8FOQ1PT7O565J8E/eigwsSi6Au/k/TZHTQws9IvO0Sk7QXGgHFE/1i
	 9XQ8f0ccExKrj7cQqYEMRYVALE0fOkxhctC0gccM8DeSxud/WieJ1Fx7zp8NJcLVF5
	 C2v22Amx8X0YiR7MtEg9tzQvMMnw/2WDvzQM8AR1CDs7q0cJFzv6w/eKJBSET2HKtu
	 fhu1eC0hUsiyQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Mon, 22 May 2023 10:44:44 +0300 (MSK)
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
Subject: [RFC PATCH v3 02/17] vhost/vsock: read data from non-linear skb
Date: Mon, 22 May 2023 10:39:35 +0300
Message-ID: <20230522073950.3574171-3-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
References: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/05/22 04:49:00 #21364689
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This adds copying to guest's virtio buffers from non-linear skbs. Such
skbs are created by protocol layer when MSG_ZEROCOPY flags is used. It
changes call of 'copy_to_iter()' to 'skb_copy_datagram_iter()'. Second
function can read data from non-linear skb.

See commit to 'net/vmw_vsock/virtio_transport_common.c' with the same
name for more details.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 drivers/vhost/vsock.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 6578db78f0ae..b254aa4b756a 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -156,7 +156,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		}
 
 		iov_iter_init(&iov_iter, ITER_DEST, &vq->iov[out], in, iov_len);
-		payload_len = skb->len;
+		payload_len = skb->len - VIRTIO_VSOCK_SKB_CB(skb)->frag_off;
 		hdr = virtio_vsock_hdr(skb);
 
 		/* If the packet is greater than the space available in the
@@ -197,8 +197,10 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			break;
 		}
 
-		nbytes = copy_to_iter(skb->data, payload_len, &iov_iter);
-		if (nbytes != payload_len) {
+		if (skb_copy_datagram_iter(skb,
+					   VIRTIO_VSOCK_SKB_CB(skb)->frag_off,
+					   &iov_iter,
+					   payload_len)) {
 			kfree_skb(skb);
 			vq_err(vq, "Faulted on copying pkt buf\n");
 			break;
@@ -212,13 +214,13 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		vhost_add_used(vq, head, sizeof(*hdr) + payload_len);
 		added = true;
 
-		skb_pull(skb, payload_len);
+		VIRTIO_VSOCK_SKB_CB(skb)->frag_off += payload_len;
 		total_len += payload_len;
 
 		/* If we didn't send all the payload we can requeue the packet
 		 * to send it with the next available buffer.
 		 */
-		if (skb->len > 0) {
+		if (VIRTIO_VSOCK_SKB_CB(skb)->frag_off < skb->len) {
 			hdr->flags |= cpu_to_le32(flags_to_restore);
 
 			/* We are queueing the same skb to handle
-- 
2.25.1


