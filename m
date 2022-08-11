Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B585F58FDC4
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 15:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbiHKNyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 09:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbiHKNyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 09:54:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2AFD760695
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 06:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660226047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5kJeSSsfCq2FY3f7RK2Q/BBcFFU0NepVqdZJEXZ6UQI=;
        b=EXWzPevJpBIHjqCvHHV41JmTVmrxLMgrywin7BQsp6von3JBsP8hLXBvBJ2Vuh6vbtE9A4
        3cTTrusuTStoEgidCsoaUq8yYNNWJ4q9XaSH4hvGcVJtZvRNl4WNAvXWI0lmwe56uBAKtB
        24xzByykDG7oo16KmlohocB0CI68P68=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-FQ17yzFNMV-zJv8IcbJuMg-1; Thu, 11 Aug 2022 09:54:03 -0400
X-MC-Unique: FQ17yzFNMV-zJv8IcbJuMg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87E2C1C04B6E;
        Thu, 11 Aug 2022 13:54:02 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE41640D2827;
        Thu, 11 Aug 2022 13:53:55 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     ecree.xilinx@gmail.com, gautam.dawar@amd.com,
        Zhang Min <zhang.min9@zte.com.cn>, pabloc@xilinx.com,
        Piotr.Uminski@intel.com, Dan Carpenter <dan.carpenter@oracle.com>,
        tanuj.kamde@amd.com, Zhu Lingshan <lingshan.zhu@intel.com>,
        martinh@xilinx.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        lvivier@redhat.com, martinpo@xilinx.com, hanand@xilinx.com,
        Eli Cohen <elic@nvidia.com>, lulu@redhat.com,
        habetsm.xilinx@gmail.com, Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>, dinang@xilinx.com,
        Xie Yongji <xieyongji@bytedance.com>
Subject: [PATCH v8 0/3] Implement vdpasim suspend operation
Date:   Thu, 11 Aug 2022 15:53:50 +0200
Message-Id: <20220811135353.2549658-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
Applied on top of vhost branch.=0D
=0D
Comments are welcome.=0D
=0D
v8:=0D
* v7 but incremental from vhost instead of isolated.=0D
=0D
v7:=0D
* Remove ioctl leftover argument and update doc accordingly.=0D
=0D
v6:=0D
* Remove the resume operation, making the ioctl simpler. We can always add=
=0D
  another ioctl for VM_STOP/VM_RESUME operation later.=0D
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
[1] git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git=0D
=0D
Eugenio P=C3=A9rez (3):=0D
  vdpa: delete unreachable branch on vdpasim_suspend=0D
  vdpa: Remove wrong doc of VHOST_VDPA_SUSPEND ioctl=0D
  vhost: Remove invalid parameter of VHOST_VDPA_SUSPEND ioctl=0D
=0D
 drivers/vdpa/vdpa_sim/vdpa_sim.c |  7 -------=0D
 include/linux/vdpa.h             |  2 +-=0D
 include/uapi/linux/vhost.h       | 17 ++++++-----------=0D
 3 files changed, 7 insertions(+), 19 deletions(-)=0D
=0D
-- =0D
2.31.1=0D
=0D

