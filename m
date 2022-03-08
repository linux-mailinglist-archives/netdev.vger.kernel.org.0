Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CB84D27A8
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiCIBf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiCIBf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:35:56 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E65B91E3
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 17:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646789699; x=1678325699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fx25nLMetq/iNuCJ7i1SBSABreZkqtIM3Ip/QYbe25E=;
  b=TudTfHuLfjgr/uKSjHpTeLIWxgTDzjp5vLPC56163VWY3RrBFpolcKY4
   Cgc0MNpsnxt7fzOoKKGzAGGCzpsj2OZ35k5N1+Zhed/omrlJAVPZC+TIb
   +dunH4ZC7ipBDTqvlhtxCMchM3FzNGFPv87lLYAUhciwb/Nfwk/FDZEo7
   INmPaIkjaTDZiPADeMkhf5GJuo/fgf8pFlsk1vVmDzyWiewGFWPp8svKm
   m1dQpJLSmoQOaBQSH/E1G8E/nUAZ1ds0eMOAlRXmG4urEe2PpVr0r/uPF
   SH8YTG2lao6DkOcOKchTZyzPFrjXktrHq3rNr/C+BfBMtBphNTlTXVgdq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="315559868"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="315559868"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 15:44:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="537778719"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 08 Mar 2022 15:44:54 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        david.m.ertman@intel.com,
        Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
Subject: [PATCH net v2 6/7] ice: Don't use GFP_KERNEL in atomic context
Date:   Tue,  8 Mar 2022 15:45:12 -0800
Message-Id: <20220308234513.1089152-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220308234513.1089152-1-anthony.l.nguyen@intel.com>
References: <20220308234513.1089152-1-anthony.l.nguyen@intel.com>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

ice_misc_intr() is an irq handler. It should not sleep.

Use GFP_ATOMIC instead of GFP_KERNEL when allocating some memory.

Fixes: 348048e724a0 ("ice: Implement iidc operations")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Tested-by: Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6fc6514eb007..83e3e8aae6cf 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3034,7 +3034,7 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 		struct iidc_event *event;
 
 		ena_mask &= ~ICE_AUX_CRIT_ERR;
-		event = kzalloc(sizeof(*event), GFP_KERNEL);
+		event = kzalloc(sizeof(*event), GFP_ATOMIC);
 		if (event) {
 			set_bit(IIDC_EVENT_CRIT_ERR, event->type);
 			/* report the entire OICR value to AUX driver */
-- 
2.31.1

