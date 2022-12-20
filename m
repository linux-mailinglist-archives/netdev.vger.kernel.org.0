Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1015665222B
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 15:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbiLTOPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 09:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbiLTOO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 09:14:56 -0500
Received: from out30-6.freemail.mail.aliyun.com (out30-6.freemail.mail.aliyun.com [115.124.30.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FB9E19;
        Tue, 20 Dec 2022 06:14:55 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VXlw2Sp_1671545692;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VXlw2Sp_1671545692)
          by smtp.aliyun-inc.com;
          Tue, 20 Dec 2022 22:14:52 +0800
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
Subject: [PATCH v2 2/9] virtio_net: set up xdp for multi buffer packets
Date:   Tue, 20 Dec 2022 22:14:42 +0800
Message-Id: <20221220141449.115918-3-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20221220141449.115918-1-hengqi@linux.alibaba.com>
References: <20221220141449.115918-1-hengqi@linux.alibaba.com>
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
But for single-buffer xdp, we should keep checking for MTU.

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 443aa7b8f0ad..c5c4e9db4ed3 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3095,8 +3095,8 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		return -EINVAL;
 	}
 
-	if (dev->mtu > max_sz) {
-		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
+	if (prog && !prog->aux->xdp_has_frags && dev->mtu > max_sz) {
+		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP without frags");
 		netdev_warn(dev, "XDP requires MTU less than %lu\n", max_sz);
 		return -EINVAL;
 	}
-- 
2.19.1.6.gb485710b

