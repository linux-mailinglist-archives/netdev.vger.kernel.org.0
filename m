Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA7763D187
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391796AbfFKPzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:55:36 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48875 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388958AbfFKPzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:55:36 -0400
X-Originating-IP: 90.88.159.246
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 6B74B60016;
        Tue, 11 Jun 2019 15:55:29 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net] net: ethtool: Allow matching on vlan CFI bit
Date:   Tue, 11 Jun 2019 17:54:56 +0200
Message-Id: <20190611155456.15360-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using ethtool, users can specify a classification action matching on the
full vlan tag, which includes the CFI bit.

However, when converting the ethool_flow_spec to a flow_rule, we use
dissector keys to represent the matching patterns.

Since the vlan dissector key doesn't include the CFI bit, this
information was silently discarded when translating the ethtool
flow spec in to a flow_rule.

This commit adds the CFI bit into the vlan dissector key, and allows
propagating the information to the driver when parsing the ethtool flow
spec.

Fixes: eca4205f9ec3 ("ethtool: add ethtool_rx_flow_spec to flow_rule structure translator")
Reported-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
Hi all,

Although this prevents information to be silently discarded when parsing
an ethtool_flow_spec, this information doesn't seem to be used by any
driver that converts an ethtool_flow_spec to a flow_rule, hence I'm not
sure this is suitable for -net.

Thanks,

Maxime

 include/net/flow_dissector.h | 1 +
 net/core/ethtool.c           | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 7c5a8d9a8d2a..9d2e395c6568 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -46,6 +46,7 @@ struct flow_dissector_key_tags {
 
 struct flow_dissector_key_vlan {
 	u16	vlan_id:12,
+		vlan_cfi:1,
 		vlan_priority:3;
 	__be16	vlan_tpid;
 };
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index d08b1e19ce9c..43df34c1ebe1 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -3020,6 +3020,11 @@ ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
 			match->mask.vlan.vlan_id =
 				ntohs(ext_m_spec->vlan_tci) & 0x0fff;
 
+			match->key.vlan.vlan_cfi =
+				!!(ntohs(ext_h_spec->vlan_tci) & 0x1000);
+			match->mask.vlan.vlan_cfi =
+				!!(ntohs(ext_m_spec->vlan_tci) & 0x1000);
+
 			match->key.vlan.vlan_priority =
 				(ntohs(ext_h_spec->vlan_tci) & 0xe000) >> 13;
 			match->mask.vlan.vlan_priority =
-- 
2.20.1

