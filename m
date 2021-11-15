Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079D8450883
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 16:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbhKOPfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 10:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236667AbhKOPfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 10:35:01 -0500
X-Greylist: delayed 101 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Nov 2021 07:32:02 PST
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70C9C061766;
        Mon, 15 Nov 2021 07:31:59 -0800 (PST)
Received: from iva8-d2cd82b7433e.qloud-c.yandex.net (iva8-d2cd82b7433e.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:a88e:0:640:d2cd:82b7])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 8D3A02E101C;
        Mon, 15 Nov 2021 18:30:17 +0300 (MSK)
Received: from iva4-f06c35e68a0a.qloud-c.yandex.net (iva4-f06c35e68a0a.qloud-c.yandex.net [2a02:6b8:c0c:152e:0:640:f06c:35e6])
        by iva8-d2cd82b7433e.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 7dSigTEJay-UGsqMU5B;
        Mon, 15 Nov 2021 18:30:17 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1636990217; bh=hD/D+1kSstlQTTh1W7AK2gOCb2Yqt/7WhBUur9GwPEE=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=fPA/J5cJ+KSQ2lo7J8Yek4Rba35NcqCckCHG+gypfrbfShMPMcSb7M/+iOHWOziDh
         QjFWAOYYtoAtQSBdBSmWqxrbCY6ATECDFFzn3x6zwIefxT/JjBS1G5Z1YGMw3o8pyr
         5602p2DrL5l2GnzbcUl7r41teYHZxGLlIThyKr74=
Authentication-Results: iva8-d2cd82b7433e.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from dellarbn.yandex.net (dynamic-red3.dhcp.yndx.net [2a02:6b8:0:107:3e85:844d:5b1d:60a])
        by iva4-f06c35e68a0a.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id wuqDqjnGag-UGxaT0Z8;
        Mon, 15 Nov 2021 18:30:16 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Andrey Ryabinin <arbn@yandex-team.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Andrey Ryabinin <arbn@yandex-team.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 6/6] vhost_net: use RCU callbacks instead of synchronize_rcu()
Date:   Mon, 15 Nov 2021 18:30:03 +0300
Message-Id: <20211115153003.9140-6-arbn@yandex-team.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211115153003.9140-1-arbn@yandex-team.com>
References: <20211115153003.9140-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently vhost_net_release() uses synchronize_rcu() to synchronize
freeing with vhost_zerocopy_callback(). However synchronize_rcu()
is quite costly operation. It take more than 10 seconds
to shutdown qemu launched with couple net devices like this:
	-netdev tap,id=tap0,..,vhost=on,queues=80
because we end up calling synchronize_rcu() netdev_count*queues times.

Free vhost net structures in rcu callback instead of using
synchronize_rcu() to fix the problem.

Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 drivers/vhost/net.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 97a209d6a527..0699d30e83d5 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -132,6 +132,7 @@ struct vhost_net {
 	struct vhost_dev dev;
 	struct vhost_net_virtqueue vqs[VHOST_NET_VQ_MAX];
 	struct vhost_poll poll[VHOST_NET_VQ_MAX];
+	struct rcu_head rcu;
 	/* Number of TX recently submitted.
 	 * Protected by tx vq lock. */
 	unsigned tx_packets;
@@ -1389,6 +1390,18 @@ static void vhost_net_flush(struct vhost_net *n)
 	}
 }
 
+static void vhost_net_free(struct rcu_head *rcu_head)
+{
+	struct vhost_net *n = container_of(rcu_head, struct vhost_net, rcu);
+
+	kfree(n->vqs[VHOST_NET_VQ_RX].rxq.queue);
+	kfree(n->vqs[VHOST_NET_VQ_TX].xdp);
+	kfree(n->dev.vqs);
+	if (n->page_frag.page)
+		__page_frag_cache_drain(n->page_frag.page, n->refcnt_bias);
+	kvfree(n);
+}
+
 static int vhost_net_release(struct inode *inode, struct file *f)
 {
 	struct vhost_net *n = f->private_data;
@@ -1404,15 +1417,8 @@ static int vhost_net_release(struct inode *inode, struct file *f)
 		sockfd_put(tx_sock);
 	if (rx_sock)
 		sockfd_put(rx_sock);
-	/* Make sure no callbacks are outstanding */
-	synchronize_rcu();
 
-	kfree(n->vqs[VHOST_NET_VQ_RX].rxq.queue);
-	kfree(n->vqs[VHOST_NET_VQ_TX].xdp);
-	kfree(n->dev.vqs);
-	if (n->page_frag.page)
-		__page_frag_cache_drain(n->page_frag.page, n->refcnt_bias);
-	kvfree(n);
+	call_rcu(&n->rcu, vhost_net_free);
 	return 0;
 }
 
-- 
2.32.0

