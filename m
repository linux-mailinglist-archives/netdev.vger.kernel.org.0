Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331F265222C
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 15:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbiLTOPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 09:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiLTOO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 09:14:57 -0500
Received: from out30-6.freemail.mail.aliyun.com (out30-6.freemail.mail.aliyun.com [115.124.30.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC010231;
        Tue, 20 Dec 2022 06:14:55 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VXlw2Sg_1671545691;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VXlw2Sg_1671545691)
          by smtp.aliyun-inc.com;
          Tue, 20 Dec 2022 22:14:51 +0800
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
Subject: [PATCH v2 1/9] virtio_net: disable the hole mechanism for xdp
Date:   Tue, 20 Dec 2022 22:14:41 +0800
Message-Id: <20221220141449.115918-2-hengqi@linux.alibaba.com>
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

XDP core assumes that the frame_size of xdp_buff and the length of
the frag are PAGE_SIZE. The hole may cause the processing of xdp to
fail, so we disable the hole mechanism when xdp is set.

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9cce7dec7366..443aa7b8f0ad 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1419,8 +1419,11 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
 		/* To avoid internal fragmentation, if there is very likely not
 		 * enough space for another buffer, add the remaining space to
 		 * the current buffer.
+		 * XDP core assumes that frame_size of xdp_buff and the length
+		 * of the frag are PAGE_SIZE, so we disable the hole mechanism.
 		 */
-		len += hole;
+		if (!headroom)
+			len += hole;
 		alloc_frag->offset += hole;
 	}
 
-- 
2.19.1.6.gb485710b

