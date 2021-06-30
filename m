Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11D83B886C
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhF3Saf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:30:35 -0400
Received: from mga12.intel.com ([192.55.52.136]:18074 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232358AbhF3Sae (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 14:30:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10031"; a="188092820"
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="188092820"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 11:28:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="626106789"
Received: from ccgwwan-adlp1.iind.intel.com ([10.224.174.35])
  by orsmga005.jf.intel.com with ESMTP; 30 Jun 2021 11:28:02 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH 3/5] net: wwan: iosm: correct link-id handling
Date:   Wed, 30 Jun 2021 23:57:03 +0530
Message-Id: <20210630182702.3429-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Link ID to be kept intact with MBIM session ID
Ex: ID 0 should be associated to MBIM session ID 0.

Reported-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c  | 6 +++---
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h  | 6 +++---
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c | 2 +-
 drivers/net/wwan/iosm/iosm_ipc_wwan.c      | 4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
index e4e9461b603e..0a472ce77370 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
@@ -24,7 +24,7 @@ int ipc_imem_sys_wwan_open(struct iosm_imem *ipc_imem, int if_id)
 		return -EIO;
 	}
 
-	return ipc_mux_open_session(ipc_imem->mux, if_id - 1);
+	return ipc_mux_open_session(ipc_imem->mux, if_id);
 }
 
 /* Release a net link to CP. */
@@ -33,7 +33,7 @@ void ipc_imem_sys_wwan_close(struct iosm_imem *ipc_imem, int if_id,
 {
 	if (ipc_imem->mux && if_id >= IP_MUX_SESSION_START &&
 	    if_id <= IP_MUX_SESSION_END)
-		ipc_mux_close_session(ipc_imem->mux, if_id - 1);
+		ipc_mux_close_session(ipc_imem->mux, if_id);
 }
 
 /* Tasklet call to do uplink transfer. */
@@ -76,7 +76,7 @@ int ipc_imem_sys_wwan_transmit(struct iosm_imem *ipc_imem,
 	}
 
 	/* Route the UL packet through IP MUX Layer */
-	ret = ipc_mux_ul_trigger_encode(ipc_imem->mux, if_id - 1, skb);
+	ret = ipc_mux_ul_trigger_encode(ipc_imem->mux, if_id, skb);
 out:
 	return ret;
 }
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
index fd356dafbdd6..2007fe23e9a5 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
@@ -27,11 +27,11 @@
 #define BOOT_CHECK_DEFAULT_TIMEOUT 400
 
 /* IP MUX channel range */
-#define IP_MUX_SESSION_START 1
-#define IP_MUX_SESSION_END 8
+#define IP_MUX_SESSION_START 0
+#define IP_MUX_SESSION_END 7
 
 /* Default IP MUX channel */
-#define IP_MUX_SESSION_DEFAULT	1
+#define IP_MUX_SESSION_DEFAULT	0
 
 /**
  * ipc_imem_sys_port_open - Open a port link to CP.
diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
index e634ffc6ec08..562de275797a 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
@@ -288,7 +288,7 @@ static int ipc_mux_net_receive(struct iosm_mux *ipc_mux, int if_id,
 	/* Pass the packet to the netif layer. */
 	dest_skb->priority = service_class;
 
-	return ipc_wwan_receive(wwan, dest_skb, false, if_id + 1);
+	return ipc_wwan_receive(wwan, dest_skb, false, if_id);
 }
 
 /* Decode Flow Credit Table in the block */
diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index c999c64001f4..84e37c4b0f74 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -252,8 +252,8 @@ int ipc_wwan_receive(struct iosm_wwan *ipc_wwan, struct sk_buff *skb_arg,
 
 	skb->pkt_type = PACKET_HOST;
 
-	if (if_id < (IP_MUX_SESSION_START - 1) ||
-	    if_id > (IP_MUX_SESSION_END - 1)) {
+	if (if_id < IP_MUX_SESSION_START ||
+	    if_id > IP_MUX_SESSION_END) {
 		ret = -EINVAL;
 		goto free;
 	}
-- 
2.25.1

