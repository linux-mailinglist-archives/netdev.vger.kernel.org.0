Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7821339892
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 21:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhCLUoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 15:44:12 -0500
Received: from mxout03.lancloud.ru ([45.84.86.113]:55294 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbhCLUnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 15:43:49 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 6CC57209388B
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: [PATCH net-next 1/4] sh_eth: rename TRSCER bits
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>
References: <41a26045-c70e-32d7-b13e-8a8bd0834fcc@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <3850b8e5-8abe-c044-cfb9-0e0774a0a554@omprussia.ru>
Date:   Fri, 12 Mar 2021 23:43:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <41a26045-c70e-32d7-b13e-8a8bd0834fcc@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In all the SoC manuals the TRSCER register bits match the corresponding
EESR registers's bits, but only on the R-Car gen2 SoC those are named
RINT<n> and TINT<n>.  Follow the suit and rename the *enum* tag/entries
from DESC_I_* to TRSCER_*.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
 drivers/net/ethernet/renesas/sh_eth.c |    8 ++++----
 drivers/net/ethernet/renesas/sh_eth.h |   18 ++++++++++++------
 2 files changed, 16 insertions(+), 10 deletions(-)

Index: net-next/drivers/net/ethernet/renesas/sh_eth.c
===================================================================
--- net-next.orig/drivers/net/ethernet/renesas/sh_eth.c
+++ net-next/drivers/net/ethernet/renesas/sh_eth.c
@@ -560,7 +560,7 @@ static struct sh_eth_cpu_data r7s72100_d
 			  EESR_TDE,
 	.fdr_value	= 0x0000070f,
 
-	.trscer_err_mask = DESC_I_RINT8 | DESC_I_RINT5,
+	.trscer_err_mask = TRSCER_RMAFCE | TRSCER_RRFCE,
 
 	.no_psr		= 1,
 	.apr		= 1,
@@ -701,7 +701,7 @@ static struct sh_eth_cpu_data rcar_gen2_
 			  EESR_RDE | EESR_RFRMER | EESR_TFE | EESR_TDE,
 	.fdr_value	= 0x00000f0f,
 
-	.trscer_err_mask = DESC_I_RINT8,
+	.trscer_err_mask = TRSCER_RMAFCE,
 
 	.apr		= 1,
 	.mpr		= 1,
@@ -782,7 +782,7 @@ static struct sh_eth_cpu_data r7s9210_da
 
 	.fdr_value	= 0x0000070f,
 
-	.trscer_err_mask = DESC_I_RINT8 | DESC_I_RINT5,
+	.trscer_err_mask = TRSCER_RMAFCE | TRSCER_RRFCE,
 
 	.apr		= 1,
 	.mpr		= 1,
@@ -1094,7 +1094,7 @@ static struct sh_eth_cpu_data sh771x_dat
 			  EESIPR_RRFIP | EESIPR_RTLFIP | EESIPR_RTSFIP |
 			  EESIPR_PREIP | EESIPR_CERFIP,
 
-	.trscer_err_mask = DESC_I_RINT8,
+	.trscer_err_mask = TRSCER_RMAFCE,
 
 	.tsu		= 1,
 	.dual_port	= 1,
Index: net-next/drivers/net/ethernet/renesas/sh_eth.h
===================================================================
--- net-next.orig/drivers/net/ethernet/renesas/sh_eth.h
+++ net-next/drivers/net/ethernet/renesas/sh_eth.h
@@ -380,14 +380,20 @@ enum MPR_BIT {
 };
 
 /* TRSCER */
-enum DESC_I_BIT {
-	DESC_I_TINT4 = 0x0800, DESC_I_TINT3 = 0x0400, DESC_I_TINT2 = 0x0200,
-	DESC_I_TINT1 = 0x0100, DESC_I_RINT8 = 0x0080, DESC_I_RINT5 = 0x0010,
-	DESC_I_RINT4 = 0x0008, DESC_I_RINT3 = 0x0004, DESC_I_RINT2 = 0x0002,
-	DESC_I_RINT1 = 0x0001,
+enum TRSCER_BIT {
+	TRSCER_CNDCE	= 0x00000800,
+	TRSCER_DLCCE	= 0x00000400,
+	TRSCER_CDCE	= 0x00000200,
+	TRSCER_TROCE	= 0x00000100,
+	TRSCER_RMAFCE	= 0x00000080,
+	TRSCER_RRFCE	= 0x00000010,
+	TRSCER_RTLFCE	= 0x00000008,
+	TRSCER_RTSFCE	= 0x00000004,
+	TRSCER_PRECE	= 0x00000002,
+	TRSCER_CERFCE	= 0x00000001,
 };
 
-#define DEFAULT_TRSCER_ERR_MASK (DESC_I_RINT8 | DESC_I_RINT5 | DESC_I_TINT2)
+#define DEFAULT_TRSCER_ERR_MASK (TRSCER_RMAFCE | TRSCER_RRFCE | TRSCER_CDCE)
 
 /* RPADIR */
 enum RPADIR_BIT {
