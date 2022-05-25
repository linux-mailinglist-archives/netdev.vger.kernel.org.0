Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A0E533B1E
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 12:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbiEYK7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 06:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233957AbiEYK7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 06:59:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 752A960BAF
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 03:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653476383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=oQoa0hxtp2aLppBonjbRDOp8064Y/JajbFbLccXWRXs=;
        b=ULqPEtjKjR9kOpbiu3Uor3WiS76in3E5/uM7e2zJNWDmZCpUG0JO+3WDFibqz6vzQQcAyE
        IJk3KMW74ATv6TAlAE60MSqZUoMunxWtlzetrOYhtfCSpeA8q9hE/id4k9tvgMGjZMZP6S
        QJ699cbM03GPXR2ua0vxgALo014baK8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-Wbiuid1DNn2z-eOkMf5Tzg-1; Wed, 25 May 2022 06:59:42 -0400
X-MC-Unique: Wbiuid1DNn2z-eOkMf5Tzg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D96EF1C0CE63;
        Wed, 25 May 2022 10:59:40 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05E591730C;
        Wed, 25 May 2022 10:59:31 +0000 (UTC)
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
Subject: [PATCH v3 0/4] Implement vdpasim stop operation
Date:   Wed, 25 May 2022 12:59:18 +0200
Message-Id: <20220525105922.2413991-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
 include/uapi/linux/vhost.h           | 14 ++++++++++++=0D
 include/uapi/linux/vhost_types.h     |  2 ++=0D
 8 files changed, 83 insertions(+), 1 deletion(-)=0D
=0D
-- =0D
2.27.0=0D
=0D

