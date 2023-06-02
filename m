Return-Path: <netdev+bounces-7516-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25727720840
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:18:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A75531C21091
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB3813330B;
	Fri,  2 Jun 2023 17:17:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D1118B0E
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 17:17:49 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFCA1AB
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685726268; x=1717262268;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y68qr6YBaC6a5pL+WZe5r9a+5k+3/CT5VhQOvvC3Voc=;
  b=LuNv9chHJzqH2X4eUBLWRvutGj6crnk8UEa0CFp3D5xpV5Wu6tSWP0fQ
   r4Ojh+8UkliL8kVXjtZbMV9t3p8vmNxqcfpaMrkX8N4JDbN5xXFmExulD
   zfo6mgze5ha68W//uaBZepc1unCOl+DfA01JbsG8TbqGpIMPOeQsgnbVj
   5YMMwGw6iJTXdSKpjPDYRssq/jMJFmxau7LrnFIy6YBrWNCGPYzQDmFns
   xeQp0D63yaIPy5hd6uy1SSl8ulF+O4sYhLyF+UlkbrqHwEjark8twykTR
   VZao+njN0RFkehRxdvkUd3SuXuHEHKn9XEo68Dod175q8lrdTpiB6OGtI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="340549381"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="340549381"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 10:17:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="772952472"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="772952472"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 02 Jun 2023 10:17:41 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Ahmed Zaki <ahmed.zaki@intel.com>,
	anthony.l.nguyen@intel.com,
	Rafal Romanowski <rafal.romanowski@intel.com>
Subject: [PATCH net-next 3/3] iavf: remove mask from iavf_irq_enable_queues()
Date: Fri,  2 Jun 2023 10:13:02 -0700
Message-Id: <20230602171302.745492-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
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

From: Ahmed Zaki <ahmed.zaki@intel.com>

Enable more than 32 IRQs by removing the u32 bit mask in
iavf_irq_enable_queues(). There is no need for the mask as there are no
callers that select individual IRQs through the bitmask. Also, if the PF
allocates more than 32 IRQs, this mask will prevent us from using all of
them.

The comment in iavf_register.h is modified to show that the maximum
number allowed for the IRQ index is 63 as per the iAVF standard 1.0 [1].

link: [1] https://www.intel.com/content/dam/www/public/us/en/documents/product-specifications/ethernet-adaptive-virtual-function-hardware-spec.pdf
Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h          |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c     | 15 ++++++---------
 drivers/net/ethernet/intel/iavf/iavf_register.h |  2 +-
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 9abaff1f2aff..39d0fe76a38f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -525,7 +525,7 @@ void iavf_set_ethtool_ops(struct net_device *netdev);
 void iavf_update_stats(struct iavf_adapter *adapter);
 void iavf_reset_interrupt_capability(struct iavf_adapter *adapter);
 int iavf_init_interrupt_scheme(struct iavf_adapter *adapter);
-void iavf_irq_enable_queues(struct iavf_adapter *adapter, u32 mask);
+void iavf_irq_enable_queues(struct iavf_adapter *adapter);
 void iavf_free_all_tx_resources(struct iavf_adapter *adapter);
 void iavf_free_all_rx_resources(struct iavf_adapter *adapter);
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 3a78f86ba4f9..1332633f0ca5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -359,21 +359,18 @@ static void iavf_irq_disable(struct iavf_adapter *adapter)
 }
 
 /**
- * iavf_irq_enable_queues - Enable interrupt for specified queues
+ * iavf_irq_enable_queues - Enable interrupt for all queues
  * @adapter: board private structure
- * @mask: bitmap of queues to enable
  **/
-void iavf_irq_enable_queues(struct iavf_adapter *adapter, u32 mask)
+void iavf_irq_enable_queues(struct iavf_adapter *adapter)
 {
 	struct iavf_hw *hw = &adapter->hw;
 	int i;
 
 	for (i = 1; i < adapter->num_msix_vectors; i++) {
-		if (mask & BIT(i - 1)) {
-			wr32(hw, IAVF_VFINT_DYN_CTLN1(i - 1),
-			     IAVF_VFINT_DYN_CTLN1_INTENA_MASK |
-			     IAVF_VFINT_DYN_CTLN1_ITR_INDX_MASK);
-		}
+		wr32(hw, IAVF_VFINT_DYN_CTLN1(i - 1),
+		     IAVF_VFINT_DYN_CTLN1_INTENA_MASK |
+		     IAVF_VFINT_DYN_CTLN1_ITR_INDX_MASK);
 	}
 }
 
@@ -387,7 +384,7 @@ void iavf_irq_enable(struct iavf_adapter *adapter, bool flush)
 	struct iavf_hw *hw = &adapter->hw;
 
 	iavf_misc_irq_enable(adapter);
-	iavf_irq_enable_queues(adapter, ~0);
+	iavf_irq_enable_queues(adapter);
 
 	if (flush)
 		iavf_flush(hw);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_register.h b/drivers/net/ethernet/intel/iavf/iavf_register.h
index bf793332fc9d..a19e88898a0b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_register.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_register.h
@@ -40,7 +40,7 @@
 #define IAVF_VFINT_DYN_CTL01_INTENA_MASK IAVF_MASK(0x1, IAVF_VFINT_DYN_CTL01_INTENA_SHIFT)
 #define IAVF_VFINT_DYN_CTL01_ITR_INDX_SHIFT 3
 #define IAVF_VFINT_DYN_CTL01_ITR_INDX_MASK IAVF_MASK(0x3, IAVF_VFINT_DYN_CTL01_ITR_INDX_SHIFT)
-#define IAVF_VFINT_DYN_CTLN1(_INTVF) (0x00003800 + ((_INTVF) * 4)) /* _i=0...15 */ /* Reset: VFR */
+#define IAVF_VFINT_DYN_CTLN1(_INTVF) (0x00003800 + ((_INTVF) * 4)) /* _i=0...63 */ /* Reset: VFR */
 #define IAVF_VFINT_DYN_CTLN1_INTENA_SHIFT 0
 #define IAVF_VFINT_DYN_CTLN1_INTENA_MASK IAVF_MASK(0x1, IAVF_VFINT_DYN_CTLN1_INTENA_SHIFT)
 #define IAVF_VFINT_DYN_CTLN1_SWINT_TRIG_SHIFT 2
-- 
2.38.1


