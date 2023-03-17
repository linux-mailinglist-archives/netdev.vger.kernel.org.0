Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DE16BF136
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjCQSzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjCQSzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:55:23 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A28474EC;
        Fri, 17 Mar 2023 11:54:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yn9Xqdh1Q4+DZPHLGO/PcCajm/fKegrjRuORwqtd/6RQCR/Uz/0hrbZpYHSdya+KWinsKXINc0ZLt6eK+0VCUe5WIkAF7wXlLGkV2UifpgLzgkTizR+m2INWWGL7NPG/jCtAXKJ4KLHvvohZPLmhA0SKayb98/DUlDm6I9sFVD0Kf3Ehn+ma2glKvzJPESW53B+u1hymzbAOnmZ/ftCSSpfBpREOJJGyDXD91zeb5iuGerkQJNS065DPBpGuIHpHFS0ZoXzWCM9/DgQzuQdgjwioNouUK454NCKEAUBT0SX55/faFVmiGUyCCK2p4QrTtD4MO/00oKlYttEvuTaKKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0c3jSAaoRCqaweuae6hEaYOqfgSm14WlCDiu/BgcAc=;
 b=JArcy5t0a37Rw/Pj738rmIk9RWypJy+rkA0WyiJXrI1OpO5hYmQ2uFlx+DuTBbDNPp4OLGwJ/1xoawIF6tkAIK69IYohamgNb/jiVrgJqZ31JJbk6rsRf2t4rmZniwj4RDK6GxNaWoqYDAGHks9kAs45kA08At9FCHFv+1RCWy1RJpPABF/sl1fT+Sezdkaxj36YwZ/fZfFr5VVwlE37vpRKliwEFxKCEylTORKRHzgxFoINCo7Q4C4kE8YcyMp8zujiaJyCOl0YYc4hhh87T2huHjiMch4L9PNMQVR4bR0sKcflWv5Z4uhdtv/+OURYRg1F2Pq0sHWblfn+pdbbWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0c3jSAaoRCqaweuae6hEaYOqfgSm14WlCDiu/BgcAc=;
 b=fupqhLzMJnujcH/7ZnfY28YIUxMl+DrrlPEPFh1ww6NyQBgyq6IX4wuAxQnq++7EFOoJokGpTxGCqaC67qUSSBfp3pZ44FwfIPygA9iMeqZNv8HaH/+JSIfYG+ViAyPhq666CNEE8y5Cj8rC/j2WdHXuQEGs+0HvSQYw9UNA4Ys=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB5289.namprd10.prod.outlook.com
 (2603:10b6:610:d8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 18:54:39 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 18:54:39 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [PATCH v2 net-next 8/9] net: dsa: felix: allow serdes configuration for dsa ports
Date:   Fri, 17 Mar 2023 11:54:14 -0700
Message-Id: <20230317185415.2000564-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230317185415.2000564-1-colin.foster@in-advantage.com>
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH0PR10MB5289:EE_
X-MS-Office365-Filtering-Correlation-Id: 3afc251d-89ce-4416-96ba-08db27190fa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o98XC90W+tNe43kXHT22JR1hHGcOhtmuS0BOGXYgC2C8xt3p6hMceuk4+qHgCbdXPn3Qe/WqSaz1ll5KHnW0RlVcEpIZH66JvW7q6sgjmOdmrUW0gLjzoRQdxPpSt3Ll/LH4oQH/azngY/vSI70p8vAi3C3PZfWWqp7iXu8UprNUEghFeawW/2blpUhEFAcB3Z9lq5nHO/dKWRikEGvm2x731JLxdxifmgsdZKPCkIfYyMmKnIMURU3qxvLVHbg/v03kWJ2JAdXpVC8YObn8UCJkPSY6Qt7S8TJ/WNpylAwoUx+HYOZgWrkSaVfFz3gKukuPhm9AyiubMrn3x+NCDwXnAu2yCuLOScasuCuNqySwqU3jNpROW2OBt7v+EUilL9VwVJtxaKBBZbdKR6+svV+LH6MC0UfW8T4JE1bor7rwHeWBwjHuc6RtR8ql/to4cYLQ+1FzMYYV6AjePZbrE4zICHCfCm3MnzsgTBBbhlDTVo2aTvPhrGt6djnVtMYaYN/YvkPkaVFEyfq73WLe8bqp2J7v4xsoKCeB2DGI1HahxjL5xLO6sMQT//+qjlct+RjR7kAsKavd4kmCNrj1dCldlb8wGdiHZCk6nCMw6exIclZ9rMlkblR5l0PZfkShvZOJipON9IDYNT4HqETJdvFp+WWdSNeX+UXVofIUqgLRdkZHJUZQLe10YSPDE/FHQvj0zsp2HBQD8sAvYC8c3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(366004)(376002)(136003)(39840400004)(451199018)(44832011)(41300700001)(8936002)(5660300002)(2906002)(7416002)(86362001)(36756003)(38100700002)(38350700002)(478600001)(52116002)(8676002)(6666004)(66946007)(6486002)(66556008)(66476007)(1076003)(4326008)(54906003)(316002)(6506007)(26005)(2616005)(6512007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZDpXDeEbM1Hjaw6jnx+RXbysGUsf5kRY4XyC3WqzVQpwnE+LtG/OZFAy2sKw?=
 =?us-ascii?Q?VPzlbDPhP/30qeohkXAlVg4NE4u/8pafpIq0tn6hLHIWED3GCpevD68yL7pR?=
 =?us-ascii?Q?nhFmt/Bbx8mnDo9EH/8A9705oar786aMd+zGiXVnjY1EOnDNvGj+M9IA6qTR?=
 =?us-ascii?Q?y5va1WyPsZsghhLJZjScvpBEW0TYPsrAo5ggqIiLy+HulQMMiB0BK6awOK2W?=
 =?us-ascii?Q?UusPd4ONyR1stJyQmBFcUowGx447SgrZ32Xsr+N0n/SyCt38WSQ12onDCbZO?=
 =?us-ascii?Q?0vobt8iMi/96rBZGBf7zVlyY1FRB9OmaBk+V+oITItfo8f0DiR+ZkS8FYNhB?=
 =?us-ascii?Q?UdKTF1AI80+OfnDQ9DE82YG26gAI95aYcQF92p8qrSXQCvdf1JTerZvPTiNE?=
 =?us-ascii?Q?uHQXL7AhPzIfcjNU53HAIHmLAdIld3V8QowDhDTTrTKebzMyykzRu+VLplym?=
 =?us-ascii?Q?p9/wsBT0LsE2ledzKtVuQT61viiEq7LT5esel/mONtl5bwaF+l5nAazEB58j?=
 =?us-ascii?Q?Sr1FDHN+Znx7KiLtJptq5/e/7jM+B5eu4ViuQSJuVYl3jJ99FamdztyRzsu0?=
 =?us-ascii?Q?HEnisQoA0QrSeN86LBlTvLffF+axbc+vBSgdnCutx55qnQLAgVH6cvKCzzJH?=
 =?us-ascii?Q?2pfp1+jy2cpVW51zxOf5VwEkXJsv013q/Ik/OLE+lwZpXJPnk7bSGqMPaxSU?=
 =?us-ascii?Q?yIja+YfwFr/PxS/NsoHj44tdbABhcVexEvrVwd7K/w9widmAfrHEuPpVtkjw?=
 =?us-ascii?Q?FemJAtv7b4WPfcA1C6e966tD0Yqb4Nv6yEjoETcAPp0il7fN8n2tujwHVU2U?=
 =?us-ascii?Q?DI9LH/rKI7adGiFgMP0/tx9xzS15UIuG4OZEmGb9hDu5Oa6oO8JJSouz2PA0?=
 =?us-ascii?Q?9/zgmdUd7UVpfbZDCQqzK5AJrTnbcrb0DUhpBq4R9Qvp2DfiBHlJYswinPGP?=
 =?us-ascii?Q?eMkFSjDZP/tu6QEcuKpM95Q44U3HiW1R1KVHDpIIN9VUCzy9FZzBDdL0q6q6?=
 =?us-ascii?Q?hP9p9+1D7mbCWth6z+3BtaR8C4iMq9Q7YUKgOLZjgkvx3HHwaYZ1h+6IHT0/?=
 =?us-ascii?Q?UBtbrg96XGlVOzOzhheLvWqTMCY6hZM6DDCApy9OQIxXBJd0sfuqg3FZJcv4?=
 =?us-ascii?Q?vCpYBbqHygA5fAsSQVr9wegWyxWOHZ6L1of5bm2WdBqtJGoCGHJLXYXhJ0FH?=
 =?us-ascii?Q?41z8ZsPWoiWw1iORgZCWLql1dBW7eP6ujCb70lwv9Ol1WmYBDnntFNEogtqA?=
 =?us-ascii?Q?vTSrKQyA04yh1pA7X/ceUnLvQbbOpZv3kiKbMQ+nnHdlQFBfhPDqcB3qahH4?=
 =?us-ascii?Q?2WmZ1HwyVw/fVCbsTPdrcdobBLxQZokxGergmXnIRiLVtp4gOSRPXd8cH7BP?=
 =?us-ascii?Q?YUI18eazQ8WDuVWe/rxeg3eeDFUPdhovSHj5r5Iul4P4DGgA9RMMCWenQ2Nh?=
 =?us-ascii?Q?yCwIZRjmU8MurMngHp3UTabladbjMVsbrmkcdbBoCUhdluL1F7ZOvxvB/tUh?=
 =?us-ascii?Q?2SGW8e7XWyDkYX56alAhfmB1/mOuwcgCBoN4PmWbHtVjM9X3pbPSo7wdt8Md?=
 =?us-ascii?Q?jr/t9EoW2kS3V20+DeINy+xs1gO9gTgwOKc0cwEJd8s5TGN7cHIJ1hCkj5kE?=
 =?us-ascii?Q?jXO1Py7OYk/Wl96sMIFXy7A=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3afc251d-89ce-4416-96ba-08db27190fa9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:54:39.5370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4xuPsZpcy+ljpEQmUhy3JQFxFkg9ld1JkNCI/6eV+DPVhMZK1BS3bjWty32dRnGHeXfwa1tDuox6qlkOm+LmtgpgrTWegVYPOfvHoD9tWpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5289
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ports for Ocelot devices (VSC7511, VSC7512, VSC7513 and VSC7514) support
external phys. When external phys are used, additional configuration on
each port is required to enable QSGMII mode and set external phy modes.

Add a configurable hook into these routines, so the external ports can be
used.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2
    * New patch

---
 drivers/net/dsa/ocelot/felix.c | 4 ++++
 drivers/net/dsa/ocelot/felix.h | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 845068bcbeb4..6dcebcfd71e7 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1585,6 +1585,10 @@ static int felix_setup(struct dsa_switch *ds)
 	dsa_switch_for_each_available_port(dp, ds) {
 		ocelot_init_port(ocelot, dp->index);
 
+		if (felix->info->configure_serdes)
+			felix->info->configure_serdes(ocelot, dp->index,
+						      dp->dn);
+
 		/* Set the default QoS Classification based on PCP and DEI
 		 * bits of vlan tag.
 		 */
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 98771273512b..96008c046da5 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -15,6 +15,8 @@
 #define OCELOT_PORT_MODE_USXGMII	BIT(4)
 #define OCELOT_PORT_MODE_1000BASEX	BIT(5)
 
+struct device_node;
+
 /* Platform-specific information */
 struct felix_info {
 	/* Hardcoded resources provided by the hardware instantiation. */
@@ -61,6 +63,8 @@ struct felix_info {
 	void	(*phylink_mac_config)(struct ocelot *ocelot, int port,
 				      unsigned int mode,
 				      const struct phylink_link_state *state);
+	int	(*configure_serdes)(struct ocelot *ocelot, int port,
+				    struct device_node *portnp);
 };
 
 /* Methods for initializing the hardware resources specific to a tagging
-- 
2.25.1

