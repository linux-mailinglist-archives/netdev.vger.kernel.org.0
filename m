Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBAD5653C09
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 07:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbiLVGGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 01:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235085AbiLVGGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 01:06:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A951B1D2
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 22:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671689092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1rTeZDLahEEUIQy4wMRthdfJbzV+lOwcoNI4SggfJI8=;
        b=R62w4ImgynvjYrO7IgrIDcR2VDtZpEl+S4+8iqDsFZkGlcVbBS7eMDSJGc6NS3QAVxjW6+
        DPXzl5TiHAd6nmPvsm0E29IkXV1mRJkfx8jqT2nSB1lfW3vcSz042Kes0u94WxrmrO/Y2M
        vZsaudRsAAVF4kofjO1/fGuFdUFJ+UI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-V2twCnI5NIurCMkSOvZAzQ-1; Thu, 22 Dec 2022 01:04:49 -0500
X-MC-Unique: V2twCnI5NIurCMkSOvZAzQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB30A29ABA2B;
        Thu, 22 Dec 2022 06:04:48 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-179.pek2.redhat.com [10.72.13.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48B21112132C;
        Thu, 22 Dec 2022 06:04:43 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: [RFC PATCH 2/4] virtio_ring: switch to use BAD_RING()
Date:   Thu, 22 Dec 2022 14:04:25 +0800
Message-Id: <20221222060427.21626-3-jasowang@redhat.com>
In-Reply-To: <20221222060427.21626-1-jasowang@redhat.com>
References: <20221222060427.21626-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch to reuse BAD_RING() to allow common logic to be implemented in
BAD_RING().

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 2e7689bb933b..90c2034a77f3 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2237,7 +2237,7 @@ bool virtqueue_notify(struct virtqueue *_vq)
 
 	/* Prod other side to tell it about changes. */
 	if (!vq->notify(_vq)) {
-		vq->broken = true;
+		BAD_RING(vq, "vq %d is broken\n", vq->vq.index);
 		return false;
 	}
 	return true;
-- 
2.25.1

