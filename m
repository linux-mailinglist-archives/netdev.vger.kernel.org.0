Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AE06C3609
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 16:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbjCUPnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 11:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbjCUPn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 11:43:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2798040D3
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 08:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679413356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zd9PLJS6vpKJ6CPmR9YHtESYhzkUvkwsWDxsXaqlwQ8=;
        b=efQwvRn0B7ulOHNiZab7za2HchoEQsAatRcZfk/c82/FePajha9OXxlyPy0Ro5N5ki1Jek
        /gv1SdqH0bB7BGP/h5AwUqs0Z0lKaqrH73613BETlWQIb3Ugr+1hHaEMS2BOHSQPtKwlnD
        ROGT4zbgdbtjTrevoFjJ3X0YWA/UIJ0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-xLqcbLOHML-XKEZT1d1M5g-1; Tue, 21 Mar 2023 11:42:34 -0400
X-MC-Unique: xLqcbLOHML-XKEZT1d1M5g-1
Received: by mail-wm1-f69.google.com with SMTP id j16-20020a05600c1c1000b003edfa11fa91so2593690wms.3
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 08:42:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679413353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zd9PLJS6vpKJ6CPmR9YHtESYhzkUvkwsWDxsXaqlwQ8=;
        b=Ui76Z5Eqq07E77uq5tYT9cFZ8p97Xr0CMPtlOcFnGrJZK8Wsdy7T9qkYIdvgEGI6LA
         B9SBIiqnT+WVeLFqRdDQ814mptP8mXrEVc+A0pAODp6ROO8q3cXxnx3AnnwZaDgjigX5
         LiTXfNtiIB7eR3MvcmDGk0YV9XUYAcSHnwMFFFDboLZfddKRHWi8ppcS8b74UIgUbNUe
         ujCpIL2itIAwZwWz2d2S0enm9/ksf1dni6PfMIsFndwlB770cUBrf+uX1PGKmme8K5np
         ocRBu9uAnQHAjdmngdopBEma4boQobP5OBTBa2dXRYYy2pqr0JkIKsyu7h0uFTQ8MlqO
         Gttg==
X-Gm-Message-State: AO0yUKXpZjxhZX4BhsLdDxUJn5cETjiVO42nioWO23yjVLMapOBuHU/I
        I/sInWYiC3RuDUSNNkK4ZeX063PTZbXQuApL1YygwNyiwqVYyMkifAEaZSNnBuZe7ERlEWehjwI
        1pjIVgKvpiYVoo1XM
X-Received: by 2002:adf:f343:0:b0:2d3:3cda:b3c6 with SMTP id e3-20020adff343000000b002d33cdab3c6mr2888096wrp.40.1679413353604;
        Tue, 21 Mar 2023 08:42:33 -0700 (PDT)
X-Google-Smtp-Source: AK7set/b5KVmlfqlN07+fuoNrjHLEJpuKDzvXT/LPPT4E9RDWaTxlJ4Sk2OLx1GqH6fn/8z1bNY5hQ==
X-Received: by 2002:adf:f343:0:b0:2d3:3cda:b3c6 with SMTP id e3-20020adff343000000b002d33cdab3c6mr2888071wrp.40.1679413353350;
        Tue, 21 Mar 2023 08:42:33 -0700 (PDT)
Received: from step1.redhat.com (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id n2-20020adffe02000000b002cfeffb442bsm11582490wrr.57.2023.03.21.08.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 08:42:32 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     stefanha@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v3 1/8] vdpa: add bind_mm/unbind_mm callbacks
Date:   Tue, 21 Mar 2023 16:42:21 +0100
Message-Id: <20230321154228.182769-2-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321154228.182769-1-sgarzare@redhat.com>
References: <20230321154228.182769-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These new optional callbacks is used to bind/unbind the device to
a specific address space so the vDPA framework can use VA when
these callbacks are implemented.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
    v2:
    - removed `struct task_struct *owner` param (unused for now, maybe
      useful to support cgroups) [Jason]
    - add unbind_mm callback [Jason]

 include/linux/vdpa.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 43f59ef10cc9..369c21394284 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -290,6 +290,14 @@ struct vdpa_map_file {
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				Returns pointer to structure device or error (NULL)
+ * @bind_mm:			Bind the device to a specific address space
+ *				so the vDPA framework can use VA when this
+ *				callback is implemented. (optional)
+ *				@vdev: vdpa device
+ *				@mm: address space to bind
+ * @unbind_mm:			Unbind the device from the address space
+ *				bound using the bind_mm callback. (optional)
+ *				@vdev: vdpa device
  * @free:			Free resources that belongs to vDPA (optional)
  *				@vdev: vdpa device
  */
@@ -351,6 +359,8 @@ struct vdpa_config_ops {
 	int (*set_group_asid)(struct vdpa_device *vdev, unsigned int group,
 			      unsigned int asid);
 	struct device *(*get_vq_dma_dev)(struct vdpa_device *vdev, u16 idx);
+	int (*bind_mm)(struct vdpa_device *vdev, struct mm_struct *mm);
+	void (*unbind_mm)(struct vdpa_device *vdev);
 
 	/* Free device resources */
 	void (*free)(struct vdpa_device *vdev);
-- 
2.39.2

