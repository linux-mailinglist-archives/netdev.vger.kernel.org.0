Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B1C3B338B
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhFXQJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:09:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34352 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231655AbhFXQIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:08:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624550787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4HZENA/DgIRqzTQFaPlI7HLLaKbjRPeaazW1V9p71pE=;
        b=Sop6EizUMfgZKiQtE/7+YgYvImWxiaNSzl+XFMAOrSWqQsl0ipWchFFEVDlTmqvS9iH4Vi
        ofIDgKyCLK+oaWymHlvasXfiTJ/fMYcrJIqX/fpsTLb8FeTqRHymyftk/2YUhKXvVznIOa
        5UE7HS9Ib9CXFL9gh0eDz5FB/vrhewI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-WQoQ1CASMaGzeXgoAYvd7Q-1; Thu, 24 Jun 2021 12:06:25 -0400
X-MC-Unique: WQoQ1CASMaGzeXgoAYvd7Q-1
Received: by mail-ej1-f70.google.com with SMTP id w22-20020a17090652d6b029048a3391d9f6so2202153ejn.12
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 09:06:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4HZENA/DgIRqzTQFaPlI7HLLaKbjRPeaazW1V9p71pE=;
        b=kR9IETMGeChGVMWVYia98yM2K4Vllm0lJqMDjCmEnxEshMUuFn0wBAFujhiOnW5WaW
         T2SYMOK4U0ciyWUlV+lTtC72pZPi9pYgQT4Rl5h2GjuaOwTkm7jmms0423O41Tlkp6s6
         GicnQcalI0gtNj7yagsa9R60B8VXKtedLuvGF6fg2y5h3kUIL3D3VMj2KCmt1t1gbU2F
         1IllCjjCvHkzlgb4LCjV073CQD7S9mNVqSkHxgAHoLxLHtZiegmgi/AaIZ5Er27mPYMr
         OybJkSyeU2fQP5efCccbXcIMJ2FOKaeDKmJpVvyHCFwJpHtSQQQUlnBL22n85CSS2eDD
         ykqg==
X-Gm-Message-State: AOAM5331JL4ognA8/i77TYYRuwQyNXhPEIoPQSV50H9qudtYvsy8LM50
        0bJZnHH9IyutaG7/lPbVDDXwllBKDS+YzTqVfMSqxZOdaGd+tc3LSbzvmxE1m4NFazGcELkIZEQ
        cO8bZkTZz103F1mQg
X-Received: by 2002:a17:907:20ed:: with SMTP id rh13mr5923178ejb.137.1624550784126;
        Thu, 24 Jun 2021 09:06:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymuoDGHbfvZKplY9RBsGybZkq21Hh0wdUnS+ml2EhRktVxqqDq4LhKonWx2QxmNk4uIIhRDQ==
X-Received: by 2002:a17:907:20ed:: with SMTP id rh13mr5923141ejb.137.1624550783729;
        Thu, 24 Jun 2021 09:06:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g12sm2149959edb.23.2021.06.24.09.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 09:06:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8DA7418073E; Thu, 24 Jun 2021 18:06:10 +0200 (CEST)
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
Subject: [PATCH bpf-next v5 13/19] mlx4: remove rcu_read_lock() around XDP program invocation
Date:   Thu, 24 Jun 2021 18:06:03 +0200
Message-Id: <20210624160609.292325-14-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210624160609.292325-1-toke@redhat.com>
References: <20210624160609.292325-1-toke@redhat.com>
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
index cea62b8f554c..442991d91c15 100644
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

