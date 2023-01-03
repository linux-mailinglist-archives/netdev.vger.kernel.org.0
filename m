Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4986B65BABB
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 07:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbjACGkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 01:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236765AbjACGkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 01:40:25 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F00D10C;
        Mon,  2 Jan 2023 22:40:23 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VYj.ow._1672728019;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VYj.ow._1672728019)
          by smtp.aliyun-inc.com;
          Tue, 03 Jan 2023 14:40:20 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH v3 6/9] virtio-net: transmit the multi-buffer xdp
Date:   Tue,  3 Jan 2023 14:40:09 +0800
Message-Id: <20230103064012.108029-7-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230103064012.108029-1-hengqi@linux.alibaba.com>
References: <20230103064012.108029-1-hengqi@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This serves as the basis for XDP_TX and XDP_REDIRECT
to send a multi-buffer xdp_frame.

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ab01cf3855bc..fee9ce31f6c7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -563,22 +563,43 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 				   struct xdp_frame *xdpf)
 {
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
-	int err;
+	struct skb_shared_info *shinfo;
+	u8 nr_frags = 0;
+	int err, i;
 
 	if (unlikely(xdpf->headroom < vi->hdr_len))
 		return -EOVERFLOW;
 
-	/* Make room for virtqueue hdr (also change xdpf->headroom?) */
+	if (unlikely(xdp_frame_has_frags(xdpf))) {
+		shinfo = xdp_get_shared_info_from_frame(xdpf);
+		nr_frags = shinfo->nr_frags;
+	}
+
+	/* In wrapping function virtnet_xdp_xmit(), we need to free
+	 * up the pending old buffers, where we need to calculate the
+	 * position of skb_shared_info in xdp_get_frame_len() and
+	 * xdp_return_frame(), which will involve to xdpf->data and
+	 * xdpf->headroom. Therefore, we need to update the value of
+	 * headroom synchronously here.
+	 */
+	xdpf->headroom -= vi->hdr_len;
 	xdpf->data -= vi->hdr_len;
 	/* Zero header and leave csum up to XDP layers */
 	hdr = xdpf->data;
 	memset(hdr, 0, vi->hdr_len);
 	xdpf->len   += vi->hdr_len;
 
-	sg_init_one(sq->sg, xdpf->data, xdpf->len);
+	sg_init_table(sq->sg, nr_frags + 1);
+	sg_set_buf(sq->sg, xdpf->data, xdpf->len);
+	for (i = 0; i < nr_frags; i++) {
+		skb_frag_t *frag = &shinfo->frags[i];
+
+		sg_set_page(&sq->sg[i + 1], skb_frag_page(frag),
+			    skb_frag_size(frag), skb_frag_off(frag));
+	}
 
-	err = virtqueue_add_outbuf(sq->vq, sq->sg, 1, xdp_to_ptr(xdpf),
-				   GFP_ATOMIC);
+	err = virtqueue_add_outbuf(sq->vq, sq->sg, nr_frags + 1,
+				   xdp_to_ptr(xdpf), GFP_ATOMIC);
 	if (unlikely(err))
 		return -ENOSPC; /* Caller handle free/refcnt */
 
-- 
2.19.1.6.gb485710b

