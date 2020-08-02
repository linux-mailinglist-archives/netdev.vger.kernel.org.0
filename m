Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8082354FE
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 05:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgHBDlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 23:41:51 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:53699 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbgHBDlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 23:41:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=wenan.mao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0U4S33z6_1596339685;
Received: from VM20200710-3.tbsite.net(mailfrom:wenan.mao@linux.alibaba.com fp:SMTPD_---0U4S33z6_1596339685)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 02 Aug 2020 11:41:37 +0800
From:   Mao Wenan <wenan.mao@linux.alibaba.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Mao Wenan <wenan.mao@linux.alibaba.com>
Subject: [PATCH -next] virtio_net: Avoid loop in virtnet_poll
Date:   Sun,  2 Aug 2020 11:41:23 +0800
Message-Id: <1596339683-117617-1-git-send-email-wenan.mao@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The loop may exist if vq->broken is true,
virtqueue_get_buf_ctx_packed or virtqueue_get_buf_ctx_split
will return NULL, so virtnet_poll will reschedule napi to
receive packet, it will lead cpu usage(si) to 100%.

call trace as below:
virtnet_poll
	virtnet_receive
		virtqueue_get_buf_ctx
			virtqueue_get_buf_ctx_packed
			virtqueue_get_buf_ctx_split
	virtqueue_napi_complete
		virtqueue_napi_schedule //it will reschedule napi

Signed-off-by: Mao Wenan <wenan.mao@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ba38765..a058da1 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -327,7 +327,8 @@ static void virtqueue_napi_complete(struct napi_struct *napi,
 
 	opaque = virtqueue_enable_cb_prepare(vq);
 	if (napi_complete_done(napi, processed)) {
-		if (unlikely(virtqueue_poll(vq, opaque)))
+		if (unlikely(virtqueue_poll(vq, opaque)) &&
+		    unlikely(!virtqueue_is_broken(vq)))
 			virtqueue_napi_schedule(napi, vq);
 	} else {
 		virtqueue_disable_cb(vq);
-- 
1.8.3.1

