Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A364FE6C2
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240410AbiDLRYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbiDLRYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:24:49 -0400
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40076.outbound.protection.outlook.com [40.107.4.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B1760CE0
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:22:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9hLeHn5DfSuDcZX1aKTsIAidNBUH11U4fWczGuCGTGwHNITDjVcwmRET7SAGGKp/B+OySC3727OxxdEAV9DkO/I+MepHPNsz798wQEPNazkudPXN+rFFI4R3Rt7ZSKoDAjyzgb6/bDskWz5J0IVsIVfHXMxjbMinR9/QFCLqnZBLw9X+Kw2Q629aNqELbW1hvFvZWwsh7FMuMTOcZAGjzRq5QhiNW258/ahrbfptQfc1Q6UJADOrQRi02eZXp+F7nFHc6u3UtL29G3bPABYVhmOjnzCtXWYIqFI/5q4oa6Gk0DGIdXMCPXbayS/fBDdqXtMvN/U/MqJ9vb1NQGNyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CC6QJeCrTRlSjhZeC7Z7e8qNqETfh6VkLB9eUsQLqI=;
 b=ACmuuIUhLqO8n6H46UjKPAev0LXgbYGOWyBM/iyQAHDN4NkYhUAIM5SG8dVZY8hE1Rf9fzyrsFQzio9q8w7havhwV6ZAF/9KckL28saGGTL+nh/6wzhqN3EI0usRADUuzA/DZmY4l63QJZ0vdLSIlIaZLFLiQZs7NzdV5TU7EAbSnEz/zs7GknrsUNiA0h6UQul1kYz+WfsMKA5o/tQ0UQt7qfsnk3qtB5k5UuWFgTbMZX075UJtVK7kX9ZgShMOZhIK1rUsoom4tY9aTWNXTSZLS7m+meHzOBc6//m9Ap9kwA17N3k5Cw9jwWIYajojQgf6ASToAjXlpe0CkVA/qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CC6QJeCrTRlSjhZeC7Z7e8qNqETfh6VkLB9eUsQLqI=;
 b=JCwgqNHSqLUTA+Ot+ow++Oh0D43BdPvWMmXHHogoglVeTXrn6fkiElKDdJL+oZl1Jt7FVTNjHPRUqZvBMc9gGquW8c64b+vn537lHh2i3zrCLBQmNyXEctx/1vzv3hGWWLe3P0li2TzWEfo+i4GfI8+yCyP4aauP2JxJXHxq+84=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6131.eurprd04.prod.outlook.com (2603:10a6:208:145::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 17:22:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 17:22:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Michael Walle <michael@walle.cc>
Subject: [PATCH net] net: dsa: felix: fix tagging protocol changes with multiple CPU ports
Date:   Tue, 12 Apr 2022 20:22:09 +0300
Message-Id: <20220412172209.2531865-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0220.eurprd06.prod.outlook.com
 (2603:10a6:20b:45e::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae97df70-440f-4aef-bc21-08da1ca904cc
X-MS-TrafficTypeDiagnostic: AM0PR04MB6131:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB6131BB9809B611A223EF5097E0ED9@AM0PR04MB6131.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S+XBfKlUyCbZw6+m8vfGBaUhAPMYJms+92vfzqwwxwWcJ3JHL1bKG5mlssQBXgnouXajAbXYRVfPmujmO0yK8+IhUN/xZTa7ayxFVua1LptC7p8HdpmXoY30i7SREt0Z97XXL7QsPAOosKCWFl359yHxv+CKFSvnq0VhgedhHVVWaGvpK1SJWJ1PopSz/jngMzjko3a+rl6pwG6LKQTloF4AQu0K5j3OhN0hlkV5uhEKYaaL7JpUpV0MaZ1YEnxe+1x1zUxa4QcienYcC4EKnN/d+k8ZA6uxSkyQbcKkaUwTs2n89eHedsq25csFwri/j5pIKGchDdbK8qLYlIYqPOyG7wn3oaOccwVuTHe/9jNIGTRoSbc/bOLGGqAD1YizHhFtN4BFofR+jAAKjw5R+hSMg2f9xMQ7I+zFgJ37vCEJxU5+pak9fMZDMI+CoVdn0nUxKowGOVM4kWOnoU5aAZEwxaKB3CUyJHajRmG4NH+1XBNk6WFItwSTIA9ACHs3vd4LokufpMD39GBeBnmrLL5D396rzpfb74BM5fpN1Q8W+z38tF1eA0Y3/327bMQxbDxYVjkevFcTr7MZ7Fp/tXmQNyBoXbSgi4urUm4qbary5IwHDJKcFyfIYP0NuOs6Srqtk2zh2WsjWGRE2TBqSMPp/aQ6/ptMgTTaKlb2O287UScqthudqeThrlMmgIr1zR6/M355bz9S/RDCTcRG+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(44832011)(2616005)(5660300002)(508600001)(186003)(26005)(1076003)(8676002)(4326008)(66946007)(86362001)(36756003)(66476007)(66556008)(2906002)(8936002)(7416002)(6486002)(54906003)(83380400001)(52116002)(6512007)(6506007)(6666004)(316002)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ig+bDESy3OBeuoKFCmQ6f3why65wM09//HeBJLKHMKJaczvF9LLXfyH9gkWa?=
 =?us-ascii?Q?uA1EG1fiUvAZLo8XiyekgvbMEnyJubLdVMMJbIpl1VPjaIXeGEVojUMETm5b?=
 =?us-ascii?Q?9GmCHwhDGlScvm8AcUCSrpfAk+NKARP6CEI55PZsZHA+mBq+jD+KPyQ4ngnb?=
 =?us-ascii?Q?TQtOvFSwbNwFRvz5DGvD7C/n+2BgPinJdd38+Avcugl0FjqFQ0vGPpeszvGz?=
 =?us-ascii?Q?n5l0jfigDgICKAiJi9VsLwwd24nbEJtLmOwU2tEecAYObLE/djZrcEpb/Jwk?=
 =?us-ascii?Q?6eCy2IcUO8MGWUMDv3WCS0F4t386GwC6Hav5XN76Gd9JAWq1PCP+kHQQVU0T?=
 =?us-ascii?Q?wW3xTb/hzGHjv6Ydu/AFzk1wSY3Dfkf+rU8ZMu+RZWwMegO+gosGafiYXzNn?=
 =?us-ascii?Q?lO/Fl2T4tySq8HGQMkM/L0b939mBTWicHVLZVjkhLYSVtoG7a3NjwhcI7/xJ?=
 =?us-ascii?Q?PA8fUgRTAmCzg1ZeurJru4nHh+WQmfePvQrkCWYdvkphrXHkElgkK26lZVBk?=
 =?us-ascii?Q?vR3YMKBaEveTF/aQmym7fwlwPrfmSbbD+2R4ieECogfAVbM/wLNEJum/BCFP?=
 =?us-ascii?Q?YD+6o52IoZKWxoYDbYTcP3RNVtwYppS7RF1pg4GrFF9xgWwvLC6T/QWzweCC?=
 =?us-ascii?Q?NAjzZVNkIXCoizIaVlQkajWAtEQCM64NHFN8gk/Cszo7yC8vqRiYYwiJnVwM?=
 =?us-ascii?Q?1FVT3oVM6EU4x2IgwBmISUPih6bd3Yu4+i7IStNWHjcm1jrltb2NTRvox8v6?=
 =?us-ascii?Q?5Wyb0pQTndZs2Dy64sN/zJgKIIfGeDRxJsyruLys5dCUiv4DR1X/8IH/pBhX?=
 =?us-ascii?Q?QD/y6vqL6iHz6Sf0AKs0mA9p1YscUq+/lbjBPeTkM8800cNgQfqEBQp6Nxrp?=
 =?us-ascii?Q?Q7rPS1RIJ4NWobX6B+03jA4dXsbFR+JfDbDWJ7zXcMrjX6iy/RQv/gRV6sGC?=
 =?us-ascii?Q?GlU2NSAfFfydolMml0vU4njUru3361M7Fk3+ZUaMtkC6RLrBwQ3v1qMGJGhA?=
 =?us-ascii?Q?tq9DElfzbhj40xtj9D2C9FMRs0uc04l1rjLQWWiTRotJ3cWFTreNlPiHXeFQ?=
 =?us-ascii?Q?o9dtMrtajtcerQFcfR3HeGqsGTnb1XDzypiDrxaKu8FZsWmzeTMpJrVhVCWk?=
 =?us-ascii?Q?A6memffO3DIRSULVMcMCZ2DeaX9XgYyX+U0TIKWx6WDxhm3VJbSwQcVyE1+F?=
 =?us-ascii?Q?v60KUMnbqJVCFBxOrT/MmlO4Dz7DkMPqVBH/oTuvNw4sXnEIEG7l/9TedHPA?=
 =?us-ascii?Q?Tig0AMwqZNprrTFOWQiCdtKODxrzKnsD+hoHD1wAEkGkkVshz+fIrSW9D8fg?=
 =?us-ascii?Q?h7EevI030RaYoGFZIuDn6PUoNsImnonTCs5QXDSe69vRFeuxv3gXP8s0sjgu?=
 =?us-ascii?Q?vjB8ZNZbc/JT4hdzPBykrdRM1N7LiFJryWc8JNrqwBXBuvxC/Vb7WSeaNnrE?=
 =?us-ascii?Q?wyVgEeyCcV2cchINhwKz4KySYvBxAQW+t2qOaJKBsparfIzdOmJsfgP2AdR+?=
 =?us-ascii?Q?nu89VFmIB3eu6NqX1bW+RcCMaO2EOA10e6n73h4ObFVO3bZAXLSnIOmP+Npi?=
 =?us-ascii?Q?81/yl+Sv2nRhchHXWGIh5G++P5AM2IpVmFKFgIn1FmYShrhQChJMu1LdWJN6?=
 =?us-ascii?Q?r5bmbOFlSaWO0SxaDS0hfi2rH6gEeSfG18RNtFWl+3+pp3QBEEOHWy071UDk?=
 =?us-ascii?Q?Jnm3E//hqCtSc2bqPuw9R/k29PUInxfGzzWC/5BMvB6W6/3EaWX/uQo8bCGk?=
 =?us-ascii?Q?xGaN7XVcbVLAtAShBNjNBnifrhp76ek=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae97df70-440f-4aef-bc21-08da1ca904cc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 17:22:28.4579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cqJmnACwXVyhAyW2fdtYMzo4kCudA0WJX74NKkvWUn8PkFHKvnS/2c4LMafuml/GMbh6C4x2gAiHtnm8esLQSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6131
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the device tree has 2 CPU ports defined, a single one is active
(has any dp->cpu_dp pointers point to it). Yet the second one is still a
CPU port, and DSA still calls ->change_tag_protocol on it.

On the NXP LS1028A, the CPU ports are ports 4 and 5. Port 4 is the
active CPU port and port 5 is inactive.

After the following commands:

 # Initial setting
 cat /sys/class/net/eno2/dsa/tagging
 ocelot
 echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging
 echo ocelot > /sys/class/net/eno2/dsa/tagging

traffic is now broken, because the driver has moved the NPI port from
port 4 to port 5, unbeknown to DSA.

The problem can be avoided by detecting that the second CPU port is
unused, and not doing anything for it. Further rework will be needed
when proper support for multiple CPU ports is added.

Treat this as a bug and prepare current kernels to work in single-CPU
mode with multiple-CPU DT blobs.

Fixes: adb3dccf090b ("net: dsa: felix: convert to the new .change_tag_protocol DSA API")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 413b0006e9a2..9e28219b223d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -670,6 +670,8 @@ static int felix_change_tag_protocol(struct dsa_switch *ds, int cpu,
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
 	enum dsa_tag_protocol old_proto = felix->tag_proto;
+	bool cpu_port_active = false;
+	struct dsa_port *dp;
 	int err;
 
 	if (proto != DSA_TAG_PROTO_SEVILLE &&
@@ -677,6 +679,27 @@ static int felix_change_tag_protocol(struct dsa_switch *ds, int cpu,
 	    proto != DSA_TAG_PROTO_OCELOT_8021Q)
 		return -EPROTONOSUPPORT;
 
+	/* We don't support multiple CPU ports, yet the DT blob may have
+	 * multiple CPU ports defined. The first CPU port is the active one,
+	 * the others are inactive. In this case, DSA will call
+	 * ->change_tag_protocol() multiple times, once per CPU port.
+	 * Since we implement the tagging protocol change towards "ocelot" or
+	 * "seville" as effectively initializing the NPI port, what we are
+	 * doing is effectively changing who the NPI port is to the last @cpu
+	 * argument passed, which is an unused DSA CPU port and not the one
+	 * that should actively pass traffic.
+	 * Suppress DSA's calls on CPU ports that are inactive.
+	 */
+	dsa_switch_for_each_user_port(dp, ds) {
+		if (dp->cpu_dp->index == cpu) {
+			cpu_port_active = true;
+			break;
+		}
+	}
+
+	if (!cpu_port_active)
+		return 0;
+
 	felix_del_tag_protocol(ds, cpu, old_proto);
 
 	err = felix_set_tag_protocol(ds, cpu, proto);
-- 
2.25.1

