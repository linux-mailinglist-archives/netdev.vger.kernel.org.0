Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D727C3CCB26
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbhGRVtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:49:41 -0400
Received: from mail-db8eur05on2056.outbound.protection.outlook.com ([40.107.20.56]:53472
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233679AbhGRVt3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 17:49:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYGPib8yKit5txm5FIWqhXmaAkwbLkMu4njPHvsEkZl47HvciWjlIQx+PVXVmc/56nETmLm8lDZWkFL8+D2g98VBL3DHmTk5dvwbSJFvuOhi+YmcmLJ+1liGGadNCmj5Cpd1xoCcDMsDju/2iNdXpj7x1RsTz+OtmDCsqXWIMCrf04phPqTDUj0X8GEBSKZzvixwqOm52U/Z0FvjPlVZK/eFEoLbvXS+dryXZLbh7wTJxjqBotP/lfLXL/IfVFLk8SOOnoQ+J5akuJXtWKtHk8rCA1ouQsKaKZxOhl6CTbiYKI9MgOqUi+JCrb0JpyCL6XE+5wn3thxydORDgMRQ0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M86taBXiJCSKQqMTIk71KVAVbaMqAo+VCYTzVyMmeiA=;
 b=EhsL0ankpkeGGdxt2Shcc3NFiMmebJ+8I2imkQHNwyY3vYJido7IOpKbJvpiRlp7wzoeaY3D2l/ahL65hmwwwCYR3w8KdxpZjdjjQD7X2FxUAitOIkYaxRZ7fzvr/FKfR775tQdmC+U3HUx4cz5ioWy1RNgbs52l8EN924xjQnXFOXOOpuJBwvNdnyiV2vWNT4pVg+3YFrc1LfwqrcQFErMFboVka4+V+LOpsBGki1+hpRVDLKcuKegDusqd/0B8MDyESjRQP3WUE2qfSRpoTuALLJTtOgXzxXZTthhDaVKHgygqnu5+my5FAKkxHONBQCjjQ0Q4Bz2IEX6sbmvsxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M86taBXiJCSKQqMTIk71KVAVbaMqAo+VCYTzVyMmeiA=;
 b=K9Jg0449YSDCuosjTVjG8PmhEE68dhMRJR6+GIbnDryiHZws9wUrdPfMWhqJgnMkAXH2xBZPyTqn3uREMr+YManDvuIsvRyZiHaAaZUQP/zWndoPEO2sGmb5ic7TDFyWGShiluTWJ6aUCeYCx5lR5OLZ7cQAdQAc6pVGHAVDc+M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5502.eurprd04.prod.outlook.com (2603:10a6:803:c9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Sun, 18 Jul
 2021 21:46:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Sun, 18 Jul 2021
 21:46:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v4 net-next 12/15] net: dsa: track the number of switches in a tree
Date:   Mon, 19 Jul 2021 00:44:31 +0300
Message-Id: <20210718214434.3938850-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0014.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by VI1PR0602CA0014.eurprd06.prod.outlook.com (2603:10a6:800:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Sun, 18 Jul 2021 21:46:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdb9aa78-4542-4468-2ce3-08d94a357a69
X-MS-TrafficTypeDiagnostic: VI1PR04MB5502:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5502225D3EC4382D863586F7E0E09@VI1PR04MB5502.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MPeMEjSdisdSzBvDdFmv3NJ5NtcLb2L7WGvhfR8jPRxoT+lK/nktrqZoeEbs42T5l3eFR+z0YXzcEAUnhFK6ZVbXQRZZ5MBSAhXmP6tBrH2XuhWFZfRA0H2DWS0wCITt9VWUj+c1xliILmLMxKmGjxfnikUMZGU+qWoZDitzlMc3QoleNcqoqJI/R84OLO9TwBL4baUnn+GY3BIOifRFHqTNl7NIwMBBKdbBsfn9OhPEobRLLll4leugCpUfwXAjuJE9WPRYOBWff4tGwUVmm/nqD4fitISagS3SwyILl9Y7/YH5kpIe4NVRExcW5FtduPINx93LPURjGbAxUEC2SgA8zyBe/xAUnPGopZzuH7tHIhzimuwqjpfKdQ8GGqBB5Ll3gCQeBVZnYl1d6khXmX2JtNMNqyHaV/CyhBtoAY5SYemqfrFrUz31WANPeeRnTTt4iogvMavuPXGP627MXZENbWVwDXYUvm2QEVBPE4S4OypDc3oAW0plJgMEAR4K2o93/B8qKoZBixLRG4IFan3i0Sd7Ez8fNBt2dHqLAnwF4+WAG3gOZaHm/RRQlVRwAHxfckbiY5Nsp+XCZJhwPXextw92zUJXu7m2z0ttuQmwrqCqDp5hYPIdcIh+tLc2v8oa+Nr2DGmsOpGvB0qBwEYCCSzRnOxMm7SJp0+KeVz9z61uxgK2hZ9qGdfpWbi3zGQE3if86uLe4FIgEHhHdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(38100700002)(44832011)(52116002)(38350700002)(6486002)(956004)(508600001)(36756003)(2616005)(6512007)(1076003)(66476007)(66556008)(316002)(66946007)(26005)(6506007)(54906003)(186003)(2906002)(86362001)(110136005)(7416002)(4326008)(6666004)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FGQaT0+Kporw7qblIAIFPK3kEUVVJGHo7WuKZEId1ahhZglhcNsHMN/lJJ+u?=
 =?us-ascii?Q?pI91Pj54ukzChR1hZYdmpqBEnmxgDFNV8G+CyX4s0HpCL2bgP/qH5vem6syP?=
 =?us-ascii?Q?2MAH7WUBMZ6PbaKpERvmyGd8W/iBHOHBlyu06vFbj/5pegOfGpaRcB+loKbt?=
 =?us-ascii?Q?HmJYgQyOlIlA1Wv3y5ltScNntXHTDYzAEqCOyDRlVO/lQlZwA7V69a1TEyD3?=
 =?us-ascii?Q?qv63wqgKAHXvTf+f08/g4hh5lfqKv8cqTvNTr99kZRcg2zfNcNf9tzDX/XBQ?=
 =?us-ascii?Q?QaQngYvmQV4zfVoc0qyujkGycXlKsxo/syQhMl8jshADVaEY5pmr/mkM7q3L?=
 =?us-ascii?Q?SHTlLRJCtWeOrw6dqNEylMUfeqpZR8ypFnidLIvF/SY4aec+btj/xk576eUu?=
 =?us-ascii?Q?hXysDqNmFxVZCocGVWfrl5v4TAfpWUxEU1C9ejjxqpTs9fNsRBKwGxOeFwO9?=
 =?us-ascii?Q?VIxZiUJECU3gkBTAbrulSryMpl2dqElOKEz89nLFlqDFyLEWMfV5vQ+qquAj?=
 =?us-ascii?Q?EdOsEaFIE3N9QrhADZYVZZQ3f+tWU5HReMoHLAJPU0tl8Q3jbTFaTvuXtqS1?=
 =?us-ascii?Q?cMYzMjB5rdE7VchDydovkemNdXW5byXAcCOH+/KeinI4zHd8/X4ShCKF4G+6?=
 =?us-ascii?Q?BMPf0CtRPfF9/hWuJaYW44Zg7gHNfNt9LerbEr4veGBOX9DzWwAs3Ar51nhp?=
 =?us-ascii?Q?gHlSKzh7EtUypzeK3ZaJt27+N/VQlTDqZeyVOz+pQtVw+3p+icu5IP/8b8f8?=
 =?us-ascii?Q?ChWwMMDC2ve8fFTay/Y1rV95pmMiKsDf76dDJiFpJOlBnmehJR3zrMp2r+UG?=
 =?us-ascii?Q?jPGFNE6N2CAbw23842KFsqSrwRElWQe4mXbyGvpC1Hetp/M2/lvsI+Bhvmq3?=
 =?us-ascii?Q?K2JuCapLxNJwk2F/YQF7X0UmNTbf/x0gAW/a1TcP33yVxyQC6i59NelHWZU+?=
 =?us-ascii?Q?fMl4/dHvvfjxX+ub/3lmQisYq6wNDcC7rJtQw3ybnBvXs5azPnAAstIA4p3S?=
 =?us-ascii?Q?+rSugQpXXvzir/kR5IWlSfHYZf9vqjIcdiAnLKhWQyoAtnBJYfoDWt5Q8O60?=
 =?us-ascii?Q?OG4SewjMm54vTBnW+Lb4B+bplR+Ihzwf83Df0ARmPkx+UNSBROAan4Up8mHS?=
 =?us-ascii?Q?LIRex/3RV0HM1A84fXAihOHHtjqAZ8DjX/6vbDeuRtblSi5lIMHF2xYUjLnn?=
 =?us-ascii?Q?1u9FRbtlPI75DOuvzUMAffwmUZOsnhJ7TlKNt/d+KgGRm4/6b7kHq7psSxil?=
 =?us-ascii?Q?VwNEDXrqkdkEnEGQYQus+K73YMFTc8mi6YP6EiZroyqirc8dw/OCJwd7ztUY?=
 =?us-ascii?Q?R89kkBryOd6HmdKBhJFEgQdV?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb9aa78-4542-4468-2ce3-08d94a357a69
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2021 21:46:19.8550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5CV9ZIohFqi/KkxinCkHRpj4hamIsqugOrjfB3vGg5PVpiDRrosNU7exYH3SxveuwyLcwhdllGJrf6IjPC1yFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of supporting data plane forwarding on behalf of a
software bridge, some drivers might need to view bridges as virtual
switches behind the CPU port in a cross-chip topology.

Give them some help and let them know how many physical switches there
are in the tree, so that they can count the virtual switches starting
from that number on.

Note that the first dsa_switch_ops method where this information is
reliably available is .setup(). This is because of how DSA works:
in a tree with 3 switches, each calling dsa_register_switch(), the first
2 will advance until dsa_tree_setup() -> dsa_tree_setup_routing_table()
and exit with error code 0 because the topology is not complete. Since
probing is parallel at this point, one switch does not know about the
existence of the other. Then the third switch comes, and for it,
dsa_tree_setup_routing_table() returns complete = true. This switch goes
ahead and calls dsa_tree_setup_switches() for everybody else, calling
their .setup() methods too. This acts as the synchronization point.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is new
v3->v4: none

 include/net/dsa.h | 3 +++
 net/dsa/dsa2.c    | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 33f40c1ec379..89626eab92b9 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -159,6 +159,9 @@ struct dsa_switch_tree {
 	 */
 	struct net_device **lags;
 	unsigned int lags_len;
+
+	/* Track the largest switch index within a tree */
+	unsigned int last_switch;
 };
 
 #define dsa_lags_foreach_id(_id, _dst)				\
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 185629f27f80..de5e93ba2a9d 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1265,6 +1265,9 @@ static int dsa_switch_parse_member_of(struct dsa_switch *ds,
 		return -EEXIST;
 	}
 
+	if (ds->dst->last_switch < ds->index)
+		ds->dst->last_switch = ds->index;
+
 	return 0;
 }
 
-- 
2.25.1

