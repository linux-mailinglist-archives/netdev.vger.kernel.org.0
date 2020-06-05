Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF0B1EF7DC
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 14:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgFEMZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 08:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726753AbgFEMZb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 08:25:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 964A3207D0;
        Fri,  5 Jun 2020 12:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591359930;
        bh=XSED5VucqbaIM9KAXQKYBziYyqoyqr+tNkKG5o4T0yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=To0fcKyoFzQ1W0f4gED+kaquygOKLRayC0HmKGL8ZaBvR98LKq27l97RPoKdRWsBl
         1gEUGv7DRnEtAmD22lVD3V4nVUmdNIGMJ6AEv6M0PXzQZZELK1NI18+/kmNJxtOK7D
         FfHZ9MaqUZVgOcBTYPoNFgyz8RBc2EKIQ0MAIx1Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 10/17] net: dsa: felix: send VLANs on CPU port as egress-tagged
Date:   Fri,  5 Jun 2020 08:25:09 -0400
Message-Id: <20200605122517.2882338-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200605122517.2882338-1-sashal@kernel.org>
References: <20200605122517.2882338-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 183be6f967fe37c3154bfac39e913c3bafe89d1b ]

As explained in other commits before (b9cd75e66895 and 87b0f983f66f),
ocelot switches have a single egress-untagged VLAN per port, and the
driver would deny adding a second one while an egress-untagged VLAN
already exists.

But on the CPU port (where the VLAN configuration is implicit, because
there is no net device for the bridge to control), the DSA core attempts
to add a VLAN using the same flags as were used for the front-panel
port. This would make adding any untagged VLAN fail due to the CPU port
rejecting the configuration:

bridge vlan add dev swp0 vid 100 pvid untagged
[ 1865.854253] mscc_felix 0000:00:00.5: Port already has a native VLAN: 1
[ 1865.860824] mscc_felix 0000:00:00.5: Failed to add VLAN 100 to port 5: -16

(note that port 5 is the CPU port and not the front-panel swp0).

So this hardware will send all VLANs as tagged towards the CPU.

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index b74580e87be8..5d9db8d042c1 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -100,13 +100,17 @@ static void felix_vlan_add(struct dsa_switch *ds, int port,
 			   const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ocelot *ocelot = ds->priv;
+	u16 flags = vlan->flags;
 	u16 vid;
 	int err;
 
+	if (dsa_is_cpu_port(ds, port))
+		flags &= ~BRIDGE_VLAN_INFO_UNTAGGED;
+
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		err = ocelot_vlan_add(ocelot, port, vid,
-				      vlan->flags & BRIDGE_VLAN_INFO_PVID,
-				      vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED);
+				      flags & BRIDGE_VLAN_INFO_PVID,
+				      flags & BRIDGE_VLAN_INFO_UNTAGGED);
 		if (err) {
 			dev_err(ds->dev, "Failed to add VLAN %d to port %d: %d\n",
 				vid, port, err);
-- 
2.25.1

