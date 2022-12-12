Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F07649AC6
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 10:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiLLJLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 04:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbiLLJLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 04:11:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E897671
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 01:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670836239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=js5jlF3yTN3u8DK/CNDR5RCWPJzXAeH4KJeogte/M2c=;
        b=fQbJEVuXs6zOX1A+HXNomLbQPw4h+/PVnCZ+15LVm9qgjIgTDRuW1zI8BNQUFIaokN8wv+
        7y75CmyiLQL+4YoiE6TxJ94xrWqqrgTfikjatxj1Oh4WdH36I3v5g/T7x7POLmmCUp2/Ft
        XA3duokg1ObVk55oStwm4bYSa79MBsM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-RVzAPNIxNYiHJkzms2wBpw-1; Mon, 12 Dec 2022 04:10:36 -0500
X-MC-Unique: RVzAPNIxNYiHJkzms2wBpw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0159B81173A;
        Mon, 12 Dec 2022 09:10:36 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-186.pek2.redhat.com [10.72.12.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3082B2166B26;
        Mon, 12 Dec 2022 09:10:31 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] virtio-net: correctly enable callback during start_xmit
Date:   Mon, 12 Dec 2022 17:10:29 +0800
Message-Id: <20221212091029.54390-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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

This will cause a missing call to virtqueue_enable_cb_delayed() when
kick is false. Fixing this by removing the checking of the kick from
the condition to make sure callback is enabled correctly.

Fixes: a7766ef18b33 ("virtio_net: disable cb aggressively")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
The patch is needed for -stable.
---
 drivers/net/virtio_net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 86e52454b5b5..44d7daf0267b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1834,8 +1834,8 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		free_old_xmit_skbs(sq, false);
 
-	} while (use_napi && kick &&
-	       unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
+	} while (use_napi &&
+		 unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
 
 	/* timestamp packet in software */
 	skb_tx_timestamp(skb);
-- 
2.25.1

