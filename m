Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF453633619
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 08:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbiKVHo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 02:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbiKVHoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 02:44:04 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0E0317E5;
        Mon, 21 Nov 2022 23:44:02 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VVRAvyd_1669103038;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VVRAvyd_1669103038)
          by smtp.aliyun-inc.com;
          Tue, 22 Nov 2022 15:43:59 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [RFC PATCH 8/9] virtio_net: transmit the multi-buffer xdp
Date:   Tue, 22 Nov 2022 15:43:47 +0800
Message-Id: <20221122074348.88601-9-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20221122074348.88601-1-hengqi@linux.alibaba.com>
References: <20221122074348.88601-1-hengqi@linux.alibaba.com>
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
---
 drivers/net/virtio_net.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 260ce722c687..431f2126a2b5 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -543,22 +543,34 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 				   struct xdp_frame *xdpf)
 {
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
-	int err;
+	struct skb_shared_info *shinfo;
+	int err, i;
 
 	if (unlikely(xdpf->headroom < vi->hdr_len))
 		return -EOVERFLOW;
 
-	/* Make room for virtqueue hdr (also change xdpf->headroom?) */
+	shinfo = xdp_get_shared_info_from_frame(xdpf);
+	/* Need to adjust this to calculate the correct postion
+	 * for shinfo of the xdpf.
+	 */
+	xdpf->headroom -= vi->hdr_len;
 	xdpf->data -= vi->hdr_len;
 	/* Zero header and leave csum up to XDP layers */
 	hdr = xdpf->data;
 	memset(hdr, 0, vi->hdr_len);
 	xdpf->len   += vi->hdr_len;
 
-	sg_init_one(sq->sg, xdpf->data, xdpf->len);
+	sg_init_table(sq->sg, shinfo->nr_frags + 1);
+	sg_set_buf(sq->sg, xdpf->data, xdpf->len);
+	for (i = 0; i < shinfo->nr_frags; i++) {
+		skb_frag_t *frag = &shinfo->frags[i];
+
+		sg_set_page(&sq->sg[i + 1], skb_frag_page(frag),
+			    skb_frag_size(frag), skb_frag_off(frag));
+	}
 
-	err = virtqueue_add_outbuf(sq->vq, sq->sg, 1, xdp_to_ptr(xdpf),
-				   GFP_ATOMIC);
+	err = virtqueue_add_outbuf(sq->vq, sq->sg, shinfo->nr_frags + 1,
+				   xdp_to_ptr(xdpf), GFP_ATOMIC);
 	if (unlikely(err))
 		return -ENOSPC; /* Caller handle free/refcnt */
 
-- 
2.19.1.6.gb485710b

