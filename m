Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7C32E2680
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 12:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgLXLuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 06:50:01 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9645 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgLXLuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 06:50:00 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D1pHQ4hd7z15jKY;
        Thu, 24 Dec 2020 19:48:18 +0800 (CST)
Received: from localhost (10.174.243.127) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.498.0; Thu, 24 Dec 2020
 19:48:56 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>, <mst@redhat.com>, <jasowang@redhat.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <jerry.lilijun@huawei.com>, <chenchanghu@huawei.com>,
        <xudingke@huawei.com>, <brian.huangbin@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net] tun: fix return value when the number of iovs exceeds MAX_SKB_FRAGS
Date:   Thu, 24 Dec 2020 19:48:53 +0800
Message-ID: <1608810533-8308-1-git-send-email-wangyunjian@huawei.com>
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

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
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

