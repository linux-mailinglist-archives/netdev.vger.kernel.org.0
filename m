Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F64A5A0BF6
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbiHYI4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiHYI4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:56:18 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FCAA3D15;
        Thu, 25 Aug 2022 01:56:16 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=kangjie.xu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VNCZWjK_1661417770;
Received: from localhost(mailfrom:kangjie.xu@linux.alibaba.com fp:SMTPD_---0VNCZWjK_1661417770)
          by smtp.aliyun-inc.com;
          Thu, 25 Aug 2022 16:56:11 +0800
From:   Kangjie Xu <kangjie.xu@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org
Cc:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, hengqi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com
Subject: [PATCH] vhost-net: support VIRTIO_F_RING_RESET
Date:   Thu, 25 Aug 2022 16:56:10 +0800
Message-Id: <20220825085610.80315-1-kangjie.xu@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add VIRTIO_F_RING_RESET, which indicates that the driver can reset a
queue individually.

VIRTIO_F_RING_RESET feature is added to virtio-spec 1.2. The relevant
information is in
    oasis-tcs/virtio-spec#124
    oasis-tcs/virtio-spec#139

The implementation only adds the feature bit in supported features. It
does not require any other changes because we reuse the existing vhost
protocol.

The virtqueue reset process can be concluded as two parts:
1. The driver can reset a virtqueue. When it is triggered, we use the
set_backend to disable the virtqueue.
2. After the virtqueue is disabled, the driver may optionally re-enable
it. The process is basically similar to when the device is started,
except that the restart process does not need to set features and set
mem table since they do not change. QEMU will send messages containing
size, base, addr, kickfd and callfd of the virtqueue in order.
Specifically, the host kernel will receive these messages in order:
    a. VHOST_SET_VRING_NUM
    b. VHOST_SET_VRING_BASE
    c. VHOST_SET_VRING_ADDR
    d. VHOST_SET_VRING_KICK
    e. VHOST_SET_VRING_CALL
    f. VHOST_NET_SET_BACKEND
Finally, after we use set_backend to attach the virtqueue, the virtqueue
will be enabled and start to work.

Signed-off-by: Kangjie Xu <kangjie.xu@linux.alibaba.com>
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---

Test environment and method:
    Host: 5.19.0-rc3
    Qemu: QEMU emulator version 7.0.50 (With vq rset support)
    Guest: 5.19.0-rc3 (With vq reset support)
    Test Cmd: ethtool -g eth1; ethtool -G eth1 rx $1 tx $2; ethtool -g eth1;

    The drvier can resize the virtio queue, then virtio queue reset function should
    be triggered.

    The default is split mode, modify Qemu virtio-net to add PACKED feature to 
    test packed mode.

Guest Kernel Patch:
    https://lore.kernel.org/bpf/20220801063902.129329-1-xuanzhuo@linux.alibaba.com/

QEMU Patch:
    https://lore.kernel.org/qemu-devel/cover.1661414345.git.kangjie.xu@linux.alibaba.com/

Looking forward to your review and comments. Thanks.

 drivers/vhost/net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 68e4ecd1cc0e..8a34928d4fef 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -73,7 +73,8 @@ enum {
 	VHOST_NET_FEATURES = VHOST_FEATURES |
 			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
 			 (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
-			 (1ULL << VIRTIO_F_ACCESS_PLATFORM)
+			 (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
+			 (1ULL << VIRTIO_F_RING_RESET)
 };
 
 enum {
-- 
2.32.0

