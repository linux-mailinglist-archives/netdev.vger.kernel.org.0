Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CCA433C73
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 18:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234436AbhJSQiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234403AbhJSQiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 12:38:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75BB86103B;
        Tue, 19 Oct 2021 16:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634661368;
        bh=u1+B8sU0GaUIkTKzZls2pE1/mPX31F3xxYDjwuaflQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvwI25yMtBBlaAchW+bdIL1Tx07yYHgyNQaPgt+tHjt210FSKuq9QzTRRC1WyoRqI
         XngsmbrnO/VIJvQ5C+dGifxtbiG/3oSJJg0nlSrBtjerLBj74tG652V9UtuBCRngGS
         +HRVR8IETtpPtcnFMdRl8x4FcxnG/zrLUGmZI5rlmhFbiteWSHgT7r+Y8NBcd7oETN
         igsGkD7zAgr3zMK3qg9tCsA6QwpB18D6I1BQQpXJkvH1YoPvl28jF4jKL578/xNSXz
         ib/ANRcgM0U98oS1XGjNlhJrAOdiDCkBxqbWxcdAoEx9uUOhPdB53xxeldlD6XgeLJ
         LFUViE/+gl0XA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, alex.aring@gmail.com,
        stefan@datenfreihafen.org, linux-wpan@vger.kernel.org
Subject: [PATCH 2/2] mac802154: use dev_addr_set() - manual
Date:   Tue, 19 Oct 2021 09:36:06 -0700
Message-Id: <20211019163606.1385399-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019163606.1385399-1-kuba@kernel.org>
References: <20211019163606.1385399-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: alex.aring@gmail.com
CC: stefan@datenfreihafen.org
CC: linux-wpan@vger.kernel.org
---
 net/ieee802154/6lowpan/core.c |  2 +-
 net/mac802154/iface.c         | 15 ++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/ieee802154/6lowpan/core.c b/net/ieee802154/6lowpan/core.c
index 3297e7fa9945..2cf62718a282 100644
--- a/net/ieee802154/6lowpan/core.c
+++ b/net/ieee802154/6lowpan/core.c
@@ -157,7 +157,7 @@ static int lowpan_newlink(struct net *src_net, struct net_device *ldev,
 
 	lowpan_802154_dev(ldev)->wdev = wdev;
 	/* Set the lowpan hardware address to the wpan hardware address. */
-	memcpy(ldev->dev_addr, wdev->dev_addr, IEEE802154_ADDR_LEN);
+	__dev_addr_set(ldev, wdev->dev_addr, IEEE802154_ADDR_LEN);
 	/* We need headroom for possible wpan_dev_hard_header call and tailroom
 	 * for encryption/fcs handling. The lowpan interface will replace
 	 * the IPv6 header with 6LoWPAN header. At worst case the 6LoWPAN
diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 3210dec64a6a..500ed1b81250 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -136,8 +136,7 @@ static int mac802154_wpan_mac_addr(struct net_device *dev, void *p)
 	 * wpan mac has been changed
 	 */
 	if (sdata->wpan_dev.lowpan_dev)
-		memcpy(sdata->wpan_dev.lowpan_dev->dev_addr, dev->dev_addr,
-		       dev->addr_len);
+		dev_addr_set(sdata->wpan_dev.lowpan_dev, dev->dev_addr);
 
 	return mac802154_wpan_update_llsec(dev);
 }
@@ -615,6 +614,7 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
 		  unsigned char name_assign_type, enum nl802154_iftype type,
 		  __le64 extended_addr)
 {
+	u8 addr[IEEE802154_EXTENDED_ADDR_LEN];
 	struct net_device *ndev = NULL;
 	struct ieee802154_sub_if_data *sdata = NULL;
 	int ret;
@@ -638,11 +638,12 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
 	switch (type) {
 	case NL802154_IFTYPE_NODE:
 		ndev->type = ARPHRD_IEEE802154;
-		if (ieee802154_is_valid_extended_unicast_addr(extended_addr))
-			ieee802154_le64_to_be64(ndev->dev_addr, &extended_addr);
-		else
-			memcpy(ndev->dev_addr, ndev->perm_addr,
-			       IEEE802154_EXTENDED_ADDR_LEN);
+		if (ieee802154_is_valid_extended_unicast_addr(extended_addr)) {
+			ieee802154_le64_to_be64(addr, &extended_addr);
+			dev_addr_set(ndev, addr);
+		} else {
+			dev_addr_set(ndev, ndev->perm_addr);
+		}
 		break;
 	case NL802154_IFTYPE_MONITOR:
 		ndev->type = ARPHRD_IEEE802154_MONITOR;
-- 
2.31.1

