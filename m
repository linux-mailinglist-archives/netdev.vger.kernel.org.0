Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28400557F5F
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 18:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiFWQIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 12:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiFWQH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 12:07:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3EDC8FD6
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 09:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656000477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jDSWGezRUNkQrAnDbfXcTDGQ0dqeSGuiydbEoBFc/3I=;
        b=en6Py0yjD8FhHPu631h54ZDN9Kpwx64ztu8fOc8W0soKrp3SvPRoTBljL2euETWaxN7tZk
        yaGxVr5fm43L4shMmqXlGg+S5CphXWrBvtz9TIu9QDhiRQDxggUGILr165yZfDacGy337T
        NhsKkR4XWMCuhSmvfxkmal48bL6He1U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-un5L0Dl3OjyiMOvnfTqbhA-1; Thu, 23 Jun 2022 12:07:51 -0400
X-MC-Unique: un5L0Dl3OjyiMOvnfTqbhA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1514718E004D;
        Thu, 23 Jun 2022 16:07:50 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A14B82166B26;
        Thu, 23 Jun 2022 16:07:45 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        lulu@redhat.com, tanuj.kamde@amd.com,
        Si-Wei Liu <si-wei.liu@oracle.com>, Piotr.Uminski@intel.com,
        habetsm.xilinx@gmail.com, gautam.dawar@amd.com, pabloc@xilinx.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, lvivier@redhat.com,
        Longpeng <longpeng2@huawei.com>, dinang@xilinx.com,
        martinh@xilinx.com, martinpo@xilinx.com,
        Eli Cohen <elic@nvidia.com>, ecree.xilinx@gmail.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, hanand@xilinx.com,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: [PATCH v6 1/4] vdpa: Add suspend operation
Date:   Thu, 23 Jun 2022 18:07:35 +0200
Message-Id: <20220623160738.632852-2-eperezma@redhat.com>
In-Reply-To: <20220623160738.632852-1-eperezma@redhat.com>
References: <20220623160738.632852-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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

