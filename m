Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DE73554B8
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 15:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239386AbhDFNNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 09:13:18 -0400
Received: from mga07.intel.com ([134.134.136.100]:40797 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhDFNNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 09:13:14 -0400
IronPort-SDR: w2XddTqzmG1uTbOmELe2LjSzt/L8gqwW8n5l/NvxklA7I+siYdADdjVAc1Gwa5JE+ZFrGpFbH5
 SX7zMShdT0iw==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="257046005"
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="257046005"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 06:13:05 -0700
IronPort-SDR: sOc5CsVpUc5Gnm5DJHgcvOj4bB0TSMgw6iKLZD682KIe74/Oxl0pDGU3pmJw986Vdad9JpfVZW
 yJD7WOkaTNMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="414766179"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga008.fm.intel.com with ESMTP; 06 Apr 2021 06:13:05 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.59])
        by linux.intel.com (Postfix) with ESMTP id 3347B5808ED;
        Tue,  6 Apr 2021 06:13:04 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH net v1 1/1] ethtool: fix incorrect datatype in set_eee ops
Date:   Tue,  6 Apr 2021 21:17:30 +0800
Message-Id: <20210406131730.25404-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The member 'tx_lpi_timer' is defined with __u32 datatype in the ethtool
header file. Hence, we should use ethnl_update_u32() in set_eee ops.

Fixes: fd77be7bd43c ("ethtool: set EEE settings with EEE_SET request")
Cc: <stable@vger.kernel.org> # 5.10.x
Cc: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 net/ethtool/eee.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/eee.c b/net/ethtool/eee.c
index 901b7de941ab..e10bfcc07853 100644
--- a/net/ethtool/eee.c
+++ b/net/ethtool/eee.c
@@ -169,8 +169,8 @@ int ethnl_set_eee(struct sk_buff *skb, struct genl_info *info)
 	ethnl_update_bool32(&eee.eee_enabled, tb[ETHTOOL_A_EEE_ENABLED], &mod);
 	ethnl_update_bool32(&eee.tx_lpi_enabled,
 			    tb[ETHTOOL_A_EEE_TX_LPI_ENABLED], &mod);
-	ethnl_update_bool32(&eee.tx_lpi_timer, tb[ETHTOOL_A_EEE_TX_LPI_TIMER],
-			    &mod);
+	ethnl_update_u32(&eee.tx_lpi_timer, tb[ETHTOOL_A_EEE_TX_LPI_TIMER],
+			 &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
-- 
2.25.1

