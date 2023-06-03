Return-Path: <netdev+bounces-7708-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0DD37212D8
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 22:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62D1B2819F7
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 20:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 399C6101D3;
	Sat,  3 Jun 2023 20:54:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AA5101C3
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 20:54:55 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A191B7;
	Sat,  3 Jun 2023 13:54:49 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id B18B55FD33;
	Sat,  3 Jun 2023 23:54:46 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1685825686;
	bh=12J3aUkd1001dQlCLmszH/Jlw+bRp81nuK6DQ+iFTnk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=OzeEQXlLUG5SLF1/btlSkjrBq7Gu1yg80/B6vqrl87g4u7MaLTpJaA5RHB0iNpE6e
	 6jMjrxTYvjBHo8xkTKp8dbedDsCpyZGSBMSCclSL/POgWCysWXX88ERx78+mBhyoaT
	 KB+A3amjimOeeAQPX9tV19GRNC4FzEAaNdpZjFNkOiiOWULHWn1x3P76q5GRGd7Hex
	 qwATekJY0ZJwGczQsqdREfumXHCxL9wpUgMczRSVbXp9CL5BDXYUsnd/rfnnpgL/d3
	 fQMJcz4y2sxpOtgLzlYda5qcZ4U0zFQnHN6B0i4zNTNA35ptEOiQYfoVU143e71lgQ
	 eKFsuvFBrfydA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Sat,  3 Jun 2023 23:54:46 +0300 (MSK)
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
Subject: [RFC PATCH v4 03/17] vsock/virtio: support to send non-linear skb
Date: Sat, 3 Jun 2023 23:49:25 +0300
Message-ID: <20230603204939.1598818-4-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/03 16:55:00 #21417531
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

For non-linear skb use its pages from fragment array as buffers in
virtio tx queue. These pages are already pinned by 'get_user_pages()'
during such skb creation.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport.c | 37 ++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e95df847176b..6053d8341091 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -100,7 +100,9 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 	vq = vsock->vqs[VSOCK_VQ_TX];
 
 	for (;;) {
-		struct scatterlist hdr, buf, *sgs[2];
+		/* +1 is for packet header. */
+		struct scatterlist *sgs[MAX_SKB_FRAGS + 1];
+		struct scatterlist bufs[MAX_SKB_FRAGS + 1];
 		int ret, in_sg = 0, out_sg = 0;
 		struct sk_buff *skb;
 		bool reply;
@@ -111,12 +113,35 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 
 		virtio_transport_deliver_tap_pkt(skb);
 		reply = virtio_vsock_skb_reply(skb);
+		sg_init_one(&bufs[0], virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
+		sgs[out_sg++] = &bufs[0];
+
+		if (skb_is_nonlinear(skb)) {
+			struct skb_shared_info *si;
+			int i;
+
+			si = skb_shinfo(skb);
+
+			for (i = 0; i < si->nr_frags; i++) {
+				skb_frag_t *skb_frag = &si->frags[i];
+				void *va = page_to_virt(skb_frag->bv_page);
+
+				/* We will use 'page_to_virt()' for userspace page here,
+				 * because virtio layer will call 'virt_to_phys()' later
+				 * to fill buffer descriptor. We don't touch memory at
+				 * "virtual" address of this page.
+				 */
+				sg_init_one(&bufs[i + 1],
+					    va + skb_frag->bv_offset,
+					    skb_frag->bv_len);
+				sgs[out_sg++] = &bufs[i + 1];
+			}
+		} else {
+			if (skb->len > 0) {
+				sg_init_one(&bufs[1], skb->data, skb->len);
+				sgs[out_sg++] = &bufs[1];
+			}
 
-		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
-		sgs[out_sg++] = &hdr;
-		if (skb->len > 0) {
-			sg_init_one(&buf, skb->data, skb->len);
-			sgs[out_sg++] = &buf;
 		}
 
 		ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
-- 
2.25.1


