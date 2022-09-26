Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA045E9769
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbiIZAdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbiIZAch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:32:37 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2111.outbound.protection.outlook.com [40.107.96.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AC22F662;
        Sun, 25 Sep 2022 17:31:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdfZuqNZHYE4SV1nAGCgwBdFiFMXwSdVgItsCQI/nyHG1+hJoA9ddAfDFSToo0MB7iIzMxvEIDK4TXvy5qEEbghIF+xbqp0DZEFzQ+RLp/0RxTb5KLlaQB16uw89qyUSu9WiZRY+pLuWydcyDkwgKdTNLNF1J2E9od3plID/QmeFk7p7iqZbdawzgKGqEm613XwQeG5ZyAwiKtJtdbAA5z2qLWO/z8S2APadzpmt4eQz6BMa6qItgOF6AgGdwd/fPVyvqfOrjWWq+1pde8/12YetbEbKgNlqLCoVegKu2X/VUwbatbJf0rwBUm1jyb6MaEQOhc1p1hngHbll/FIRbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YC5g1ocJuDiF8rbRilSLDB2qkCF+FTUQ/rftX0G9Q+8=;
 b=NNk+i/dJ5/BzoxDaNUy/hFwXdj1cwP8+3AyOs181Yu/RaC0LpRmUCXAFrrgrNc+rfJL6IlWeHIOpPeXIMXk2rQ75bTfkyr/X4gMnm18EvCdzuHCgN8Nd5dJ0mIv5A3rZp71w18VTxLhy0y3dpdu9TizxortkyOBOrSXoKQ9bXVwSo1AyY8yfFn8bOKnK0qhJZFAS97EZ20pH1vCJAw/9ec/bRpGtIFz7iGkuHoryQLbZAHw2pgNjTG73tneC85iiobN7mCQMY/90S+vH5YOtfIUszM5MrEmmtTt1Sr65xADWOeuG9DBpiq30ZREjROOY2SYlfqjIhUGuXG2JifUjhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YC5g1ocJuDiF8rbRilSLDB2qkCF+FTUQ/rftX0G9Q+8=;
 b=BHauCrzkuNMeNqwDcOHHPBri97vRxhjWnCtILLWwSQVnR2+IzKhQaNcYCWvJ+g/YQsdjj0YvZS9KwhNknR7yRybVYqUFDzz69DLzYlHaWeVs8fs9RCU8tyubGfcodx/w+ZJ4llZwVVP4Sjn1kagEzE23O6epTussPkJlS2+xFVw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4849.namprd10.prod.outlook.com
 (2603:10b6:208:321::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 00:30:27 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 00:30:27 +0000
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
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 14/14] mfd: ocelot: add external ocelot switch control
Date:   Sun, 25 Sep 2022 17:29:28 -0700
Message-Id: <20220926002928.2744638-15-colin.foster@in-advantage.com>
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
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BLAPR10MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: 53c99098-da02-4712-2f21-08da9f564f51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lxb9bDwBkVK/NPqaf9R9zdXx13t1OZQnlUnMFA2tQWlGClGAwrNh2chx41guIVQIgsTJY5H+UVMMIf5XMHe7Cbn23d/VG8D+k+gBI/NPyIC4ojYxfsmRysQDy3oBLHvWLW244SYoItkvgAMJEMv0E6rJZpHAUErxJmKWrfStbeCCjev6LXSZhfgCPUTcawBHc0Il1DEZn8m6tGOxQK6LJjio6LYx5bbqzQIN6I/JtllU+kOso2Uuq5ddM6Hf76cZyzaiLRNTupysqX2mj1IOPu/F47ogncvAMbyyTzD4wwx9jyQrLSegiRe69BaWys9u/hZs5LpVBzpqgEY9hQvxvJxPq44Ps0k4iEL3ehs9MQmh6EwCB4UIEqHV1OEDjbdgLRDZrNmMzMOx3g7jRK6B3xYlQkxFIuGEEYyZ4nHFnO/kmbTxFZdL06sAZnrJ4Aq/C8cIVMnQY8rvpfmCUiJsVeA0LvQmhGkhHBMqRjZKBI4eSgqw9GjA1gALv79X8+gNPjETrkxUbQWGXIOmP2GiIfGIkPurnVIq4UKWnsFgkXtaLGSGod2ujSX56bVi7zHPZrq0aN+6K7b9i5++dROCvWfRhgvRvzQ5fc/+vCD5R4mbaLNMlDqQTppNlJaRTTc/08EUBjonFmAFgFBDI59iPeSQ52mRkzy2eTLqTOtQyOs6p/ki/gVeqjKtWjBUqxKAxHquf6HXxE6V9ULFFtnDiAUIp936ZvEfJAkaFjdAHZdPR+Eg420zyaGocm2NhiWY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(39830400003)(366004)(136003)(451199015)(54906003)(38100700002)(478600001)(6486002)(316002)(2906002)(2616005)(6506007)(6512007)(26005)(5660300002)(1076003)(8936002)(7416002)(186003)(52116002)(86362001)(8676002)(38350700002)(36756003)(44832011)(4744005)(41300700001)(66946007)(66556008)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QZ9zBR/trxrMaFZaITUr//Weh9jYqd+RPUDts3AUj8gZIrxd+PNrwxOFU7Hl?=
 =?us-ascii?Q?DuZ26tWOg9AEYoV+97h8ixBfoP7YFgqa3JcPxUFDN0MOcshRrFJDqmeFK93/?=
 =?us-ascii?Q?GrsqWTiGS6a8O30BgNhbX3wyXqjseTua0448x3Yk/kZBFSjSvsuX47NDZoRI?=
 =?us-ascii?Q?DJcGnCRg7Wsu2A9FPeKgC+aurY8EMs5p4cJyKhFhl+BqXtKNKEEI/jLn8qJb?=
 =?us-ascii?Q?s2vLBtekiQFzya+jyTYvNnqxSs+PcvKm5qvRaxrzjqZgBrtz5YUHBeA/yyyY?=
 =?us-ascii?Q?0S0mNhNnLMnepuZWx/GZGGrGi5MievbYHKWnwfJKmSGJa2oZw/2wEY4a3bWH?=
 =?us-ascii?Q?hbGxyfcl3CRgbeROsMQmxfLOX19rhrHZMl0YGltNgj5ZKsuWBVGO93ESlmNv?=
 =?us-ascii?Q?KaqdEwrOaLa5pU7F2vneA+eEjQrYtzNl10AKeXVcA9z6qrVL6ESRWU2jf0O4?=
 =?us-ascii?Q?BWo0AlYkEdqITClHyvdOnoxYHgWDXFja++wG1BBrdCyazPdCa+LFsiaqhv1Q?=
 =?us-ascii?Q?zRTv5gsHQrecseAufhvHSoAqQZ9N9GVIUXc5L6XMiTahraCJS37J16V6kKgx?=
 =?us-ascii?Q?ehSt2cp435cFzA6YjQbrRw3agRYvfMLMraGRoVEkhk5VUkWYNZ4YuNnsPLlD?=
 =?us-ascii?Q?2mzrS4BswGdtBnIoYGGFHYa8UbU3SmSXi7i38OwDAkZwv4cLcrjEMaocVg6U?=
 =?us-ascii?Q?A7ZDk2bW5P0T16MtUP3PsXPPx35/564U65Euqf7J+Gt2w52guyKdD0ANC2Xj?=
 =?us-ascii?Q?XYRK+VIn4+Xmz0pWyEGe/6cDAiL7e+s43TabVMNSXBIoLIPESvFPawhK8Ilb?=
 =?us-ascii?Q?gPrRZ+7Yn/UQmt6S0DkVlbgzgaAgiETL+tqzjwgR5cvsbMZmi75YyH9Yudn5?=
 =?us-ascii?Q?gjp+fQJX+aSFPE4LKGABKVl40aSHWtxET0gHW+i0RMpIX3aDXsqLvx01ERxo?=
 =?us-ascii?Q?tDhRCVOdtAS6xlV5MMFraJs5rsDByTGrdjbpSSNDuwAbV0MYyT8zT6VIkzRB?=
 =?us-ascii?Q?DJUV7HEGGavMy709sIllZkE6AkkLQpjJ28WrAQVf8xslbBcLW0rmjO17yCct?=
 =?us-ascii?Q?plzIonQRvnmSH/SRIhNLxwup4270OUuY8+6u7hoX4Euu01ua2hUpJKMcZ/pg?=
 =?us-ascii?Q?DEXiaqVpB9HGA5tLVt6ZdKvpaWhkjYdEwhEcmG6KR1+5yrt95X0T3VjfZsav?=
 =?us-ascii?Q?NkOsr87mLiIw43CibigFkcA2IpV6vFypED/fQguW+6kUtyDVTp9HuUI12Wx2?=
 =?us-ascii?Q?o4am11K9aBhJ00+yXneEKrLD2ia+GqVWzDkYEeOUjzPKXsEGdBConJqTL7Da?=
 =?us-ascii?Q?S8BbyUZwrWZ8h/bcx2nYYVJA9zsyLUlmItkFMQKXWoMv0Y7EOznTxgRxL3Gv?=
 =?us-ascii?Q?/JYQ92LPG8SG6AbBJ8ChYWfuZ2a0/hc5CUthoyr4D8agQsIgg2Ey/uCZh8io?=
 =?us-ascii?Q?qcDHyVtLJm3C/c0g38NA/DQB4ioj5JNh+OiIppnnXycO6tNoMIoiHlWzNN+L?=
 =?us-ascii?Q?kXOrnkNF9sWzf3XDMicB+wHHVnUEdFxKMd55neBSMf2CT0xfSrGvC1jEgj1A?=
 =?us-ascii?Q?rV0W/meJFehbOFs53BQ9pUZ3mVK87O9HDZ8OzAbLTm7QEsn4pHomPdEgucCb?=
 =?us-ascii?Q?evUFpJPRMargdpucvG79/hk=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c99098-da02-4712-2f21-08da9f564f51
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 00:30:27.7289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LMpRkY0aWxt8ZGrpJwbHRg4MqgFMNvsNkneuk3HS0M/J7m0L1ZEplGq/BDQo4/UzSngGJ+AQLMQHfhSjXuiiJ59b3Ns3a0Vkog0Xdm5u9Io=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize the existing ocelot MFD interface to add switch functionality to
the Microsemi VSC7512 chip.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v3
    * No change

v2
    * New patch, broken out from a previous one

---
 drivers/mfd/ocelot-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index 702555fbdcc5..8b4d813d3139 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -190,6 +190,9 @@ static const struct mfd_cell vsc7512_devs[] = {
 		.use_of_reg = true,
 		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
 		.resources = vsc7512_miim1_resources,
+	}, {
+		.name = "ocelot-switch",
+		.of_compatible = "mscc,vsc7512-switch",
 	},
 };
 
-- 
2.25.1

