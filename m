Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D2A6629E6
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 16:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbjAIP32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 10:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237139AbjAIP3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 10:29:14 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F77212;
        Mon,  9 Jan 2023 07:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673278153; x=1704814153;
  h=from:to:cc:subject:date:message-id;
  bh=wva8vZRxBk1WM1WW4WpFbcoP5MmHOU8eLhwsXmsxR3Q=;
  b=e73+XiHzh0fgyvqAOyfPe7h9I4NOvg+UXaug//snuBw/Z9zRLF9R5tr+
   2y2S+mc+qQ5YLTuZ2ZmjTgZNgd/0GDeQvlKLcF9SHawiP44YhNfPpE2U3
   1LXWnxceI0/EtdMxhPKAD8nvZPRv6vEuYbDU8XpflUKdQFliMcsPafsku
   8pZOI/4sl6XW+28JDJUAVxuxdwsmZRkKfyFLDtztG2DlGrMXv5OTAyjc5
   iGF/dg1C1r801RinBllbI088FJ0Oq+Te63d3tzETL4aWiPQ6MPwD4fsIL
   Bw/ppg6aWVm8c3DJ4yL9+LI7RNaIyWSwH4CnUjAyTkPfmIDvLyKqpQHPN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="385201766"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="385201766"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 07:29:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="719960144"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="719960144"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga008.fm.intel.com with ESMTP; 09 Jan 2023 07:29:12 -0800
Received: from noorazur1-iLBPG12.png.intel.com (noorazur1-iLBPG12.png.intel.com [10.88.229.87])
        by linux.intel.com (Postfix) with ESMTP id 50F405809A0;
        Mon,  9 Jan 2023 07:29:07 -0800 (PST)
From:   Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Noor Azura Ahmad Tarmizi 
        <noor.azura.ahmad.tarmizi@linux.intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH net 1/1] net: stmmac: add aux timestamps fifo clearance wait
Date:   Mon,  9 Jan 2023 23:15:46 +0800
Message-Id: <20230109151546.26247-1-noor.azura.ahmad.tarmizi@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add timeout polling wait for auxiliary timestamps snapshot FIFO clear bit
(ATSFC) to clear. This is to ensure no residue fifo value is being read
erroneously.

Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index fc06ddeac0d5..b4388ca8d211 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -210,7 +210,10 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
 		}
 		writel(acr_value, ptpaddr + PTP_ACR);
 		mutex_unlock(&priv->aux_ts_lock);
-		ret = 0;
+		/* wait for auxts fifo clear to finish */
+		ret = readl_poll_timeout(ptpaddr + PTP_ACR, acr_value,
+					 !(acr_value & PTP_ACR_ATSFC),
+					 10, 10000);
 		break;
 
 	default:
-- 
2.17.1

