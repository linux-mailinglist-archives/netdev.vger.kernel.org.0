Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C760B59549D
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiHPILI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbiHPIKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:10:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7947CFC7
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 22:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660628194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bnInJhTNmcRkk5WIZQp/adh2w/55qWjBovtngHxo1PM=;
        b=UnFnQdMICe1ph6hMhcpXCBN7MH3SirA2KSLaEpMhTQIRzV0XniY9JuNe1pxVDA37WECcKN
        ZLqnHxKm6pTMOwW47nPXzSy59MmW8bp/xadJFiEAB7Rlhvc+xHKDsT6q6fqH/a2cfDaP8z
        t0uPS+xh5Thpcz7gXpAYoNZIKfzpPXY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-232-iL0TFDtDMy-ynr3l-RmLtQ-1; Tue, 16 Aug 2022 01:36:33 -0400
X-MC-Unique: iL0TFDtDMy-ynr3l-RmLtQ-1
Received: by mail-wm1-f70.google.com with SMTP id b4-20020a05600c4e0400b003a5a96f1756so9752743wmq.0
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 22:36:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=bnInJhTNmcRkk5WIZQp/adh2w/55qWjBovtngHxo1PM=;
        b=TIdNPQ/HG23qBiXMV5OwjDAr618lpDZtY98CMmEvfKdNhMTMXr92+bBMvNTQ/EsDzp
         aKmuvaHPte0h6nowL8arbCkFqX7Ke5wHS982cpZWsAWjguz84OigU7eDHzoOgvW+mdhb
         SICFay0Sx5s+XnYrYGT2uqBylrmwMe6VJnk56grt4ZWiNNDFN+Hxw8Frni2DUG66CP/f
         urs8LrrCc5sOizrhy82ejDQvlDV1AD4ycNbrBfdVEuFZHmuYLo2fuk8awRQ1WB2pI1a+
         md/29i630V1Th13dlTe1u2PYWPuJpAXlcDpYtiMqQSrtCbJly6WLNAk94otrffGsgICJ
         2xtQ==
X-Gm-Message-State: ACgBeo0ySztUkAIX520YyVs6acuj2vXgz+dEcK+pUGxxf4AilGa0mrIk
        wafZkxjlLfDfpwm6ksplfj3JUEm4fvqk7P0G5ydOaX8Yhd2/8Mn4i82Ped4Rfm/fclzzzgJEA9e
        V0Mlhkk+ajqPhaLUv
X-Received: by 2002:a05:6000:1188:b0:220:6c20:fbf6 with SMTP id g8-20020a056000118800b002206c20fbf6mr10766512wrx.372.1660628192107;
        Mon, 15 Aug 2022 22:36:32 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4EkqFgvn7hB2RJJpvVWV5jJVrRGEU1rfoAnhvs4XogqkEgf0eN7zdUfJbZFDbhzDt1P9Tkdg==
X-Received: by 2002:a05:6000:1188:b0:220:6c20:fbf6 with SMTP id g8-20020a056000118800b002206c20fbf6mr10766495wrx.372.1660628191855;
        Mon, 15 Aug 2022 22:36:31 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id bg1-20020a05600c3c8100b003a317ee3036sm12197295wmb.2.2022.08.15.22.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 22:36:31 -0700 (PDT)
Date:   Tue, 16 Aug 2022 01:36:27 -0400
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
Subject: [PATCH v4 2/6] virtio: Revert "virtio: add helper
 virtio_find_vqs_ctx_size()"
Message-ID: <20220816053602.173815-3-mst@redhat.com>
References: <20220816053602.173815-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816053602.173815-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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

