Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E02E3BCDC2
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbhGFLXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:23:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233497AbhGFLVM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:21:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7E7C61CEE;
        Tue,  6 Jul 2021 11:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570263;
        bh=ejeh7x8VILLkzHwcfeY8ejdBP6rp3we5gnnFdnNnW5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIUGZx2eU8KfHsm8McHWsIeWnaTGKJlE0fWt74V/Gnofg7YEIZZYzzqL+fEItE6Zr
         8KDSyWt4tojExI5vwhgYqMKDUT5zIkI2QEQiQ86THHEmUL+HYHHr5TAkNx+PoWjfhg
         RPljbDCqLFkOASlOyaLrsuOgZpFnznlwZejy6uDVnG0tT/gLVUDOahhAE+T3C2Vz+s
         aUniYmeIBeQFG+UX+05UDUIBWH/jlt20axziD7Z5sK1JLeHNmLXH7d5iBF+6brrdCL
         xMOIf51U3trIZtZfSoojZroUS9wDhbxxdgORnbYElzVNfr2sP35QfcgOvK8/PYqDnQ
         Jl5K673wUKl/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 159/189] net: dsa: b53: Create default VLAN entry explicitly
Date:   Tue,  6 Jul 2021 07:13:39 -0400
Message-Id: <20210706111409.2058071-159-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 64a81b24487f0d2fba0f033029eec2abc7d82cee ]

In case CONFIG_VLAN_8021Q is not set, there will be no call down to the
b53 driver to ensure that the default PVID VLAN entry will be configured
with the appropriate untagged attribute towards the CPU port. We were
implicitly relying on dsa_slave_vlan_rx_add_vid() to do that for us,
instead make it explicit.

Reported-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 3ca6b394dd5f..67a7de87c17a 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -728,6 +728,13 @@ static u16 b53_default_pvid(struct b53_device *dev)
 		return 0;
 }
 
+static bool b53_vlan_port_needs_forced_tagged(struct dsa_switch *ds, int port)
+{
+	struct b53_device *dev = ds->priv;
+
+	return dev->tag_protocol == DSA_TAG_PROTO_NONE && dsa_is_cpu_port(ds, port);
+}
+
 int b53_configure_vlan(struct dsa_switch *ds)
 {
 	struct b53_device *dev = ds->priv;
@@ -748,9 +755,20 @@ int b53_configure_vlan(struct dsa_switch *ds)
 
 	b53_enable_vlan(dev, -1, dev->vlan_enabled, ds->vlan_filtering);
 
-	b53_for_each_port(dev, i)
+	/* Create an untagged VLAN entry for the default PVID in case
+	 * CONFIG_VLAN_8021Q is disabled and there are no calls to
+	 * dsa_slave_vlan_rx_add_vid() to create the default VLAN
+	 * entry. Do this only when the tagging protocol is not
+	 * DSA_TAG_PROTO_NONE
+	 */
+	b53_for_each_port(dev, i) {
+		v = &dev->vlans[def_vid];
+		v->members |= BIT(i);
+		if (!b53_vlan_port_needs_forced_tagged(ds, i))
+			v->untag = v->members;
 		b53_write16(dev, B53_VLAN_PAGE,
 			    B53_VLAN_PORT_DEF_TAG(i), def_vid);
+	}
 
 	/* Upon initial call we have not set-up any VLANs, but upon
 	 * system resume, we need to restore all VLAN entries.
-- 
2.30.2

