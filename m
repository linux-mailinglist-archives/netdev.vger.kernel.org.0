Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01324A7FDF
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 08:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344482AbiBCHev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 02:34:51 -0500
Received: from mga07.intel.com ([134.134.136.100]:32403 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230473AbiBCHeu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 02:34:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643873690; x=1675409690;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+vr3cPXtMggxYYtZto6eAGP/RQTPNgzVO9+AiIDukQ8=;
  b=cfsIU8XhPEnf7yQGsjaHsjMXnfDo7yDRM634A8XliWnd6Bm6a3kCMw/U
   ojQECvtP6egKksmz149nvf5D7tR69iD+LXItEETohbyjItdeyINjEvN9n
   dmcc+kwzgMptBuxcQkOHs+ihx8JbNjuf+lf6I4BLEbBqopXdLIoFdqwVV
   jBnm9v1dZ+Cq3DWfuR8y73S2Rpno8YaZXZh8Tgt9IiRgDQA0a6WS9uD8K
   q57HitxrnbKWfF53ZGED4EQ59wVtHaOHIw2NZS03kMWYNd4nZx4SpbFY4
   +cW7KfLNPoA8WNdQyVf79/aqWlTpyhb55sc+jYaWORpncVAmMylWZijoZ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="311397567"
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="311397567"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 23:34:50 -0800
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="771703671"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 23:34:48 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 0/4] vDPA/ifcvf: implement shared IRQ feature 
Date:   Thu,  3 Feb 2022 15:27:31 +0800
Message-Id: <20220203072735.189716-1-lingshan.zhu@intel.com>
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

For the test report, plase kindly refer to last version cover letter:
https://www.spinics.net/lists/netdev/msg795808.html

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

Zhu Lingshan (4):
  vDPA/ifcvf: implement IO read/write helpers in the header file
  vDPA/ifcvf: implement device MSIX vector allocator
  vhost_vdpa: don't setup irq offloading when irq_num < 0
  vDPA/ifcvf: implement shared IRQ feature

 drivers/vdpa/ifcvf/ifcvf_base.c |  67 +++-----
 drivers/vdpa/ifcvf/ifcvf_base.h |  60 +++++++-
 drivers/vdpa/ifcvf/ifcvf_main.c | 262 ++++++++++++++++++++++++++++----
 drivers/vhost/vdpa.c            |   4 +
 4 files changed, 314 insertions(+), 79 deletions(-)

-- 
2.27.0

