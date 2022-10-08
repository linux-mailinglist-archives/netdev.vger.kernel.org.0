Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541055F86D6
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiJHSw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiJHSwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:52:15 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2102.outbound.protection.outlook.com [40.107.94.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326053F330;
        Sat,  8 Oct 2022 11:52:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UK8YSbhbUK1McfBEBYPqigpeW2PF7o5ED7+LOqb6r8VVLvjKWbCC/UQXrM6kfKrXQ5RmfQnFiOQoHXQepS1It7U761xlBKP/n4JTafTapggmOAPvL2l/ezueY2bh+k6A8r74LfcKb8aTF0SgI6MnYX+XpoYdCaHJgsf9ycvwa8jN9JD0MTJYGScJTf2SfLJFdiPkkeTBrWt3zkbibtVxIsREbuFmFZvitmJlFHPwLQkgiXhtv/b0CvVauXImOead5rEIDKaPoLq2N8uwZMwtqQRQhhhfBchlshQKwOiTo6sUkgya1ibr4S9rxF4clCXWs8STcVXKYwyXJhnthv0jvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sx6uo+k8oxp1Me10hVVjNIFbJRnKU3QiS1p0xRQWsDw=;
 b=NNFYT47o8EvSHWPzWnQN2PH8t1IKgstLCOpXQR/EkV18f4jvFs7eSszeMyG/8W3kpoWvZTueIE8wL0vYQ+sZJyVItmeA6GKocMk0KgoXzBFF+h30aVbZlRDZQ7FnR+hZgQ9pt+KTkGpj9ghjJ0t7Dg0j6WqrvEKT2ZxuuFy1RX2E2Fg0x5XfPVt3TuAxcf3lJfqeNwoI37tsoPgLoziYGd+CW1M2efIWCJc5omSGVlO1OXj24jA3FP4xaXP6KWC8JRx2QJT6v4X8/7AHQ3zko2FYspxqu0EiPGcuFuvX7E20z51uJY1Y9QiHiWJAiNrOYypQTo2n6D4X3dQ+DAupew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sx6uo+k8oxp1Me10hVVjNIFbJRnKU3QiS1p0xRQWsDw=;
 b=ehpfOfuTSYQc6aygODKLCeQ19Zinz7Y0BeLnJRtGM2lBeqD+7u+4H9TBYzHoqzPYnkHBw1/PkSfdiPQgSU+YArYZO2q/fYTkVVplsoTAxyTH9voy8xvovCaODJVfFHCTzEGzjxfUj/UBwwAfkWMIl8XLvrYu+u8/dSJwj6Tlod0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Sat, 8 Oct
 2022 18:52:09 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 18:52:09 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [RFC v4 net-next 09/17] net: dsa: felix: add support for MFD configurations
Date:   Sat,  8 Oct 2022 11:51:44 -0700
Message-Id: <20221008185152.2411007-10-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221008185152.2411007-1-colin.foster@in-advantage.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 62010382-8f5c-47c8-a519-08daa95e3382
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9K7PSjnfptsj0i3HAvY0okp+kopvpV0ILIth7JouzLBPM1YT3WaQEKVjcVNJNN1blNywc/KB3rBEvEH+dqFDpX4KkFb8JazIisvSopKCpgKESxlIKTzZ21T7ATfjbbi90l6RolkDjM9CeAPFeJgMN3nad+vlGrz+T6v0UxOicCV4Ri/5bbwILej28iadZi9HJ8BpNbhLbUEibQ0EXD2+45jHLkUHG+PHnOn6h4bm9XPDAiZW5CIWwhWNYB4GE1L1m+9AiGPDsMe6ajRSv2cnyie6KPcJIsNjDEs4QTWmeV/EfC/Hzq4rRhACnEHWLJIt+cfUp5LVzPdQz5lLe3Dlzyiw2YyZJAHDsfcPmYmSiqo7scuK6BLgS8qaATQf+PdUeJ4AEQ+1M8cwycDrYuo1fi+w6kRPX+r6Un/IWyaNg5v9CHlWQkiK2GAV6+q335XhFbpgZ3ZEJqLlgswTn2Of6fut8+ylcmwKHF9puoHGhEk5B3n/gG7+TJLRlHZ9L2uY4jXivrR6hIQEdgKwaYcHfg9EKHhxtOOfJDE8tV6cEiRUHb6KAQUEguz/CSLIsWuBV0VSd8KmHrfdZzzX+LcttfeIZbvF8XDKk83FmgotcBe6IYGY0D/SFEwk9Nh6DZyBP5v07Gaun6H1kjPbVQU+atKxXVouUZWrqnL8iAgZvi3u6ivizwPRIZwPtjNm9tZuShcPUswgN/nnG1HdtsloSUGgaYsLWw+yvIfVvrVXSHiQ1NOXWw3dVk5YoBTXsHV7ycidZI5xA3gUVhvgFEBdOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199015)(44832011)(186003)(6512007)(6666004)(26005)(6486002)(6506007)(2616005)(316002)(54906003)(38100700002)(38350700002)(52116002)(4326008)(86362001)(83380400001)(1076003)(478600001)(36756003)(7416002)(2906002)(41300700001)(8676002)(66476007)(8936002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2P8rKP6SR5hNNcgNjkcjpEUmWAkGtYv0a31rCe5QE9JQxYQLxkYBY7TazRkf?=
 =?us-ascii?Q?qT1YSYb6KEjpy5Oq3KhgbF66CE4Y9qoKlJ8c+CIMs72kzh93ZJcH+qXdPFRp?=
 =?us-ascii?Q?kGWl3mt2FC5GL5tp5PtJygndRJmHttrIVg/OKcO+i2XVU8J+JkG389J1XNWz?=
 =?us-ascii?Q?CcxFVIG448MenBVI1G9aLAfqTl8qvtxHlbnxv35vgv+BtIDCWbxUgpAsEC+r?=
 =?us-ascii?Q?vNZ3ojW3NrsdRt80uaEeKofc6ZhOOLPUz1XCyVsgxYhUIk1H9uWUgjyNGEK4?=
 =?us-ascii?Q?3heINEXdQxUF13DjNadrHLYrDdSZ7WG9OLAc/N1YAs6+Nfch9mhC5IrA8ZQK?=
 =?us-ascii?Q?utuTKRWhQhXc7PujTjS61Z5OiR3ktGr8h4tg/FkNE4bfjn39vFWBB6uCZD1A?=
 =?us-ascii?Q?Wm738hwr9gKuNj7CecxmV/sryhvpecsYr4FCTKCRL6j+ogFuwwY0bwsRIqd2?=
 =?us-ascii?Q?Ec2HwPiL1BcNF66fYKNbPw05VWvKWrxPzzkZunCMG290Lg3e3I7EPMFii77s?=
 =?us-ascii?Q?Pw4fjx1+sJ7iykl19uu7puMsVq6QIKf32i3r7q/b+5n8krZDML8yl4WvrnRJ?=
 =?us-ascii?Q?7HkLQmd417IfjS+kgLFAH/+w0a9zSDqQkxpJNm+ytCJ88F0ihKB9rzXA3aeZ?=
 =?us-ascii?Q?WbsScpAejSbc0NNuCJ649os3TpCfYf3TMoLh+M6OboIra/NlHOhlKm8XuObK?=
 =?us-ascii?Q?FsQuuKbWPRmnSGfAk/ihN8bq+34U10R1EOex8124m8uYNX/eHry7OwOtJF8e?=
 =?us-ascii?Q?oF6uhcZ/elhlY1rRawnAvZoOGsCDdbgrXttT9vvnPdk/wMx43quNVkU+MKND?=
 =?us-ascii?Q?vhx17jVVwskQ2PUmsROpNABtEtTAtWEqJ4B6a84N8yUZRvqh6VCUDtA1dtc4?=
 =?us-ascii?Q?9csvQXBKfezJtbtwst/T3Bc2/Pc+CS1bLLP/SKPNYpudi97/p14ryOMBl/66?=
 =?us-ascii?Q?a/5ZSvgDNLEojKqjbykum96B9grL7RsqmKth5xiAX+d/bN9CvgINkViJLpx3?=
 =?us-ascii?Q?XwlsJ6pYeUCT7OHzoYgp6jdYKfw+HVC5UVb5bBnmFgb3UVW+OWfCja3f1gjd?=
 =?us-ascii?Q?f39w9yxdQn0EEY7RqQSDtjjDJflpHuA3cX0mliL+fwchrMsH0pBGcd5FE47T?=
 =?us-ascii?Q?V2akVppv0JHuH5B7zlRA5oPWfxtsFqQdtdT2Xjwl97eO76bZhJeJ6wjkuIqF?=
 =?us-ascii?Q?EmAJQvaBM5Ds15DKxJl4PhGe8NlLsKmF2JubXYm5vca3T6zlG0/oLJzwQqkp?=
 =?us-ascii?Q?YGVbDRlyZkcCP1nagZ3LsD4IzujTKJ/yPPYW4eGDj8CEINjyD17jMFJy3J1N?=
 =?us-ascii?Q?WnSBR/dmuNmahzN7cBXlOTCfwzDTqC1CoHig6cnBSahWkxw6BF3gCONCJ+ux?=
 =?us-ascii?Q?TCaB6sXlOElbANc5N23k4R5yFkbaxzDn14ygVZ8t73YmILvtOiOnLo/GT+KL?=
 =?us-ascii?Q?7qvgsVddJm2xbue8y92UPzTzPm2rdbgwYOJ9vGIJiinJhOOwyHPW6jEvDlTJ?=
 =?us-ascii?Q?iMWKljwNPhG1xPTN0T464nmhi0/PH+sibv2X8UqNZQmytaYfoTDo0dmxuNSJ?=
 =?us-ascii?Q?5AWiaLK2BkKN8RcwdLVix0C4qJt5IsX3c9RJyPv6Y7CTyYggBAM3F+9OnzxK?=
 =?us-ascii?Q?yl9EOFmrc6AD2Uy9kbpZSYo=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62010382-8f5c-47c8-a519-08daa95e3382
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:08.4285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u3tgrZabUOJbyeKdtCE1He3MB7miL1ZnSGFOYU+2mPbWvQkfffCBFkt9SFH5nyS1pEPbMYbxctZQ4cgQzYEcnsHgFLsAUwvdwtcsRQbT4iQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The architecture around the VSC7512 differs from existing felix drivers. In
order to add support for all the chip's features (pinctrl, MDIO, gpio) the
device had to be laid out as a multi-function device (MFD).

One difference between an MFD and a standard platform device is that the
regmaps are allocated to the parent device before the child devices are
probed. As such, there is no need for felix to initialize new regmaps in
these configurations, they can simply be requested from the parent device.

Add support for MFD configurations by performing this request from the
parent device.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v4
    * New patch

---
 drivers/net/dsa/ocelot/felix.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 1d938675bd3a..fb0a0f7e42ac 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1325,6 +1325,13 @@ static struct regmap *felix_request_regmap_by_name(struct felix *felix,
 	struct resource res;
 	int i;
 
+	/* In an MFD configuration, regmaps are registered directly to the
+	 * parent device before the child devices are probed, so there is no
+	 * need to initialize a new one.
+	 */
+	if (!felix->info->resources)
+		return dev_get_regmap(ocelot->dev->parent, resource_name);
+
 	for (i = 0; i < felix->info->num_resources; i++) {
 		if (strcmp(resource_name, felix->info->resources[i].name))
 			continue;
-- 
2.25.1

