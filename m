Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE10C668FE5
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239619AbjAMIB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239960AbjAMIBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:01:17 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993316DB8B;
        Fri, 13 Jan 2023 00:00:25 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VZU-5H8_1673596818;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VZU-5H8_1673596818)
          by smtp.aliyun-inc.com;
          Fri, 13 Jan 2023 16:00:18 +0800
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
Subject: [PATCH net-next v4 02/10] virtio-net: fix calculation of MTU for single buffer xdp
Date:   Fri, 13 Jan 2023 16:00:08 +0800
Message-Id: <20230113080016.45505-3-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230113080016.45505-1-hengqi@linux.alibaba.com>
References: <20230113080016.45505-1-hengqi@linux.alibaba.com>
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

When single-buffer xdp is loaded, the size of the buffer filled each time
is 'sz = (PAGE_SIZE - headroom - tailroom)', which is the maximum packet
length that the driver allows the device to pass in. Otherwise, the packet
with a length greater than sz will come in, so num_buf will be greater than
or equal to 2, and then xdp_linearize_page() will be performed and the
packet will be dropped because the total length is greater than PAGE_SIZE.
So the maximum value of MTU for single-buffer xdp is 'max_sz = sz - ETH_HLEN'.

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
In fact, this is a fix patch belonging to the net branch, which needs
to be backported to the stable branch.

 drivers/net/virtio_net.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 443aa7b8f0ad..87226dd8d262 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3074,7 +3074,9 @@ static int virtnet_restore_guest_offloads(struct virtnet_info *vi)
 static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			   struct netlink_ext_ack *extack)
 {
-	unsigned long int max_sz = PAGE_SIZE - sizeof(struct padded_vnet_hdr);
+	unsigned int room = SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM +
+					   sizeof(struct skb_shared_info));
+	unsigned int max_sz = PAGE_SIZE - room - ETH_HLEN;
 	struct virtnet_info *vi = netdev_priv(dev);
 	struct bpf_prog *old_prog;
 	u16 xdp_qp = 0, curr_qp;
-- 
2.19.1.6.gb485710b

