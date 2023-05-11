Return-Path: <netdev+bounces-1785-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 314D46FF257
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E283B28175A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:15:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351F11F953;
	Thu, 11 May 2023 13:15:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2755415482
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:15:36 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B552659D;
	Thu, 11 May 2023 06:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683810920; x=1715346920;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W5cLSAaV+r+1ItVRXAcJDtR+e/em1mtYJ7N6Iy6IoQc=;
  b=ePJobaBID6ILaQVr5Io5+Iu+GVB12lTrgz4rukTjEhIxsIerpfyDPsPp
   M/e+QGn1AhWHh47t8MooBVvcB++0ecU+hkp3qxWhn0ZYq9oPioz3cgSyl
   oUUK84dVhZZ/DRCoSzNG/iT6tow5mKJcEPwphHsDZd8K9ATBFd+kx9iwQ
   cij3str8fF+we798MRVVtzVrTz29zagqG2X1eRExLBPdh2RdHEvra0qeT
   qeFJ2nk92D92Cq3Pea1B+4bXHynZcjXT1gwfvUpZJ5O/2OEryzzaLo9CK
   lHKaqzxRmAHHHlYlWZ3ZZBEwa7p6ZWGBwhMVdUbTa2hn8JrK4NIN2+1QN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="378619458"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="378619458"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 06:15:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="650169748"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="650169748"
Received: from jsanche3-mobl1.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.252.39.112])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 06:15:15 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: linux-pci@vger.kernel.org,
	Bjorn Helgaas <helgaas@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
	Lukas Wunner <lukas@wunner.de>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 07/17] e1000e: Use pcie_lnkctl_clear_and_set() for changing LNKCTL
Date: Thu, 11 May 2023 16:14:31 +0300
Message-Id: <20230511131441.45704-8-ilpo.jarvinen@linux.intel.com>
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

Don't assume that only the driver would be accessing LNKCTL. ASPM
policy changes can trigger write to LNKCTL outside of driver's control.
And in the case of upstream (parent), the driver does not even own the
device it's changing LNKCTL for.

Use pcie_lnkctl_clear_and_set() which does proper locking to avoid
losing concurrent updates to the register value.

Suggested-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index bd7ef59b1f2e..29d50aeb2c3e 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6829,11 +6829,9 @@ static void __e1000e_disable_aspm(struct pci_dev *pdev, u16 state, int locked)
 	/* Both device and parent should have the same ASPM setting.
 	 * Disable ASPM in downstream component first and then upstream.
 	 */
-	pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL, aspm_dis_mask);
-
+	pcie_lnkctl_clear_and_set(pdev, aspm_dis_mask, 0);
 	if (parent)
-		pcie_capability_clear_word(parent, PCI_EXP_LNKCTL,
-					   aspm_dis_mask);
+		pcie_lnkctl_clear_and_set(parent, aspm_dis_mask, 0);
 }
 
 /**
-- 
2.30.2


