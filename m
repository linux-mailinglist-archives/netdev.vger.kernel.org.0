Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D9E3BD225
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239316AbhGFLlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237127AbhGFLf4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22DD461EA4;
        Tue,  6 Jul 2021 11:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570740;
        bh=vSV+KP7kK+8dQ477OOy/G5Ve/6OIMh37u26Cm3/UnEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uk1BKwB6xJZjMd6vkKE4ebt4wXVpPVcQTBKJr9IyvrqDSc9LpGilfh0CNp7zjcLYh
         PSgj1U4kl5xq08xNG29CTZdahn3Einw/OZPD7Kiq3T/QKti2RwfJ1C4IumLWX5Heyy
         NSYr2HAPwmBByJNnt4IVlE7ELn9E6sCxViMLwNqMpfaWmFIEU7WGZomWl/+RCoqqa1
         DZ5pgvKS4CHUnfDi+vHeZ4I7pZZHfEt31iCLpncQNVWxvLUy9LYIoebjJRTnKyZoae
         gDSdPpbn2UWc4ZpYL3bC5XfEc6sZ7Ude9o2sGRfwE4VMgkkBmSG6hPhblnU+CZJ1gn
         f4XynHhFuAifQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 30/74] virtio_net: Remove BUG() to avoid machine dead
Date:   Tue,  6 Jul 2021 07:24:18 -0400
Message-Id: <20210706112502.2064236-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
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
index d8ee001d8e8e..5cd55f950032 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1548,7 +1548,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
 				    virtio_is_little_endian(vi->vdev), false,
 				    0))
-		BUG();
+		return -EPROTO;
 
 	if (vi->mergeable_rx_bufs)
 		hdr->num_buffers = 0;
-- 
2.30.2

