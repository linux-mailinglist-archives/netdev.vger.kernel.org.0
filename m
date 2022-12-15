Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEAE964D58E
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 04:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiLOD21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 22:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLOD2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 22:28:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AA54B988
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 19:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671074855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PymI4q7qNfGWX3YIwL6NoS6LPNMzpnl2I9EurJsvLII=;
        b=OkxoJDg19C+J0xqjjUAD4LFSlCwHy718gVr2UeXgFpEwrU+0Y1hEJGLTSSVCSklxXuLQq2
        oSqGCQ5i4WYnDMlAgaSXEOA5aoZYjCVkXctAgYKKHc+cIQXixEacRBeCvPuDA3jbptlMTl
        6nQquf2ACxjNFV/Ex87jg4TbKmTm8no=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-kma6sXGIOKKmlWPHWJxdxw-1; Wed, 14 Dec 2022 22:27:32 -0500
X-MC-Unique: kma6sXGIOKKmlWPHWJxdxw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47D081C02D47;
        Thu, 15 Dec 2022 03:27:32 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-112.pek2.redhat.com [10.72.12.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18DC1C15BA0;
        Thu, 15 Dec 2022 03:27:21 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com
Subject: [PATCH net V2] virtio-net: correctly enable callback during start_xmit
Date:   Thu, 15 Dec 2022 11:27:19 +0800
Message-Id: <20221215032719.72294-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a7766ef18b33("virtio_net: disable cb aggressively") enables
virtqueue callback via the following statement:

        do {
           ......
	} while (use_napi && kick &&
               unlikely(!virtqueue_enable_cb_delayed(sq->vq)));

When NAPI is used and kick is false, the callback won't be enabled
here. And when the virtqueue is about to be full, the tx will be
disabled, but we still don't enable tx interrupt which will cause a TX
hang. This could be observed when using pktgen with burst enabled.

Fixing this by trying to enable tx interrupt after we disable TX when
we're not using napi or kick is false.

Fixes: a7766ef18b33 ("virtio_net: disable cb aggressively")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
The patch is needed for -stable.
Changes since V1:
- enable tx interrupt after we disable tx
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 86e52454b5b5..dcf3a536d78a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1873,7 +1873,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	 */
 	if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
 		netif_stop_subqueue(dev, qnum);
-		if (!use_napi &&
+		if ((!use_napi || !kick) &&
 		    unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
 			/* More just got used, free them then recheck. */
 			free_old_xmit_skbs(sq, false);
-- 
2.25.1

