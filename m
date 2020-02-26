Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0672916F492
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 01:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgBZA6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 19:58:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729277AbgBZA6E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 19:58:04 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41E8221927;
        Wed, 26 Feb 2020 00:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582678683;
        bh=lZKyUgaTT6f+F71KbAvc2/3FwiSgqPc3XQVqexI06+o=;
        h=From:To:Cc:Subject:Date:From;
        b=LPU+PsxcNkGTOJbGKWPnKhMXXD+7u/kSsgUbyZzb75qJj3XUfOdvCII+6yTAjNNeM
         89RmprvzkqF2QX4czODCz8J09qfYR86I7v5FHJrZiTMs0nH3AQXs2VRVlv/bX7km/v
         0LG6JF8AlTdq4vwnTEc9jWcbrIjgOK5AH7LrwBZM=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        David Ahern <dahern@digitalocean.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH RFC net-next] virtio_net: Relax queue requirement for using XDP
Date:   Tue, 25 Feb 2020 17:57:44 -0700
Message-Id: <20200226005744.1623-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

virtio_net currently requires extra queues to install an XDP program,
with the rule being twice as many queues as vcpus. From a host
perspective this means the VM needs to have 2*vcpus vhost threads
for each guest NIC for which XDP is to be allowed. For example, a
16 vcpu VM with 2 tap devices needs 64 vhost threads.

The extra queues are only needed in case an XDP program wants to
return XDP_TX. XDP_PASS, XDP_DROP and XDP_REDIRECT do not need
additional queues. Relax the queue requirement and allow XDP
functionality based on resources. If an XDP program is loaded and
there are insufficient queues, then return a warning to the user
and if a program returns XDP_TX just drop the packet. This allows
the use of the rest of the XDP functionality to work without
putting an unreasonable burden on the host.

Cc: Jason Wang <jasowang@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 drivers/net/virtio_net.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2fe7a3188282..2f4c5b2e674d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -190,6 +190,8 @@ struct virtnet_info {
 	/* # of XDP queue pairs currently used by the driver */
 	u16 xdp_queue_pairs;
 
+	bool can_do_xdp_tx;
+
 	/* I like... big packets and I cannot lie! */
 	bool big_packets;
 
@@ -697,6 +699,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
 			len = xdp.data_end - xdp.data;
 			break;
 		case XDP_TX:
+			if (!vi->can_do_xdp_tx)
+				goto err_xdp;
 			stats->xdp_tx++;
 			xdpf = convert_to_xdp_frame(&xdp);
 			if (unlikely(!xdpf))
@@ -870,6 +874,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			}
 			break;
 		case XDP_TX:
+			if (!vi->can_do_xdp_tx)
+				goto err_xdp;
 			stats->xdp_tx++;
 			xdpf = convert_to_xdp_frame(&xdp);
 			if (unlikely(!xdpf))
@@ -2435,10 +2441,10 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 
 	/* XDP requires extra queues for XDP_TX */
 	if (curr_qp + xdp_qp > vi->max_queue_pairs) {
-		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available");
-		netdev_warn(dev, "request %i queues but max is %i\n",
-			    curr_qp + xdp_qp, vi->max_queue_pairs);
-		return -ENOMEM;
+		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available; XDP_TX will not be allowed");
+		vi->can_do_xdp_tx = false;
+	} else {
+		vi->can_do_xdp_tx = true;
 	}
 
 	old_prog = rtnl_dereference(vi->rq[0].xdp_prog);
-- 
2.17.1

