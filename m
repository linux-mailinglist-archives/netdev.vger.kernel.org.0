Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A165951F9
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 07:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbiHPF1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 01:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbiHPF0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 01:26:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 52CA62EC
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 15:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660600838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bnInJhTNmcRkk5WIZQp/adh2w/55qWjBovtngHxo1PM=;
        b=EHiMupOJ2icYjOXVQ8sFxh3ko4sXMrIsr1zUjvxgs2aZ2xlNXKOVwuIbtfqcTrgo9pEjNB
        +9h++a7QLDe7Vq4zfaMRKjME/FqhPMgaBrWboaHEQrVlh2BvP96jVbtn13Za7qCsvvuiNj
        ZADl3pbeZ7R/Ve5a/OJ38NwC46IhjlQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-173-5iApdfH-M8KRTn1qNmjW7w-1; Mon, 15 Aug 2022 18:00:37 -0400
X-MC-Unique: 5iApdfH-M8KRTn1qNmjW7w-1
Received: by mail-wm1-f69.google.com with SMTP id z11-20020a05600c0a0b00b003a043991610so1585996wmp.8
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 15:00:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=bnInJhTNmcRkk5WIZQp/adh2w/55qWjBovtngHxo1PM=;
        b=Cuo4PzfxYQp/+7M++EvokVfG7dPCroR5KTnW3yul9rsNaBCilRTJsBDUP0MmjrptUu
         5txAgNAUt0SsNmtfxBzCbqU7YT2DSpsjUTfW+tmYit4eHfQog9KNjJzpi9GH1LSRJ/nV
         Ni3ODLK1sIAer+CP+SecjU/PLrzI3tw69QeYV2VnJPwuPJlzwjTPMpjbJ74ELeQsjgxC
         FZyTOTlzzfsPzbnQ0Nu4AbSWDetgzrQR8BSYnNgDWLSBasfdjUbXgbBKyE3vPzX3z6GZ
         B9WptW+XvyHH455DQrouljCgw7SWQMMtpzROEYNTPWTrVJxpQslU/8D++5xEysmqbzLl
         G6LQ==
X-Gm-Message-State: ACgBeo2WplEohbilKIXOvNZBnTfhrFrmDZXnatB8heFli01B3nPFcULn
        bwo80Jy4SrAXAkBh8VUP1fwPvrl3xdqITQ9kQ2opT54Ssi2K02mC+x5SuD2qCqBAK0t5YpRVuHC
        MiwNIraIlCqBOKDGy
X-Received: by 2002:adf:fe0d:0:b0:220:5df9:e5cf with SMTP id n13-20020adffe0d000000b002205df9e5cfmr10037592wrr.332.1660600836186;
        Mon, 15 Aug 2022 15:00:36 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7neOEEnsfPvVNfIdJ1DGmTNBVQIoh+gohySWeq1ab7WHyHnV34ZmbBICAeo695PHmm06CKHw==
X-Received: by 2002:adf:fe0d:0:b0:220:5df9:e5cf with SMTP id n13-20020adffe0d000000b002205df9e5cfmr10037579wrr.332.1660600835925;
        Mon, 15 Aug 2022 15:00:35 -0700 (PDT)
Received: from redhat.com ([2.55.43.215])
        by smtp.gmail.com with ESMTPSA id r187-20020a1c44c4000000b003a5f2cc2f1dsm6101446wma.42.2022.08.15.15.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 15:00:35 -0700 (PDT)
Date:   Mon, 15 Aug 2022 18:00:31 -0400
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
Subject: [PATCH v3 2/5] virtio: Revert "virtio: add helper
 virtio_find_vqs_ctx_size()"
Message-ID: <20220815215938.154999-3-mst@redhat.com>
References: <20220815215938.154999-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815215938.154999-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit fe3dc04e31aa51f91dc7f741a5f76cc4817eb5b4: the
API is now unused and in fact can't be implemented on top of a legacy
device.

Fixes: fe3dc04e31aa ("virtio: add helper virtio_find_vqs_ctx_size()")
Cc: "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio_config.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 6adff09f7170..888f7e96f0c7 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -241,18 +241,6 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev, unsigned nvqs,
 				      ctx, desc);
 }
 
-static inline
-int virtio_find_vqs_ctx_size(struct virtio_device *vdev, u32 nvqs,
-			     struct virtqueue *vqs[],
-			     vq_callback_t *callbacks[],
-			     const char * const names[],
-			     u32 sizes[],
-			     const bool *ctx, struct irq_affinity *desc)
-{
-	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, sizes,
-				      ctx, desc);
-}
-
 /**
  * virtio_synchronize_cbs - synchronize with virtqueue callbacks
  * @vdev: the device
-- 
MST

