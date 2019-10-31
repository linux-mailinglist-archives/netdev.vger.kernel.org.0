Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4003AEAF0B
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfJaLhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:37:14 -0400
Received: from inva021.nxp.com ([92.121.34.21]:44304 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbfJaLhL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 07:37:11 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 95678200501;
        Thu, 31 Oct 2019 12:37:09 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 881B22004F1;
        Thu, 31 Oct 2019 12:37:09 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 3D64D205E9;
        Thu, 31 Oct 2019 12:37:09 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, jakub.kicinski@netronome.com,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [net-next 09/13] dpaa_eth: add dropped frames to percpu ethtool stats
Date:   Thu, 31 Oct 2019 13:36:55 +0200
Message-Id: <1572521819-10458-10-git-send-email-madalin.bucur@nxp.com>
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

Prior to this change, the frames dropped on receive or transmit
were not displayed in the ethtool statistics, leaving the dropped
frames unaccounted for.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index bc6ed1df53ca..1c689e11c61f 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -47,6 +47,8 @@ static const char dpaa_stats_percpu[][ETH_GSTRING_LEN] = {
 	"tx S/G",
 	"tx error",
 	"rx error",
+	"rx dropped",
+	"tx dropped",
 };
 
 static char dpaa_stats_global[][ETH_GSTRING_LEN] = {
@@ -262,6 +264,12 @@ static void copy_stats(struct dpaa_percpu_priv *percpu_priv, int num_cpus,
 	data[crr * num_values + crr_cpu] = percpu_priv->stats.rx_errors;
 	data[crr++ * num_values + num_cpus] += percpu_priv->stats.rx_errors;
 
+	data[crr * num_values + crr_cpu] = percpu_priv->stats.rx_dropped;
+	data[crr++ * num_values + num_cpus] += percpu_priv->stats.rx_dropped;
+
+	data[crr * num_values + crr_cpu] = percpu_priv->stats.tx_dropped;
+	data[crr++ * num_values + num_cpus] += percpu_priv->stats.tx_dropped;
+
 	data[crr * num_values + crr_cpu] = bp_count;
 	data[crr++ * num_values + num_cpus] += bp_count;
 }
-- 
2.1.0

