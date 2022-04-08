Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0D04F9745
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 15:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236511AbiDHNuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 09:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbiDHNuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 09:50:50 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E327F1E92;
        Fri,  8 Apr 2022 06:48:45 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 238DmeRb034356;
        Fri, 8 Apr 2022 08:48:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1649425720;
        bh=Yzv2IfuxorHkkyDNwD5OnhJsw0aVngAYPY8J9ftFkn0=;
        h=From:To:CC:Subject:Date;
        b=lahOonoKXmaVgM324eXqCXeTHJ7druJtS4BOJEhefkXD2nJgelk9r0TIbov49rlR8
         m0bjosGTXySI8iFh8SgU1J4UiIsw8NUL7Q/EIW1XdjYVAaIcq7ijB4THe3A/cZxT5O
         shtPHI3btFzirlDyQJ43EX4GAyCXj7n3zizHIbBw=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 238DmeNM041045
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 8 Apr 2022 08:48:40 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Fri, 8
 Apr 2022 08:48:40 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Fri, 8 Apr 2022 08:48:40 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 238DmdOp071085;
        Fri, 8 Apr 2022 08:48:39 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next] net: ethernet: ti: cpsw: drop CPSW_HEADROOM define
Date:   Fri, 8 Apr 2022 16:48:38 +0300
Message-ID: <20220408134838.24761-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 1771afd47430 ("net: cpsw: avoid alignment faults by taking
NET_IP_ALIGN into account") the TI CPSW driver was switched to use correct
define CPSW_HEADROOM_NA to avoid alignment faults, but there are two places
left where CPSW_HEADROOM is still used (without causing issues).

Hence, completely drop CPSW_HEADROOM define and use CPSW_HEADROOM_NA
everywhere to avoid further mistakes in code.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw.c      | 2 +-
 drivers/net/ethernet/ti/cpsw_new.c  | 2 +-
 drivers/net/ethernet/ti/cpsw_priv.h | 1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 03575c017500..e4edcc8c6889 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -335,7 +335,7 @@ static void cpsw_ndo_set_rx_mode(struct net_device *ndev)
 
 static unsigned int cpsw_rxbuf_total_len(unsigned int len)
 {
-	len += CPSW_HEADROOM;
+	len += CPSW_HEADROOM_NA;
 	len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
 	return SKB_DATA_ALIGN(len);
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 561fd8c51cda..dfa0a9cf9d89 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -273,7 +273,7 @@ static void cpsw_ndo_set_rx_mode(struct net_device *ndev)
 
 static unsigned int cpsw_rxbuf_total_len(unsigned int len)
 {
-	len += CPSW_HEADROOM;
+	len += CPSW_HEADROOM_NA;
 	len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
 	return SKB_DATA_ALIGN(len);
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index ec751e7e001d..fc591f5ebe18 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -418,7 +418,6 @@ struct __aligned(sizeof(long)) cpsw_meta_xdp {
 
 /* The buf includes headroom compatible with both skb and xdpf */
 #define CPSW_HEADROOM_NA (max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + NET_IP_ALIGN)
-#define CPSW_HEADROOM  ALIGN(CPSW_HEADROOM_NA, sizeof(long))
 
 static inline int cpsw_is_xdpf_handle(void *handle)
 {
-- 
2.17.1

