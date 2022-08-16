Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B815954A8
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbiHPILi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbiHPIK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:10:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3E8366A71
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 22:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660628213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7gwPm9xDUr2cS5ofMDcan9qf7hv2F2NrtQxh7A5E41E=;
        b=RzNbCe2P5JyCsULdVvUvKo7xnwRw3oaoVCPwz5VYg8gPYrish+gZ4jzw2hJ8TiPoky69Qh
        9MiPgtLiURbWjtyYMmg4Hns/zmKobRdbrJ2n55hZsI+cmaAr/OnKS8Vn5nDPML6quhg59V
        l2O2trDmUsK4s6a0k5T3dbMAIah93xE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-283-4QBCfwugNoOQ9KUM5lpKSQ-1; Tue, 16 Aug 2022 01:36:52 -0400
X-MC-Unique: 4QBCfwugNoOQ9KUM5lpKSQ-1
Received: by mail-wm1-f69.google.com with SMTP id c189-20020a1c35c6000000b003a4bfb16d86so4469540wma.3
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 22:36:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=7gwPm9xDUr2cS5ofMDcan9qf7hv2F2NrtQxh7A5E41E=;
        b=vhR5+iop9vgbNqFrNrwVyheb05a3lx3Wq3fiby6O3S84bVWv43sXpUOOfytTWPd3JB
         rOnF+WQTPZwzAIzY+yU09NeTkJ9QJHkyppROPIW4AGi/KH7fqm+yGrSkwSBXji5aufta
         favXP0QUwSlg9blq3HaIMT3n01WpjXQZVb7R4EhIYOS3F6bNHzHktB8VzoO8CEd/6JPn
         VRlUJiPaiefF1RaewNfHTwonH/VI+Yn4GaUe4aGULEArl2yj5xEZ504HH5wTuT3wTv30
         ff4pk1XI0rNL4kHpyBGZmxLVV+g8m0KpMGzyUYN6byrPYGRSK4wXogXQx5TFHV9Xl75c
         Dlug==
X-Gm-Message-State: ACgBeo0lFJc4sDCv0oc9cECIBeOV9c7VzFeDnrtzjR2hhk+ELhtjOV0y
        41bePetSc97g3I8k+BF3ek3yPTGEYZ5rMr6vVS3KqlT4srttO6arZS1AsCCguIfc5C5TxNz5LzH
        E4Ss/79/6ukpZ5XZc
X-Received: by 2002:a5d:6d42:0:b0:220:7ab1:9da9 with SMTP id k2-20020a5d6d42000000b002207ab19da9mr10493841wri.403.1660628211235;
        Mon, 15 Aug 2022 22:36:51 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7d8A8k6M8JI6hmCoeeaJbBUK4Uy4I2ToLn096BssqGpPc9DKZ9IxX+tavz6eIPk8MWq4XyUg==
X-Received: by 2002:a5d:6d42:0:b0:220:7ab1:9da9 with SMTP id k2-20020a5d6d42000000b002207ab19da9mr10493798wri.403.1660628209524;
        Mon, 15 Aug 2022 22:36:49 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id by6-20020a056000098600b0021e571a99d5sm9163254wrb.17.2022.08.15.22.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 22:36:49 -0700 (PDT)
Date:   Tue, 16 Aug 2022 01:36:45 -0400
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
        Greg KH <gregkh@linuxfoundation.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH v4 5/6] virtio_vdpa: Revert "virtio_vdpa: support the arg
 sizes of find_vqs()"
Message-ID: <20220816053602.173815-7-mst@redhat.com>
References: <20220816053602.173815-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816053602.173815-1-mst@redhat.com>
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

This reverts commit 99e8927d8a4da8eb8a8a5904dc13a3156be8e7c0:
proposed API isn't supported on all transports but no
effort was made to address this.

It might not be hard to fix if we want to: maybe just rename size to
size_hint and make sure legacy transports ignore the hint.

But it's not sure what the benefit is in any case, so let's drop it.

Fixes: 99e8927d8a4d ("virtio_vdpa: support the arg sizes of find_vqs()")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_vdpa.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index 9bc4d110b800..832d2c5b1b19 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -131,7 +131,7 @@ static irqreturn_t virtio_vdpa_virtqueue_cb(void *private)
 static struct virtqueue *
 virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 		     void (*callback)(struct virtqueue *vq),
-		     const char *name, u32 size, bool ctx)
+		     const char *name, bool ctx)
 {
 	struct virtio_vdpa_device *vd_dev = to_virtio_vdpa_device(vdev);
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
@@ -168,17 +168,14 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 		goto error_new_virtqueue;
 	}
 
-	if (!size || size > max_num)
-		size = max_num;
-
 	if (ops->get_vq_num_min)
 		min_num = ops->get_vq_num_min(vdpa);
 
-	may_reduce_num = (size == min_num) ? false : true;
+	may_reduce_num = (max_num == min_num) ? false : true;
 
 	/* Create the vring */
 	align = ops->get_vq_align(vdpa);
-	vq = vring_create_virtqueue(index, size, align, vdev,
+	vq = vring_create_virtqueue(index, max_num, align, vdev,
 				    true, may_reduce_num, ctx,
 				    virtio_vdpa_notify, callback, name);
 	if (!vq) {
@@ -288,9 +285,9 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 			continue;
 		}
 
-		vqs[i] = virtio_vdpa_setup_vq(vdev, queue_idx++, callbacks[i],
-						  names[i], sizes ? sizes[i] : 0,
-						  ctx ? ctx[i] : false);
+		vqs[i] = virtio_vdpa_setup_vq(vdev, queue_idx++,
+					      callbacks[i], names[i], ctx ?
+					      ctx[i] : false);
 		if (IS_ERR(vqs[i])) {
 			err = PTR_ERR(vqs[i]);
 			goto err_setup_vq;
-- 
MST

