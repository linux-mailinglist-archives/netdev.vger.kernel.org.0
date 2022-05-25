Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7FA533B27
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 13:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242490AbiEYLAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 07:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241949AbiEYLAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 07:00:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB64C63398
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 04:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653476399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ese622/PjwlbZK8BGVrfy4abZ5tLs60liyPxNETnN7U=;
        b=JRPrUCo3/Ia7YPUdQ4HGYd7ZXbbWhF7EUrnPeRT+32du3IdhC4+VurEJvnO3TB336KKYyl
        pHygcgOBAWyQcYsRbfM4Sp4fvUaXOpVWFxrXoD9SDy9a3iwT+8tpvy+s5Q3w7pu4hel004
        L9Qk7MIo3qv/4lzXTRvx/MkPLPay9Hk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-mAvFaTlVPUyrJ8isaMy3yQ-1; Wed, 25 May 2022 06:59:49 -0400
X-MC-Unique: mAvFaTlVPUyrJ8isaMy3yQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9C601C0CE63;
        Wed, 25 May 2022 10:59:47 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57D9D7AD8;
        Wed, 25 May 2022 10:59:41 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>, martinh@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>,
        ecree.xilinx@gmail.com, Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>, dinang@xilinx.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>, gautam.dawar@amd.com,
        lulu@redhat.com, martinpo@xilinx.com, pabloc@xilinx.com,
        Longpeng <longpeng2@huawei.com>, Piotr.Uminski@intel.com,
        tanuj.kamde@amd.com, Si-Wei Liu <si-wei.liu@oracle.com>,
        habetsm.xilinx@gmail.com, lvivier@redhat.com,
        Zhang Min <zhang.min9@zte.com.cn>, hanand@xilinx.com
Subject: [PATCH v3 1/4] vdpa: Add stop operation
Date:   Wed, 25 May 2022 12:59:19 +0200
Message-Id: <20220525105922.2413991-2-eperezma@redhat.com>
In-Reply-To: <20220525105922.2413991-1-eperezma@redhat.com>
References: <20220525105922.2413991-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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

