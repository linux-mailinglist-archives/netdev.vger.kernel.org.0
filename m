Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A4D34F98E
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 09:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhCaHMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 03:12:21 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:55975 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233906AbhCaHLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 03:11:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0UTwBY6S_1617174701;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UTwBY6S_1617174701)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 31 Mar 2021 15:11:42 +0800
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
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        Dust Li <dust.li@linux.alibaba.com>
Subject: [PATCH net-next v3 5/8] virtio-net: xsk zero copy xmit support xsk unaligned mode
Date:   Wed, 31 Mar 2021 15:11:36 +0800
Message-Id: <20210331071139.15473-6-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
References: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In xsk unaligned mode, the frame pointed to by desc may span two
consecutive pages, but not more than two pages.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c8a317a93ef7..259fafcf6028 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2562,24 +2562,42 @@ static void virtnet_xsk_check_space(struct send_queue *sq)
 static int virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
 			    struct xdp_desc *desc)
 {
+	u32 offset, n, i, copy, copied;
 	struct virtnet_info *vi;
 	struct page *page;
 	void *data;
-	u32 offset;
+	int err, m;
 	u64 addr;
-	int err;
 
 	vi = sq->vq->vdev->priv;
 	addr = desc->addr;
+
 	data = xsk_buff_raw_get_data(pool, addr);
+
 	offset = offset_in_page(data);
+	m = desc->len - (PAGE_SIZE - offset);
+	/* xsk unaligned mode, desc will use two page */
+	if (m > 0)
+		n = 3;
+	else
+		n = 2;
 
-	sg_init_table(sq->sg, 2);
+	sg_init_table(sq->sg, n);
 	sg_set_buf(sq->sg, &xsk_hdr, vi->hdr_len);
-	page = xsk_buff_xdp_get_page(pool, addr);
-	sg_set_page(sq->sg + 1, page, desc->len, offset);
 
-	err = virtqueue_add_outbuf(sq->vq, sq->sg, 2, NULL, GFP_ATOMIC);
+	copied = 0;
+	for (i = 1; i < n; ++i) {
+		copy = min_t(int, desc->len - copied, PAGE_SIZE - offset);
+
+		page = xsk_buff_xdp_get_page(pool, addr + copied);
+
+		sg_set_page(sq->sg + i, page, copy, offset);
+		copied += copy;
+		if (offset)
+			offset = 0;
+	}
+
+	err = virtqueue_add_outbuf(sq->vq, sq->sg, n, NULL, GFP_ATOMIC);
 	if (unlikely(err))
 		sq->xsk.last_desc = *desc;
 
-- 
2.31.0

