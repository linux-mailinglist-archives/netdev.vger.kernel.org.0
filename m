Return-Path: <netdev+bounces-6786-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0F2271800A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:37:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6067F28144B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F63A959;
	Wed, 31 May 2023 12:37:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AF71850
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 12:37:38 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C0C11D
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 05:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685536657; x=1717072657;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/7ki4PH7pJfXAJYIjAt2oWlh0KK1EwLb+t3e8AEDub8=;
  b=jgCnFpH7mnMmiBx20mipEYut16eVp953gTDMmchwPo9yPJiInC5lfBH4
   xPs7eQcNzDGLAX4xmUv6Tkv5irmUs6UpVrf5Znut0rcyHwuheQeByoPlf
   6cW3V2lLTFq5OzA3xXKuYdSWLCTjozIFMZumsBFLXMjjF/uB6aGAxSHcs
   JAsYhRm1HEcQ33raDwk017H80O8+TI4dMW7Ch0qAUTfodq9uvy9ZG6oCn
   eI5FwfAp78T7rMaZX26HR92E2Pfe6kOUrvOpTat/HRL8kwnd6CuRPMT4r
   fKSi1zMugZtz3Xj4hAFRDxc2atGSPJJny5ZUhXsO+egbdtYnkERIrRl3B
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="339816781"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="339816781"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 05:36:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="710050849"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="710050849"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga007.fm.intel.com with ESMTP; 31 May 2023 05:36:53 -0700
Received: from pkitszel-desk.tendawifi.com (unknown [10.255.201.128])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id F0E3735FDB;
	Wed, 31 May 2023 13:36:50 +0100 (IST)
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
	Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH iwl-next v2] ice: clean up freeing SR-IOV VFs
Date: Wed, 31 May 2023 14:36:42 +0200
Message-Id: <20230531123642.20246-1-przemyslaw.kitszel@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The check for existing VFs was redundant since very
inception of SR-IOV sysfs interface in the kernel,
see commit 1789382a72a5 ("PCI: SRIOV control and status via sysfs").

v2: sending to proper IWL address

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 2ea6d24977a6..1f66914c7a20 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -905,14 +905,13 @@ static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
  */
 static int ice_pci_sriov_ena(struct ice_pf *pf, int num_vfs)
 {
-	int pre_existing_vfs = pci_num_vf(pf->pdev);
 	struct device *dev = ice_pf_to_dev(pf);
 	int err;
 
-	if (pre_existing_vfs && pre_existing_vfs != num_vfs)
+	if (!num_vfs) {
 		ice_free_vfs(pf);
-	else if (pre_existing_vfs && pre_existing_vfs == num_vfs)
 		return 0;
+	}
 
 	if (num_vfs > pf->vfs.num_supported) {
 		dev_err(dev, "Can't enable %d VFs, max VFs supported is %d\n",
-- 
2.38.1


