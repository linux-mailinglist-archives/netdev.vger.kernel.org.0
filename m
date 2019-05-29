Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 537D52DEE1
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 15:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfE2Nvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 09:51:31 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40364 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfE2Nva (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 09:51:30 -0400
Received: from localhost ([::1]:53454 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hVyzI-0007XD-0u; Wed, 29 May 2019 15:51:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [net-next PATCH] net: rtnetlink: Enslave device before bringing it up
Date:   Wed, 29 May 2019 15:51:20 +0200
Message-Id: <20190529135120.32241-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike with bridges, one can't add an interface to a bond and set it up
at the same time:

| # ip link set dummy0 down
| # ip link set dummy0 master bond0 up
| Error: Device can not be enslaved while up.

Of all drivers with ndo_add_slave callback, bond and team decline if
IFF_UP flag is set, vrf cycles the interface (i.e., sets it down and
immediately up again) and the others just don't care.

Support the common notion of setting the interface up after enslaving it
by sorting the operations accordingly.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/core/rtnetlink.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index adcc045952c2f..d81acace02ce5 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2488,13 +2488,6 @@ static int do_setlink(const struct sk_buff *skb,
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
 	}
 
-	if (ifm->ifi_flags || ifm->ifi_change) {
-		err = dev_change_flags(dev, rtnl_dev_combine_flags(dev, ifm),
-				       extack);
-		if (err < 0)
-			goto errout;
-	}
-
 	if (tb[IFLA_MASTER]) {
 		err = do_set_master(dev, nla_get_u32(tb[IFLA_MASTER]), extack);
 		if (err)
@@ -2502,6 +2495,13 @@ static int do_setlink(const struct sk_buff *skb,
 		status |= DO_SETLINK_MODIFIED;
 	}
 
+	if (ifm->ifi_flags || ifm->ifi_change) {
+		err = dev_change_flags(dev, rtnl_dev_combine_flags(dev, ifm),
+				       extack);
+		if (err < 0)
+			goto errout;
+	}
+
 	if (tb[IFLA_CARRIER]) {
 		err = dev_change_carrier(dev, nla_get_u8(tb[IFLA_CARRIER]));
 		if (err)
-- 
2.21.0

