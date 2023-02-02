Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E2D687B53
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbjBBLCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbjBBLBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:01:31 -0500
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7808717B;
        Thu,  2 Feb 2023 03:01:29 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VakkM7N_1675335684;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VakkM7N_1675335684)
          by smtp.aliyun-inc.com;
          Thu, 02 Feb 2023 19:01:25 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH 23/33] virtio_net: xsk: support xsk setup
Date:   Thu,  2 Feb 2023 19:00:48 +0800
Message-Id: <20230202110058.130695-24-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: d7589ab6ea10
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

support xsk XDP_SETUP_XSK_POOL.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/main.c       | 2 ++
 drivers/net/virtio/virtio_net.h | 2 ++
 drivers/net/virtio/xsk.c        | 9 +++++++++
 drivers/net/virtio/xsk.h        | 7 +++++++
 4 files changed, 20 insertions(+)
 create mode 100644 drivers/net/virtio/xsk.h

diff --git a/drivers/net/virtio/main.c b/drivers/net/virtio/main.c
index 0ee23468b795..ed79e750bc6c 100644
--- a/drivers/net/virtio/main.c
+++ b/drivers/net/virtio/main.c
@@ -3094,6 +3094,8 @@ static int virtnet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return virtnet_xdp_set(dev, xdp->prog, xdp->extack);
+	case XDP_SETUP_XSK_POOL:
+		return virtnet_xsk_pool_setup(dev, xdp);
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/virtio/virtio_net.h b/drivers/net/virtio/virtio_net.h
index 4a7633714802..a12d85624fe9 100644
--- a/drivers/net/virtio/virtio_net.h
+++ b/drivers/net/virtio/virtio_net.h
@@ -248,6 +248,8 @@ static inline void virtqueue_napi_schedule(struct napi_struct *napi,
 	}
 }
 
+#include "xsk.h"
+
 static inline bool is_xdp_frame(void *ptr)
 {
 	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
diff --git a/drivers/net/virtio/xsk.c b/drivers/net/virtio/xsk.c
index 18c0c6e4d501..b96af38a2608 100644
--- a/drivers/net/virtio/xsk.c
+++ b/drivers/net/virtio/xsk.c
@@ -142,3 +142,12 @@ static int virtnet_xsk_pool_disable(struct net_device *dev, u16 qid)
 
 	return err1 | err2;
 }
+
+int virtnet_xsk_pool_setup(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	if (xdp->xsk.pool)
+		return virtnet_xsk_pool_enable(dev, xdp->xsk.pool,
+					       xdp->xsk.queue_id);
+	else
+		return virtnet_xsk_pool_disable(dev, xdp->xsk.queue_id);
+}
diff --git a/drivers/net/virtio/xsk.h b/drivers/net/virtio/xsk.h
new file mode 100644
index 000000000000..1918285c310c
--- /dev/null
+++ b/drivers/net/virtio/xsk.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __XSK_H__
+#define __XSK_H__
+
+int virtnet_xsk_pool_setup(struct net_device *dev, struct netdev_bpf *xdp);
+#endif
-- 
2.32.0.3.g01195cf9f

