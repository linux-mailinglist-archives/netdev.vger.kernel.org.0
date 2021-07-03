Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FBD3BA89E
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 13:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhGCMBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 08:01:20 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:47491
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230266AbhGCMBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 08:01:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PkpQZpCZR0z+ipHKxL60nv5krq25SMuT/S+kh0RV0RayH9D2Qf3l2mPj2O6q7WPdwM70F5b+pwaRTsoKd+m79ATTg+7QAdvFcS3+v3UJguW/3rXLhDR/HUvFz2HYde9p4yTy28pTfShb3aFyBGe8eKIKnoYOhMdIVJcaZcryx15fHSM9rRejt++85uE91Eag60plUhSA9sp1fToPdW8bB70N3JC+SjCo/bd6MVlVoCd1LugHBTatwXplE7irI2EraivjVgx3jMD6P/2LEl3j1kzw/u7zCEe27G+FMpruzuGpP15zdDok7u+BVCizddVa0kne16JO2B/OUE6ZOh3CIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YcXpR57JCcAMQ9q/jdIeT5Ev/nTHUqZD/rJq1Q8j8q4=;
 b=azy0ccum6fhBGBPV1ammHjcuP5FFDs6bK7CN+eoHv+TLdKgJDNNVndbHxnbnLyOt85HR95BAtbKf3+/95Ay4UCgO2+IAlbs5xio5N0nxT27tFPeD1wWTOcApGNRhd1Ik4jeFwXTFLNM46H1lz5AnL/DDAh+EoBTHCmFnuwUdbrrlNs86J0JEJ02kmL7QDxdAJcm+0Wfiqu2PrI+HKvc7MjyfT3FhkfGNrTVJ3ub8cLACwEOJdZEnmLOJ5dJpyGwKWyVqJrtwpOLEqSbAF6kL9F2P9vFkb+qQeveDgMmkiw6EKsjQH2/njSohBPwCExUv/2VhsS4yLV6M88weyAZI0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YcXpR57JCcAMQ9q/jdIeT5Ev/nTHUqZD/rJq1Q8j8q4=;
 b=XCRHziJTV6C4CGUooEYbkpDGkLegU80mRJYA0pwF8df78TIh/UkpjaVzTbJYeM9rP6F2MODRmMvpl+2N5wnLT1fQsqBc+kbl//P4eu36f8VE7GsYdl4WIDL53lTaALHG81cSJnb2QM+OGNrh8kr1KXsdUKUb1UUG8UHmYVsz0j0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Sat, 3 Jul
 2021 11:58:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4287.031; Sat, 3 Jul 2021
 11:58:36 +0000
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
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [RFC PATCH v2 net-next 07/10] net: dsa: track the number of switches in a tree
Date:   Sat,  3 Jul 2021 14:57:02 +0300
Message-Id: <20210703115705.1034112-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
References: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.224.68]
X-ClientProxiedBy: PR3P189CA0081.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.224.68) by PR3P189CA0081.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Sat, 3 Jul 2021 11:58:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f897eaae-f91c-4fe3-fd81-08d93e19e394
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB25099ECC8EA39E25F43F5F4BE01E9@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TDqJ8j0J44HJZUgWvPaiVNCG/prgbniCzl78r5sUovlQgfVwolp5pwGnDSHPbVkGpdm3pMLDETl9oEC1j52pZI7n0qjKw8rFJkKZK4Lwbf729QYBri/s6QpIHPxGIjaKahXhX3hdmaE9FwjmFhNHuBzv76onJ4nF3Wm3dwtjSjGH11cYxZfg9xnxsZQVJmLiL2UAovrthvpvFuDoK3FwMCR0Xw2qkLxS/IencfRtEQanULh6CR6sm+eGjQb1qc/vhAJZTgw9Z2DNs2vtAWVit/DOjbnbPI39zjHi4hXkdXFRehJrdvKP8GmNHymF0PsVHRFYRQjyW/OgMfdjLHxFRrnReHSSxhpfIc2MKv4lhRHFdMhyb2ftgQcxnUFcJ6ScAScF6bDDIYO1K8Nk4K9avthI3DNxOXH0hPXrrk46cWSKx2wuLkSpeypoEKqGItBJ21d1a1q3wcf2xE/EskT+q2pw9NVtLDcijUx9Vi0rf2f99Tsgd+y4ZvR76dhbAlIWDBpHr73+Dcn9EA3Jr4nmu49gFV0zpisj5GaCkKudGP46+PnyW4OP16nVu1rqGmmrjK/Qi6AzcCmQLYC1MBo0hBmSGbzPVAbqsJrX5jWFkMKaXgWMbBlR4iW3ntIquGORIPuHFBSae8d4PRn6SHWzCa7/z1X6gqeCjAFFSUNyaz5XvgWJFo04Hs3LaCskhzOfCjtjme9/ugSVC72Laal7UvOmKS0Vd+fht92W8bGwqf9dsPtuBFGk4Y+iDLXFeD32
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39850400004)(6506007)(2906002)(4326008)(36756003)(2616005)(44832011)(956004)(6666004)(478600001)(7416002)(5660300002)(110136005)(66946007)(26005)(52116002)(1076003)(8676002)(8936002)(316002)(54906003)(66476007)(66556008)(6486002)(38100700002)(16526019)(38350700002)(186003)(86362001)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8DZtsF5x8gTQ6dQd6F3pokVcNI11ln//0hpzIW7NMfVD4Rsa/FSKAGGtfdu1?=
 =?us-ascii?Q?ECpu1v1f0iS3mKrE2V2qcfSzNn02HEQzQW2VwThU4tbfFi9UzuR4smkug17s?=
 =?us-ascii?Q?LNFY8+ffcdDHuTAZD5B6Ri2DyE5JMUnvvgJAaEDhNc3kYIOk6ftNzCpqYQ9D?=
 =?us-ascii?Q?l7boWzmfdRhqWvTuvy6KuVSfgLmDLY4NMnuGuBtpBSvtXryO4GuXg0oA5YQT?=
 =?us-ascii?Q?g9/S5lenx3ItBGXRSjqiFnSzdoWHwutJeorM9WFit6GkcLpBX4180KM7hBsN?=
 =?us-ascii?Q?z+FzvXK29atr6ajXFpd3VbUtN2WH8Zr4Di7BFsTh5HZhAXeLN13RZ5PWQdke?=
 =?us-ascii?Q?nXh9QOq2MNzKa94VyjESOY3N+IPpcuXN2SYmcTmMXfo5799GQI9NvL4Viuqh?=
 =?us-ascii?Q?C/FG5ZOqIfdTooFSODQqrDWNDd4XHwwQVfva5VLPSPYLiFQqhlFM7v4NgOKy?=
 =?us-ascii?Q?Cbw/YikOCZlH4Zy7B1X68MBvf2hAkW9nKxaCGAdbEFPb/dARSCFHXVVSkbSA?=
 =?us-ascii?Q?7MMISBa9DB2iHD9AMM8Nu6aawfk6HRPpck+PYH0AYNEZZsL3wEWdqsYme+/5?=
 =?us-ascii?Q?yPI/KuM6Yapsfmarr7yxuiQ7CLG/q8cK6+hfooeDi9xndB6MBhodN0AQHi0q?=
 =?us-ascii?Q?Krr/m1HxU0+ycHDZMuSGU1bOjflnsvljXIR1vgcFIhQaSeVHGTQPHIeMHahr?=
 =?us-ascii?Q?2HXPwzUkfTTZgTxTYeXoIaYUIuFmsjwOGgxWOVOz9uyMXYm0v1RiKj65EsN4?=
 =?us-ascii?Q?+FFagSD1Mo1cNLNRRVwky0yDHzSXirg92pDxQ04rMnzHL97OhhoH+VFZcXEo?=
 =?us-ascii?Q?okePC/3Ve1bs96Xe/k7KgWpnTFqePR+9UL4H2ETdZMPOtyAdR5WxyveerScz?=
 =?us-ascii?Q?VJYPbKgMeBvLtx0ISkmoS5XOMWPQpV7Jdt8KoxPJEklKxV82fHfb8HoSdAjN?=
 =?us-ascii?Q?ptqFyF6aZsApyxM54B5OLtjzu5k6xTFXFZv9SfXLwaDqqSydQWeAVolbXCeS?=
 =?us-ascii?Q?IXi/Ywas7195SeKckgpMxqKTvsiWi7uPP6BpBMNrAScw6T3kCVVj/K6fADhJ?=
 =?us-ascii?Q?hTD9LTLH7qUs4a3sQ6DCeQtALUgHEqOhehzcqcCSCGBvDiWy0Uogy3R0pGYR?=
 =?us-ascii?Q?opBgyyooExwsxBy2j2jafJBpDg4Cc80AN5+vWfVRLSCRVUiLVO6nRCedg2Xy?=
 =?us-ascii?Q?QZaLYpZ0EsLIWYrq/QajcL5kdenwLHLWxx4NhWMAWiM2/INCqnN+TyKZ7ONU?=
 =?us-ascii?Q?3U3AqoKZl0ovYH+RVOPGYxG5MIqc4NWxyk72YgLLEZb55Qr4emaFqw0S6SDE?=
 =?us-ascii?Q?BeBTY46OUpm5dG0dwNM3JvI3?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f897eaae-f91c-4fe3-fd81-08d93e19e394
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2021 11:58:36.4671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qK6WUS2u1q10xnmoq8MffBGP8E/nrm6NdqK1E5beCMbFFSDITTVojIsnGrxo75wQUKHHTchKfFZpHUorT8lbJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
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

