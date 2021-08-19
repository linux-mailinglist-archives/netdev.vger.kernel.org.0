Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15363F1F49
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 19:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhHSRlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 13:41:15 -0400
Received: from mail-eopbgr00081.outbound.protection.outlook.com ([40.107.0.81]:62067
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229728AbhHSRlN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 13:41:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPv9+X0iWG56hkyfto50SUVcKDVtFLTsNxlTKk7hqjgKyB7jS/BZZ1RQAOD2MRODcNbv3tlNF7L5gXdDNL4s/kTH3H6A0nqTIlUqPJke8mPY/d4Btg157S1i3/lV7s141RxZdmqmSMD/EkjRdpNsUknzZeKCYIueKo2rNXb6f5YIdCJ2B4xkRAX00NzMiGS8YyxuKe0iFlR5CMElrlyc8brUmqgbtaqso+2jecwXMWszpkrVTL+MFghuIsqzYu2BJpDLcQO2KpQR80h4zOjJtjSLOnYixkCsjU6sZe9YTu8OHjejserUl2zyYOZ6jR4ud9NUoScJrNVtJnR6pb5bJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zQmhdGJjvGc6x8W/0H/J8I4/NgGniuyPBzRA12vOmA=;
 b=c6jxttiwRaDEnXX3x+c3g3SIY9u3Lu5E5HLPwvGnfGNEC7TgkKFlkKCuARsgyx7TAcaDvfM0yzvau6nG9eCu5IDEqOEt7NuKL7etdrrDc71f+2cMy+Li2+RVcM/KPXubA0pKfx14v00Z3wh+SORvJU0uQUiKLAuWutGzixuxfufSSeY5t6cCltjGH4KTkF0+q2gDljGADuqxXwPt6ueKSy1FcCbHMyXiQe49pN3q565urOPrvM8kvGfsyxk2SIyMbiJ1waF+w+RdWBANo+uuvUjge01gfHeph9n5RjhwUBmTiq5US/9D9uhgrvDF3h/WYcsx68VY4SXfkrMawuVeKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zQmhdGJjvGc6x8W/0H/J8I4/NgGniuyPBzRA12vOmA=;
 b=rMYRfpqnHUzZrwh0xs64WoevEymND/hBcVFiiD6GX6aNEjaVG5uVNnrKJSCkvsl38z6uR3Sn/VSGumFWNfYg8dJY2fem6lR5sVIblgVjhBqJKBhKXLhzoofLWbuXGJlD3creVfnot91gcjyDHrHYMFyN6qWC769WdTzyzM49bjE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Thu, 19 Aug
 2021 17:40:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 17:40:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 2/3] net: mscc: ocelot: transmit the VLAN filtering restrictions via extack
Date:   Thu, 19 Aug 2021 20:40:07 +0300
Message-Id: <20210819174008.2268874-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210819174008.2268874-1-vladimir.oltean@nxp.com>
References: <20210819174008.2268874-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0191.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR02CA0191.eurprd02.prod.outlook.com (2603:10a6:20b:28e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 17:40:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4c8bd19-d08b-44a4-7126-08d96338727c
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26865C9C6F83F1E1C8AB2424E0C09@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:281;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6w7Mqh9TfP3zL8Ekn1uAimpxxhsNQ+twJn6W34s43aZ+JNmOn07Jw9ryvwAcDgbysjDzf9sbyMH7wau3NJTuRw11CKhFPV4VYWNWc7hw90dG0Fxcs5EuEmtB/Y1qOYtLLXRZmCbJy6qP3W39dtbxG0hT/cx8Io6fYNF8xMLko2NCJuauBFCTF1+7TAjNWpRxBVhW5oN09R7SKFo4skk5NuBGjmq5FZJn8A9s38+uPAs9UjPC2rFw2DTgYxaf14YFMbgrDrVyBvZjOcyVFA5m6HVQoulBitxqQnhpNaWX5NAKaX/FsZOzWL9j64v7Fq4euL29MSv2+5v7e1PyoojYtrTP7Ce8FyaLNeL3TWAcQmf2NDQavs6m6ZzL5EVrKkfaazvR3ivEHRgOGlOck8ATdXhnnd7w7R7V4yBhd2+LLHS5RO/1kJl2u5Qc2WnlOD2Klv10BYY+O/E8mqUTPXT7+hyHHCnbrHx0b14D9xaSl+55LEyz5WqQQ29LXpy4BEm3uMTyDcBrCICl73HyZ+GCwxUI1SVJ3cBdgX2XZKEA+Rx702RtbkFbxCrxAjawJMOOY5hA2bU26uhMityldgJqiLoNOcbINary3H6hXOu/bFHcLJCHDhAgHMwlsCg0gry7Bp/EJSL30EEVIXFvnW8p2H+dRgyc8OfmRe79HyMryAg7kAfVwUndudf9wYyHsRzpO1tKq/C+zjAvBiM10nqxqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(39850400004)(376002)(6486002)(316002)(6666004)(44832011)(83380400001)(110136005)(54906003)(1076003)(8936002)(36756003)(186003)(26005)(38350700002)(8676002)(5660300002)(6506007)(6512007)(86362001)(38100700002)(4326008)(956004)(2616005)(478600001)(66476007)(66556008)(66946007)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lPpR50bhjalNXGtZcYd529lAdb5lr0xvUgbT52JiH9/N3I/RTeoKhCT06NvH?=
 =?us-ascii?Q?bY2IiMQ+QK0y4LV7LCxT/9cP/dP6wPOeC4BHlHX9bqaNm+47nEY3XK9KJDPY?=
 =?us-ascii?Q?mzZSYy0sbEpoDm8yZ4UnP5oJqRC08dcTcwM4PwvSUkmHPiapHKE8TFQovIoR?=
 =?us-ascii?Q?LL08xFXIn7dWE4N24bduKUSG6mHTS+kSCgP7jKowHyvxAoz+uixWuYauYLTv?=
 =?us-ascii?Q?tx9URbo/ycKcklfj8ZgoZmKoZRAFdXibD6XmcxVmQ2SPFObOC3ynFvfhMYlw?=
 =?us-ascii?Q?NbtmVinYFREiA3EAzG5YcQ26k2OD713DNNznLp1XpUu4HIMFednO+ya2S5+U?=
 =?us-ascii?Q?sOdP22ukzVW6ImDoFogprMkIZk9dQRXmF2jcosVMzQgbzIglYGH3aCbioCl+?=
 =?us-ascii?Q?/P8gNeyebfdRgDEbOWqp+/bUKDItA7H+RW81m9+V8xs9/k8d5b1FyOX4pjvJ?=
 =?us-ascii?Q?TUMwlXli7UHQoWKG4jLWOKBfKotehRU/Jdqn/yooWTJwIGVZnB94O+OI2Ap7?=
 =?us-ascii?Q?/bBD5zrGNhZS9CaPK75sVgaAr3UUvcmmd1BN/ixXlUB7+Hoy3zzV6uFUkTtr?=
 =?us-ascii?Q?K6nib0FyM45q/1rETAAWiq+BnIc2KvS7WuKRTgxBfRwQ5Tdax3oHN+Nwnn09?=
 =?us-ascii?Q?//+jNBZgydw8rNjocftIjbCjkMsQmo1ZiPpU2A14dfkKoinX3hX98YKkMxQ2?=
 =?us-ascii?Q?W6cBumJc3YFx0/2ECcpWXnRkq5dEo/JuezA4dKF758uyOGL7KhutpF8iYcAB?=
 =?us-ascii?Q?fa5pDVcWgn5WmhnvuNLiYHj08pDJOTiuNipVSPN260x6730/6WdS8+l9mgVz?=
 =?us-ascii?Q?8YDnYq7kdy+lGlbR6XyejMpfAneVW6w03DDtcYLgOI9C0kzUk5iRmnK6cCUY?=
 =?us-ascii?Q?FpUts5x0wpfLzfiCUdOLiXt2YGXDNvpnKjJGASbRzOH7qrEakTarOIx5V7Nu?=
 =?us-ascii?Q?3Xx2+C29ommLSTad9tuItgJsGDcdyWtpyM6QSpCTUR80vl2zik5PDwG5Ap8X?=
 =?us-ascii?Q?5yOkLB/DPkemKH7LJXcuo2QM+nWqZEM6dsb0mqCZH2JdWsuLG7fP1obYJqCX?=
 =?us-ascii?Q?lKQl+V+YkCY2wvE9ZfDdthSwwaSj+eDGspJrRSy3x6HHGX3ojWR7g+zQlw/3?=
 =?us-ascii?Q?WAGVUPR/MztmXREvyxbWBdByB5tOkfrQmnTxoM9G7JOOO19ZxblXAjuSx+mN?=
 =?us-ascii?Q?kgt3oVziog2q554YgR5RghzuC9Iad0AHIWH4ItB6yQ3nL385aEOZfDzE8E0B?=
 =?us-ascii?Q?lD491K+lGdaKMcEYOqVmti016EkdFw/mTv2JWZnSW0SMHJHdb7x3iipj9UL4?=
 =?us-ascii?Q?jtjKUCPjLZbwxoPzYhSCloQZ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4c8bd19-d08b-44a4-7126-08d96338727c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 17:40:34.0801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xzvHF21fQgOUgdhiwjJkqVs894HJ4vA93QwufOf2yaU8PDZN1lI00kplXQNgBjWYAnoBEwyLH4TUaIMCTYloNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to transmit more restrictions in future patches, convert this
one to netlink extack.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         | 2 +-
 drivers/net/ethernet/mscc/ocelot.c     | 6 +++---
 drivers/net/ethernet/mscc/ocelot_net.c | 8 +++++---
 include/soc/mscc/ocelot.h              | 3 ++-
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 0b3f7345d13d..fdfb7954b203 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -768,7 +768,7 @@ static int felix_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 {
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_port_vlan_filtering(ocelot, port, enabled);
+	return ocelot_port_vlan_filtering(ocelot, port, enabled, extack);
 }
 
 static int felix_vlan_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ccb8a9863890..e848e0379b5a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -223,7 +223,7 @@ static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
 }
 
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
-			       bool vlan_aware)
+			       bool vlan_aware, struct netlink_ext_ack *extack)
 {
 	struct ocelot_vcap_block *block = &ocelot->block[VCAP_IS1];
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -233,8 +233,8 @@ int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 	list_for_each_entry(filter, &block->rules, list) {
 		if (filter->ingress_port_mask & BIT(port) &&
 		    filter->action.vid_replace_ena) {
-			dev_err(ocelot->dev,
-				"Cannot change VLAN state with vlan modify rules active\n");
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Cannot change VLAN state with vlan modify rules active");
 			return -EBUSY;
 		}
 	}
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 133634852ecf..d255ab2c2848 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -912,7 +912,8 @@ static int ocelot_port_attr_set(struct net_device *dev, const void *ctx,
 		ocelot_port_attr_ageing_set(ocelot, port, attr->u.ageing_time);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		ocelot_port_vlan_filtering(ocelot, port, attr->u.vlan_filtering);
+		ocelot_port_vlan_filtering(ocelot, port, attr->u.vlan_filtering,
+					   extack);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
 		ocelot_port_attr_mc_set(ocelot, port, !attr->u.mc_disabled);
@@ -1132,14 +1133,15 @@ static int ocelot_switchdev_sync(struct ocelot *ocelot, int port,
 	ocelot_port_attr_ageing_set(ocelot, port, ageing_time);
 
 	return ocelot_port_vlan_filtering(ocelot, port,
-					  br_vlan_enabled(bridge_dev));
+					  br_vlan_enabled(bridge_dev),
+					  extack);
 }
 
 static int ocelot_switchdev_unsync(struct ocelot *ocelot, int port)
 {
 	int err;
 
-	err = ocelot_port_vlan_filtering(ocelot, port, false);
+	err = ocelot_port_vlan_filtering(ocelot, port, false, NULL);
 	if (err)
 		return err;
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index ac072303dadf..06706a9fd5b1 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -807,7 +807,8 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset);
 int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 		       struct ethtool_ts_info *info);
 void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs);
-int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled);
+int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled,
+			       struct netlink_ext_ack *extack);
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state);
 void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot);
 int ocelot_port_pre_bridge_flags(struct ocelot *ocelot, int port,
-- 
2.25.1

