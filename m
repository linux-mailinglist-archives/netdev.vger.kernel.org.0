Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D92D6DF614
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjDLMuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbjDLMtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:49:55 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2061a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::61a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2091D868D;
        Wed, 12 Apr 2023 05:49:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kmqq86Z2Yn+vrf3z7yoC+nky8TzCQ+hXrVFKIdrBm3CisDhieiQLXTsY7antS2ao5xEbgFU3UsPFxk+gXvoanDkhiNoQZO8TVf7Zabk1z3Lr5yDInCz3kThph5f3QYFaWYjE6MFLa4YSkT4qGCG9JCiwbyMNNMgotHEKPf2fBDNl1YMRWQb2CM+entvEjNrgzsurmuplfLRc5egTb9w+zgl+T9pCGPjGBw24FIAHy8/1GYz5omA7UzuGAijDksEZAer0ZmCT/yjWwKDGqRaxWjri6Fk2talWLpZX3ZREXJkhacUOUsm4hoILyl1IP346cZXtRwZ7HFcJy4m/YHmrjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6T4+lWflBLs8QRBOwrTdASAf83R3d0iOinQW9i9yQME=;
 b=hmGS0uHoy+jXS+NYx73m/fGc9OCbDkWyFp0hZkuzC/tNorHsxdo3dXtJ0P+NVxKpC8LR/fExryIh9bMMx1Wd7kxfNMXjAJETNmDRf85N9As62FG/qjWdI73YajQKP6ZTN6ikseMY+UpWcoRiIRjvwo3YlWNrBuhUIyfF/gydujTV00q/JSheZUfD0RnoI1TcZeWnt4Wrx1KSVfGRH2hOwe36+EetvwdwSJE/PrGSt4sLF8x1q8KQvWRbI61JBgGtjWYhcFLhlkU+L3BGE/gmduJQJtABQdtVLtql3hi/fSd0K6OjKhhPTRrS6y2BqI1wRrvRyfq31qfQ8R9ZGJzhCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6T4+lWflBLs8QRBOwrTdASAf83R3d0iOinQW9i9yQME=;
 b=KsjVqRP63BDvj4gfOnhq1gqFXaUdCXDkFQyUqU9nd8fY2p15/FDYsBeFKnTA0Lbdx0VpWf2ZzFWY3sHyfX57iXkZUvMesOm3WSwF5vtmsj4RO2+aJMsrWx1JoXTdWztVtLs078Bn5Ab0GJ36AVd4p37aQeFiFGT764CdWrBbn1U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB6888.eurprd04.prod.outlook.com (2603:10a6:20b:107::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 12:47:57 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Wed, 12 Apr 2023
 12:47:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/8] net: dsa: felix: remove confusing/incorrect comment from felix_setup()
Date:   Wed, 12 Apr 2023 15:47:34 +0300
Message-Id: <20230412124737.2243527-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
References: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0056.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: e1da837a-b138-44b1-1dfa-08db3b542407
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6GYP1/dcv5m4EK0fgplSaQp8HrPo2eVK1ddNkWomsKvmrVoq/AM5BaHrFRHSOs4FhX/+Ij/44dsvst0YSviCTHZFWqpyDkzKQS3fHceJUI2Ny8DfsUmFK87T7N3QtTQEbSEXUFoiTaMeNynjH+bASXLRgUdbV7ZbAPGsoDA6Nt+ohvJuRB5ThF01GN5cDuRjm38rnTRD20yUoaZW+vTwJx0f/Z33fpuHjn+WBdwwOIMaSnGK//naw+kvFZKx6HFzLkyx4FfYpKmhlmDKMImipuFa1CNNJTa75WAllPKN317Kl1nU/q81j787FORtMMZu9wvFb/+R5ElfzEXqap4pK3PmD5H95/1GtCL1JQdTTyfuEv7ozxv9PJ0LSCJrJxG08hVICKXdjwbUcCI/o2szuAhlpy8YsmWmyB/S+rm/4qM2bDjTXWT6rcH2p1VRqnBlWUq+8o9Hw9e70pX7PP5SrBut4iO34d9/4RUs/bw0LxvA+pdcOcy7D6pr0115QLuglidryZ692aGCQjGDc/Qu/sUGbQApFIyLAYGo2n0eSwOT/NRykafbs1HW2Ql430tkxYGS2+IGfrhUK4Ml+jVyuwOMk+Q90oEEhYqJy0nxCOYFQmwUOGuPbOLPPsRId9Bn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199021)(478600001)(52116002)(86362001)(83380400001)(6512007)(36756003)(38350700002)(2616005)(38100700002)(316002)(2906002)(1076003)(6506007)(26005)(54906003)(44832011)(186003)(5660300002)(66476007)(6486002)(6666004)(6916009)(8936002)(66556008)(41300700001)(8676002)(7416002)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LQAXkWz4eReDrWcNYG3CMaYlLZGFYUqxO+Og4GX7MAFkF2A+SCApXvixYX+z?=
 =?us-ascii?Q?Ok3CG+iGvwjwD79eCEuYiWYJu+UgLCnplrXpxnYSGBhnzbG+upIhDc2FEDvo?=
 =?us-ascii?Q?wibhg6Owb1qMgT0A3MUeX2kruEzXU+VeHb0O8un81VxfhnNpLM0dwfh5mwSA?=
 =?us-ascii?Q?hL+Q5J0zbujKKkslTZJG6o35t/74EZ9WiIgzGDFYyzJhQXTp4wsQuw/1ULKs?=
 =?us-ascii?Q?5/baNZRlGkodTqiY6OBFtNgaKY0X7FWpygUbm/zrojs482/hq7sxRsrhkKkX?=
 =?us-ascii?Q?lOzNPsRFZbk+bJkO8dZ86vTFNDTkoW4y1xtzj/3n21Tll7BMLelXbH+WQGkz?=
 =?us-ascii?Q?ZJNlT4CXXU5KSeEHcq2iJqi9tYKPlq8bmDLMUZFsxhfVsD/xg4SpR1KUlWfG?=
 =?us-ascii?Q?DfzSmYo+d3dz10Oivqc4O1bIMGjRibUG/7MEof4oHiO9s75sRm2N9JCvDWK8?=
 =?us-ascii?Q?FwQBSPIdKBrpMFiSkxCpNl5W6n8XdyaY7kOVob0OKZAYcMsN2e/u2rw/JQ96?=
 =?us-ascii?Q?gDgIWbsCef6nQFVz4Q1LtOBrwME2VnGL5bLv04d3gCifvP5EaNlozUfgzspa?=
 =?us-ascii?Q?pdFYol8ERWfaet1xLSbHCRQMV8fWXus6EyBM6MjNbdqAEVtHVMGO8d++JaLG?=
 =?us-ascii?Q?B+v9TijPDS4ocqc6E1kif4yrjv3hmUTsB3Ro38S6iNVK2I+EJrkhaQ0XcUHE?=
 =?us-ascii?Q?S4dzoI2wmdOFfoY9XFlogpa29bxMKM56YU0HdFjGJZeU53+apRonxD/f4a7L?=
 =?us-ascii?Q?WA7vpG1zdhBBY+gnwnLdNOtsDN3cAL0eGAHnMuLovbrdW11nmPmdyJMbMbGb?=
 =?us-ascii?Q?ifKuArbK84n8nUQBmF7sXSuu59fi+y+SuAg9aBEOcbUyliq5YgTSQhwXtyJC?=
 =?us-ascii?Q?uXrirbtXUM1kRbLiZ6QhTTOu+1dHzuSU38ea8JX3nwPMjo91zKyqtmSww2vh?=
 =?us-ascii?Q?o+UAGyJILn6sy8qnPvtx56bvubCfHw0fRwfwsaiNwVcDm7Trd1oZhiuYd1qW?=
 =?us-ascii?Q?N7RMljxa85q1PKTBWxe3kWPqhWYxtUXZtprPegOmrlsDC3WymQKheWrEWhtf?=
 =?us-ascii?Q?ak+ivKhsuv4x5BIQEI7aqG/rcHqrHqm7+3L6UV/q94oVf4PSYTCe9HtcHjz0?=
 =?us-ascii?Q?fDwFQJK/YCVO1FZGp5OkTa6HC7avjzbeiSLpX8Ax6rlGB0wBs085b+9U/JVK?=
 =?us-ascii?Q?zDgS5KYXPrDmlqvt/h23P1lx1tc3nN0sAEiKg7vMg85YQjsGCTnd5x1C6RWG?=
 =?us-ascii?Q?E43CRLyliMrP7tn9S3hG/K7EnTEu6vspQ/e1R2c13wwkwrEpL28vdqzx82uE?=
 =?us-ascii?Q?vBn7nXk5hM0p4wVrnsyx7nLLW6R5Lcv/AIDD+3BkLQv1X2tcjqjcjVD6o6+K?=
 =?us-ascii?Q?JEYwwsAQlsamKL3noVW4EJJ+WHmadBaGrzeLmztd0bxoWevFepLIB1K3qmBw?=
 =?us-ascii?Q?Dbk7U4XQf329rs/HDOnN+V+XzRnfMSZRUoeaNndG7HRWS+l0WrzzeVKgfaVv?=
 =?us-ascii?Q?ZOE65pbCK0Zg6LuaTI7T0TMcxfmUsqioST89rs2kXrFCuxDmjcYA7eMKSHyq?=
 =?us-ascii?Q?C6g90c9AS2nU/NmAa1DXJd0FW7CLmVFm3ujNY3549kYwVWMPrZdbtLpdZuI9?=
 =?us-ascii?Q?Tg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1da837a-b138-44b1-1dfa-08db3b542407
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 12:47:57.2774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jWECevEO4sCscfSMPAI9V+mcXhXs0jttNgHJVA/rVG53svh1lMSAI5eYxWo+Z+Olm1U0tS57NeY7ypojpxFkNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6888
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That comment was written prior to knowing that what I was actually
seeing was a manifestation of the bug fixed in commit b4024c9e5c57
("felix: Fix initialization of ioremap resources").

There isn't any particular reason now why the hardware initialization is
done in felix_setup(), so just delete that comment to avoid spreading
misinformation.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 6dcebcfd71e7..80861ac090ae 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1550,11 +1550,6 @@ static int felix_connect_tag_protocol(struct dsa_switch *ds,
 	}
 }
 
-/* Hardware initialization done here so that we can allocate structures with
- * devm without fear of dsa_register_switch returning -EPROBE_DEFER and causing
- * us to allocate structures twice (leak memory) and map PCI memory twice
- * (which will not work).
- */
 static int felix_setup(struct dsa_switch *ds)
 {
 	struct ocelot *ocelot = ds->priv;
-- 
2.34.1

