Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9996822F3
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjAaDnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjAaDnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:43:42 -0500
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6556EFBF;
        Mon, 30 Jan 2023 19:43:40 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VaV42yb_1675136617;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VaV42yb_1675136617)
          by smtp.aliyun-inc.com;
          Tue, 31 Jan 2023 11:43:38 +0800
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
Subject: [PATCH net-next] virtio-net: fix possible unsigned integer overflow
Date:   Tue, 31 Jan 2023 11:43:37 +0800
Message-Id: <20230131034337.55445-1-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the single-buffer xdp is loaded and after xdp_linearize_page()
is called, *num_buf becomes 0 and (*num_buf - 1) may overflow into
a large integer in virtnet_build_xdp_buff_mrg(), resulting in
unexpected packet dropping.

Fixes: ef75cb51f139 ("virtio-net: build xdp_buff with multi buffers")
Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index aaa6fe9b214a..a8e9462903fa 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1007,6 +1007,9 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 	xdp_prepare_buff(xdp, buf - VIRTIO_XDP_HEADROOM,
 			 VIRTIO_XDP_HEADROOM + vi->hdr_len, len - vi->hdr_len, true);
 
+	if (!*num_buf)
+		return 0;
+
 	if (*num_buf > 1) {
 		/* If we want to build multi-buffer xdp, we need
 		 * to specify that the flags of xdp_buff have the
@@ -1020,10 +1023,10 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 		shinfo->xdp_frags_size = 0;
 	}
 
-	if ((*num_buf - 1) > MAX_SKB_FRAGS)
+	if (*num_buf > MAX_SKB_FRAGS + 1)
 		return -EINVAL;
 
-	while ((--*num_buf) >= 1) {
+	while (--*num_buf) {
 		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
 		if (unlikely(!buf)) {
 			pr_debug("%s: rx error: %d buffers out of %d missing\n",
-- 
2.19.1.6.gb485710b

