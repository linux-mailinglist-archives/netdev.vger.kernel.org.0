Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C650E532F6F
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 19:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239890AbiEXRHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 13:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235069AbiEXRHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 13:07:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 81CE17E1FD
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 10:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653412048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GxIUBanOlo4kCZlBLy+vq6QBMWA1M+KHEcRWloPp9vs=;
        b=SxYQABIff5LIPdMxMPCt3LFhcfbEHSjAtzO1fz+dnP0wlS68/FsirkGvE2EsfPRWsAYrOH
        WlPlHLgDTlK9Qwg+Nir+oxz5H6rEcRz95F3ea8KTh6WIDSVUXIh6o8MrHVE7XiuNbrsBvE
        dIoA7HvXkRFr7P8vpYg+VtnfY9fK17I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-2xLvnYQCMHOtyYr0ccgPhw-1; Tue, 24 May 2022 13:06:18 -0400
X-MC-Unique: 2xLvnYQCMHOtyYr0ccgPhw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F2692999B2D;
        Tue, 24 May 2022 17:06:17 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.195.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EB7D2026D64;
        Tue, 24 May 2022 17:06:12 +0000 (UTC)
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
Subject: [PATCH v2 0/4] Implement vdpasim stop operation
Date:   Tue, 24 May 2022 19:06:06 +0200
Message-Id: <20220524170610.2255608-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer=0D
that backend feature and userspace can effectively stop the device.=0D
=0D
This is a must before get virtqueue indexes (base) for live migration,=0D
since the device could modify them after userland gets them. There are=0D
individual ways to perform that action for some devices=0D
(VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no=0D
way to perform it for any vhost device (and, in particular, vhost-vdpa).=0D
=0D
After the return of ioctl with stop !=3D 0, the device MUST finish any=0D
pending operations like in flight requests. It must also preserve all=0D
the necessary state (the virtqueue vring base plus the possible device=0D
specific states) that is required for restoring in the future. The=0D
device must not change its configuration after that point.=0D
=0D
After the return of ioctl with stop =3D=3D 0, the device can continue=0D
processing buffers as long as typical conditions are met (vq is enabled,=0D
DRIVER_OK status bit is enabled, etc).=0D
=0D
In the future, we will provide features similar to VHOST_USER_GET_INFLIGHT_=
FD=0D
so the device can save pending operations.=0D
=0D
Comments are welcome.=0D
=0D
v2:=0D
* Replace raw _F_STOP with BIT_ULL(_F_STOP).=0D
* Fix obtaining of stop ioctl arg (it was not obtained but written).=0D
* Add stop to vdpa_sim_blk.=0D
=0D
Eugenio P=C3=A9rez (4):=0D
  vdpa: Add stop operation=0D
  vhost-vdpa: introduce STOP backend feature bit=0D
  vhost-vdpa: uAPI to stop the device=0D
  vdpa_sim: Implement stop vdpa op=0D
=0D
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++=0D
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +=0D
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++=0D
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++=0D
 drivers/vhost/vdpa.c                 | 34 +++++++++++++++++++++++++++-=0D
 include/linux/vdpa.h                 |  6 +++++=0D
 include/uapi/linux/vhost.h           |  3 +++=0D
 include/uapi/linux/vhost_types.h     |  2 ++=0D
 8 files changed, 72 insertions(+), 1 deletion(-)=0D
=0D
-- =0D
2.27.0=0D
=0D

