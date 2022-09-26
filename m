Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1B65E9738
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbiIZAaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbiIZAaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:30:22 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2093.outbound.protection.outlook.com [40.107.237.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF83DDFB;
        Sun, 25 Sep 2022 17:30:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKsUTkpjOjCO90pI97oWXuu+qn1TIJE34BCr9kJUDfMaF21cqJcjv7ZyTq7mbrRM4GEmlj/4pBZCso2oFNeNWejiEhlBoQK6d0yQDr21/TDC5o0knHgdCfrk0EqluIaOnP7SZTDfiFFfWq/upQ6+IjdPRcch4ssFQ5nM1nJ8Q6ZBTmCDQOqGkVjGKMvjvR6fWzc8cpX8ysFk4s/zyerfOxVGLH1jmPz1ZKPZrMbbCzxcWjluPu7KSvC8yjoRfLi6eoR5T4X+rtAZzq7kYQAH0pb658tlbBmFFKi6YryT7TV/2HMQnGH88QxdGyj1bNKH+50TG41EHJfh6vPfsogXbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqmBGl/Tg5V+/O9icejKCv5hf5v4n9ArjoewSzu+wQI=;
 b=ewrmnWj4O3ef053aDRseDD6IpvsBzyB3L72IZMMsOMmTf5SSK3Fygdka+5Idc/DTuvqemlLh2+JbizgKweRTx8ZFMSt6G2RPFjSOkae84aBfrDp7jwdlL/O2/UjxIuoFoLKAq4U7mFi4NdQ6qFLpKa1Ut2471kaCttVLMvqnkXZFDDuQhD2wsoKzUjiGfo2BoxU9i4GJXCbCXDKE8UFq5SL/sHtW4AStyOFligeX99KOpEZRBb6bV3VR8FCseC/Lb/KQJFiJMdBVRonl6zFwpSkbOhI4Yv2rXfkyqVFvLN5ZPKcEGLmdkjBm7+927Rdyukfb1UKmsc3WAGZZvcB3OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqmBGl/Tg5V+/O9icejKCv5hf5v4n9ArjoewSzu+wQI=;
 b=HpYYdnm8uksE9ii+fMTkxvKSsEHLeEImGAVCv0XSJyB0M0OYrYT2Bds4PqnJIDo7b7SpAMnun2/07yjE72c4yXutWqy2dHqy8v7s24QCCvEEGJBuwDtW31U6I/TgALKLnWb0//tcLT2iM3MMRpGFlLqCDPNknf7OE25vz3I62gE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM4PR10MB6062.namprd10.prod.outlook.com
 (2603:10b6:8:b7::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 00:30:17 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 00:30:17 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 02/14] net: mscc: ocelot: expose regfield definition to be used by other drivers
Date:   Sun, 25 Sep 2022 17:29:16 -0700
Message-Id: <20220926002928.2744638-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220926002928.2744638-1-colin.foster@in-advantage.com>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0260.namprd04.prod.outlook.com
 (2603:10b6:303:88::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DM4PR10MB6062:EE_
X-MS-Office365-Filtering-Correlation-Id: 03131806-734b-4a05-b914-08da9f56494a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hm+5rlTTPhRlTipTBtcNvIN+QSlETM4OhXBggJm91hCIRQMLKl7ICHoNijXnH5RP2GLBuOrrygkFlmaqeNBwO887X/JJIeUnFlYtOlE0Al02TBoqrpL7rIz61xN9Kufhnyt4KNN7tLBHBE5iCwQrdOfx0nNWDK40Rx18Gy6QWYATnL3H8uYDt98h1/cxFcWLkRpetxYvMCsGbFUDbX/aPIV1hMPHV1GYGapgOeZ4VMA+lwvkkQLUC27YApiqiyo5NxvVH+AGpTqYtPKNAbIQWc4T4KvGkP7vXZWXTc38NpH2bsAx62Mfs3RNMWKrvf07b9L7biX8Y7WHm5JCDVkqLCVkJtjf3mriNFC5rnO6uZPn+kMYn4zhiovFfVaWQiUe4ZC74QubUmRSoK19TJX1Q7JVXQPAIii7QT3q7BMJCptgy7l4owlwy/HyTWjlD4Rav0ldr6VjqkqZxwUkidsd5L02q77mwMwfJhlkg5Ri4zrk+9lVGEhQ7UrCLFzcUJYHMvd6j8vddrWt2ihXkvoGFYu7zwMuL5U1nJRDUXj1W9k+KGvarzF513XFyCLPB5BPtvfyilHgYMm8kQFQ+PPhcHTdgBK6AFbY4m4wbl4mPmg8Dnwbxj2tx73MXqBEn/6s5nh1IPq05wRqXdMQQ61zMqC7sPlrVa2dsB1NNem4LSZnD2hCsafteaFCa+jszwSH6wzVDDupderlEpJQg7GLUvHOfG3DBWdghjgoVOGua9x8tMOp0koW8KZX8EuQfrFD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(396003)(39830400003)(136003)(451199015)(66556008)(66476007)(478600001)(8676002)(4326008)(66946007)(316002)(6486002)(54906003)(38100700002)(38350700002)(2616005)(1076003)(186003)(86362001)(26005)(6506007)(6512007)(52116002)(83380400001)(36756003)(8936002)(30864003)(44832011)(7416002)(2906002)(5660300002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2ELHsbzoAK5+nLaFRAZ7SWYKCYshn7xlQtc5zT1Hzo8LV5P5JTUQfOYhBstZ?=
 =?us-ascii?Q?bQIl0mrZT0fIuh7nHLrTeIhbz/Xu8RvLrwERHir+jD2HE+fZ1MiZdWZirq8Q?=
 =?us-ascii?Q?wTIxXcBVqNc4fVRLrWP0rRF9WhSQpcmIB1BKTsNerMEbUQ5Bf2qbtUBCKriy?=
 =?us-ascii?Q?tFGydpeifyLheo9xyO5MrNk6nZMEyQUfn/UTuN1dAYET4yl3Q/qg5KBofKHn?=
 =?us-ascii?Q?nMKvv7zdTc7WM7gzW/CrlbI2UTbDIUrypNfzP+4vpdLO079wTxsL87NE9cX7?=
 =?us-ascii?Q?QAx9I510m2x3bF9Ex0Evqz7H/jY6Z6ZOs0mHB0Q0YAwBQZljbWYCEm+hdLtG?=
 =?us-ascii?Q?ay6SordQZvfaGvUEY0Pj/mOwjSCyeWwAGioXYTjrUo59bZrPRfjX1xAZNE5h?=
 =?us-ascii?Q?YxdSY+BhMNfkrRDtBD6QDQqLaIxTEj4kuo1zGkmp2o4J32eUNlDO2/YldG0j?=
 =?us-ascii?Q?KtSnE37BiN6Pzrk/tb+/baGNrgtDngLMYJdxSbSAzLp2rUNwpQTWUy//Enhi?=
 =?us-ascii?Q?gw0rt4s4otQG9kRN8Iv7c4AeAMQjr9JsYVhUea3HiIm9R5R4nF/JSlhDftkM?=
 =?us-ascii?Q?8Eyzc7Jr92aSP8y59jzwQJpqTMgwgzyNZmgoJAQ1aXLQjnmufPAbaVFmlMc0?=
 =?us-ascii?Q?3nq7ejNIjlQFRux7hNP7z2DWg1j/1R6q6sC+B5Gl8FakdhGObMWowkfw3UYB?=
 =?us-ascii?Q?cz5PJVEQsk8O33sb+vPZe1W9LU5EqhV/4Bmx0SatdmJqtgglQwqbfM/bIIEn?=
 =?us-ascii?Q?5lc1NhyPJ1PLKoqwelK8+r6n/DSIegVQ9wzvycMXYQC+nF70MOcoj21sX9I2?=
 =?us-ascii?Q?Pg6MqaHCqSeIluxFXHerFAgtmW4LT0CjazCdekZEEoM8qsHvYBZi4IsXgmMh?=
 =?us-ascii?Q?XAwD7P9hqoJ8zaxQlmrs5kT2YjydPS+Hwbkv0vG8VqEAzmgqLercp0kYwjXk?=
 =?us-ascii?Q?RAunx94RDwVkvYaysy3IW8C2+XiNBS1WwuCBfOp2yPPiKfuiv7PumctO7kHb?=
 =?us-ascii?Q?f69Gq3YCpG+ABW+5vfJoNhieJGndyqSxm2sRQGQxXd+suxKjt+Fyig3uxYdI?=
 =?us-ascii?Q?f+EiKOwhC1fNnnScqAzYfoxLIxWKQLDyek81kR07NTaCKuBmwkAxZ42PiB1N?=
 =?us-ascii?Q?pNUnh3JxebOuCbi4iPoFmV0daTHmMToXYxBOTrKZ1zFMEdjSPs1goNAJZwaf?=
 =?us-ascii?Q?2kQ/fRu8Qey62aWeYq/P6d8lrgmTT7oMf6xr0amL8Mj5hVVrH+Z6bcty507o?=
 =?us-ascii?Q?tt7elM0VhCDtSbDbAO5/va9ZtCPUBIPVTGyIvQzJN45+iNicfTuvGJUkwx0c?=
 =?us-ascii?Q?lhFLB6RAnXbF+p+fuwjtKSq9EzPEOAafyteSUQYCJsJkh901apEhOAAZX8xL?=
 =?us-ascii?Q?I8g0nsxbVSYVa8TCjiIz4gtgz+0hkj/VRgtNJ1Rv16of3GjkVF8IzV0azJ05?=
 =?us-ascii?Q?jNk+7flAzsDA7rq4yLZ4VABf7GX3pIKNcenyZ/r2UN+qbk9ogWad06Xk0fpL?=
 =?us-ascii?Q?c6W3XKGeMI/kNThGx1kIHhpsl3ptHjrMVnE4XoshiQJrehP8wk74XQp6q1ZU?=
 =?us-ascii?Q?3YkGhE3ghMhGhjVFVm9ycnyO+XwTdNjryldgMnqEUYi6tNiZMxMWUPhvqEvz?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03131806-734b-4a05-b914-08da9f56494a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 00:30:17.7140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hhQnOLthD7qnqV7osvJR1DwFidpqKev21pABYWP/e9dJtKXduzNToUZ0hVBoR4s7aRbK0oUQ+XsDgdPZ4eQHy8jwApLBNUoVTFX26ImPa9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6062
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
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
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v3
    * No changes

v2
    * Add Reviewed tag

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
index bac0ee9126f8..6d695375b14b 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -42,64 +42,6 @@ static const u32 *ocelot_regmap[TARGET_MAX] = {
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
@@ -142,7 +84,7 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
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

