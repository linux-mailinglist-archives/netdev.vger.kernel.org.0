Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9AFB646B66
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiLHJGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiLHJFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:05:53 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF8A73F62;
        Thu,  8 Dec 2022 01:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670490273; x=1702026273;
  h=from:to:cc:subject:date:message-id;
  bh=UA+smJjZZYbFnblJ4yJ0P96Z25fhqeBCuoWHkuOYe74=;
  b=dK7sIzIncfCkR1apA+JyjDmSSCxolKWOYAHhM/KwWFZbj4wQ8I9gsgVE
   kzLj2pc9WQqNGWXEoh+C1AEpaewa1Zl+DlJk7PRhCqQkpbzTVoATdOgbl
   d6u4PXnvDoCK9ZvZAccQDbKN2jmdHko9HFhQcfpqsKQUcwjcxk/GK87Wm
   Ba3fOinjO+l6/w9VcPKP+f4MWcdof7k1mW9mQlixgeF6TWu+1BRQqr4Ij
   UaDtmk8ZGQhJNsHeq5vKCaqm6RqJwS3vkPJmRZrqEcgIfsHKci2a8NzgK
   75SXPndmx+GsXKKt2HceLenbYtWYLENWW5RXmscbxxn1BqQZ6YQSzI1Ek
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="381413937"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="381413937"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 01:03:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="975786174"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="975786174"
Received: from ssid-ilbpg3.png.intel.com ([10.88.227.111])
  by fmsmga005.fm.intel.com with ESMTP; 08 Dec 2022 01:03:16 -0800
From:   Lai Peter Jun Ann <jun.ann.lai@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Lai Peter Jun Ann <jun.ann.lai@intel.com>
Subject: [PATCH net-next 1/1] net: stmmac: Add check for taprio basetime configuration
Date:   Thu,  8 Dec 2022 17:03:15 +0800
Message-Id: <1670490195-19367-1-git-send-email-jun.ann.lai@intel.com>
X-Mailer: git-send-email 1.9.1
X-Spam-Status: No, score=-1.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>

Adds a boundary check to prevent negative basetime input from user
while configuring taprio.

Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Signed-off-by: Lai Peter Jun Ann <jun.ann.lai@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 773e415..2cfb18c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -926,6 +926,9 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	int i, ret = 0;
 	u64 ctr;
 
+	if (qopt->base_time < 0)
+		return -ERANGE;
+
 	if (!priv->dma_cap.estsel)
 		return -EOPNOTSUPP;
 
-- 
1.9.1

