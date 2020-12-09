Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6A92D4252
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 13:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731797AbgLIMmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 07:42:46 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9048 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730929AbgLIMme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 07:42:34 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Crc9X12VGzhYl3;
        Wed,  9 Dec 2020 20:41:20 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Dec 2020
 20:41:43 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <jerry.lilijun@huawei.com>,
        <chenchanghu@huawei.com>, <xudingke@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net v2] tun: fix ubuf refcount incorrectly on error path
Date:   Wed, 9 Dec 2020 20:41:43 +0800
Message-ID: <1607517703-18472-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
In-Reply-To: <1606982459-41752-1-git-send-email-wangyunjian@huawei.com>
References: <1606982459-41752-1-git-send-email-wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.243.127]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

After setting callback for ubuf_info of skb, the callback
(vhost_net_zerocopy_callback) will be called to decrease
the refcount when freeing skb. But when an exception occurs
afterwards, the error handling in vhost handle_tx() will
try to decrease the same refcount again. This is wrong and
fix this by delay copying ubuf_info until we're sure
there's no errors.

Fixes: 4477138fa0ae ("tun: properly test for IFF_UP")
Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
v2:
   Updated code, fix by delay copying ubuf_info
---
 drivers/net/tun.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 2dc1988a8973..2ea822328e73 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1637,6 +1637,20 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 	return NULL;
 }
 
+/* copy ubuf_info for callback when skb has no error */
+static inline void tun_copy_ubuf_info(struct sk_buff *skb, bool zerocopy, void *msg_control)
+{
+	if (zerocopy) {
+		skb_shinfo(skb)->destructor_arg = msg_control;
+		skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
+		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
+	} else if (msg_control) {
+		struct ubuf_info *uarg = msg_control;
+
+		uarg->callback(uarg, false);
+	}
+}
+
 /* Get packet from user space buffer */
 static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 			    void *msg_control, struct iov_iter *from,
@@ -1812,16 +1826,6 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		break;
 	}
 
-	/* copy skb_ubuf_info for callback when skb has no error */
-	if (zerocopy) {
-		skb_shinfo(skb)->destructor_arg = msg_control;
-		skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
-		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
-	} else if (msg_control) {
-		struct ubuf_info *uarg = msg_control;
-		uarg->callback(uarg, false);
-	}
-
 	skb_reset_network_header(skb);
 	skb_probe_transport_header(skb);
 	skb_record_rx_queue(skb, tfile->queue_index);
@@ -1830,6 +1834,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		struct bpf_prog *xdp_prog;
 		int ret;
 
+		tun_copy_ubuf_info(skb, zerocopy, msg_control);
 		local_bh_disable();
 		rcu_read_lock();
 		xdp_prog = rcu_dereference(tun->xdp_prog);
@@ -1881,6 +1886,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 			return -ENOMEM;
 		}
 
+		tun_copy_ubuf_info(skb, zerocopy, msg_control);
 		local_bh_disable();
 		napi_gro_frags(&tfile->napi);
 		local_bh_enable();
@@ -1889,6 +1895,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		struct sk_buff_head *queue = &tfile->sk.sk_write_queue;
 		int queue_len;
 
+		tun_copy_ubuf_info(skb, zerocopy, msg_control);
 		spin_lock_bh(&queue->lock);
 		__skb_queue_tail(queue, skb);
 		queue_len = skb_queue_len(queue);
@@ -1899,8 +1906,10 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 		local_bh_enable();
 	} else if (!IS_ENABLED(CONFIG_4KSTACKS)) {
+		tun_copy_ubuf_info(skb, zerocopy, msg_control);
 		tun_rx_batched(tun, tfile, skb, more);
 	} else {
+		tun_copy_ubuf_info(skb, zerocopy, msg_control);
 		netif_rx_ni(skb);
 	}
 	rcu_read_unlock();
-- 
2.23.0

