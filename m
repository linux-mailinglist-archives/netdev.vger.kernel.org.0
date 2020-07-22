Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4099F2295BE
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731473AbgGVKM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:12:57 -0400
Received: from mga03.intel.com ([134.134.136.65]:1548 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbgGVKM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 06:12:56 -0400
IronPort-SDR: xeW5ChbJpf/r2hLVs7ISik6HeAoNHCNeqlodkZVFrBw66srS79v/OMA6s9bG+w+GGqiXcEf9yy
 DqTodx/xuXQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="150280654"
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="150280654"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 03:12:54 -0700
IronPort-SDR: 3QwdtUb5jyy1VyXx3+rx0BvLTgUOlHZ1VO/vqj1UQFRCT+GJKpUvYEVZomzh8cizIj1UYv4svO
 Ee192DZAK1zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="392634853"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by fmsmga001.fm.intel.com with ESMTP; 22 Jul 2020 03:12:52 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 0/6] IRQ offloading for vDPA
Date:   Wed, 22 Jul 2020 18:08:53 +0800
Message-Id: <20200722100859.221669-1-lingshan.zhu@intel.com>
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
(5)simplified vhost_vdpa_updat

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

