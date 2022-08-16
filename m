Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDD8596278
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbiHPS2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbiHPS23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:28:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74773CBEC
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660674506; x=1692210506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sU9ZvLZHAhcgvBlI26YuR39LnU2K6WK8B8BN0fQH9zU=;
  b=c/xMLk7ihQOvetVDQtJAWcpgPYeIA9scgxOfiAPOuHiUQABIDmsuEvz+
   k4e9rIJLoDuLBAnLlJ+S5hJngZTwgKttfrvP0bHGJvjLQwFQ7BEDLAh/u
   nZ6nmOsP/dvMfkCzRX+KwxZX4owlo+dF1zKhuREgzV5BKS9TEtlpf1d8g
   gqbaa45G2gsiGxqEfhEozs3pTzs7ClFU5pUZKICpx3bQdNfsQdlHrLmjM
   8kL6bd5hz3Xtv+FZ5QhuIVwLGdcFZ97lCa5yiEzl9K0In09aT/mC9f/yC
   wYAXMLblNp8QuWR9QH43uKLLD7BqSCJ5U+gnTy57Lr+EYs9XIBgvy2gJr
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="293572978"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="293572978"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 11:27:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="710246361"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 16 Aug 2022 11:27:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Alan Brady <alan.brady@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 2/2] i40e: Fix to stop tx_timeout recovery if GLOBR fails
Date:   Tue, 16 Aug 2022 11:27:51 -0700
Message-Id: <20220816182751.2534028-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220816182751.2534028-1-anthony.l.nguyen@intel.com>
References: <20220816182751.2534028-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alan Brady <alan.brady@intel.com>

When a tx_timeout fires, the PF attempts to recover by incrementally
resetting.  First we try a PFR, then CORER and finally a GLOBR.  If the
GLOBR fails, then we keep hitting the tx_timeout and incrementing the
recovery level and issuing dmesgs, which is both annoying to the user
and accomplishes nothing.

If the GLOBR fails, then we're pretty much totally hosed, and there's
not much else we can do to recover, so this makes it such that we just
kill the VSI and stop hitting the tx_timeout in such a case.

Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b36bf9c3e1e4..9f1d5de7bf16 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -384,7 +384,9 @@ static void i40e_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 		set_bit(__I40E_GLOBAL_RESET_REQUESTED, pf->state);
 		break;
 	default:
-		netdev_err(netdev, "tx_timeout recovery unsuccessful\n");
+		netdev_err(netdev, "tx_timeout recovery unsuccessful, device is in non-recoverable state.\n");
+		set_bit(__I40E_DOWN_REQUESTED, pf->state);
+		set_bit(__I40E_VSI_DOWN_REQUESTED, vsi->state);
 		break;
 	}
 
-- 
2.35.1

