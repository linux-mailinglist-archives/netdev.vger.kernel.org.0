Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC71C2E2985
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 03:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgLYCxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 21:53:47 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9924 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729068AbgLYCxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 21:53:46 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4D2BLh3J8gzhwcf;
        Fri, 25 Dec 2020 10:52:28 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.498.0; Fri, 25 Dec 2020
 10:52:57 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>, <mst@redhat.com>, <jasowang@redhat.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <jerry.lilijun@huawei.com>, <chenchanghu@huawei.com>,
        <xudingke@huawei.com>, <brian.huangbin@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net v2] tun: fix return value when the number of iovs exceeds MAX_SKB_FRAGS
Date:   Fri, 25 Dec 2020 10:52:16 +0800
Message-ID: <1608864736-24332-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.243.127]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

Currently the tun_napi_alloc_frags() function returns -ENOMEM when the
number of iovs exceeds MAX_SKB_FRAGS + 1. However this is inappropriate,
we should use -EMSGSIZE instead of -ENOMEM.

The following distinctions are matters:
1. the caller need to drop the bad packet when -EMSGSIZE is returned,
   which means meeting a persistent failure.
2. the caller can try again when -ENOMEM is returned, which means
   meeting a transient failure.

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
v2:
  * update commit log suggested by Willem de Bruijn
---
 drivers/net/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 2dc1988a8973..15c6dd7fb04c 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1365,7 +1365,7 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
 	int i;
 
 	if (it->nr_segs > MAX_SKB_FRAGS + 1)
-		return ERR_PTR(-ENOMEM);
+		return ERR_PTR(-EMSGSIZE);
 
 	local_bh_disable();
 	skb = napi_get_frags(&tfile->napi);
-- 
2.23.0

