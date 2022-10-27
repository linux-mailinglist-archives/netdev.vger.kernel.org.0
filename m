Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898B560F58B
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 12:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbiJ0Kmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 06:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbiJ0Kmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 06:42:49 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AF64B0C1
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 03:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666867368; x=1698403368;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xd/2NFIATPd2N650ChuJM233QArZZukZHyVVDAuF/hU=;
  b=iYGe1fDsendefqtpwMfiPF0JhOLOD0uf9eezvPhEBRX7IwTm36fj5SW5
   MANzd82I+xoVG40U8gATGFxiA3zyaVQjLR+UY+8QLyeOMpT6a6ZTSjW3w
   7EikZQQLxRq2uaSw7tEikbtl+OEDTCXuUwYKaRJw3niOk5vtXXdeOmHff
   O/xxBIKUVcw6uZcMXfMd/ZmzPqVFFIc1W3Vg/WMQLgE2XGcThtZJUY9Ku
   BfEwM+XTAVDHpwBEwbKl5YijRludExW/QguTNNxB06kpMD4oTe4KowUSE
   ZTFE7nVgUc/td9gKhnC8Dm9QzSkSaLJwWNfOpBNq+PPlXKAUFba9bxkU/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="306919836"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="306919836"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 03:42:48 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="807408914"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="807408914"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 03:42:47 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2] ice: Add additional CSR registers to ETHTOOL_GREGS
Date:   Thu, 27 Oct 2022 03:42:39 -0700
Message-Id: <20221027104239.1691549-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.0.83.gd420dda05763
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukasz Czapnik <lukasz.czapnik@intel.com>

In the event of a Tx hang it can be useful to read a variety of hardware
registers to capture some state about why the transmit queue got stuck.

Extend the ETHTOOL_GREGS dump provided by the ice driver with several CSR
registers that provide such relevant information regarding the hardware Tx
state. This enables capturing relevant data to enable debugging such a Tx
hang.

Signed-off-by: Lukasz Czapnik <lukasz.czapnik@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
---
Changes since v1:
* Improved the commit message as suggested by Maciej Fijalkowski

 drivers/net/ethernet/intel/ice/ice_ethtool.c | 169 +++++++++++++++++++
 1 file changed, 169 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index b7be84bbe72d..f71a7521c7bd 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -151,6 +151,175 @@ static const u32 ice_regs_dump_list[] = {
 	QINT_RQCTL(0),
 	PFINT_OICR_ENA,
 	QRX_ITR(0),
+#define GLDCB_TLPM_PCI_DM			0x000A0180
+	GLDCB_TLPM_PCI_DM,
+#define GLDCB_TLPM_TC2PFC			0x000A0194
+	GLDCB_TLPM_TC2PFC,
+#define TCDCB_TLPM_WAIT_DM(_i)			(0x000A0080 + ((_i) * 4))
+	TCDCB_TLPM_WAIT_DM(0),
+	TCDCB_TLPM_WAIT_DM(1),
+	TCDCB_TLPM_WAIT_DM(2),
+	TCDCB_TLPM_WAIT_DM(3),
+	TCDCB_TLPM_WAIT_DM(4),
+	TCDCB_TLPM_WAIT_DM(5),
+	TCDCB_TLPM_WAIT_DM(6),
+	TCDCB_TLPM_WAIT_DM(7),
+	TCDCB_TLPM_WAIT_DM(8),
+	TCDCB_TLPM_WAIT_DM(9),
+	TCDCB_TLPM_WAIT_DM(10),
+	TCDCB_TLPM_WAIT_DM(11),
+	TCDCB_TLPM_WAIT_DM(12),
+	TCDCB_TLPM_WAIT_DM(13),
+	TCDCB_TLPM_WAIT_DM(14),
+	TCDCB_TLPM_WAIT_DM(15),
+	TCDCB_TLPM_WAIT_DM(16),
+	TCDCB_TLPM_WAIT_DM(17),
+	TCDCB_TLPM_WAIT_DM(18),
+	TCDCB_TLPM_WAIT_DM(19),
+	TCDCB_TLPM_WAIT_DM(20),
+	TCDCB_TLPM_WAIT_DM(21),
+	TCDCB_TLPM_WAIT_DM(22),
+	TCDCB_TLPM_WAIT_DM(23),
+	TCDCB_TLPM_WAIT_DM(24),
+	TCDCB_TLPM_WAIT_DM(25),
+	TCDCB_TLPM_WAIT_DM(26),
+	TCDCB_TLPM_WAIT_DM(27),
+	TCDCB_TLPM_WAIT_DM(28),
+	TCDCB_TLPM_WAIT_DM(29),
+	TCDCB_TLPM_WAIT_DM(30),
+	TCDCB_TLPM_WAIT_DM(31),
+#define GLPCI_WATMK_CLNT_PIPEMON		0x000BFD90
+	GLPCI_WATMK_CLNT_PIPEMON,
+#define GLPCI_CUR_CLNT_COMMON			0x000BFD84
+	GLPCI_CUR_CLNT_COMMON,
+#define GLPCI_CUR_CLNT_PIPEMON			0x000BFD88
+	GLPCI_CUR_CLNT_PIPEMON,
+#define GLPCI_PCIERR				0x0009DEB0
+	GLPCI_PCIERR,
+#define GLPSM_DEBUG_CTL_STATUS			0x000B0600
+	GLPSM_DEBUG_CTL_STATUS,
+#define GLPSM0_DEBUG_FIFO_OVERFLOW_DETECT	0x000B0680
+	GLPSM0_DEBUG_FIFO_OVERFLOW_DETECT,
+#define GLPSM0_DEBUG_FIFO_UNDERFLOW_DETECT	0x000B0684
+	GLPSM0_DEBUG_FIFO_UNDERFLOW_DETECT,
+#define GLPSM0_DEBUG_DT_OUT_OF_WINDOW		0x000B0688
+	GLPSM0_DEBUG_DT_OUT_OF_WINDOW,
+#define GLPSM0_DEBUG_INTF_HW_ERROR_DETECT	0x000B069C
+	GLPSM0_DEBUG_INTF_HW_ERROR_DETECT,
+#define GLPSM0_DEBUG_MISC_HW_ERROR_DETECT	0x000B06A0
+	GLPSM0_DEBUG_MISC_HW_ERROR_DETECT,
+#define GLPSM1_DEBUG_FIFO_OVERFLOW_DETECT	0x000B0E80
+	GLPSM1_DEBUG_FIFO_OVERFLOW_DETECT,
+#define GLPSM1_DEBUG_FIFO_UNDERFLOW_DETECT	0x000B0E84
+	GLPSM1_DEBUG_FIFO_UNDERFLOW_DETECT,
+#define GLPSM1_DEBUG_SRL_FIFO_OVERFLOW_DETECT	0x000B0E88
+	GLPSM1_DEBUG_SRL_FIFO_OVERFLOW_DETECT,
+#define GLPSM1_DEBUG_SRL_FIFO_UNDERFLOW_DETECT  0x000B0E8C
+	GLPSM1_DEBUG_SRL_FIFO_UNDERFLOW_DETECT,
+#define GLPSM1_DEBUG_MISC_HW_ERROR_DETECT       0x000B0E90
+	GLPSM1_DEBUG_MISC_HW_ERROR_DETECT,
+#define GLPSM2_DEBUG_FIFO_OVERFLOW_DETECT       0x000B1680
+	GLPSM2_DEBUG_FIFO_OVERFLOW_DETECT,
+#define GLPSM2_DEBUG_FIFO_UNDERFLOW_DETECT      0x000B1684
+	GLPSM2_DEBUG_FIFO_UNDERFLOW_DETECT,
+#define GLPSM2_DEBUG_MISC_HW_ERROR_DETECT       0x000B1688
+	GLPSM2_DEBUG_MISC_HW_ERROR_DETECT,
+#define GLTDPU_TCLAN_COMP_BOB(_i)               (0x00049ADC + ((_i) * 4))
+	GLTDPU_TCLAN_COMP_BOB(1),
+	GLTDPU_TCLAN_COMP_BOB(2),
+	GLTDPU_TCLAN_COMP_BOB(3),
+	GLTDPU_TCLAN_COMP_BOB(4),
+	GLTDPU_TCLAN_COMP_BOB(5),
+	GLTDPU_TCLAN_COMP_BOB(6),
+	GLTDPU_TCLAN_COMP_BOB(7),
+	GLTDPU_TCLAN_COMP_BOB(8),
+#define GLTDPU_TCB_CMD_BOB(_i)                  (0x0004975C + ((_i) * 4))
+	GLTDPU_TCB_CMD_BOB(1),
+	GLTDPU_TCB_CMD_BOB(2),
+	GLTDPU_TCB_CMD_BOB(3),
+	GLTDPU_TCB_CMD_BOB(4),
+	GLTDPU_TCB_CMD_BOB(5),
+	GLTDPU_TCB_CMD_BOB(6),
+	GLTDPU_TCB_CMD_BOB(7),
+	GLTDPU_TCB_CMD_BOB(8),
+#define GLTDPU_PSM_UPDATE_BOB(_i)               (0x00049B5C + ((_i) * 4))
+	GLTDPU_PSM_UPDATE_BOB(1),
+	GLTDPU_PSM_UPDATE_BOB(2),
+	GLTDPU_PSM_UPDATE_BOB(3),
+	GLTDPU_PSM_UPDATE_BOB(4),
+	GLTDPU_PSM_UPDATE_BOB(5),
+	GLTDPU_PSM_UPDATE_BOB(6),
+	GLTDPU_PSM_UPDATE_BOB(7),
+	GLTDPU_PSM_UPDATE_BOB(8),
+#define GLTCB_CMD_IN_BOB(_i)                    (0x000AE288 + ((_i) * 4))
+	GLTCB_CMD_IN_BOB(1),
+	GLTCB_CMD_IN_BOB(2),
+	GLTCB_CMD_IN_BOB(3),
+	GLTCB_CMD_IN_BOB(4),
+	GLTCB_CMD_IN_BOB(5),
+	GLTCB_CMD_IN_BOB(6),
+	GLTCB_CMD_IN_BOB(7),
+	GLTCB_CMD_IN_BOB(8),
+#define GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(_i)   (0x000FC148 + ((_i) * 4))
+	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(1),
+	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(2),
+	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(3),
+	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(4),
+	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(5),
+	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(6),
+	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(7),
+	GLLAN_TCLAN_FETCH_CTL_FBK_BOB_CTL(8),
+#define GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(_i) (0x000FC248 + ((_i) * 4))
+	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(1),
+	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(2),
+	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(3),
+	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(4),
+	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(5),
+	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(6),
+	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(7),
+	GLLAN_TCLAN_FETCH_CTL_SCHED_BOB_CTL(8),
+#define GLLAN_TCLAN_CACHE_CTL_BOB_CTL(_i)       (0x000FC1C8 + ((_i) * 4))
+	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(1),
+	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(2),
+	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(3),
+	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(4),
+	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(5),
+	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(6),
+	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(7),
+	GLLAN_TCLAN_CACHE_CTL_BOB_CTL(8),
+#define GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(_i)  (0x000FC188 + ((_i) * 4))
+	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(1),
+	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(2),
+	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(3),
+	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(4),
+	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(5),
+	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(6),
+	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(7),
+	GLLAN_TCLAN_FETCH_CTL_PROC_BOB_CTL(8),
+#define GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(_i) (0x000FC288 + ((_i) * 4))
+	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(1),
+	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(2),
+	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(3),
+	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(4),
+	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(5),
+	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(6),
+	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(7),
+	GLLAN_TCLAN_FETCH_CTL_PCIE_RD_BOB_CTL(8),
+#define PRTDCB_TCUPM_REG_CM(_i)			(0x000BC360 + ((_i) * 4))
+	PRTDCB_TCUPM_REG_CM(0),
+	PRTDCB_TCUPM_REG_CM(1),
+	PRTDCB_TCUPM_REG_CM(2),
+	PRTDCB_TCUPM_REG_CM(3),
+#define PRTDCB_TCUPM_REG_DM(_i)			(0x000BC3A0 + ((_i) * 4))
+	PRTDCB_TCUPM_REG_DM(0),
+	PRTDCB_TCUPM_REG_DM(1),
+	PRTDCB_TCUPM_REG_DM(2),
+	PRTDCB_TCUPM_REG_DM(3),
+#define PRTDCB_TLPM_REG_DM(_i)			(0x000A0000 + ((_i) * 4))
+	PRTDCB_TLPM_REG_DM(0),
+	PRTDCB_TLPM_REG_DM(1),
+	PRTDCB_TLPM_REG_DM(2),
+	PRTDCB_TLPM_REG_DM(3),
 };
 
 struct ice_priv_flag {

base-commit: 330543d04f2c9c5924736d81f67b50b925bd0864
-- 
2.38.0.83.gd420dda05763

