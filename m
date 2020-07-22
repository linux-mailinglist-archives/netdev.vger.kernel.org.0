Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C85229577
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 11:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731436AbgGVJxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 05:53:06 -0400
Received: from mga18.intel.com ([134.134.136.126]:63311 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgGVJxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 05:53:06 -0400
IronPort-SDR: ZDEEjv6F7/YUYAKCvnGdZiu66YBAuNsNT0wjyaW3Bqp14+1xprVCbIW8i0gZ9ERxZO7Ax2fwr1
 Cl9WuqwMbT1Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="137804228"
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="137804228"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 02:53:05 -0700
IronPort-SDR: 7KJ6UsqeyYgkOsvhtp/wSxLkEzP18miCfz/0UJI3ez1eKMFvPQl61uRoMNNqaev27ltyVyXZ2L
 zltqv2RWcwoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="487936068"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by fmsmga006.fm.intel.com with ESMTP; 22 Jul 2020 02:53:02 -0700
From:   Zhu Lingshan <lingshan.zhu@live.com>
To:     jasowang@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@live.com>
Subject: [PATCH V3 0/6] IRQ offloading for vDPA
Date:   Wed, 22 Jul 2020 17:49:04 +0800
Message-Id: <20200722094910.218014-1-lingshan.zhu@live.com>
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
(5)simplified vhost_vdpa_update_vq_irq()
(6)minor improvements

Zhu Lingshan (6):
  vhost: introduce vhost_vring_call
  kvm: detect assigned device via irqbypass manager
  vDPA: implement vq IRQ allocate/free helpers in vDPA core
  vhost_vdpa: implement IRQ offloading in vhost_vdpa
  ifcvf: replace irq_request/free with vDPA helpers
  irqbypass: do not start cons/prod when failed connect

 arch/x86/kvm/x86.c              | 11 +++++-
 drivers/vdpa/ifcvf/ifcvf_main.c | 14 ++++---
 drivers/vdpa/vdpa.c             | 49 +++++++++++++++++++++++
 drivers/vhost/Kconfig           |  1 +
 drivers/vhost/vdpa.c            | 70 +++++++++++++++++++++++++++++++--
 drivers/vhost/vhost.c           | 22 ++++++++---
 drivers/vhost/vhost.h           |  9 ++++-
 include/linux/vdpa.h            | 13 ++++++
 virt/lib/irqbypass.c            | 16 +++++---
 9 files changed, 182 insertions(+), 23 deletions(-)

-- 
2.18.4

