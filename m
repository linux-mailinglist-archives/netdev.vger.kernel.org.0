Return-Path: <netdev+bounces-3279-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DEF4B7065CA
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6C531C20D99
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD19168B4;
	Wed, 17 May 2023 10:56:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D30DDBA
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:56:40 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B355D2D7B;
	Wed, 17 May 2023 03:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684320971; x=1715856971;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7umx+GxEypVIOLX+1oZG2a7eY4JTaLow3U/ElJE5Scs=;
  b=niDEj/YYNempx1xaXbrtHaX6FWsj/jm3KgnNMFSUXS2N79t8B2YHlMIB
   EVDDUIAM9/8YKDaMGnwnIBoQG+J99VcMD1oHNKL1PX0d7qEODV/bo1+qw
   ByqRHuaYV+8HpX4GewpSWcpYz0RKI6QBfoRuDd+Fmaw/dF2d1cYHdvzE4
   D/szKuaospH7t3GF3QgY2LtZA4ug1PNKNeaoS3RsDZW5nFKd5tb/hgE5f
   Yla782y6inPwhM1YsgLZxj6kqyyh3z08rBfAzCtrZC9XPHtvYtu/WX9mK
   b4hZ0a953EZVxMUloRcSorvDbM1NDGKtSPI3HjZ9Y1lh7zQrrVLVmxtLx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="438071703"
X-IronPort-AV: E=Sophos;i="5.99,281,1677571200"; 
   d="scan'208";a="438071703"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 03:53:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="734651067"
X-IronPort-AV: E=Sophos;i="5.99,281,1677571200"; 
   d="scan'208";a="734651067"
Received: from lnstern-mobl1.amr.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.251.221.185])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 03:53:29 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: linux-pci@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Rob Herring <robh@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Lukas Wunner <lukas@wunner.de>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Moshe Shemesh <moshe@mellanox.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Dean Luick <dean.luick@cornelisnetworks.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 6/9] net/mlx5: Use RMW accessors for changing LNKCTL
Date: Wed, 17 May 2023 13:52:32 +0300
Message-Id: <20230517105235.29176-7-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230517105235.29176-1-ilpo.jarvinen@linux.intel.com>
References: <20230517105235.29176-1-ilpo.jarvinen@linux.intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Don't assume that only the driver would be accessing LNKCTL of the
upstream bridge. ASPM policy changes can trigger write to LNKCTL
outside of driver's control.

Use RMW capability accessors which do proper locking to avoid losing
concurrent updates to the register value.

Fixes: eabe8e5e88f5 ("net/mlx5: Handle sync reset now event")
Suggested-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 50022e7565f1..f202150a5093 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -332,16 +332,11 @@ static int mlx5_pci_link_toggle(struct mlx5_core_dev *dev)
 		pci_cfg_access_lock(sdev);
 	}
 	/* PCI link toggle */
-	err = pci_read_config_word(bridge, cap + PCI_EXP_LNKCTL, &reg16);
-	if (err)
-		return err;
-	reg16 |= PCI_EXP_LNKCTL_LD;
-	err = pci_write_config_word(bridge, cap + PCI_EXP_LNKCTL, reg16);
+	err = pcie_capability_set_word(bridge, PCI_EXP_LNKCTL, PCI_EXP_LNKCTL_LD);
 	if (err)
 		return err;
 	msleep(500);
-	reg16 &= ~PCI_EXP_LNKCTL_LD;
-	err = pci_write_config_word(bridge, cap + PCI_EXP_LNKCTL, reg16);
+	err = pcie_capability_clear_word(bridge, PCI_EXP_LNKCTL, PCI_EXP_LNKCTL_LD);
 	if (err)
 		return err;
 
-- 
2.30.2


