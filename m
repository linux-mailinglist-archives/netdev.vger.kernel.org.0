Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF13E66AA21
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 09:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjANIWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 03:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjANIWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 03:22:39 -0500
Received: from out30-6.freemail.mail.aliyun.com (out30-6.freemail.mail.aliyun.com [115.124.30.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E562468D;
        Sat, 14 Jan 2023 00:22:36 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VZX3LLO_1673684552;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VZX3LLO_1673684552)
          by smtp.aliyun-inc.com;
          Sat, 14 Jan 2023 16:22:32 +0800
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
Subject: [PATCH net-next v5 02/10] virtio-net: fix calculation of MTU for single-buffer xdp
Date:   Sat, 14 Jan 2023 16:22:21 +0800
Message-Id: <20230114082229.62143-3-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230114082229.62143-1-hengqi@linux.alibaba.com>
References: <20230114082229.62143-1-hengqi@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When single-buffer xdp is loaded, the size of the buffer filled each time
is 'sz = (PAGE_SIZE - headroom - tailroom)', which is the maximum packet
length that the driver allows the device to pass in. Otherwise, the packet
with a length greater than sz will come in, so num_buf will be greater than
or equal to 2, and xdp_linearize_page() will be performed and the packet
will be dropped because the total length is greater than PAGE_SIZE. So the
maximum value of MTU for single-buffer xdp is 'max_sz = sz - ETH_HLEN'.

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
In fact, this is a fix patch belonging to the net branch, which needs
to be backported to the stable branch.

 drivers/net/virtio_net.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 443aa7b8f0ad..1203e4176b66 100644
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
@@ -3097,7 +3099,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 
 	if (dev->mtu > max_sz) {
 		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
-		netdev_warn(dev, "XDP requires MTU less than %lu\n", max_sz);
+		netdev_warn(dev, "XDP requires MTU less than %u\n", max_sz);
 		return -EINVAL;
 	}
 
-- 
2.19.1.6.gb485710b

