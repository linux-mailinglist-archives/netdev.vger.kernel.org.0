Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0773E394258
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbhE1MPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbhE1MPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:15:02 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451C6C061342
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 05:12:35 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 29so2376469pgu.11
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 05:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rk9k9ChEl7Vg+ae/8wyh9IS3nb1o6P9TvR8ucb6RQfk=;
        b=arqhkqGKXLOp9FYHW7F+1Qvr074ccA2539eWwXlR56VpI8MXOo85su1pyIaHg0BqWu
         0NZ7luwzcaR4BGwU4mpiQxcfQqvWeVlG6ySfbP1OtydShiz4i3qBXRSJ5DC8lz/lfcJB
         O3N6dQpAghVgnGP0GnkiBJiJmx5tBVJ3s/3ktgyUFTQWppk14d2q+EnT5kRK5Dwjgxhs
         7XwAjiFEwCCKvCGfk4xUHWOmG6+BVV8sX+nZT0eYl/QHFh0wA8F2CHYPSXk2BvGlKBMO
         t5KdqmIat2cMwZEhI6pOP6shRpgbiIwUoxmnExevIPF8DeO1tmtzXvTLRwo5UYDLhlij
         AcCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rk9k9ChEl7Vg+ae/8wyh9IS3nb1o6P9TvR8ucb6RQfk=;
        b=lKGEWNIxo6NRJH+69nwPYfl1jk1SjLXZDtyG4nYo5egVXXtryZ7wmMsgqZSPjlZQG7
         GUsZSaJirTefx+WsPtiYTrrke3VzAXG5ssM9yPdrTgcITkhHptVe+O9oCFn74LVg04s6
         gwkKpvDvg+aIGiteDXg+pXD1pT97ucCpf8gsq8e/3z4GJXKMBnaAlu7fSyi91vIS/7W1
         9lFy3JD5/WOIsJd8Y+SeBmZKUhvHZeg+kAhtof2X24GsS6ORllmfP/p9mXYmhkFq9aVW
         kBKLDHILdW9/nphhv6grJkZOEAX8UViyjJBCmbeCif0Zo65l/0XhoZyFwLeZcOh1IOGA
         YkZA==
X-Gm-Message-State: AOAM533JBjZhK37byEfCf3D1M4NZZBqLThBnjoSx7yC6um+ZfXBESodH
        i6btJ/qFCpR8sakmkHIUMNKZ
X-Google-Smtp-Source: ABdhPJxCxfvZSsLHbJBwI8eroHQylFucorI0drDHYYSNCh2VDuiQT518+4R0U1INuo90BpJtJj2vZQ==
X-Received: by 2002:a63:5052:: with SMTP id q18mr8594951pgl.349.1622203954848;
        Fri, 28 May 2021 05:12:34 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id c1sm4165321pfo.181.2021.05.28.05.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 05:12:33 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, kuba@kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] virtio-net: Add validation for used length
Date:   Fri, 28 May 2021 20:11:57 +0800
Message-Id: <20210528121157.105-1-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds validation for used length (might come
from an untrusted device) to avoid data corruption
or loss.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/net/virtio_net.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 073fec4c0df1..01f15b65824c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -732,6 +732,17 @@ static struct sk_buff *receive_small(struct net_device *dev,
 
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
+	if (unlikely(len > GOOD_PACKET_LEN)) {
+		pr_debug("%s: rx error: len %u exceeds max size %d\n",
+			 dev->name, len, GOOD_PACKET_LEN);
+		dev->stats.rx_length_errors++;
+		if (xdp_prog)
+			goto err_xdp;
+
+		rcu_read_unlock();
+		put_page(page);
+		return NULL;
+	}
 	if (xdp_prog) {
 		struct virtio_net_hdr_mrg_rxbuf *hdr = buf + header_offset;
 		struct xdp_frame *xdpf;
@@ -888,6 +899,16 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
+	if (unlikely(len > truesize)) {
+		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
+			 dev->name, len, (unsigned long)ctx);
+		dev->stats.rx_length_errors++;
+		if (xdp_prog)
+			goto err_xdp;
+
+		rcu_read_unlock();
+		goto err_skb;
+	}
 	if (xdp_prog) {
 		struct xdp_frame *xdpf;
 		struct page *xdp_page;
@@ -1012,13 +1033,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	}
 	rcu_read_unlock();
 
-	if (unlikely(len > truesize)) {
-		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
-			 dev->name, len, (unsigned long)ctx);
-		dev->stats.rx_length_errors++;
-		goto err_skb;
-	}
-
 	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
 			       metasize, !!headroom);
 	curr_skb = head_skb;
-- 
2.11.0

