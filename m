Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748944CBF62
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbiCCOCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbiCCOCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:02:46 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80058.outbound.protection.outlook.com [40.107.8.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E180518C794
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:01:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/lrNEyk3411UWaHmmiHrcmuGcIXtFIVDnIjadSZDSoUZbZVertsNV9cbzVaK7ndk0SU2IpSE7mbNrx+pn0ht5jp8jk7nfc64H0umlEaiv4ORfzNsw7w/4p2/j2qbpJ0JMm3lwh8aRmrlYk+OGzFA4if/QTOA+AIQitqdMypyMMJQpUDgep6blP8yt/CJhpj0qCGTw0Ujda63IMjvdKWmE45pbdBtiaiHQrMWACoDLbxbW1IQQ2AImXyrtFDdNDjdxyfGQU9d9anDYCp751YpE/SrIoBFVWX6N4rULnSNgIqi228JhoRX32AvXiYPCRdeNdo/tp38ZhwDsBXnmETnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NYiaZI+9AjapZ5ypcNkQNrj9fP2W6B4t4VQHi0wq3HQ=;
 b=JifReDgpj+TSE5iIdqJVOSkCkvXEs2wwZDNjO5OV0R2uZmwU3JVyxJ9GHRZ9BlAg9Dk9kNsYEgnqLEdPmyacb/JJ03oiPprRAWRdUxep2xmOdRdmApz6m9DRFAOzKSqwzGKJK/0I7IgjcWFKvMZS/yKSM3FuJxyKhqe5S53suk8aZzA0ThIgOM/8H+68i+IzwVYd1AthO5O4gXopB/tHWoHBHb1jiHGixa5St4p4vTmGl4WM/i2jvfBecU9PooliS0jXFtioTNxrEUyjtdsYnuQwcER3Lb7s/QJGZqz7GPfAMoUm3EcuVbqj0YIBEx1Piey3PHuNbuVY+sNAqyNlGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYiaZI+9AjapZ5ypcNkQNrj9fP2W6B4t4VQHi0wq3HQ=;
 b=WU0S//dFhyhApjy72BKuthJTZO1nMMU6q2u8eOLRqI3T1nuIciGkEWulQk9VD3spU+HLFg9HXGWJBAyMaLgx83zMAB2Cve61+1LGV7mXBzUhmbM9gHD05mN+sebcPqvg50owmOMJDhSYgw+QMsAZi9sNJOPpgzSP+ZspzlYW3qg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8879.eurprd04.prod.outlook.com (2603:10a6:102:20e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 14:01:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 14:01:48 +0000
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
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 7/7] net: dsa: felix: remove redundant assignment in felix_8021q_cpu_port_deinit
Date:   Thu,  3 Mar 2022 16:01:26 +0200
Message-Id: <20220303140126.1815356-8-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: e40267b2-b4fd-43fc-1b44-08d9fd1e5ba3
X-MS-TrafficTypeDiagnostic: PAXPR04MB8879:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB88794337E49445B2736690A5E0049@PAXPR04MB8879.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tslZz1HIi5BRqPBqb+LptKMWhUN3XyXym7FfwhdO9CB08gm8HgXL+eHTa87HOlXcWtkdmRMY4oXw8J4gWFG2rPyVw2HTMzE5MVNqQvfEPqzl1WIr23RMvPhs1v7CXcU0z1Sgv2P0Y/64B6+gZfxvtySHst8Bx0lx3OcCZdS+zmpeNMEYo9vT1VupZzsYmX1PRAkPfi1SUwiILroq5XoZyC8rMLn3f0hqcWpOtSUsKTa7LMpAY/1LDv8L2LSrqrLzyTROCNtGbIoo57xe02Zx5tlbwP5k3CooK6+ffiG3+jck1ysHnKGtet1RW1FZpQiHJwMzlSAYNyJ1YlgDf6Zb5gzP3OdGsIgn/Vi2u9G7OpDjxrcVx3pwyeGbiyWpsoHGSIMMmlJrPyEUfeWVkfSDNi52Y8V7SmDck2mJqDyEOQr1ACwccta/Ra2xymSHC99suIuFw0bNHHg5k2pZUnsHrfATrZP/lQ9lt10/0Glt0vPQERXh0MTIi/ifH+6VdDxEZeQPnnd10lEME2bjnniDdjxMdENRUR/iSV4F/MWz/grV1tBjzwEQOQmr69F/qyOV0wH+JFPD8nCmjFk6tQoqGv5GvJ9QpdpEHZnXtlLhTprVpqT/GMuRwKxE/wXwJRI7mlsSUep1skceWb2VAHurM+GSIllp+/1TzGa/WLidrchNmFCScxYo72iKvk8ZjCZvRTJaTx2CGchk9uR86W1H8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4744005)(7416002)(186003)(26005)(6916009)(316002)(54906003)(8936002)(2616005)(66556008)(52116002)(6666004)(6512007)(66946007)(66476007)(5660300002)(44832011)(4326008)(6506007)(8676002)(1076003)(508600001)(86362001)(6486002)(83380400001)(2906002)(38100700002)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hI6SopC3MPBGGGglCYGnAPSBEgDjoPojEky951k4Zwtq8uFcBPuTNyh8ntSb?=
 =?us-ascii?Q?2h6JNRhscJfrUWMDs9JkZsorXfJTd2Mqt4QUXAqW/8A4wrjbHUMOdZfcalbW?=
 =?us-ascii?Q?DOs9/sFoNr+rYm6SCD+iUbc0rj0qQwZ9ZINQWHNKs0rECft3AHU4f4KPBgTC?=
 =?us-ascii?Q?ApacopkVswAK3D+fxj5XOq6mY5eP99ieYcGTBi5xUtB0DM5DcqHWQKx7kTPu?=
 =?us-ascii?Q?gtMckByxDQk0PP+qySk4jWy4moizAGkj7y0JIvoblNdol+L4JQ6Zd1RmIgam?=
 =?us-ascii?Q?yNcRQpUpy2kMvsfOKU2f+NEC6Dr9B7oZc3RHm2msN+f/ltSShFIEcSYgAE1N?=
 =?us-ascii?Q?AilHsiIeMIk7miCVkWCqumjKnN6ycuazSy/N+GQimRPVXiQ1iHkWU44/tQWL?=
 =?us-ascii?Q?YisFmXzgkHVw8bL004Zvi4TZs/mzhLoDJK6Wepp1iwySRtcqQGDL40p4WEum?=
 =?us-ascii?Q?gp+aNnOvjr4nEMXVjf4PX8V9S/zOpargQ1KEbqyHdICaVT0I0Q5DwhKtXOtc?=
 =?us-ascii?Q?FpDpr3hYiCrRNF34JFRfqOd52JNqLh0yresWBCwrnOWwoaU9w1lSQcz0brwI?=
 =?us-ascii?Q?wnDHbxZ/l8H38XzeA12JAbZi+NhYLBb81VQAzAUB+x+Z0KvrzSCbV067fO++?=
 =?us-ascii?Q?844pU05/6GCPgcyv7oe3o5PElGnJB3z6dD8TjjIGmL/LNWWLgGm96ZL35r6q?=
 =?us-ascii?Q?LcUwUuTWKclBaZzZON/nn+KIPtkvKYmRUTemJIEMhqPPg9ydr1prhBIpXqHG?=
 =?us-ascii?Q?DrwAAhozWJ8VJeiri5OjildR+3VxZeTby6CsO99UW1VraGmJAnoKVyPWEngi?=
 =?us-ascii?Q?7BwYE+oiPBReQehNd5QUu7bV60AB9g2Kli4Fj7UtDnLTko3WoQjiOrVxM1LV?=
 =?us-ascii?Q?yQRXrpBrrXRTmVa2lhY9aICDrM3TwhgolQKzltS+MhwptZatVC9m3LGCRrxV?=
 =?us-ascii?Q?WrIzbeesYo4s0zS95JZmJgmJHoDo/txih/aYQyAnH5ICofdT1lKAbr4qmcbV?=
 =?us-ascii?Q?3IVcWASpwYePC/+m7VbaGRusiqVKi30hf02uvFAV7N2GhsjKwE1yRCEA3FRs?=
 =?us-ascii?Q?31yv7KK/Xzcuf0kHwPTZidlzrBPQSYo5iDyMo39naHu2S86jJUBPlrMZiA6+?=
 =?us-ascii?Q?jCPqn1fDPcuk4inq7iJtKXgt/HzYqVX+HKM1rsb7r3IXnfgJg+EWlZk0OFr8?=
 =?us-ascii?Q?g6xIUJHLKTP9x0rrH4NkYSwiQPnGMRFtNKDbRks6NSs6kDGVynXVmx8z+Xy9?=
 =?us-ascii?Q?N4jwt0MTooaUIQT2A8C2QxLUJcOMmcAvRKrkHj60DUW8vNJYDQoWJu7qDyaA?=
 =?us-ascii?Q?A1z2OhSxyk0dapkAs+ppwI4Fg6o5biIEejzlMlLz/QrACtxYFJ68V8uFsBEB?=
 =?us-ascii?Q?wv4BbnmGDVvYLNvw5sBn1OeeKKjgutryEHuq3oVfbZRDL6o8TdzwJaqNqmLU?=
 =?us-ascii?Q?pRv/SGIhUjvxiHMcHj2xJhNTOsjSXWQa4d44ii3XQOrWQ9AenBcDxpL/kpWk?=
 =?us-ascii?Q?EHnZS270Cwfdl16vjFsB4fF+ZpXRNaMRfJJQu8bjrLDM67g0Ys/Bm7OVmxb8?=
 =?us-ascii?Q?u72QXWIx5qZk18mU0uIQLyVBj6Vx5FqboMjn+oqU/kHVXajRR7oz0pbdD0PU?=
 =?us-ascii?Q?ZVD8i+f5LZX2nl4womf2fsY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e40267b2-b4fd-43fc-1b44-08d9fd1e5ba3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 14:01:47.9304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DaPgvAGeP2bJHvxZ7lVtMZLjHe+RO8QBTCSpxVTcN76iopBlbP481D371jhfCP1UcdSoZMajABlHGZrkHkIjNA==
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

Due to an apparently incorrect conflict resolution on my part in commit
54c319846086 ("net: mscc: ocelot: enforce FDB isolation when
VLAN-unaware"), "ocelot->ports[port]->is_dsa_8021q_cpu = false" was
supposed to be replaced by "ocelot_port_unset_dsa_8021q_cpu(ocelot, port)"
which does the same thing, and more. But now we have both, so the direct
assignment is redundant. Remove it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 25eb57058ce0..5a6f83fa4d96 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -248,7 +248,6 @@ static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
 {
 	mutex_lock(&ocelot->fwd_domain_lock);
 
-	ocelot->ports[port]->is_dsa_8021q_cpu = false;
 	ocelot_port_unset_dsa_8021q_cpu(ocelot, port);
 
 	/* Restore PGID_CPU */
-- 
2.25.1

