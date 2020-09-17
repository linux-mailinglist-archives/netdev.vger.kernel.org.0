Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3161C26DB61
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 14:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgIQMUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 08:20:21 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:37994 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726952AbgIQMUC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 08:20:02 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EFCE8EDA883CF9A60A83;
        Thu, 17 Sep 2020 20:19:57 +0800 (CST)
Received: from huawei.com (10.175.104.82) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Thu, 17 Sep 2020
 20:19:54 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <ajay.kathat@microchip.com>, <claudiu.beznea@microchip.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: wilc1000: clean up resource in error path of init mon interface
Date:   Thu, 17 Sep 2020 08:30:19 -0400
Message-ID: <20200917123019.206382-1-huangguobin4@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wilc_wfi_init_mon_int() forgets to clean up resource when
register_netdevice() failed. Add the missed call to fix it.
And the return value of netdev_priv can't be NULL, so remove
the unnecessary error handling.

Fixes: 588713006ea4 ("staging: wilc1000: avoid the use of 'wilc_wfi_mon' static variable")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Huang Guobin <huangguobin4@huawei.com>
---
 drivers/net/wireless/microchip/wilc1000/mon.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/mon.c b/drivers/net/wireless/microchip/wilc1000/mon.c
index 358ac8601333..b5a1b65c087c 100644
--- a/drivers/net/wireless/microchip/wilc1000/mon.c
+++ b/drivers/net/wireless/microchip/wilc1000/mon.c
@@ -235,11 +235,10 @@ struct net_device *wilc_wfi_init_mon_interface(struct wilc *wl,
 
 	if (register_netdevice(wl->monitor_dev)) {
 		netdev_err(real_dev, "register_netdevice failed\n");
+		free_netdev(wl->monitor_dev);
 		return NULL;
 	}
 	priv = netdev_priv(wl->monitor_dev);
-	if (!priv)
-		return NULL;
 
 	priv->real_ndev = real_dev;
 
-- 
2.25.1

