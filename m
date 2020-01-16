Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D1413DA39
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 13:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgAPMm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 07:42:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54731 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726684AbgAPMm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 07:42:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579178575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WoZ0K4rRpiCW2qZjV/rJhDzQmCc+LfTgnMm+6gb2PKw=;
        b=e5PLuWH4GY8a3WNn6r9eqt5OPvBfw2AYbDBHeGNA3NaqiGOL6WvRVpkaHdqGwZLlxJnhGS
        TE+99FG5MnYzd9rMs2ZHuV6YOYUG8VMvlTdRTSa/tJuHYh/3ymvh2SnADZ/91JfAMMek0J
        LrImgMgsagkVeGMG7eNlT6uePpzlqrI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-PcWvHHUMNVOFfEm04vtmnQ-1; Thu, 16 Jan 2020 07:42:52 -0500
X-MC-Unique: PcWvHHUMNVOFfEm04vtmnQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4009DB61;
        Thu, 16 Jan 2020 12:42:49 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-70.pek2.redhat.com [10.72.12.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBB995C1C3;
        Thu, 16 Jan 2020 12:42:33 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Cc:     tiwei.bie@intel.com, jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jakub.kicinski@netronome.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com
Subject: [PATCH 0/5] vDPA support
Date:   Thu, 16 Jan 2020 20:42:26 +0800
Message-Id: <20200116124231.20253-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all:

Based on the comments and discussion for mdev based hardware virtio
offloading support[1]. A different approach to support vDPA device is
proposed in this series.

Instead of leveraging VFIO/mdev which may not work for some
vendors. This series tries to introduce a dedicated vDPA bus and
leverage vhost for userspace drivers. This help for the devices that
are not fit for VFIO and may reduce the conflict when try to propose a
bus template for virtual devices in [1].

The vDPA support is split into following parts:

1) vDPA core (bus, device and driver abstraction)
2) virtio vDPA transport for kernel virtio driver to control vDPA
   device
3) vhost vDPA bus driver for userspace vhost driver to control vDPA
   device
4) vendor vDPA drivers
5) management API

Both 1) and 2) are included in this series. Tiwei will work on part
3). For 4), Ling Shan will work and post IFCVF driver. For 5) we leave
it to vendor to implement, but it's better to come into an agreement
for management to create/configure/destroy vDPA device.

The sample driver is kept but renamed to vdap_sim. An on-chip IOMMU
implementation is added to sample device to make it work for both
kernel virtio driver and userspace vhost driver. It implements a sysfs
based management API, but it can switch to any other (e.g devlink) if
necessary.

Please refer each patch for more information.

Comments are welcomed.

[1] https://lkml.org/lkml/2019/11/18/261

Jason Wang (5):
  vhost: factor out IOTLB
  vringh: IOTLB support
  vDPA: introduce vDPA bus
  virtio: introduce a vDPA based transport
  vdpasim: vDPA device simulator

 MAINTAINERS                    |   2 +
 drivers/vhost/Kconfig          |   7 +
 drivers/vhost/Kconfig.vringh   |   1 +
 drivers/vhost/Makefile         |   2 +
 drivers/vhost/net.c            |   2 +-
 drivers/vhost/vhost.c          | 221 +++------
 drivers/vhost/vhost.h          |  36 +-
 drivers/vhost/vhost_iotlb.c    | 171 +++++++
 drivers/vhost/vringh.c         | 434 +++++++++++++++++-
 drivers/virtio/Kconfig         |  15 +
 drivers/virtio/Makefile        |   2 +
 drivers/virtio/vdpa/Kconfig    |  26 ++
 drivers/virtio/vdpa/Makefile   |   3 +
 drivers/virtio/vdpa/vdpa.c     | 141 ++++++
 drivers/virtio/vdpa/vdpa_sim.c | 796 +++++++++++++++++++++++++++++++++
 drivers/virtio/virtio_vdpa.c   | 400 +++++++++++++++++
 include/linux/vdpa.h           | 191 ++++++++
 include/linux/vhost_iotlb.h    |  45 ++
 include/linux/vringh.h         |  36 ++
 19 files changed, 2327 insertions(+), 204 deletions(-)
 create mode 100644 drivers/vhost/vhost_iotlb.c
 create mode 100644 drivers/virtio/vdpa/Kconfig
 create mode 100644 drivers/virtio/vdpa/Makefile
 create mode 100644 drivers/virtio/vdpa/vdpa.c
 create mode 100644 drivers/virtio/vdpa/vdpa_sim.c
 create mode 100644 drivers/virtio/virtio_vdpa.c
 create mode 100644 include/linux/vdpa.h
 create mode 100644 include/linux/vhost_iotlb.h

--=20
2.19.1

