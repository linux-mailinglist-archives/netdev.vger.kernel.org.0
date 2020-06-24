Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA2020697D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 03:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388470AbgFXB0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 21:26:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57472 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388464AbgFXB0B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 21:26:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jnuAn-001x3O-7t; Wed, 24 Jun 2020 03:25:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net] net: ethtool: Handle missing cable test TDR parameters
Date:   Wed, 24 Jun 2020 03:25:45 +0200
Message-Id: <20200624012545.465287-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A last minute change put the TDR cable test parameters into a nest.
The validation is not sufficient, resulting in an oops if the nest is
missing. Set default values first, then update them if the nest is
provided.

Fixes: f2bc8ad31a7f ("net: ethtool: Allow PHY cable test TDR data to configured")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ethtool/cabletest.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index 7b7a0456c15c..7194956aa09e 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -234,6 +234,14 @@ static int ethnl_act_cable_test_tdr_cfg(const struct nlattr *nest,
 	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_MAX + 1];
 	int ret;
 
+	cfg->first = 100;
+	cfg->step = 100;
+	cfg->last = MAX_CABLE_LENGTH_CM;
+	cfg->pair = PHY_PAIR_ALL;
+
+	if (!nest)
+		return 0;
+
 	ret = nla_parse_nested(tb, ETHTOOL_A_CABLE_TEST_TDR_CFG_MAX, nest,
 			       cable_test_tdr_act_cfg_policy, info->extack);
 	if (ret < 0)
@@ -242,17 +250,12 @@ static int ethnl_act_cable_test_tdr_cfg(const struct nlattr *nest,
 	if (tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_FIRST])
 		cfg->first = nla_get_u32(
 			tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_FIRST]);
-	else
-		cfg->first = 100;
+
 	if (tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_LAST])
 		cfg->last = nla_get_u32(tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_LAST]);
-	else
-		cfg->last = MAX_CABLE_LENGTH_CM;
 
 	if (tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_STEP])
 		cfg->step = nla_get_u32(tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_STEP]);
-	else
-		cfg->step = 100;
 
 	if (tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_PAIR]) {
 		cfg->pair = nla_get_u8(tb[ETHTOOL_A_CABLE_TEST_TDR_CFG_PAIR]);
@@ -263,8 +266,6 @@ static int ethnl_act_cable_test_tdr_cfg(const struct nlattr *nest,
 				"invalid pair parameter");
 			return -EINVAL;
 		}
-	} else {
-		cfg->pair = PHY_PAIR_ALL;
 	}
 
 	if (cfg->first > MAX_CABLE_LENGTH_CM) {
-- 
2.27.0.rc2

