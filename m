Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0510AB4517
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 03:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387404AbfIQBE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 21:04:59 -0400
Received: from mga04.intel.com ([192.55.52.120]:34819 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbfIQBE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 21:04:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Sep 2019 18:04:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,514,1559545200"; 
   d="scan'208";a="180611926"
Received: from dpdk-virtio-tbie-2.sh.intel.com ([10.67.104.71])
  by orsmga008.jf.intel.com with ESMTP; 16 Sep 2019 18:04:55 -0700
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com, tiwei.bie@intel.com
Subject: [RFC v4 0/3] vhost: introduce mdev based hardware backend
Date:   Tue, 17 Sep 2019 09:02:01 +0800
Message-Id: <20190917010204.30376-1-tiwei.bie@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This RFC is to demonstrate below ideas,

a) Build vhost-mdev on top of the same abstraction defined in
   the virtio-mdev series [1];

b) Introduce /dev/vhost-mdev to do vhost ioctls and support
   setting mdev device as backend;

Now the userspace API looks like this:

- Userspace generates a compatible mdev device;

- Userspace opens this mdev device with VFIO API (including
  doing IOMMU programming for this mdev device with VFIO's
  container/group based interface);

- Userspace opens /dev/vhost-mdev and gets vhost fd;

- Userspace uses vhost ioctls to setup vhost (userspace should
  do VHOST_MDEV_SET_BACKEND ioctl with VFIO group fd and device
  fd first before doing other vhost ioctls);

Only compile test has been done for this series for now.

RFCv3: https://patchwork.kernel.org/patch/11117785/

[1] https://lkml.org/lkml/2019/9/10/135

Tiwei Bie (3):
  vfio: support getting vfio device from device fd
  vfio: support checking vfio driver by device ops
  vhost: introduce mdev based hardware backend

 drivers/vfio/mdev/vfio_mdev.c    |   3 +-
 drivers/vfio/vfio.c              |  32 +++
 drivers/vhost/Kconfig            |   9 +
 drivers/vhost/Makefile           |   3 +
 drivers/vhost/mdev.c             | 462 +++++++++++++++++++++++++++++++
 drivers/vhost/vhost.c            |  39 ++-
 drivers/vhost/vhost.h            |   6 +
 include/linux/vfio.h             |  11 +
 include/uapi/linux/vhost.h       |  10 +
 include/uapi/linux/vhost_types.h |   5 +
 10 files changed, 573 insertions(+), 7 deletions(-)
 create mode 100644 drivers/vhost/mdev.c

-- 
2.17.1

