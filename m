Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04F02D1B7
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 00:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfE1WuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 18:50:16 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35126 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbfE1WuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 18:50:15 -0400
Received: by mail-wm1-f68.google.com with SMTP id w9so220686wmi.0
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 15:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RiDQ9CNES6CwCHlKok45HmAa5anJ9F0Gd3not8Fx9IM=;
        b=QcbFeV08Nq5pa9Wspsi0u4pCLE8Sq8xi3KHX5sBDkDJMRiIF7ep9SZgf443VTkRIZ0
         2eTDLbQ+3PXO4H+Zf+KZDBPP+BAJfFNdq7UJRFyhxdteREjiJ4BPmw4kbWy1wCybl+wl
         VKQrSM7hAGh7dE4zwxHvJY8mgwYxEYMrC42m/EgaHLEhsvgABxtMGu8Z5YZOPBo5vqwZ
         awbPYqWrQ5ubhAZxlPpOWCqMc62IoizCAT3pzQmeVF/oSmcEcESOpFbn7ncYPQULe+3T
         VjtlYLRyd/sK3GYyAm5RoXQZYwyM+HndRDVbFj1QSkztsz+80E6piGXMXv9r5ghBVGCJ
         WK+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RiDQ9CNES6CwCHlKok45HmAa5anJ9F0Gd3not8Fx9IM=;
        b=Sf6kwW3tNujzKn9/cSYiHAMdRKKdrW67GAbcAamQrQtj0r3pRXNbVX55LixK9g/cVb
         oS/FAHZWN6OAeQgZNPwy++EqeyfsNbW8ay3KR4GC/HhnQVc8FTb6ffCqYdtHMLnJdRzi
         Afbq+wUekDw/ozqMwJeO6JreFOBk+3WO+DlJpIse5Sm6WmfIoBiLWFxv3HeK/xHPTq8a
         /mIZ442P4tZ9oitxGg2EXkNM6JrRyaihnxjo1UJLLfO+aBbyzskKW0qGBG6EVejCVC6+
         eoQdrQcnjaBBhWfpFPk+X1QWRkwogPDXm/ZOTR+rp8JssSovSuOoGzcweJO+9ODm8XfW
         /1Jw==
X-Gm-Message-State: APjAAAWYCyHXVLCMpZdGa7DRf1pFp4xabqTKZx9iO0SCVZK0wqpuR9cC
        YMBj8djhbDpQ+1+QlZEuzzY=
X-Google-Smtp-Source: APXvYqx9Egs7JCLMj5HPW61fmnEQj+20h9EewM38zIVG20AXGuD2NXIIITzQK/Xc7henYvgvRwMb3A==
X-Received: by 2002:a7b:c549:: with SMTP id j9mr4427806wmk.122.1559083813418;
        Tue, 28 May 2019 15:50:13 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f2sm6623658wrq.48.2019.05.28.15.50.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 15:50:12 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     ioana.ciornei@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 1/2] net: dsa: tag_8021q: Change order of rx_vid setup
Date:   Wed, 29 May 2019 01:50:04 +0300
Message-Id: <20190528225005.10628-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528225005.10628-1-olteanv@gmail.com>
References: <20190528225005.10628-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The 802.1Q tagging performs an unbalanced setup in terms of RX VIDs on
the CPU port. For the ingress path of a 802.1Q switch to work, the RX
VID of a port needs to be seen as tagged egress on the CPU port.

While configuring the other front-panel ports to be part of this VID,
for bridge scenarios, the untagged flag is applied even on the CPU port
in dsa_switch_vlan_add.  This happens because DSA applies the same flags
on the CPU port as on the (bridge-controlled) slave ports, and the
effect in this case is that the CPU port tagged settings get deleted.

Instead of fixing DSA by introducing a way to control VLAN flags on the
CPU port (and hence stop inheriting from the slave ports) - a hard,
perhaps intractable problem - avoid this situation by moving the setup
part of the RX VID on the CPU port after all the other front-panel ports
have been added to the VID.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Fixes: f9bbe4477c30 ("net: dsa: Optional VLAN-based port separation for switches without tagging")
---
 net/dsa/tag_8021q.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 8ae48c7e1e76..4adec6bbfe59 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -128,10 +128,7 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 		u16 flags;
 
 		if (i == upstream)
-			/* CPU port needs to see this port's RX VID
-			 * as tagged egress.
-			 */
-			flags = 0;
+			continue;
 		else if (i == port)
 			/* The RX VID is pvid on this port */
 			flags = BRIDGE_VLAN_INFO_UNTAGGED |
@@ -150,6 +147,20 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 			return err;
 		}
 	}
+
+	/* CPU port needs to see this port's RX VID
+	 * as tagged egress.
+	 */
+	if (enabled)
+		err = dsa_port_vid_add(upstream_dp, rx_vid, 0);
+	else
+		err = dsa_port_vid_del(upstream_dp, rx_vid);
+	if (err) {
+		dev_err(ds->dev, "Failed to apply RX VID %d to port %d: %d\n",
+			rx_vid, port, err);
+		return err;
+	}
+
 	/* Finally apply the TX VID on this port and on the CPU port */
 	if (enabled)
 		err = dsa_port_vid_add(dp, tx_vid, BRIDGE_VLAN_INFO_UNTAGGED);
-- 
2.17.1

