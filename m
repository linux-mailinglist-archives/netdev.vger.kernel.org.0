Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447962001E7
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 08:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgFSGWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 02:22:19 -0400
Received: from mga18.intel.com ([134.134.136.126]:50185 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbgFSGWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 02:22:16 -0400
IronPort-SDR: WVkscpUJVlEHkhfbBg7/gZSshJ7zGvGCmH2oTRuRzOIfNa0f4hsB9M9XgBkqUaFNi0Pd1ZDNDG
 03wk79QcGnyA==
X-IronPort-AV: E=McAfee;i="6000,8403,9656"; a="130229729"
X-IronPort-AV: E=Sophos;i="5.75,253,1589266800"; 
   d="scan'208";a="130229729"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2020 23:22:13 -0700
IronPort-SDR: 9CcV71emjPlftAqdNs8Fn8kVJZ2Zubg0pp5GoKUvZtARG7dyiddNS8R1dqDlCtXmFblKX8ijok
 ldVD55RTfJ+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,253,1589266800"; 
   d="scan'208";a="421753965"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 18 Jun 2020 23:22:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 4/4] i40e: fix crash when Rx descriptor count is changed
Date:   Thu, 18 Jun 2020 23:22:10 -0700
Message-Id: <20200619062210.3159291-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619062210.3159291-1-jeffrey.t.kirsher@intel.com>
References: <20200619062210.3159291-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

When the AF_XDP buffer allocator was introduced, the Rx SW ring
"rx_bi" allocation was moved from i40e_setup_rx_descriptors()
function, and was instead done in the i40e_configure_rx_ring()
function.

This broke the ethtool set_ringparam() hook for changing the Rx
descriptor count, which was relying on i40e_setup_rx_descriptors() to
handle the allocation.

Fix this by adding an explicit i40e_alloc_rx_bi() call to
i40e_set_ringparam().

Fixes: be1222b585fd ("i40e: Separate kernel allocated rx_bi rings from AF_XDP rings")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index aa8026b1eb81..67806b7b2f49 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2070,6 +2070,9 @@ static int i40e_set_ringparam(struct net_device *netdev,
 			 */
 			rx_rings[i].tail = hw->hw_addr + I40E_PRTGEN_STATUS;
 			err = i40e_setup_rx_descriptors(&rx_rings[i]);
+			if (err)
+				goto rx_unwind;
+			err = i40e_alloc_rx_bi(&rx_rings[i]);
 			if (err)
 				goto rx_unwind;
 
-- 
2.26.2

