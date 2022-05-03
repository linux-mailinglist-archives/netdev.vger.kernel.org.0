Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1E751839C
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 13:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbiECMB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbiECMBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:01:25 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2058.outbound.protection.outlook.com [40.107.20.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD8626AF2
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 04:57:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmauY4C0k2NS4PNFtBrLsaNTx4303a2MOobjBc2xdEJMLx9EEOomkWOA4ojs0bkRxGBCm32xb7vee0lyHq30zXIBlmjoiPJvFnYAH34eHK3x9fjowwX+yXDhwI18/9SH0zyUFk4UwPcGQKTmpYM8D03ZdWD0DRpQzvjtw4nVBJYwkmyE56F8bk7H8cevf/k0CmVlqApf/Bz/XHLNLYJXDcwiBaXkBmqMZJ9DqjsfKmaK2FcqSNt3y0JTtRaysmh/lxjKwQOXzxJVaON1a8R03DR4xE4fI3LKdFlPKmwk6PJTQaS4ZszqnwathQr+5HKI2w93JfWGq8kEugJrmt/KjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hcYs0QEmIQjtW31Ip8FmdLDJEG/PKxXN17IYk4CUaK0=;
 b=VrhJoiAI8SZDp4dLbvQOr2kYgbG3AFYMiIOy+PKkY5/CKne0ndLzyaBofLF/4o5ZOVdrE+3GDDVvzJTrmY1ijq5P0nwWcQLdVLEKEwcaVF+kZrXX46TImxJBnDuULrkpg6dBzCG7kOinwIlDasleh1O7d4syXi6RG8miGTwVugPduihqQkmXSOhijs2Ud3m7NYngi83o5ozZLGcrlCIAjb9RexJUsSYFYkVSkVZJdkuy/9Er0xbKFAsCPl++Kelz9agng+e5EONsPogfPpBi3+bv+0ebCLrThPv+bl2oJonCzA1pmYQDW6+hdve7IkDMAnvVTbZuGvcU8hM/VDIvIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcYs0QEmIQjtW31Ip8FmdLDJEG/PKxXN17IYk4CUaK0=;
 b=nv5cGQDBikwysRNioQo3EeXZHSB2/+wEwSjMhiL8BY1psC74FOavYVqoLtMrsBSnKx5GwtmFXgMpMJmEMO2nBkCqzE6j/qVBu+aLkkPxGerN+CLqsFacmdMzgt1Xn3w1nrGGFvbOWMrJmaBoDPWXc6wCp68yMm+E+uvJBEirskg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 11:57:49 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 11:57:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net 0/6] Ocelot VCAP fixes
Date:   Tue,  3 May 2022 14:57:22 +0300
Message-Id: <20220503115728.834457-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::22) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06a3c2d3-28cf-4653-9d7a-08da2cfc24a4
X-MS-TrafficTypeDiagnostic: VI1PR04MB4813:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB481371166A4F39CDAFD97C6FE0C09@VI1PR04MB4813.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dsXZf7d5XY4OO5Zy9b8GnlAzmnUJWGchT44y8McQ/8eaujdf/sZ6hVU0uoWgUDWWK40x2pGoxnwkQfT80TcM3xbfU0iue6b74ozeRipGQPgSvyoNm9ymVtu6T9x337YgNs35egPPO9eZdxxkRdDnsSJbKLAFHOJZ8c4+XLVXJfb9lQ74QqFfdc3b9fvVqZ2oVJ5M8miiNAo7PalBmGWKL4U9J2CZy7Oz7EhcuPuUnUMYmSbaeitjs2iGpcxAoaCR3oTM5o2zvLQUNLUfStC1NHy+oH90UIo5QkczWnmKkgch/b3/7qRFzUz64YQjtvXN/edc5hWsU701dJV5jsjfpSsjRONj7Oj1yLXJGpYNuBoBpL0kLLzr3D4yT58ECuAhfO1+HzqWiEeLl3/mV2TsFcj+QvnobBi1FlibuFub9Nk2BHzYi6Ia3+hoiXYo8FUmbHf0ckzld4hGTm5J83p+LRtBSf/3zX+FxbgzyQPYOyg9Sb+PqdMTPwPcjaWfffq9GORe1+OSpgrtqN5vJayP0B1z1CLlNQY1+Kjr4Btyz9qeJ6eIgI82xo36UyrVo2WGEMeWlgn8Z3xn2DY3173XnEoULDPzgoxKSDTEVnfcXHGqPevIQhBskKJrnRWtnmTvRXYl1Q9iawWew4lJSStwGZ6viwMZvE1okulMSn0hEkzEziW8xZqvzWzjB4zlHDKHS0XQyp+pEuPYmQn8sW3yjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(44832011)(8936002)(2906002)(8676002)(66476007)(4326008)(1076003)(2616005)(186003)(508600001)(5660300002)(66556008)(7416002)(6506007)(6512007)(6666004)(36756003)(86362001)(52116002)(83380400001)(26005)(38350700002)(38100700002)(6916009)(54906003)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wf9hyIiqP9A7dFcFtbbwrBhgiuX8FN+4jq1dzLYM4BgbeiVhd2Yf/mT1QrUL?=
 =?us-ascii?Q?DDYm85UfglSM1HbT3LnjNozpgyCa5lQ9rXvOhuVxfTj7itbCHqMopy4qAN3C?=
 =?us-ascii?Q?K4GjEWwgI8YRqeupPModrp22mqi8V84mH28WC7aMPIEeo2fJzykm/J3y9C73?=
 =?us-ascii?Q?3sNwe7OILW24+t2RR4frmfacpx867j8Cp/bSJe2wx/Pzy/juGin3m1lRmuPn?=
 =?us-ascii?Q?skleT7JnehB2fTAqZSP0GxuPSXSZW19pheVrDW57mOgdSTqOf79uBvaUAhgB?=
 =?us-ascii?Q?jNa0AZXkliiokwPcX2bPDjx5skavOAvwG4U63WPHZ1C6HyHXluxyfFeDpq2j?=
 =?us-ascii?Q?G5xwS3YpCUd6HWwRu4LuA58CQuCWj4et8SOMA2Zop0d8gVig5gZTrZfQPwq8?=
 =?us-ascii?Q?/c8tABIgwOctu4zPTZ6IG7FCri4T8mAJVULtZLWGhIk089EPBJSDfKcUoCoR?=
 =?us-ascii?Q?O5meWjruC9sp3s1vitN6DvCIienFPVZYg1397+AvHcA85YM8+NrnmSxO3vTB?=
 =?us-ascii?Q?b4d2/bvOrxVSe8WApilWe333ag5xlkVu3pcABtgfBROSaRz1m3x36pgzSjUF?=
 =?us-ascii?Q?XZMdW3HO5snMi/8GsOM3L/uStswR5ay/Bpvr7/Go6sSdt5EJkK0fxrlVJNg0?=
 =?us-ascii?Q?gTPC46OUNKm5erUVmwMyP6uk5cveP/MXdJy5uj4CFIa4tvSzQxkwFwCNjf6F?=
 =?us-ascii?Q?I40VCCKALFMrB5I2nOyERTV/sjEUrsXl82SdXcNKZpAawE0svN0jzuFHB+qj?=
 =?us-ascii?Q?+9ptIgG7aPBMyGgT50GW1/p4aferleDMTmcFLnXk4P2i9Jkz0lVM8UmSgDrh?=
 =?us-ascii?Q?UfCH3t5nUm3NDR641W0YSXR1M5wZ8yBtgUM+q/7wdQKkG849oSFOMy6mBNTT?=
 =?us-ascii?Q?LnGDjPiumUFfYqbZDXMJIPVUoiGFXiGC0WbX2ts6rheA7lcPXYdMWIV3x0LX?=
 =?us-ascii?Q?tN19+SwONqUSa+b+fBNkCawYtawUjjog02jULCinL667WeMbmp5eZWNQBHiq?=
 =?us-ascii?Q?qJB1JT1xxCvjNavw1smjH66XuqmxkZy1EoOeYVjkEm+sIik1n27rURtq7+Bi?=
 =?us-ascii?Q?XDsOWisL3zsFB14H879CUhFgHbOd0Y5c54fhNj1sacD1hoODrI8y4N+/kyyT?=
 =?us-ascii?Q?DWFnwYze/kpXKmqCyvniYLSPRANeW9Ac1ocRQOqs/x4JfD7ScwB4Z539KfmC?=
 =?us-ascii?Q?2LV5RcXAluW2QZiuKmmm/twyXhIchvEnj2JKjuPHWKSqsKGvfMfsHTffJeeG?=
 =?us-ascii?Q?z9ttVA/tSc83Bpjs7WGFbmkPmo5y4RwO2aUU7MMJ9pR4hOIlbjf5Jq4Pl06W?=
 =?us-ascii?Q?/9zQiEC9Fy+2q3mczc9zTS+jkFVaIjrOEeldagWlpHeJYrYWOYBf5h2MBGCX?=
 =?us-ascii?Q?xclgfVFQNsknhwhFD1i91od2gpodowuB+Gkxl/1y4A+1qGWOD3ZXJkPMPvWv?=
 =?us-ascii?Q?CO9RNo/RZhlyCajHkULdE1SnmtJDW2BNYPzEhMcxHBag1L56cAbrKxAI5pky?=
 =?us-ascii?Q?AEJCsp/h6RBLDGf4oDPmaXJAcVC06s0yNnqnVt5ava4vbBE5ZjlEGlzZtHfN?=
 =?us-ascii?Q?nzdbUXCR/nvEKHEXASrSoU7dQT2ei+4l1zqAbbhqHKOZLaDh9ZhDU/FncQjY?=
 =?us-ascii?Q?JQCEwbHbDjmEEeub7kwRS9yKe5WHKlBoe5pfEQNmzc5Kz0VmVd0n+Up9Fd5T?=
 =?us-ascii?Q?qdCGQRR9RTeIAQRKKyd6CU0yVczuRBzCGVK1lrnZfI1xboCncxpL/N0c+S4m?=
 =?us-ascii?Q?ZR8CYVp5ugLbXHStHxLMHUN/tv+/sNc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06a3c2d3-28cf-4653-9d7a-08da2cfc24a4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 11:57:48.8869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qHDu2bHDp4z4tisqxUEq0tVsxBr0QCjf8i0Sd9TSINeKl4DXdgo0QocTFuOZQC+ipChnngRyl/wRyHE0s4VctQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes issues found while running
tools/testing/selftests/net/forwarding/tc_actions.sh on the ocelot
switch:

- NULL pointer dereference when failing to offload a filter
- NULL pointer dereference after deleting a trap
- filters still having effect after being deleted
- dropped packets still being seen by software
- statistics counters showing double the amount of hits
- statistics counters showing inexistent hits
- invalid configurations not rejected

Vladimir Oltean (6):
  net: mscc: ocelot: don't use list_empty() on non-initialized list
    element
  net: mscc: ocelot: avoid use after free with deleted tc-trap rules
  net: mscc: ocelot: fix last VCAP IS1/IS2 filter persisting in hardware
    when deleted
  net: mscc: ocelot: fix VCAP IS2 filters matching on both lookups
  net: mscc: ocelot: restrict tc-trap actions to VCAP IS2 lookup 0
  net: mscc: ocelot: avoid corrupting hardware counters when moving VCAP
    filters

 drivers/net/ethernet/mscc/ocelot_flower.c | 10 ++++++++--
 drivers/net/ethernet/mscc/ocelot_vcap.c   | 11 ++++++++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

-- 
2.25.1

