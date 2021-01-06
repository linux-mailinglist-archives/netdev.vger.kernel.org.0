Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606AC2EC538
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 21:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbhAFUkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 15:40:23 -0500
Received: from mxout01.lancloud.ru ([45.84.86.81]:46030 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbhAFUkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 15:40:23 -0500
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jan 2021 15:40:22 EST
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 6EEBF20E410A
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: [PATCH net-next 1/2] ravb: remove APSR_DM
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>
References: <6aef8856-4bf5-1512-2ad4-62af05f00cc6@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <e1345e35-35d1-aea0-c9c8-775b28cd9f8b@omprussia.ru>
Date:   Wed, 6 Jan 2021 23:31:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6aef8856-4bf5-1512-2ad4-62af05f00cc6@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the R-Car Series, 3rd Generation User's Manual: Hardware,
Rev. 1.50, there's no APSR.DM field, instead therea are 2 independent
RX/TX clock internal delay bits.  Follow the suit: remove #define APSR_DM
and rename #define's APSR_DM_{R|T}DM to APSR_{R|T}DM.

While at it, do several more things to the declaration of *enum* APSR_BIT:
- remove superfluous indentation;
- annotate APSR_MEMS as undocumented;
- annotate APSR as R-Car Gen3 only.

Fixes: 61fccb2d6274 ("ravb: Add tx and rx clock internal delays mode of APSR")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
 drivers/net/ethernet/renesas/ravb.h      |   11 +++++------
 drivers/net/ethernet/renesas/ravb_main.c |    6 +++---
 2 files changed, 8 insertions(+), 9 deletions(-)

Index: net-next/drivers/net/ethernet/renesas/ravb.h
===================================================================
--- net-next.orig/drivers/net/ethernet/renesas/ravb.h
+++ net-next/drivers/net/ethernet/renesas/ravb.h
@@ -241,13 +241,12 @@ enum ESR_BIT {
 	ESR_EIL		= 0x00001000,
 };
 
-/* APSR */
+/* APSR (R-Car Gen3 only) */
 enum APSR_BIT {
-	APSR_MEMS		= 0x00000002,
-	APSR_CMSW		= 0x00000010,
-	APSR_DM			= 0x00006000,	/* Undocumented? */
-	APSR_DM_RDM		= 0x00002000,
-	APSR_DM_TDM		= 0x00004000,
+	APSR_MEMS	= 0x00000002,	/* Undocumented */
+	APSR_CMSW	= 0x00000010,
+	APSR_RDM	= 0x00002000,
+	APSR_TDM	= 0x00004000,
 };
 
 /* RCR */
Index: net-next/drivers/net/ethernet/renesas/ravb_main.c
===================================================================
--- net-next.orig/drivers/net/ethernet/renesas/ravb_main.c
+++ net-next/drivers/net/ethernet/renesas/ravb_main.c
@@ -2034,10 +2034,10 @@ static void ravb_set_delay_mode(struct n
 	u32 set = 0;
 
 	if (priv->rxcidm)
-		set |= APSR_DM_RDM;
+		set |= APSR_RDM;
 	if (priv->txcidm)
-		set |= APSR_DM_TDM;
-	ravb_modify(ndev, APSR, APSR_DM, set);
+		set |= APSR_TDM;
+	ravb_modify(ndev, APSR, APSR_RDM | APSR_TDM, set);
 }
 
 static int ravb_probe(struct platform_device *pdev)
