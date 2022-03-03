Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEEC64CBF5F
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbiCCOCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbiCCOCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:02:45 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80058.outbound.protection.outlook.com [40.107.8.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF7718C78C
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:01:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jz8uvFBef5z5f0i3xPXQdCRq2NMCY+rH7MsJjXSTk2bZLK38Yrg7/a3j4x3wXcVIqDVURwJsAMH0KJe33f/XvNaeJEAtUKqmbil+jdOYf3l9N9Yrf+sSANPmhpnOaQd6P+OcJcw5n5dJ9TNaBlhkooUXDTz5lKPDUpd4tnZQO9XQ7Ult1zstUfhZySvrCEXNMaSJ9WEldCCfuWzh9W2hxg6716xI6FOppE0mQgeZP1iyeuyQS8iBTzvbuxfQnUNQBkjxdj5JzOXmFaWFscfYZyW9MSQVnC9llg/m1y4Rhn5IV7BMr3aKkFwM0ibZBJHxDzDLk5IlJGV+Z8EtqBq80w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDETn9Vr5HeeTZ5BHQq+Whuq/MDt4gTkLS9W1HMIALk=;
 b=B7rCDyV6bwzqnd+mtLby1SBJ3epZe1KQu02rYDvoiPV/i++0erI61tcXQekpvPP9cW+XGEoj3tE5uHYdxxLOBWmdU/vI/NRB2OTd3go9ii6Kodkk/4LV6bkszBNQBe0vD6fe16/mVyIbYZuXa/zgfd+/jjFMxZgaEWMEB3TIwbSPllsjN28t08ccEpvpomsyy+IJ2v2/47rDMH5n158H9xIwycqHXQ3dny65MWljCkW9YHwIdLjHrPWhWu0adVXMwuI/jpM/zcBJ3BWZJkxTbFYb6eyyZDG/8k8NN9vcuyN/GDv7dMMhSXHTtshQMRH4We8r0xR17zRaiz1+uB5VJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDETn9Vr5HeeTZ5BHQq+Whuq/MDt4gTkLS9W1HMIALk=;
 b=A0JCV3jsu1rrA5FBk4yIA25btryTo3ta4BWPMAaLXTovJxCaybw56Z48DbQGmxxccQ+zGUO1kDZNHNih7I0TUGIabVf9ZUu2UczYFOz4H7MB405/WTo1lTSUcKinRGbqAlFrQzL2fxOLl7zAv3Wfo6jSBdo7o6cgT8akzZVPeh8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8879.eurprd04.prod.outlook.com (2603:10a6:102:20e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 14:01:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 14:01:47 +0000
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
Subject: [PATCH net-next 6/7] net: dsa: felix: print error message in felix_check_xtr_pkt()
Date:   Thu,  3 Mar 2022 16:01:25 +0200
Message-Id: <20220303140126.1815356-7-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: d6bb74e0-921f-481e-8589-08d9fd1e5b29
X-MS-TrafficTypeDiagnostic: PAXPR04MB8879:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB887962EE225CF9D4676F7DABE0049@PAXPR04MB8879.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nct8tyKPYPx/Gex/IIHlRGS1f8PXVz11geztiywliH5c7DH7UbVol6ekL7ICoza6PjSuiyiH/fK2FrVh1/ICPozRJlzSOqnfa02anudXEDtVk6J64vFHUT+FiGygy2Bokbos73FFviKM877ePNvc7awtMPPCbLbyR0nFKfSewxfi/tSdZLiwBRc3UgE+Lrs6K6Qmurdr8RyUr5YJt0wV2p3XBKtsOy7Xw7WveMUYv8AdNia4lsNhLUZDZ5RpM8uxNbD3LlpmDK30V2c8N9VQGZzE27rNVpGEwvimTE78Dsa7J/zkRDGwmZ6JhEcq5jbq/z43DTH4bT++PSf/drpFYsbs1uEDj9LR0YNu2/U/3yumreLExt5leT5A2AsLGaqG7qBJKApF9FyMPat6VDd33m23LFlecpN8b5RYckmIoLqejETlMeeok91quADF/1W2rCRWwSAChNxnQxhoWz6ATv+WmkOF3YjhTHuwHYGR9lz136mSbm+bD2nrV8V2clBG5+2w5rEfx8fKw27VxxtZVsSdlPKJSP4OT9IiCTm/t8gV5rszliyFBabqoEY8jBb0uKUlN9SOt66fCkZDHyw7h1wohxkewK3SvN1RDNcTWvYEAyJp4gNAEouP86kcQ/+F+iYeXm7QzYGSgBeqy3hGuGwiEdyphhAtOOXmxsMX/1dCrI/vqtPxeEQZFz96xhLJWFsUo6RxG2OrH/K0oTrM+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4744005)(7416002)(186003)(26005)(6916009)(316002)(54906003)(15650500001)(8936002)(2616005)(66556008)(52116002)(6666004)(6512007)(66946007)(66476007)(5660300002)(44832011)(4326008)(6506007)(8676002)(1076003)(508600001)(86362001)(6486002)(83380400001)(2906002)(38100700002)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FWGZsrsX+SOpetpOrUotUZEV3gv4QV2nErKe0B1G2EgGRSaJ4SAg9iSjJAqW?=
 =?us-ascii?Q?S0mU3saTHSvjDa/MMtuABZUyNSX6o60X3S/ePYf7j6NLV3t9FNpn8KLYq+Dp?=
 =?us-ascii?Q?p3wyOM5X463getJvRe4Yv4MFc9Rj7oQvv28QxFIDjw9JJqvw0+CJv0SkKujA?=
 =?us-ascii?Q?v6a9Wsukk0X7jhX/m8otjdEv+QcBEet0nhZFUZH1sGTklzKAkAwLpoE/KIZp?=
 =?us-ascii?Q?jh+qLlalgrkcSbOecAftc7CKlwHJFhCg2vfMg5TSe2Z/2/1eF4xlFcAXQ1VU?=
 =?us-ascii?Q?bERzPn+Xy0dOmfN6Ngx5v8J0wQu8vC6ye35rtD/dWoijcCtaqfwCc9/Cd+kJ?=
 =?us-ascii?Q?DY18r475GW7VfAruX1HDTf0wpBOHwu9ijRxKZUN+BgFEq66coJDdHoABXy6n?=
 =?us-ascii?Q?qVtMjCzoXrhYMqVGcjJjoHBdR+uRCJKfY2zvl1LqA6dgnwYkHXZQoodH7Slk?=
 =?us-ascii?Q?QyBGjZczNim9F5R2lxAbr8GZCbBknqANqAH0iQhUQSThJ8rpctjT5a0vmtdz?=
 =?us-ascii?Q?PmzR2a8Y96a8yEkaMO4NNbtA1MHVrfsJeWe00F14ETqd3XDK1HnI4Wc8x6cq?=
 =?us-ascii?Q?UqvO8DyLsz+HCy2lgjMWGn9g98pt040tcB1OXmt7jvf/yEa2RuzZQgluXlPI?=
 =?us-ascii?Q?YOlPd2wzQeNahbevjimmNhsSMmGzADTDbxVrjeJl9R1CgQ99anKMU6W1fG+k?=
 =?us-ascii?Q?ZUeawp9OM4t9I0vCeucgaEpZ2v6vdX+YpXxYZLZOPwMidFu21hzoVOu6Lyqd?=
 =?us-ascii?Q?vFMVa2YlGOGU+lD+WCV56JtuiC9MiWdYcMfH8Ma4nld5Tmx6BISL/WZ45VrJ?=
 =?us-ascii?Q?wvQNj8UcKCSANndSXX5KeFknpqt54d756WCdKEmoz1ASi8UFckOYomtmJ2F+?=
 =?us-ascii?Q?5V/+P1dVxwZKKiht4rK3WBotvA1LjedfEMKEhwyWBJgWwTkVAsJt05G85KiD?=
 =?us-ascii?Q?A+qoQ+2cvhPUjv/45dl8UYqjmC+rnJkjvD/bF6yW0TqiPdqDfaCTuDlIwIDT?=
 =?us-ascii?Q?7OiA44W5KOAiSftf/AB+f//hTtVgoEz+wcNOw1OgYNyz38vulIeuFtxMuFOb?=
 =?us-ascii?Q?ya+NZoB+vLJ922af48OvdA7dlYVLs5Q3XS9BpSY/g6TD1bK4SUFqxTLSHs58?=
 =?us-ascii?Q?UbSUVdpogkqpTnS6ZlX2MVLQKls2B/VOj6YoROZfoW+pV5G3RLmvYLm1iVuK?=
 =?us-ascii?Q?ebH4pzW2rPyi8i1xDui3ogv0uW7PrnZ5gRVxvYFXtRTKwgw/hEnLUvbhSypo?=
 =?us-ascii?Q?/a1Lvy6A1Dw1M73hNuZnery1YYHmuTmV63VeqPJw9kEJyrzv6+7Wfu1m1AFn?=
 =?us-ascii?Q?DA3NRvwa35YHKggepWtdtHnwDNFWfAZJfmefVKB4KsoZA0pEQ7QSGzTEeXos?=
 =?us-ascii?Q?kZ5h08gdzBkt8NLz1fTdeMw2X8S+XppBBt/Hep7qLTSxof5vbmpBkjptNBDh?=
 =?us-ascii?Q?ohb902eCOa0wssZtUHlr2EGghStf0ySE+kh+LbiJbQrpfGgPHCUQZNq50SMs?=
 =?us-ascii?Q?LWvo/ZVlB4BtgLE83RDza82v9vqDOFMNz5OZvt1D3VpTH2RFSPPemeR3Gr3s?=
 =?us-ascii?Q?8arJveBynzaT9WyHfOQKXEIQhCaeayyFSjDCnuOpK1GaFr6RKxuhTNoxZFI0?=
 =?us-ascii?Q?apxRSo4osIJMbeXpbOyRrjk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6bb74e0-921f-481e-8589-08d9fd1e5b29
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 14:01:47.1492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C+RgD45A5A5jS2rz5XfYEX8S0GmPvHrxFappZ+DtKXJDWH029YPew4b15QOJc/YkbqR2OywZC6+6hHYfcLQqcw==
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

Packet extraction failures over register-based MMIO are silent, and
difficult to pinpoint. Add an error message to remedy this.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 5c4eecf3994a..25eb57058ce0 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1371,8 +1371,12 @@ static bool felix_check_xtr_pkt(struct ocelot *ocelot)
 	}
 
 out:
-	if (err < 0)
+	if (err < 0) {
+		dev_err_ratelimited(ocelot->dev,
+				    "Error during packet extraction: %pe\n",
+				    ERR_PTR(err));
 		ocelot_drain_cpu_queue(ocelot, 0);
+	}
 
 	return true;
 }
-- 
2.25.1

