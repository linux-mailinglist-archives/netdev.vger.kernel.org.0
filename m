Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C42461A9E
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 16:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235775AbhK2PJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 10:09:13 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:14994 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242424AbhK2PHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 10:07:12 -0500
Received: from dggeml709-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J2pT54JMYzZdJ9;
        Mon, 29 Nov 2021 23:01:13 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 dggeml709-chm.china.huawei.com (10.3.17.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Mon, 29 Nov 2021 23:03:52 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net: mscc: ocelot: fix missing unlock on error in ocelot_hwstamp_set()
Date:   Mon, 29 Nov 2021 15:16:52 +0000
Message-ID: <20211129151652.1165433-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeml709-chm.china.huawei.com (10.3.17.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing mutex_unlock before return from function
ocelot_hwstamp_set() in the ocelot_setup_ptp_traps() error
handling case.

Fixes: 96ca08c05838 ("net: mscc: ocelot: set up traps for PTP packets")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index fe8abb30f185..b1856d8c944b 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1651,8 +1651,10 @@ int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
 	}
 
 	err = ocelot_setup_ptp_traps(ocelot, port, l2, l4);
-	if (err)
+	if (err) {
+		mutex_unlock(&ocelot->ptp_lock);
 		return err;
+	}
 
 	if (l2 && l4)
 		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;

