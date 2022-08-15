Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480EA5951FE
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 07:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbiHPF2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 01:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbiHPF1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 01:27:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB174CE16
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 15:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660600843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0Woc1p74LnDMz9TXkvyQIlZ2BlUNGXfNgs76Y3D9lgg=;
        b=D7V4RiBI/pfDwGyUESH50z/jt2lPEedE44Uij4syI+LjHM2XF64Isnp9+tnGyHYRJCgSgf
        FQWfJfAFIxAxSMSolLK5c+YKe6MnSjfCedtWiA0e1pCnOsRyou1iIdkXbwwZOLI2PBcGQ4
        6+htoKh7m2Z6wD9zj6B1qkDPAC+d5BA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-301-bSf1DEYvNOiOmCmQmTboQw-1; Mon, 15 Aug 2022 18:00:42 -0400
X-MC-Unique: bSf1DEYvNOiOmCmQmTboQw-1
Received: by mail-wm1-f72.google.com with SMTP id c17-20020a7bc011000000b003a2bfaf8d3dso4085303wmb.0
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 15:00:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=0Woc1p74LnDMz9TXkvyQIlZ2BlUNGXfNgs76Y3D9lgg=;
        b=ofEBjK2Tc1reOOMuoh5piqV1X4H9tBn/tIOQkib5la3RBBkPHDhjAMu98lgxhn/5EE
         uhaU9xtOaziYwI57vhmPFP3n3N8lvVt7dOuaD/pzUKWyFYIwQiRlELpwEfbzAx//3d5y
         gDT54OkCNFCeaYE0pyIozF3W4AwIFriyntgia5ibXkPc8pyj3yUjHzZExWG1Gnk+TH8G
         KL9HUadJRcgl0qjzt487sLBO0y0sp1KfOermx9VdTAQpHRCqEcOvNJQJqO6l9iHgy78i
         o0+IFfGOnlfxfMi4ShQGjpiLoKzkMKcy65XL4tSyXZr3ZOpZcBrae173Gw3NWEh++8mU
         hi5A==
X-Gm-Message-State: ACgBeo0xnaXye1x060uFdL2C/GzC0ZehkNWOuXDJbDNRoTPilh0IAlGI
        LdDiODRp/1fSbHEt++33E7kGRVit50B+JJJ4lC+Pw70scCVLEYpoISNu2cRJpZtpP22QAnq7HNm
        9vkPhWL1uNRgd5jq6
X-Received: by 2002:a5d:4705:0:b0:21f:3890:8619 with SMTP id y5-20020a5d4705000000b0021f38908619mr9636843wrq.104.1660600839849;
        Mon, 15 Aug 2022 15:00:39 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5NxSuUyDWQq7UInnZ68N9WtAPaKK7deSifgf1qRjxa6/C2abrrgR1eXC9qHiVHNg4n83AbHg==
X-Received: by 2002:a5d:4705:0:b0:21f:3890:8619 with SMTP id y5-20020a5d4705000000b0021f38908619mr9636823wrq.104.1660600839647;
        Mon, 15 Aug 2022 15:00:39 -0700 (PDT)
Received: from redhat.com ([2.55.43.215])
        by smtp.gmail.com with ESMTPSA id a16-20020a056000051000b00223b8168b15sm8326754wrf.66.2022.08.15.15.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 15:00:39 -0700 (PDT)
Date:   Mon, 15 Aug 2022 18:00:36 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v3 3/5] virtio-mmio: Revert "virtio_mmio: support the arg
 sizes of find_vqs()"
Message-ID: <20220815215938.154999-4-mst@redhat.com>
References: <20220815215938.154999-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815215938.154999-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit fbed86abba6e0472d98079790e58060e4332608a.
The API is now unused, let's not carry dead code around.

Fixes: fbed86abba6e ("virtio_mmio: support the arg sizes of find_vqs()")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_mmio.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index c492a57531c6..dfcecfd7aba1 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -360,7 +360,7 @@ static void vm_synchronize_cbs(struct virtio_device *vdev)
 
 static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int index,
 				  void (*callback)(struct virtqueue *vq),
-				  const char *name, u32 size, bool ctx)
+				  const char *name, bool ctx)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
 	struct virtio_mmio_vq_info *info;
@@ -395,11 +395,8 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 		goto error_new_virtqueue;
 	}
 
-	if (!size || size > num)
-		size = num;
-
 	/* Create the vring */
-	vq = vring_create_virtqueue(index, size, VIRTIO_MMIO_VRING_ALIGN, vdev,
+	vq = vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN, vdev,
 				 true, true, ctx, vm_notify, callback, name);
 	if (!vq) {
 		err = -ENOMEM;
@@ -503,7 +500,6 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		}
 
 		vqs[i] = vm_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
-				     sizes ? sizes[i] : 0,
 				     ctx ? ctx[i] : false);
 		if (IS_ERR(vqs[i])) {
 			vm_del_vqs(vdev);
-- 
MST

