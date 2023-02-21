Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E347F69D7A0
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbjBUAlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbjBUAlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:41:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C549B22DC9
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 16:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676940055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ivV8MRUKs7ozW1pF8hDCdVy4BvYTao2KBGKgdqnNtEA=;
        b=Z7pwEoQYZkI/Ktg8mW63fIcclAjXcf+fXdetFRx/KNNOC+q6oZroV98oDUY6PcMAHzGSir
        /9hyza7s9AHR5+qQ9UaFCsC0X6ZU0xQDleOVdXtHofvKZEfDbn6Zcy3kr3fTYi03a2jNmY
        wiIKS1fOV3ZK900feLZllkYkuvpQgrI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-318-a047K7DXNrGNIt6HsO1Ybg-1; Mon, 20 Feb 2023 19:40:53 -0500
X-MC-Unique: a047K7DXNrGNIt6HsO1Ybg-1
Received: by mail-wm1-f70.google.com with SMTP id h8-20020a05600c314800b003e10bfcd160so1060345wmo.6
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 16:40:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ivV8MRUKs7ozW1pF8hDCdVy4BvYTao2KBGKgdqnNtEA=;
        b=Z99cRP24TbPmAHkSdRVcX1qpDHwHNN6Ih8hPBLNpuOozUHalGo+6CoPalhVd/7hPBX
         nrGRaeYLGcrBAyrDPBA2IjbPl/c0EWnCyA7QHbsMirVgoRlVtyGDMo7zbU9e4NxfteRK
         evy0HxXjWOeabCn98kk757+7i5yBKwo4mmnBwtFs6qtBWzbKTLXRNpLUsoQ5UZuifne4
         Bjz2eEWPjwSQd80bj9gVUh+r7udbPfZ09dbAuPndAx4aOphtMNriLkmTyLjQdY4roHL0
         2WcCLNIzr9cKinXzKxjZUmQrSIdYHxsRWzMx8T15V1+1t05f1H5OpCg6/IQi7l4MTnpz
         QqVA==
X-Gm-Message-State: AO0yUKXo94ieleKcvlFd6EI1qWUeFiIQtwzUhsqfBxvzGUaH+qa/Spuh
        h6BI8yqkmeRDA8/ng6wBpabz6MUsjB3BllI4QQkXHk9ZyA85koZQNsPwVf4OZ834nLZmlyXahoR
        BQHYPba4UTIAn3AGU
X-Received: by 2002:a5d:444d:0:b0:2c5:4c32:92cb with SMTP id x13-20020a5d444d000000b002c54c3292cbmr1010434wrr.54.1676940052193;
        Mon, 20 Feb 2023 16:40:52 -0800 (PST)
X-Google-Smtp-Source: AK7set8KGWfYITRF31i2K/JLQVmFylv6hAV7//rGLBlWRfuXHGq2sQ0V6QTBt+n4dJHEoKpWOPQgHg==
X-Received: by 2002:a5d:444d:0:b0:2c5:4c32:92cb with SMTP id x13-20020a5d444d000000b002c54c3292cbmr1010403wrr.54.1676940051865;
        Mon, 20 Feb 2023 16:40:51 -0800 (PST)
Received: from redhat.com ([2.52.36.56])
        by smtp.gmail.com with ESMTPSA id r13-20020adfdc8d000000b002c557f82e27sm1062943wrj.99.2023.02.20.16.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 16:40:51 -0800 (PST)
Date:   Mon, 20 Feb 2023 19:40:45 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        almasrymina@google.com, alvaro.karsz@solid-run.com,
        anders.roxell@linaro.org, bagasdotme@gmail.com,
        bhelgaas@google.com, colin.i.king@gmail.com,
        dmitry.fomichev@wdc.com, elic@nvidia.com, eperezma@redhat.com,
        hch@lst.de, jasowang@redhat.com, kangjie.xu@linux.alibaba.com,
        leiyang@redhat.com, liming.wu@jaguarmicro.com,
        lingshan.zhu@intel.com, liubo03@inspur.com, lkft@linaro.org,
        mie@igel.co.jp, mst@redhat.com, m.szyprowski@samsung.com,
        ricardo.canuelo@collabora.com, sammler@google.com,
        sebastien.boeuf@intel.com, sfr@canb.auug.org.au,
        si-wei.liu@oracle.com, stable@vger.kernel.org, stefanha@gmail.com,
        suwan.kim027@gmail.com, xuanzhuo@linux.alibaba.com,
        yangyingliang@huawei.com, zyytlz.wz@163.com
Subject: [GIT PULL] virtio,vhost,vdpa: features, fixes
Message-ID: <20230220194045-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit ceaa837f96adb69c0df0397937cd74991d5d821a:

  Linux 6.2-rc8 (2023-02-12 14:10:17 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to deeacf35c922da579637f5db625af20baafc66ed:

  vdpa/mlx5: support device features provisioning (2023-02-20 19:27:00 -0500)

Note: dropped a patch close to the bottom of the stack at the last
minute so the commits differ but all of these have been in next already.
The dropped patch just added a new query ioctl so not interacting with
anything else in the pull.

----------------------------------------------------------------
virtio,vhost,vdpa: features, fixes

device feature provisioning in ifcvf, mlx5
new SolidNET driver
support for zoned block device in virtio blk
numa support in virtio pmem
VIRTIO_F_RING_RESET support in vhost-net
more debugfs entries in mlx5
resume support in vdpa
completion batching in virtio blk
cleanup of dma api use in vdpa
now simulating more features in vdpa-sim
documentation, features, fixes all over the place

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Alvaro Karsz (4):
      PCI: Add SolidRun vendor ID
      PCI: Avoid FLR for SolidRun SNET DPU rev 1
      virtio: vdpa: new SolidNET DPU driver.
      vhost-vdpa: print warning when vhost_vdpa_alloc_domain fails

Bagas Sanjaya (3):
      docs: driver-api: virtio: parenthesize external reference targets
      docs: driver-api: virtio: slightly reword virtqueues allocation paragraph
      docs: driver-api: virtio: commentize spec version checking

Bo Liu (1):
      vhost-scsi: convert sysfs snprintf and sprintf to sysfs_emit

Colin Ian King (1):
      vdpa: Fix a couple of spelling mistakes in some messages

Dmitry Fomichev (1):
      virtio-blk: add support for zoned block devices

Eli Cohen (6):
      vdpa/mlx5: Move some definitions to a new header file
      vdpa/mlx5: Add debugfs subtree
      vdpa/mlx5: Add RX counters to debugfs
      vdpa/mlx5: Directly assign memory key
      vdpa/mlx5: Don't clear mr struct on destroy MR
      vdpa/mlx5: Initialize CVQ iotlb spinlock

Eugenio Pérez (2):
      vdpa_sim: not reset state in vdpasim_queue_ready
      vdpa_sim_net: Offer VIRTIO_NET_F_STATUS

Jason Wang (11):
      vdpa_sim: use weak barriers
      vdpa_sim: switch to use __vdpa_alloc_device()
      vdpasim: customize allocation size
      vdpa_sim: support vendor statistics
      vdpa_sim_net: vendor satistics
      vdpa_sim: get rid of DMA ops
      virtio_ring: per virtqueue dma device
      vdpa: introduce get_vq_dma_device()
      virtio-vdpa: support per vq dma device
      vdpa: set dma mask for vDPA device
      vdpa: mlx5: support per virtqueue dma device

Kangjie Xu (1):
      vhost-net: support VIRTIO_F_RING_RESET

Liming Wu (2):
      vhost-test: remove meaningless debug info
      vhost: remove unused paramete

Michael S. Tsirkin (3):
      virtio_blk: temporary variable type tweak
      virtio_blk: zone append in header type tweak
      virtio_blk: mark all zone fields LE

Michael Sammler (1):
      virtio_pmem: populate numa information

Ricardo Cañuelo (1):
      docs: driver-api: virtio: virtio on Linux

Sebastien Boeuf (4):
      vdpa: Add resume operation
      vhost-vdpa: Introduce RESUME backend feature bit
      vhost-vdpa: uAPI to resume the device
      vdpa_sim: Implement resume vdpa op

Shunsuke Mie (2):
      vringh: fix a typo in comments for vringh_kiov
      tools/virtio: enable to build with retpoline

Si-Wei Liu (6):
      vdpa: fix improper error message when adding vdpa dev
      vdpa: conditionally read STATUS in config space
      vdpa: validate provisioned device features against specified attribute
      vdpa: validate device feature provisioning against supported class
      vdpa/mlx5: make MTU/STATUS presence conditional on feature bits
      vdpa/mlx5: support device features provisioning

Suwan Kim (2):
      virtio-blk: set req->state to MQ_RQ_COMPLETE after polling I/O is finished
      virtio-blk: support completion batching for the IRQ path

Zheng Wang (1):
      scsi: virtio_scsi: fix handling of kmalloc failure

Zhu Lingshan (12):
      vDPA/ifcvf: decouple hw features manipulators from the adapter
      vDPA/ifcvf: decouple config space ops from the adapter
      vDPA/ifcvf: alloc the mgmt_dev before the adapter
      vDPA/ifcvf: decouple vq IRQ releasers from the adapter
      vDPA/ifcvf: decouple config IRQ releaser from the adapter
      vDPA/ifcvf: decouple vq irq requester from the adapter
      vDPA/ifcvf: decouple config/dev IRQ requester and vectors allocator from the adapter
      vDPA/ifcvf: ifcvf_request_irq works on ifcvf_hw
      vDPA/ifcvf: manage ifcvf_hw in the mgmt_dev
      vDPA/ifcvf: allocate the adapter in dev_add()
      vDPA/ifcvf: retire ifcvf_private_to_vf
      vDPA/ifcvf: implement features provisioning

 Documentation/driver-api/index.rst                 |    1 +
 Documentation/driver-api/virtio/index.rst          |   11 +
 Documentation/driver-api/virtio/virtio.rst         |  145 +++
 .../driver-api/virtio/writing_virtio_drivers.rst   |  197 ++++
 MAINTAINERS                                        |    5 +
 drivers/block/virtio_blk.c                         |  468 ++++++++-
 drivers/nvdimm/virtio_pmem.c                       |   11 +-
 drivers/pci/quirks.c                               |    8 +
 drivers/scsi/virtio_scsi.c                         |   14 +-
 drivers/vdpa/Kconfig                               |   30 +
 drivers/vdpa/Makefile                              |    1 +
 drivers/vdpa/ifcvf/ifcvf_base.c                    |   32 +-
 drivers/vdpa/ifcvf/ifcvf_base.h                    |   10 +-
 drivers/vdpa/ifcvf/ifcvf_main.c                    |  162 ++-
 drivers/vdpa/mlx5/Makefile                         |    2 +-
 drivers/vdpa/mlx5/core/mr.c                        |    1 -
 drivers/vdpa/mlx5/core/resources.c                 |    3 +-
 drivers/vdpa/mlx5/net/debug.c                      |  152 +++
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  261 +++--
 drivers/vdpa/mlx5/net/mlx5_vnet.h                  |   94 ++
 drivers/vdpa/solidrun/Makefile                     |    6 +
 drivers/vdpa/solidrun/snet_hwmon.c                 |  188 ++++
 drivers/vdpa/solidrun/snet_main.c                  | 1111 ++++++++++++++++++++
 drivers/vdpa/solidrun/snet_vdpa.h                  |  194 ++++
 drivers/vdpa/vdpa.c                                |  110 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |  233 ++--
 drivers/vdpa/vdpa_sim/vdpa_sim.h                   |    7 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c               |    1 +
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c               |  219 +++-
 drivers/vhost/net.c                                |    5 +-
 drivers/vhost/scsi.c                               |    6 +-
 drivers/vhost/test.c                               |    3 -
 drivers/vhost/vdpa.c                               |   39 +-
 drivers/vhost/vhost.c                              |    2 +-
 drivers/vhost/vhost.h                              |    2 +-
 drivers/vhost/vsock.c                              |    2 +-
 drivers/virtio/virtio_ring.c                       |  133 ++-
 drivers/virtio/virtio_vdpa.c                       |   13 +-
 include/linux/pci_ids.h                            |    2 +
 include/linux/vdpa.h                               |   12 +-
 include/linux/virtio_config.h                      |    8 +-
 include/linux/virtio_ring.h                        |   16 +
 include/linux/vringh.h                             |    2 +-
 include/uapi/linux/vhost.h                         |    8 +
 include/uapi/linux/vhost_types.h                   |    2 +
 include/uapi/linux/virtio_blk.h                    |  105 ++
 tools/virtio/Makefile                              |    2 +-
 47 files changed, 3536 insertions(+), 503 deletions(-)
 create mode 100644 Documentation/driver-api/virtio/index.rst
 create mode 100644 Documentation/driver-api/virtio/virtio.rst
 create mode 100644 Documentation/driver-api/virtio/writing_virtio_drivers.rst
 create mode 100644 drivers/vdpa/mlx5/net/debug.c
 create mode 100644 drivers/vdpa/mlx5/net/mlx5_vnet.h
 create mode 100644 drivers/vdpa/solidrun/Makefile
 create mode 100644 drivers/vdpa/solidrun/snet_hwmon.c
 create mode 100644 drivers/vdpa/solidrun/snet_main.c
 create mode 100644 drivers/vdpa/solidrun/snet_vdpa.h

