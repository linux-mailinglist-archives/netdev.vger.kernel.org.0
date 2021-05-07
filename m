Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC63376252
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 10:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbhEGIs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:48:57 -0400
Received: from inva020.nxp.com ([92.121.34.13]:59752 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236426AbhEGIsu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 04:48:50 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id F3AB41A19C3;
        Fri,  7 May 2021 10:47:48 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4F2FF1A19CD;
        Fri,  7 May 2021 10:47:46 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id A395740326;
        Fri,  7 May 2021 10:47:42 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next 4/6] enetc_ptp: support ptp virtual clock
Date:   Fri,  7 May 2021 16:57:54 +0800
Message-Id: <20210507085756.20427-5-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210507085756.20427-1-yangbo.lu@nxp.com>
References: <20210507085756.20427-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for ptp virtual clock.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_ptp.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
index bc594892507a..52de736df800 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
@@ -10,6 +10,16 @@
 int enetc_phc_index = -1;
 EXPORT_SYMBOL(enetc_phc_index);
 
+struct ptp_vclock_cc ptp_qoriq_vclock_cc = {
+	.cc.read		= ptp_qoriq_clock_read,
+	.cc.mask		= CYCLECOUNTER_MASK(64),
+	.cc.shift		= 28,
+	.cc.mult		= (1 << 28),
+	.refresh_interval	= (HZ * 60),
+	.mult_num		= (1 << 6),
+	.mult_dem		= 15625,
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

