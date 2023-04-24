Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABAA96ED6FD
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 23:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbjDXVtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 17:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbjDXVtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 17:49:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E8E49F7
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 14:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682372930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=LTku6/Nsh4EQKQDxDWLRcPwgB6PJh1RSdW2LJYHZfVo=;
        b=FaaEZjYGZiEVeCtRWI+yMNx+C9uy7xkWmkY+/hBZDaBY5sWq+p8ZXQmDxv4dqqt0ia5Y2v
        G1x/xtCyWX3/ziG8iv7CYIhqjZ4QA3GZW4kliBR4yHzyR5qN6YPMofd99MMy0TTS5/SJ9R
        D0TB36JzL0/G8LfdrtJeCMqHy6H/fnY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-Pu6CwrSBNbulqly5_jh8Mw-1; Mon, 24 Apr 2023 17:48:48 -0400
X-MC-Unique: Pu6CwrSBNbulqly5_jh8Mw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f195129aa4so20683705e9.2
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 14:48:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682372927; x=1684964927;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LTku6/Nsh4EQKQDxDWLRcPwgB6PJh1RSdW2LJYHZfVo=;
        b=NivauYEDSrLDkZjeopgQk8SDwEw0jHoD9nHUFqcZvwihhGGpwcgBNitfrJ1Y8XN4u3
         +3KZsin3gDA/DqZK6P0fJe164o+lwlOs+PSOw3WejhzXbu4fj+/ARjnmaXhLoZnnqAaC
         oYZCwASCP84QJG8Pk4SqxWeIODjlycgxExpoM+jZTFzHDtZZS0dPTsHKLQedorR0HMjx
         PADMN7Jm/CFtBSXfTcsMUlUZI8ZeP2VfbeaOc1CBUNGbdbFH1W9qOHQw3K9I6pi1OpSc
         QNaUkWL9GcOa8/jqE6zUke3si1kQn9Btfck70MzNS+iBD1ddUFBl/HwJzYQdghLSMnxM
         pV5w==
X-Gm-Message-State: AAQBX9cwwlnVshAZ2xwyGiny2cCXApStJfsqDJKnVt8XPH0sp4MwPKIo
        GBMJXpBN25Tif5WbtApVVGmWrnHvRMvwNcegRBjdplUW5SIhm8m5AyV9HhwcO1yvCSdA1lpL5WO
        MI+YT4ARXZGlnPLhW
X-Received: by 2002:a05:600c:3783:b0:3f1:6fb4:44cf with SMTP id o3-20020a05600c378300b003f16fb444cfmr8608247wmr.28.1682372927739;
        Mon, 24 Apr 2023 14:48:47 -0700 (PDT)
X-Google-Smtp-Source: AKy350YG+bu9VkCDkBDU5OqH7npNiCVJnyD1y1MZ7cwDgboNxSYoUBRLO5K70UIGq6nLW+I8k2nrAg==
X-Received: by 2002:a05:600c:3783:b0:3f1:6fb4:44cf with SMTP id o3-20020a05600c378300b003f16fb444cfmr8608223wmr.28.1682372927445;
        Mon, 24 Apr 2023 14:48:47 -0700 (PDT)
Received: from redhat.com ([2.55.17.255])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d6892000000b002f9bfac5baesm11626239wru.47.2023.04.24.14.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 14:48:46 -0700 (PDT)
Date:   Mon, 24 Apr 2023 17:48:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alvaro.karsz@solid-run.com, christophe.jaillet@wanadoo.fr,
        elic@nvidia.com, eperezma@redhat.com, feliu@nvidia.com,
        fmdefrancesco@gmail.com, horms@kernel.org,
        huangjie.albert@bytedance.com, jacob.e.keller@intel.com,
        jasowang@redhat.com, lulu@redhat.com, michael.christie@oracle.com,
        mie@igel.co.jp, mst@redhat.com, peter@n8pjl.ca, rongtao@cestc.cn,
        rtoax@foxmail.com, sgarzare@redhat.com, simon.horman@corigine.com,
        stable@vger.kernel.org, viktor@daynix.com, xieyongji@bytedance.com,
        xuanzhuo@linux.alibaba.com
Subject: [GIT PULL] virtio,vhost,vdpa: features, fixes, cleanups
Message-ID: <20230424174842-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most exciting stuff this time around has to do with performance.

The following changes since commit 6a8f57ae2eb07ab39a6f0ccad60c760743051026:

  Linux 6.3-rc7 (2023-04-16 15:23:53 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to c82729e06644f4e087f5ff0f91b8fb15e03b8890:

  vhost_vdpa: fix unmap process in no-batch mode (2023-04-21 03:02:36 -0400)

----------------------------------------------------------------
virtio,vhost,vdpa: features, fixes, cleanups

reduction in interrupt rate in virtio
perf improvement for VDUSE
scalability for vhost-scsi
non power of 2 ring support for packed rings
better management for mlx5 vdpa
suspend for snet
VIRTIO_F_NOTIFICATION_DATA
shared backend with vdpa-sim-blk
user VA support in vdpa-sim
better struct packing for virtio

fixes, cleanups all over the place

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Albert Huang (1):
      virtio_ring: don't update event idx on get_buf

Alvaro Karsz (5):
      vdpa/snet: support getting and setting VQ state
      vdpa/snet: support the suspend vDPA callback
      virtio-vdpa: add VIRTIO_F_NOTIFICATION_DATA feature support
      vdpa/snet: implement kick_vq_with_data callback
      vdpa/snet: use likely/unlikely macros in hot functions

Christophe JAILLET (1):
      virtio: Reorder fields in 'struct virtqueue'

Cindy Lu (1):
      vhost_vdpa: fix unmap process in no-batch mode

Eli Cohen (3):
      vdpa/mlx5: Avoid losing link state updates
      vdpa/mlx5: Make VIRTIO_NET_F_MRG_RXBUF off by default
      vdpa/mlx5: Extend driver support for new features

Feng Liu (3):
      virtio_ring: Avoid using inline for small functions
      virtio_ring: Use const to annotate read-only pointer params
      virtio_ring: Allow non power of 2 sizes for packed virtqueue

Jacob Keller (1):
      vhost: use struct_size and size_add to compute flex array sizes

Mike Christie (5):
      vhost-scsi: Delay releasing our refcount on the tpg
      vhost-scsi: Drop device mutex use in vhost_scsi_do_plug
      vhost-scsi: Check for a cleared backend before queueing an event
      vhost-scsi: Drop vhost_scsi_mutex use in port callouts
      vhost-scsi: Reduce vhost_scsi_mutex use

Rong Tao (2):
      tools/virtio: virtio_test: Fix indentation
      tools/virtio: virtio_test -h,--help should return directly

Shunsuke Mie (2):
      virtio_ring: add a struct device forward declaration
      tools/virtio: fix build caused by virtio_ring changes

Simon Horman (3):
      vdpa: address kdoc warnings
      vringh: address kdoc warnings
      MAINTAINERS: add vringh.h to Virtio Core and Net Drivers

Stefano Garzarella (12):
      vringh: fix typos in the vringh_init_* documentation
      vdpa: add bind_mm/unbind_mm callbacks
      vhost-vdpa: use bind_mm/unbind_mm device callbacks
      vringh: replace kmap_atomic() with kmap_local_page()
      vringh: define the stride used for translation
      vringh: support VA with iotlb
      vdpa_sim: make devices agnostic for work management
      vdpa_sim: use kthread worker
      vdpa_sim: replace the spinlock with a mutex to protect the state
      vdpa_sim: add support for user VA
      vdpa_sim: move buffer allocation in the devices
      vdpa_sim_blk: support shared backend

Viktor Prutyanov (1):
      virtio: add VIRTIO_F_NOTIFICATION_DATA feature support

Xie Yongji (11):
      lib/group_cpus: Export group_cpus_evenly()
      vdpa: Add set/get_vq_affinity callbacks in vdpa_config_ops
      virtio-vdpa: Support interrupt affinity spreading mechanism
      vduse: Refactor allocation for vduse virtqueues
      vduse: Support set_vq_affinity callback
      vduse: Support get_vq_affinity callback
      vduse: Add sysfs interface for irq callback affinity
      vdpa: Add eventfd for the vdpa callback
      vduse: Signal vq trigger eventfd directly if possible
      vduse: Delay iova domain creation
      vduse: Support specifying bounce buffer size via sysfs

Xuan Zhuo (1):
      MAINTAINERS: make me a reviewer of VIRTIO CORE AND NET DRIVERS

 MAINTAINERS                          |   2 +
 drivers/s390/virtio/virtio_ccw.c     |  22 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c    | 261 +++++++++++++---------
 drivers/vdpa/solidrun/Makefile       |   1 +
 drivers/vdpa/solidrun/snet_ctrl.c    | 330 ++++++++++++++++++++++++++++
 drivers/vdpa/solidrun/snet_hwmon.c   |   2 +-
 drivers/vdpa/solidrun/snet_main.c    | 146 ++++++------
 drivers/vdpa/solidrun/snet_vdpa.h    |  20 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 166 +++++++++++---
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  14 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  93 ++++++--
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  38 ++--
 drivers/vdpa/vdpa_user/vduse_dev.c   | 414 +++++++++++++++++++++++++++++------
 drivers/vhost/scsi.c                 | 102 +++++----
 drivers/vhost/vdpa.c                 |  44 +++-
 drivers/vhost/vhost.c                |   6 +-
 drivers/vhost/vringh.c               | 191 ++++++++++++----
 drivers/virtio/virtio_mmio.c         |  18 +-
 drivers/virtio/virtio_pci_modern.c   |  22 +-
 drivers/virtio/virtio_ring.c         |  89 +++++---
 drivers/virtio/virtio_vdpa.c         | 120 +++++++++-
 include/linux/vdpa.h                 |  52 ++++-
 include/linux/virtio.h               |  16 +-
 include/linux/virtio_ring.h          |   3 +
 include/linux/vringh.h               |  26 ++-
 include/uapi/linux/virtio_config.h   |   6 +
 lib/group_cpus.c                     |   1 +
 tools/include/linux/types.h          |   5 +
 tools/virtio/linux/compiler.h        |   2 +
 tools/virtio/linux/kernel.h          |   5 +-
 tools/virtio/linux/uaccess.h         |  11 +-
 tools/virtio/virtio_test.c           |  12 +-
 32 files changed, 1760 insertions(+), 480 deletions(-)
 create mode 100644 drivers/vdpa/solidrun/snet_ctrl.c

