Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC4D52F19C
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 19:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352167AbiETRXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 13:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352159AbiETRXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 13:23:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C339A187067
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 10:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653067416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+mUQhLcxz6TZwVt0puoA8uLFKO7ahYDhUTcQY+6+1vw=;
        b=Y8EZwzfXUB/PJI43lkPcoBzr2z9YcjcdFbw2Ru0gzg1DzSxS6LZRjx0yuW9mWH6izAEkEZ
        DYpnfUx2WPb4Ods79nSzdUXfp3crcZFrv2S/DRmwAMBKYG34ouqRhA3dQlG+u12URKCXlk
        XZg4A6C4HfleMXzVkafIXQuWO5RDIo0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-66oEZV14PGix7OSjvRA3fQ-1; Fri, 20 May 2022 13:23:33 -0400
X-MC-Unique: 66oEZV14PGix7OSjvRA3fQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B40E138041D6;
        Fri, 20 May 2022 17:23:32 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 189E1492C14;
        Fri, 20 May 2022 17:23:27 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, martinh@xilinx.com,
        hanand@xilinx.com, Si-Wei Liu <si-wei.liu@oracle.com>,
        dinang@xilinx.com, Eli Cohen <elic@nvidia.com>, lvivier@redhat.com,
        pabloc@xilinx.com, gautam.dawar@amd.com,
        Xie Yongji <xieyongji@bytedance.com>, habetsm.xilinx@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tanuj.kamde@amd.com, eperezma@redhat.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        martinpo@xilinx.com, lulu@redhat.com, ecree.xilinx@gmail.com,
        Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: [PATCH 0/4] Implement vdpasim stop operation
Date:   Fri, 20 May 2022 19:23:21 +0200
Message-Id: <20220520172325.980884-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Comments are welcome.=0D
=0D
Eugenio P=C3=A9rez (4):=0D
  vdpa: Add stop operation=0D
  vhost-vdpa: introduce STOP backend feature bit=0D
  vhost-vdpa: uAPI to stop the device=0D
  vdpa_sim: Implement stop vdpa op=0D
=0D
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++++=0D
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +=0D
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++=0D
 drivers/vhost/vdpa.c                 | 31 ++++++++++++++++++++++++++++=0D
 include/linux/vdpa.h                 |  6 ++++++=0D
 include/uapi/linux/vhost.h           |  3 +++=0D
 include/uapi/linux/vhost_types.h     |  2 ++=0D
 7 files changed, 67 insertions(+)=0D
=0D
-- =0D
2.27.0=0D
=0D

