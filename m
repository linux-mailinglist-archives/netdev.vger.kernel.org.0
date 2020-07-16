Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BC6222156
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 13:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgGPL1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 07:27:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:8123 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgGPL1i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 07:27:38 -0400
IronPort-SDR: xV2xPLtzzTvfoU1Val7CBl6MBpr367vLrC4pw7YvMBTpTNWIo5WOhB2FdLppJXwssMYF1Yh23+
 Bi5n7mxMkeUw==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="149350090"
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="149350090"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 04:27:37 -0700
IronPort-SDR: jIW0pVSPd9YOifcBmO2kcenGTvkvM/k72dY+Xq6a0AnDPgBKdN9CrLKYyCg/fcEUegZ+tep4nf
 4E5kfBa3HtoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="460442794"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga005.jf.intel.com with ESMTP; 16 Jul 2020 04:27:34 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 0/6] IRQ offloading for vDPA
Date:   Thu, 16 Jul 2020 19:23:43 +0800
Message-Id: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
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

changes from V1:
(1)dropped vfio changes.
(3)removed KVM_HVAE_IRQ_BYPASS checks
(4)locking fixes
(5)simplified vhost_vdpa_update_vq_irq()
(6)minor improvements

Zhu Lingshan (6):
  vhost: introduce vhost_call_ctx
  kvm: detect assigned device via irqbypass manager
  vDPA: implement IRQ offloading helpers in vDPA core
  vhost_vdpa: implement IRQ offloading in vhost_vdpa
  ifcvf: replace irq_request/free with vDPA helpers
  irqbypass: do not start cons/prod when failed connect

 arch/x86/kvm/x86.c              | 10 ++++++--
 drivers/vdpa/ifcvf/ifcvf_main.c | 14 +++++++----
 drivers/vdpa/vdpa.c             | 42 +++++++++++++++++++++++++++++++++
 drivers/vhost/Kconfig           |  1 +
 drivers/vhost/vdpa.c            | 52 +++++++++++++++++++++++++++++++++++++++--
 drivers/vhost/vhost.c           | 22 ++++++++++++-----
 drivers/vhost/vhost.h           |  9 ++++++-
 include/linux/vdpa.h            | 13 +++++++++++
 virt/lib/irqbypass.c            | 16 ++++++++-----
 9 files changed, 157 insertions(+), 22 deletions(-)

-- 
1.8.3.1

