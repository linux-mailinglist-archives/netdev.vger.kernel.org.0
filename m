Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F385591336
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237430AbiHLPnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238720AbiHLPnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:43:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6632026551
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 08:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660318980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dU06y8+WFEqxVVNCdptk9Tc9JwQCiUowOye+07FhZZk=;
        b=TxdUZ9z8AzrGuX232UTOtCCMXPWAbqOtizlNu2FHr4ueRMWxH/pgcIZTj4SavX/vSMMH4n
        sdnDiqdrpgjJapXfXAILcGs+MKs0eMhu1E4tro/XTSwZs3Q4DIe3CpDiOYMgvfzvY38nA8
        8oryIiwUwyNMP/7vZvyLLnVU2YW3//U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-551-2v7PSNmGOKOJB-hZ3j0DNg-1; Fri, 12 Aug 2022 11:42:59 -0400
X-MC-Unique: 2v7PSNmGOKOJB-hZ3j0DNg-1
Received: by mail-wm1-f71.google.com with SMTP id i65-20020a1c3b44000000b003a537031613so4465811wma.2
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 08:42:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=dU06y8+WFEqxVVNCdptk9Tc9JwQCiUowOye+07FhZZk=;
        b=qiEhSh7VX+Xt3ODJ4VkSBv9vN/uF0Gaa11d1r5bb3W0fS79NdokRea6nV7YWJv1b+B
         D3/oyQFrV51QcK8wV/bKRB+EpfzvbXDz6/rs+K02EQ9WqAf123B8J7Ku2c51I0717mUU
         3r6v+0taOtSKFrW/KUFbb4vdORc2EA+AefDel/jC5TNk87ufMs6kQ8Ai1/ya5vZ69vH2
         hhB56Z2mulTNBdyY1ialQe8NgE5Q3YVEpFkTKCyhGJ6PQbIeBvn7EI7rJIQIIYn6Wv45
         CgEOmQkZayPxDG0FlL6hbtW/RSNRtS6WT48lg9EAv5GZOP2v1zle3k5nV42XkYpz84sh
         l+Jg==
X-Gm-Message-State: ACgBeo2hoQg4UTDi4qrLpvQQUmTMEPcVyPzsGttI9ZbV2+FpGEC6Y+u0
        6EEYfpk+Zls5QOJNgbEWHuO+srST+wsB86EvsNlj9UZp/xIAWNQ1V1BCrBSbQoNDqatCbFX0M/M
        e99ck357EnRjofuMy
X-Received: by 2002:a05:6000:1888:b0:222:c96d:862f with SMTP id a8-20020a056000188800b00222c96d862fmr2441133wri.706.1660318978274;
        Fri, 12 Aug 2022 08:42:58 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4eX4UTrlOMsC6tsiDzrk0RxUAoIqtKyE9JwEfcKp7sOMME89M6xJltrqsn3/+oIEuf2mbBGw==
X-Received: by 2002:a05:6000:1888:b0:222:c96d:862f with SMTP id a8-20020a056000188800b00222c96d862fmr2441121wri.706.1660318977953;
        Fri, 12 Aug 2022 08:42:57 -0700 (PDT)
Received: from redhat.com ([2.52.152.113])
        by smtp.gmail.com with ESMTPSA id n18-20020a7bc5d2000000b003a0375c4f73sm3124129wmk.44.2022.08.12.08.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 08:42:57 -0700 (PDT)
Date:   Fri, 12 Aug 2022 11:42:50 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alvaro.karsz@solid-run.com, colin.i.king@gmail.com,
        colin.king@intel.com, dan.carpenter@oracle.com, david@redhat.com,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@xilinx.com,
        gshan@redhat.com, hdegoede@redhat.com, hulkci@huawei.com,
        jasowang@redhat.com, jiaming@nfschina.com,
        kangjie.xu@linux.alibaba.com, lingshan.zhu@intel.com,
        liubo03@inspur.com, michael.christie@oracle.com, mst@redhat.com,
        pankaj.gupta@amd.com, peng.fan@nxp.com, quic_mingxue@quicinc.com,
        robin.murphy@arm.com, sgarzare@redhat.com, suwan.kim027@gmail.com,
        syoshida@redhat.com, xieyongji@bytedance.com,
        xuanzhuo@linux.alibaba.com, xuqiang36@huawei.com
Subject: [GIT PULL] virtio: fatures, fixes
Message-ID: <20220812114250-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 3d7cb6b04c3f3115719235cc6866b10326de34cd:

  Linux 5.19 (2022-07-31 14:03:01 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 93e530d2a1c4c0fcce45e01ae6c5c6287a08d3e3:

  vdpa/mlx5: Fix possible uninitialized return value (2022-08-11 10:00:36 -0400)

----------------------------------------------------------------
virtio: fatures, fixes

A huge patchset supporting vq resize using the
new vq reset capability.
Features, fixes, cleanups all over the place.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Alvaro Karsz (1):
      net: virtio_net: notifications coalescing support

Bo Liu (3):
      virtio: Check dev_set_name() return value
      vhost-vdpa: Call ida_simple_remove() when failed
      virtio_vdpa: support the arg sizes of find_vqs()

Colin Ian King (1):
      vDPA/ifcvf: remove duplicated assignment to pointer cfg

David Hildenbrand (1):
      drivers/virtio: Clarify CONFIG_VIRTIO_MEM for unsupported architectures

Eli Cohen (3):
      vdpa/mlx5: Implement susupend virtqueue callback
      vdpa/mlx5: Support different address spaces for control and data
      vdpa/mlx5: Fix possible uninitialized return value

Eugenio Pérez (4):
      vdpa: Add suspend operation
      vhost-vdpa: introduce SUSPEND backend feature bit
      vhost-vdpa: uAPI to suspend the device
      vdpa_sim: Implement suspend vdpa op

Jason Wang (2):
      virtio_pmem: initialize provider_data through nd_region_desc
      virtio_pmem: set device ready in probe()

Michael S. Tsirkin (1):
      virtio: VIRTIO_HARDEN_NOTIFICATION is broken

Mike Christie (2):
      vhost-scsi: Fix max number of virtqueues
      vhost scsi: Allow user to control num virtqueues

Minghao Xue (2):
      dt-bindings: virtio: mmio: add optional wakeup-source property
      virtio_mmio: add support to set IRQ of a virtio device as wakeup source

Robin Murphy (1):
      vdpa: Use device_iommu_capable()

Shigeru Yoshida (1):
      virtio-blk: Avoid use-after-free on suspend/resume

Stefano Garzarella (11):
      vringh: iterate on iotlb_translate to handle large translations
      vdpa_sim_blk: use dev_dbg() to print errors
      vdpa_sim_blk: limit the number of request handled per batch
      vdpa_sim_blk: call vringh_complete_iotlb() also in the error path
      vdpa_sim_blk: set number of address spaces and virtqueue groups
      vdpa_sim: use max_iotlb_entries as a limit in vhost_iotlb_init
      tools/virtio: fix build
      vdpa_sim_blk: check if sector is 0 for commands other than read or write
      vdpa_sim_blk: make vdpasim_blk_check_range usable by other requests
      vdpa_sim_blk: add support for VIRTIO_BLK_T_FLUSH
      vdpa_sim_blk: add support for discard and write-zeroes

Xie Yongji (5):
      vduse: Remove unnecessary spin lock protection
      vduse: Use memcpy_{to,from}_page() in do_bounce()
      vduse: Support using userspace pages as bounce buffer
      vduse: Support registering userspace memory for IOVA regions
      vduse: Support querying information of IOVA regions

Xu Qiang (1):
      vdpa/mlx5: Use eth_broadcast_addr() to assign broadcast address

Xuan Zhuo (44):
      remoteproc: rename len of rpoc_vring to num
      virtio_ring: remove the arg vq of vring_alloc_desc_extra()
      virtio: record the maximum queue num supported by the device.
      virtio: struct virtio_config_ops add callbacks for queue_reset
      virtio_ring: update the document of the virtqueue_detach_unused_buf for queue reset
      virtio_ring: extract the logic of freeing vring
      virtio_ring: split vring_virtqueue
      virtio_ring: introduce virtqueue_init()
      virtio_ring: split: stop __vring_new_virtqueue as export symbol
      virtio_ring: split: __vring_new_virtqueue() accept struct vring_virtqueue_split
      virtio_ring: split: introduce vring_free_split()
      virtio_ring: split: extract the logic of alloc queue
      virtio_ring: split: extract the logic of alloc state and extra
      virtio_ring: split: extract the logic of vring init
      virtio_ring: split: extract the logic of attach vring
      virtio_ring: split: introduce virtqueue_reinit_split()
      virtio_ring: split: reserve vring_align, may_reduce_num
      virtio_ring: split: introduce virtqueue_resize_split()
      virtio_ring: packed: introduce vring_free_packed
      virtio_ring: packed: extract the logic of alloc queue
      virtio_ring: packed: extract the logic of alloc state and extra
      virtio_ring: packed: extract the logic of vring init
      virtio_ring: packed: extract the logic of attach vring
      virtio_ring: packed: introduce virtqueue_reinit_packed()
      virtio_ring: packed: introduce virtqueue_resize_packed()
      virtio_ring: introduce virtqueue_resize()
      virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
      virtio: allow to unbreak/break virtqueue individually
      virtio: queue_reset: add VIRTIO_F_RING_RESET
      virtio_ring: struct virtqueue introduce reset
      virtio_pci: struct virtio_pci_common_cfg add queue_reset
      virtio_pci: introduce helper to get/set queue reset
      virtio_pci: extract the logic of active vq for modern pci
      virtio_pci: support VIRTIO_F_RING_RESET
      virtio: find_vqs() add arg sizes
      virtio_pci: support the arg sizes of find_vqs()
      virtio_mmio: support the arg sizes of find_vqs()
      virtio: add helper virtio_find_vqs_ctx_size()
      virtio_net: set the default max ring size by find_vqs()
      virtio_net: get ringparam by virtqueue_get_vring_max_size()
      virtio_net: split free_unused_bufs()
      virtio_net: support rx queue resize
      virtio_net: support tx queue resize
      virtio_net: support set_ringparam

Zhang Jiaming (1):
      vdpa: ifcvf: Fix spelling mistake in comments

Zhu Lingshan (4):
      vDPA/ifcvf: get_config_size should return a value no greater than dev implementation
      vDPA/ifcvf: support userspace to query features and MQ of a management device
      vDPA: !FEATURES_OK should not block querying device config space
      vDPA: fix 'cast to restricted le16' warnings in vdpa.c

 Documentation/devicetree/bindings/virtio/mmio.yaml |   4 +
 arch/um/drivers/virtio_uml.c                       |   3 +-
 drivers/block/virtio_blk.c                         |  24 +-
 drivers/net/virtio_net.c                           | 325 +++++++-
 drivers/nvdimm/virtio_pmem.c                       |   9 +-
 drivers/platform/mellanox/mlxbf-tmfifo.c           |   3 +
 drivers/remoteproc/remoteproc_core.c               |   4 +-
 drivers/remoteproc/remoteproc_virtio.c             |  13 +-
 drivers/s390/virtio/virtio_ccw.c                   |   4 +
 drivers/vdpa/ifcvf/ifcvf_base.c                    |  14 +-
 drivers/vdpa/ifcvf/ifcvf_base.h                    |   2 +
 drivers/vdpa/ifcvf/ifcvf_main.c                    | 144 ++--
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |  11 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  | 175 ++++-
 drivers/vdpa/vdpa.c                                |  14 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |  18 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.h                   |   1 +
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c               | 176 ++++-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c               |   3 +
 drivers/vdpa/vdpa_user/iova_domain.c               | 102 ++-
 drivers/vdpa/vdpa_user/iova_domain.h               |   8 +
 drivers/vdpa/vdpa_user/vduse_dev.c                 | 180 +++++
 drivers/vhost/scsi.c                               |  85 ++-
 drivers/vhost/vdpa.c                               |  38 +-
 drivers/vhost/vringh.c                             |  78 +-
 drivers/virtio/Kconfig                             |  11 +-
 drivers/virtio/virtio.c                            |   4 +-
 drivers/virtio/virtio_mmio.c                       |  14 +-
 drivers/virtio/virtio_pci_common.c                 |  32 +-
 drivers/virtio/virtio_pci_common.h                 |   3 +-
 drivers/virtio/virtio_pci_legacy.c                 |   8 +-
 drivers/virtio/virtio_pci_modern.c                 | 153 +++-
 drivers/virtio/virtio_pci_modern_dev.c             |  39 +
 drivers/virtio/virtio_ring.c                       | 814 +++++++++++++++------
 drivers/virtio/virtio_vdpa.c                       |  18 +-
 include/linux/mlx5/mlx5_ifc_vdpa.h                 |   8 +
 include/linux/remoteproc.h                         |   4 +-
 include/linux/vdpa.h                               |   4 +
 include/linux/virtio.h                             |  10 +
 include/linux/virtio_config.h                      |  40 +-
 include/linux/virtio_pci_modern.h                  |   9 +
 include/linux/virtio_ring.h                        |  10 -
 include/uapi/linux/vduse.h                         |  47 ++
 include/uapi/linux/vhost.h                         |   9 +
 include/uapi/linux/vhost_types.h                   |   2 +
 include/uapi/linux/virtio_config.h                 |   7 +-
 include/uapi/linux/virtio_net.h                    |  34 +-
 include/uapi/linux/virtio_pci.h                    |   2 +
 tools/virtio/linux/kernel.h                        |   2 +-
 tools/virtio/linux/vringh.h                        |   1 +
 tools/virtio/virtio_test.c                         |   4 +-
 51 files changed, 2171 insertions(+), 556 deletions(-)

