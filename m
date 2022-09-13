Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73495B79D2
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbiIMSkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 14:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbiIMSkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 14:40:03 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2099.outbound.protection.outlook.com [40.107.20.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D12E857FB;
        Tue, 13 Sep 2022 11:10:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVKd43V4ok4SRIR/wfF4PQeL5S6cSUKQ98vFVgrdnMwefv4PDnUfCHuxbEKvw0a3NH8sgv9CpeUtDe2ATFJSmgPWlB9v8LZBybfyFk4WTFvzYXQetsz3JVao+JVPoKimkTUimko1jRud/2nk86PM7/yvuM8hkNzsfBk7DwZWdE0kOfTLsHV937PO6tWd645OskDHrP0icmDVh4Ore41eA69XJHWiawUt6uwqRjqJBx9iDA3rfKEcCRvxdoF8JCXXEuebRAOA9gyOqkPQm6w1YoMyl5E3AXSjCKMKq65Mrh0cGAmVJbBZgpwcpJY9pspfm+GPhryb9LthupF13SYpZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GiIDk5k0MIRr3eTv9K6sQYkCz+nUEjStOndas7OJfGQ=;
 b=e2/j3hP1+PAl/g1HFILCN8EebuESeWq4gVdBLtNGyW8UTtdE6DFoNXq3X4QPu7zFX0ZDlf5IJbe4tdfsB8IchIVN8wBsvhIhMEucjmB98QBnnQfeYDsQudLELcMROPcBjBw2vxdJ5P+MDnWHYhP6rBLzhVVFo/iQyusUEczgPizCvfi4XeD07aVCyLj1ZTeReqvdrJxHRNDuBwlN789NvL9qyLwhwuSpcSKMpV6AdmHQNuXs8EVmoT1XY3DtIT8OpDkcuF9gGmQqlR6Hw9Vmih7sA16pjlf22npn86ZxA2jqgB56KHbvhN8qU+FkkGAOVy3XPzrb+Hvk3VvoLiQFYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GiIDk5k0MIRr3eTv9K6sQYkCz+nUEjStOndas7OJfGQ=;
 b=VG6qj+VyrsXWCqWtzdCpkc+PfILY7rGSr64RV+HKLVY0RKCNgArzCi9R/aOdIe72/74J/FrMX0EjUPEd7Xs7f+j1gUa6mBXYGL0iGOx2ik9BYJNTkt/H/SMbZ6aRcu5RfvkJ29W4auXal6TJRjyrwsH7eZQt2dEFeg61LfkbnT4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 13 Sep
 2022 18:10:22 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::c761:b659:8b7a:80ea]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::c761:b659:8b7a:80ea%5]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 18:10:22 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, hkallweit1@gmail.com, andrew@lunn.ch,
        linux@armlinux.org.uk,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH 1/2] net: sfp: add quirk for FINISAR FTLX8574D3BCL and FTLX1471D3BCL SFP modules
Date:   Tue, 13 Sep 2022 21:10:08 +0300
Message-Id: <20220913181009.13693-2-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220913181009.13693-1-oleksandr.mazur@plvision.eu>
References: <20220913181009.13693-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0180.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::13) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1P190MB2019:EE_|PAXP190MB1789:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c0fb697-13d4-4062-3f3a-08da95b3399f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WPodMAX74bzBdyPWSikGgysJzGQQcfESeG3lL9MBIIvX4U8dtSeAIwHDf1Tdp/+mL0oSrsjBCNGY0Ke7LkXUImgNlfhgaEgfFkSUU3nQvlsqV0kKb08CiEGcHduw2fE54lKloHrwNokoA2KeHEMeYLrnSVgmPlK/SQ9ChR7NCbVLWWF0/tQHgFXxAEqI9cDO3S9OmgsXMyIYYnjLIpNIOukjL09wqLy4aeMZKjoqRNtrE4pCO/c1a+ajNF02PJOOUCtzzGq9cndxCfEaoIuQZIAU8iNd0bmR+qsM7tUZ2EtB2800RMn+o42p/2APmlU6zdZBVEkuRLeJPbmhurg4Dt22cf14AjsseIC4tf99tETmeaWG7XENg3M/Ky7UxNjSn/7Upr1tUlatVxShhC/UdJ74aI/8W/rXR45A3zYmurnYFzFEUotD7LhU4hZlYkh4jdmcZACqJB+B7W8ISNbvu2vNICD75ALqYkhLcsfrXoW4fopkdzbWnbR7acjlGXWcz/M3lZWIFwRvfaV004vlMwbDF3FHEe9LisY6L1x2g4/sFGEZ0qPcAZvUodHk3ZBVOPXvs0sOyFaKqKWA1QNGtCInWHnlixV8eWwFCEHqLcUOq11Ie3iY+gDtni2cXxahrFWfdohZLC+g48qJygRq8soqPYnI0MtIu8FCuPw1/COf15pJtOGNuqwElrVFHCuSPCQ5TW08eWudRbt3MSQuInUSEMQhPLzU6OyDOTXcf+7ZEURrD9ITkRc+tiPHgkI1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39840400004)(376002)(366004)(346002)(396003)(136003)(451199015)(52116002)(66946007)(8676002)(186003)(66476007)(5660300002)(478600001)(1076003)(66556008)(107886003)(44832011)(38100700002)(38350700002)(86362001)(8936002)(41300700001)(26005)(6666004)(6512007)(6486002)(6506007)(316002)(2906002)(2616005)(4326008)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XTE3mAsgQGE2gwedfEsG76y0OyyLtnUTfzymyJ8l/vSTYKd94N0yXeo/9Le4?=
 =?us-ascii?Q?ufJKkwHv4vc8oeKp83y5dOeAaDiJJ9wSkGLprojDWYAjZGTyG84FvyN/3bWE?=
 =?us-ascii?Q?D1FqLOa47m/0ApCaDwRw6gKH9+wDUm3W67IXy2Qew8XctmpcRtg0CSm0fazc?=
 =?us-ascii?Q?ZrqackRurWWkLL+EHtyLJF2qFVo065STF2zDLDnzd2CYetj/i6g3pJOeVMi+?=
 =?us-ascii?Q?oNuM0hDItFgwAZAAqRRfPvtmmzCjyZboUHnnUtLxRiAPIMWT9eRmcaR92hMO?=
 =?us-ascii?Q?WRfsk+wrzfVXV/REAx6JJy9eky9TUerhDR9XS4pHE5K3vkrz4ATQwrccBRkF?=
 =?us-ascii?Q?KpiOVJaBHApfM50PQtu+JceuM0KN7MIh1YkIETgFJtSKvOJc09yRkKownjuL?=
 =?us-ascii?Q?26EoZO7y1EqjCsAFVg3c9kIisUb3/QVjIcPB9/1pwwxnsJsM+1Mf+6jdgIWg?=
 =?us-ascii?Q?HNjjGfEc7BQm2qxUKdXsPwVH+fCVI623MJGy1P5S6XfBmpzQZKzRq+V1UXMd?=
 =?us-ascii?Q?GYe6xPzbrPNzoYIFXDYImEej1Reegiou5KIFOCkfYSoOFXiq+agRSf2IVG2H?=
 =?us-ascii?Q?+j5MG3kuIoHbEff93bLfQC7evrnYYlGPy4mFaMaqWoXot9hV6W1ZrIqGGEhA?=
 =?us-ascii?Q?5gguJkxiqC/Cj0tQoEpWYkqQvmDvaEV5b2rHePETswZxsUk7YfEaK5FC0mtw?=
 =?us-ascii?Q?pv2aH/nxitcl7vr9/VXUM9sySUzYtVnW9z+ElegB76Xb/AermVgj1vTcRvqt?=
 =?us-ascii?Q?cihlS8xCBCP1GwtLqWm5JknRAdVAxP83iHSi6WwQy5nmgAM96RGDspxO0ukG?=
 =?us-ascii?Q?4oOTIH8iZ3tLrie3XnrdN3Z3a3n337LMe4vxtAcVcEKvB5vYD/WOg2vxM8dM?=
 =?us-ascii?Q?Ldw7fDbCA4o6oZzcw2TcCjqcJMP7m0mYE07rB9TA2qilpw+a0E34oQP3xpO5?=
 =?us-ascii?Q?V/hsIUkFcdE9JMVHaxEuntCuJIT5CHQ96OCETzqTZb6NyVHoUngG1XIYZssQ?=
 =?us-ascii?Q?gfWns5hCh4MVQXslN7XFkFtlHyA5NfUJmeyo9WeBQG/04cFNWhh++fBBbPMY?=
 =?us-ascii?Q?b1k/osuyc212ffmUJnZ/5IihRt99LwGlqfd0wet+nO5o9rae/JersjOsidK6?=
 =?us-ascii?Q?dfydCic1IBof2eyHTXw7muLkDcoJFZNcAICKruQLigFUGLfIZBf6rThACMJo?=
 =?us-ascii?Q?1sKCC5dG81v8bS8ojR08/gYJ+LipRb13ssHayuGR+GiXEYRdSR24uGU95JhR?=
 =?us-ascii?Q?HT2OIw307RacnEPlgPYIDKFwR66trVR2cuCpEneOBUPOPTKXbL2JCoAx6aZG?=
 =?us-ascii?Q?x35NR8cyF9cjGJ2hkOfvt+xdTp0XLEEbFqCEjxqWL3xUTQYDPKXObsaSFN0P?=
 =?us-ascii?Q?dx5LrJVrhALNMUSTqZpSrPU5UW7eqYtwFlRDZHgXZgxxC04zunpnU8vlf9w4?=
 =?us-ascii?Q?/6gouPlbCJWLh2NssNxvR2Ju0IMVHZm87JAkTO8Hv4baT6oIyF7LxAw8NPaQ?=
 =?us-ascii?Q?+4noR5vhQwRSHtgRzXoftClNq2J7QB/i3ZiPkyAohXkIlC9I7DxBe/Z9/1dX?=
 =?us-ascii?Q?U82KSKOtW3gNi43eOsYXc8aZfQ61WMiJT4gacH2F6/mHYVwuTMKnL1uUzV6I?=
 =?us-ascii?Q?FQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c0fb697-13d4-4062-3f3a-08da95b3399f
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 18:10:22.6955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eqqMmCT1ggsoHnInAfaPtnQxp/RjzJDplEy8y3Dsm0pyNHrahh0/nMT0fQCsOFnuD+veMtH3fzqtaFblP0bHtiIiFLVnnni+16VX1Zg6+gs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP190MB1789
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FINISAR FTLX8574D3BCL and FTLX1471D3BCL modules report 10Gbase-SR mode
support, but can also operate at 1000base-X.

Add quirk to also support 1000base-X.

EEPROM content of FTLX8574D3BCL SFP module is (where XX is serial number):

00:  03 04 07 10 00 00 00 00  00 00 00 06 67 00 00 00  |............g...|
10:  08 03 00 1e 46 49 4e 49  53 41 52 20 43 4f 52 50  |....FINISAR CORP|
20:  2e 20 20 20 00 00 90 65  46 54 4c 58 38 35 37 34  |.   ...eFTLX8574|
30:  44 33 42 43 4c 20 20 20  41 20 20 20 03 52 00 4b  |D3BCL   A   .R.K|
40:  00 1a 00 00 41 30 XX XX  XX XX XX XX XX XX XX XX  |....A0XXXXXXXXXX|
50:  20 20 20 20 31 38 30 38  31 32 20 20 68 f0 05 e7  |    180812  h...|

EEPROM content of FTLX1471D3BCL SFP module is (where XX is serial number):

00:  03 04 07 20 00 00 00 00  00 00 00 06 67 00 0a 64  |... ........g..d|
10:  00 00 00 00 46 49 4e 49  53 41 52 20 43 4f 52 50  |....FINISAR CORP|
20:  2e 20 20 20 00 00 90 65  46 54 4c 58 31 34 37 31  |.   ...eFTLX1471|
30:  44 33 42 43 4c 20 20 20  41 20 20 20 05 1e 00 63  |D3BCL   A   ...c|
40:  00 1a 00 00 55 4b XX XX  XX XX XX XX XX XX XX XX  |....UKXXXXXXXXXX|
50:  20 20 20 20 31 31 30 34  30 32 20 20 68 f0 03 bb  |    110402  h...|

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 drivers/net/phy/sfp-bus.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 15aa5ac1ff49..c3df85501836 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -38,6 +38,12 @@ struct sfp_bus {
 	bool started;
 };
 
+static void sfp_quirk_1000basex(const struct sfp_eeprom_id *id,
+				unsigned long *modes)
+{
+	phylink_set(modes, 1000baseX_Full);
+}
+
 static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
 				unsigned long *modes)
 {
@@ -84,6 +90,16 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.vendor = "UBNT",
 		.part = "UF-INSTANT",
 		.modes = sfp_quirk_ubnt_uf_instant,
+	}, {
+		// Finisar FTLX1471D3BCL can operate at 1000base-X and 10000base-SR,
+		.vendor = "FINISAR CORP.",
+		.part = "FTLX1471D3BCL",
+		.modes = sfp_quirk_1000basex,
+	}, {
+		// Finisar FTLX8574D3BCL can operate at 1000base-X and 10000base-SR,
+		.vendor = "FINISAR CORP.",
+		.part = "FTLX8574D3BCL",
+		.modes = sfp_quirk_1000basex,
 	},
 };
 
-- 
2.17.1

