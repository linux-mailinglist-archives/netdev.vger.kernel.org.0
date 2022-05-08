Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D9651EF2A
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238362AbiEHTF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbiEHS5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:45 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2102.outbound.protection.outlook.com [40.107.220.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA29A1B1;
        Sun,  8 May 2022 11:53:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZsxDBy7pTYHpj2s1V7NqmgypGF0DYQ1drXGf1gnp6djfYXNFCQPhCZG3se27cFh5Zp76EOiW8hVt/Vp/oDLbc/jqNWVWj5yEdAuPYber3K3fetawIO8RWic1FNpQH15/S8MwEc7tHTHdhogJMR2O/8KlN18bFpk6/E/N76V9HgXhg86aQLhMYYwu/LrcHab1BnHzG6sdcHInaU53joxhL1RDU9dybWUfRylpzCubVKFTfSLkkQsAEfD8iOfo4702nE7t/unxNSzwRA3i/B/cP8lmZUIY00DJRurko/ilXboNRW2M6dUaR6Lqdp8+MEbNtKa2/OjW71Jdo9G9RlpKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jht0BpWcJRTHFvJRgbv6zaCcBdyebYpgiTuhrzO+5mA=;
 b=nGYwRAvdR2J5ZHt4LrsqgqhtekAXABk4tjyXUjBfP+oHa0UIvSDDb/stYteNjtfKJgIdjj82HNfanSQ28By/EPbhFLQjT/Z8Olzrq+zsrBU0Iwz35t+XDFcmaQHppV9GFZy/12o6UweZQq/AK7oXy4ToVqo0CuMWCcvpo19/1Jf6UiBMmfcQ2KeTIwEfCEQrC/ij8LxirmwS3LK9GJ5hgGvd9TYZAlSgINTaKerfewwdtFhP3PTeRC5HsKlPwcki/JCT3gjU0RBP5PCMWfmwjWWqmn06EYx+xiKel06FEin7DeNcCo7yAaWwGRAA9stD1gjYep8sBSMDzhTMASPMsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jht0BpWcJRTHFvJRgbv6zaCcBdyebYpgiTuhrzO+5mA=;
 b=trY32lhpQt686ztp39oTxVB8u67f+RMdFAWN8i8bjFqYYfWJA+kGWHUP3qQNqUqUV0SG3tbqK7Z2BJLzQUVwogj7YNe+jisyPxOMSDjcmu9RaAr2JUh5mVHPuiYoxwsUCQujJqgXd4+yNb5uSBDXDsKBdYXLa+xxdtRw3mx+RxY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5672.namprd10.prod.outlook.com
 (2603:10b6:a03:3ef::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Sun, 8 May
 2022 18:53:53 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:53:53 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v8 net-next 11/16] net: mscc: ocelot: expose regfield definition to be used by other drivers
Date:   Sun,  8 May 2022 11:53:08 -0700
Message-Id: <20220508185313.2222956-12-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185313.2222956-1-colin.foster@in-advantage.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2358fb44-91e6-47a5-f69e-08da312418b2
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5672:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5672A70BBEBD461A30613CDAA4C79@SJ0PR10MB5672.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZYB70u66F2DILRYBHq22yeLm/KjL0Yt+L0ZGSseriRjcPutEp+U8WCgxLpWEmSdUeG6cTkgHnK++kt3iWUnL/GtPnTcLgoL0aPWn6puQioucEK5JWtz2LjRHzDxEnNatotrMSfA4Z964hUyCkWbDoITVuaEaCOvv7+9b/88vwgt+fnZyZRQ+lYVytlYvz4XCcK9HpoMbsV1yaDPFVSFgereHj4ZCApns6CXGEEbi2oTlzLtLIcefE/m+7uc+JijA1caAqzAgzyeqBUzhGM1u8Cms9tj4RnImBrqi+7NVAAjxy5tUoteZGgVBbRTN1cFy2HiGwAa5Xhwe/8Qh9nJIqONlTRz7U+ihadwuTnP5oG5VFusVnnoX1S5up2M5mcWqPWc02l0BoLuQcrWBKSnjM5zNvwX0YUlaz9GRqCFSHW6K475JOE/W+UzB8HzomRbY08nHB9VTFqvuQNCeWFTSLMl3fMbvcMm2hLWHeJW42XdjjKpbO6IUbUrQs7LAwouDDTQ7R/JrK7CbQzHTuNE9br55soDcj7aIy5rfrJUJou47589gXsM5bN06UKj5dLj9M2OGS99MkjS6XIZJBFqpBtNlllvgPOjw+XqGS2CKusKlAsxgmU1ZT550dc2e7kgDMQtPhuF3w9zoHYxJcK/LX5xShHREKIUDE0dldS7lGlxRWWKXjJ6GBphV+40/QhhkMeh8Uu3dZcOoSNLcyc5n/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(396003)(366004)(346002)(376002)(136003)(6506007)(6666004)(6512007)(2906002)(8676002)(7416002)(52116002)(8936002)(4326008)(36756003)(5660300002)(86362001)(44832011)(66556008)(66476007)(26005)(30864003)(2616005)(66946007)(6486002)(508600001)(38350700002)(1076003)(38100700002)(54906003)(186003)(316002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+vBcpq2rWPMStgqdxRhZx7EigdUPuhdXVLsU7GHqjSQBvAIS6a7D+PGTPWVV?=
 =?us-ascii?Q?VnlcwzIlNChgCTy8SkkChL6zLbbWYPFhAITIyI7MByal/dcoPJlo9idkxITF?=
 =?us-ascii?Q?KxWTF2fKWPPPDX0CtW6uys5VlUFzlSh7uxn2ZkaOTWB1vhkzMk7L3CCfkA/D?=
 =?us-ascii?Q?iEZi6odGEFsEvfOh7vK17qjTP4pULhQgYg9f0VP+3QXMoB6X6Lnd2sjuCPqG?=
 =?us-ascii?Q?O6XgGECnVaEK1VYKkF9R5OyN4kCqAj4sL0JWv3nJ9ECdy+DI/5VlY+AuNYMx?=
 =?us-ascii?Q?xSOsQLq290Z78CXPk34CMrzlKfj3MSGhyMB2F5QP38+7xzS1usLLqJRrKtjV?=
 =?us-ascii?Q?8CGILky//kBhIk/VEbLzznEg166d5X/SCuWj4XUQ/c05uJIY4KPJd4FRCxVS?=
 =?us-ascii?Q?X6/uJJCP7McSoRK5eGl4DWJb5Kmv1L13LhjowuemdB5eUxJjMMlZHs1fd5y8?=
 =?us-ascii?Q?yKQpKDn7XOaDnNFRi0kOlxxOC0WU0xFVcKSvW6b9vOVyvjng98Qrr2YIGkLb?=
 =?us-ascii?Q?WgmTPdlO3qLnhRjq2JfFX4EARFgI8YTfUuetP/KpntimzCGSkxOpY1zcTAsi?=
 =?us-ascii?Q?5+z/LJZCndJG5Bb1DkyjcuNFuS2rN98LGfdCvjN9iTX5Ow3yfOnkcIGJJjaL?=
 =?us-ascii?Q?hW0YnvuYflWEwdebnRz3AVYrrszrRst4EsFeZylhxBUFSFNPzrrnD/YgLnpo?=
 =?us-ascii?Q?97peMwiE09YcypaBEvduBZcisVUPdyJumY4DgNzkrxGGyxh2EjGhP6L4hm2a?=
 =?us-ascii?Q?ZIER+LKr8HAp+oUk7PmZ9vKGQfUSIpNOrP/J6DWaqb8sIqF1uXyC3svzWTdT?=
 =?us-ascii?Q?+JvZSxJl3/FoOY6vS91h63beGfi3BZkUmW2PmNd58+ldUMnAamEpzX27Fw7l?=
 =?us-ascii?Q?KDAK6DGtrINaECdyArC+BqKQlbTzmnE3grzigK0RwbVOUZF7uHq7Q1TJN8h3?=
 =?us-ascii?Q?AbXGINKft6b5RvQ/6cOgHhpuZVLcgsSHt6Meagu27aYj/JDriM8SRzJH462I?=
 =?us-ascii?Q?kz0Hp3pORiCNdiN4i196Ur05WH1emyVpWYqrHEY29C2ICTnje/QLdbk0h++H?=
 =?us-ascii?Q?e7LEBKyMSFZ3XSbe9CZMg7m5sdFw1tEEZuWbJL+ffTkDnRTbMOWZxCvg2Fke?=
 =?us-ascii?Q?+i1lFIrfCYWMtEEyDEU8BQoeCttKMWTW39ipkUGAwvRRnCwXY7ZezninLi4+?=
 =?us-ascii?Q?EdrL2wOpdnOUMZz3DuDNyA9mcAk5pJH0y8eivkIO01urfj90naaqEwBQlwbk?=
 =?us-ascii?Q?r056FSWmeKK8/yxX4jWl1VYCKeIVgukOFpwfBulYmwvYSIFD45GlPBtchmJn?=
 =?us-ascii?Q?Wi58HD6j2n9N22NBvsNcNB0ep6iUjzTC00t1CD5mdB2XTnLj1VBkUCALWTy2?=
 =?us-ascii?Q?3XaPlbdQ4kZPCNSD2TEETuUJeJ+D3MJ+mY+2ojLVFOqchW9/9j/PqcUeIif2?=
 =?us-ascii?Q?g7zykMivqHAM2t4Kn3IKvGGCwCofHV+J6P8qlvWoXYcxkVPbUjzyeG6pZygY?=
 =?us-ascii?Q?MucGXR/RUK6Oy1fRQn63khDpve3GcOEr3YKTlvz65CUFM60owZoce7D1OWJC?=
 =?us-ascii?Q?At2M+I7Q0ReOM3+iLpGow+CM1csKQRDC2wOA7SwhO6Eaf7qDk5yr9F8CCscV?=
 =?us-ascii?Q?a0+9kylIWgzvrjYjl2q6jTDgP9/otCBwAWf9KOZwDknT7jYgH2xT1TA3egFD?=
 =?us-ascii?Q?twHm3jk3LGigWNA66kPrxzuMT65t/JFZfgpMKvRvNipFKBarQ6lJkixTSfq0?=
 =?us-ascii?Q?Gg9Mlodp5+b9xFRSBsmqMTnqH6+sCSLpIccdBdjofaqIrEeocL9G?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2358fb44-91e6-47a5-f69e-08da312418b2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:53:53.1811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oFpvI+rXI4fAVQqVz5rR/9z8dbuAJO4jKhIOyd+IyVMECAnQArxUGfipmlCCGREn0aBv9p3jpKa/4Wt3GkhqJndIKJTb7PlVNWpiv7HIYfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5672
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot_regfields struct is common between several different chips, some
of which can only be controlled externally. Export this structure so it
doesn't have to be duplicated in these other drivers.

Rename the structure as well, to follow the conventions of other shared
resources.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 60 +---------------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 59 +++++++++++++++++++++
 include/soc/mscc/vsc7514_regs.h            |  2 +
 3 files changed, 62 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 68d205088665..a13fec7247d6 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -38,64 +38,6 @@ static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[DEV_GMII] = vsc7514_dev_gmii_regmap,
 };
 
-static const struct reg_field ocelot_regfields[REGFIELD_MAX] = {
-	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 11, 11),
-	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 10),
-	[ANA_ANEVENTS_MSTI_DROP] = REG_FIELD(ANA_ANEVENTS, 27, 27),
-	[ANA_ANEVENTS_ACLKILL] = REG_FIELD(ANA_ANEVENTS, 26, 26),
-	[ANA_ANEVENTS_ACLUSED] = REG_FIELD(ANA_ANEVENTS, 25, 25),
-	[ANA_ANEVENTS_AUTOAGE] = REG_FIELD(ANA_ANEVENTS, 24, 24),
-	[ANA_ANEVENTS_VS2TTL1] = REG_FIELD(ANA_ANEVENTS, 23, 23),
-	[ANA_ANEVENTS_STORM_DROP] = REG_FIELD(ANA_ANEVENTS, 22, 22),
-	[ANA_ANEVENTS_LEARN_DROP] = REG_FIELD(ANA_ANEVENTS, 21, 21),
-	[ANA_ANEVENTS_AGED_ENTRY] = REG_FIELD(ANA_ANEVENTS, 20, 20),
-	[ANA_ANEVENTS_CPU_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 19, 19),
-	[ANA_ANEVENTS_AUTO_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 18, 18),
-	[ANA_ANEVENTS_LEARN_REMOVE] = REG_FIELD(ANA_ANEVENTS, 17, 17),
-	[ANA_ANEVENTS_AUTO_LEARNED] = REG_FIELD(ANA_ANEVENTS, 16, 16),
-	[ANA_ANEVENTS_AUTO_MOVED] = REG_FIELD(ANA_ANEVENTS, 15, 15),
-	[ANA_ANEVENTS_DROPPED] = REG_FIELD(ANA_ANEVENTS, 14, 14),
-	[ANA_ANEVENTS_CLASSIFIED_DROP] = REG_FIELD(ANA_ANEVENTS, 13, 13),
-	[ANA_ANEVENTS_CLASSIFIED_COPY] = REG_FIELD(ANA_ANEVENTS, 12, 12),
-	[ANA_ANEVENTS_VLAN_DISCARD] = REG_FIELD(ANA_ANEVENTS, 11, 11),
-	[ANA_ANEVENTS_FWD_DISCARD] = REG_FIELD(ANA_ANEVENTS, 10, 10),
-	[ANA_ANEVENTS_MULTICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 9, 9),
-	[ANA_ANEVENTS_UNICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 8, 8),
-	[ANA_ANEVENTS_DEST_KNOWN] = REG_FIELD(ANA_ANEVENTS, 7, 7),
-	[ANA_ANEVENTS_BUCKET3_MATCH] = REG_FIELD(ANA_ANEVENTS, 6, 6),
-	[ANA_ANEVENTS_BUCKET2_MATCH] = REG_FIELD(ANA_ANEVENTS, 5, 5),
-	[ANA_ANEVENTS_BUCKET1_MATCH] = REG_FIELD(ANA_ANEVENTS, 4, 4),
-	[ANA_ANEVENTS_BUCKET0_MATCH] = REG_FIELD(ANA_ANEVENTS, 3, 3),
-	[ANA_ANEVENTS_CPU_OPERATION] = REG_FIELD(ANA_ANEVENTS, 2, 2),
-	[ANA_ANEVENTS_DMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 1, 1),
-	[ANA_ANEVENTS_SMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 0, 0),
-	[ANA_TABLES_MACACCESS_B_DOM] = REG_FIELD(ANA_TABLES_MACACCESS, 18, 18),
-	[ANA_TABLES_MACTINDX_BUCKET] = REG_FIELD(ANA_TABLES_MACTINDX, 10, 11),
-	[ANA_TABLES_MACTINDX_M_INDEX] = REG_FIELD(ANA_TABLES_MACTINDX, 0, 9),
-	[QSYS_TIMED_FRAME_ENTRY_TFRM_VLD] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 20, 20),
-	[QSYS_TIMED_FRAME_ENTRY_TFRM_FP] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 8, 19),
-	[QSYS_TIMED_FRAME_ENTRY_TFRM_PORTNO] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 4, 7),
-	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_SEL] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 1, 3),
-	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_T] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 0, 0),
-	[SYS_RESET_CFG_CORE_ENA] = REG_FIELD(SYS_RESET_CFG, 2, 2),
-	[SYS_RESET_CFG_MEM_ENA] = REG_FIELD(SYS_RESET_CFG, 1, 1),
-	[SYS_RESET_CFG_MEM_INIT] = REG_FIELD(SYS_RESET_CFG, 0, 0),
-	/* Replicated per number of ports (12), register size 4 per port */
-	[QSYS_SWITCH_PORT_MODE_PORT_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 14, 14, 12, 4),
-	[QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 11, 13, 12, 4),
-	[QSYS_SWITCH_PORT_MODE_YEL_RSRVD] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 10, 10, 12, 4),
-	[QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 9, 9, 12, 4),
-	[QSYS_SWITCH_PORT_MODE_TX_PFC_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 1, 8, 12, 4),
-	[QSYS_SWITCH_PORT_MODE_TX_PFC_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 0, 0, 12, 4),
-	[SYS_PORT_MODE_DATA_WO_TS] = REG_FIELD_ID(SYS_PORT_MODE, 5, 6, 12, 4),
-	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 12, 4),
-	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 12, 4),
-	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 12, 4),
-	[SYS_PAUSE_CFG_PAUSE_START] = REG_FIELD_ID(SYS_PAUSE_CFG, 10, 18, 12, 4),
-	[SYS_PAUSE_CFG_PAUSE_STOP] = REG_FIELD_ID(SYS_PAUSE_CFG, 1, 9, 12, 4),
-	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 12, 4),
-};
-
 static const struct ocelot_stat_layout ocelot_stats_layout[] = {
 	{ .name = "rx_octets", .offset = 0x00, },
 	{ .name = "rx_unicast", .offset = 0x01, },
@@ -231,7 +173,7 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	ocelot->num_mact_rows = 1024;
 	ocelot->ops = ops;
 
-	ret = ocelot_regfields_init(ocelot, ocelot_regfields);
+	ret = ocelot_regfields_init(ocelot, vsc7514_regfields);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index c2af4eb8ca5d..847e64d11075 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -9,6 +9,65 @@
 #include <soc/mscc/vsc7514_regs.h>
 #include "ocelot.h"
 
+const struct reg_field vsc7514_regfields[REGFIELD_MAX] = {
+	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 11, 11),
+	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 10),
+	[ANA_ANEVENTS_MSTI_DROP] = REG_FIELD(ANA_ANEVENTS, 27, 27),
+	[ANA_ANEVENTS_ACLKILL] = REG_FIELD(ANA_ANEVENTS, 26, 26),
+	[ANA_ANEVENTS_ACLUSED] = REG_FIELD(ANA_ANEVENTS, 25, 25),
+	[ANA_ANEVENTS_AUTOAGE] = REG_FIELD(ANA_ANEVENTS, 24, 24),
+	[ANA_ANEVENTS_VS2TTL1] = REG_FIELD(ANA_ANEVENTS, 23, 23),
+	[ANA_ANEVENTS_STORM_DROP] = REG_FIELD(ANA_ANEVENTS, 22, 22),
+	[ANA_ANEVENTS_LEARN_DROP] = REG_FIELD(ANA_ANEVENTS, 21, 21),
+	[ANA_ANEVENTS_AGED_ENTRY] = REG_FIELD(ANA_ANEVENTS, 20, 20),
+	[ANA_ANEVENTS_CPU_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 19, 19),
+	[ANA_ANEVENTS_AUTO_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 18, 18),
+	[ANA_ANEVENTS_LEARN_REMOVE] = REG_FIELD(ANA_ANEVENTS, 17, 17),
+	[ANA_ANEVENTS_AUTO_LEARNED] = REG_FIELD(ANA_ANEVENTS, 16, 16),
+	[ANA_ANEVENTS_AUTO_MOVED] = REG_FIELD(ANA_ANEVENTS, 15, 15),
+	[ANA_ANEVENTS_DROPPED] = REG_FIELD(ANA_ANEVENTS, 14, 14),
+	[ANA_ANEVENTS_CLASSIFIED_DROP] = REG_FIELD(ANA_ANEVENTS, 13, 13),
+	[ANA_ANEVENTS_CLASSIFIED_COPY] = REG_FIELD(ANA_ANEVENTS, 12, 12),
+	[ANA_ANEVENTS_VLAN_DISCARD] = REG_FIELD(ANA_ANEVENTS, 11, 11),
+	[ANA_ANEVENTS_FWD_DISCARD] = REG_FIELD(ANA_ANEVENTS, 10, 10),
+	[ANA_ANEVENTS_MULTICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 9, 9),
+	[ANA_ANEVENTS_UNICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 8, 8),
+	[ANA_ANEVENTS_DEST_KNOWN] = REG_FIELD(ANA_ANEVENTS, 7, 7),
+	[ANA_ANEVENTS_BUCKET3_MATCH] = REG_FIELD(ANA_ANEVENTS, 6, 6),
+	[ANA_ANEVENTS_BUCKET2_MATCH] = REG_FIELD(ANA_ANEVENTS, 5, 5),
+	[ANA_ANEVENTS_BUCKET1_MATCH] = REG_FIELD(ANA_ANEVENTS, 4, 4),
+	[ANA_ANEVENTS_BUCKET0_MATCH] = REG_FIELD(ANA_ANEVENTS, 3, 3),
+	[ANA_ANEVENTS_CPU_OPERATION] = REG_FIELD(ANA_ANEVENTS, 2, 2),
+	[ANA_ANEVENTS_DMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 1, 1),
+	[ANA_ANEVENTS_SMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 0, 0),
+	[ANA_TABLES_MACACCESS_B_DOM] = REG_FIELD(ANA_TABLES_MACACCESS, 18, 18),
+	[ANA_TABLES_MACTINDX_BUCKET] = REG_FIELD(ANA_TABLES_MACTINDX, 10, 11),
+	[ANA_TABLES_MACTINDX_M_INDEX] = REG_FIELD(ANA_TABLES_MACTINDX, 0, 9),
+	[GCB_SOFT_RST_SWC_RST] = REG_FIELD(GCB_SOFT_RST, 1, 1),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_VLD] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 20, 20),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_FP] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 8, 19),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_PORTNO] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 4, 7),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_SEL] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 1, 3),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_T] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 0, 0),
+	[SYS_RESET_CFG_CORE_ENA] = REG_FIELD(SYS_RESET_CFG, 2, 2),
+	[SYS_RESET_CFG_MEM_ENA] = REG_FIELD(SYS_RESET_CFG, 1, 1),
+	[SYS_RESET_CFG_MEM_INIT] = REG_FIELD(SYS_RESET_CFG, 0, 0),
+	/* Replicated per number of ports (12), register size 4 per port */
+	[QSYS_SWITCH_PORT_MODE_PORT_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 14, 14, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 11, 13, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_YEL_RSRVD] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 10, 10, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 9, 9, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 1, 8, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 0, 0, 12, 4),
+	[SYS_PORT_MODE_DATA_WO_TS] = REG_FIELD_ID(SYS_PORT_MODE, 5, 6, 12, 4),
+	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 12, 4),
+	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 12, 4),
+	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_START] = REG_FIELD_ID(SYS_PAUSE_CFG, 10, 18, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_STOP] = REG_FIELD_ID(SYS_PAUSE_CFG, 1, 9, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 12, 4),
+};
+
 const u32 vsc7514_ana_regmap[] = {
 	REG(ANA_ADVLEARN,				0x009000),
 	REG(ANA_VLANMASK,				0x009004),
diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
index ceee26c96959..9b40e7d00ec5 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -10,6 +10,8 @@
 
 #include <soc/mscc/ocelot_vcap.h>
 
+extern const struct reg_field vsc7514_regfields[REGFIELD_MAX];
+
 extern const u32 vsc7514_ana_regmap[];
 extern const u32 vsc7514_qs_regmap[];
 extern const u32 vsc7514_qsys_regmap[];
-- 
2.25.1

