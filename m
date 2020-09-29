Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBA727DC09
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgI2W3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:29:44 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:36622
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728192AbgI2W3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:29:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4hnBxLkkQvj6OZDKXwfQz20Fdpo1tPO8VCcrDRYdbg7I5ghUPxWOQQW/h9mO4wP6pF6Z4NIuvlO+Zk7wghte0rb+6LgtEdCAXURHtAjhLaB61g/WuoxRTj5nMJz4v9rv8/cvIlg2f7y6A5rKjG84mSdN8NEMsjheGbgLi9sGIVVZ/S1VCMERaZmUajK8zYOLrphG3XqrcpmVqQjmaOToOw0lesn/0HucGIQbyUsb75+gk3J14I9frsh494xSbEP2jUjYCMooy1dTy7L3GR20uwS96bdtSZZUHHclCIepv1/qKL5sqxgJ44776MdfRtBrGfx0K5428qOXa/RFetXnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXzTf+G0Gd1FWRNqFxnkiaUKYSPOnVaGPyn0l/I4GeI=;
 b=WBvCmrCVT2oiAPFb0oxMtpRZ+zLOatZeezb8jF3eRRyx9/RgpY4qBWRMYT0Etg7C3QeMg8uBNMPjzZ1ymNhBLt3nuYlR/ZnUJw9P6+XqNS0CQfIoxdv9tTxbXeLAI9yyUXIc9AP0Mv3XThUUG2/t6q8IIAWOV/mtx+HoaG7U/sqV2BPgb2WWJteKxJHEkaUWyFYlcVFOJZRjjLCsUl5SipCnJoBffWzH15I9xfkoknZokTfwfiQxVDNqbrPZ2T6uSoA7zRb05Zv585j72c/NCy4mRVlkcgMdMGJaNifEETTU6DEBOGmYzubdI0I7DWFSUl1s1CEcSYCyM08Kc4DqeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXzTf+G0Gd1FWRNqFxnkiaUKYSPOnVaGPyn0l/I4GeI=;
 b=obAvm6C6yjXKzuG7QTIcY/Mwo7dAzavG+gYObIWsLtlLukdzbZqPW1joyVjjsnZ9qmV5SEEmhfqb2dX7CrrbpqwwF8AWFe3qD2Tq9HOO6tFtQEgLnbbAxPoJCCjVbCx+SnC6Y+rXQ7FyZMAiWp/ZwEq8E31eRfOPWTrFZtkvA5Q=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Tue, 29 Sep
 2020 22:27:56 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 22:27:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 01/13] net: mscc: ocelot: introduce a new ocelot_target_{read,write} API
Date:   Wed, 30 Sep 2020 01:27:21 +0300
Message-Id: <20200929222733.770926-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929222733.770926-1-vladimir.oltean@nxp.com>
References: <20200929222733.770926-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM0PR06CA0126.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::31) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM0PR06CA0126.eurprd06.prod.outlook.com (2603:10a6:208:ab::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 22:27:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9c93d037-ba9a-45f2-3343-08d864c6e9b6
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB279765B0CCF6CD4AD5372AB6E0320@VI1PR0402MB2797.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IISxdXunG/H329wD+yLGIoN12vtFnPBzSzUXcZCTGqV+vs0DHAVoiJgdq93VMPJyWXu7zonx0IQp+ZmcO1den4neHu/5NcWlzQsWCJmpWhIhtzh+Z1v7YifkjbnbDe2n4dml4g/O885meCCbFLC6PJErc08p7bAXsXAt8nCd/MLHbnB0BV5TPFMlHi27UYCpilNuUkcSI67bG3zcpSxquJD/Er69hDAziTrdkMGMR14CP6f2/ZyI61/1vALn/Zi4VjKGlvnhRQFlYHmk/fw4sP57bBSDIGlfmXE/JziWg67513Vh92ZBUv6GXH3mi7XNvJ46xeaxExD/svnsVxwMox71GQta/5lKORy/5iU7nT6UVp6jwgdQ8OgdCBkiZuwCoI4P+LQIcwURbnS0dbnEGdMhCv6lQM0Y0n2ueLK+iCNkUx3twYUFmS4P3uth0srh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(8936002)(956004)(478600001)(1076003)(66946007)(69590400008)(6916009)(86362001)(66476007)(6486002)(316002)(83380400001)(2616005)(66556008)(6512007)(36756003)(44832011)(16526019)(2906002)(186003)(6666004)(52116002)(26005)(4326008)(6506007)(8676002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +U++kDdc36Qyw2/vJrtqcwyu9Ek9wBSXa94Ii0Z22vRkZLQAzmjxt8yq6eBTnBfE0Wm4fwEc+8KI55m6LYCdXP5tjJV4VgsPEz0eKN5Z+lOAQWVGC9Gpy8zBAEvmcFURZoab5l32+xK0ECL0TBEFz8KW6nTRsQxTigzIzIVNmms7axa8z28++jN9keQkNlbhgp0MzHUwjNbWvirzdK6fovVavyhJt41+VcExH7+TUl+5g6NnP6JlskULeclqYMcWnWJtJd+wtHLeYpH/oA3l9TMC7OxpzXj37UBY9+85sqaSxh39kb0whueEX+fE3428gZPEZaOknQaJAiVTLTG+mgjlM+3y6s18KL2Fafs+gbVmV0iTwz3CLfwH4i3D9UqQ6nByImX3aWNa/i56wjmJ2N/P/N3He+ETMm4LjAv2i7r2Xs7Oy7Q7nDYcuXU6d4BI4/demC7IcBgplRDR+Pba0SOWTUEJqQ1YQbM0piyWtYIO+MqBL0A/u/WELWXrUtadXd4Agzw3Tc+giv/UgEc7AGIfkmP9veD6HpN1WHMMqCudQgglnCn9aIWXFiFke98bca/kyQSpV7Y7Zwowcr/K6dRgOiUm0WG26CJc8gq4IP95XcLuP94Ic1quVvFiemnUEXT5d4jEbP7BZWNLRMrtrw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c93d037-ba9a-45f2-3343-08d864c6e9b6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 22:27:56.2937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jqUCOAavPDeyG3ui/HX0dFuMR0fVqOhXiLG3QpL27BouAYosogsgEBIeeB/6rcvJV3eNPUb82WLNj5zSa8/+eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
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
Changes since RFC v2:
Fixing checkpatch.

Changes since RFC v1:
None.

 drivers/net/ethernet/mscc/ocelot_io.c | 17 +++++++++++++++++
 include/soc/mscc/ocelot.h             | 22 ++++++++++++++++++++++
 2 files changed, 39 insertions(+)

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
index 3093385f6147..d459f4f25dc8 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -661,6 +661,24 @@ struct ocelot_policer {
 #define ocelot_fields_write(ocelot, id, reg, val) regmap_fields_write((ocelot)->regfields[(reg)], (id), (val))
 #define ocelot_fields_read(ocelot, id, reg, val) regmap_fields_read((ocelot)->regfields[(reg)], (id), (val))
 
+#define ocelot_target_read_ix(ocelot, target, reg, gi, ri) \
+	__ocelot_target_read_ix(ocelot, target, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
+#define ocelot_target_read_gix(ocelot, target, reg, gi) \
+	__ocelot_target_read_ix(ocelot, target, reg, reg##_GSZ * (gi))
+#define ocelot_target_read_rix(ocelot, target, reg, ri) \
+	__ocelot_target_read_ix(ocelot, target, reg, reg##_RSZ * (ri))
+#define ocelot_target_read(ocelot, target, reg) \
+	__ocelot_target_read_ix(ocelot, target, reg, 0)
+
+#define ocelot_target_write_ix(ocelot, target, val, reg, gi, ri) \
+	__ocelot_target_write_ix(ocelot, target, val, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
+#define ocelot_target_write_gix(ocelot, target, val, reg, gi) \
+	__ocelot_target_write_ix(ocelot, target, val, reg, reg##_GSZ * (gi))
+#define ocelot_target_write_rix(ocelot, target, val, reg, ri) \
+	__ocelot_target_write_ix(ocelot, target, val, reg, reg##_RSZ * (ri))
+#define ocelot_target_write(ocelot, target, val, reg) \
+	__ocelot_target_write_ix(ocelot, target, val, reg, 0)
+
 /* I/O */
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
@@ -668,6 +686,10 @@ u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset);
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

