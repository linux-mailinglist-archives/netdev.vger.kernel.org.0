Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125D12CD0B4
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 09:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgLCIC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 03:02:29 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:8926 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgLCIC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 03:02:29 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CmpFC5J89z782w;
        Thu,  3 Dec 2020 16:01:19 +0800 (CST)
Received: from localhost (10.174.187.156) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Thu, 3 Dec 2020
 16:01:39 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <jerry.lilijun@huawei.com>,
        <xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] tun: fix ubuf refcount incorrectly on error path
Date:   Thu, 3 Dec 2020 16:00:59 +0800
Message-ID: <1606982459-41752-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.156]
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
fix this by clearing ubuf_info when meeting errors.

Fixes: 4477138fa0ae ("tun: properly test for IFF_UP")
Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/net/tun.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 2dc1988a8973..3614bb1b6d35 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1861,6 +1861,12 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	if (unlikely(!(tun->dev->flags & IFF_UP))) {
 		err = -EIO;
 		rcu_read_unlock();
+		if (zerocopy) {
+			skb_shinfo(skb)->destructor_arg = NULL;
+			skb_shinfo(skb)->tx_flags &= ~SKBTX_DEV_ZEROCOPY;
+			skb_shinfo(skb)->tx_flags &= ~SKBTX_SHARED_FRAG;
+		}
+
 		goto drop;
 	}
 
@@ -1874,6 +1880,11 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 		if (unlikely(headlen > skb_headlen(skb))) {
 			atomic_long_inc(&tun->dev->rx_dropped);
+			if (zerocopy) {
+				skb_shinfo(skb)->destructor_arg = NULL;
+				skb_shinfo(skb)->tx_flags &= ~SKBTX_DEV_ZEROCOPY;
+				skb_shinfo(skb)->tx_flags &= ~SKBTX_SHARED_FRAG;
+			}
 			napi_free_frags(&tfile->napi);
 			rcu_read_unlock();
 			mutex_unlock(&tfile->napi_mutex);
-- 
2.18.1

