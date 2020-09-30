Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03BE27F295
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbgI3T3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:29:21 -0400
Received: from esa3.mentor.iphmx.com ([68.232.137.180]:8472 "EHLO
        esa3.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgI3T3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 15:29:21 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Sep 2020 15:29:20 EDT
IronPort-SDR: 79Y+dQNdbeABQCfzpyJGfU1sh1XoRyQaVczTlK10vCjQxJQ4sSkyPTfz1X4sCabjqIHZ+0q2ce
 n0dckxVONw1h+2mYHVwtmM4SGUNFJW+XRpOCWA8zmVzXtdiJJbyyLnaPiv+kRGpJkmwFF24VqF
 JUZ3VwYkGfnhlVyBG+xxrLLZqabOFG8UE52L/I+jThnBViJs9zdrsBVWoeXHMvGAse3Tr8d8QB
 4vT1QCnEqOnm7YA0kbIN5Y8XN8pLJO2X1TCxYWsJ264IGd8O0dqM8Fblk/0sGImsq85+A5/8rA
 Ff4=
X-IronPort-AV: E=Sophos;i="5.77,322,1596528000"; 
   d="scan'208";a="53432061"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa3.mentor.iphmx.com with ESMTP; 30 Sep 2020 11:22:13 -0800
IronPort-SDR: XYbYlObdcqtCz/2S2ePqINMCdlQmkUbA6J6SFwP3KrWiEWlIh3QNBTdiybCzBUHyUIis4G7NFk
 DgKgYHpsX0O4EtJAn1XU2ggBKTNtN9qdDlmRUNGDk5tBztwxyvhFOy5yty1W4SEsZufiS7hWKl
 PZPCxK79KYEskJKS0y2NLKGGP0bigw5GfIWmb2TcTJngC0RGlaucEiJKiKE9MEWE/Rcx+k2U3o
 pNbVerm+2nELL76EYh1JElJum2cVeLIxEyqkiPF1XPMXug4y/BZBrQNh4Ju1KH/w/2W6jN+yO8
 ktg=
From:   Andrew Gabbasov <andrew_gabbasov@mentor.com>
To:     <linux-renesas-soc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, <geert+renesas@glider.be>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>
Subject: [PATCH net] ravb: Fix bit fields checking in ravb_hwtstamp_get()
Date:   Wed, 30 Sep 2020 14:21:24 -0500
Message-ID: <20200930192124.25060-1-andrew_gabbasov@mentor.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [137.202.0.90]
X-ClientProxiedBy: SVR-IES-MBX-08.mgc.mentorg.com (139.181.222.8) To
 svr-ies-mbx-02.mgc.mentorg.com (139.181.222.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function ravb_hwtstamp_get() in ravb_main.c with the existing
values for RAVB_RXTSTAMP_TYPE_V2_L2_EVENT (0x2) and RAVB_RXTSTAMP_TYPE_ALL
(0x6)

if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_V2_L2_EVENT)
	config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
else if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_ALL)
	config.rx_filter = HWTSTAMP_FILTER_ALL;

if the test on RAVB_RXTSTAMP_TYPE_ALL should be true,
it will never be reached.

This issue can be verified with 'hwtstamp_config' testing program
(tools/testing/selftests/net/hwtstamp_config.c). Setting filter type
to ALL and subsequent retrieving it gives incorrect value:

$ hwtstamp_config eth0 OFF ALL
flags = 0
tx_type = OFF
rx_filter = ALL
$ hwtstamp_config eth0
flags = 0
tx_type = OFF
rx_filter = PTP_V2_L2_EVENT

Correct this by converting if-else's to switch.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Andrew Gabbasov <andrew_gabbasov@mentor.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index df89d09b253e..c0610b2d3b14 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1802,12 +1802,16 @@ static int ravb_hwtstamp_get(struct net_device *ndev, struct ifreq *req)
 	config.flags = 0;
 	config.tx_type = priv->tstamp_tx_ctrl ? HWTSTAMP_TX_ON :
 						HWTSTAMP_TX_OFF;
-	if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_V2_L2_EVENT)
+	switch (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE) {
+	case RAVB_RXTSTAMP_TYPE_V2_L2_EVENT:
 		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
-	else if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_ALL)
+		break;
+	case RAVB_RXTSTAMP_TYPE_ALL:
 		config.rx_filter = HWTSTAMP_FILTER_ALL;
-	else
+		break;
+	default:
 		config.rx_filter = HWTSTAMP_FILTER_NONE;
+	}
 
 	return copy_to_user(req->ifr_data, &config, sizeof(config)) ?
 		-EFAULT : 0;
-- 
2.21.0

