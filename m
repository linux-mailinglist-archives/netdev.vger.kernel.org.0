Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB6F128FBA
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 20:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfLVTYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 14:24:10 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57406 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfLVTYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 14:24:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6+6J3+B/Jx7rdoqQ2fv78x9vcCXRCksOMmR3w4+/bVs=; b=t0Dbgtu56OjpR4/ILOZiHgSa1m
        fbFg37vvgego/rtcRpWzwQVjFhVEIHE7qq9rX5rY//8nX2Zj10kqRrl9lnaovCPxYP1krb7NuyjLO
        KqfZ5a1QI9A6RFWOgidVq/Qfag6IdzrDlEfJeEcwjg4MKQVzmOml1p2DoG6qXXh65zik0xturO0iW
        dFgWLMqZuTD0Xb7ATVLZyQ2Z6d1FQI69gOKT2VRy0D8fcX0ZbvoaHd5469Ttkey2mBaV2HJqAQzOK
        +8jMMsNxOHsjyrOUCVex/5RJ126sfnzKeHJ5X3Kel+ShatlmSHRn+KOPbsvh4CMQkkdhaXp8kFFVZ
        NvzzAcvQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39522 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ij6ph-0005qw-0X; Sun, 22 Dec 2019 19:24:05 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ij6pf-00083v-Sl; Sun, 22 Dec 2019 19:24:03 +0000
In-Reply-To: <20191222192235.GK25745@shell.armlinux.org.uk>
References: <20191222192235.GK25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC 1/3] net: switchdev: do not propagate bridge updates across
 bridges
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ij6pf-00083v-Sl@rmk-PC.armlinux.org.uk>
Date:   Sun, 22 Dec 2019 19:24:03 +0000
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

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 net/switchdev/switchdev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 3a1d428c1336..d881e5e4a889 100644
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

