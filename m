Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30ECA62A455
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 22:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238851AbiKOVlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 16:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238808AbiKOVkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 16:40:49 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17085659D;
        Tue, 15 Nov 2022 13:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668548440; x=1700084440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nl98HcOSodJTwdzaq/n4NRjid0k79X3jiygrlPJKglg=;
  b=1gl63uHMF++mFQQxE80M8koo7u9ZnpdeBMTMUfZyttQLFK9nU85mgbIV
   R1PHd6oVYGlAPJ+M5/m0FZbgCXlIt1l4KaJdBtB9QpebBe0tgbhrvDEL7
   c1spY5eS4VZj848W4Pm6yxPx+7i6SZTp4NMqoeQD2UmaQxC9McKHyEDQW
   rApH/EmYM/FKz+lIyTWP3E1LiYlFHdYJl3v8ixeoFSsl43Fj5u+9NCPds
   5b5g0vF2eWC6JGy662Qg4WFl6g/viT6JqjhGYWOCtlvKwZADclp1EPb8i
   ez2VGF6Px1wbsPLjujsEZ0o5gLJTDuaSpOz5CGLt1ofsmZXlDOKxPw6Ep
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="123588545"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Nov 2022 14:40:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 15 Nov 2022 14:40:36 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 15 Nov 2022 14:40:34 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <alexandr.lobakin@intel.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 5/5] net: lan966x: Add support for XDP_REDIRECT
Date:   Tue, 15 Nov 2022 22:44:56 +0100
Message-ID: <20221115214456.1456856-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221115214456.1456856-1-horatiu.vultur@microchip.com>
References: <20221115214456.1456856-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend lan966x XDP support with the action XDP_REDIRECT. This is similar
with the XDP_TX, so a lot of functionality can be reused.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c |  9 ++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |  1 +
 .../ethernet/microchip/lan966x/lan966x_main.h |  6 ++++
 .../ethernet/microchip/lan966x/lan966x_xdp.c  | 28 +++++++++++++++++++
 4 files changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index c2e56233a8da5..b863a5b50d4de 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0+
 
 #include <linux/bpf.h>
+#include <linux/filter.h>
 
 #include "lan966x_main.h"
 
@@ -518,6 +519,7 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 	int dcb_reload = rx->dcb_index;
 	struct lan966x_rx_dcb *old_dcb;
 	struct lan966x_db *db;
+	bool redirect = false;
 	struct sk_buff *skb;
 	struct page *page;
 	int counter = 0;
@@ -543,6 +545,10 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 		case FDMA_TX:
 			lan966x_fdma_rx_advance_dcb(rx);
 			continue;
+		case FDMA_REDIRECT:
+			lan966x_fdma_rx_advance_dcb(rx);
+			redirect = true;
+			continue;
 		case FDMA_DROP:
 			lan966x_fdma_rx_free_page(rx);
 			lan966x_fdma_rx_advance_dcb(rx);
@@ -579,6 +585,9 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 	if (counter < weight && napi_complete_done(napi, counter))
 		lan_wr(0xff, lan966x, FDMA_INTR_DB_ENA);
 
+	if (redirect)
+		xdp_do_flush();
+
 	return counter;
 }
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 0b7707306da26..0aed244826d39 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -469,6 +469,7 @@ static const struct net_device_ops lan966x_port_netdev_ops = {
 	.ndo_eth_ioctl			= lan966x_port_ioctl,
 	.ndo_setup_tc			= lan966x_tc_setup,
 	.ndo_bpf			= lan966x_xdp,
+	.ndo_xdp_xmit			= lan966x_xdp_xmit,
 };
 
 bool lan966x_netdevice_check(const struct net_device *dev)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index df7fec361962b..b73c5a6cc0beb 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -106,12 +106,14 @@ enum macaccess_entry_type {
  * FDMA_ERROR, something went wrong, stop getting more frames
  * FDMA_DROP, frame is dropped, but continue to get more frames
  * FDMA_TX, frame is given to TX, but continue to get more frames
+ * FDMA_REDIRECT, frame is given to TX, but continue to get more frames
  */
 enum lan966x_fdma_action {
 	FDMA_PASS = 0,
 	FDMA_ERROR,
 	FDMA_DROP,
 	FDMA_TX,
+	FDMA_REDIRECT,
 };
 
 struct lan966x_port;
@@ -564,6 +566,10 @@ int lan966x_xdp(struct net_device *dev, struct netdev_bpf *xdp);
 int lan966x_xdp_run(struct lan966x_port *port,
 		    struct page *page,
 		    u32 data_len);
+int lan966x_xdp_xmit(struct net_device *dev,
+		     int n,
+		     struct xdp_frame **frames,
+		     u32 flags);
 static inline bool lan966x_xdp_port_present(struct lan966x_port *port)
 {
 	return !!port->xdp_prog;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
index 9b0ba3179df62..d2ecfe78382cf 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
@@ -35,6 +35,29 @@ int lan966x_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	}
 }
 
+int lan966x_xdp_xmit(struct net_device *dev,
+		     int n,
+		     struct xdp_frame **frames,
+		     u32 flags)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	int i, nxmit = 0;
+
+	for (i = 0; i < n; ++i) {
+		struct xdp_frame *xdpf = frames[i];
+		int err;
+
+		err = lan966x_fdma_xmit_xdpf(port, xdpf,
+					     virt_to_head_page(xdpf->data));
+		if (err)
+			break;
+
+		nxmit++;
+	}
+
+	return nxmit;
+}
+
 int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
 {
 	struct bpf_prog *xdp_prog = port->xdp_prog;
@@ -59,6 +82,11 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
 
 		return lan966x_fdma_xmit_xdpf(port, xdpf, page) ?
 		       FDMA_DROP : FDMA_TX;
+	case XDP_REDIRECT:
+		if (xdp_do_redirect(port->dev, &xdp, xdp_prog))
+			return FDMA_DROP;
+
+		return FDMA_REDIRECT;
 	default:
 		bpf_warn_invalid_xdp_action(port->dev, xdp_prog, act);
 		fallthrough;
-- 
2.38.0

