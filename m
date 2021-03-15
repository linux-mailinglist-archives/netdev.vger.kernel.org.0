Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5F433C20E
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhCOQfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:35:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232340AbhCOQfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:35:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615826105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8E7bQAO4mPMCMNy7czH8SXiPxDN2NhK2/K7/V4lwNsU=;
        b=YRgBnMnfDejZ2g4awmLGc/qsn/OSoekn0Hp5B3W2Xzgqh32t1PFTOFvbTrPOZFlc0r/Sjz
        zLM3a2gL/wiPVZhg1e8Kg4A0mksK/e+HeqWZgzdxeWbLpVR45lvql5PfndLNBus5l5fsnp
        DbSA1kcTBhBBBejqkcPmMS3Yy/3Dv8c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-3bB14KOROdS3_D81865z-Q-1; Mon, 15 Mar 2021 12:35:01 -0400
X-MC-Unique: 3bB14KOROdS3_D81865z-Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E03A6100C663;
        Mon, 15 Mar 2021 16:34:59 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-1.ams2.redhat.com [10.36.114.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 47AD319D7C;
        Mon, 15 Mar 2021 16:34:51 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v4 00/14] vdpa: add vdpa simulator for block device
Date:   Mon, 15 Mar 2021 17:34:36 +0100
Message-Id: <20210315163450.254396-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v4:
- added support for iproute2 vdpa management tool in vdpa_sim_blk
- removed get/set_config patches
  - 'vdpa: add return value to get_config/set_config callbacks'
  - 'vhost/vdpa: remove vhost_vdpa_config_validate()'
- added get_config_size() patches
  - 'vdpa: add get_config_size callback in vdpa_config_ops'
  - 'vhost/vdpa: use get_config_size callback in vhost_vdpa_config_validate()'

v3: https://lore.kernel.org/lkml/20210204172230.85853-1-sgarzare@redhat.com/
v2: https://lore.kernel.org/lkml/20210128144127.113245-1-sgarzare@redhat.com/
v1: https://lore.kernel.org/lkml/93f207c0-61e6-3696-f218-e7d7ea9a7c93@redhat.com/

This series is the second part of the v1 linked above. The first part with
refactoring of vdpa_sim has already been merged.

The patches are based on Max Gurtovoy's work and extend the block simulator to
have a ramdisk behaviour.

As mentioned in the v1 there was 2 issues and I fixed them in this series:
1. The identical mapping in the IOMMU used until now in vdpa_sim created issues
   when mapping different virtual pages with the same physical address.
   Fixed by patch "vdpa_sim: use iova module to allocate IOVA addresses"

2. There was a race accessing the IOMMU between the vdpasim_blk_work() and the
   device driver that map/unmap DMA regions. Fixed by patch "vringh: add
   'iotlb_lock' to synchronize iotlb accesses"

I used the Xie's patch coming from VDUSE series to allow vhost-vdpa to use
block devices, and I added get_config_size() callback to allow any device
in vhost-vdpa.

The series also includes small fixes for vringh, vdpa, and vdpa_sim that I
discovered while implementing and testing the block simulator.

Thanks for your feedback,
Stefano

Max Gurtovoy (1):
  vdpa: add vdpa simulator for block device

Stefano Garzarella (12):
  vdpa_sim: use iova module to allocate IOVA addresses
  vringh: add 'iotlb_lock' to synchronize iotlb accesses
  vringh: reset kiov 'consumed' field in __vringh_iov()
  vringh: explain more about cleaning riov and wiov
  vringh: implement vringh_kiov_advance()
  vringh: add vringh_kiov_length() helper
  vdpa_sim: cleanup kiovs in vdpasim_free()
  vdpa: add get_config_size callback in vdpa_config_ops
  vhost/vdpa: use get_config_size callback in
    vhost_vdpa_config_validate()
  vdpa_sim_blk: implement ramdisk behaviour
  vdpa_sim_blk: handle VIRTIO_BLK_T_GET_ID
  vdpa_sim_blk: add support for vdpa management tool

Xie Yongji (1):
  vhost/vdpa: Remove the restriction that only supports virtio-net
    devices

 drivers/vdpa/vdpa_sim/vdpa_sim.h     |   2 +
 include/linux/vdpa.h                 |   4 +
 include/linux/vringh.h               |  19 +-
 drivers/vdpa/ifcvf/ifcvf_main.c      |   6 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c    |   6 +
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 127 ++++++----
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 338 +++++++++++++++++++++++++++
 drivers/vdpa/virtio_pci/vp_vdpa.c    |   8 +
 drivers/vhost/vdpa.c                 |  15 +-
 drivers/vhost/vringh.c               |  69 ++++--
 drivers/vdpa/Kconfig                 |   8 +
 drivers/vdpa/vdpa_sim/Makefile       |   1 +
 12 files changed, 529 insertions(+), 74 deletions(-)
 create mode 100644 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c

-- 
2.30.2

