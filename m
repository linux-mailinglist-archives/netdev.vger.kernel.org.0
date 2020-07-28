Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533352300BC
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 06:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgG1E2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 00:28:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:58408 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbgG1E2K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 00:28:10 -0400
IronPort-SDR: f7SOb9lqMiarA5gkX+CljDMVI0E7qLJfOHLZHcIAzTBDmha014wPxaU8p0Xd23elvbv8J6M9F5
 aef50eO3ti/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="138665747"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="138665747"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 21:28:09 -0700
IronPort-SDR: xeUqyBN6CpOAJrUyAF0sVjtt78TIm171Ub7DFnAvWAc1MHPnEBw9A3F9dRG2NWEfjiJkovt9fm
 ue6vjhU0aGuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="290037157"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga006.jf.intel.com with ESMTP; 27 Jul 2020 21:28:04 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 0/6] IRQ offloading for vDPA
Date:   Tue, 28 Jul 2020 12:23:59 +0800
Message-Id: <20200728042405.17579-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
changes from V3:
(1)removed vDPA irq allocate/free helpers in vDPA core.
(2)add a new function get_vq_irq() in struct vdpa_config_ops,
upper layer driver can use this function to: A. query the
irq numbner of a vq. B. detect whether a vq is enabled.
(3)implement get_vq_irq() in ifcvf driver.
(4)in vhost_vdpa, set_status() will setup irq offloading when
setting DRIVER_OK, and unsetup when receive !DRIVER_OK.
(5)minor improvements.

changes from V2:
(1)rename struct vhost_call_ctx to vhost_vring_call
(2)add kvm_arch_end_assignment() in del_producer()
code path
(3)rename vDPA helpers to vdpa_devm_request_irq()
and vdpa_devm_free_irq(). Add better comments
for them.
(4)better comments for setup_vq_irq() and
unsetup_vq_irq()
(5)In vDPA VHOST_SET_VRING_CALL, will call vhost_vdpa_update_vq_irq()
without checking producer.irq, move this check into
vhost_vdpa_update_vq_irq(), so that get advantage of the spinlock.
(6)Add a function vhost_vdpa_clean_irq(), this function will unregister
the producer of vqs when vhost_vdpa_release(). This is safe
for control vq.
(7) minor improvements

changes from V1:
(1)dropped vfio changes.
(3)removed KVM_HVAE_IRQ_BYPASS checks
(4)locking fixes
(5)simplified vhost_vdpa_updat


Zhu Lingshan (6):
  vhost: introduce vhost_vring_call
  kvm: detect assigned device via irqbypass manager
  vDPA: add get_vq_irq() in vdpa_config_ops
  vhost_vdpa: implement IRQ offloading in vhost_vdpa
  ifcvf: implement vdpa_config_ops.get_vq_irq()
  irqbypass: do not start cons/prod when failed connect

 arch/x86/kvm/x86.c              | 12 ++++-
 drivers/vdpa/ifcvf/ifcvf_main.c | 18 ++++++-
 drivers/vhost/Kconfig           |  1 +
 drivers/vhost/vdpa.c            | 83 +++++++++++++++++++++++++++++++--
 drivers/vhost/vhost.c           | 22 ++++++---
 drivers/vhost/vhost.h           |  9 +++-
 include/linux/vdpa.h            |  6 +++
 virt/lib/irqbypass.c            | 16 ++++---
 8 files changed, 147 insertions(+), 20 deletions(-)

-- 
2.18.4

