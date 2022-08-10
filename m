Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3993D58F152
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 19:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbiHJRPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 13:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbiHJRPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 13:15:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1CF9578BD4
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 10:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660151731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i3xMckH4pXPfYRScm/pgwCzvro6+t56bA2voo3F7GcY=;
        b=fqbBMZC7rziAfTiY2HppwUFlftSr7njK2dKZc5AnpOt4LTGM5d/wS95PJYOF5vOPW59i1l
        7cwj4Z4uTm14YtvX29j4okaVjyr80mu0pQt0CitjnxSilEg2r1lcS/HP2Ejh/5cu2+W/wR
        G2Nx0TjZApWrxsYf9QZRwqpbWqcjqKU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-QocaGs_zPLKxQQ1TirQ3-w-1; Wed, 10 Aug 2022 13:15:25 -0400
X-MC-Unique: QocaGs_zPLKxQQ1TirQ3-w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FF1C1824600;
        Wed, 10 Aug 2022 17:15:24 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C791E1415128;
        Wed, 10 Aug 2022 17:15:19 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     dinang@xilinx.com, martinpo@xilinx.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Piotr.Uminski@intel.com, gautam.dawar@amd.com,
        ecree.xilinx@gmail.com, martinh@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>, pabloc@xilinx.com,
        habetsm.xilinx@gmail.com, lvivier@redhat.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, tanuj.kamde@amd.com,
        Longpeng <longpeng2@huawei.com>, lulu@redhat.com,
        hanand@xilinx.com, Parav Pandit <parav@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Eli Cohen <elic@nvidia.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH v7 1/4] vdpa: Add suspend operation
Date:   Wed, 10 Aug 2022 19:15:09 +0200
Message-Id: <20220810171512.2343333-2-eperezma@redhat.com>
In-Reply-To: <20220810171512.2343333-1-eperezma@redhat.com>
References: <20220810171512.2343333-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Message-Id: <20220623160738.632852-2-eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/vdpa.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 7b4a13d3bd91..d282f464d2f1 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -218,6 +218,9 @@ struct vdpa_map_file {
  * @reset:			Reset device
  *				@vdev: vdpa device
  *				Returns integer: success (0) or error (< 0)
+ * @suspend:			Suspend or resume the device (optional)
+ *				@vdev: vdpa device
+ *				Returns integer: success (0) or error (< 0)
  * @get_config_size:		Get the size of the configuration space includes
  *				fields that are conditional on feature bits.
  *				@vdev: vdpa device
@@ -319,6 +322,7 @@ struct vdpa_config_ops {
 	u8 (*get_status)(struct vdpa_device *vdev);
 	void (*set_status)(struct vdpa_device *vdev, u8 status);
 	int (*reset)(struct vdpa_device *vdev);
+	int (*suspend)(struct vdpa_device *vdev);
 	size_t (*get_config_size)(struct vdpa_device *vdev);
 	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
 			   void *buf, unsigned int len);
-- 
2.31.1

