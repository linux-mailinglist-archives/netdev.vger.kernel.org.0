Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F92B6EC1DF
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjDWTb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDWTb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:31:26 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4319E10DB;
        Sun, 23 Apr 2023 12:31:23 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 52CBD5FD0D;
        Sun, 23 Apr 2023 22:31:19 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1682278279;
        bh=B6LHD0ddTDQ3vaHpouYR+VjbT71Q46Di1RjaF1nYxV8=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=WsvAG0VQW75XxdmEQP9cn5KvjdEn2udS90X105MAb2RPeqUqbAaNs4/bGFh+7rlRl
         tvJUZ+yTDc+vzC5nxub9oDTOoK+/pcBcYnVlY6XIoAhDsX+af9GIFAz6z+lByxU8yH
         eGL5HyMZWWVwjdxx6VsF602YcAQNjg/XTcyOhbJx3YopQzEgW3mKCznQ6c+IU/SyDx
         aofbWaiuiFjUZlh3GUpJrDucSGzrVrb86Fi+oDz7A+SAIuWReWtpo9MeGxY/ZPAgh+
         bVQ3yoCrEWMJyjX8YtYBBt5HR2XXw8ZPutKa22jCz2jZWy1CfgkmpzUOdnfj+VR46R
         UWy3boLVXCK4A==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 23 Apr 2023 22:31:19 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v2 03/15] vsock/virtio: non-linear skb handling support
Date:   Sun, 23 Apr 2023 22:26:31 +0300
Message-ID: <20230423192643.1537470-4-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230423192643.1537470-1-AVKrasnov@sberdevices.ru>
References: <20230423192643.1537470-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/04/23 16:01:00 #21150277
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use pages of non-linear skb as buffers in virtio tx queue.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e95df847176b..1c269c3f010d 100644
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
@@ -111,12 +113,30 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 
 		virtio_transport_deliver_tap_pkt(skb);
 		reply = virtio_vsock_skb_reply(skb);
+		sg_init_one(&bufs[0], virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
+		sgs[out_sg++] = &bufs[0];
+
+		if (skb_is_nonlinear(skb)) {
+			int i;
+
+			for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+				struct page *data_page = skb_shinfo(skb)->frags[i].bv_page;
+
+				/* We will use 'page_to_virt()' for userspace page here,
+				 * because virtio layer will call 'virt_to_phys()' later
+				 * to fill buffer descriptor. We don't touch memory at
+				 * "virtual" address of this page.
+				 */
+				sg_init_one(&bufs[i + 1],
+					    page_to_virt(data_page), PAGE_SIZE);
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

