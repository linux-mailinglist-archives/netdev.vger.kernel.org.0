Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1394F35D5C0
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 05:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344358AbhDMDPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 23:15:55 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:56400 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242158AbhDMDPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 23:15:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0UVP5zPB_1618283725;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UVP5zPB_1618283725)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Apr 2021 11:15:25 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
Subject: [PATCH net-next v4 05/10] xsk: XDP_SETUP_XSK_POOL support option IFF_NOT_USE_DMA_ADDR
Date:   Tue, 13 Apr 2021 11:15:18 +0800
Message-Id: <20210413031523.73507-6-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
References: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some devices, such as virtio-net, do not directly use dma addr. These
devices do not initialize dma after completing the xsk setup, so the dma
check is skipped here.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/xdp/xsk_buff_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 8de01aaac4a0..a7e434de0308 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -171,7 +171,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	if (err)
 		goto err_unreg_pool;
 
-	if (!pool->dma_pages) {
+	if (!(netdev->priv_flags & IFF_NOT_USE_DMA_ADDR) && !pool->dma_pages) {
 		WARN(1, "Driver did not DMA map zero-copy buffers");
 		err = -EINVAL;
 		goto err_unreg_xsk;
-- 
2.31.0

