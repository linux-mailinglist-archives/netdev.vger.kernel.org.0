Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60596653A2
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbjAKFX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbjAKFW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:22:59 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED36115F18;
        Tue, 10 Jan 2023 21:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673414128; x=1704950128;
  h=from:to:cc:subject:date:message-id;
  bh=vcvLe0f0ExqdNRKNIcoKlzOvKtyRlNadlCWz9n4LyFs=;
  b=jnCFEw+ILkBPgk84MZirmFMm9Xlf3Frf4pveeklPGWGBXXFF5RRxEXQi
   9UADhZp4GedJxYNrDSFfVgd0GcGbSVW/7wKUwAEjnJSXbnrai09YhW8Hq
   85VTq0PNucSYESFExAThnwbm5tzifBMlMdpTPbpTRIIdeSFEIV8wMGDrH
   w6InfXbwjIg1HbQCM/BVReL3+OfIXn0b/x6YNU3kLjPIpfWFuLbwsWPXI
   qwF53VbQRJmmZAp6yNsXTHp8bU+zmLZmwiX0J0RUWfuxhZNVer3QX5SoD
   jqRG7RKX6lOZz3mvkOGEAOVfuxdgRFJkJbhjtWCoNT0KgAdLryJTlAb+f
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="303701151"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="303701151"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 21:15:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="720592833"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="720592833"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga008.fm.intel.com with ESMTP; 10 Jan 2023 21:15:27 -0800
Received: from noorazur1-iLBPG12.png.intel.com (noorazur1-iLBPG12.png.intel.com [10.88.229.87])
        by linux.intel.com (Postfix) with ESMTP id F124D5807C8;
        Tue, 10 Jan 2023 21:15:22 -0800 (PST)
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
Subject: [PATCH net v2 1/1] net: stmmac: add aux timestamps fifo clearance wait
Date:   Wed, 11 Jan 2023 13:02:00 +0800
Message-Id: <20230111050200.2130-1-noor.azura.ahmad.tarmizi@intel.com>
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

Fixes: f4da56529da6 ("net: stmmac: Add support for external trigger timestamping")
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

