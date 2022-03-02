Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F824CAE6D
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244913AbiCBTQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244985AbiCBTPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:15:54 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A36C3C2B
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:15:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6DO3e3nqGOzsmcl0falD4UGWedzUi5DL4kwtnPlWwu06FAhkfhzJ3ziu6LBZrZw/Cb7mQ5OEvJI8iqKJaIlUx/xSpWBUGINVsMejd82CbmMGQ8DXkJEr+zrn8cHn6nZA6PyqHsVfpT8pIwJgicd2TIAlL26lwr+bdMH5XClcGCr4+BHMqeMTqZu+ZcTc2n/lHCZ4GeLt777uApxxbieUx41NHiUgDsbvJZZGGjJu6niZYThxpvwPW6iarr525VcCwam9pyWj2955ZuHCCWmNAXJ9aF8x32fHG6AG/qj6cqIX7yLrrMQ8OeQRgeXiKhuLqHTEjKlIBwZQeoWpCRfUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j7vypvuIAMIxRvzDUu5XSorxp/4dvEm+xn9iShwEnjM=;
 b=g4B5mSNyi6yjbnCeql36bKWk9JMk/QGkTdeiAzLL2E6CreIf3INxAf2SnPkdSB+y7Q9le7iF+GWZrsGWAjb71z+s9nSM+HPepKaPmBsy7rWPQAdUhxkHCP2wpQrb2a5E6+ww5Y/dFNtwooIIfJ+TyZDruz19cLy6Dt20gXpxqpmtR531fi+Kn12IlMFeZtSLQ7awzmmsUfktC5S9lUcQn9vAjarD2ENloMrw7c1bB/OfCor5WlkkRf5c/kW0PyJZxL3p616re+ifqvFjG6YLIUYxMDVL/o2NeUHAyCAj0lRiqxvpw7pVNmd9ftkvod4/CZdR/yc199FzSnDH2W9IkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7vypvuIAMIxRvzDUu5XSorxp/4dvEm+xn9iShwEnjM=;
 b=iwgHtUuImKMt8jczLAzl3hARExkwgXXGj+iv6A2AhU8EYqUC/RdfpV5e31qScXq2GfmsGNY0eo/FoatAxh5c8Ckz8K3+2ILqzHa1O+So523E4zq9VMBE+xAvYuFSGp6H0i/nOdLD2rnNj3xbu1dB4P9nTJICESFRtfEU3vfA2hk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2911.eurprd04.prod.outlook.com (2603:10a6:800:b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 19:15:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 19:15:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 09/10] net: dsa: felix: stop clearing CPU flooding in felix_setup_tag_8021q
Date:   Wed,  2 Mar 2022 21:14:16 +0200
Message-Id: <20220302191417.1288145-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
References: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR05CA0030.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 118e7b71-0728-40ed-e233-08d9fc80f3a6
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2911:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2911D004411D83BE16C7494EE0039@VI1PR0402MB2911.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FhSoF9OMnf5uAhpkMAkwGMX6nTOJYE5lajdNEvDDCsSAaSRqjd/xLbcN25m6WsrpePCJ7v9rRey0jUDYrrwYSJno0dUy6qf75qFc2zJIInwaq0P71iQ14dP+U4GDYpoQ43lcZoq6H0FCQYWNSZBUHIKn+SUng3vfyeV7BXH9sNOmkU+nYpaVPJXeMIXJQ+WkzhNnwX8m9Rk2zCkLccJG/chsw9uwjYyTIuLpoqmPwHqWjobVCvXuJ4OtHGLnrOQUZjBX4Qy9jyIr2e+YsAGYZYg9PnZAqFd3A8Oj2vj+DsMD7uosM4rJqPIZ+0E/Uf/0Cef6lSYcfJgZA53dQSdlgaLvGhLhinXikBlnR2DE+MnhNNWFCU+Z92OZZUViBFUq++0QwEU+NQWMDh7YhfetcZcL3EyhLpi6UTliy0aE8zrxln4OcDaLcDF6Nv+xNIKHCFHDk/y5wF0y5C4C4EGM612hzjBzweoQLCKkskeIRnKHoKc6JOlbUBw5LPMe2nVn5U0j2gAEuYOx7KjY93lYOumtlYaGdZptCvxR3Lrj6fG1X1zn8vLWOdl29ezQnW9WEw0I1WvXN8/CyQgLv8dUmeHZlZvAnFNCw11b0sMojZpQ9h4L7hkZXmap04Wkuyk47Z/RFIRQPFiNKx6ccTpslm0Y+mLADZZzwBHpP2ubKTW/4mOpIYsFf8k/kzIwpiY+tDNTK834zpbWTvvCuY6roQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(316002)(6916009)(83380400001)(5660300002)(8676002)(4326008)(7416002)(66556008)(66476007)(44832011)(36756003)(54906003)(66946007)(52116002)(8936002)(38100700002)(6506007)(6512007)(6666004)(38350700002)(1076003)(2616005)(26005)(186003)(508600001)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PZDfeclAJWDhH3GSrusYFI3trpEZHTL0OhcSPmtMM1u48iweZePDHKzUKLQp?=
 =?us-ascii?Q?us0Cg0RrNfzm24141TxDMr7Dif5B3TAyjG6YetyiGHXxFbY8WRh/NtI3AwjU?=
 =?us-ascii?Q?MkBxgptYDLKVXLVX2JZtdV2ZGTpLbGHnYzDFfyqrUDkrmZQYnqDPio1OKTkZ?=
 =?us-ascii?Q?Lr7pEy23dKZvDJLbvFd2OCgNYYnK7BnFRJ+4zHpwx4LpwY3kJutkWnxy2IEn?=
 =?us-ascii?Q?vf6nY3Dv03IJLyQvfipNpdpGi5PPhvWT4TGPZ/11ywxDNwtH7bGeUgeQQf35?=
 =?us-ascii?Q?IoBcmaGzz7m7p+95ebLU4eDbs5clhN9JOvoyqTtuve8MB5W9fHowPcF7/JEg?=
 =?us-ascii?Q?KCXvLuI11IwSb8cUD4KOnq6/W6dyYaQLZFZz36FIZ8xuPPCtS/Qia4l6C4AS?=
 =?us-ascii?Q?BOPMhu1DRxSUWP3BmT5tap6YWvbwflgpfqWMjALbyqW2F2czomac4QobZIEY?=
 =?us-ascii?Q?3+MJAW9d/9VUi5je41uIuyobvu+yMKIwxCni5hdEAetaipLyvBlEM+dzC3rK?=
 =?us-ascii?Q?KgQA8kKczKXmCPQrNRhZWAHZuRdSQe9KpPQbrnwyEa2wUC1kEBDjItIRG/In?=
 =?us-ascii?Q?qlph/lTmTI3D0WtmmSFp1xlT8tnyXYSMt9pRfBLsJFaGQOCgiM1cRfOPzeFk?=
 =?us-ascii?Q?0Gg1HNrc5SnUAKA7rxADZbdEJDsmXWLJ7bftjdkC/SeT+WfkAgtcnKoXxMRv?=
 =?us-ascii?Q?0AKwqhO55oJTxvaJxVyU+8WNQlz+peXgUJ7gdzeLGe5NA6wOVcM6hOl+JUnr?=
 =?us-ascii?Q?HhJm/zPngFBUZ6Fapzsdy+9B1+hN6p4YtxIZgE05AF2izunnD8Ceolswho3p?=
 =?us-ascii?Q?JBrVvNY+Xgc4CAgqhfbBa1MRz9q1LS/RuCcyzRzOG/brwHWJxjRIFv+zBSr8?=
 =?us-ascii?Q?uZvCO07IGdhmR5TInFWySxIwJWzdhIdCybWiRytAM2CJmz62TuJiLR/JUn1u?=
 =?us-ascii?Q?hfoN+DhZi++AP/pBIiWLjkGzOEiljKNSHXzv1Zms+NnJzTaMKM6DuaNTrCgJ?=
 =?us-ascii?Q?N+zm4Orpiy1vK9CgLg/iiS3SFvlnDCQC6HEENweLGl96Sndo+jrrHKWJQCAC?=
 =?us-ascii?Q?JLgt4Z1z31OUNZgeHM8MF3qqRblBEiiLG68NlsFibQbggqCrln2Sg/775NH5?=
 =?us-ascii?Q?kjBGrxCEfbG4gtHmI0MXBFJXkCj6Iz9ixAtO/9YbMhijvsMoMdLmhyF/M1lG?=
 =?us-ascii?Q?X/hovPhXwF5PhMbCHug/YqgdHPytBiMt5M7dGOW3oAc63xkCIC7zjlrgQBNC?=
 =?us-ascii?Q?0HrTQzjBzp2wqEbJ16j4wGLsaRZQqvxUdpwFEoUs9H1AO2v9mG8yUxR5ex2d?=
 =?us-ascii?Q?3p1lCrpVEyEHfELXIbIa7Ksff7OrGs0LFWhzMAVi3zsbCMbvMVDuie8gZSzv?=
 =?us-ascii?Q?MOFNtJ/pOnQEKoO6OQPgU7UhvIbsKw7prHHD4GBTBOxGEewc+A7XZEEE5hJ/?=
 =?us-ascii?Q?AeZLsor296++17pTv63P/VwQatJ1oUfLabQeezJFMjcJqfsu8+O8hJoIVM/l?=
 =?us-ascii?Q?SoiDoNZRNo9hK/jJlJOQgYRtiMWXyU43FgLRfTDZkJVFGLt6EgbumeXHVbxC?=
 =?us-ascii?Q?XV/t2v36qTUnz3trGnnahkaOQQw2hmTBYIXhmY4QAPHFhwIwE0ij6RGMK9sS?=
 =?us-ascii?Q?9UqH9XECBt0ZmtNfesvo780=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 118e7b71-0728-40ed-e233-08d9fc80f3a6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 19:15:02.5012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: St8IIDgYmfuvhL2qc6SXCrxjEhOBXskZ2+CWpyPmLPOd2bbQu+V5mD1mrrL+kZV9njAKfIooY342iY/jMqksyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

felix_migrate_flood_to_tag_8021q_port() takes care of clearing the
flooding bits on the old CPU port (which was the CPU port module), so
manually clearing this bit from PGID_UC, PGID_MC, PGID_BC is redundant.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index e9ce0d687713..638f420bf599 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -465,7 +465,6 @@ static int felix_update_trapping_destinations(struct dsa_switch *ds,
 static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu, bool change)
 {
 	struct ocelot *ocelot = ds->priv;
-	unsigned long cpu_flood;
 	struct dsa_port *dp;
 	int err;
 
@@ -487,15 +486,6 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu, bool change)
 				 ANA_PORT_CPU_FWD_BPDU_CFG, dp->index);
 	}
 
-	/* In tag_8021q mode, the CPU port module is unused, except for PTP
-	 * frames. So we want to disable flooding of any kind to the CPU port
-	 * module, since packets going there will end in a black hole.
-	 */
-	cpu_flood = ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports));
-	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_UC);
-	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_MC);
-	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_BC);
-
 	err = dsa_tag_8021q_register(ds, htons(ETH_P_8021AD));
 	if (err)
 		return err;
-- 
2.25.1

