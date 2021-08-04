Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81473E0597
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 18:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhHDQNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 12:13:34 -0400
Received: from mga12.intel.com ([192.55.52.136]:7071 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234159AbhHDQNT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 12:13:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10066"; a="193547304"
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="193547304"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 09:11:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="569083270"
Received: from ccgwwan-adlp1.iind.intel.com ([10.224.174.35])
  by orsmga004.jf.intel.com with ESMTP; 04 Aug 2021 09:11:10 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Subject: [PATCH 2/4] net: wwan: iosm: endianness type correction
Date:   Wed,  4 Aug 2021 21:39:50 +0530
Message-Id: <20210804160952.70254-3-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804160952.70254-1-m.chetan.kumar@linux.intel.com>
References: <20210804160952.70254-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Endianness type correction for nr_of_bytes. This field is exchanged
as part of host-device protocol communication.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c | 4 ++--
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
index 562de275797a..bdb2d32cdb6d 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
@@ -320,7 +320,7 @@ static void ipc_mux_dl_fcth_decode(struct iosm_mux *ipc_mux,
 		return;
 	}
 
-	ul_credits = fct->vfl.nr_of_bytes;
+	ul_credits = le32_to_cpu(fct->vfl.nr_of_bytes);
 
 	dev_dbg(ipc_mux->dev, "Flow_Credit:: if_id[%d] Old: %d Grants: %d",
 		if_id, ipc_mux->session[if_id].ul_flow_credits, ul_credits);
@@ -586,7 +586,7 @@ static bool ipc_mux_lite_send_qlt(struct iosm_mux *ipc_mux)
 		qlt->reserved[0] = 0;
 		qlt->reserved[1] = 0;
 
-		qlt->vfl.nr_of_bytes = session->ul_list.qlen;
+		qlt->vfl.nr_of_bytes = cpu_to_le32(session->ul_list.qlen);
 
 		/* Add QLT to the transfer list. */
 		skb_queue_tail(&ipc_mux->channel->ul_list,
diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.h b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.h
index 4a74e3c9457f..aae83db5cbb8 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.h
@@ -106,7 +106,7 @@ struct mux_lite_cmdh {
  * @nr_of_bytes:	Number of bytes available to transmit in the queue.
  */
 struct mux_lite_vfl {
-	u32 nr_of_bytes;
+	__le32 nr_of_bytes;
 };
 
 /**
-- 
2.25.1

