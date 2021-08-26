Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB3B3F80A6
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 04:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237700AbhHZCvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 22:51:47 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8929 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbhHZCvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 22:51:46 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gw6gX1Ctsz8v4L;
        Thu, 26 Aug 2021 10:46:48 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 26 Aug 2021 10:50:57 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 26 Aug 2021 10:50:57 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linuxarm@openeuler.org>, <mst@redhat.com>, <jasowang@redhat.com>,
        <edumazet@google.com>, <pabeni@redhat.com>, <fw@strlen.de>,
        <aahringo@redhat.com>, <xiangxia.m.yue@gmail.com>,
        <yangbo.lu@nxp.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] sock: remove one redundant SKB_FRAG_PAGE_ORDER macro
Date:   Thu, 26 Aug 2021 10:49:47 +0800
Message-ID: <1629946187-60536-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both SKB_FRAG_PAGE_ORDER are defined to the same value in
net/core/sock.c and drivers/vhost/net.c.

Move the SKB_FRAG_PAGE_ORDER definition to net/core/sock.h,
as both net/core/sock.c and drivers/vhost/net.c include it,
and it seems a reasonable file to put the macro.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 drivers/vhost/net.c | 2 --
 include/net/sock.h  | 1 +
 net/core/sock.c     | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 6414bd5..3a249ee 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -643,8 +643,6 @@ static bool tx_can_batch(struct vhost_virtqueue *vq, size_t total_len)
 	       !vhost_vq_avail_empty(vq->dev, vq);
 }
 
-#define SKB_FRAG_PAGE_ORDER     get_order(32768)
-
 static bool vhost_net_page_frag_refill(struct vhost_net *net, unsigned int sz,
 				       struct page_frag *pfrag, gfp_t gfp)
 {
diff --git a/include/net/sock.h b/include/net/sock.h
index 95b2577..66a9a90 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2717,6 +2717,7 @@ extern int sysctl_optmem_max;
 extern __u32 sysctl_wmem_default;
 extern __u32 sysctl_rmem_default;
 
+#define SKB_FRAG_PAGE_ORDER	get_order(32768)
 DECLARE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
 
 static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
diff --git a/net/core/sock.c b/net/core/sock.c
index 950f1e7..62627e8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2574,7 +2574,6 @@ static void sk_leave_memory_pressure(struct sock *sk)
 	}
 }
 
-#define SKB_FRAG_PAGE_ORDER	get_order(32768)
 DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
 
 /**
-- 
2.7.4

