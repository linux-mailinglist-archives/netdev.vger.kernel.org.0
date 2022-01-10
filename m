Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B850C488FBB
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 06:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238714AbiAJF0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 00:26:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:9482 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238696AbiAJFZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 00:25:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641792356; x=1673328356;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ET0qLnW3tyTFQCu5LQZAadcUBsipvdpyr3aWKBjPxVw=;
  b=EJixQp89UCUFzl1IzEqWuV6FturGmipijcjaqk7VLYdFgg8/JSnPm0J2
   zz1VZBf9lBIBuJjOxnsZquofIZLrP7WlN3iP+itJQQCMWv0tqvsb8JQAT
   tvVZCOXWoWY+896Bijc9Jac+GXi2kS8hg3tzJ4eCFFqaoKW//Q2mBgQWj
   6Tqt4DsluzVVVDvYnGCf3fMRuvbe3TCI5kLa4jUreugveWwPug8D+Z9PV
   xt8XyBIdfFGNn9lMUThWCnlKPNd4iMIOBvekr1Xrg5Ca0r5XF4TGNg1fl
   8dTA5d7GYxMWVB9/lY6X/Zz60RStfmrvXmOS4NXltRm9qA4dx5cwPOP6S
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="267479391"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="267479391"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:25:55 -0800
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="622559741"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:25:53 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 0/7] Supoort shared irq for virtqueues
Date:   Mon, 10 Jan 2022 13:18:44 +0800
Message-Id: <20220110051851.84807-1-lingshan.zhu@intel.com>
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

