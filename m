Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79F427C1FD
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgI2KKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:10:49 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:9902
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728220AbgI2KKn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:10:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Td51kt1/jesLYjzQuBuAs7H8qbf8d7W/xZnf0d2Q556p44FpO2ohg36/0AQ+3m4f4JkGVXahaswCrq2lJ4MLGXF2l6I2kOpeCWztq5dypZ67piox6feydanIjKRpAtCOFeCTj+mWEyCcLcgIAxZV07h2cWp5BTO9UOaSYXgBJ44Yq2jf37Ulej57bsnhpDPG7NI85y6IdVHDfB9mgwU3hHNDUlMGzHUXmV9p//oNBn7Y3mwPhDsGeE0GHFVYlccwbCHqEq4RgBGQtha+CI9elbbmdlHiZpEnpyUcpP8CuWzv8l39LNosqGnrp4aIlZXeC+eDYD/u3fPSKUXnu6GPmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PM8QTSG9TNjTknsk6diwxCNvqv9wLvsWZp2swNkBjlI=;
 b=GREmiO/lccHB737GxAy9XPZDGp+UJ9dqIZ32TCr9tKjBzA9RDD7fcR9uTaKPa/XV7i0pfjgXDn8FL9bywb/cfH/zUGr7HGD6e8X3hHH5YXz+1dksoPqNoST2iEV8lfcqRVReOMULHJZqpQsabisfFJTzHcqAR7l5hTIOFAMYjmtRBVJa1cyRyscrP6GEIt1HLgRWlKMLD3eCSFjp+6JnyxtY1ajLbauCLxpyPaXOI4pALDiSSu1iVeyTcVgmMSQ+w8jEaVWigNYAY7Yf8L4dMFouw9eui/DQdTDlZX/N9eFSlx7l0g4Am8cz2poLF92IKopRDV8SlrIcvqYt6e6FSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PM8QTSG9TNjTknsk6diwxCNvqv9wLvsWZp2swNkBjlI=;
 b=Gxrcea3AV3fNM6/NtzQzy57j5275fYcOuEvCIpYG4dPQYWX2vmDheJI2ODQrMCKTBrX6x+EhPuduLYSCSjxvvsvRCYptIB5ADLOkkh503U9OJA0IJ+FNcAuKeLhXvoVuRjaprOo9fn6htkEV7bf8iiffDY7WUbBhjuKP+eWNpFM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:35 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 01/21] net: mscc: ocelot: introduce a new ocelot_target_{read,write} API
Date:   Tue, 29 Sep 2020 13:09:56 +0300
Message-Id: <20200929101016.3743530-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
References: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR08CA0112.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::14) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8a2956b8-3750-443b-e16f-08d8645fe7dc
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295B35B783F3D15E1FADC22E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LH3+J9NUXNZQf85eEDwnZSei9hm1jaB4gmlh/rnunrJ9G2SxJu3fwwy7oN8cPsduJK1+/BRouu40+rnCyg7wlqrlyt6sR3alUJkrFORxoo3vc/wqRf3SiYBJ0RBtFT+ZmDeUX9c0RPuRXAkrF8I3vqZL/Eixx+iQ85n9LXf2vgsWCGTmMdsq+CMrmp1txUFN2x7NqCyPIii1k70qYLfPRVSs18LSQnfYEGqdFqndlG+mB8Qgz419gW4aqeVmiCwm8yQADQnkuhA83wAi8OxOer741287lHhDKMFc3fCRDoCcz8LrwaToVOTTQVVA7L0H0hN2fU49jOUBm5IqFv4j27D2AZ4C8oq1rBt7+y9L7VKjjf7K7o6+xPCB2jtU4k79M7h+c4RE798zdT7e58nMIBFJUMb1npGOameN7nxO1EO/pALMDxqI1fCXmYqEG8sc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(83380400001)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: W+UUd1IhglRXDOTXMDEWbVroLD7ZFlKTkDCZm5TdAZzr6nrLswaQCDTU3oC8fB18pL9A7laUFhlCqxeewPjyR12Z22mqoGy/h4dIksgOdRJyKHTZNX/5Wsk+02IGqIrWO+ih1iPqx4EsRaX3tWPjm+QNJM/OG9J2VL7O57tO2u6ZLDG0vEuaPb9A09votvUlss6aHpDzJ9QsstiyWY+4M33ls+TrnXDjgFgcN2e/MwRGUSFO/oPdbmN75zWMSmoulZq1lb6yJO0iusUNzdnq371wHgEzzOZjlQabgBxwHIk1/RUKg9skI2vhsM6oCshSTXuvFRxy70HkL1CAmd2yARip+1EKF2vOg/Mz1lod2leMF+TnR4A8ydubAE0oJOthFG+elxcSw06OpPsUQFw57p9TM0fUeF593kbBnpgU4eFt+jxeL/lwgzCjIAJgIhAsL1rshCgNcHPxAY3SXWzpcOIi0zF98gq9VS9FKqsYB6S0RN8x7VUAVufrUZh9ajEJh8DiQvB2BtitT3lGv/yTEMJ8cCgrsFTc1PrCWEXD6+UzIYIon3sF/CeUXYRTVhpE2vcd9CIKx+U9+GW+uTMjF71vBZFpurRlzeL8Qud/j52wY6U0VK7iJo9AG8okdksRNtqVHHfJDrmGZeWxKVfYlw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a2956b8-3750-443b-e16f-08d8645fe7dc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:35.0396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eoFGwz/OITDg+8QvSM6aLOzAovVF1dwB2JFOXJxdbGPS4+xNl/Cg63fNq7oDluzfkDs2XRzjCsFLW2KbgYCQqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some targets (register blocks) in the Ocelot switch that are
instantiated more than once. For example, the VCAP IS1, IS2 and ES0
blocks all share the same register layout for interacting with the cache
for the TCAM and the action RAM.

For the VCAPs, the procedure for servicing them is actually common. We
just need an API specifying which VCAP we are talking to, and we do that
via these raw ocelot_target_read and ocelot_target_write accessors.

In plain ocelot_read, the target is encoded into the register enum
itself:

	u16 target = reg >> TARGET_OFFSET;

For the VCAPs, the registers are currently defined like this:

	enum ocelot_reg {
	[...]
		S2_CORE_UPDATE_CTRL = S2 << TARGET_OFFSET,
		S2_CORE_MV_CFG,
		S2_CACHE_ENTRY_DAT,
		S2_CACHE_MASK_DAT,
		S2_CACHE_ACTION_DAT,
		S2_CACHE_CNT_DAT,
		S2_CACHE_TG_DAT,
	[...]
	};

which is precisely what we want to avoid, because we'd have to duplicate
the same register map for S1 and for S0, and then figure out how to pass
VCAP instance-specific registers to the ocelot_read calls (basically
another lookup table that undoes the effect of shifting with
TARGET_OFFSET).

So for some targets, propose a more raw API, similar to what is
currently done with ocelot_port_readl and ocelot_port_writel. Those
targets can only be accessed with ocelot_target_{read,write} and not
with ocelot_{read,write} after the conversion, which is fine.

The VCAP registers are not actually modified to use this new API as of
this patch. They will be modified in the next one.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot_io.c | 17 +++++++++++++++++
 include/soc/mscc/ocelot.h             | 14 ++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
index d22711282183..0acb45948418 100644
--- a/drivers/net/ethernet/mscc/ocelot_io.c
+++ b/drivers/net/ethernet/mscc/ocelot_io.c
@@ -71,6 +71,23 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg)
 }
 EXPORT_SYMBOL(ocelot_port_writel);
 
+u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
+			    u32 reg, u32 offset)
+{
+	u32 val;
+
+	regmap_read(ocelot->targets[target],
+		    ocelot->map[target][reg] + offset, &val);
+	return val;
+}
+
+void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
+			      u32 val, u32 reg, u32 offset)
+{
+	regmap_write(ocelot->targets[target],
+		     ocelot->map[target][reg] + offset, val);
+}
+
 int ocelot_regfields_init(struct ocelot *ocelot,
 			  const struct reg_field *const regfields)
 {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 3093385f6147..16030092b9f7 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -661,6 +661,16 @@ struct ocelot_policer {
 #define ocelot_fields_write(ocelot, id, reg, val) regmap_fields_write((ocelot)->regfields[(reg)], (id), (val))
 #define ocelot_fields_read(ocelot, id, reg, val) regmap_fields_read((ocelot)->regfields[(reg)], (id), (val))
 
+#define ocelot_target_read_ix(ocelot, target, reg, gi, ri) __ocelot_target_read_ix(ocelot, target, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
+#define ocelot_target_read_gix(ocelot, target, reg, gi) __ocelot_target_read_ix(ocelot, target, reg, reg##_GSZ * (gi))
+#define ocelot_target_read_rix(ocelot, target, reg, ri) __ocelot_target_read_ix(ocelot, target, reg, reg##_RSZ * (ri))
+#define ocelot_target_read(ocelot, target, reg) __ocelot_target_read_ix(ocelot, target, reg, 0)
+
+#define ocelot_target_write_ix(ocelot, target, val, reg, gi, ri) __ocelot_target_write_ix(ocelot, target, val, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
+#define ocelot_target_write_gix(ocelot, target, val, reg, gi) __ocelot_target_write_ix(ocelot, target, val, reg, reg##_GSZ * (gi))
+#define ocelot_target_write_rix(ocelot, target, val, reg, ri) __ocelot_target_write_ix(ocelot, target, val, reg, reg##_RSZ * (ri))
+#define ocelot_target_write(ocelot, target, val, reg) __ocelot_target_write_ix(ocelot, target, val, reg, 0)
+
 /* I/O */
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
@@ -668,6 +678,10 @@ u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset);
 void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset);
 void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
 		     u32 offset);
+u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
+			    u32 reg, u32 offset);
+void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
+			      u32 val, u32 reg, u32 offset);
 
 /* Hardware initialization */
 int ocelot_regfields_init(struct ocelot *ocelot,
-- 
2.25.1

