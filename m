Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5410B6EC1DE
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjDWTbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjDWTb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:31:26 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D199CE5D;
        Sun, 23 Apr 2023 12:31:22 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 76FF95FD0F;
        Sun, 23 Apr 2023 22:31:19 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1682278279;
        bh=128uVYJJSNoHFD3kGZjfuSpswzUfi8bmAzZ5GBW0jlI=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=avki5sF9HFF3jZi/0aQea8KpgbSoH5UEWz/W5/c3O+fuiFMsdoFX0oLgSGnMwm050
         fHcKKs1S6q9nu8kYHYbUt2a9stGdqZr4VUDENZ8IcbYeZ+deDsOO6KhSIBqDqxq4J3
         cCEkYmgGDyzGAkLeli+LH0afWcB3FMDmG292rAYcGZ8fmrQ+BiXRt7dKabhuneG6O7
         ivSI/+IjtlGzBsyWRjyEQtVL5IQtyGkWzmxJENuioSPsGlIGhOKOi4rVw7+mppNiw1
         ZiXpiNBHW1FqysL3IYXutNppnyXPRlA9I2hvhMD5/fecckih6ib9AD8pqQ9TVpIHz3
         S3zwbbroUAA7g==
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
Subject: [RFC PATCH v2 04/15] vsock/virtio: non-linear skb handling for tap
Date:   Sun, 23 Apr 2023 22:26:32 +0300
Message-ID: <20230423192643.1537470-5-AVKrasnov@sberdevices.ru>
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

For tap device new skb is created and data from the current skb is
copied to it. This adds copying data from non-linear skb to new
the skb.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 31 ++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index b901017b9f92..280497d97076 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -101,6 +101,27 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
 	return NULL;
 }
 
+int virtio_transport_nl_skb_to_iov(struct sk_buff *skb,
+				   struct iov_iter *iov_iter,
+				   size_t len,
+				   bool peek);
+static void virtio_transport_copy_nonlinear_skb(struct sk_buff *skb,
+						void *dst,
+						size_t len)
+{
+	struct iov_iter iov_iter = { 0 };
+	struct iovec iovec;
+
+	iovec.iov_base = dst;
+	iovec.iov_len = len;
+
+	iov_iter.iter_type = ITER_IOVEC;
+	iov_iter.iov = &iovec;
+	iov_iter.nr_segs = 1;
+
+	virtio_transport_nl_skb_to_iov(skb, &iov_iter, len, false);
+}
+
 /* Packet capture */
 static struct sk_buff *virtio_transport_build_skb(void *opaque)
 {
@@ -109,7 +130,6 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
 	struct af_vsockmon_hdr *hdr;
 	struct sk_buff *skb;
 	size_t payload_len;
-	void *payload_buf;
 
 	/* A packet could be split to fit the RX buffer, so we can retrieve
 	 * the payload length from the header and the buffer pointer taking
@@ -117,7 +137,6 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
 	 */
 	pkt_hdr = virtio_vsock_hdr(pkt);
 	payload_len = pkt->len;
-	payload_buf = pkt->data;
 
 	skb = alloc_skb(sizeof(*hdr) + sizeof(*pkt_hdr) + payload_len,
 			GFP_ATOMIC);
@@ -160,7 +179,13 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
 	skb_put_data(skb, pkt_hdr, sizeof(*pkt_hdr));
 
 	if (payload_len) {
-		skb_put_data(skb, payload_buf, payload_len);
+		if (skb_is_nonlinear(pkt)) {
+			void *data = skb_put(skb, payload_len);
+
+			virtio_transport_copy_nonlinear_skb(pkt, data, payload_len);
+		} else {
+			skb_put_data(skb, pkt->data, payload_len);
+		}
 	}
 
 	return skb;
-- 
2.25.1

