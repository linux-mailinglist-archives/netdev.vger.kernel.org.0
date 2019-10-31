Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5E5EAF05
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfJaLhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:37:13 -0400
Received: from inva020.nxp.com ([92.121.34.13]:56418 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726783AbfJaLhM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 07:37:12 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 644761A000B;
        Thu, 31 Oct 2019 12:37:11 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 580B71A0514;
        Thu, 31 Oct 2019 12:37:11 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 1B3A4205E9;
        Thu, 31 Oct 2019 12:37:11 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, jakub.kicinski@netronome.com,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [net-next 11/13] dpaa_eth: extend delays in ndo_stop
Date:   Thu, 31 Oct 2019 13:36:57 +0200
Message-Id: <1572521819-10458-12-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1572521819-10458-1-git-send-email-madalin.bucur@nxp.com>
References: <1572521819-10458-1-git-send-email-madalin.bucur@nxp.com>
Content-Type: text/plain; charset="us-ascii"
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
index ee22ed3207b4..9e6080aaf77a 100644
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

