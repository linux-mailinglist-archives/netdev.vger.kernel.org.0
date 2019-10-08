Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BACBFCF976
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 14:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731199AbfJHMLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 08:11:36 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54318 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731174AbfJHMLe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 08:11:34 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1344C1A0158;
        Tue,  8 Oct 2019 14:11:33 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 0626F1A00FC;
        Tue,  8 Oct 2019 14:11:33 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B1AB2205DB;
        Tue,  8 Oct 2019 14:11:32 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, laurentiu.tudor@nxp.com,
        linux-kernel@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH 18/20] dpaa_eth: extend delays in ndo_stop
Date:   Tue,  8 Oct 2019 15:10:39 +0300
Message-Id: <1570536641-25104-19-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
References: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure all the frames that are in flight have time to be processed
before the interface is completely brought down. Add a missing delay
for the Rx path.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 97fc067ae269..77edf2e026e8 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -266,7 +266,7 @@ static int dpaa_stop(struct net_device *net_dev)
 	/* Allow the Fman (Tx) port to process in-flight frames before we
 	 * try switching it off.
 	 */
-	usleep_range(5000, 10000);
+	msleep(200);
 
 	err = mac_dev->stop(mac_dev);
 	if (err < 0)
@@ -283,6 +283,8 @@ static int dpaa_stop(struct net_device *net_dev)
 		phy_disconnect(net_dev->phydev);
 	net_dev->phydev = NULL;
 
+	msleep(200);
+
 	return err;
 }
 
-- 
2.1.0

