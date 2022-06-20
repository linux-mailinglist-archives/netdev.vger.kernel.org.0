Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6EF2550F99
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 07:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238207AbiFTFLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 01:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiFTFLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 01:11:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 904796348
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 22:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655701889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WXLW3+agLCoG9Abz/TU9WLAHFBCNkp7xho+9kboqnkk=;
        b=LGTvufcY9CkX+pUZfYpoOqry8LqgEjIh7NfuSTc1lA23hZZSk0WmsGExNMjJ1XGPYWibeL
        wKMh3YVtbJTiU8cmtyRnJ6OKbMNOhZXNdUNCeLOpIAP9fskP0R6kqEqrspaVoARMfKyWGL
        aFIOP0YTFUgRVezafRSYIiU8hTdTm4Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-8rTneW3jOrSfNcgdM2ikCg-1; Mon, 20 Jun 2022 01:11:25 -0400
X-MC-Unique: 8rTneW3jOrSfNcgdM2ikCg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA14B3816853;
        Mon, 20 Jun 2022 05:11:24 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-16.pek2.redhat.com [10.72.12.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7209C28112;
        Mon, 20 Jun 2022 05:11:21 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org, erwan.yvin@stericsson.com
Subject: [PATCH 1/3] caif_virtio: remove virtqueue_disable_cb() in probe
Date:   Mon, 20 Jun 2022 13:11:13 +0800
Message-Id: <20220620051115.3142-2-jasowang@redhat.com>
In-Reply-To: <20220620051115.3142-1-jasowang@redhat.com>
References: <20220620051115.3142-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This disabling is a just a hint with best effort, there's no guarantee
that device doesn't send notification. The driver should survive with
that, so let's remove it.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/caif/caif_virtio.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index 5458f57177a0..c677ded81133 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -705,9 +705,6 @@ static int cfv_probe(struct virtio_device *vdev)
 	netdev->needed_headroom = cfv->tx_hr;
 	netdev->needed_tailroom = cfv->tx_tr;
 
-	/* Disable buffer release interrupts unless we have stopped TX queues */
-	virtqueue_disable_cb(cfv->vq_tx);
-
 	netdev->mtu = cfv->mtu - cfv->tx_tr;
 	vdev->priv = cfv;
 
-- 
2.25.1

