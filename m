Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B0353C824
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 12:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243452AbiFCKKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 06:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243432AbiFCKKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 06:10:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EFAE53B037
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 03:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654251007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0BBrHrIvz5xwm3AvObGALT/JpyyQvxptTTPXovns/7Y=;
        b=Vsp3PZWkQ19AA3h9jzIyeQ9Qyt32VInxGtg9rdR9NRqxqhhlI8H/EswZVGKOv2XXc/l+CI
        lxv7UrrIZ58+nmDQKoTqo3rcenes5aa3dEy3L73H+yeFBJgpOmyuafiMt+k+JAoxTABZ82
        kHSw0TnRmux3l4kYDmewHe36ytMaquA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-lmu9olJ3Pg-wG03v9Vfw6g-1; Fri, 03 Jun 2022 06:09:59 -0400
X-MC-Unique: lmu9olJ3Pg-wG03v9Vfw6g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F8361C06EDD;
        Fri,  3 Jun 2022 10:09:58 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.40.192.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 964FE492C3B;
        Fri,  3 Jun 2022 10:09:53 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     kvm@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Longpeng <longpeng2@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>, dinang@xilinx.com,
        Piotr.Uminski@intel.com, martinpo@xilinx.com, tanuj.kamde@amd.com,
        Parav Pandit <parav@nvidia.com>,
        Zhang Min <zhang.min9@zte.com.cn>, habetsm.xilinx@gmail.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, lulu@redhat.com,
        hanand@xilinx.com, martinh@xilinx.com,
        Si-Wei Liu <si-wei.liu@oracle.com>, gautam.dawar@amd.com,
        Xie Yongji <xieyongji@bytedance.com>, ecree.xilinx@gmail.com,
        pabloc@xilinx.com, lvivier@redhat.com, Eli Cohen <elic@nvidia.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v5 1/4] vdpa: Add suspend operation
Date:   Fri,  3 Jun 2022 12:09:41 +0200
Message-Id: <20220603100944.871727-2-eperezma@redhat.com>
In-Reply-To: <20220603100944.871727-1-eperezma@redhat.com>
References: <20220603100944.871727-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 include/linux/vdpa.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 15af802d41c4c..8f4559795bf9f 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -215,6 +215,10 @@ struct vdpa_map_file {
  * @reset:			Reset device
  *				@vdev: vdpa device
  *				Returns integer: success (0) or error (< 0)
+ * @suspend:			Suspend or resume the device (optional)
+ *				@vdev: vdpa device
+ *				@suspend: suspend (true), resume (false)
+ *				Returns integer: success (0) or error (< 0)
  * @get_config_size:		Get the size of the configuration space includes
  *				fields that are conditional on feature bits.
  *				@vdev: vdpa device
@@ -316,6 +320,7 @@ struct vdpa_config_ops {
 	u8 (*get_status)(struct vdpa_device *vdev);
 	void (*set_status)(struct vdpa_device *vdev, u8 status);
 	int (*reset)(struct vdpa_device *vdev);
+	int (*suspend)(struct vdpa_device *vdev, bool suspend);
 	size_t (*get_config_size)(struct vdpa_device *vdev);
 	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
 			   void *buf, unsigned int len);
-- 
2.31.1

