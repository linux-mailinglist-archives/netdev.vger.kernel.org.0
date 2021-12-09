Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B582446E64A
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhLIKMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:12:14 -0500
Received: from mga18.intel.com ([134.134.136.126]:6778 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232870AbhLIKMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 05:12:13 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="224933553"
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="224933553"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 02:08:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="516236606"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by orsmga008.jf.intel.com with ESMTP; 09 Dec 2021 02:08:37 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH net 1/3] net: wwan: iosm: fixes unnecessary doorbell send
Date:   Thu,  9 Dec 2021 15:46:27 +0530
Message-Id: <20211209101629.2940877-2-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209101629.2940877-1-m.chetan.kumar@linux.intel.com>
References: <20211209101629.2940877-1-m.chetan.kumar@linux.intel.com>
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
 drivers/net/wwan/iosm/iosm_ipc_imem.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index cff3b43ca4d7..b4d47b31ba91 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -181,9 +181,9 @@ void ipc_imem_hrtimer_stop(struct hrtimer *hr_timer)
 bool ipc_imem_ul_write_td(struct iosm_imem *ipc_imem)
 {
 	struct ipc_mem_channel *channel;
+	bool hpda_ctrl_pending = false;
 	struct sk_buff_head *ul_list;
 	bool hpda_pending = false;
-	bool forced_hpdu = false;
 	struct ipc_pipe *pipe;
 	int i;
 
@@ -200,15 +200,19 @@ bool ipc_imem_ul_write_td(struct iosm_imem *ipc_imem)
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

