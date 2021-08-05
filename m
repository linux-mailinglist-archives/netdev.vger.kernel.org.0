Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1ED3E1486
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241197AbhHEMQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:16:23 -0400
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:63492
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239638AbhHEMQV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 08:16:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhnIYP6dy3+TMu4g0JEvAellEIfyGMGuj3Q9YT/MOmL2CyeWu5iHJq0QC+2h6K5Wuwidnq1LXooIPdqhePJQ630YBBOoR8cs1MKdxOIibMvs71PisEj6I05iIpxvlLegLHuC2nMNryBR38j+3djkUHvEKo6I2T7Dc7X73vdW4wuhs9gznTSiz/Ncv8qr617k2z/ODKVG0VhdIOp4HT32Hw/MYMqcePpIfiGwwOJAwk82FFXrQq3Q5s6VJXCmikAtGZms+9Im6BvmhIM5Hx1Y0LGNAVWroWsvomc9as7JRV0bSb19fratl9ag5gBBF3jxRGR9iivGRmVPQThwEHBzSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxJIEWDBNKUFrhzkYHQ76RgRFdMpKwrfQm0ZSBxrjy0=;
 b=nN1EWHlW8F1dekoTWy1VugS6XRcG9XYUaAYyqlB9kZ0XDTqWEamIaWtfqul5lsZtijwayYvslzlF9ioLH1f2ZTgeD1S5YpOG9IT+eOqKoF3XoPxLwdwWmCiTEqLS53CJouYIGo3LtRVfoiwdoqsUMxJOzbKUOo5VzOmDJNN+8RK7jVcJcx08hsEYrT7OkFI66Q7aOcbDaJIx4zQe9Dz7NbqWH1WS5ymwScLp+tiWBpOR2WMDiOwxQbgGGvyJwc4C05QLF4eNi1wR0+MyxetknlnKf6eagF0UwUiszfDOJn5f3qwMc6bGNOtm3K1okt3Sz8XAfZrSTD50GMKxWhDEPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxJIEWDBNKUFrhzkYHQ76RgRFdMpKwrfQm0ZSBxrjy0=;
 b=iUApz/fkG1w774wocIHH5EBzLCrExYXH+WRDcnffyRzR24YASxhkZPSj+njfrVnLgAsrn7K7ziwH0PGBysFJtRbsWJvR8CrVjymnnQoF9YjXZ6Tnt7lNiNWXVaBvcUOWAxa/PB/khXV6yXjk+y4X+/uu6NCB9ZMFGrz/ygPD6T8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6269.eurprd04.prod.outlook.com (2603:10a6:803:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Thu, 5 Aug
 2021 12:16:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 12:16:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net 1/3] net: dsa: stop syncing the bridge mcast_router attribute at join time
Date:   Thu,  5 Aug 2021 15:15:49 +0300
Message-Id: <20210805121551.2194841-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210805121551.2194841-1-vladimir.oltean@nxp.com>
References: <20210805121551.2194841-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0080.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4PR0101CA0080.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 12:16:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6fbc665-4e11-4559-98ce-08d9580acc2b
X-MS-TrafficTypeDiagnostic: VI1PR04MB6269:
X-Microsoft-Antispam-PRVS: <VI1PR04MB62692D878133940FDE0F16A6E0F29@VI1PR04MB6269.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bhsRgE2gsYhXsVPX9O2GwgZ9iMTctOiPBiFIOsXMVzQl5XVdaXSi+KhWrPZSDwx4JxsCD6i13qfz1S60i2/6TyzpxS9oL+YOwXMZNF/jdVOKvOj6UsM17aN47h8y0VgQpIsU3kldrbivOkEVG7jSNgSqgXvRcYLd7Jc9ajvYD/Y4INHkhJsNBWW70PXe4GZlDd7VfvNbgRg/xCO9n3eaktkJywT0E//MUCeMw9gMMQORsIpJvAJCLYu9P0WnE8eKhIMhWS7XrryECcUHsiF7uA2yyJb5B7YeqFYoCsOMNEb7IC3SFppLfY8zkbKcaUcJmscnY+4//6sYIZJhNVdcKMtE8NSBz3V2rFFGtBFuzOI0b+YXC1smSwSSqdcmoaReuBJkhctsQIexzjOJq26q1gTTkYbSGj9uk9elPWYHiPpa+b4508sBk1vLONeOIf1w2QWtyD/xgjvm3YzaYXVj2D5PFV1O+IoSjkZzgTg53X16QcmWFvzHoVEJV2Izq8ZBjCiEL/tH/ueWTM96H+kkmvtlXqigjzejEHkzdJrwDLx/hY4vz7ViNiAk1yv/xeY4C3CFFUiZMkbfwW6779QWXb8lDVqYIh+GO5kCme4MDzHUlO9Bw7fN2VLDpDlklNeShWGJ5dQoj/cTEzdy1UJzFxZotaiNEriDu6dH3wbFEBbIORBXLpQgASjpFzwH1W0LJkSKr3nEydUspDohT8Rm+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(136003)(39850400004)(396003)(2616005)(110136005)(6506007)(956004)(44832011)(66556008)(66476007)(478600001)(36756003)(54906003)(5660300002)(316002)(52116002)(6512007)(83380400001)(38350700002)(86362001)(2906002)(38100700002)(66946007)(6666004)(66574015)(186003)(6486002)(8936002)(1076003)(4326008)(8676002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hfXE/+lyXMBuknPE7GkqjFbWtTCy4rw97Yc0klidd46CAOAqZt2elnwN/igQ?=
 =?us-ascii?Q?wylIpCwQQJTxlNHkIo8ONDXEjVc1qXOuq0kF6pIKGvK722o/PHxACF3ybKxq?=
 =?us-ascii?Q?JGh+Wqn7pRbq94feFc+bF8q0b0L2CrC76rkLJvY/JAUn4lX5NOcRV+P5eSky?=
 =?us-ascii?Q?PCCQgMkRlaXpaPf9wc7BmNx/dR10rvyDC69jVK5uHZRKgjyqmmK5VhvSV6oV?=
 =?us-ascii?Q?O2S+/H54hx3y1sXxAAwujgqjvPrYSCnlkK7cImszIco7p7RMbaKUYqaS9BMY?=
 =?us-ascii?Q?ZsOVf0ULX1ZMPJVADXk+Gy9MHpFz1GzgJ8EABkGlvhp2o2VNgUDJJg+XbRLm?=
 =?us-ascii?Q?9Z68m5BlB9YxsF70FC5fJecdwBPW10FDDjcp9vGWLovaccrtZKdfxMrtyIMk?=
 =?us-ascii?Q?LHkpseTcsM27wfWOAX0FVsaMmB3wequPYkMgk6fGjse/DBc/ia5usonBO/Zn?=
 =?us-ascii?Q?yREfU/7rNsD3beZvILn1Y0P0TzIjXKHQ563noGEd0Ch7VmeHH5l8f3ZTH/Na?=
 =?us-ascii?Q?rWkCt2xpgurMpzv7UrrW5ReU4hSj1reJIYhJOowPZoFRNi+ereH/VCHqgJYy?=
 =?us-ascii?Q?zNTpAplANK+iLNmh4K3oJEiXOEQvy8mViYEPl65ZO+RxT3z17ciiGOgdwV/I?=
 =?us-ascii?Q?tJivmf9pLkpHM/9YhnURO+afmlgsU5itK/LdLS0GywBkNNIjs5QXsJyuhg1M?=
 =?us-ascii?Q?H9xHwNso9c9jeuab0TDwYTQGB0j9Ml4LBJE/du2rli068+9NSytX/43tL/Ua?=
 =?us-ascii?Q?eR29SFz6Wl32quys0jLf02YaNn0RAQhuIhM4tDDYrfygh1cr2Gxsq2jDi33f?=
 =?us-ascii?Q?1ummd5NhgNnla/ISAim5+ACjh0tH9BCR3iZufmhppM0yQANSfyuZzETx3v0I?=
 =?us-ascii?Q?pfUQXY9VNnQMDtAjv66yO1aG2oEX7cukfG8t1QVB4+SanEVa34tqgpr9U/v2?=
 =?us-ascii?Q?4zcR9e7LGBeXIyJp19TJ+Dp7fZJdzEUvnaWZ4H74xOYWDJs0lqzAjS6UH1h8?=
 =?us-ascii?Q?LOnoR2HUBpBhg46FvPJPa+iMfmz7ibg+9Doebn92+9+nxMesknCihh18fcCF?=
 =?us-ascii?Q?qvUgbByYG48GKniwkySeVDqJ8n6g2jfMzTA1/4j4nywkxpk7E8ZfLWTXdgGX?=
 =?us-ascii?Q?RCK6YbeSvPwEELyuyzeLOQ8FIyNb8hpCCxN46o+HTdy0SsYRChi/8xHEgzVQ?=
 =?us-ascii?Q?8cel6+ubMhBUQMJSMLEyHsPzCKW4rmXwQ3Mb8orD6NjPx2TEyjkIb2Ty+OBm?=
 =?us-ascii?Q?cMv2gZcYgSmIHesgKCIFAelJ355uFmfAuXa50ird3UyYUxdcwK2QGjDh7Boz?=
 =?us-ascii?Q?i+j4qqcO6Xh1R3E1a+2sFdTr?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6fbc665-4e11-4559-98ce-08d9580acc2b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 12:16:04.9631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /eYXCOtGDEPm4q2mAPoY4zkimB9qRoV1Zm4VjNhQbmO3pxLJLiIa7HjocMd3ZblywGjvf8UI6UuCO4hjfXuzUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qingfang points out that when a bridge with the default settings is
created and a port joins it:

ip link add br0 type bridge
ip link set swp0 master br0

DSA calls br_multicast_router() on the bridge to see if the br0 device
is a multicast router port, and if it is, it enables multicast flooding
to the CPU port, otherwise it disables it.

If we look through the multicast_router_show() sysfs or at the
IFLA_BR_MCAST_ROUTER netlink attribute, we see that the default mrouter
attribute for the bridge device is "1" (MDB_RTR_TYPE_TEMP_QUERY).

However, br_multicast_router() will return "0" (MDB_RTR_TYPE_DISABLED),
because an mrouter port in the MDB_RTR_TYPE_TEMP_QUERY state may not be
actually _active_ until it receives an actual IGMP query. So, the
br_multicast_router() function should really have been called
br_multicast_router_active() perhaps.

When/if an IGMP query is received, the bridge device will transition via
br_multicast_mark_router() into the active state until the
ip4_mc_router_timer expires after an multicast_querier_interval.

Of course, this does not happen if the bridge is created with an
mcast_router attribute of "2" (MDB_RTR_TYPE_PERM).

The point is that in lack of any IGMP query messages, and in the default
bridge configuration, unregistered multicast packets will not be able to
reach the CPU port through flooding, and this breaks many use cases
(most obviously, IPv6 ND, with its ICMP6 neighbor solicitation multicast
messages).

Leave the multicast flooding setting towards the CPU port down to a driver
level decision.

Fixes: 010e269f91be ("net: dsa: sync up switchdev objects and port attributes when joining the bridge")
Reported-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 28b45b7e66df..d9ef2c2fbf88 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -186,10 +186,6 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = dsa_port_mrouter(dp->cpu_dp, br_multicast_router(br), extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
 	err = dsa_port_ageing_time(dp, br_get_ageing_time(br));
 	if (err && err != -EOPNOTSUPP)
 		return err;
@@ -272,12 +268,6 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 
 	/* VLAN filtering is handled by dsa_switch_bridge_leave */
 
-	/* Some drivers treat the notification for having a local multicast
-	 * router by allowing multicast to be flooded to the CPU, so we should
-	 * allow this in standalone mode too.
-	 */
-	dsa_port_mrouter(dp->cpu_dp, true, NULL);
-
 	/* Ageing time may be global to the switch chip, so don't change it
 	 * here because we have no good reason (or value) to change it to.
 	 */
-- 
2.25.1

