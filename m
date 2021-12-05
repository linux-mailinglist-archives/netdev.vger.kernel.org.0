Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378D3468B86
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 15:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbhLEPAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 10:00:33 -0500
Received: from mga03.intel.com ([134.134.136.65]:20582 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234836AbhLEPAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 10:00:31 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10188"; a="237132482"
X-IronPort-AV: E=Sophos;i="5.87,289,1631602800"; 
   d="scan'208";a="237132482"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2021 06:57:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,289,1631602800"; 
   d="scan'208";a="514507283"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by fmsmga007.fm.intel.com with ESMTP; 05 Dec 2021 06:57:01 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH V2 net-next 1/7] net: wwan: iosm: stop sending unnecessary doorbell
Date:   Sun,  5 Dec 2021 20:34:49 +0530
Message-Id: <20211205150455.1829929-2-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211205150455.1829929-1-m.chetan.kumar@linux.intel.com>
References: <20211205150455.1829929-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In TX packet accumulation flow transport layer is
giving a doorbell to device even though there is
no pending control TX transfer that needs immediate
attention.

Introduced a new hpda_ctrl_pending variable to keep
track of pending control TX transfer. If there is a
pending control TX transfer which needs an immediate
attention only then give a doorbell to device.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
v2: No Change.
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index 1be07114c85d..644a871585ea 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -182,9 +182,9 @@ void ipc_imem_hrtimer_stop(struct hrtimer *hr_timer)
 bool ipc_imem_ul_write_td(struct iosm_imem *ipc_imem)
 {
 	struct ipc_mem_channel *channel;
+	bool hpda_ctrl_pending = false;
 	struct sk_buff_head *ul_list;
 	bool hpda_pending = false;
-	bool forced_hpdu = false;
 	struct ipc_pipe *pipe;
 	int i;

@@ -201,15 +201,19 @@ bool ipc_imem_ul_write_td(struct iosm_imem *ipc_imem)
 		ul_list = &channel->ul_list;

 		/* Fill the transfer descriptor with the uplink buffer info. */
-		hpda_pending |= ipc_protocol_ul_td_send(ipc_imem->ipc_protocol,
+		if (!ipc_imem_check_wwan_ips(channel)) {
+			hpda_ctrl_pending |=
+				ipc_protocol_ul_td_send(ipc_imem->ipc_protocol,
 							pipe, ul_list);
-
-		/* forced HP update needed for non data channels */
-		if (hpda_pending && !ipc_imem_check_wwan_ips(channel))
-			forced_hpdu = true;
+		} else {
+			hpda_pending |=
+				ipc_protocol_ul_td_send(ipc_imem->ipc_protocol,
+							pipe, ul_list);
+		}
 	}

-	if (forced_hpdu) {
+	/* forced HP update needed for non data channels */
+	if (hpda_ctrl_pending) {
 		hpda_pending = false;
 		ipc_protocol_doorbell_trigger(ipc_imem->ipc_protocol,
 					      IPC_HP_UL_WRITE_TD);
--
2.25.1

