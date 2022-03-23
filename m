Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DB54E57AF
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343699AbiCWRid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343654AbiCWRiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:38:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B5A38021C
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 10:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648057005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xWGdi1UqdjNcgIoNh0luPYt8s0RItagontqZa8O7xH4=;
        b=DNWJKdZiCyrL5IIAvSeVGoH5AkolypKMjOjAedZiKbeaQuQXDZF7I6lZN4P5jMiMnup0C0
        iYCDw3FrKxsfuCs9oFV8YgEy7G9z+cKJCwnfcsVJh5F4KW/wRL0lcKQNW0s+QzbiA3wKlF
        ynyht0H8sDHgikusV77QxtwxrHmxOJA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-Kcgvw4BUNq6RqRFo_ao2aw-1; Wed, 23 Mar 2022 13:36:44 -0400
X-MC-Unique: Kcgvw4BUNq6RqRFo_ao2aw-1
Received: by mail-qv1-f72.google.com with SMTP id fw9-20020a056214238900b0043522aa5b81so1749032qvb.21
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 10:36:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xWGdi1UqdjNcgIoNh0luPYt8s0RItagontqZa8O7xH4=;
        b=MMHvFbgM/IZWaKKyLUVWmc0UDf3WY418jdg02zVSUuKyvOMra2fDcSbVhpdkJGrik5
         uqv1ypKYKe5QT6QyiTeam21QxCapitjMkCzlSv8v/2tT7AgYESKIyyH8e3v9hVv1NXZP
         5eizCTn6WBABaw63jtQtmQgdrcxhtwmXI4IIqKoRU9SRBQiK7oGbXRe+ELzoOBTVcLq/
         i1UatPBa4TCv8FLiLLlclJ8w0e/9rhgzM5ve4jQRQSEQLDLLGdAARG2nt1epDG/kXCzs
         KmVDo068SYg0I5Q/y76EYaf2eBsNItd3cl8thVLFPtJvprBxm1KJZZi18Vy0VEODwxEF
         Cw+w==
X-Gm-Message-State: AOAM533bIwkngBLd77A56auro+1S/dAdiF37+AAikwbOdQhcBK2tlDDi
        W/5yKMpjtjA3OoHBv91X8VmZPhkj/QhJMGL8mRH1fShe7h9dBiDl6B4uu0FDis/xIm+r/IlpdNI
        /LRYkgs0rj9ot79yumSEPW4yixaR9r8sJX9AOhOo146PapfvlaCIinpZAQzt7FKBBvoaH
X-Received: by 2002:ac8:5dcf:0:b0:2e1:baf1:502d with SMTP id e15-20020ac85dcf000000b002e1baf1502dmr806279qtx.635.1648057003109;
        Wed, 23 Mar 2022 10:36:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTpPllZkLf2utvzNGXglhcnTlOLeIMc4F/54ZX4LmPDik4Rh6CKZ6+/p5IKQ52dEZjvQk8DA==
X-Received: by 2002:ac8:5dcf:0:b0:2e1:baf1:502d with SMTP id e15-20020ac85dcf000000b002e1baf1502dmr806235qtx.635.1648057002476;
        Wed, 23 Mar 2022 10:36:42 -0700 (PDT)
Received: from step1.redhat.com (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id h14-20020a05622a170e00b002e1a65754d8sm476127qtk.91.2022.03.23.10.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 10:36:41 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net v3 3/3] vsock/virtio: enable VQs early on probe
Date:   Wed, 23 Mar 2022 18:36:25 +0100
Message-Id: <20220323173625.91119-4-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323173625.91119-1-sgarzare@redhat.com>
References: <20220323173625.91119-1-sgarzare@redhat.com>
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
index 3954d3be9083..ba1c8cc0c467 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -627,6 +627,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 
 	vdev->priv = vsock;
 
+	virtio_device_ready(vdev);
+
 	mutex_lock(&vsock->tx_lock);
 	vsock->tx_run = true;
 	mutex_unlock(&vsock->tx_lock);
-- 
2.35.1

