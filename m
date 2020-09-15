Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424E9269B7E
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIOBpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:45:31 -0400
Received: from mga06.intel.com ([134.134.136.31]:12848 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbgIOBp1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 21:45:27 -0400
IronPort-SDR: dUlurhndlwqjht1XOxLxvyQ1w11R5BqQdAauh7ZAwwVSorRNu3rQKx4lFHerOf/6htF/1vCaAb
 kwtKup10Bwrg==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="220742450"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="220742450"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 18:45:09 -0700
IronPort-SDR: 3iuJ2DexVEC8hZixau7SVVQxL9zMlsP38V2OWriSqGOwp2NMnOHgvZvCKA7uMDCAA7s3av3HAw
 vamg1JOMGPOw==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482571962"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.56])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 18:45:09 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next v2 09/10] sfc: fix kdoc warning
Date:   Mon, 14 Sep 2020 18:44:54 -0700
Message-Id: <20200915014455.1232507-10-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel-doc script as used by W=1, is confused by the macro
usage inside the header describing the efx_ptp_data struct.

drivers/net/ethernet/sfc/ptp.c:345: warning: Function parameter or member 'MC_CMD_PTP_IN_TRANSMIT_LENMAX' not described in 'efx_ptp_data'

After some discussion on the list, break this patch out to
a separate one, and fix the issue through a creative
macro declaration.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi.h | 1 +
 drivers/net/ethernet/sfc/ptp.c  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index ef6d21e4bd0b..69c2924a147c 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -190,6 +190,7 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
  * 32-bit-aligned.  Also, on Siena we must copy to the MC shared
  * memory strictly 32 bits at a time, so add any necessary padding.
  */
+#define MCDI_TX_BUF_LEN(_len) DIV_ROUND_UP((_len), 4)
 #define _MCDI_DECLARE_BUF(_name, _len)					\
 	efx_dword_t _name[DIV_ROUND_UP(_len, 4)]
 #define MCDI_DECLARE_BUF(_name, _len)					\
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index bea4725a4499..a5f0c943a9bf 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -325,7 +325,7 @@ struct efx_ptp_data {
 	struct work_struct pps_work;
 	struct workqueue_struct *pps_workwq;
 	bool nic_ts_enabled;
-	_MCDI_DECLARE_BUF(txbuf, MC_CMD_PTP_IN_TRANSMIT_LENMAX);
+	efx_dword_t txbuf[MCDI_TX_BUF_LEN(MC_CMD_PTP_IN_TRANSMIT_LENMAX)];
 
 	unsigned int good_syncs;
 	unsigned int fast_syncs;
-- 
2.28.0

