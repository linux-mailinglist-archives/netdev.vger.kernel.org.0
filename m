Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA781705A3
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgBZRKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:10:17 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:51104 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727905AbgBZRKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:10:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0jxy9TfUv53+AvFcjEpwQifXuWJDhaRpG+8gw6vOwbg=; b=n4msS2PnAJyv2/YHYJpJXQJu/l
        pN2td4e5XV+iKLouDIO9OBVk1NceI541lQvUZ/SYPeQxl7ZHVUiXycHQD0KD2EHOoqeB50gOCrOsI
        FqvXAEM4W2i/IMoQa1z96OMRBYvq1V2qY+/73aCFyQlFB3ShbsE+CJFXGX5hxrDtFKhmWIFstTOKR
        lxYHALvFraq5RZ8oOW1rfJjUQ2LKXWPOMzjLdFUP3FOMC3W3a//O22XmxoNBhmBBR2Osp9BAZZ/nP
        AM7LG+8NyNA94rktXnPgOOEXqfKfWDLcwE1IzDijZPd2TBDeE9F7cR7U/u8ouD6z7k0+KSucS8uHa
        gNg2pMPA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:34060 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j70CJ-0000NW-0y; Wed, 26 Feb 2020 17:10:11 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j70CI-0004Hs-Be; Wed, 26 Feb 2020 17:10:10 +0000
In-Reply-To: <20200226170847.GB25745@shell.armlinux.org.uk>
References: <20200226170847.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/2] net: switchdev: do not propagate bridge
 updates across bridges
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j70CI-0004Hs-Be@rmk-PC.armlinux.org.uk>
Date:   Wed, 26 Feb 2020 17:10:10 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When configuring a tree of independent bridges, propagating changes
from the upper bridge across a bridge master to the lower bridge
ports brings surprises.

For example, a lower bridge may have vlan filtering enabled.  It
may have a vlan interface attached to the bridge master, which may
then be incorporated into another bridge.  As soon as the lower
bridge vlan interface is attached to the upper bridge, the lower
bridge has vlan filtering disabled.

This occurs because switchdev recursively applies its changes to
all lower devices no matter what.

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Tested-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 net/switchdev/switchdev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 60630762a748..f25604d68337 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -475,6 +475,9 @@ static int __switchdev_handle_port_obj_add(struct net_device *dev,
 	 * necessary to go through this helper.
 	 */
 	netdev_for_each_lower_dev(dev, lower_dev, iter) {
+		if (netif_is_bridge_master(lower_dev))
+			continue;
+
 		err = __switchdev_handle_port_obj_add(lower_dev, port_obj_info,
 						      check_cb, add_cb);
 		if (err && err != -EOPNOTSUPP)
@@ -526,6 +529,9 @@ static int __switchdev_handle_port_obj_del(struct net_device *dev,
 	 * necessary to go through this helper.
 	 */
 	netdev_for_each_lower_dev(dev, lower_dev, iter) {
+		if (netif_is_bridge_master(lower_dev))
+			continue;
+
 		err = __switchdev_handle_port_obj_del(lower_dev, port_obj_info,
 						      check_cb, del_cb);
 		if (err && err != -EOPNOTSUPP)
@@ -576,6 +582,9 @@ static int __switchdev_handle_port_attr_set(struct net_device *dev,
 	 * necessary to go through this helper.
 	 */
 	netdev_for_each_lower_dev(dev, lower_dev, iter) {
+		if (netif_is_bridge_master(lower_dev))
+			continue;
+
 		err = __switchdev_handle_port_attr_set(lower_dev, port_attr_info,
 						       check_cb, set_cb);
 		if (err && err != -EOPNOTSUPP)
-- 
2.20.1

