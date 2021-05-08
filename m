Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1FC377012
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 08:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhEHG0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 02:26:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18013 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhEHG0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 02:26:40 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fccfz5WVBzQjFm;
        Sat,  8 May 2021 14:22:19 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 8 May 2021 14:25:27 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        linux-wpan <linux-wpan@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] ieee802154: fix error return code in ieee802154_add_iface()
Date:   Sat, 8 May 2021 14:25:17 +0800
Message-ID: <20210508062517.2574-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: be51da0f3e34 ("ieee802154: Stop using NLA_PUT*().")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 net/ieee802154/nl-phy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/nl-phy.c b/net/ieee802154/nl-phy.c
index 2cdc7e63fe17..88215b5c93aa 100644
--- a/net/ieee802154/nl-phy.c
+++ b/net/ieee802154/nl-phy.c
@@ -241,8 +241,10 @@ int ieee802154_add_iface(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (nla_put_string(msg, IEEE802154_ATTR_PHY_NAME, wpan_phy_name(phy)) ||
-	    nla_put_string(msg, IEEE802154_ATTR_DEV_NAME, dev->name))
+	    nla_put_string(msg, IEEE802154_ATTR_DEV_NAME, dev->name)) {
+		rc = -EMSGSIZE;
 		goto nla_put_failure;
+	}
 	dev_put(dev);
 
 	wpan_phy_put(phy);
-- 
2.25.1


