Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA07C2766D7
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgIXDVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:21:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbgIXDVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:21:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ulvoXaawU1LlJCvKBwZXwnTD0YBj1z2Rn2hoHe4yuKA=;
        b=Ji0Pi0uvPp+TIOMcy7TqKvbmb1ZtbqIvG1BlqmBthkHyr4kg2kQzcTd4PSeGnt3tT+UNXf
        aptIQ8vX9W9/s1kBWO9v6EjMWoyY9AG8W9LBYM891Bw987g5iOXMMNWTKQmlP+lFqaZYBF
        uMFGMpx5d5OVokR7b79LNqnVEjmP8zs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-nXpWs3-YNjaBVu0TOZk99g-1; Wed, 23 Sep 2020 23:21:45 -0400
X-MC-Unique: nXpWs3-YNjaBVu0TOZk99g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F5251005E72;
        Thu, 24 Sep 2020 03:21:43 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2852B3782;
        Thu, 24 Sep 2020 03:21:27 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 00/24] Control VQ support in vDPA
Date:   Thu, 24 Sep 2020 11:21:01 +0800
Message-Id: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All:

This series tries to add the support for control virtqueue in vDPA.

Control virtqueue is used by networking device for accepting various
commands from the driver. It's a must to support multiqueue and other
configurations.

When used by vhost-vDPA bus driver for VM, the control virtqueue
should be shadowed via userspace VMM (Qemu) instead of being assigned
directly to Guest. This is because Qemu needs to know the device state
in order to start and stop device correctly (e.g for Live Migration).

This requies to isolate the memory mapping for control virtqueue
presented by vhost-vDPA to prevent guest from accesing it directly.

To achieve this, vDPA introduce two new abstractions:

- address space: identified through address space id (ASID) and a set
                 of memory mapping in maintained
- virtqueue group: the minimal set of virtqueues that must share an
                 address space

Device needs to advertise the following attributes to vDPA:

- the number of address spaces supported in the device
- the number of virtqueue groups supported in the device
- the mappings from a specific virtqueue to its virtqueue groups

The mappings from virtqueue to virtqueue groups is fixed and defined
by vDPA device driver. E.g:

- For the device that has hardware ASID support, it can simply
  advertise a per virtqueue virtqueue group.
- For the device that does not have hardware ASID support, it can
  simply advertise a single virtqueue group that contains all
  virtqueues. Or if it wants a software emulated control virtqueue, it
  can advertise two virtqueue groups, one is for cvq, another is for
  the rest virtqueues.

vDPA also allow to change the association between virtqueue group and
address space. So in the case of control virtqueue, userspace
VMM(Qemu) may use a dedicated address space for the control virtqueue
group to isolate the memory mapping.

The vhost/vhost-vDPA is also extend for the userspace to:

- query the number of virtqueue groups and address spaces supported by
  the device
- query the virtqueue group for a specific virtqueue
- assocaite a virtqueue group with an address space
- send ASID based IOTLB commands

This will help userspace VMM(Qemu) to detect whether the control vq
could be supported and isolate memory mappings of control virtqueue
from the others.

To demonstrate the usage, vDPA simulator is extended to support
setting MAC address via a emulated control virtqueue. Please refer
patch 24 for more implementation details.

Please review.

Note that patch 1 and a equivalent of patch 2 have been posted in the
list. Those two are requirement for this series to work, so I add them
here.

Thank

Jason Wang (24):
  vhost-vdpa: fix backend feature ioctls
  vhost-vdpa: fix vqs leak in vhost_vdpa_open()
  vhost: move the backend feature bits to vhost_types.h
  virtio-vdpa: don't set callback if virtio doesn't need it
  vhost-vdpa: passing iotlb to IOMMU mapping helpers
  vhost-vdpa: switch to use vhost-vdpa specific IOTLB
  vdpa: add the missing comment for nvqs in struct vdpa_device
  vdpa: introduce virtqueue groups
  vdpa: multiple address spaces support
  vdpa: introduce config operations for associating ASID to a virtqueue
    group
  vhost_iotlb: split out IOTLB initialization
  vhost: support ASID in IOTLB API
  vhost-vdpa: introduce ASID based IOTLB
  vhost-vdpa: introduce uAPI to get the number of virtqueue groups
  vhost-vdpa: introduce uAPI to get the number of address spaces
  vhost-vdpa: uAPI to get virtqueue group id
  vhost-vdpa: introduce uAPI to set group ASID
  vhost-vdpa: support ASID based IOTLB API
  vdpa_sim: use separated iov for reading and writing
  vdpa_sim: advertise VIRTIO_NET_F_MTU
  vdpa_sim: advertise VIRTIO_NET_F_MAC
  vdpa_sim: factor out buffer completion logic
  vdpa_sim: filter destination mac address
  vdpasim: control virtqueue support

 drivers/vdpa/ifcvf/ifcvf_main.c   |   9 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c |  11 +-
 drivers/vdpa/vdpa.c               |   8 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c  | 293 ++++++++++++++++++++++++------
 drivers/vhost/iotlb.c             |  23 ++-
 drivers/vhost/vdpa.c              | 259 ++++++++++++++++++++------
 drivers/vhost/vhost.c             |  23 ++-
 drivers/vhost/vhost.h             |   4 +-
 drivers/virtio/virtio_vdpa.c      |   2 +-
 include/linux/vdpa.h              |  42 ++++-
 include/linux/vhost_iotlb.h       |   2 +
 include/uapi/linux/vhost.h        |  19 +-
 include/uapi/linux/vhost_types.h  |  10 +-
 13 files changed, 556 insertions(+), 149 deletions(-)

-- 
2.20.1

