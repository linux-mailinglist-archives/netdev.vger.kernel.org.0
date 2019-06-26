Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 130F8564C8
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 10:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfFZIoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 04:44:16 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:56683 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfFZIoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 04:44:15 -0400
X-Originating-IP: 86.250.200.211
Received: from mc-bl-xps13.lan (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 973EFC000C;
        Wed, 26 Jun 2019 08:44:07 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com
Subject: [PATCH net-next] net: ethtool: Allow parsing ETHER_FLOW types when using flow_rule
Date:   Wed, 26 Jun 2019 10:44:03 +0200
Message-Id: <20190626084403.17749-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When parsing an ethtool_rx_flow_spec, users can specify an ethernet flow
which could contain matches based on the ethernet header, such as the
MAC address, the VLAN tag or the ethertype.

Only the ethtype field is specific to the ether flow, the MAC and vlan
fields are processed using the special FLOW_EXT and FLOW_MAC_EXT flags.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 net/core/ethtool.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 4d1011b2e24f..01ceba556341 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -2883,6 +2883,18 @@ ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
 	match->mask.basic.n_proto = htons(0xffff);
 
 	switch (fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS)) {
+	case ETHER_FLOW: {
+		const struct ethhdr *ether_spec, *ether_m_spec;
+
+		ether_spec = &fs->h_u.ether_spec;
+		ether_m_spec = &fs->m_u.ether_spec;
+
+		if (ether_m_spec->h_proto) {
+			match->key.basic.n_proto = ether_spec->h_proto;
+			match->mask.basic.n_proto = ether_m_spec->h_proto;
+		}
+		}
+		break;
 	case TCP_V4_FLOW:
 	case UDP_V4_FLOW: {
 		const struct ethtool_tcpip4_spec *v4_spec, *v4_m_spec;
-- 
2.20.1

