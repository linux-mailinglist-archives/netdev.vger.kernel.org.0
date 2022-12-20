Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A905C652232
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 15:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbiLTOPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 09:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbiLTOPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 09:15:03 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FF71004;
        Tue, 20 Dec 2022 06:15:01 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VXliaRY_1671545696;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VXliaRY_1671545696)
          by smtp.aliyun-inc.com;
          Tue, 20 Dec 2022 22:14:57 +0800
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
Subject: [PATCH v2 6/9] virtio_net: transmit the multi-buffer xdp
Date:   Tue, 20 Dec 2022 22:14:46 +0800
Message-Id: <20221220141449.115918-7-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20221220141449.115918-1-hengqi@linux.alibaba.com>
References: <20221220141449.115918-1-hengqi@linux.alibaba.com>
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
 drivers/net/virtio_net.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 40bc58fa57f5..9f31bfa7f9a6 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -563,22 +563,39 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
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

