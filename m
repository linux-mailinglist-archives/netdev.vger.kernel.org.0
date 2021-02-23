Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF42C3229B6
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 12:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhBWLwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 06:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbhBWLw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 06:52:27 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80790C061786
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:51:46 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id a24so9653494plm.11
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xdz76Pr5X2U4qGHNaBUqTnUQFn7wjtLgR16d6odDiDY=;
        b=KqAJzp4Ub9NgdWZX0Vx+kHhWD2qcuxAU6AlaIr1cTEa34WXruEbOqzAduVnsyuTiVq
         Qrj6vhsW64HXdsYLwgt1DG1lA+9TBfZc692wNCowM9cPgj7jJnYpvmm/cvgJvHoJExvV
         Xxv9RFF5PRqatMwzSs7jXOqar4QnqNbmRljz1DSrtU5dIG0PRZ6lgyriHVoG9LQCpKAG
         CPGyxiEwaf+JQABA6jerjDMlAAj+c7c0yRibE9YyayEvUVlVTFEnuSSb1M8pu50stbnL
         LGbS+/8NrESm09jnrN+7TNWR7JMY7D24qOMgkvxMbUPorHkxamXnkMMD8Ks3aGu/oSOZ
         kaUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xdz76Pr5X2U4qGHNaBUqTnUQFn7wjtLgR16d6odDiDY=;
        b=skQ5mMp0EH/xypogKC2Ogf7kcoBz5AHeO0oztcIcf+fVo4Z7Ruphmjalt7kxKSg+lb
         CLFVih07n5u+ZqGFKrP9PiU2cjWx2eH1XVO/ktceQ+riz0ubLo8JtxTymsd16IqBe5sQ
         T335GOIFjlA0EOmZ8zk1mMJKVNrFKDc+6Ah9cKyrw4GTRzvdmAG4PJa5tv3EYr/fu/wQ
         zo1cMPEFcV0HY8pG/hGKutotUmsfwRUOqtvnb+zN7MX6fTJ3vkaWsoLbV8MBtpcG9VNU
         Ht1vtBCvnw7iJGsNrGDuyDwdQtprOpTqvA0NWClSglu58lnrr87/t4okd01WWn7PUCXQ
         bmgQ==
X-Gm-Message-State: AOAM531kD/LWkQ1gLOp7OB3nn47uiuPh8cxcwC1Lpy+ZCfG/yPfxQ/j5
        CtwEqrFPcP19uc56++XZu/4y
X-Google-Smtp-Source: ABdhPJz+79mE6shXBsPb0acvIFtMPBgzHOe2E85ktwi8FRo2C3PHXFv0KX2CxiJB+oN/aw8FRop8mg==
X-Received: by 2002:a17:90a:ba02:: with SMTP id s2mr29110785pjr.53.1614081105834;
        Tue, 23 Feb 2021 03:51:45 -0800 (PST)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id ca19sm3086493pjb.31.2021.02.23.03.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 03:51:45 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v4 00/11] Introduce VDUSE - vDPA Device in Userspace
Date:   Tue, 23 Feb 2021 19:50:37 +0800
Message-Id: <20210223115048.435-1-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces a framework, which can be used to implement
vDPA Devices in a userspace program. The work consist of two parts:
control path forwarding and data path offloading.

In the control path, the VDUSE driver will make use of message
mechnism to forward the config operation from vdpa bus driver
to userspace. Userspace can use read()/write() to receive/reply
those control messages.

In the data path, the core is mapping dma buffer into VDUSE
daemon's address space, which can be implemented in different ways
depending on the vdpa bus to which the vDPA device is attached.

In virtio-vdpa case, we implements a MMU-based on-chip IOMMU driver with
bounce-buffering mechanism to achieve that. And in vhost-vdpa case, the dma
buffer is reside in a userspace memory region which can be shared to the
VDUSE userspace processs via transferring the shmfd.

The details and our user case is shown below:

------------------------    -------------------------   ----------------------------------------------
|            Container |    |              QEMU(VM) |   |                               VDUSE daemon |
|       ---------      |    |  -------------------  |   | ------------------------- ---------------- |
|       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | | vDPA device emulation | | block driver | |
------------+-----------     -----------+------------   -------------+----------------------+---------
            |                           |                            |                      |
            |                           |                            |                      |
------------+---------------------------+----------------------------+----------------------+---------
|    | block device |           |  vhost device |            | vduse driver |          | TCP/IP |    |
|    -------+--------           --------+--------            -------+--------          -----+----    |
|           |                           |                           |                       |        |
| ----------+----------       ----------+-----------         -------+-------                |        |
| | virtio-blk driver |       |  vhost-vdpa driver |         | vdpa device |                |        |
| ----------+----------       ----------+-----------         -------+-------                |        |
|           |      virtio bus           |                           |                       |        |
|   --------+----+-----------           |                           |                       |        |
|                |                      |                           |                       |        |
|      ----------+----------            |                           |                       |        |
|      | virtio-blk device |            |                           |                       |        |
|      ----------+----------            |                           |                       |        |
|                |                      |                           |                       |        |
|     -----------+-----------           |                           |                       |        |
|     |  virtio-vdpa driver |           |                           |                       |        |
|     -----------+-----------           |                           |                       |        |
|                |                      |                           |    vdpa bus           |        |
|     -----------+----------------------+---------------------------+------------           |        |
|                                                                                        ---+---     |
-----------------------------------------------------------------------------------------| NIC |------
                                                                                         ---+---
                                                                                            |
                                                                                   ---------+---------
                                                                                   | Remote Storages |
                                                                                   -------------------

We make use of it to implement a block device connecting to
our distributed storage, which can be used both in containers and
VMs. Thus, we can have an unified technology stack in this two cases.

To test it with null-blk:

  $ qemu-storage-daemon \
      --chardev socket,id=charmonitor,path=/tmp/qmp.sock,server,nowait \
      --monitor chardev=charmonitor \
      --blockdev driver=host_device,cache.direct=on,aio=native,filename=/dev/nullb0,node-name=disk0 \
      --export type=vduse-blk,id=test,node-name=disk0,writable=on,name=vduse-null,num-queues=16,queue-size=128

The qemu-storage-daemon can be found at https://github.com/bytedance/qemu/tree/vduse

Future work:
  - Improve performance
  - Userspace library (find a way to reuse device emulation code in qemu/rust-vmm)

V3 to V4:
- Rebase to vhost.git
- Split some patches
- Add some documents
- Use ioctl to inject interrupt rather than eventfd
- Enable config interrupt support
- Support binding irq to the specified cpu
- Add two module parameter to limit bounce/iova size
- Create char device rather than anon inode per vduse
- Reuse vhost IOTLB for iova domain
- Rework the message mechnism in control path

V2 to V3:
- Rework the MMU-based IOMMU driver
- Use the iova domain as iova allocator instead of genpool
- Support transferring vma->vm_file in vhost-vdpa
- Add SVA support in vhost-vdpa
- Remove the patches on bounce pages reclaim

V1 to V2:
- Add vhost-vdpa support
- Add some documents
- Based on the vdpa management tool
- Introduce a workqueue for irq injection
- Replace interval tree with array map to store the iova_map

Xie Yongji (11):
  eventfd: Increase the recursion depth of eventfd_signal()
  vhost-vdpa: protect concurrent access to vhost device iotlb
  vhost-iotlb: Add an opaque pointer for vhost IOTLB
  vdpa: Add an opaque pointer for vdpa_config_ops.dma_map()
  vdpa: Support transferring virtual addressing during DMA mapping
  vduse: Implement an MMU-based IOMMU driver
  vduse: Introduce VDUSE - vDPA Device in Userspace
  vduse: Add config interrupt support
  Documentation: Add documentation for VDUSE
  vduse: Introduce a workqueue for irq injection
  vduse: Support binding irq to the specified cpu

 Documentation/userspace-api/index.rst              |    1 +
 Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
 Documentation/userspace-api/vduse.rst              |  112 ++
 drivers/vdpa/Kconfig                               |   10 +
 drivers/vdpa/Makefile                              |    1 +
 drivers/vdpa/ifcvf/ifcvf_main.c                    |    2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |    2 +-
 drivers/vdpa/vdpa.c                                |    9 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |    8 +-
 drivers/vdpa/vdpa_user/Makefile                    |    5 +
 drivers/vdpa/vdpa_user/iova_domain.c               |  486 +++++++
 drivers/vdpa/vdpa_user/iova_domain.h               |   61 +
 drivers/vdpa/vdpa_user/vduse_dev.c                 | 1399 ++++++++++++++++++++
 drivers/vhost/iotlb.c                              |   20 +-
 drivers/vhost/vdpa.c                               |  106 +-
 fs/eventfd.c                                       |    2 +-
 include/linux/eventfd.h                            |    5 +-
 include/linux/vdpa.h                               |   22 +-
 include/linux/vhost_iotlb.h                        |    3 +
 include/uapi/linux/vduse.h                         |  144 ++
 20 files changed, 2363 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/userspace-api/vduse.rst
 create mode 100644 drivers/vdpa/vdpa_user/Makefile
 create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
 create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
 create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
 create mode 100644 include/uapi/linux/vduse.h

-- 
2.11.0

