Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4474D5897C6
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 08:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbiHDGc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 02:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiHDGcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 02:32:55 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A87118E3F;
        Wed,  3 Aug 2022 23:32:53 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VLL1OaM_1659594768;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VLL1OaM_1659594768)
          by smtp.aliyun-inc.com;
          Thu, 04 Aug 2022 14:32:49 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net] virtio_net: fix memory leak inside XPD_TX with mergeable
Date:   Thu,  4 Aug 2022 14:32:48 +0800
Message-Id: <20220804063248.104523-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
X-Git-Hash: e7250b49da48
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

When we call xdp_convert_buff_to_frame() to get xdpf, if it returns
NULL, we should check if xdp_page was allocated by xdp_linearize_page().
If it is newly allocated, it should be freed here alone. Just like any
other "goto err_xdp".

Fixes: 44fa2dbd4759 ("xdp: transition into using xdp_frame for ndo_xdp_xmit")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ec8e1b3108c3..3b3eebad3977 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1057,8 +1057,11 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		case XDP_TX:
 			stats->xdp_tx++;
 			xdpf = xdp_convert_buff_to_frame(&xdp);
-			if (unlikely(!xdpf))
+			if (unlikely(!xdpf)) {
+				if (unlikely(xdp_page != page))
+					put_page(xdp_page);
 				goto err_xdp;
+			}
 			err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
 			if (unlikely(!err)) {
 				xdp_return_frame_rx_napi(xdpf);
-- 
2.31.0

