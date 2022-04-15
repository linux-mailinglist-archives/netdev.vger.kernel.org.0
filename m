Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBB6502D4A
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 17:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355618AbiDOPtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 11:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355609AbiDOPtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 11:49:09 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2084.outbound.protection.outlook.com [40.107.20.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2295D986C1
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 08:46:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YtylnWIufFvYVBnyYJZexRkhJYaXab5tDl5D5wUn0HfTAuC/xreNd9XI7ta/F3+MauLkBcQ2D7zXqJQ4ucngyKo1zFv18FhCTT2jBNuYMo/zS3HCVvg6s1hXnLV2WCHpKDXqaBymgjE3bkDc3Q94rVvvFYCkhUhT9Lpah6u+x75qRx7HxaCWTq7VieyhQxI+wT3JNbuantNczFtQBn3QsdtyP6U0AjtXQJvxmofHLFXymq6fmDbG/IGUOxZQH1ujcLpvNGt9NqopqaaQpZVY+s0wKPZjL43urTYBL3kDAFu4kxQ08aCkLu00HLiJC9I75AKOv7J2c0LSuvSGsPnL/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gs/GiCCdtKf0kF57BlZ1zur5IPciziEZrX/8XUruFFE=;
 b=iYr83QKsSPZuRvvmBWHVzupvwMVPbKeYbi63d4evvuidlSIP7YH/c21167ebf9+RTEkeoemkReoy1sFj2aZgoZHnyRexRuMaERigW3ry5y4VMeVU2x2eN7WZFHaeCYwNzU2jAUYHgpwbZaqCchKAtHl/4iWxfRYF18iprWGvAnFV0mPlQ8bE5LFgO85l3LgMKceHRWuk6wecsKrB3PfNW4tHvLI63NbpGcXqyRWPamvVkfozNONf5Fbt76bLZrk1tnQjLw7sO9dlYKeO/mR3a9/oLdYSYiQZMEv29Ju2epXiBQuQdzatyQJYpyBLJs5dy0cG5pVIBBAGxqFWsqsrvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gs/GiCCdtKf0kF57BlZ1zur5IPciziEZrX/8XUruFFE=;
 b=kzQL9+71X1z733hHtddLdHNhZ21pVtBSoVWijFz0NZqpPTGwix9R6WYEefkV3eukoc4vJmIcg8YUDVpZKimQdaC9qf0yseLhiVGFCtntbaL+jjpxW/j8nE2u/NsVkp8SatVQqWdtKHuUQF3jLqK7FvPj6QBi51rKs7Stm5aO3Gs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0402MB3385.eurprd04.prod.outlook.com (2603:10a6:7:8a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 15:46:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Fri, 15 Apr 2022
 15:46:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 4/6] net: dsa: avoid one dsa_to_port() in dsa_slave_change_mtu
Date:   Fri, 15 Apr 2022 18:46:24 +0300
Message-Id: <20220415154626.345767-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415154626.345767-1-vladimir.oltean@nxp.com>
References: <20220415154626.345767-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0091.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bc8c57d-6e48-4c11-4089-08da1ef71ffd
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3385:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0402MB338550688230908799DD1D66E0EE9@HE1PR0402MB3385.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G1JyIs4BRjf+GPXD4VYPtAWh7mYaD134mohbTj37F6CCX1GRp6HRzjvP98b8CzIIwJPQ+IHnUm68pvlZXMuhMOkFHWtJqBqn/xf7ZXR1G6A5hNENFnc+CwTLS5HN1s+1p8cgVb3Xsqkv1x4h6judBErJ5T/LjTn4s8upGRQFALCuFG9mcoJOeR0iPuZunbUf1u7TVTc3eJ7mggyYZh4H65XkGOwdB2rH9WfH65XNTtgy1Nn4oHn6tpv8iMQV08nHH4lQwPyaK3w+F8+N3rycQpYq+NiyCKeYy97PblGJjWcofxHFqPweOUquE83AbgZzAMyrOR4g6UiZqtAwOobTevIp50Gte6ORlognjBGuIsqHIBArj8X5T2M9c7WPUm6Z3SkM8Q9GLMEUFr7TWviA6oE4d6fJm0DwpicKaF3LcBEjKRi7vxLIJ/Hd+m8shPgzC9ju1xJzqiXohfo//JBsAnhP23kbwoFpPotfDA4jY/eQMxi5VzJVtUPFBbTIIgoYpBxVJjJ9VyDigzt7Y58Rjy3nOMkRyt42O4dXT5LHokgjiwzj0qBl65aJA/S0Af0JkvsB4yrXLfD/4cb8Ysdw2snzColoIJfq90uTckRYJFt9ASCpcCR+2ar/RfbtfUyTdEOAr4mwt1ZFlpf3R02xvZ4/T26/cxvpGporZkwJlVgYMStf0uDUeMtGn3ECc7wLr7H2KDH0yvOdiFiitxWt+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(6486002)(36756003)(316002)(52116002)(2616005)(508600001)(186003)(5660300002)(54906003)(38100700002)(38350700002)(6506007)(8936002)(6666004)(6512007)(2906002)(44832011)(4326008)(66556008)(66476007)(66946007)(83380400001)(86362001)(6916009)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H6Xbkkk5PFiKTsNWWtsONKQkfz+wWEnRhaynFyPM4aVzRhv4wNjUG4RghohT?=
 =?us-ascii?Q?AsEjLXR6WSMOkPfDLTtXlga8dyHvzpwKfpFEy1LoIHCIq9R5UPS5TwFpwJyt?=
 =?us-ascii?Q?5058xZfx9eFeavH40/vtSacKArzRy9729dE+mDh3CVfYkRxRhCV7ntf2CNfa?=
 =?us-ascii?Q?eh3m82DXeHqoyDo5uDrkiSYrz4VFykDnOhFGwc2PYc+JU62J8egBCNCP/L4p?=
 =?us-ascii?Q?x+n6yGSQl4keb+IrX3hMxmZN9trzO6PWiZnf3bPf1dYgiqw0wS4sske6YKaK?=
 =?us-ascii?Q?EXTmwdXFX3eguD5esheE5XHmwtw0c2Swhc5ejjGdjerq3P/GY5N6IY03q795?=
 =?us-ascii?Q?eY/xYe1NEutXFVSe7NNwu3kYjACU244kwXdJRwt0q/P4g2FrwaDOs8VO6FKo?=
 =?us-ascii?Q?St5Cyjr7OPFOuM6ZDp94faQcgHSE3bBVF5+2rlr9uu2RmDJBJGbsjxnNy0yC?=
 =?us-ascii?Q?c0l/JDoX2xfvzVkFgmzKSQB8r1J9bqlDAwuuecdFvo7AAfoxy9x5YvdEzxQS?=
 =?us-ascii?Q?r9H6zAevVocuD3OigOdf9zC5gFcntNRLcbRpbjJST4G8lTgrlqOYhQGWWcrO?=
 =?us-ascii?Q?OdpyQMC3Q2GqtlDmx4cLfezkSMSqmOpB5k9fAWwzZ9I83eCqgczIFBFcQfnE?=
 =?us-ascii?Q?/YbTT4h0q/EB9tvViqt38pUv3W8LwB5ns5aEYH6io5UdMahgZc+qhuWO4DxK?=
 =?us-ascii?Q?/J/J/00LSnCAKVt9QiXmnKh1393/u9PMpDtizBvC6+xws1kqHczqIF2PwSWb?=
 =?us-ascii?Q?TtSJ6cSa9/zlN9IvTfk5OBgcwuwIjI7g4aeBaLZJHHAE3K0Mr0rXr0n7TDBV?=
 =?us-ascii?Q?m7O5bHnTMTYcCER2le7nFrqnc6EEzyRTEn4FWNpu3jfpLdZxZ5RqVpQkgqJC?=
 =?us-ascii?Q?kJBXRWI/E9rMSddFG45qqtn6UyncNsN1BHbfw/8LoRUSU/Mu7FF8283tqNBt?=
 =?us-ascii?Q?OBPEcpXc6ez2unRNa+vpPRubae6i7buWLfoVg1JT4qCFxD7MPQobsQ55ckfG?=
 =?us-ascii?Q?23tOFlAuxWxWwYemYywytWzaqVx1iYpeAzyv4ss3LRl2/drmqgBvCy+uInwn?=
 =?us-ascii?Q?M9rAfk7rBDuFzo8d4x5US1CWY+zk0R4zCip7IHzGqFsWL2NH5SmYMwDO/ikZ?=
 =?us-ascii?Q?hYmj71yJnBXWymdYrYw7kC+LxlNjpRqTcLaEqU5dbaKS+eoMmbrjLD1D9GvD?=
 =?us-ascii?Q?jxw7oug7o5DobbVLVhmApf7x3lRdWlgCKDilp7RMlbrVhyLXFla4frVq49YW?=
 =?us-ascii?Q?TYFIi6+OlmozWOEuSSjw+Cg8SI69DxNfNwCGq4bWaypx0Zo1NThu0ESZYEeY?=
 =?us-ascii?Q?nfNiZGSOAsmHOwcfu0GBKGxOsngSOGJN3CvYqH/7LVtEa0NDX3Gm+QOejfwa?=
 =?us-ascii?Q?YCqH3a5h3ud9Z/VIhPOX9zmKHeReKP4nxpWlWut+Gx8VdUsKQcuSY239sUmP?=
 =?us-ascii?Q?ktvaDqO5if2Nfr4/jSjPvIXxcLR7JPKKAS2tCchIVdthC4ym/YxkeqT1a2LG?=
 =?us-ascii?Q?lk30Ta1lIkqdiC5ToCEwA+ijcEKFQULe/Pb7KmN1i+17admzbjepzB18K2Mn?=
 =?us-ascii?Q?zHVoiLqOoSc1V+/1WHltdmPbUI6ha4OIITwiu2Lhzhhn6ZQaFjSQS6gpDzo4?=
 =?us-ascii?Q?flaPTzN6/uLv07x1CGvGXO3Dh768U5h7BNlmzXTJnvNKJnKVfpqLIZzhCMj+?=
 =?us-ascii?Q?3F55WnX8ds1GCoCOc7ISCiE+38ie8fiN1zo9FG9NS5xJau48O/EyVeU0atP2?=
 =?us-ascii?Q?8jbKnJaMzVIE0b574kfMKlnFgM8yYnk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc8c57d-6e48-4c11-4089-08da1ef71ffd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 15:46:37.0042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: REOiivK1SaXi4LX1E+Dks/tn8eItBkptdvVuJKPdgTnqqoYy2M3Cv2PZMY5yAlTATSdcRiWFjwk7+TMDhJtK8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3385
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We could retrieve the cpu_dp pointer directly from the "dp" we already
have, no need to resort to dsa_to_port(ds, port).

This change also removes the need for an "int port", so that is also
deleted.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index da234c4b7daa..3ff8647be619 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1807,10 +1807,9 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct dsa_port *cpu_dp = dp->cpu_dp;
 	struct dsa_switch *ds = p->dp->ds;
 	struct dsa_port *other_dp;
-	struct dsa_port *cpu_dp;
-	int port = p->dp->index;
 	int largest_mtu = 0;
 	int new_master_mtu;
 	int old_master_mtu;
@@ -1843,8 +1842,6 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 			largest_mtu = slave_mtu;
 	}
 
-	cpu_dp = dsa_to_port(ds, port)->cpu_dp;
-
 	mtu_limit = min_t(int, master->max_mtu, dev->max_mtu);
 	old_master_mtu = master->mtu;
 	new_master_mtu = largest_mtu + dsa_tag_protocol_overhead(cpu_dp->tag_ops);
-- 
2.25.1

