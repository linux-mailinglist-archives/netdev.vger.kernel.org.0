Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E749520F
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 02:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbfHTAAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 20:00:17 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53381 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728770AbfHTAAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 20:00:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id 10so1020459wmp.3
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 17:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=g9/Dv36uTpAz2reRjbFrFDGlDtx2bn02uDtVR7AiqFM=;
        b=bcbX+xSQ/Q5p9/bfLFzveQuDclfZCpCYXFLyRFxTTlh94m1AbVs86OGoH4v/NPQ2p5
         /EJ9wxZ19y8X1MzgcpzT6r+ZDr99ILD0AUzNxZRTD0LdJ6gj9odo5ixxkvDkFH9ObJko
         wgionIpXpNZ1zU4TWPVPqVIaUt5nDfotWeva7FxnYUZpRP0WLelgMre4wtIVf7j7DQWb
         2dgNfH/GdSX1kP3X38kz3//ExeTlRO1gA2pKe7oMAFGKzstlCt5iJTgvDkXVAOJblnRK
         6OHYFfO5wz9qpevszfMqKXSv1fbovDQbb16fLGcIbl2MJyF84buQFOGbx3xeuexEbnEV
         b9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=g9/Dv36uTpAz2reRjbFrFDGlDtx2bn02uDtVR7AiqFM=;
        b=qroV7LVCQcnO3+sq4Q0TsUgTjV7YGhdMENe1JayiHjpUoTGn00jGmYIH8LRubolUBd
         lUJiqWYGaALs+qN+F4hwdiGwaPMY4+aLnNn1Fznb+NnACjOKPmysrdMh735n+OtrSlHk
         5dCnl6dZH+1eoxm17hdrqK5egGH+ZSd+vSuZr1gF1jkn6WjOEILjDcsx6T3T3jKvPRqn
         oBGPCpbC9LcPA0GEkaGY6ioeoynJcq/qAk/PlkC7y98UmQDdskX+a/hBMhlSQYfPn/QS
         dJwKvNlRGYa116MvoaX/0o9fnkTnPvNQ9UagwUcfHO5Lr/Pvg2LK/hXOJbBaqs1NJIfL
         LR/g==
X-Gm-Message-State: APjAAAUnQGBkVgeEEGVSc9akH0xamavrlvA6kwzaehTExY1V7HrM5nYm
        zlv+ziLRY+lQA7cMnvh1PKc=
X-Google-Smtp-Source: APXvYqz8UFtgf11NbJlMFSFxLNBmQfkSkn6sVvLlXQdozmb6Yg57F0kxe+A14FeU7MX7NsJJBvlebA==
X-Received: by 2002:a1c:721a:: with SMTP id n26mr21896123wmc.88.1566259212625;
        Mon, 19 Aug 2019 17:00:12 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id c9sm3814064wrv.40.2019.08.19.17.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 17:00:12 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 5/6] net: dsa: Allow proper internal use of VLANs
Date:   Tue, 20 Aug 2019 03:00:01 +0300
Message-Id: <20190820000002.9776-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190820000002.9776-1-olteanv@gmail.com>
References: <20190820000002.9776-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Below commit:

commit 2ea7a679ca2abd251c1ec03f20508619707e1749
Author: Andrew Lunn <andrew@lunn.ch>
Date:   Tue Nov 7 00:04:24 2017 +0100

    net: dsa: Don't add vlans when vlan filtering is disabled

    The software bridge can be build with vlan filtering support
    included. However, by default it is turned off. In its turned off
    state, it still passes VLANs via switchev, even though they are not to
    be used. Don't pass these VLANs to the hardware. Only do so when vlan
    filtering is enabled.

    This fixes at least one corner case. There are still issues in other
    corners, such as when vlan_filtering is later enabled.

    Signed-off-by: Andrew Lunn <andrew@lunn.ch>
    Signed-off-by: David S. Miller <davem@davemloft.net>

stubs out SWITCHDEV_OBJ_ID_PORT_VLAN objects notified by the bridge core
to DSA drivers when vlan_filtering is 0.

This is generally a good thing, because it allows dsa_8021q to make
private use of VLANs in that mode.

So it makes sense to move the check for the bridge presence and
vlan_filtering setting one layer above. We don't want calls from
dsa_8021q to be prevented by this, only from the bridge core.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/port.c  | 10 ++--------
 net/dsa/slave.c |  8 ++++++++
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index f75301456430..c1cc41c1eeb6 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -348,10 +348,7 @@ int dsa_port_vlan_add(struct dsa_port *dp,
 		.vlan = vlan,
 	};
 
-	if (!dp->bridge_dev || br_vlan_enabled(dp->bridge_dev))
-		return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_ADD, &info);
-
-	return 0;
+	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_ADD, &info);
 }
 
 int dsa_port_vlan_del(struct dsa_port *dp,
@@ -363,10 +360,7 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 		.vlan = vlan,
 	};
 
-	if (!dp->bridge_dev || br_vlan_enabled(dp->bridge_dev))
-		return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
-
-	return 0;
+	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
 }
 
 int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 33f41178afcc..6a02eb8988d1 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -341,6 +341,8 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		if (obj->orig_dev != dev)
 			return -EOPNOTSUPP;
+		if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+			return 0;
 		err = dsa_port_vlan_add(dp, SWITCHDEV_OBJ_PORT_VLAN(obj),
 					trans);
 		break;
@@ -373,6 +375,8 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		if (obj->orig_dev != dev)
 			return -EOPNOTSUPP;
+		if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+			return 0;
 		err = dsa_port_vlan_del(dp, SWITCHDEV_OBJ_PORT_VLAN(obj));
 		break;
 	default:
@@ -1073,6 +1077,8 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
+		if (!br_vlan_enabled(dp->bridge_dev))
+			return 0;
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
 		 * device, respectively the VID is not found, returning
 		 * 0 means success, which is a failure for us here.
@@ -1097,6 +1103,8 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
+		if (!br_vlan_enabled(dp->bridge_dev))
+			return 0;
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
 		 * device, respectively the VID is not found, returning
 		 * 0 means success, which is a failure for us here.
-- 
2.17.1

