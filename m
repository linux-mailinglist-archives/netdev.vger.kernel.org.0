Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80AA416337
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 18:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242174AbhIWQ22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 12:28:28 -0400
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:40942
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242049AbhIWQ2Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 12:28:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h44iI/vN7I/QbYYOkSPcLKpfIUdhWGD8ypmC3S2VslP+G78PsL1oiqVutP2FhwZTbTeeGvJtPdN9RSZ0nM/KRcK3kT6PlRZxZwmO0Jh31e6lshlcpzt7p8q2uADGwSAHOoR1hbADZ3E/ET1LR760NuqEir7KI3kTO0i9Pg/7bpAv3jbeTr8LV6kxrNRWv5NkODtG+VIghMniprKkW0rur0svG9NNNAZbbvojZtkP6T+4zwVDWcq7ulI6sX3VHFcDPKOIrDxNCdfCr/YLw7tPxJJVM2I0DXPcTFKMQ0s13bnZbKn//lgCddlNnqwV0Xbq8T5p5sv7VbyYyA0n2nt9Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=XYa3DhFO3AW0gV1eIfNG0RS2+iTkknvaD46YJ97wlgc=;
 b=VWbJrADbYMoJbWy/L12PuaJZJoce+YXksohs7bKDd+gNv0INY7J2tPURx9/4SSKrLgOLSqF5P21Dji12FZHPM/U9fOll7riWzqSsQINXk5aKIcUlil4EMF2heQLwX18vCdVL0Zwv4YFcz2d13McPkel36qz+sEz+NuzVm9X/8W0g61slbV5pW0AeANC3Y94R5BXJwQiqCso0vt9ffV5uPmA/d1JLPs5YSjEP4m34C4+y0bMi5/LFqM+KJ7+Sdl8SvApVbtMMeLUQgwemkoADH3i3wUfgEUKjs2C+AvtGGu/3MIaS2FYhyUss6l/t06qh34Vi2RmCMyIKjMF4f5QPsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYa3DhFO3AW0gV1eIfNG0RS2+iTkknvaD46YJ97wlgc=;
 b=lwQYOOoz1fxie4Nsb51Vd13PlFbry61MN3RT2S+m+NadB9iztmijizLJgViMzc8YxLZSYS31gVDSt+fdzlqFXMi8JBT+EoTPCWtR73AR8HMMer6qQTJtJDOuYRzb3hTp23pdkF0HAZI7/YdmvFfXxyU2mP9szep413oD+bSg3F0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6270.eurprd04.prod.outlook.com (2603:10a6:803:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 16:26:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.021; Thu, 23 Sep 2021
 16:26:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: dsa: felix: break at first CPU port during init and teardown
Date:   Thu, 23 Sep 2021 19:26:41 +0300
Message-Id: <20210923162641.3047568-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0032.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::45) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.53.217) by AM0PR07CA0032.eurprd07.prod.outlook.com (2603:10a6:208:ac::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7 via Frontend Transport; Thu, 23 Sep 2021 16:26:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45553a17-cb1d-4764-6d91-08d97eaef365
X-MS-TrafficTypeDiagnostic: VI1PR04MB6270:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6270EB5C4DE8D725C43FAC80E0A39@VI1PR04MB6270.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GWd4dPFxN7O5NluwwpL6OoI+AhjKbel0Mv+zrIpxi3judLrlt+HCJGVB3flg7UDXsYb/mqQu5R1KGpHNCSnWcwk/Czl4SrgOH0TbHIe/ZGMYNvYdM90sgn/rEBhO2drHsfqOOR2pM3576ocs4pes8vs6Q4x+RYKew3mVLUooioRBJ06NQ+DGu5DwL6rIIToUoD/R7tQcKqVUOfr2TJ1sKa0lka4H9jHDms7BpOi/sedPb/MX/ax/vFV3qi0n8Ph9FQIwH7H6J663Rq7LZkVTWby9i9oTw4NmY1F/rl2+qTLsXWh+D4h3jZMsnqQSU2hWjO4Zz1tZsT5j/YbdCvgYA97Aky6vNIWvkSIVBaG/YfK1lj2QC0YIhzq6tWiipJzlJ3zydassVj57U7EHYJEL5aVMfzis0z2B1E/esxNBUZ69XeZw7CSJl0UiwxgqKOr/mVuGLEvwPg1uBoOWzR+kYcJPG9KnsHYTDBMAU0sWUPf9cVYtAaXAVOCzQH9rb516WRNuVRzP1mOG1DcjCbuXBQe/LEu0FoRViQDTDFFHP2L7bHeJNJ4/ui0wDmpDXdoX+VvAPEHfphZ8cZHxUUJDcw1as9kb3ljWyvVSVdTlLPVmLyieNsBCitF/vUa4VumJ4reOIfxi8wmZNTZ7u1DifGabMX0K1kpMfN5llao+4oy1fokSHUNSR4sqqVL9pAtbZ8kEyR7XyNeLTplU1n8E4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(66946007)(6666004)(6506007)(956004)(1076003)(26005)(52116002)(316002)(186003)(36756003)(6512007)(6486002)(83380400001)(508600001)(38100700002)(8936002)(44832011)(4326008)(66556008)(2616005)(8676002)(6916009)(5660300002)(2906002)(66476007)(38350700002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qm0hHxfcUtHAHQ5OZUTKazXWSveoPa9Alh4qv9sX2JRvuYB2XpBJiFRX1Y57?=
 =?us-ascii?Q?aR955sgI8nqJ5K9/Z+PIbTyRRa5hAL3QJl32/8+lXQK1sRi4VSmHnc0Vq7Q4?=
 =?us-ascii?Q?YPuhhvYP2kvIljzgdsXPwZ2CgdQPggSzspmeMzzmxONRfHGJYU7tXjUX2NV0?=
 =?us-ascii?Q?LpDpnS68ndZ+Mz0WWSPPLjk1/eUfB25rSYFkY0Er+RfWfSf7DvDS+1Km8rA/?=
 =?us-ascii?Q?JWXo0vGnuc8Yji6vc6NhAy9SyNr/lB2mPuKeD8RyVNpLFF344UkuyIvbjtUX?=
 =?us-ascii?Q?jtpEEAa6pp5ste09dXi56dRm8xgXd3EEVpRUbf4ITTUQhPgUbL/WwVw7mQ7b?=
 =?us-ascii?Q?s9glUpYuDCH2iIoHRMqJNZWrnAL5ej/IyM6Mni4MgITdQGt0UqImaQ6ehBGw?=
 =?us-ascii?Q?DH+Lpe1iLMv9np4ppWyZreIgViVD6SKm5Mz4gpyllj0n92AHYY3Ye3Oj2O1n?=
 =?us-ascii?Q?j4WUyQJO3qUhPc/zCb96PH9RIMswYlhWKNKjK7gJn/Eq6+E1qTtD7pZIsybp?=
 =?us-ascii?Q?IDJQEzOJeo9JQnit7CIEBKb496gQG0hufcwMUYUuU1XBTojZDnua6s8wIfMP?=
 =?us-ascii?Q?QvGS4wABwGBscVtmopcQkibVjqKfGDB7qlB9b7vt2mjXwHRjEqMIesOPmKHU?=
 =?us-ascii?Q?qcK4/NDV5uAiQrR4k7G0PvV1Kqm9x8XLhMidnQTRVz6ofPAVvPplX88YWHWn?=
 =?us-ascii?Q?RDtqUJZDWuAJXp+piL2nGP28z4JfzSSuC9LHNwVJfB5cinyLrsOOMOZrxfbb?=
 =?us-ascii?Q?0hxPNBmiyZpJF4xMapsZMoZYx1rXAsHbtiBS7aXFHnzMBT0/q3qyrpkzMkrH?=
 =?us-ascii?Q?sOkDUSH29K+TB/I1L3dqdjZkiQt4FliSPNM891uQQe8yaALQAYq4SkY54K7z?=
 =?us-ascii?Q?x76nFxwh9czMlO0ly9Ld4+ay6/gDRD0sdC+Q2C4YXaT+MzKo+dU2rTF6ViWI?=
 =?us-ascii?Q?WOR0xJ3q0BpDJbgUk4BmVGSJmL7izAn4RqW5Z4FwQSV+myZi7D+bkAYyl/mY?=
 =?us-ascii?Q?5EtVGW6LftY8bd5KJyC3qdN/9FvpqRpdzdJky6KWukNRf7GU/NDb5mE4gpNn?=
 =?us-ascii?Q?NiYXN6Fln+z36QSu2rFxvdTl2/zylD2GBvlDAzIncPpWOF5F+6Lh53Lg/MbH?=
 =?us-ascii?Q?5TY0Fe+cu/NHBeyxOauU9AiEUoYs9BO8jbLeYH6GhluYCAt0jYcX1gS0yZB1?=
 =?us-ascii?Q?LML99ioBiLe6KN8CvfF8j1MyOCgpO1v8xSxJ58VPV6F++vwrASlufiVQd1U1?=
 =?us-ascii?Q?tywSRiOTjoJ913yHRC08eBxLnUQbymL1r5xPA1PfJG+M1ndFq80Sc1TeqDoV?=
 =?us-ascii?Q?PPC5+t0N4PGxyJ4/YCtX0kwQ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45553a17-cb1d-4764-6d91-08d97eaef365
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 16:26:52.3915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xQ58RA1DL3iXNJAf8ku6aeE9b53aV2Y7KLrub+VsZjMIIZbwTJgmGEl4criQXJJzLh1mlPldXeZhyLknvR8SxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6270
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NXP LS1028A switch has two Ethernet ports towards the CPU, but only
one of them is capable of acting as an NPI port at a time (inject and
extract packets using DSA tags).

However, using the alternative ocelot-8021q tagging protocol, it should
be possible to use both CPU ports symmetrically, but for that we need to
mark both ports in the device tree as DSA masters.

In the process of doing that, it can be seen that traffic to/from the
network stack gets broken, and this is because the Felix driver iterates
through all DSA CPU ports and configures them as NPI ports. But since
there can only be a single NPI port, we effectively end up in a
situation where DSA thinks the default CPU port is the first one, but
the hardware port configured to be an NPI is the last one.

I would like to treat this as a bug, because if the updated device trees
are going to start circulating, it would be really good for existing
kernels to support them, too.

Fixes: adb3dccf090b ("net: dsa: felix: convert to the new .change_tag_protocol DSA API")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 50f872454b7a..571b20fd2b4a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1126,6 +1126,7 @@ static int felix_setup(struct dsa_switch *ds)
 		 * there's no real point in checking for errors.
 		 */
 		felix_set_tag_protocol(ds, port, felix->tag_proto);
+		break;
 	}
 
 	ds->mtu_enforcement_ingress = true;
@@ -1162,6 +1163,7 @@ static void felix_teardown(struct dsa_switch *ds)
 			continue;
 
 		felix_del_tag_protocol(ds, port, felix->tag_proto);
+		break;
 	}
 
 	ocelot_devlink_sb_unregister(ocelot);
-- 
2.25.1

