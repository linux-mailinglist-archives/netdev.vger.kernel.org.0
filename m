Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497DF360199
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 07:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhDOF2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 01:28:53 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54012 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhDOF2w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 01:28:52 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DA7C81A3028;
        Thu, 15 Apr 2021 07:28:28 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 92FDE1A1506;
        Thu, 15 Apr 2021 07:28:26 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 5406F402A6;
        Thu, 15 Apr 2021 07:28:23 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next] enetc: convert to schedule_work()
Date:   Thu, 15 Apr 2021 13:34:55 +0800
Message-Id: <20210415053455.10029-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert system_wq queue_work() to schedule_work() which is
a wrapper around it, since the former is a rare construct.

Fixes: 7294380c5211 ("enetc: support PTP Sync packet one-step timestamping")
Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 4a0adb0b8bd7..9a726085841d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -552,7 +552,7 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 				 * timestamping packet. And send one skb in
 				 * tx_skbs queue if has.
 				 */
-				queue_work(system_wq, &priv->tx_onestep_tstamp);
+				schedule_work(&priv->tx_onestep_tstamp);
 			} else if (unlikely(do_twostep_tstamp)) {
 				enetc_tstamp_tx(skb, tstamp);
 				do_twostep_tstamp = false;

base-commit: 3a1aa533f7f676aad68f8dbbbba10b9502903770
-- 
2.25.1

