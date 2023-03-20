Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784016C23E7
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 22:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjCTVgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 17:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjCTVgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 17:36:12 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D603159DF;
        Mon, 20 Mar 2023 14:35:40 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 6B69A5FD1B;
        Tue, 21 Mar 2023 00:35:14 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679348114;
        bh=+ac8kGjYp52ALChNaMEeZYAi9Vwz3yqoRUCFZXFor6s=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=gK/2mMgADcDcrT72ZntUMdwSfCfZUAlC9ujY0twoyeuOPL89rIM/JppEHPSwmD6Ni
         57Had7xarGduHyOdItz4KLWnzhulqR/M10g8L41xIGMw7H710mPPv8CX7JCPVzJf+O
         w+Kp8gpYLUmeXp2MVxBpeSHCEECKBFlveunen4cRSEtr1VXMTRsRgQqQ8gQUUg2sAH
         m5lwaflXysTqLLO6qclc409JBGImWnSrUHj2Pb+ludslJLhNCN2YIqYYfvJ1lSdbsO
         ZQguKcLbQk9AbG9p/NnZY4d8bOQoh6DUVQfCjDytMatuW88T3pRIZzBioSzYo/qCAl
         G78Os75xfFgWA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 21 Mar 2023 00:35:09 +0300 (MSK)
Message-ID: <f33ef593-982e-2b3f-0986-6d537a3aaf08@sberdevices.ru>
Date:   Tue, 21 Mar 2023 00:31:48 +0300
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
Subject: [RFC PATCH v3] virtio/vsock: allocate multiple skbuffs on tx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/20 09:56:00 #20977321
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
---
 Link to v1:
 https://lore.kernel.org/netdev/2c52aa26-8181-d37a-bccd-a86bd3cbc6e1@sberdevices.ru/
 Link to v2:
 https://lore.kernel.org/netdev/ea5725eb-6cb5-cf15-2938-34e335a442fa@sberdevices.ru/

 Changelog:
 v1 -> v2:
 - If sent something, return number of bytes sent (even in
   case of error). Return error only if failed to sent first
   skbuff.

 v2 -> v3:
 - Handle case when transport callback returns unexpected value which
   is not equal to 'skb->len'. Break loop.
 - Don't check for zero value of 'rest_len' before calling
   'virtio_transport_put_credit()'. Decided to add this check directly
   to 'virtio_transport_put_credit()' in separate patch.

 net/vmw_vsock/virtio_transport_common.c | 59 +++++++++++++++++++------
 1 file changed, 45 insertions(+), 14 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 6564192e7f20..e0b2c6ecbe22 100644
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
 
@@ -227,17 +224,51 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
 		return pkt_len;
 
-	skb = virtio_transport_alloc_skb(info, pkt_len,
-					 src_cid, src_port,
-					 dst_cid, dst_port);
-	if (!skb) {
-		virtio_transport_put_credit(vvs, pkt_len);
-		return -ENOMEM;
-	}
+	ret = 0;
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
+
+		virtio_transport_inc_tx_pkt(vvs, skb);
 
-	virtio_transport_inc_tx_pkt(vvs, skb);
+		ret = t_ops->send_pkt(skb);
 
-	return t_ops->send_pkt(skb);
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
+		if (ret != skb_len) {
+			ret = -EFAULT;
+			break;
+		}
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
