Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C1B4D17EE
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 13:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343757AbiCHMjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 07:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244331AbiCHMhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 07:37:39 -0500
Received: from out199-13.us.a.mail.aliyun.com (out199-13.us.a.mail.aliyun.com [47.90.199.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B1D48395;
        Tue,  8 Mar 2022 04:36:11 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0V6eC9VZ_1646742964;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6eC9VZ_1646742964)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Mar 2022 20:36:05 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v7 21/26] virtio: add helper virtio_find_vqs_ctx_size()
Date:   Tue,  8 Mar 2022 20:35:13 +0800
Message-Id: <20220308123518.33800-22-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: f06b131dbfed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce helper virtio_find_vqs_ctx_size() to call find_vqs and specify
the maximum size of each vq ring.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 include/linux/virtio_config.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 5157524d8036..921d8610db0c 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -233,6 +233,18 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev, unsigned nvqs,
 				      desc, NULL);
 }
 
+static inline
+int virtio_find_vqs_ctx_size(struct virtio_device *vdev, u32 nvqs,
+				 struct virtqueue *vqs[],
+				 vq_callback_t *callbacks[],
+				 const char * const names[],
+				 const bool *ctx, struct irq_affinity *desc,
+				 u32 sizes[])
+{
+	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, ctx,
+				      desc, sizes);
+}
+
 /**
  * virtio_reset_vq - reset a queue individually
  * @vq: the virtqueue
-- 
2.31.0

