Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC0EE5E60
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 20:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfJZSEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 14:04:53 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38361 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfJZSEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 14:04:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id v9so5733604wrq.5
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 11:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=whkw5x/JtRJM3k8pxfegTmKu9Rs1cKtS8RnzmnISQvg=;
        b=hDu8wjg+tut4k4rgAwGpMlGd+0Jq1SD/g6ZLukRDa9Q5IUXF42dKXRfnTlJplZbIUU
         ESTgE6903LRMFikBSppl5RvDX8wZcBZGqUvyEg44+BvdrgIC4VfXP6YEr/0miryVZhVR
         KwyT6Ia58vNuwTPdjrmaybyHu8PMJd5QQcpp4fJuwasXM+YCYbptSJJSBUsPWFbQLD0x
         PAyf3qBkbb0V9bcxREmDRtQnXnqUv+y98cR0xgC469+9wAifcN3AV4lDj3O6fLbAYuZy
         9yPxMeOK8+v4K6aaRrWrzoCuQEzGDZyhECMl1gd71UoKqRXt+z/6VUAxxAT/SUZYVWEG
         VGfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=whkw5x/JtRJM3k8pxfegTmKu9Rs1cKtS8RnzmnISQvg=;
        b=Uv7vcDWNBSiCdXjhTTD+7pAYSvCrY0KkP3i+sZPSZtNs/BQRSzmQxn5ml96p0X83xx
         8StwdG0ZTfu1CDAzsiYUSv/W0y8FmfKfHVwpiWoBf5P4c72gzP5viuAwFpJaUt35A22Y
         mbKe2Y3vozBLnoGyRN3zMcJJ/RN/AAuX2iV/CazQQ/dKACOF8NjIOKwMl7Jy6oOVjjdh
         w89iT/2gIBaRCYG4MtSp1sXFMRaP90395BZy0hWehNzWApXIMdB3wz07C4yTZvDQPEG3
         /dJLcHuJ4r69ceQyjqxGmC+MMftJS6TRUdhoiLqDuDZ3K+WeSsIs/71btcBCUAWvMhZd
         05sA==
X-Gm-Message-State: APjAAAWhJHjw+47WUhFh712aSvTB8UIp2YuOUCqBJqx/IgJd2bUlqtVZ
        TQbW8aIy7fyv6DriT6sIFvQ=
X-Google-Smtp-Source: APXvYqxYKNKnPl+k/vyYKayfROEA9ZzqBiwjfcUO3k+XS6qNEmp3KdEJKNfFynceb3WAKEEgw+nCMw==
X-Received: by 2002:a5d:6892:: with SMTP id h18mr7707539wru.370.1572113089953;
        Sat, 26 Oct 2019 11:04:49 -0700 (PDT)
Received: from localhost.localdomain ([188.25.218.57])
        by smtp.gmail.com with ESMTPSA id 1sm5568036wrr.16.2019.10.26.11.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2019 11:04:49 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 1/2] net: mscc: ocelot: fix vlan_filtering when enslaving to bridge before link is up
Date:   Sat, 26 Oct 2019 21:04:26 +0300
Message-Id: <20191026180427.14039-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191026180427.14039-1-olteanv@gmail.com>
References: <20191026180427.14039-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Background information: the driver operates the hardware in a mode where
a single VLAN can be transmitted as untagged on a particular egress
port. That is the "native VLAN on trunk port" use case. Its value is
held in port->vid.

Consider the following command sequence (no network manager, all
interfaces are down, debugging prints added by me):

$ ip link add dev br0 type bridge vlan_filtering 1
$ ip link set dev swp0 master br0

Kernel code path during last command:

br_add_slave -> ocelot_netdevice_port_event (NETDEV_CHANGEUPPER):
[   21.401901] ocelot_vlan_port_apply: port 0 vlan aware 0 pvid 0 vid 0

br_add_slave -> nbp_vlan_init -> switchdev_port_attr_set -> ocelot_port_attr_set (SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING):
[   21.413335] ocelot_vlan_port_apply: port 0 vlan aware 1 pvid 0 vid 0

br_add_slave -> nbp_vlan_init -> nbp_vlan_add -> br_switchdev_port_vlan_add -> switchdev_port_obj_add -> ocelot_port_obj_add -> ocelot_vlan_vid_add
[   21.667421] ocelot_vlan_port_apply: port 0 vlan aware 1 pvid 1 vid 1

So far so good. The bridge has replaced the driver's default pvid used
in standalone mode (0) with its own default_pvid (1). The port's vid
(native VLAN) has also changed from 0 to 1.

$ ip link set dev swp0 up

[   31.722956] 8021q: adding VLAN 0 to HW filter on device swp0
do_setlink -> dev_change_flags -> vlan_vid_add -> ocelot_vlan_rx_add_vid -> ocelot_vlan_vid_add:
[   31.728700] ocelot_vlan_port_apply: port 0 vlan aware 1 pvid 1 vid 0

The 8021q module uses the .ndo_vlan_rx_add_vid API on .ndo_open to make
ports be able to transmit and receive 802.1p-tagged traffic by default.
This API is supposed to offload a VLAN sub-interface, which for a switch
port means to add a VLAN that is not a pvid, and tagged on egress.

But the driver implementation of .ndo_vlan_rx_add_vid is wrong: it adds
back vid 0 as "egress untagged". Now back to the initial paragraph:
there is a single untagged VID that the driver keeps track of, and that
has just changed from 1 (the pvid) to 0. So this breaks the bridge
core's expectation, because it has changed vid 1 from untagged to
tagged, when what the user sees is.

$ bridge vlan
port    vlan ids
swp0     1 PVID Egress Untagged

br0      1 PVID Egress Untagged

But curiously, instead of manifesting itself as "untagged and
pvid-tagged traffic gets sent as tagged on egress", the bug:

- is hidden when vlan_filtering=0
- manifests as dropped traffic when vlan_filtering=1, due to this setting:

	if (port->vlan_aware && !port->vid)
		/* If port is vlan-aware and tagged, drop untagged and priority
		 * tagged frames.
		 */
		val |= ANA_PORT_DROP_CFG_DROP_UNTAGGED_ENA |
		       ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
		       ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA;

which would have made sense if it weren't for this bug. The setting's
intention was "this is a trunk port with no native VLAN, so don't accept
untagged traffic". So the driver was never expecting to set VLAN 0 as
the value of the native VLAN, 0 was just encoding for "invalid".

So the fix is to not send 802.1p traffic as untagged, because that would
change the port's native vlan to 0, unbeknownst to the bridge, and
trigger unexpected code paths in the driver.

Cc: Antoine Tenart <antoine.tenart@bootlin.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Fixes: 7142529f1688 ("net: mscc: ocelot: add VLAN filtering")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7190fe4c1095..552252331e55 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -915,7 +915,7 @@ static int ocelot_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 static int ocelot_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 				  u16 vid)
 {
-	return ocelot_vlan_vid_add(dev, vid, false, true);
+	return ocelot_vlan_vid_add(dev, vid, false, false);
 }
 
 static int ocelot_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
-- 
2.17.1

