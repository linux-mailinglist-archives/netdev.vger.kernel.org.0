Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930CC53C822
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 12:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243424AbiFCKKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 06:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243381AbiFCKJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 06:09:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE1703B02E
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 03:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654250995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=idp6ThZhNo+GCJ/QXSxEg9bFnM2OmX/SaaK0aBYeq44=;
        b=Xya8YLESeRDg1zwpZKmYqS7MDtc53YXCY+D8pDheF+NDy8+9lfDhMJsE0Y6bJpShXBRMB5
        s+uhg6PkiDf06R76BuVQyyef+9FUI2eoCMEkh1pQo5RPUA5AoDQrEAAFRxvVazA9c6YPMm
        WdE+7QqZdI4A2Pt+0LLBIYE6+E9V+SU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-Knw5QX-HNVSZcpQAsToNAQ-1; Fri, 03 Jun 2022 06:09:54 -0400
X-MC-Unique: Knw5QX-HNVSZcpQAsToNAQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 494951C06EE5;
        Fri,  3 Jun 2022 10:09:53 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.40.192.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1964E492C3B;
        Fri,  3 Jun 2022 10:09:46 +0000 (UTC)
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
Subject: [PATCH v5 0/4] Implement vdpasim suspend operation
Date:   Fri,  3 Jun 2022 12:09:40 +0200
Message-Id: <20220603100944.871727-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
After a successful return of ioctl with suspend =3D 1, the device must not=
=0D
process more virtqueue descriptors, and it must not send any config=0D
interrupt. The device can answer to read or writes of config fields as=0D
if it were not suspended. In particular, writing to "queue_enable" with=0D
a value of 1 will not make the device start processing buffers of the=0D
virtqueue until the device is resumed (suspend =3D 0).=0D
=0D
After a successful return of ioctl with suspend =3D 0, the device will=0D
start processing data of the virtqueues if other expected conditions are=0D
met (queue is enabled, DRIVER_OK has already been set to status, etc.)=0D
If not, the device should be in the same state as if no call to suspend=0D
callback with suspend =3D 1 has been performed.=0D
=0D
In the future, we will provide features similar to=0D
VHOST_USER_GET_INFLIGHT_FD so the device can save pending operations.=0D
=0D
Comments are welcome.=0D
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
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++=0D
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +=0D
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 ++=0D
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 ++=0D
 drivers/vhost/vdpa.c                 | 47 +++++++++++++++++++++++++++-=0D
 include/linux/vdpa.h                 |  5 +++=0D
 include/uapi/linux/vhost.h           | 14 +++++++++=0D
 include/uapi/linux/vhost_types.h     |  2 ++=0D
 8 files changed, 95 insertions(+), 1 deletion(-)=0D
=0D
--=0D
2.31.1=0D
=0D

