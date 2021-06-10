Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E043A2767
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 10:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhFJIvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 04:51:15 -0400
Received: from mga07.intel.com ([134.134.136.100]:4236 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhFJIvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 04:51:14 -0400
IronPort-SDR: Y6QQFDInwVutPzBqjsZhoecevuzZhpUFAcSE22PxCBoZ4W8ruiOWPilrMHI5u9RjKfZtOQQQj/
 ELQs6YS/MAkw==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="269109593"
X-IronPort-AV: E=Sophos;i="5.83,263,1616482800"; 
   d="scan'208";a="269109593"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 01:49:13 -0700
IronPort-SDR: tWyKEu0tHSOZusqlFndwFkERH2/HlIARjRaOnVupIdzhJH6dxixEZq+MF66efislk7Mmn1ZObI
 vnFHtpqXTpdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,263,1616482800"; 
   d="scan'208";a="486088008"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 10 Jun 2021 01:49:13 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id C2C8D580B58;
        Thu, 10 Jun 2021 01:49:10 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 1/1] net: stmmac: Fix mixed enum type warning
Date:   Thu, 10 Jun 2021 16:53:54 +0800
Message-Id: <20210610085354.656580-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 5a5586112b92 ("net: stmmac: support FPE link partner
hand-shaking procedure") introduced the following coverity warning:

  "Parse warning (PW.MIXED_ENUM_TYPE)"
  "1. mixed_enum_type: enumerated type mixed with another type"

This is due to both "lo_state" and "lp_sate" which their datatype are
enum stmmac_fpe_state type, and being assigned with "FPE_EVENT_UNKNOWN"
which is a macro-defined of 0. Fixed this by assigned both these
variables with the correct enum value.

Fixes: 5a5586112b92 ("net: stmmac: support FPE link partner hand-shaking procedure")
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 180f347b4c8e..db97cd4b871d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1021,8 +1021,8 @@ static void stmmac_fpe_link_state_handle(struct stmmac_priv *priv, bool is_up)
 	if (is_up && *hs_enable) {
 		stmmac_fpe_send_mpacket(priv, priv->ioaddr, MPACKET_VERIFY);
 	} else {
-		*lo_state = FPE_EVENT_UNKNOWN;
-		*lp_state = FPE_EVENT_UNKNOWN;
+		*lo_state = FPE_STATE_OFF;
+		*lp_state = FPE_STATE_OFF;
 	}
 }
 
-- 
2.25.1

