Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68531298A4C
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 11:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769512AbgJZKWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 06:22:06 -0400
Received: from esa1.mentor.iphmx.com ([68.232.129.153]:30935 "EHLO
        esa1.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1737087AbgJZKWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 06:22:06 -0400
IronPort-SDR: YRo55J557N13+I3yWtqXaapNWdovLDr6SmrPQ9TR5zQjHgrmA7m/DQAY4lhPGBsAeLpZ1PR0G3
 rnn/2aOjAwuMjXz9H2Q3IncdFbTIo7TAN3v4XEXLDIdHR+mxnao8jdPB9lxx09VubUrGv3Ch3Z
 zleYb9IhmCucHgU39GWS7+gI/3gSMOJC+v9A604wGQnkfRQS2GHXd4KB7lasP1tjtvNHtz6QZA
 ZB+khe1nx66wh6YKZkkpmMXAIfkOTiyhTBdtEdCbolJlpN6Q3571J1ddriFw//VEzN6Z8P8wzG
 alU=
X-IronPort-AV: E=Sophos;i="5.77,419,1596528000"; 
   d="scan'208";a="56606908"
Received: from orw-gwy-01-in.mentorg.com ([192.94.38.165])
  by esa1.mentor.iphmx.com with ESMTP; 26 Oct 2020 02:22:05 -0800
IronPort-SDR: oiPiE7abMAhr4lniMrTvHffBVbglbEkbjdrbyq1oreQ3h6LVBjNQUO/1+zMSCpuJuv/tWt8166
 wj6/HlJaKMHYJO1ZarWZ8/AbKS5y0hqhSqzjoAYchV7kPj6nByKWNOG4SSgw/qslOUdIZkqI8Q
 oNtcDJf0pUIQYc5Cottm/efsCJ+FxRCegOJtK8uOnZ5XRalEe9JZxBOxjrw9F8gcV4owBFv8ci
 8twIHaduWQpucbjcZynWKSExD3J6DieFNiDFs8ZJt3vI/F4E+J0M77krf1KTtV3v2WjexqYGuY
 cHU=
From:   Andrew Gabbasov <andrew_gabbasov@mentor.com>
To:     <linux-renesas-soc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, <geert+renesas@glider.be>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>
Subject: [PATCH net v2] ravb: Fix bit fields checking in ravb_hwtstamp_get()
Date:   Mon, 26 Oct 2020 05:21:30 -0500
Message-ID: <20201026102130.29368-1-andrew_gabbasov@mentor.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [137.202.0.90]
X-ClientProxiedBy: SVR-IES-MBX-04.mgc.mentorg.com (139.181.222.4) To
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
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 9c4df4ede011..bd30505fbc57 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1744,12 +1744,16 @@ static int ravb_hwtstamp_get(struct net_device *ndev, struct ifreq *req)
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

