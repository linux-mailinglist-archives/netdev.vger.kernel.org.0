Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95AAE52E1C6
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344375AbiETBQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344340AbiETBQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:16:01 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0586C377D9
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653009360; x=1684545360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tPQE+Qlryk7avBL9Z3AbOFS6jfrdTs4+uu3FoJxBUqg=;
  b=HnVAVRiR/semWnyhB0tqSFPD5QOjuN1rNJe8iuvN8qZuljoHyjWnA+qx
   rP+OWNDIzFx8ff1byEoTAr7VZgK5O1vCc/mB7ULKFcd6/Avzef6qsp6z3
   FAAqjYj8J59gxUw7qGUxS8RqBXI9+/clVQ7MecfDgDRxRNpIUhvO2R5rJ
   Eb+T/OHJbYc2K1k2h5DO5447el395RczVvP1zpw7NW5urWgbt+1/iOaM8
   Lz1pZvKMJtdEq3GJbQHOmF2XLiMyxDOf0UxPeio26bEYOyzVsi/e4cDW0
   Av/As7JbiqG2A8UmeD4yCeNFjB4h+0td8QB1Ia67J5vH+K6Al62LI7z8y
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="333064160"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="333064160"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 18:15:54 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="570534552"
Received: from vcostago-mobl3.jf.intel.com ([10.24.14.84])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 18:15:54 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v5 06/11] igc: Add support for receiving errored frames
Date:   Thu, 19 May 2022 18:15:33 -0700
Message-Id: <20220520011538.1098888-7-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220520011538.1098888-1-vinicius.gomes@intel.com>
References: <20220520011538.1098888-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While developing features that require sending potencially ill formed
frames, it is useful being able to receive them on the other side.

The driver already had all the pieces in place to support that, all
that was missing was put the flag in the list of supported features.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index bcbf35b32ef3..5dd7140bac82 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6318,6 +6318,7 @@ static int igc_probe(struct pci_dev *pdev,
 
 	/* copy netdev features into list of user selectable features */
 	netdev->hw_features |= NETIF_F_NTUPLE;
+	netdev->hw_features |= NETIF_F_RXALL;
 	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
 	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
 	netdev->hw_features |= netdev->features;
-- 
2.35.3

