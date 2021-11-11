Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA1B44D2C9
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 08:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhKKIAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 03:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbhKKIAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 03:00:17 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55F8C061766;
        Wed, 10 Nov 2021 23:57:28 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso3662580wms.3;
        Wed, 10 Nov 2021 23:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yy84J4kYBklmkMHIZAnsZ8B8aIMzcqVJsGpKuCOKvt4=;
        b=AJEE1cKq9S5MKPcGJIr2M2t/33J9nNhOl9g25nFpPZDRmEb2bwKU3DOkFzWA04GQ2a
         H0+4aP32IGsNWRl5TX9bd3jynJ+rOePWbMIWjU1SxCB+ZT7kPIKKWcu9uB/vJ9eBjvEd
         bs8NZnoDpr0Mn14/9d0MqM6sq/hdaE8PVxX3DsZKv0YIo6Mma8OsYPndi7ikgnzcWQYK
         q3UXIU/G2H85rZ+j7jX4pJNOmBLAT3Pwp9g/IYYZw+ARFXY6n9kVgYpGgKgRXqu5Z3Tf
         hENSOGBXV7couWgga1eKFjh7uYf0PZTA1Qjg4Ao6iz+V+PRC9bj/s9gV+l7fMDF+LqNL
         9mjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yy84J4kYBklmkMHIZAnsZ8B8aIMzcqVJsGpKuCOKvt4=;
        b=1aU4PATG/wfhNewWJ+6TpMSp+T+Vr31+LiGLZPAPYqzbTilZLT8H0nwM8oD4parMil
         9X6vVsESholCX52/XticTG6LBAx9nU/b3WfCjHXx9J4Kly/ybH30dD33v+vprtM9OrZk
         14kEqqW99SqxINfRL4I1pmw+Vljg2G7tV0h7KFqMVZYsZ2sMtU+FG6MPBENf35FWDBeS
         d0AxWaDrdzFK/p0vvKgoxxIHvVvR4rKbhXO+1j0QlA4EHrs3/+7eFO/r5be2B1jz+CB3
         G0Cmk+Vwf5uu+6Iko4LUSmT6/yshHTLJxIkc69qFlNETs7aEvrgIlCiOLlVQV3h+eJbx
         0Ftg==
X-Gm-Message-State: AOAM533Mr7VKlBu7AMYt1kQ7Z56sdRDmg9M27mgWr9Lm0Q2wRKAAu/O6
        84RaXpblxdvwOqtDbILiAO8=
X-Google-Smtp-Source: ABdhPJyxYGq+j6f1YUd6GVgSBvko/t6KlGj/54jPIKBYGCFmS+Hg8c8tlbkpKjSO5gdW0HvNs/qg6w==
X-Received: by 2002:a7b:c04b:: with SMTP id u11mr23318678wmc.127.1636617447425;
        Wed, 10 Nov 2021 23:57:27 -0800 (PST)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id m2sm7808818wml.15.2021.11.10.23.57.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Nov 2021 23:57:27 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf] xsk: fix crash on double free in buffer pool
Date:   Thu, 11 Nov 2021 08:57:07 +0100
Message-Id: <20211111075707.21922-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a crash in the buffer pool allocator when a buffer is double
freed. It is possible to trigger this behavior not only from a faulty
driver, but also from user space like this: Create a zero-copy AF_XDP
socket. Load an XDP program that will issue XDP_DROP for all
packets. Put the same umem buffer into the fill ring multiple times,
then bind the socket and send some traffic. This will crash the kernel
as the XDP_DROP action triggers one call to xsk_buff_free()/xp_free()
for every packet dropped. Each call will add the corresponding buffer
entry to the free_list and increase the free_list_cnt. Some entries
will have been added multiple times due to the same buffer being
freed. The buffer allocation code will then traverse this broken list
and since the same buffer is in the list multiple times, it will try
to delete the same buffer twice from the list leading to a crash.

The fix for this is just to test that the buffer has not been added
before in xp_free(). If it has been, just return from the function and
do not put it in the free_list a second time.

Note that this bug was not present in the code before the commit
referenced in the Fixes tag. That code used one list entry per
allocated buffer, so multiple frees did not have any side effects. But
the commit below optimized the usage of the pool and only uses a
single entry per buffer in the umem, meaning that multiple
allocations/frees of the same buffer will also only use one entry,
thus leading to the problem.

Fixes: 47e4075df300 ("xsk: Batched buffer allocation for the pool")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk_buff_pool.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 90c4e1e819d3..bc4ad48ea4f0 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -500,7 +500,7 @@ struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool)
 		pool->free_list_cnt--;
 		xskb = list_first_entry(&pool->free_list, struct xdp_buff_xsk,
 					free_list_node);
-		list_del(&xskb->free_list_node);
+		list_del_init(&xskb->free_list_node);
 	}
 
 	xskb->xdp.data = xskb->xdp.data_hard_start + XDP_PACKET_HEADROOM;
@@ -568,7 +568,7 @@ static u32 xp_alloc_reused(struct xsk_buff_pool *pool, struct xdp_buff **xdp, u3
 	i = nb_entries;
 	while (i--) {
 		xskb = list_first_entry(&pool->free_list, struct xdp_buff_xsk, free_list_node);
-		list_del(&xskb->free_list_node);
+		list_del_init(&xskb->free_list_node);
 
 		*xdp = &xskb->xdp;
 		xdp++;
@@ -615,6 +615,9 @@ EXPORT_SYMBOL(xp_can_alloc);
 
 void xp_free(struct xdp_buff_xsk *xskb)
 {
+	if (!list_empty(&xskb->free_list_node))
+		return;
+
 	xskb->pool->free_list_cnt++;
 	list_add(&xskb->free_list_node, &xskb->pool->free_list);
 }

base-commit: fceb07950a7aac43d52d8c6ef580399a8b9b68fe
-- 
2.29.0

