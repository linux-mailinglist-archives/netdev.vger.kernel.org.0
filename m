Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2023A3B18A6
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhFWLQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:16:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230249AbhFWLQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:16:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624446826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c8O4Yimc+TSjNewaWd3nzsqZvk1ap2sDHxPur5LQuO8=;
        b=Cl+zANt5jQGq4GrDoQWHGxoCgexeV/xpYzj/EStJ6vGG7VNBMYStKES/s+TuYr+aYIVd5y
        CKudJC6/1jFkqNvMGQh3m8LX1zYWV0WEEu5ikT5TYkLVmI1yzefU2W4gO3pszoxKK7BkVP
        433UC/yBQqkyG44BJ5wHDo0LXEz8rac=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-AaGAPWJlMtCT9n9p-TRBnw-1; Wed, 23 Jun 2021 07:13:45 -0400
X-MC-Unique: AaGAPWJlMtCT9n9p-TRBnw-1
Received: by mail-ej1-f71.google.com with SMTP id g6-20020a1709064e46b02903f57f85ac45so841044ejw.15
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:13:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c8O4Yimc+TSjNewaWd3nzsqZvk1ap2sDHxPur5LQuO8=;
        b=M6Q279GAB4anp0R08d/f0RAs6oD8Ynhg5Byn617PCo1r1M/IpVPPpZlLPTkpszt/wP
         iiIP73AYAjA2nRnzI/pgsgp4aD7mloCpxFydWv8nE64n6Ly/f230OaTtWP/5PmbJuzAk
         +yOwqCgAl13umawpbAlCMsLheY4Fuax0ldRz3ENdq/qIaFdGgXF8vzomYKqLeNkze9e0
         T6U9tNnL0G8p+Ytk/VFSiXfHvvn9xpBheY32FoSD3bnJ9IaFUL+yxCmNoZWbzUYHoP7y
         2wO/q8Mesmc2ek1ZcgrNxqOL+M8tvFyXHTSrhsa9r29nGOajkbOTRCcpn/oVwcHaQFDX
         u+dA==
X-Gm-Message-State: AOAM5303Z6KjI17pOpcYfpqiMRX85O6pENbYe4RV2aSWckGteiv1poqm
        hU0y2UtNVVXRXvZBTaSi56T9QoUkxtrNuGZ54LtIqhV4/er7x1VuqjefhiVt0uusXiONDANS9Ue
        8AYrD2Z2ACo//nIXd
X-Received: by 2002:a50:fb14:: with SMTP id d20mr3291894edq.187.1624446824538;
        Wed, 23 Jun 2021 04:13:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsSY5GdO8QnMV3L9SPl1VreJbS+DP/2ecehYnp9BW+UbIigCzyGSGeiKpi3x7jyvffXawbww==
X-Received: by 2002:a50:fb14:: with SMTP id d20mr3291871edq.187.1624446824347;
        Wed, 23 Jun 2021 04:13:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q20sm7334738ejb.71.2021.06.23.04.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:13:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5654518073D; Wed, 23 Jun 2021 13:07:28 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH bpf-next v4 13/19] mlx4: remove rcu_read_lock() around XDP program invocation
Date:   Wed, 23 Jun 2021 13:07:21 +0200
Message-Id: <20210623110727.221922-14-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623110727.221922-1-toke@redhat.com>
References: <20210623110727.221922-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlx4 driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
program invocations. However, the actual lifetime of the objects referred
by the XDP program invocation is longer, all the way through to the call to
xdp_do_flush(), making the scope of the rcu_read_lock() too small. This
turns out to be harmless because it all happens in a single NAPI poll
cycle (and thus under local_bh_disable()), but it makes the rcu_read_lock()
misleading.

Rather than extend the scope of the rcu_read_lock(), just get rid of it
entirely. With the addition of RCU annotations to the XDP_REDIRECT map
types that take bh execution into account, lockdep even understands this to
be safe, so there's really no reason to keep it around. Also switch the RCU
dereferences in the driver loop itself to the _bh variants.

Cc: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index e35e4d7ef4d1..3f08c14d0441 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -679,9 +679,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 
 	ring = priv->rx_ring[cq_ring];
 
-	/* Protect accesses to: ring->xdp_prog, priv->mac_hash list */
-	rcu_read_lock();
-	xdp_prog = rcu_dereference(ring->xdp_prog);
+	xdp_prog = rcu_dereference_bh(ring->xdp_prog);
 	xdp_init_buff(&xdp, priv->frag_info[0].frag_stride, &ring->xdp_rxq);
 	doorbell_pending = false;
 
@@ -744,7 +742,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 				/* Drop the packet, since HW loopback-ed it */
 				mac_hash = ethh->h_source[MLX4_EN_MAC_HASH_IDX];
 				bucket = &priv->mac_hash[mac_hash];
-				hlist_for_each_entry_rcu(entry, bucket, hlist) {
+				hlist_for_each_entry_rcu_bh(entry, bucket, hlist) {
 					if (ether_addr_equal_64bits(entry->mac,
 								    ethh->h_source))
 						goto next;
@@ -899,8 +897,6 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 			break;
 	}
 
-	rcu_read_unlock();
-
 	if (likely(polled)) {
 		if (doorbell_pending) {
 			priv->tx_cq[TX_XDP][cq_ring]->xdp_busy = true;
-- 
2.32.0

