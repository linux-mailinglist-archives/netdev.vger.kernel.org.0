Return-Path: <netdev+bounces-1786-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E246FF25B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:15:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F11A1C20F48
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:15:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 069CC6AAB;
	Thu, 11 May 2023 13:15:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0C91F959
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:15:46 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2ED5DDBF;
	Thu, 11 May 2023 06:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683810924; x=1715346924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tR36HaeeacyhIGI4nAW+0GGuTxGMUoZAAEei/0m0WFw=;
  b=QxXwf5GRBr4Lvr0jYElsysSYZRHFi9DMAVoZv9t+y33YioMt5DCJx/Y8
   eqK/yUMVJsKntFHNdUqyfoeU3NqrShdv1uJasCnWEYsRYBAJirxy2UBF6
   vegpoaYWAAvHIB5vB06TpJhI8IGLEhsuaOXGzUXmt/QopZ8goECYr+bxP
   z/lP1lIZ8nfLeyA9c0pZlFpW6BvphC/vPVMzoMBrEKVYbG/MvmhvhksXz
   SfKC6bnp7Nr5vvFY5vtC43i3VbIgIvNbjMq5ur6mRfyLMrHhu5w6/9Ekv
   jJrPoNTBqAIbuyhZRd+ElyM6Wth3RYPq+YZofqHt9ZkRV8vnmtEVt9iNk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="378619493"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="378619493"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 06:15:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="650169752"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="650169752"
Received: from jsanche3-mobl1.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.252.39.112])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 06:15:20 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: linux-pci@vger.kernel.org,
	Bjorn Helgaas <helgaas@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
	Lukas Wunner <lukas@wunner.de>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 08/17] net/mlx5: Use pcie_lnkctl_clear_and_set() for changing LNKCTL
Date: Thu, 11 May 2023 16:14:32 +0300
Message-Id: <20230511131441.45704-9-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230511131441.45704-1-ilpo.jarvinen@linux.intel.com>
References: <20230511131441.45704-1-ilpo.jarvinen@linux.intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Don't assume that only the driver would be accessing LNKCTL of the
upstream (bridge). ASPM policy changes can trigger write to LNKCTL
outside of driver's control.

Use pcie_lnkctl_clear_and_set() which does proper locking to avoid
losing concurrent updates to the register value.

Suggested-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 50022e7565f1..2c3d69f3a107 100644
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
+	err = pcie_lnkctl_clear_and_set(bridge, 0, PCI_EXP_LNKCTL_LD);
 	if (err)
 		return err;
 	msleep(500);
-	reg16 &= ~PCI_EXP_LNKCTL_LD;
-	err = pci_write_config_word(bridge, cap + PCI_EXP_LNKCTL, reg16);
+	err = pcie_lnkctl_clear_and_set(bridge, PCI_EXP_LNKCTL_LD, 0);
 	if (err)
 		return err;
 
-- 
2.30.2


