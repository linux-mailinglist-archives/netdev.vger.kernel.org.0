Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094314E3C94
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 11:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbiCVKkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 06:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbiCVKkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 06:40:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10A375AA5F
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 03:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647945516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VkoZGCDazaob935cf0K6/xqwp1grV8y7vA1EUagsdw8=;
        b=CXZUZIISL19ZPcrKNiw1uktdfJJltoX+O5e0iWZUNkMrx7VXY9YyKDn1nux9C86FznBE0Y
        nhP8UUh6SFJVKM15phBho9H5PVSdIRhsfOAYFs7BPU3FA/R+Vo2CiAGjgKCosVEfUKvODZ
        /LnkHvblfQJxe1Y7mS4N+evqWkwcCbY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-AWZYyJtoOjSM-QMHP2wg1g-1; Tue, 22 Mar 2022 06:38:35 -0400
X-MC-Unique: AWZYyJtoOjSM-QMHP2wg1g-1
Received: by mail-qk1-f199.google.com with SMTP id z10-20020a05620a08ca00b0067d341e82edso11462095qkz.17
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 03:38:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VkoZGCDazaob935cf0K6/xqwp1grV8y7vA1EUagsdw8=;
        b=GLY5h2800GTBkxSL+VB6oWAuE55AeKz+XxQzkFbojwTuNJ3LXTAG1uUl6kDPDdNbIZ
         /M8H/djxKrkwb6knNgqji5zerHk5jYT8fXMzQ5DfJmvvpP3QBimiva7AAmiuTH2C9Y8G
         vXFkhraSNa0O/O2SpocdomrcO8Jc/3OOpEMdrlVjX9xW54enEWGxo2k5nbkF3eLRvNNT
         v91x2dRbmTvwiuySfDKNJDsy0Vzu+O8oUL7vtmn98/PoK1XMHZUMRAd/vW3tQonfRJ92
         5znslQiQxQpcLd/eFxjjAogf+Qbj60e8AQq5TZ0uYf+apktbtPQd6SFB/duASP4Ib6YI
         Q1Wg==
X-Gm-Message-State: AOAM531Iafhgnkjx5kn5WbPwK5McelFEj6EaV0eWV9b2v8qn8/qE3yMQ
        V2T4dq6qdkfBylJLBs62BY5eQRt1/rTqOyd4Sz1VdDOFXX7E5UHmM7koNRvS6VK6aTV6IFY1pH5
        jirgKjQJAOGimdBesVHK/AYAUpiRsy6sqVaCzVs9YQSHyjB7UVnpZuBuKPsQgRUQDUCdB
X-Received: by 2002:a05:6214:29ca:b0:441:1f8c:e58d with SMTP id gh10-20020a05621429ca00b004411f8ce58dmr7306567qvb.111.1647945514123;
        Tue, 22 Mar 2022 03:38:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4XnbEotBgwmm8Kokd0VkMAvlrSAfcDAHK9dNDeWtrOWpekkIQX4QyQevtVagOHVlC3sFqKg==
X-Received: by 2002:a05:6214:29ca:b0:441:1f8c:e58d with SMTP id gh10-20020a05621429ca00b004411f8ce58dmr7306547qvb.111.1647945513838;
        Tue, 22 Mar 2022 03:38:33 -0700 (PDT)
Received: from step1.redhat.com ([87.12.25.114])
        by smtp.gmail.com with ESMTPSA id q123-20020a378e81000000b0067eb3d6f605sm1532443qkd.0.2022.03.22.03.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 03:38:33 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Asias He <asias@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH net] vsock/virtio: enable VQs early on probe
Date:   Tue, 22 Mar 2022 11:38:23 +0100
Message-Id: <20220322103823.83411-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtio spec requires drivers to set DRIVER_OK before using VQs.
This is set automatically after probe returns, but virtio-vsock
driver uses VQs in the probe function to fill rx and event VQs
with new buffers.

Let's fix this, calling virtio_device_ready() before using VQs
in the probe function.

Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 5afc194a58bb..b1962f8cd502 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -622,6 +622,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
 	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
 
+	virtio_device_ready(vdev);
+
 	mutex_lock(&vsock->tx_lock);
 	vsock->tx_run = true;
 	mutex_unlock(&vsock->tx_lock);
-- 
2.35.1

