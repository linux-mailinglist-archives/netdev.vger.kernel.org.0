Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E74CD6BAC0
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 12:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733116AbfGQKyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 06:54:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733001AbfGQKyL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 06:54:11 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 126A281F1B;
        Wed, 17 Jul 2019 10:54:11 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DFA071017E30;
        Wed, 17 Jul 2019 10:53:58 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jfreimann@redhat.com, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com
Subject: [PATCH V3 12/15] vhost: vhost_put_user() can accept metadata type
Date:   Wed, 17 Jul 2019 06:52:52 -0400
Message-Id: <20190717105255.63488-13-jasowang@redhat.com>
In-Reply-To: <20190717105255.63488-1-jasowang@redhat.com>
References: <20190717105255.63488-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 17 Jul 2019 10:54:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We assumes used ring update is the only user for vhost_put_user() in
the past. This may not be the case for the incoming packed ring which
may update the descriptor ring for used. So introduce a new type
parameter.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 6044cdea124f..3fa1adf2cb90 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1178,7 +1178,7 @@ static inline void __user *__vhost_get_user(struct vhost_virtqueue *vq,
 	return __vhost_get_user_slow(vq, addr, size, type);
 }
 
-#define vhost_put_user(vq, x, ptr)		\
+#define vhost_put_user(vq, x, ptr, type)		\
 ({ \
 	int ret = -EFAULT; \
 	if (!vq->iotlb) { \
@@ -1186,7 +1186,7 @@ static inline void __user *__vhost_get_user(struct vhost_virtqueue *vq,
 	} else { \
 		__typeof__(ptr) to = \
 			(__typeof__(ptr)) __vhost_get_user(vq, ptr,	\
-					  sizeof(*ptr), VHOST_ADDR_USED); \
+					  sizeof(*ptr), type); \
 		if (to != NULL) \
 			ret = __put_user(x, to); \
 		else \
@@ -1230,7 +1230,7 @@ static inline int vhost_put_avail_event(struct vhost_virtqueue *vq)
 #endif
 
 	return vhost_put_user(vq, cpu_to_vhost16(vq, vq->avail_idx),
-			      vhost_avail_event(vq));
+			      vhost_avail_event(vq), VHOST_ADDR_USED);
 }
 
 static inline int vhost_put_used(struct vhost_virtqueue *vq,
@@ -1267,7 +1267,7 @@ static inline int vhost_put_used_flags(struct vhost_virtqueue *vq)
 #endif
 
 	return vhost_put_user(vq, cpu_to_vhost16(vq, vq->used_flags),
-			      &vq->used->flags);
+			      &vq->used->flags, VHOST_ADDR_USED);
 }
 
 static inline int vhost_put_used_idx(struct vhost_virtqueue *vq)
@@ -1284,7 +1284,7 @@ static inline int vhost_put_used_idx(struct vhost_virtqueue *vq)
 #endif
 
 	return vhost_put_user(vq, cpu_to_vhost16(vq, vq->last_used_idx),
-			      &vq->used->idx);
+			      &vq->used->idx, VHOST_ADDR_USED);
 }
 
 #define vhost_get_user(vq, x, ptr, type)		\
-- 
2.18.1

