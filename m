Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FBA27B887
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgI1Xzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:55:45 -0400
Received: from mga17.intel.com ([192.55.52.151]:45599 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727199AbgI1Xzo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:55:44 -0400
IronPort-SDR: UZtOr4DOWmpEr91JpSNaz+mPRtBQJoXJxfbV4RBUso3+wjsJVB2VDs0qrwcg9+varITnpVk9Ks
 UaXkTNryD/Xw==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="142086325"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="142086325"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:29 -0700
IronPort-SDR: zO3OYkW+iZRfTIr1kL6HsYkjcxZSCz705eTSqHBHnp03uUu1JUnipbquuW3Jtx74NmJTvFWlLC
 wwh9thU5fYyw==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="311962111"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:28 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 06/15] igc: Remove timeout check from ptp_tx work
Date:   Mon, 28 Sep 2020 14:50:09 -0700
Message-Id: <20200928215018.952991-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
References: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The Tx timestamp timeout is already checked by the watchdog_task
which runs periodically. In addition to that, from the ptp_tx work
perspective, if __IGC_PTP_TX_IN_PROGRESS flag is set we always want
handle the timestamp stored in hardware and update the skb. So remove
the timeout check in igc_ptp_tx_work() function.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 791f406f1314..61852c99815d 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -422,12 +422,6 @@ static void igc_ptp_tx_work(struct work_struct *work)
 	if (!test_bit(__IGC_PTP_TX_IN_PROGRESS, &adapter->state))
 		return;
 
-	if (time_is_before_jiffies(adapter->ptp_tx_start +
-				   IGC_PTP_TX_TIMEOUT)) {
-		igc_ptp_tx_timeout(adapter);
-		return;
-	}
-
 	tsynctxctl = rd32(IGC_TSYNCTXCTL);
 	if (WARN_ON_ONCE(!(tsynctxctl & IGC_TSYNCTXCTL_TXTT_0)))
 		return;
-- 
2.26.2

