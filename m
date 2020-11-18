Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4629B2B788B
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 09:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgKRIZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 03:25:18 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:54216 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726296AbgKRIZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 03:25:17 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UFn7TNs_1605687913;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UFn7TNs_1605687913)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 Nov 2020 16:25:13 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     bjorn.topel@intel.com
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] xsk: set tx/rx the min entries
Date:   Wed, 18 Nov 2020 16:25:10 +0800
Message-Id: <ed585669ba63dbbef5ec0d5568574e5e51e23c06.1605686678.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1605686678.git.xuanzhuo@linux.alibaba.com>
References: <3306b4d8-8689-b0e7-3f6d-c3ad873b7093@intel.com>
 <cover.1605686678.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1605686678.git.xuanzhuo@linux.alibaba.com>
References: <cover.1605686678.git.xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We expect tx entries to be greater than twice the number of packets that
the network card can send at a time, so that when the remaining number
of the tx queue is less than half of the queue, it can be guaranteed
that there are recycled items in the cq that can be used.

At the same time, rx will not cause packet loss because it cannot
receive the packets uploaded by the network card at one time.

Of course, the 1024 here is only an estimated value, and the number of
packets sent by each network card at a time may be different.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 include/uapi/linux/if_xdp.h | 2 ++
 net/xdp/xsk.c               | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
index a78a809..d55ba79 100644
--- a/include/uapi/linux/if_xdp.h
+++ b/include/uapi/linux/if_xdp.h
@@ -64,6 +64,8 @@ struct xdp_mmap_offsets {
 #define XDP_STATISTICS			7
 #define XDP_OPTIONS			8
 
+#define XDP_RXTX_RING_MIN_ENTRIES       1024
+
 struct xdp_umem_reg {
 	__u64 addr; /* Start of packet data area */
 	__u64 len; /* Length of packet data area */
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index bc3d4ece..e62c795 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -831,6 +831,8 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 			return -EINVAL;
 		if (copy_from_sockptr(&entries, optval, sizeof(entries)))
 			return -EFAULT;
+		if (entries < XDP_RXTX_RING_MIN_ENTRIES)
+			return -EINVAL;
 
 		mutex_lock(&xs->mutex);
 		if (xs->state != XSK_READY) {
-- 
1.8.3.1

