Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15E238BD66
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 06:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239069AbhEUE2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 00:28:34 -0400
Received: from inva021.nxp.com ([92.121.34.21]:52486 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239062AbhEUE2Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 00:28:25 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 451292006B6;
        Fri, 21 May 2021 06:26:32 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva021.eu-rdc02.nxp.com 451292006B6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com;
        s=nselector4; t=1621571192;
        bh=vSH6qe4RRrXv5rg1WC3/BTKNnR2jOaq7vgUi0iNwVKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rlqi52AiJNzKyTNEkrYMZhoG7T6/Kg6OEHi+YtWABE7L1XCnmUiMJotXQGyjJURlw
         vW3hjyCJGMuTFBV83Oy+lC2OiiQFMpKAr/bxdPojZA11eKLSCyg4/49/urYna7sGvh
         e20hH5N21lGcBVE335+Lchl5JZDB6l0wsN2g5yrW3e64EDtsBsx5C8HtpFbDX7RGDu
         hGZVPXnkfGbCIlzK9eryqqYS+fKFTugLDapGWJSf2pdRyjFpRc0guBnESsTT0g54MX
         hhbGL4JVIrCWIcjjVMCQ7mssgA82k8bUcCjY+By1E92rFum2w65PgojYKFOuA/r5BE
         EGXTDfg9aLpJA==
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8CAFD20067E;
        Fri, 21 May 2021 06:26:29 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva021.eu-rdc02.nxp.com 8CAFD20067E
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id E4E3940243;
        Fri, 21 May 2021 12:26:25 +0800 (+08)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next, v2, 5/7] enetc_ptp: support ptp virtual clock
Date:   Fri, 21 May 2021 12:36:17 +0800
Message-Id: <20210521043619.44694-6-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210521043619.44694-1-yangbo.lu@nxp.com>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for ptp virtual clock.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Made ptp_qoriq_vclock_cc static.
	- Updated copyright.
---
 drivers/net/ethernet/freescale/enetc/enetc_ptp.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
index bc594892507a..dabcdaf972a9 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
-/* Copyright 2019 NXP */
+/* Copyright 2019-2021 NXP */
 
 #include <linux/module.h>
 #include <linux/of.h>
@@ -10,6 +10,16 @@
 int enetc_phc_index = -1;
 EXPORT_SYMBOL(enetc_phc_index);
 
+static struct ptp_vclock_cc ptp_qoriq_vclock_cc = {
+	.cc.read		= ptp_qoriq_clock_read,
+	.cc.mask		= CYCLECOUNTER_MASK(64),
+	.cc.shift		= 28,
+	.cc.mult		= (1 << 28),
+	.refresh_interval	= (HZ * 60),
+	.mult_factor		= (1 << 6),
+	.div_factor		= 15625,
+};
+
 static struct ptp_clock_info enetc_ptp_caps = {
 	.owner		= THIS_MODULE,
 	.name		= "ENETC PTP clock",
@@ -24,6 +34,7 @@ static struct ptp_clock_info enetc_ptp_caps = {
 	.gettime64	= ptp_qoriq_gettime,
 	.settime64	= ptp_qoriq_settime,
 	.enable		= ptp_qoriq_enable,
+	.vclock_cc	= &ptp_qoriq_vclock_cc,
 };
 
 static int enetc_ptp_probe(struct pci_dev *pdev,
-- 
2.25.1

