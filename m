Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 844BEAE54E
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 10:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406737AbfIJIUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 04:20:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54330 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731155AbfIJIUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 04:20:04 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 026D55859E;
        Tue, 10 Sep 2019 08:20:03 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-188.pek2.redhat.com [10.72.12.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 449B56092F;
        Tue, 10 Sep 2019 08:19:49 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, cohuck@redhat.com, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com, idos@mellanox.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com
Subject: [RFC PATCH 0/4] mdev based hardware virtio offloading support
Date:   Tue, 10 Sep 2019 16:19:31 +0800
Message-Id: <20190910081935.30516-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 10 Sep 2019 08:20:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all:

There are hardware that can do virtio datapath offloading while having
its own control path. This path tries to implement a mdev based
unified API to support using kernel virtio driver to drive those
devices. This is done by introducing a new mdev transport for virtio
(virtio_mdev) and register itself as a new kind of mdev driver. Then
it provides a unified way for kernel virtio driver to talk with mdev
device implementation.

Though the series only contain kernel driver support, the goal is to
make the transport generic enough to support userspace drivers. This
means vhost-mdev[1] could be built on top as well by resuing the
transport.

A sample driver is also implemented which simulate a virito-net
loopback ethernet device on top of vringh + workqueue. This could be
used as a reference implementation for real hardware driver.

Notes:

- Some of the key transport command for vhost-mdev(userspace driver)
  is not introduced. This includes:
  1) set/get virtqueue state (idx etc), this could be simply done by
     introducing new transport command
  2) dirty pages tracking, could be simply done by introducing new
     transport command
  3) set/get device internal state, this requires more thought, of
     course we can introduce device specific transport command, but it
     would be better to have a unified API
- Current mdev_parent_ops assumes all pointers are userspace pointer,
  this block the kernel driver, this series just abuse those as kernel
  pointer and this could be addressed by inventing new parent_ops.
- For quick POC, mdev transport was just derived from virtio-MMIO,
  I'm pretty sure it has lots of space to be optimized, please share
  your thought.

Please review.

[1] https://lkml.org/lkml/2019/8/28/35

Jason Wang (4):
  vringh: fix copy direction of vringh_iov_push_kern()
  mdev: introduce helper to set per device dma ops
  virtio: introudce a mdev based transport
  docs: Sample driver to demonstrate how to implement virtio-mdev
    framework

 drivers/vfio/mdev/Kconfig        |   7 +
 drivers/vfio/mdev/Makefile       |   1 +
 drivers/vfio/mdev/mdev_core.c    |   7 +
 drivers/vfio/mdev/virtio_mdev.c  | 500 ++++++++++++++++++++
 drivers/vhost/vringh.c           |   8 +-
 include/linux/mdev.h             |   2 +
 include/uapi/linux/virtio_mdev.h | 131 ++++++
 samples/Kconfig                  |   7 +
 samples/vfio-mdev/Makefile       |   1 +
 samples/vfio-mdev/mvnet.c        | 766 +++++++++++++++++++++++++++++++
 10 files changed, 1429 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/mdev/virtio_mdev.c
 create mode 100644 include/uapi/linux/virtio_mdev.h
 create mode 100644 samples/vfio-mdev/mvnet.c

-- 
2.19.1

