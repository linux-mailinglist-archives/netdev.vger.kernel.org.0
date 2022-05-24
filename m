Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5F1532F62
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 19:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239838AbiEXRGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 13:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239825AbiEXRGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 13:06:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7E6168998
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 10:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653411989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ese622/PjwlbZK8BGVrfy4abZ5tLs60liyPxNETnN7U=;
        b=R+BaXGgSRtdRGuAmV+JpDdZM/OfC/ZEYgDiKk4DEf9LHOcplnVaFQ7eSDEENzYg56+MuH5
        630IdP2q/FvCTSV8YI0jdCvdK4Fm6A/bekiqckSYVEmKDhtPI9yVRNAHQd/eaiKlOhGzJE
        vqqsT01uG1ImvufP57CvKcXOnmw6DZE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-16yW63O5N3qchf5XfyAvpg-1; Tue, 24 May 2022 13:06:23 -0400
X-MC-Unique: 16yW63O5N3qchf5XfyAvpg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E8A83C1E328;
        Tue, 24 May 2022 17:06:22 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.195.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C19F22026D64;
        Tue, 24 May 2022 17:06:17 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>, Zhang Min <zhang.min9@zte.com.cn>,
        hanand@xilinx.com, Zhu Lingshan <lingshan.zhu@intel.com>,
        tanuj.kamde@amd.com, gautam.dawar@amd.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>, dinang@xilinx.com,
        habetsm.xilinx@gmail.com, Eli Cohen <elic@nvidia.com>,
        pabloc@xilinx.com, lvivier@redhat.com,
        Dan Carpenter <dan.carpenter@oracle.com>, lulu@redhat.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        eperezma@redhat.com, ecree.xilinx@gmail.com,
        Piotr.Uminski@intel.com, martinpo@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Longpeng <longpeng2@huawei.com>, martinh@xilinx.com
Subject: [PATCH v2 1/4] vdpa: Add stop operation
Date:   Tue, 24 May 2022 19:06:07 +0200
Message-Id: <20220524170610.2255608-2-eperezma@redhat.com>
In-Reply-To: <20220524170610.2255608-1-eperezma@redhat.com>
References: <20220524170610.2255608-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This operation is optional: It it's not implemented, backend feature bit
will not be exposed.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 include/linux/vdpa.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 15af802d41c4..ddfebc4e1e01 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -215,6 +215,11 @@ struct vdpa_map_file {
  * @reset:			Reset device
  *				@vdev: vdpa device
  *				Returns integer: success (0) or error (< 0)
+ * @stop:			Stop or resume the device (optional, but it must
+ *				be implemented if require device stop)
+ *				@vdev: vdpa device
+ *				@stop: stop (true), not stop (false)
+ *				Returns integer: success (0) or error (< 0)
  * @get_config_size:		Get the size of the configuration space includes
  *				fields that are conditional on feature bits.
  *				@vdev: vdpa device
@@ -316,6 +321,7 @@ struct vdpa_config_ops {
 	u8 (*get_status)(struct vdpa_device *vdev);
 	void (*set_status)(struct vdpa_device *vdev, u8 status);
 	int (*reset)(struct vdpa_device *vdev);
+	int (*stop)(struct vdpa_device *vdev, bool stop);
 	size_t (*get_config_size)(struct vdpa_device *vdev);
 	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
 			   void *buf, unsigned int len);
-- 
2.27.0

