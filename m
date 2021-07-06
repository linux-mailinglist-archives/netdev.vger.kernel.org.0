Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A613BD5B4
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237676AbhGFMYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:24:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236303AbhGFLfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 809E261E1B;
        Tue,  6 Jul 2021 11:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570602;
        bh=Cw2ARdHoUyronOO5hDgZF3fHmbP47LLSQ6y+NnXGX74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2hL5XqtikPp8bI1mHqPOjBoH5+QPFqnSe2waFUD8WlpVCz0DXmt2X02uNjWA2m5U
         GTMrg3U2VTIbIbbRfU+oWR9ZOkWNapDAxQM88rbtF9CxvUcuAY3p3LGjlLpoHcMZNL
         tv1uxltMayCNcgrnaE8EPNjzK3Aq/KnEqToQVQzoQDXAEBxwqU+iEBdVrJEzLdnCZE
         eUHB9CRALCGS/6AruVzppbVAkqq4yXMHo6VRiEhYSx0MisYu/hoFkSNJFppNjKpQn4
         L3bK7qyXWC9Z/MYROaqnAUOwN1W9YIQHixrhSaXQquI+r1WZ3U/RxPVHGUhJswt/3r
         s7KzZ8j6xr0Mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 061/137] virtio_net: Remove BUG() to avoid machine dead
Date:   Tue,  6 Jul 2021 07:20:47 -0400
Message-Id: <20210706112203.2062605-61-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xianting Tian <xianting.tian@linux.alibaba.com>

[ Upstream commit 85eb1389458d134bdb75dad502cc026c3753a619 ]

We should not directly BUG() when there is hdr error, it is
better to output a print when such error happens. Currently,
the caller of xmit_skb() already did it.

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index e2c6c5675ec6..91e0e6254a01 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1563,7 +1563,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
 				    virtio_is_little_endian(vi->vdev), false,
 				    0))
-		BUG();
+		return -EPROTO;
 
 	if (vi->mergeable_rx_bufs)
 		hdr->num_buffers = 0;
-- 
2.30.2

