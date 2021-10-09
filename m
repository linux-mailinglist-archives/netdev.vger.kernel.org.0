Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634FB427873
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 11:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhJIJeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 05:34:44 -0400
Received: from mx313.baidu.com ([180.101.52.140]:41764 "EHLO
        njjs-sys-mailin06.njjs.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230022AbhJIJem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 05:34:42 -0400
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (unknown [10.168.56.63])
        by njjs-sys-mailin06.njjs.baidu.com (Postfix) with ESMTP id D321A185C00C4;
        Sat,  9 Oct 2021 17:32:43 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id B7EFAD9932;
        Sat,  9 Oct 2021 17:32:43 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH][net-next] virtio_net: skip RCU read lock by checking xdp_enabled of vi
Date:   Sat,  9 Oct 2021 17:32:43 +0800
Message-Id: <1633771963-6746-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

networking benchmark shows that __rcu_read_lock and
__rcu_read_unlock takes some cpu cycles, and we can avoid
calling them partially in virtio rx path by check xdp_enabled
of vi, and xdp is disabled most of time

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/net/virtio_net.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2ed49884565f..74d2be438180 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -734,6 +734,12 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		dev->stats.rx_length_errors++;
 		goto err_len;
 	}
+
+	if (likely(!vi->xdp_enabled)) {
+		xdp_prog = NULL;
+		goto skip_xdp;
+	}
+
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (xdp_prog) {
@@ -816,6 +822,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	}
 	rcu_read_unlock();
 
+skip_xdp:
 	skb = build_skb(buf, buflen);
 	if (!skb) {
 		put_page(page);
@@ -897,6 +904,12 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		dev->stats.rx_length_errors++;
 		goto err_skb;
 	}
+
+	if (likely(!vi->xdp_enabled)) {
+		xdp_prog = NULL;
+		goto skip_xdp;
+	}
+
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (xdp_prog) {
@@ -1024,6 +1037,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	}
 	rcu_read_unlock();
 
+skip_xdp:
 	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
 			       metasize, headroom);
 	curr_skb = head_skb;
-- 
2.33.0.69.gc420321.dirty
