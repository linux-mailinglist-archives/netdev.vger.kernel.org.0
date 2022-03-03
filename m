Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9129E4CBF61
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbiCCOCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233897AbiCCOCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:02:40 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80058.outbound.protection.outlook.com [40.107.8.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9383418A7A3
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:01:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I75cjeyQhmhm7vzvlQ7q+43iXFb5Q4baFwJ9ZqKdFD+/qPupMruscvoqsjqPlBQE0oTEi64piqkY42jMot+EHpl5k23xhiv+t2Y+jUHP6ooMU7wut/fmY73mNlM7ktgRDWFMdl7m4Bg5leJQSU+sWMeNUxiH9e0n9UQ6TzXIU2ir2iLxumMryzS+xUVSyoooo808bxRUrK9q7d3XjJjVOF6XAubayFJ25+/iFikqcgjX+YNuyhalWqiRdNr/tYIWtVUcwJk2SUtTVVKxujcf4q7TD5bZmI1RM7EIVcKFpDbvh8IsJDSMmfEs2zEYbraY4OkICaw7fd8T4Ga84PaVOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V2hfvEJ8NswZDhd49YRMv5jBaduaUelLKlayaABFsmM=;
 b=C0wkNMGPCjWsvkDey9LX8PV3oWokpkODXNGw644sofHYttB4a6AbHvWJ4ZO5Zc1JkIb6NPoak+60urUgka7IZFtSuiaQ14GHnabwdU/Zw5MZlSbgyfM317ECE64eO8bA9YH0IKufpqYZ3b8IaD0TBxAdcJdLff7zqpKa2gA3pLkvXPQWJumPSK0m6RXI4XETWOQW6+FDIfxUocLIqVXxI2o8rua5kY/ykiXPSQQdNwF1Iqk5vAOCjx9pDx+T62dOOLjPKg2hzj94woxUhzFB/VHX8uNzmquIJfqikpTvIxtbX1OzSHs7/WRkFwrI4YyvTlcvSnGQsSEqvlphxK4+YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2hfvEJ8NswZDhd49YRMv5jBaduaUelLKlayaABFsmM=;
 b=bRcGR/PATbkA+w4lDDQ40maXHcmNDnYS+aJSXR9hFWl8qrQI5b7qN/tXuswTroB+5hNbivWM6N/spt2D7l4//eApHOPUZNOJBYeVHkUiMR4gk9KRbuC2cewpDnrCMuZaNgU9Ipg6+qREmOWavSdxWIftNPfu3IcehpplRVMwjC4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8879.eurprd04.prod.outlook.com (2603:10a6:102:20e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 14:01:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 14:01:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next 5/7] net: dsa: felix: initialize "err" to 0 in felix_check_xtr_pkt()
Date:   Thu,  3 Mar 2022 16:01:24 +0200
Message-Id: <20220303140126.1815356-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303140126.1815356-1-vladimir.oltean@nxp.com>
References: <20220303140126.1815356-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:803:64::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a997896-d228-4e4f-044e-08d9fd1e5aa4
X-MS-TrafficTypeDiagnostic: PAXPR04MB8879:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB8879B6F553DD31669270ED72E0049@PAXPR04MB8879.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 04L6jtgvYWg9H7QGdIfuqwK43Jw2l+r99rCQM2pKdKDv85+B61/KkpQRuQCMKmADamIcnMpjK1WkYzqw1ZhL+Ni761lSOqs8vBeAkZbpO+jDCee5MII30fTB4Le7rwCNHS3ce7Sxe+6kT1q5Yw+c3kjpKrRQ+mkiAJOzqP8Ek8ah1Db8CfT9nRs0PcnMXnHK/AbYYWJPcAVpbEGzKycsVQ1d9Sc5Q6o4yz5bW8ABR/Hr1ITLE1rN52cLtDRXtSCdAd7Rxx3lqAROVDdqI6dvaclRdP72uLWXN2RBuDOSFIxtvbTDwuma4iHnoecWdTNiszt/DmVrJOS+9Att8uT8/nVFpxARxJP1IGzUpgLQT0ItyrOA55zQfPFvB2DFk+xp7pZ3N9zqxNTvRgvuA4LHa0owjtkiPnYP076uf28NZROyUfOhiZhRyIFhDPWEOik/qm1CTjBFnQEeE8UeVZsDLlD9wI8SAtyrQzKFqDbN1B37q5kcEl3yzCwjYPW0t/VKMzthy748gI+u0zJXFjqe87gxHAIYKu29c3Dej8uHtQtU2eYE+ESuylUrubM2rqz2DJpgwJqn8ASlp8ulai3xCDf1TCOtdCqPre3f/w+rLz6MidCEeWlTzI5koSlvsgIPkbpwRQdZwjXsHBi3GfWjRKMQeo4hX2TyjO3PaDLS34IkiqZNDdCbLuDgJVmUUg6ULJiKkKtf5VzlmAXcVzMwzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(186003)(26005)(6916009)(316002)(54906003)(8936002)(2616005)(66556008)(52116002)(6666004)(6512007)(66946007)(66476007)(5660300002)(44832011)(4326008)(6506007)(8676002)(1076003)(508600001)(86362001)(6486002)(83380400001)(2906002)(38100700002)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vOdrsI1ANUal13CkoQm5Y3Vj6gUktvkMml/R8sX1iHkf9fMyraxXlMrUmn5N?=
 =?us-ascii?Q?qn8WMRa9x+SlK3CntNh360KIvahzyokIfYU0mosut2S4fWKzmyNFesVJOw/I?=
 =?us-ascii?Q?6neVUh6qubBM+M13T55MoyC4xjhu0y4+190grPIRGBsa5N85Hs0wRhEz6xDo?=
 =?us-ascii?Q?yLV9iE9Kay0W19//gaGF7aOe0w8sFM9bwlCnWvGrfJA/vfdmbehtY5LpEoHS?=
 =?us-ascii?Q?HJk0qow5DX+3BKLXm5FsWN8VoihtvzRY7lB2JGs8rGXcnCxROHN1rdS/mPo3?=
 =?us-ascii?Q?behaNNOMTukz9dap1I1XXnWnbStaDm17na1JmaHuZtUGnw2op0faxehpjJVb?=
 =?us-ascii?Q?O70v6/+HswGROHdVMGHyvbCqjO4RTwqWbwcOieZE8XyLSQ+eiqySrJ/7fcN3?=
 =?us-ascii?Q?D1CqHPew0i4JCgYLjnTy7n3bYf6hw4SIAz5Nb1CMm1hv25IiZbnIqrj/cKkC?=
 =?us-ascii?Q?es7EV2LzKHaCp+PGgoui0dtc/K1GfgNe/ch3YXz/dmF5+lfIc7XpMGgLKe2/?=
 =?us-ascii?Q?AiXVtd384GJ/xLBd51EV1foRIZnM+6lSqtODIR7knkxwML43gl0bSON0OTF2?=
 =?us-ascii?Q?WJT7rWGTyN8nwV5edRPPu30j5IYdeSU1CxgjuE+W4faQSkusmRMld4bmVOT0?=
 =?us-ascii?Q?erWS8cLjfdIJ5iKHms11aMzJmS5+V6yPZ/O8XeZbKsAIdMZ0eaK9nzSkZC6c?=
 =?us-ascii?Q?fvR8PI2W1MtBmZl3a4h6BlzxKR510CKvVz7ZRW/41ZbZwC3XZ74rne6EY1Bb?=
 =?us-ascii?Q?Zj1hrYrRrJrO9i9fIkbAWrO47tTwW0vAGSjODF3eXQEq1hCcVFUDBndar9LQ?=
 =?us-ascii?Q?7+V1dhINk+QSmoLX7mEcGCkYdvc9INdsm8YMf/ucd6RovZvhhoJq5ZcFwwii?=
 =?us-ascii?Q?AOTXz+oGLHTiW89B6nq/R11lnrn6efo9ktVo+Pa+PFjSAotI2tgQhNcDnsZd?=
 =?us-ascii?Q?bSKxnu037lF2PuTBi4+ZS0sCCXPahmKa6qBAhxHd/wfu17YQhAR9qJeUiUUH?=
 =?us-ascii?Q?hIZ2/ikndNWO8UZ+9pQeDWHx9YyMchBjoN7KwAAMqNkWLQ1MXEHjnDxOC+eJ?=
 =?us-ascii?Q?cmR8gJ0RHmPjqV0GOmMHCsICUEK+egJqxgc/qpvSPQeeA58jn84QQdvroBsp?=
 =?us-ascii?Q?Xypwk3KIIh1mjUobYUvcQ5CwktUw/VCQjtXRVNv1PcGUBV3tKiKk4Nu3Lo9L?=
 =?us-ascii?Q?sZcmAgxl7zrAYKqzzlTDvc5BceAO7Aziy6s+HisRQsUyK5F+xB0izANirSEb?=
 =?us-ascii?Q?kpmjVNAXRiVviIB/+9rgNaihlnqVuXd86uIMPkdxnOjJFxnJ9NsertRPeY3F?=
 =?us-ascii?Q?gSp0GBkGsrnCCyTXFizE18+OC/MEm/6GZmq7Yv4K9mHv3pTE54qkU3E5FpsY?=
 =?us-ascii?Q?nHUX+51M1kqk+y1IpUKMSpAQe2tJTzWdaply/hfgBYfHAUHvxpHW/6Jv08BV?=
 =?us-ascii?Q?DAwm4WFtUXjmSijdTyaWFar13weH8qhA7DyVAfQTqZeJ8/vTTtY2oFs+q6KP?=
 =?us-ascii?Q?/i9R3q54tJrggG91yCD+W+qT2o/7IrtWsi7sV+gOe7RpI2hzdxPaJwqODLLp?=
 =?us-ascii?Q?t91H4Ymx6Bg5/liCH9xak/CvlvgVsxkMlzJI+LUta9f72nF6t3fLwXsgaSKE?=
 =?us-ascii?Q?84LQN7Vd4Us3dDWi/QmysE8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a997896-d228-4e4f-044e-08d9fd1e5aa4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 14:01:46.3055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: to+qDWDyp2U+t0IsAtArokwDPqeeciqcUgzGjW3GrYgBN0i44Y/ePuu7v1MSTlker8lyNEJHkWiON2nku6xRWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8879
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Automated tools complain that felix_check_xtr_pkt() has logic to drain
the CPU queue on the reception of a PTP packet over Ethernet, yet it
returns an uninitialized error code in the case where the CPU queue was
empty.

This is not likely to happen (/possible if hardware works correctly),
but it isn't a fatal condition either. The PTP packet will be dequeued
from the CPU queue when the next PTP packet arrives. So initialize "err"
to 0 for the case where nothing was dequeued during this iteration.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 24963335f17e..5c4eecf3994a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1334,7 +1334,7 @@ static int felix_hwtstamp_set(struct dsa_switch *ds, int port,
 static bool felix_check_xtr_pkt(struct ocelot *ocelot)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
-	int err, grp = 0;
+	int err = 0, grp = 0;
 
 	if (felix->tag_proto != DSA_TAG_PROTO_OCELOT_8021Q)
 		return false;
-- 
2.25.1

