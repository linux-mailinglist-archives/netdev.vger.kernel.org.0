Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B8D488FC4
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 06:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238730AbiAJF05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 00:26:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:9532 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230407AbiAJF0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 00:26:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641792411; x=1673328411;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ET0qLnW3tyTFQCu5LQZAadcUBsipvdpyr3aWKBjPxVw=;
  b=IObo59rFryycfYm3NxFYcC0zhKjqx+839L/6EbNz2wfmzmx+EZ8Z2LfE
   cmKdCtlu9rXzLRX6y+0i4uLb3DOP0ILGeBm9Aibsg9poezLFsisiDrSQ4
   1aEBd4xcz4OcdxEoRUybzb9lwiEB04g02TEE2DhfwxGZ0pvirwAcLqRk1
   Xk0wHUvAqRl3gFg1mHQNDryzebVbv/y1Wc8abUyLXBtZC2wAOrB4rlYyQ
   2TP6PMIImAZAfQa4YQMkjPduofbBrCcWh/tUt+CMEvL03pYs9K10fMVYv
   rXwiXTLCnxKuaHh54NYdz51zVE8bLiVDHGcgh8DL6pLqBVVImFmQWjlrQ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="267479482"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="267479482"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:26:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="489892262"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:26:49 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 0/7] Supoort shared irq for virtqueues
Date:   Mon, 10 Jan 2022 13:19:40 +0800
Message-Id: <20220110051947.84901-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some platforms, it has been observed that a device may fail to
allocate enough MSI-X vectors, under such circumstances, the vqs have
to share a irq/vector.

This series extends irq requester/handlers abilities to deal with:
(granted nvectors, and max_intr = total vq number + 1(config interrupt) )

1)nvectors = max_intr: each vq has its own vector/irq,
config interrupt is enabled, normal case
2)max_intr > nvectors >= 2: vqs share one irq/vector, config interrupt is
enabled
3)nvectors = 1, vqs share one irq/vector, config interrupt is disabled.
Otherwise it fails.

This series also made necessary changes to irq cleaners and related
helpers.

Pleaase help reivew.

Thanks!
Zhu Lingshan

Zhu Lingshan (7):
  vDPA/ifcvf: implement IO read/write helpers in the header file
  vDPA/ifcvf: introduce new helpers to set config vector and vq vectors
  vDPA/ifcvf: implement device MSIX vector allocation helper
  vDPA/ifcvf: implement shared irq handlers for vqs
  vDPA/ifcvf: irq request helpers for both shared and per_vq irq
  vDPA/ifcvf: implement config interrupt request helper
  vDPA/ifcvf: improve irq requester, to handle per_vq/shared/config irq

 drivers/vdpa/ifcvf/ifcvf_base.c |  65 ++++--------
 drivers/vdpa/ifcvf/ifcvf_base.h |  45 +++++++-
 drivers/vdpa/ifcvf/ifcvf_main.c | 179 +++++++++++++++++++++++++++-----
 3 files changed, 215 insertions(+), 74 deletions(-)

-- 
2.27.0

