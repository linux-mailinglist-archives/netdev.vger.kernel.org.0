Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096E13BCC62
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhGFLS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232590AbhGFLSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0A3461C43;
        Tue,  6 Jul 2021 11:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570161;
        bh=pbrqg3q9ZKQjbiYduLZ2R2y70pRSymOAXgM40LNGXiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkrY907Z6Zco87qdBP9kzHJqUxsVCwk52U9Kdv1JE3hUS7eR3Cq/rGE6hVe1mDVoC
         7ZB2k0egI6OHpFQrwI1O3+xIMynhzMtLtzu32/0aO4HZRNIfV4Tm4Z9eTUiR/ewITr
         72OEbpDaDkJzrXLi/fMR2uZl8dFM5Ixf1XgrnTN3mBf6vYN+AwRcqZJiRsS33MLs+d
         Zw5fTy7uAuhooE/LbYsT4UmsBrNTmNStPLEo2cWAp00O8yd3bgoua1+bC42U294U88
         I5GfFP2MdX3ObEi3z2WXDBgHLRNOE21OubzZvYkxNQf1zDgQw+6aYiM6qjPEgSH5sL
         eEDeMXXNolq3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 082/189] virtio_net: Remove BUG() to avoid machine dead
Date:   Tue,  6 Jul 2021 07:12:22 -0400
Message-Id: <20210706111409.2058071-82-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index 252f6718d730..2debb32a1813 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1625,7 +1625,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
 				    virtio_is_little_endian(vi->vdev), false,
 				    0))
-		BUG();
+		return -EPROTO;
 
 	if (vi->mergeable_rx_bufs)
 		hdr->num_buffers = 0;
-- 
2.30.2

