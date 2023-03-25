Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77FF6C911D
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 23:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbjCYWHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 18:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCYWHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 18:07:11 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A117DCA35;
        Sat, 25 Mar 2023 15:07:09 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 05C275FD02;
        Sun, 26 Mar 2023 01:07:08 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679782028;
        bh=ezacvqrTrZ1zK6rRKTaH36dKk0Vzi7emuPTjIZNzoFM=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=DuQeudt3MAvpW1M2lRtTjKry7HZRz5L1nmTss8/klZTl9HhzkyuO8MJIqHCUvF534
         wBKRj5Gyjdcip/UGSrCKIG5X3i5b1NtLYZ6g66rRbVqQpRBkd7qGx03fJEQRNigRqF
         xbAAZfiCZn3VXIbg7k3fWUtKBzMQZyIvuaBiEh3sZepGKodqxXGZmX101w1/VVPGUb
         +LrOE9n5lpmrQ60ag22A8GQdGdtlZleiYS88M/u9bgofqka7/FUx92Z+XXi/jEeMIG
         UlygVlZ3y+igvRmyD/RghDde9PCM4dKLOkSCSO5z1lR5q1CO6f+ZryM9elg2p9unW4
         4sm+5AejDM/nQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 26 Mar 2023 01:07:07 +0300 (MSK)
Message-ID: <7d3e4515-a520-1ac3-f768-303566868a77@sberdevices.ru>
Date:   Sun, 26 Mar 2023 01:03:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <b0d15942-65ba-3a32-ba8d-fed64332d8f6@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
Subject: [PATCH net-next v5 1/2] virtio/vsock: allocate multiple skbuffs on tx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/25 18:14:00 #21009230
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds small optimization for tx path: instead of allocating single
skbuff on every call to transport, allocate multiple skbuff's until
credit space allows, thus trying to send as much as possible data without
return to af_vsock.c.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 57 +++++++++++++++++++------
 1 file changed, 43 insertions(+), 14 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 6564192e7f20..9e87c7d4d7cf 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -196,7 +196,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	const struct virtio_transport *t_ops;
 	struct virtio_vsock_sock *vvs;
 	u32 pkt_len = info->pkt_len;
-	struct sk_buff *skb;
+	u32 rest_len;
+	int ret;
 
 	info->type = virtio_transport_get_type(sk_vsock(vsk));
 
@@ -216,10 +217,6 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 
 	vvs = vsk->trans;
 
-	/* we can send less than pkt_len bytes */
-	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
-		pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
-
 	/* virtio_transport_get_credit might return less than pkt_len credit */
 	pkt_len = virtio_transport_get_credit(vvs, pkt_len);
 
@@ -227,17 +224,49 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
 		return pkt_len;
 
-	skb = virtio_transport_alloc_skb(info, pkt_len,
-					 src_cid, src_port,
-					 dst_cid, dst_port);
-	if (!skb) {
-		virtio_transport_put_credit(vvs, pkt_len);
-		return -ENOMEM;
-	}
+	rest_len = pkt_len;
+
+	do {
+		struct sk_buff *skb;
+		size_t skb_len;
+
+		skb_len = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE, rest_len);
+
+		skb = virtio_transport_alloc_skb(info, skb_len,
+						 src_cid, src_port,
+						 dst_cid, dst_port);
+		if (!skb) {
+			ret = -ENOMEM;
+			break;
+		}
 
-	virtio_transport_inc_tx_pkt(vvs, skb);
+		virtio_transport_inc_tx_pkt(vvs, skb);
 
-	return t_ops->send_pkt(skb);
+		ret = t_ops->send_pkt(skb);
+		if (ret < 0)
+			break;
+
+		/* Both virtio and vhost 'send_pkt()' returns 'skb_len',
+		 * but for reliability use 'ret' instead of 'skb_len'.
+		 * Also if partial send happens (e.g. 'ret' != 'skb_len')
+		 * somehow, we break this loop, but account such returned
+		 * value in 'virtio_transport_put_credit()'.
+		 */
+		rest_len -= ret;
+
+		if (WARN_ONCE(ret != skb_len,
+			      "'send_pkt()' returns %i, but %zu expected\n",
+			      ret, skb_len))
+			break;
+	} while (rest_len);
+
+	virtio_transport_put_credit(vvs, rest_len);
+
+	/* Return number of bytes, if any data has been sent. */
+	if (rest_len != pkt_len)
+		ret = pkt_len - rest_len;
+
+	return ret;
 }
 
 static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
-- 
2.25.1
