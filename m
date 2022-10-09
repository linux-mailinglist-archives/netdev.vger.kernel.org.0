Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9205F908F
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbiJIW0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiJIWYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:24:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3C53C8F3;
        Sun,  9 Oct 2022 15:18:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97FF4B80DF6;
        Sun,  9 Oct 2022 22:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ED1C43470;
        Sun,  9 Oct 2022 22:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353745;
        bh=sOJf2HMfcZ1hjIAO+qoNr5T6ovrDWP07KCEdymXI3QQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JC9haYZEUk1xW5ACEVnafhbR71Uc03iZtGuVGBg+oyX4YDt1DGa0te5jh9LGUTYEB
         r+Cy44CgmCXAYoeUurGjDKii6IAiAZsuj2/Z3dLibC+ugk1p7IKqhw2V5gFI/HwqeM
         cl/CcavewRS4oQqH3YVlAxuNuucsg7MTusruQccq7yCg7+VPsbRyFW2EmaK632234x
         5lt893BE7XrwGYR5CTtO3cQe/Xi8ZwYgLCdZkLHYtyjq87rYRyE/YNZIstJdAj4HZJ
         s5i7gtw5DoAjvGgAilmE5ZpEYr0BQcSQmvv03dea+AorCV7TTT1DDA0zM7nyIrabGF
         uTVDQCHeG2/5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 11/73] net: mscc: ocelot: adjust forwarding domain for CPU ports in a LAG
Date:   Sun,  9 Oct 2022 18:13:49 -0400
Message-Id: <20221009221453.1216158-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 291ac1517af58670740528466ccebe3caefb9093 ]

Currently when we have 2 CPU ports configured for DSA tag_8021q mode and
we put them in a LAG, a PGID dump looks like this:

PGID_SRC[0] = ports 4,
PGID_SRC[1] = ports 4,
PGID_SRC[2] = ports 4,
PGID_SRC[3] = ports 4,
PGID_SRC[4] = ports 0, 1, 2, 3, 4, 5,
PGID_SRC[5] = no ports

(ports 0-3 are user ports, ports 4 and 5 are CPU ports)

There are 2 problems with the configuration above:

- user ports should enable forwarding towards both CPU ports, not just 4,
  and the aggregation PGIDs should prune one CPU port or the other from
  the destination port mask, based on a hash computed from packet headers.

- CPU ports should not be allowed to forward towards themselves and also
  not towards other ports in the same LAG as themselves

The first problem requires fixing up the PGID_SRC of user ports, when
ocelot_port_assigned_dsa_8021q_cpu_mask() is called. We need to say that
when a user port is assigned to a tag_8021q CPU port and that port is in
a LAG, it should forward towards all ports in that LAG.

The second problem requires fixing up the PGID_SRC of port 4, to remove
ports 4 and 5 (in a LAG) from the allowed destinations.

After this change, the PGID source masks look as follows:

PGID_SRC[0] = ports 4, 5,
PGID_SRC[1] = ports 4, 5,
PGID_SRC[2] = ports 4, 5,
PGID_SRC[3] = ports 4, 5,
PGID_SRC[4] = ports 0, 1, 2, 3,
PGID_SRC[5] = no ports

Note that PGID_SRC[5] still looks weird (it should say "0, 1, 2, 3" just
like PGID_SRC[4] does), but I've tested forwarding through this CPU port
and it doesn't seem like anything is affected (it appears that PGID_SRC[4]
is being looked up on forwarding from the CPU, since both ports 4 and 5
have logical port ID 4). The reason why it looks weird is because
we've never called ocelot_port_assign_dsa_8021q_cpu() for any user port
towards port 5 (all user ports are assigned to port 4 which is in a LAG
with 5).

Since things aren't broken, I'm willing to leave it like that for now
and just document the oddity.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 68991b021c56..f6ec299a2b5a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2065,6 +2065,16 @@ static int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond)
 	return __ffs(bond_mask);
 }
 
+/* Returns the mask of user ports assigned to this DSA tag_8021q CPU port.
+ * Note that when CPU ports are in a LAG, the user ports are assigned to the
+ * 'primary' CPU port, the one whose physical port number gives the logical
+ * port number of the LAG.
+ *
+ * We leave PGID_SRC poorly configured for the 'secondary' CPU port in the LAG
+ * (to which no user port is assigned), but it appears that forwarding from
+ * this secondary CPU port looks at the PGID_SRC associated with the logical
+ * port ID that it's assigned to, which *is* configured properly.
+ */
 static u32 ocelot_dsa_8021q_cpu_assigned_ports(struct ocelot *ocelot,
 					       struct ocelot_port *cpu)
 {
@@ -2081,9 +2091,15 @@ static u32 ocelot_dsa_8021q_cpu_assigned_ports(struct ocelot *ocelot,
 			mask |= BIT(port);
 	}
 
+	if (cpu->bond)
+		mask &= ~ocelot_get_bond_mask(ocelot, cpu->bond);
+
 	return mask;
 }
 
+/* Returns the DSA tag_8021q CPU port that the given port is assigned to,
+ * or the bit mask of CPU ports if said CPU port is in a LAG.
+ */
 u32 ocelot_port_assigned_dsa_8021q_cpu_mask(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -2092,6 +2108,9 @@ u32 ocelot_port_assigned_dsa_8021q_cpu_mask(struct ocelot *ocelot, int port)
 	if (!cpu_port)
 		return 0;
 
+	if (cpu_port->bond)
+		return ocelot_get_bond_mask(ocelot, cpu_port->bond);
+
 	return BIT(cpu_port->index);
 }
 EXPORT_SYMBOL_GPL(ocelot_port_assigned_dsa_8021q_cpu_mask);
-- 
2.35.1

