Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E891C557F57
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 18:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbiFWQH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 12:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbiFWQHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 12:07:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43F9B4505F
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 09:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656000470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=S3oCRCXEV1K9DsN6PfqUynkZmDYWF6Rf7y0C3Au1By4=;
        b=bllGs+0aesPb2VvzOMzYV1+kNiIvSPuyGuTSsV3v3VZKD1Sln9N1fQBT/OwIhkY+AvSWWj
        zKMyNHK2nHIQLVDx1KXp6vdidFuU+V9SxRVycVYl22uWXVB2eRokrJPWV+i+l9mVL7EP3x
        dDEeZDzwRdLTyrmQm95mVqZywi/LxPQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-3LdcDvSdOlKw1ZaLMZpg2Q-1; Thu, 23 Jun 2022 12:07:46 -0400
X-MC-Unique: 3LdcDvSdOlKw1ZaLMZpg2Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F6071C04B42;
        Thu, 23 Jun 2022 16:07:45 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACA7C2166B26;
        Thu, 23 Jun 2022 16:07:40 +0000 (UTC)
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
Subject: [PATCH v6 0/4] Implement vdpasim suspend operation
Date:   Thu, 23 Jun 2022 18:07:34 +0200
Message-Id: <20220623160738.632852-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement suspend operation for vdpa_sim devices, so vhost-vdpa will offer=
=0D
that backend feature and userspace can effectively suspend the device.=0D
=0D
This is a must before getting virtqueue indexes (base) for live migration,=
=0D
since the device could modify them after userland gets them. There are=0D
individual ways to perform that action for some devices=0D
(VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no=0D
way to perform it for any vhost device (and, in particular, vhost-vdpa).=0D
=0D
After a successful return of ioctl the device must not process more virtque=
ue=0D
descriptors. The device can answer to read or writes of config fields as if=
 it=0D
were not suspended. In particular, writing to "queue_enable" with a value o=
f 1=0D
will not make the device start processing virtqueue buffers.=0D
=0D
In the future, we will provide features similar to=0D
VHOST_USER_GET_INFLIGHT_FD so the device can save pending operations.=0D
=0D
Comments are welcome.=0D
=0D
v7:=0D
* Remove the resume operation, making the ioctl simpler. We can always add=
=0D
  another ioctl for VM_STOP/VM_RESUME operation later.=0D
=0D
v6:=0D
* s/stop/suspend/ to differentiate more from reset.=0D
* Clarify scope of the suspend operation.=0D
=0D
v5:=0D
* s/not stop/resume/ in doc.=0D
=0D
v4:=0D
* Replace VHOST_STOP to VHOST_VDPA_STOP in vhost ioctl switch case too.=0D
=0D
v3:=0D
* s/VHOST_STOP/VHOST_VDPA_STOP/=0D
* Add documentation and requirements of the ioctl above its definition.=0D
=0D
v2:=0D
* Replace raw _F_STOP with BIT_ULL(_F_STOP).=0D
* Fix obtaining of stop ioctl arg (it was not obtained but written).=0D
* Add stop to vdpa_sim_blk.=0D
=0D
Eugenio P=C3=A9rez (4):=0D
  vdpa: Add suspend operation=0D
  vhost-vdpa: introduce SUSPEND backend feature bit=0D
  vhost-vdpa: uAPI to suspend the device=0D
  vdpa_sim: Implement suspend vdpa op=0D
=0D
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++=0D
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +=0D
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++=0D
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++=0D
 drivers/vhost/vdpa.c                 | 35 +++++++++++++++++++++++++++-=0D
 include/linux/vdpa.h                 |  4 ++++=0D
 include/uapi/linux/vhost.h           | 14 +++++++++++=0D
 include/uapi/linux/vhost_types.h     |  2 ++=0D
 8 files changed, 82 insertions(+), 1 deletion(-)=0D
=0D
-- =0D
2.31.1=0D
=0D

