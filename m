Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077902786E5
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgIYMT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:19:28 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:63262
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728171AbgIYMT2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 08:19:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0oU5eAInkrVPBAqbDSN1B00gl7VD6AZIb3KFerZnHZpM8nILTNQpB360+593t+Ee/E5p35+byBWyJ2U50jxFnji0r1Rnr4liDE9HJuh4mJBwv18d2HOae0AyhLW5uAjYm0Vj/uGQK5P+3ZI2iAnn7luWOFjqATXqRD4l1hsL/RZQcuExEQKIbtZjT/ydGLuXYJiPigBbfvmwcy2obTuTcGx8zADw3msN/Ivypo7wy4uXRR3AZ88YrniGiPcJ0a342egTIPnGSv11E8zQMY0K6cLL/w8LxWH87cxtHu3eGP5Xk1287Sn6KTr2041/8vMCiMvRgxhlk056aPsRLdcSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZzdWd7XBq0XkxXFBZd9X31wh7zrNES+u0qOd02vYcs=;
 b=AeHvNWf4240LM+b3J/VS9f3cFMeEfTlujSzmsLf3qLAi/h6zdW8eAmpWLq4gAfK55kCf0j5d6YEoY+Dfmf9wBozGVmbn4S+X264DHeWqpACGNvpqEiCHDVc5aPke8xPCpi0fO4yBUMkqBvMwAu5Imcym3IWBQLbH2IdknICWJmwJ8YUk6BVakXssl0jMPDg6ZVYmCmQMI5MJ2yl/feinRhqHmhiDTFqETzOv9YwiMaQrpMRk7XIbN6VPJ5SHNo/1Cv6SJyBlgYPEX0OpqzL4nMV3itmFd0vc0atydV73cZ2403JaxWdTPLemzApNFSZ4CNES6ibZKkUvHvIwaR6YBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZzdWd7XBq0XkxXFBZd9X31wh7zrNES+u0qOd02vYcs=;
 b=D9ubcRV9ZyrvDhpL5ZVz6MqOcT5syMYvHtWfDnKHZFyJNor4aotlgObPrdr2Hh2IRbYTEHG6HHExpWODwQ4sgyyENoSno99QNAzBsfJJbnYjg+agbfC4cecC+Wr6uHQX+eJulJGWChLuQ8QEBnWF1uf5MUdlQR/pilYwoVklOQI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3550.eurprd04.prod.outlook.com (2603:10a6:803:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 12:19:23 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 12:19:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH net-next 01/14] net: mscc: ocelot: introduce a new ocelot_target_{read,write} API
Date:   Fri, 25 Sep 2020 15:18:42 +0300
Message-Id: <20200925121855.370863-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925121855.370863-1-vladimir.oltean@nxp.com>
References: <20200925121855.370863-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0007.eurprd08.prod.outlook.com
 (2603:10a6:803:104::20) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VE1PR08CA0007.eurprd08.prod.outlook.com (2603:10a6:803:104::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 12:19:22 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9dfd96ed-61b7-4102-a6fe-08d8614d3c42
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB355032BB5B44B8B871D7FE2EE0360@VI1PR0402MB3550.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t4FYTViY2R9cIB0uB7fFhtRAoNrv+zjaQcI5R5xHdeXobd/L9cD5lipbIOknirN2kizWXl3I0QrHGw1VgPlF8dgSM25p4+FhU4AhCwCKRX/MvcJTfwFfyO19Af/YfS0L6oLIG3v7JBEREDcuXDdYAL7ryTtQwoVUg+Fg6ZCZcYGuJuWwAb3YsVGNt32b3tkZ1ycS2olq8bywD1fdpEAjX/laXpIPJftJ1zAQzWEW6p26DQvYSKh81w5FzmK/BizXplxx473iyQ9tLzn9pQiM5Yk/p/UEYQ5Ml+a8mMK1dzhY3j9SLC1Mh8Va7sJtcpQFow8NQ98AsyPKoNQmK3H9XRpQxh5oYe95WUCvbIIy6N1FdaTS9QCN8QIamx1OKdSsYGXs31hf7cMhYcidI4neCZaLefLVK9EKpRMmqP7alCk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(66946007)(66556008)(36756003)(26005)(4326008)(8676002)(956004)(2616005)(69590400008)(83380400001)(86362001)(66476007)(44832011)(52116002)(6916009)(6666004)(1076003)(6512007)(8936002)(6506007)(186003)(7416002)(5660300002)(6486002)(2906002)(316002)(478600001)(16526019)(142933001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tZPqtf3XBN2Fpi37PL1o+1nkYElEr+Cplew71kBHQK/DwDWx4uGf/WwLFyGJbOrx+aa6k2Mu9Vf2xVcM1va+tjTODGrxiKve40veNsnJwwkp5VdzN8SdSmgI+LhobOXco5tA3OAGbbucrL5DV2/W3Nng6FrBRchYko3o6kaUZiGIhk34Qi8Tlz91YzzyjHRZgLfK2KE/ROM1rr/y9sQRFf4SKus+31IzWZ0VW0Xzux/63i0q1lkrFKO28BNiiCCeXUnYuX07oGu7KZ+ZX5yvTLrnXrsVt33MS1LZFmJ4X7JDVcrUYoSZwCcUJmLfgBzMo5zzBa2Qym9arY9to9vFXCQ5ocfljpfC5qSvg07+haO/bfX2fIyd0vXC8b0DGkv+MnJNK6o/FXjJ2Q/MAXfW0NWBZetS4mxVg2K13vTPhxXrr6OqMG//FSQWBqU9MLu6X+5qEQN3rlJjoO15yd4zRXrQ7aai3bSEx9AY9Zr3Zimzhgl6iRB5AtNjBNjzocF9rPvb2sfaWNKt/6ellbNjYYFIHLhWRUHWK6Bny1FOp5rHP1C1ElyPW6sUGh81aj5w5fDy+FYZBEH/Cg0H1CcqMmH9FV+CJkm+Lrk3fl5Sn6xXy2YnM9/EN62U8+3axBz+Ro8HY/SeJbpSwxvk+FQCPg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dfd96ed-61b7-4102-a6fe-08d8614d3c42
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 12:19:22.6291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qTTFI3ZC5xm6XavTApPvOjMyhbh/evkD2iANMCJcvm5JHZSE6+IzbfaNMSZCUSlxYrME3tSO9Kw1+HY3QBgBtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3550
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
---
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
index 7e52e6ee09d8..a71ea217da70 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -662,6 +662,16 @@ struct ocelot_policer {
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
@@ -669,6 +679,10 @@ u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset);
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

