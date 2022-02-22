Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7834BF26A
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 08:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiBVHJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 02:09:03 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiBVHJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 02:09:02 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F738B151B
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 23:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645513718; x=1677049718;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QiOhjCd6PqAvLDGm+qbsC/uyhrPnBAuqrt26BCUm6mw=;
  b=f89L5m0+2r2LlA+OGj638eFV/68/EgXXWptDPxeNBNoqq0q0A6SKx73P
   QZe9tDTH00qKfsxyx1Qv+avhxCNpTqZ4xcUT4v7rzimybaQpyTxC0lKce
   MI7kr3QA9sJxgiN+VMHIBupzy5rF+6ncfaPI5pFWe1dJT5sKaLihFurpw
   ASqde+0E3Zf+STKBwQsWxb9b0lmR/K6FMKGzCSPv4BeY6iX0jtZdBhaRL
   8fMkjB2Y0HCBGIZaAunfQ+s5RmMll3L5bXbcpOoGugVds5hPRM744ORTI
   u4RxipLPYzMA0ZnQ75QLmsCIrDIA8zzkHgUY1ekvB3bsp+nzuBUYkxpIC
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="249207291"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="249207291"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 23:08:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="776207121"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 23:08:36 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 0/5] vDPA/ifcvf: implement shared IRQ feature 
Date:   Tue, 22 Feb 2022 15:01:04 +0800
Message-Id: <20220222070109.931260-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has been observed that on some platforms/devices, there may
not be enough MSI vectors for virtqueues and the config change.
Under such circumstances, the interrupt sources of a device
have to share vectors/IRQs.

This series implemented a shared IRQ feature for ifcvf.

Please help review.

For the test report, plase kindly refer to V3  cover letter:
https://www.spinics.net/lists/netdev/msg795808.html

Changes from V4:
(1) Insted of checking errors by themself, set_vq_vector() and
set_config_vector() would return the value read from the corresponding
registers, then let the caller do error handling.
So hw_disable() can use them.(Jason)
(2)Use virtio pci modern IO helers than ifcvf_read/write_xxx (Jason)
(3)Free all IRQs and vectors once failed in request_irq and its
subroutines, don't wait for a restart caused by start_datapath fail or
device reset issued from the guest.
(4) Better naming: vqs-reused-irq --> vqs_reused_irq,
ifcvf_dev_shared_irq --> ifcvf_dev_irq (Michael)
(5) A separate patch for ifcvf_hw cacheline alignment(Michael)

Changes from V3:
fix code indenting issues reported by LKP:

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

Zhu Lingshan (5):
  vDPA/ifcvf: make use of virtio pci modern IO helpers in ifcvf
  vhost_vdpa: don't setup irq offloading when irq_num < 0
  vDPA/ifcvf: implement device MSIX vector allocator
  vDPA/ifcvf: implement shared IRQ feature
  vDPA/ifcvf: cacheline alignment for ifcvf_hw

 drivers/vdpa/ifcvf/ifcvf_base.c | 120 +++++-------
 drivers/vdpa/ifcvf/ifcvf_base.h |  24 ++-
 drivers/vdpa/ifcvf/ifcvf_main.c | 317 ++++++++++++++++++++++++++++----
 drivers/vhost/vdpa.c            |   5 +-
 4 files changed, 349 insertions(+), 117 deletions(-)

-- 
2.27.0

