Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7A549CA20
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 13:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241559AbiAZM4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 07:56:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:29543 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241558AbiAZM4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 07:56:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643201773; x=1674737773;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qMZDzXdDMj3mmMYi5pfzFtzgOz2wZ/XbeVSEmtDvymU=;
  b=QgMi9nu5Y9HmDvMztB3OtC7W4MnO/948U3RuEXI9o2dMI1eygisODJk+
   0uxOrzkknB1VPJ5DLZiF4XKIXgMK+DAXXibzr5vCGnIeNwa00aWf9gI61
   u2oMOAj+J1yY/rfTizyh8aiz/g4IROMWBTLcw/r3HOjEjfDz4w92GaJZR
   XFSSJs/8Snd0L5uNdUnA5QVZzsOfkA+qLBzpKJrvRJrMZVNXtLCDYX+IJ
   FxjJ0pNRDthyncYQ+z4qYYOjWBDvfka/xixX4mVaH1gOArJ9z5zqDlcb/
   2kk/38bl6FabO1YwsONvwsfwsydLpwUUDoOksr6qACR1AYSQPC5fivKh1
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="244141256"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="244141256"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 04:56:12 -0800
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="520783484"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 04:56:11 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 0/4] vDPA/ifcvf: implement shared IRQ feature 
Date:   Wed, 26 Jan 2022 20:49:08 +0800
Message-Id: <20220126124912.90205-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has been observed that on some platforms/devices, there may
not be enough MSI vectors for virtqueues and the config change.
Under such circumstances, the interrupt sources of a device
have to share vectors/IRQs.

This series implemented a shared IRQ feature for ifcvf.

Please help review.

Changes from V2:
(1) Fix misuse of nvectors(in ifcvf_alloc_vectors return value)(Michael)
(2) Fix misuse of irq = get_vq_irq() in setup irqbypass(Michael)
(3) Coding style improvements(Michael)
(4) Better naming of device shared irq/shared vq irq

Changes from V1:
(1) Enable config interrupt when only one vector is allocated(Michael)
(2) Clean vectors/IRQs if failed to request config interrupt
since config interrupt is a must(Michael)
(3) Keep local vdpa_ops, disable irq_bypass by setting IRQ = -EINVAL
for shared IRQ case(Michael)
(4) Improvements on error messages(Michael)
(5) Squash functions implementation patches to the callers(Michael)

Zhu Lingshan (4):
  vDPA/ifcvf: implement IO read/write helpers in the header file
  vDPA/ifcvf: implement device MSIX vector allocator
  vhost_vdpa: don't setup irq offloading when irq_num < 0
  vDPA/ifcvf: implement shared IRQ feature

 drivers/vdpa/ifcvf/ifcvf_base.c |  67 +++-----
 drivers/vdpa/ifcvf/ifcvf_base.h |  60 +++++++-
 drivers/vdpa/ifcvf/ifcvf_main.c | 260 ++++++++++++++++++++++++++++----
 drivers/vhost/vdpa.c            |   4 +
 4 files changed, 312 insertions(+), 79 deletions(-)

-- 
2.27.0

