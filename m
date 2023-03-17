Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF11E6BE708
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 11:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjCQKl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 06:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjCQKl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 06:41:58 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF6AFF04;
        Fri, 17 Mar 2023 03:41:56 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 92D475FD3D;
        Fri, 17 Mar 2023 13:41:54 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679049714;
        bh=ud9QwJyCxtRqhWwZzbGgqbYviVFkVybpiPswGzZYdEM=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=h4o6yqyn9pPRCyd9OOy6k0ZJrWdJDF1BLWZkoRdcB0r3qI4IQ2GwNpuPHQDfinJpk
         1YrmML4bC/fYU1Fg9IKp3pPpakMXkcGgEbJQD4oDBmyM+O6geuDnj6HUeAS/LqmbPZ
         5x4N1+nmNBhupfteEUE9NH4UIIFUo/LWacSQ90gtZOJwwyoMAFikjp1eQHQ7L7NXep
         KYvO/H9fjXk2r1ITjUJpp+AAlGpW+1i1kk/CoOz2SP09nXU0d2kDA+s/MVUl7fIXhE
         1LmQate+tX3dJjW0GMT6dNwrVjFLX/AzMuVmvhy679Trx1MQMAnus7X1XA6FF0ngj7
         kZj9wGVNpnyHg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Fri, 17 Mar 2023 13:41:54 +0300 (MSK)
Message-ID: <2c52aa26-8181-d37a-bccd-a86bd3cbc6e1@sberdevices.ru>
Date:   Fri, 17 Mar 2023 13:38:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
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
Subject: [RFC PATCH v1] virtio/vsock: allocate multiple skbuffs on tx
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/17 09:15:00 #20959649
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds small optimization for tx path: instead of allocating single
skbuff on every call to transport, allocate multiple skbuffs until
credit space allows, thus trying to send as much as possible data without
return to af_vsock.c.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 45 +++++++++++++++++--------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 6564192e7f20..cda587196475 100644
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
 
@@ -227,17 +224,37 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
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
 
-	virtio_transport_inc_tx_pkt(vvs, skb);
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
+			goto out;
+		}
 
-	return t_ops->send_pkt(skb);
+		virtio_transport_inc_tx_pkt(vvs, skb);
+
+		ret = t_ops->send_pkt(skb);
+
+		if (ret < 0)
+			goto out;
+
+		rest_len -= skb_len;
+	} while (rest_len);
+
+	return pkt_len;
+
+out:
+	virtio_transport_put_credit(vvs, rest_len);
+	return ret;
 }
 
 static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
-- 
2.25.1
