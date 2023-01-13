Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A2D668FE3
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240678AbjAMIBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240759AbjAMIBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:01:15 -0500
Received: from out30-6.freemail.mail.aliyun.com (out30-6.freemail.mail.aliyun.com [115.124.30.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137246DB85;
        Fri, 13 Jan 2023 00:00:24 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VZU0KJz_1673596819;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VZU0KJz_1673596819)
          by smtp.aliyun-inc.com;
          Fri, 13 Jan 2023 16:00:19 +0800
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
Subject: [PATCH net-next v4 03/10] virtio-net: set up xdp for multi buffer packets
Date:   Fri, 13 Jan 2023 16:00:09 +0800
Message-Id: <20230113080016.45505-4-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230113080016.45505-1-hengqi@linux.alibaba.com>
References: <20230113080016.45505-1-hengqi@linux.alibaba.com>
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

When the xdp program sets xdp.frags, which means it can process
multi-buffer packets over larger MTU, so we continue to support xdp.

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 87226dd8d262..60e199811212 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3097,9 +3097,9 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		return -EINVAL;
 	}
 
-	if (dev->mtu > max_sz) {
-		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
-		netdev_warn(dev, "XDP requires MTU less than %lu\n", max_sz);
+	if (prog && !prog->aux->xdp_has_frags && dev->mtu > max_sz) {
+		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP without frags");
+		netdev_warn(dev, "single-buffer XDP requires MTU less than %u\n", max_sz);
 		return -EINVAL;
 	}
 
-- 
2.19.1.6.gb485710b

