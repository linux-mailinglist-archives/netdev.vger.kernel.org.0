Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550DD49B07E
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574898AbiAYJhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:37:03 -0500
Received: from mga12.intel.com ([192.55.52.136]:43377 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1455679AbiAYJbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 04:31:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643103078; x=1674639078;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=++JBqXNPlJKJJ+KJrzg6qONyJMFdi/Mus8P2EV/nFMg=;
  b=e9O3MMG52jXkiQ3MsucO27okRgowWoo6CgHvmteiF+5Zz/gaP5AjaydK
   SO75ToMQPeHt8sMyUzv/ps2WOpLMZT3hu/5aZbmM9Trda+e30SL4Dj8fY
   xrGMo9rljWSouoq+G6f8hv8lH3Kz1xAD7ZoZ89LuXZj26+J1NdfYxaJ+f
   ottltZkRQ6OvQoxjRA9mO9UcUSn012Q76d2Jin5WA/WtR7BoDih28SkIG
   bRYs9YSH6Bl2k9qVXjoCH9sWOYDHJYjxikMNJxYbSlGpl2JFKspuicp6n
   FiWiGh9jqDY3ix2vEUyda2JOcM4iuXbGTl4ZAZtYTO2nMKt5XIpXMM9QA
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="226240746"
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="226240746"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 01:25:01 -0800
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="520318714"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 01:25:00 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 0/4] vDPA/ifcvf: implement shared IRQ feature 
Date:   Tue, 25 Jan 2022 17:17:40 +0800
Message-Id: <20220125091744.115996-1-lingshan.zhu@intel.com>
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

 drivers/vdpa/ifcvf/ifcvf_base.c |  67 +++------
 drivers/vdpa/ifcvf/ifcvf_base.h |  60 +++++++-
 drivers/vdpa/ifcvf/ifcvf_main.c | 254 ++++++++++++++++++++++++++++----
 drivers/vhost/vdpa.c            |   3 +
 4 files changed, 305 insertions(+), 79 deletions(-)

-- 
2.27.0

