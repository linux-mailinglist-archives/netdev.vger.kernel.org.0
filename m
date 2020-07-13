Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6539A21C9E4
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 16:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgGLOzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 10:55:47 -0400
Received: from mga07.intel.com ([134.134.136.100]:60123 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728826AbgGLOzr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 10:55:47 -0400
IronPort-SDR: yCrpzf0qMUXqg2i2NTUwpah9v1fYbVJJXuwmgZBB+q976M1ZmLSEr0Cc5ctEdpHNZ+LkqdQVyy
 4WUcB7YsVGEA==
X-IronPort-AV: E=McAfee;i="6000,8403,9680"; a="213353168"
X-IronPort-AV: E=Sophos;i="5.75,344,1589266800"; 
   d="scan'208";a="213353168"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2020 07:55:45 -0700
IronPort-SDR: gJUXCmTd5tVBqS1SWc31K3wrUNzDbB8JPFF94ZwPVZGGFmccLuA+fmw8xBgYMHJv5pZgTaYA7e
 ui5+SOPZuJUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="458977463"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga005.jf.intel.com with ESMTP; 12 Jul 2020 07:55:42 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 0/7] *** IRQ offloading for vDPA ***
Date:   Sun, 12 Jul 2020 22:52:04 +0800
Message-Id: <1594565524-3394-1-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

This series intends to implement IRQ offloading for
vhost_vdpa.

By the feat of irq forwarding facilities like posted
interrupt on X86, irq bypass can  help deliver
interrupts to vCPU directly.

vDPA devices have dedicated hardware backends like VFIO
pass-throughed devices. So it would be possible to setup
irq offloading(irq bypass) for vDPA devices and gain
performance improvements.

In my testing, with this feature, we can save 0.1ms
in a ping between two VFs on average.


Zhu Lingshan (7):
  vhost: introduce vhost_call_ctx
  kvm/vfio: detect assigned device via irqbypass manager
  vhost_vdpa: implement IRQ offloading functions in vhost_vdpa
  vDPA: implement IRQ offloading helpers in vDPA core
  virtio_vdpa: init IRQ offloading function pointers to NULL.
  ifcvf: replace irq_request/free with helpers in vDPA core.
  irqbypass: do not start consumer or producer when failed to connect

 arch/x86/kvm/x86.c              | 10 ++++--
 drivers/vdpa/ifcvf/ifcvf_main.c | 11 +++---
 drivers/vdpa/vdpa.c             | 46 +++++++++++++++++++++++++
 drivers/vhost/Kconfig           |  1 +
 drivers/vhost/vdpa.c            | 75 +++++++++++++++++++++++++++++++++++++++--
 drivers/vhost/vhost.c           | 22 ++++++++----
 drivers/vhost/vhost.h           |  9 ++++-
 drivers/virtio/virtio_vdpa.c    |  2 ++
 include/linux/vdpa.h            | 11 ++++++
 virt/kvm/vfio.c                 |  2 --
 virt/lib/irqbypass.c            | 16 +++++----
 11 files changed, 181 insertions(+), 24 deletions(-)

-- 
1.8.3.1

