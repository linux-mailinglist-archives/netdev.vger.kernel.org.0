Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9665B5105
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 22:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiIKUDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 16:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiIKUDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 16:03:03 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2121.outbound.protection.outlook.com [40.107.243.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F8027FE3;
        Sun, 11 Sep 2022 13:03:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aXLCqClc3d6TQSJTr5Q0p0F9jD0+WhitbCx/z1dUPp9arvUF+z7m6K7wOoeSRcq3S5Ea39TsUNbLWjD3jxJnbM8pEvUPes+D4iI7BdBPWW/wNYqrzwl7BiSLinL+lOwfHmCS+kfQv7jfJPURfIhTf/A6mZOkZU1IspJbaKfnvCI44XdZ8Qhh3626KtXmF/cprwpKWOVC3N8J7Pthox3pelo7NvWMvIPKeVyx/N/zZST14OMKZQUX0ymlliuOEMf1R5+80mlBxIbvzPR4OU23dVhujHovdsV5lnbdA9NdO4InOyGoneD+c2CdltFY18CeF27HGOz0rsOCTE7TDeItqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GAmdHPCBjDcX+tdKeuxWgjqHyY3r+eLZbsLSB88FaTQ=;
 b=bGuw/pz80aIDkvLR9YfR4cSoY2mn8/ekFHDDfpA5y09ojmbhvRB+T0ZpgIwudijKVya7U0kO1zAzzSRZV6kr1qAlM46tg9rHKyMXeRuE3MWX7+Us6fDVRaDo8c6EKS+j94e829OlAl5j96NPnpaCkLQS04IUsn3tdo+A/otjUw/uh0oewgitzQCxrxHvSUweN4QxQiMxr5O1zlz/Iw6E6PJ2eqrhQ4xA0zX06XvDkJWPpZAGsn2o/dW0JgO00DCiT4aybcTgVBNzpHXisjH5d9LpObkOUzZQI6QxEnfiyCT8sQhRZl3dUUXOF7k3pkA/g58v+z0GK8pGNWRbU+L/wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GAmdHPCBjDcX+tdKeuxWgjqHyY3r+eLZbsLSB88FaTQ=;
 b=jh06S8aicYD/eDERHV/kM8uRvjFrCRXWy9L2wizueUywhrp8wI5Ir8Wr5jbKhKA2Nh8eG/sKdYD8zl2W4lgCznkkNC5iLAupU0Rn1P1YtHBbVTQdVMWlM0+fqv/4aIS0SgG/ejCbc1kqn4QcEmqideem57dg2FkwIffrnS15gZM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB5335.namprd10.prod.outlook.com
 (2603:10b6:408:127::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Sun, 11 Sep
 2022 20:02:56 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Sun, 11 Sep 2022
 20:02:56 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
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
        Lee Jones <lee@kernel.org>
Subject: [RFC v1 net-next 2/8] net: mscc: ocelot: expose regfield definition to be used by other drivers
Date:   Sun, 11 Sep 2022 13:02:38 -0700
Message-Id: <20220911200244.549029-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220911200244.549029-1-colin.foster@in-advantage.com>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0318.namprd03.prod.outlook.com
 (2603:10b6:303:dd::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 054a6159-5515-4e26-3cce-08da94309ddf
X-MS-TrafficTypeDiagnostic: BN0PR10MB5335:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eUuXUWDksiGXLMBNQ64sEs8TviDdadZEBMds93G245aDz/+IUSlB551tz9X2X+Vfj+mFPyFQ/HXKdqpuVKU2+jilDoxZ0gfR0wxObAxiD4Vn6mbjg21CUgm6MOebVt1lUi1bokcKA/udTpKz7N9OVVkfwd7xZSyjYhNWz2WaD6wyrtl2xoberKOVc4Ii9LvUSyNO75VhxChmLS6ZifZ0rMq1oo/2G6PB+cEj6cFzUpE/6iiBS62Zgqmsqc7Ngl+GUWCinFQ0ro/0Z3PtsuNvoc9rfHMQAJhv0wD2vVJmfV155z6pNm7d5TDf3/3AmY7waQbUbI9AdwcOM+T6cDoQ4EVUMjnVzTBUN7FH/mGoColxCGf0ksZZPWd5hzPcVb+EfFXiPrtttNrb/S7o/MxwG2n3yjQM/qcUUpWN5RSKzIGUQfZ7JWaRRC9niUtm8KB37KINEhpKYdfKoYcMJ7Jr/yMxFZA4cZZsvLOIjdZF1zQ0BP1u+hZb1gBILp7aBlwZwFI1FkPvPcHLdiAvFOIvxOhOvka/ymxBsMypsQN4p0y7aDIINCKwrXI66NVXUFcBFTW79kkGmgIBoa4ZdY3I2jr/HGOxqcCFAXQYWksIL9YZ1YxMGw8DjS4iUkJI0/Fqbp2Q5i6Xztob4EByqA8Htsa95P/kk6H5naGNnEzDAxFDE2Yi4UmAb/Yw47HMgRAqtGMZhcKkUBZwimA/1kpgqLOsgEyZzze1vHslJyL4l0V7VHOc0GunNItTB/LJHdDZ3VfAIENdNacuwksWK52wPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(366004)(39830400003)(376002)(346002)(38350700002)(38100700002)(8676002)(4326008)(66946007)(36756003)(86362001)(66556008)(66476007)(2906002)(83380400001)(186003)(2616005)(6512007)(6506007)(1076003)(52116002)(478600001)(6486002)(6666004)(26005)(316002)(54906003)(30864003)(44832011)(41300700001)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WrvwxI1+lDzim9bfL+18RHlWIAmdEwmeeiHh/BgEkYnvj4In72CJW+g05YJh?=
 =?us-ascii?Q?/eCfgA66gQDi+3aJZZMxofOBHUDN0COMsUjCDqNV7FU2jbEzeM3BtkCTmzMk?=
 =?us-ascii?Q?NJ8RIOKLyjGeFzSYb8x7kwBmEE9nXXB7LEk55tMCNFo2JvY1nB3FKYQS5DiZ?=
 =?us-ascii?Q?RcU/opSNLbJL7W6Ef1wZZhj3aPwdCNgRnEML30oy98OBQf6rqqhlBe2OJ0Bl?=
 =?us-ascii?Q?KlNIQhEeTv1l0LTYr0p2t4vohNchT5Izwc/ZjJAt2J8GPPKKtBWaap8sC68N?=
 =?us-ascii?Q?IHjHvvQ44JY+9mh4+p/F8pNVICj2H3OD5Vruwf5AFl+edfXE0S6LMzVnwtSh?=
 =?us-ascii?Q?hAIjk/KHE7bfOzJiXXKlnzwNPpiji8Zy/GDBj0EBN7ZsHJgAx82ESXy2Zibj?=
 =?us-ascii?Q?PdasvkoLmyibTylrb3Z2KyImzcW6bI077FoXILaGFWBTCCT2BBepbk+uRnus?=
 =?us-ascii?Q?DGBxmxiK1Bt+Fcjsfyy0zgkrlPcTUMFIGUHaKFmWDqmKeWw1WPRBF2Dke+UI?=
 =?us-ascii?Q?sEeT5lT9zbVRgXgAQGgmHXWdP+jWQTf9TOEnY/yuCcIFZ7tapepW58b908or?=
 =?us-ascii?Q?MWkSBqHZh836LYjEzjh0VB1Ipz4WCyCqOGpFfcBSFIGCSjaoxPNC0aGvZE1R?=
 =?us-ascii?Q?MRdpU96N19Y/i8ZL2GWZfxcJ0nUyybKye3TeeeV60AYK18QlKeUNCuLrqrI5?=
 =?us-ascii?Q?ufjzWBtkcIKGZhpNFgbzP8LTO0AGTCVopMT3/o1u81U0OLXBtKe/pWZKgxre?=
 =?us-ascii?Q?PSaEp7GXwJaxhSlT7iDsdGFhHRR7c3/Vr66L/KdsoX5eTvliJWhIuWduyO9O?=
 =?us-ascii?Q?Tw3QdWPCFkpwcGz91EmgoBxjgSGvb2Rfgb40HqL4EaWfNjio1flO/aNI6568?=
 =?us-ascii?Q?zoBv9wMaS7n+UJmCodq1PoQOLV5M6u1yY85RQiQWr0Ls/cbCejoclpjVOMRs?=
 =?us-ascii?Q?7VZYJ8Zw+V7F2GQgWzIsF2y+eIUom8HgnVVzu127aSjENjHjcPHbNF63tCwb?=
 =?us-ascii?Q?dOR8MpL1NOFSD9lvjaYIUfLBnCLBJcAtwMPJIeKkR4F8xXuZp7hnHUtKFzMq?=
 =?us-ascii?Q?yTe8BrBmnq3BAQpA2ZI1na8mFgXYKRs1wp8II0z6YXG9C/TkypjjtpTFW365?=
 =?us-ascii?Q?c1OPXnRtU995TvBJI1GGi0ocC//qAkPGkbYBNKeHaCYbVCanVLwlUnFFtPD9?=
 =?us-ascii?Q?3RQ8gQ4HdH7i+ezeAN5hpS2cqO2IATbJLC9E7wJ9Bk7ZPUyQSSuouIwCpMug?=
 =?us-ascii?Q?zf/9andekE+OFwgfyvRSfQ4YiBYtWdL7+iEdIaJMVcf0f7ddGcgRw1Oy8/xD?=
 =?us-ascii?Q?ExAWOnW/doZjz93/MFBYBCElU2qetbaSoVoReSiy6M1KK3TcI2pwl6ZE8thF?=
 =?us-ascii?Q?jg6WGxera/EuBKmMnRYlqE3FyESrABL1NWraDi90yHgcgII0j0MF9CHLhdiE?=
 =?us-ascii?Q?kMEM3LsLnNd8IUzC4BgdnECdOu1iHhyGoqcTUFMNdEskc5Hd4V81IcqNKWT+?=
 =?us-ascii?Q?O7b0kQPsqRA0eCvih8HHTmbuEk77gxuBKjhFy/C+vHZiX15C37VymY9AM1+w?=
 =?us-ascii?Q?lrWLk7JeF02Aa2YPpiTsGdmBAJWlbR4J64/H6fYMcNDs/34CPCm0IWIun3/4?=
 =?us-ascii?Q?hUwxEw0exUcRdjYNDPGZQlA=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 054a6159-5515-4e26-3cce-08da94309ddf
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 20:02:55.5746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +zQ3TQinl6yxBxIQYYslFTIeTP3xHBlNBikzUO4jhhYCSzZFFiI7lawVF/PN8c881JHGj8axl4xI+0/EG8J6KXHfH1rntI6ubzMJemqQXzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5335
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

v1 from previous RFC:
    * Remove GCB_SOFT_RST_SWC_RST entry from the regfields struct - it
      isn't used.
    * Export the vsc7514_regfields symbol so it can be used as a module.

---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 60 +---------------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 59 +++++++++++++++++++++
 include/soc/mscc/vsc7514_regs.h            |  2 +
 3 files changed, 62 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 80e88bfd38ad..e9c7740f20e9 100644
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
 static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
 	OCELOT_COMMON_STATS,
 };
@@ -138,7 +80,7 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	ocelot->num_mact_rows = 1024;
 	ocelot->ops = ops;
 
-	ret = ocelot_regfields_init(ocelot, ocelot_regfields);
+	ret = ocelot_regfields_init(ocelot, vsc7514_regfields);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index 9d2d3e13cacf..123175618251 100644
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
+EXPORT_SYMBOL(vsc7514_regfields);
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

