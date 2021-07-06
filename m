Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D986A3BCFEC
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbhGFLbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235566AbhGFLaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A103C61D98;
        Tue,  6 Jul 2021 11:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570483;
        bh=L8jub376s6xaAsAzk1kQdZw4+cPvBHdSUCWHrjUgamA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4/jHwUF613HIA7FrV9MakOD929V5MhCAk2hEzIq3+zG41ibeeJJBspwtAZQS+2p6
         pzjITs80WMzf3ILnEzJe1LdEjNLfQQDOjYp+WqSme5rtCuHgyuaovN5TkgaC89b6wb
         12kW3WxBL4u936hipinDueR7qHIkb2cTS/QRFbmGAwHOlODMCmxRCa+XGnzWJ60a+H
         5khoeVOHmzQLMxF+8VqzUUUdWo+YAcnAArPgQj/oTPkEgCKH8jQYzBANaEJR2LrGxY
         +vKDYgEfcOcnbvVOnbowWNXEJ2YYNveOFSvOHdAR5prdB7IOM1TEPXMxnih4OHktvf
         8ZAgpEG2giyTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 131/160] net: dsa: b53: Create default VLAN entry explicitly
Date:   Tue,  6 Jul 2021 07:17:57 -0400
Message-Id: <20210706111827.2060499-131-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index eb443721c58e..dee314245fb1 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -725,6 +725,13 @@ static u16 b53_default_pvid(struct b53_device *dev)
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
@@ -745,9 +752,20 @@ int b53_configure_vlan(struct dsa_switch *ds)
 
 	b53_enable_vlan(dev, dev->vlan_enabled, ds->vlan_filtering);
 
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

