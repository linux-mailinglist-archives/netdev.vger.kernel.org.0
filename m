Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0973E4E4E9F
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 09:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242974AbiCWIv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 04:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242922AbiCWIvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 04:51:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92D6375612
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 01:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648025413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OgA1lCzF0b4XjouCMdWAekLZD2KK/T/B0hpIucmcAvY=;
        b=G5g9aOuf91AvVT5T+uTTLilDIoUbYLjkjJyV0aEyoY86InI8mu2COGfW6Lts7fodtXw1fw
        fAzaEEytZS1m/XFjHZgYYD+xfXn541bVsgzus1C0gz2NZWSf+mgCGla5SgWLOcbNdzKIXa
        nbHFNrkOclqwR9holmYgd2xNj/an2N4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-FyLfmTXlMUuWjGe8kbTVRQ-1; Wed, 23 Mar 2022 04:50:12 -0400
X-MC-Unique: FyLfmTXlMUuWjGe8kbTVRQ-1
Received: by mail-qv1-f69.google.com with SMTP id 33-20020a0c8024000000b0043d17ffb0bdso739383qva.18
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 01:50:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OgA1lCzF0b4XjouCMdWAekLZD2KK/T/B0hpIucmcAvY=;
        b=L6DY6mGVcEw8aQX5Ogx8aInnG0J2s2xjQhM1nWicAx+FLsC25X48mKHdwW/5jcliCa
         zcPAPG2LzXvS6K+ksj/KoRAe5yZzLrbnfZXRlJzKrHVC8pH1SvTqlwYNYrHLKX7JZCcL
         eR/qyBnq3PLzzHj5ml2daIjka2gBxSpQ1OwrLVcJxxnuIxbX9Z8QOwwkndmYhZldZpEF
         fXmVE6YzZKvSXFHkOMmCJrkQB/asR1+QcJzq5Zhs5jEzA3WQMAD7s2oXTifp+JTcBYpn
         8tvP01Rp3azLUf7X/C2lhCDI5RBd8dFbSZYvY6S3xdrwkfcQxdNpoBR4w9aQuujsZqsZ
         Jq7w==
X-Gm-Message-State: AOAM532+pMUdmDt250o7pa+b883bnDMPESRj83QRJzLZZtAon9MpgEwL
        qZhGZs/wMuylYZLU1TzPHY6fq7eQs08Z4lBWjDvUMzR2kai2aUSpVna/LVpMv+wXz/KxFXJSAJ3
        hteYHO5/5cwrD91xAt+51CmmIM9IMvvVTVZAgg70ucxZmC2EhQaykz8qEnsV+P6hF0+IQ
X-Received: by 2002:a05:620a:370a:b0:67d:5f35:900f with SMTP id de10-20020a05620a370a00b0067d5f35900fmr17592018qkb.767.1648025411660;
        Wed, 23 Mar 2022 01:50:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzyPK4ZKA2MkSsVUsQecAaz7gloEHvd5w3N1Q/3d1hjdf5Wr4EaGY3ikaTT6b++I1clHGznQ==
X-Received: by 2002:a05:620a:370a:b0:67d:5f35:900f with SMTP id de10-20020a05620a370a00b0067d5f35900fmr17591997qkb.767.1648025411363;
        Wed, 23 Mar 2022 01:50:11 -0700 (PDT)
Received: from step1.redhat.com (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id j188-20020a3755c5000000b0067d1c76a09fsm10640609qkb.74.2022.03.23.01.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 01:50:10 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 3/3] vsock/virtio: read the negotiated features before using VQs
Date:   Wed, 23 Mar 2022 09:49:54 +0100
Message-Id: <20220323084954.11769-4-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323084954.11769-1-sgarzare@redhat.com>
References: <20220323084954.11769-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Complete the driver configuration, reading the negotiated features,
before using the VQs and tell the device that the driver is ready in
the virtio_vsock_probe().

Fixes: 53efbba12cc7 ("virtio/vsock: enable SEQPACKET for transport")
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index fff67ad39087..1244e7cf585b 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -622,6 +622,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
 	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
 
+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
+		vsock->seqpacket_allow = true;
+
 	vdev->priv = vsock;
 	virtio_device_ready(vdev);
 
@@ -639,9 +642,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	vsock->event_run = true;
 	mutex_unlock(&vsock->event_lock);
 
-	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
-		vsock->seqpacket_allow = true;
-
 	rcu_assign_pointer(the_virtio_vsock, vsock);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
-- 
2.35.1

