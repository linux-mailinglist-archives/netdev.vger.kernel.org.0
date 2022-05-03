Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705D1518483
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbiECMrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbiECMrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:47:20 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2072.outbound.protection.outlook.com [40.107.21.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0F71CFDB
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:43:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fayCqcqrshXPwDWMhXyFPQEAxdkGqUOyY303weXKGD6NVNt9Umfd9uWlglQ3DtUoMsYdkOyRgfdUB/btFC3shfellflae3Ah5FboIPFZDyrE1FEiP6DTvtWGHcFsaKPYxDsLj9b3gfdz9FMRSpdxA1mIcn3Mh8qPDiCqxiOkMDbrUUS1aVep0AG29JeUAFMElfRC6MVhGDxRrn8fJPhDeghEq4FfuSkcFgNhIcyoLGC3vXNAnsm2g2vcunvyzJS3/pzVNPzpVYOH1X93/gZb1+qy4ii832R+zgJOwx4glgbUE1cb/jdLjUjgzLm+XTLf80vzttteJSsE1oTcZFbSiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GiyvnvPkaGdpRSv35Eo/FpTpnQSlRg9cC6GxRVXshyY=;
 b=nVgZ5PLgKGAxViX13Qif4N98pH4S0jPzCRio3LBppUQC8hRpkhhvLc9EfYfEacwDldIUlYgLBet0lBVKgtvuITR098z/gnDmC0UvEPFidM5zSiKn5lFkqLpnIEcUL+VUAECjjER58I4GPtxCl3+NrTPi7CQs1dTiI9YeXvTwUtPgyybdjNqWLqdLJDrg3k/4tgO7IG+OJRBnEUROClhuGjLlB9/AtUG1NpdZeoLw2LXZ2nJAQstypoGUdCzag4n7+f2YI2hpjfKJWbJtkVB/m3V0TQG5x+cYmcOwtxXrNl98fTUneyCFMX2zE8NOvLXIntRlueRw115Djulpky3EhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GiyvnvPkaGdpRSv35Eo/FpTpnQSlRg9cC6GxRVXshyY=;
 b=fTVVwz5fvAOJIOFaZFX6yhFqHXM66xWawLEiHt+fXtxlD0EFkDs0YyoNj3bv3MH8xnW4fu+hkAxRl/nRUcDt8PkmhS8OAPvZv7t+rNVR+QL1RVTIAhbUssQkfaXrYItp/rU3VnBbZk+lipnpTTvj6PY616qdrTZIp08Br/7Q+oA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DBBPR04MB7675.eurprd04.prod.outlook.com (2603:10a6:10:207::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 12:43:45 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 12:43:45 +0000
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
Subject: [PATCH net-next 0/3] Streamline the tc_flower_chains Ocelot selftest
Date:   Tue,  3 May 2022 15:43:29 +0300
Message-Id: <20220503124332.857499-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0036.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::49) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba6afab4-915b-412b-7767-08da2d028fb8
X-MS-TrafficTypeDiagnostic: DBBPR04MB7675:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB767568A29F215D7A280D7EC1E0C09@DBBPR04MB7675.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mXVeEJt7wgKZUHAOfTQrM1qCKIbHFrAM/PlgdWkQW2q4EphRsdt6OzQmdcFVhhSvnfI02Ey9XvElPlCQ1mw9gfIdJzUqrop6OXRS0eWgpB4eJoyQcNwPhLafaIFtY/bqQFPWzly9aT/E86Rt0HYmAakVX/Ct7kv+nSebIHwkImSuuKIWbL2nFW6xZTLRpXEXHYPz73oKl/zytz1UB5lrSYl6/y/PJNCc62iZpIlooD+vF7Lj5RHtRA4P67TramTiZVBLyJGfxAyvBaBTkaGmZPtjno+I8wiQdkhoj3TUP/xYHsKLs3RduZZw4POGLmgJBE38JQzGwwQgvmxnW2TAuEd54971dMqCssKTIV+zKhUC+AQEFoqnP386Wr780nHEFH5ipm0wy6rXRf1BkZib8o4ATqY5PWXz5NRRqqHag7tpuYjBY+BkR1jdwseREoIhmIcEe/K5LS9aONvqvmSQ1YUnTy3Dv17kBclHu5/2W8cSXW96Fgy1ifM+9r3yRWuI/KBtQx7r9G/zwoecCpKW+EW2lBQBb1Bo6FWXZGcmMnMX0ko4Y3j+8dvHIl00SIxhkw3ctB4cO9z5mdEbR8wf5CCCWO4QejvKCU9xxZDE1X7O4JoIAtKJQiDBjWlwJ1sQeaBAbF2SnlGrpgo+pEyVemh/DAUuM64WPwxhppuANOHnJW6EGp8bVEBaPjVlbRVMBMnvhzUyOQI7SNAF6uV7DQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(52116002)(83380400001)(6506007)(5660300002)(26005)(6512007)(316002)(86362001)(7416002)(186003)(4744005)(44832011)(2616005)(36756003)(8936002)(1076003)(4326008)(6666004)(8676002)(6916009)(54906003)(66556008)(66476007)(2906002)(508600001)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ILVL9JcpLxu4KulNs0iEW7sBL+Blq2foS77W1+G72XS0o9oyJagq6gZ+YEjD?=
 =?us-ascii?Q?gt9blMwhubAX5/QyLAg8KIT1uYUDNbwYfVT3VA0jfOzMijAMeKKmzBOMTCJT?=
 =?us-ascii?Q?wW1O2DNWZfDR0v2QSEHhxo3/l2ljUE1EUPjgEtOTqK0uGVt9HBqQMPRs0c8T?=
 =?us-ascii?Q?NUgzLAULOjYSUoddraUEIT4HZ1y+a2UVh2DlQuOh7MsrXKoj5akxaLdUSblc?=
 =?us-ascii?Q?f6ZeMcznSwBfA6EFxuji06Tm5DPJCDT6eDGDeQ3trA1u2tED1l6ATzuLiPNy?=
 =?us-ascii?Q?I5vMs4whc+p0oBLYAux3Y955UFXSkaCH7WyJthuMdGugXLEnJ0uf8MmTZmn9?=
 =?us-ascii?Q?H2+rJ6t8jBxFTBypj/S6HWFIhTu8UxBzQ3ndF6F0q3HVbv97Zvj7zuSH0EeH?=
 =?us-ascii?Q?mCAg9onVJzTqAsK3DbX7N9ImajK+J9jr3c9c5PHiGABf140JSHvA6glwQj+z?=
 =?us-ascii?Q?B0Dz/u2YIF2FAFOYczqezhSIiTU5OuMWIV2aZl6QH7Hwqkxgq1IMvcEbBn7X?=
 =?us-ascii?Q?kZIGzqi00zL3PDMfY5xdlNAqAtw/uCE+8wuekxFqwvUuQ0O+D+teOewytswM?=
 =?us-ascii?Q?t3azFt/iTBAPdLyocECvpbrxI1h+Va7vkWFWpJhGrjWAqRtoJ+o/HAVfFd02?=
 =?us-ascii?Q?yNDnLaeblAYAxKXpO+Hq6tmUQVuArp1EbWb+MdSGL97Cy4h9AM99lcodcVlu?=
 =?us-ascii?Q?7o5wX1a2TBgVb0QXNHQAxvTYM7Vwktl0N/fbQ7N1HKsTfcJO2FjnIJf11ZwW?=
 =?us-ascii?Q?d8RfVINpMmlLCKAJ3c/s2WlTtxEjx2LBSk42+O2sKc1NGhlo3eLscA70hlFw?=
 =?us-ascii?Q?EIptpN1fmjWKevcs/2EHPYkPnur58wnzKR6kh66732IoNhuz8r0XMOgyKU3r?=
 =?us-ascii?Q?uwpI6u9ItODm9vjiZB1E+rnIAZ6N14ShqNToR8EHr9fTImOVQw0PVq8EyF2r?=
 =?us-ascii?Q?A+3rxidf7nQA0UMoGuUn9K4uYEW3UsvMUIP2dlV+e4UnP/v/2u5fhcOzBbQI?=
 =?us-ascii?Q?sE1t2VMT3+pSEVgJMZtnE/Ui4asoXbGdww/IKFNPOY4thyygIsoGbBIjcZQV?=
 =?us-ascii?Q?XVS0W+h+Ei52akVtgElsWPabzg4AThfGp3K9WUODeuhy8Z8W71ZWZqH+atfg?=
 =?us-ascii?Q?MhDX6ySk3Vr2t32LLAgI2crKDqWXtz95x31+W1/K1awt6VR5NVaoy1yIhkIu?=
 =?us-ascii?Q?fszfbTz7bPE1iO9mxr1TmyoskrB5vtKxud+yR9w2nWFVssuhxq9naX3OqTbm?=
 =?us-ascii?Q?UHICKSU6DoczFWsqqiQ94JBC+FVyd6mLgXr901ja6tXeN71RISds1P4wn7e+?=
 =?us-ascii?Q?PvA8oa5ep65U0Q90qXwwk/gzDQd8zFpc/Cye9wZzf/03zVFYWmxJ9OdKuzC7?=
 =?us-ascii?Q?NlgaPiq8I0Ermk1QFCjq/WbIQcwXKANNEshdA97JeL2ZXeF3yFJHCHHZdjfk?=
 =?us-ascii?Q?MRsJVIoxrAdRD4EQj+chVedg2S3gpwGaXa5ypEFGvd9dnPoemDFKIjTZ4M7n?=
 =?us-ascii?Q?Y/TVk1O+KhGSLJTwbxg2e6GvY/C9LKb+exgtW5RBzK+QIEoIffocXnWIjOBj?=
 =?us-ascii?Q?MtbLRqiUd0roHtDNCl1Wn9L1o6MTRH7sbrCnwJOWMcI6VvvR22D0S8jBssmi?=
 =?us-ascii?Q?tbiR6hPGGO+vpLO0dplLXMkmT06lgl0JrheevP91fU6Ex9t8Im1O1TqTNktO?=
 =?us-ascii?Q?nUVjc0M2MEuJ+24bcgDpm16hohNK1RqkbQfcs8Cp19AZW7CO+gpFH/oduMOw?=
 =?us-ascii?Q?OoSov541P3N1SnU9yob85eBUd2KNg0A=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba6afab4-915b-412b-7767-08da2d028fb8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 12:43:45.3105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a6WFANwVQDBnXinvABWshtGjogT5pMYnPY2xPOAFwVoZazgqv4V27JUqWDTTpJxWevC6RZZtkvFUOCTElyHuwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7675
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The forwarding selftest framework has conventions for the test output
format, interface names and order. The driver-specific tc_flower_chains.sh
follows none of those conventions. This change set addresses that.

Vladimir Oltean (3):
  selftests: ocelot: tc_flower_chains: streamline test output
  selftests: ocelot: tc_flower_chains: use conventional interface names
  selftests: ocelot: tc_flower_chains: reorder interfaces

 .../drivers/net/ocelot/tc_flower_chains.sh    | 202 +++++++++---------
 1 file changed, 97 insertions(+), 105 deletions(-)

-- 
2.25.1

