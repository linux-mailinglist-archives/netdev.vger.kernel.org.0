Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE55E3E8FF6
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 14:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237414AbhHKMAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 08:00:22 -0400
Received: from mail-eopbgr40042.outbound.protection.outlook.com ([40.107.4.42]:39590
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236497AbhHKMAV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 08:00:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJuNtihKGhBLtO+WwIKifAfnyUR7JC1REWLFvZTKOa6b7uFrpeHUVPNeRj0dDWPFBf6kKa3eNu8/yNkOn3w7Gi67kMqnJ5cPIadnQCFeWdMpQ/K8+5Vvq9i2lTRFlM19qdM1czFjz/GzN40NfPOFgNCnxMAl3Z7JyWhFkKNPtuGoGWBmcfdG+soBWB10crIM6SYDu/76T9FYFZ0tJNchbgA4K5E9iOZ0K4O6pB59bRWR5CpHrFYqTop2KsCElMwyVLDut0yPVD6pbRfy+MveKM0AX8N9R5UficEHsUcssB87NCDVyQD0V4u9mtgYY/6Z3cE55edqyjgpCl2Vu+/XHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0EzchKYKhxUrU2plop5n8MH29FrFEeACLzXar130F4=;
 b=LR9fRC/XKpJfghC0RUh91zEapfVNci03TDUgCTDbmuNVyswvZChz9RImK3aRmiDnv+abNP3QFWSJQFp41Kj8IAEvFn33QI5LSJUeSOkrhDH+vLjEd2DyisWF+kOng+5fcPTQdlK7vOCxCuBvC+RJuiITRdWfmZZIULCYSuBQYYCPu7ixdFRQ9YBhD+/P0xcs+xKLuaHNppjLR9Xr//8u+1jnR/1eGM7MoK0eKlkhLHDpgZB7LWjdKiwUGx3/cxBnsOghWcCp3i1rqohyBqqMFo2EDlhg2jNqLKCPwgEddUv7k+AN48N283BaH42dYIchBF8jvyD9DwRrK762tXFO5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0EzchKYKhxUrU2plop5n8MH29FrFEeACLzXar130F4=;
 b=rezjwVMS+ny67XbPzuWm2Ruj+T+l6TDIQ20WJ0DN7OEQcNa9AFHpXCjW5tQAOUlYNcu/FEDERgcna02O/Gjrbz0KuDyMPq/ALlB58IAYFSRHezSbdNCzJZcbmB5+UsgmWr/822ZtTJ2tD7UiDpyj6JkX3lHF/VNzE4oYYM5SAQo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4814.eurprd04.prod.outlook.com (2603:10a6:803:53::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Wed, 11 Aug
 2021 11:59:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.016; Wed, 11 Aug 2021
 11:59:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: dsa: sja1105: unregister the MDIO buses during teardown
Date:   Wed, 11 Aug 2021 14:59:45 +0300
Message-Id: <20210811115945.2606372-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0130.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR01CA0130.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Wed, 11 Aug 2021 11:59:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ae7909b-4318-4dc7-77ae-08d95cbf88ad
X-MS-TrafficTypeDiagnostic: VI1PR04MB4814:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4814F0DAEF37E5E4DDB76D97E0F89@VI1PR04MB4814.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TyCh/4FjmEIFwNZn9Lr5V/2v5WYXUpq4SA0NUKnW/EEsuIde77WaI1VU+kzU115A0fHFVlNAfUC3A3eo0KpS3980V19cqQyZAfgZbtfjjYQspdQd47SqosRkNEoKaw3dz4MVDEkyuziT+hHXvuT2ZzJZTIQ5uWNx0mXXCLrnctyJiWwxwuAFouBsfIDqjEZKSzSnO/fDf3lh3r8Fhg04uGXKyMorDF805oN4zItwG/e4L5CmmAa217X36DORbw3v4HSLQAQOLnp65isemdG9KRL/SOEsqiSL0GxazYPt11bHn4lEQYEPxM2RisjgodVeco8DxOGh+19fv2D/GaKUXQ+SLO/VHit3DM16O/ibmkQK/xxYxvwu5gX4bQFLMwbTro/VG3uGNVtKCFIEcPOxC4sIurmXnQycTMpAfg8rgGnO2S9gVwq72avd3kwl+DdYofmweQoCcsfztYxtIG+nXiJ3W7xja1TPMxQyceY8YszBsWolQi4XBrAVItHqipw5MaWTAHCpko+GQC52Ktvbk8qXDRuzr32WoHNju9pKioiF0X2h/bQ4AkCWgqrRGEF52OgK8dFep9uocgyGdmm9ndpSjtCoveSiS16E8jXXuhi+cloRfwW44eDpHPvsN2Bp44stHEOTCTN3ZdMd26iB8RIBo2nE0YYyXwfecx3FPv41Nk3VmteJu8oIrhzg0jUyDy1PGnSzQs5JpOMYfxuo/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(26005)(2616005)(478600001)(38350700002)(38100700002)(66556008)(66946007)(66476007)(44832011)(110136005)(36756003)(4744005)(186003)(54906003)(1076003)(6666004)(8936002)(6486002)(8676002)(6506007)(316002)(4326008)(2906002)(86362001)(5660300002)(52116002)(83380400001)(6512007)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rp6OvUoLrynkk4wIUzum6eKuo/TslobK+UwadVdPMiiqQT4rLjdPaQVVYHaW?=
 =?us-ascii?Q?RULmhm7gpVJae8XNSOe1c0mcn2dDJcGyWsGEboNzIaZWwEpKiafz/RlxWsz8?=
 =?us-ascii?Q?jvr8zBlgPF0Wv6UHPKivKf+XNoHmTb/Z4BhjvQa0lR2KMbt12CSuQBhj1Gz6?=
 =?us-ascii?Q?OiAQsLRSvOOUY5PJnG8+6KDWuqK6UrSXuprbiPtjuKQyeNC7BsGolzXRIRgA?=
 =?us-ascii?Q?CW8fn7MfF0W81SaUhNUZSbwXtSxrdpWzZtDjQfO8M4B1ZH9Wr4u6HCFHtTWc?=
 =?us-ascii?Q?O8ArtPBo/dlejTPc3lavDh85PnZSAqtMfiDq81b3y22kdlvM2xLw/uOry034?=
 =?us-ascii?Q?Joa1sbENSnNNebKOV2Z0tVHxuDf9xDT3eJXv3edhbFj8v2jqi6dKn0/uL41K?=
 =?us-ascii?Q?ubxnC8f7AaTSjkZSyRBPjGBf5s4eXaIJbBmNMlkp2g4cO8N61jZUbgh5AUFu?=
 =?us-ascii?Q?DBEmvrcEKMt8HvdHpBONjCSadVI1Q09SZsS69uKuYejxy5f1HHnz8WRSrB6M?=
 =?us-ascii?Q?Fq2rf1S/+pAm7E9EevohnYSgjTgvBmuKfkRJ7bTt8XbcruhwBGU6OPvUStQm?=
 =?us-ascii?Q?Hd7wAGuDBrvyzfkv8KGy2jhy50icxCxKNKLJTB8Z7SWWTYFzYM/+YLfsHX57?=
 =?us-ascii?Q?C/tbcUOUCW1KgNSvcmOBjKcDcg1QmSrjyGiGGAZXzOAEEhMcWnElB1IpLJzH?=
 =?us-ascii?Q?9LGPnn81EUz+GHK9iup1qmRz/TL1mN92sqccu83RrojhR1lUB9o/ly70B6tv?=
 =?us-ascii?Q?fEjFWse1dfSQkVP1AYFArbt68YhY5raCD5SOCNx+ltlSt/6rZ+QwNUJa4h7d?=
 =?us-ascii?Q?cBexsU2BM6cTEAAkS3EvTMaLKOLZDqTSPMhTrlKcrxApsSAUYVtWbWSm9bnq?=
 =?us-ascii?Q?5DwDTduILFTaSEQXpcHEl6o/jy2wxk8zIAs8rEi+lbg6w7D/teMKHuSJQHzj?=
 =?us-ascii?Q?tKUPsL3FePUoDSI+5MAODtA8EvX+oiBrknGOwUvwuJDyICtbGABO2G5Typ5Y?=
 =?us-ascii?Q?LM8uL43WqWyG474wdAU+qa+oj+A613hw0JUBd1z+Wdbk6j19SfoT9LXbBL68?=
 =?us-ascii?Q?78GmtRwEsg+m9LpYnoIQHviev+JtbPsz5AjjXYdWNwooYOgSJ5v9ZUfDV9yt?=
 =?us-ascii?Q?aY127tZLuzKoVrqoT2ciYPmIrMfWyrotjBNYssonp9nRyaJ2qwzbij26PtIK?=
 =?us-ascii?Q?xxm7Io/5fVrwVYhq7D6mdsLSII9avY+I4h/BhmHuMcysYcIBdKEYKhHVMavt?=
 =?us-ascii?Q?a5Wt1gsfmGRxvaqedsackuDGOe0Uy/wm7s8jaa0P+V+yjgUDDyCajXYkqJfl?=
 =?us-ascii?Q?GwvGNyuHFUThH7FGijeX9bFi?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae7909b-4318-4dc7-77ae-08d95cbf88ad
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2021 11:59:55.3333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vrRvh17GLEUHg8mHRrMI6uSOPVuLivMk7v0i+JIbmypTTQ8Fjshfq0SAp+LPGuk+A16nBzXX3WU2XFM18b/RKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4814
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The call to sja1105_mdiobus_unregister is present in the error path but
absent from the main driver unbind path.

Fixes: 5a8f09748ee7 ("net: dsa: sja1105: register the MDIO buses for 100base-T1 and 100base-TX")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b188a80eeec6..49eb0ac41b7d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3187,6 +3187,7 @@ static void sja1105_teardown(struct dsa_switch *ds)
 	}
 
 	sja1105_devlink_teardown(ds);
+	sja1105_mdiobus_unregister(ds);
 	sja1105_flower_teardown(ds);
 	sja1105_tas_teardown(ds);
 	sja1105_ptp_clock_unregister(ds);
-- 
2.25.1

