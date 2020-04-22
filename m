Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590E31B49B3
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgDVQJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:09:00 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51060 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726667AbgDVQJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:09:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587571738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y64HUdYoCarj58fkcaitOQ3dtKZD+rqR2sTqjPA43rs=;
        b=fkUsPqjYXhDG2eiagpqLt4slU+RsH3V+MzLcotVY6HCSSP63OaK6CYeIribDb4DLZc5wJT
        Ck+Fa58DZC9sqdvzjI+tCK09H/43nDwiUmXaY9St8W9r6wu9rnSnA0BcjptxKb8voP1YVG
        5PJ9dGxC+vLC9JQ3WFpV2yhg34gXM0Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-4xHNZdxhPmWmyTS5KIsrwg-1; Wed, 22 Apr 2020 12:08:54 -0400
X-MC-Unique: 4xHNZdxhPmWmyTS5KIsrwg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4ADB618CA260;
        Wed, 22 Apr 2020 16:08:52 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43BA74FA50;
        Wed, 22 Apr 2020 16:08:43 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 651A530000E43;
        Wed, 22 Apr 2020 18:08:42 +0200 (CEST)
Subject: [PATCH net-next 16/33] mlx4: add XDP frame size and adjust max XDP
 MTU
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
Date:   Wed, 22 Apr 2020 18:08:42 +0200
Message-ID: <158757172234.1370371.3244906743966141248.stgit@firesoul>
In-Reply-To: <158757160439.1370371.13213378122947426220.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlx4 drivers size of memory backing the RX packet is stored in
frag_stride. For XDP mode this will be PAGE_SIZE (normally 4096).
For normal mode frag_stride is 2048.

Also adjust MLX4_EN_MAX_XDP_MTU to take tailroom into account.

Cc: Tariq Toukan <tariqt@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    3 ++-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c     |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 43dcbd8214c6..5bd3cd37d50f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -51,7 +51,8 @@
 #include "en_port.h"
 
 #define MLX4_EN_MAX_XDP_MTU ((int)(PAGE_SIZE - ETH_HLEN - (2 * VLAN_HLEN) - \
-				   XDP_PACKET_HEADROOM))
+				XDP_PACKET_HEADROOM -			    \
+				SKB_DATA_ALIGN(sizeof(struct skb_shared_info))))
 
 int mlx4_en_setup_tc(struct net_device *dev, u8 up)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index db3552f2d087..231f08c0276c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -683,6 +683,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(ring->xdp_prog);
 	xdp.rxq = &ring->xdp_rxq;
+	xdp.frame_sz = priv->frag_info[0].frag_stride;
 	doorbell_pending = 0;
 
 	/* We assume a 1:1 mapping between CQEs and Rx descriptors, so Rx


