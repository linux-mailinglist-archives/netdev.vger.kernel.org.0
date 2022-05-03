Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DACA5183C7
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbiECMFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233912AbiECMFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:05:36 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80084.outbound.protection.outlook.com [40.107.8.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC7A30F45
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:02:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXK0mp6ZA6HAp3BfXsP9LuNVnKGF4frU55v6Etow60nhqc0pklAphDx+mxYt7JiU3/labYrU1m5eCBh+3ah+/6dB5OhUQ7rE1GlsJyhQBlA9L4GXyPianh0SnlUldkj0HgFvRhzIbvLpPOS3wR17QJCM5wgxpM4jvQaLR89IEKpdB7bm9twtyh0EmLYgw5/YFasNeEAHCeHBVwvFTSzp1owF40nYvKeWCRfR89ON7BcWp7BqaaBd8cAkQHIWr7+8RqXB+zd+SHaN4Z4QRse01X2B1iun9rMv4B4x4xhVxLXkHMJFViOnJwrbv00SAEioefH8goAce6lLshoDjTLa0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BAtikziy5MALYBbs29G8FWVNVkWUcadX7bCjlwnr51U=;
 b=RrSyqei0hGLLKQgp2VDAaE9LLG6W1Fvk0LOgXQ4b3lvDuwC4ZsYwnOnfjrF3joqzhm8rbZvmfXXSg4RyiULPX+jpHX3ehUwFXDFipm88kU+xe9J84OYJQktx6CoJVxlL5n0uIL7z0PP7OGUBye1c4ZXnXzpr8ccwx6IQGs5qNrhP//UuFihkVlgj8Gs+vmaCKwsPsJYx5AMRMYdZxUsqKwOlODDeaiRM4Pa0kaQ0Aj/e9FSdHJyGhehkcz0TnwR9lG9pdFH3z708d9LXBAbwaXdrsCO68qcc2/dTW/xRzr7m6JGVySWCktkGaSFBCpsjRxhV0I8yfIFf4FndmXViEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BAtikziy5MALYBbs29G8FWVNVkWUcadX7bCjlwnr51U=;
 b=CXl1+etHxdeeHaEAnObRsjPAXbY3ITqiVlH9s4GH9deOz5yZXFJFG7iq6SxVZupQQ+nErW6uHTH7wlL/kMXdTLavbCPbn+EDx045qCdRNtCBnu8Uh2oqce/5E1jTVWxWZZJSrkOJPidlU67xwDCGeQtnV0BKqO/0cGah5W81ZuA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AS1PR04MB9480.eurprd04.prod.outlook.com (2603:10a6:20b:4d6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Tue, 3 May
 2022 12:02:02 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 12:02:02 +0000
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
Subject: [PATCH net-next 0/5] Ocelot VCAP cleanups
Date:   Tue,  3 May 2022 15:01:45 +0300
Message-Id: <20220503120150.837233-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0067.eurprd04.prod.outlook.com
 (2603:10a6:802:2::38) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf103080-568e-4fea-e8e6-08da2cfcbbf3
X-MS-TrafficTypeDiagnostic: AS1PR04MB9480:EE_
X-Microsoft-Antispam-PRVS: <AS1PR04MB9480F96D3D2BE7830F5C627EE0C09@AS1PR04MB9480.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4qTpZaTwJ7YqEJHzvv/F24q+Y0t2jujOYsLD1GcOcRSI1U6/95wB4H+harC+EvtIaj5JNgX5sfd1FoI6yTIep/1FwEZg9WFKWjj5tF/WYdrJB/LtiWxBNbdBWx0+5Z84UYif0Zp1/PNlAjd/Eso51t+7J4guni7tTqGXv1zIdR2fHU6ScwMsX5/ZTWGIijG8QechaaHLRXI7ANMfBVxtEmKN10+2ApPl2H6ptdpSgfflqg2b+Ig59waD5PWnrCzBvHdg9Jps+LQC9EtnJDd12afES+NmXdaw2sJr13BzYNrwTmR6AG+urRjvSvlAZcZOJP4PgGQuq0qf+Ha33HmkjPA5xkgzu4sFbNcD/aaXB+oqMDOp6jwYsCxscIk4HvoJfhIRJLA3mrvR5iU3ovLg8MU4wrkxnj0ec0V1zEDsKtW0KyvZTAbfbJYchFxO/PjGHiRZaYBJEnB7boN7IeQsv8+4fjAvEMByNl6FUvyskT50XgJ0DkuR9U0BTUGhh6dRPgX5pe9DEcnoSeHG0V5MOWiCRbfRP3PBWm7gX9NsaQ1m1oi4UTMbbX+Jw4pa7TiDN+TYv2mbOgPDY7vjE2Xp2hZenmr8Dkwfy/VFKgS6sIHneS5ti2UFylwq4QeVUbgJf16GJlPrsEpf1SnonIY4Mfr/jG7fxuogol4Gr7b3h2rdIkXKqMg5m3P7Ahdcph8w/2TeA7pV6hRHbXr6Jq3leg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(83380400001)(8936002)(7416002)(8676002)(66476007)(4744005)(44832011)(5660300002)(38350700002)(4326008)(508600001)(86362001)(6666004)(186003)(54906003)(2616005)(1076003)(38100700002)(6916009)(6506007)(26005)(316002)(2906002)(6512007)(52116002)(36756003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/mDuoPrqGOYXlX+1L5F0U6Hbam8AJw6jraPgKlXwcvb6UnpE4TsdJnr8mZwe?=
 =?us-ascii?Q?cNsTcHpoYVreZwu6yNNAfKr3DDqQLPPltphYcElEJ4JxEgJf+Wglv6O83Nwk?=
 =?us-ascii?Q?Flq7sCPWC2CaSLiD5ErYk9i9CqW3rhQhDx2s7ShqAQbmfNFaOneNGfmYH4nZ?=
 =?us-ascii?Q?3QoLByfnPZpNWTKbyWPSY57eYa/T8XgTC4qq1x4IGLHym6mTAxtztWFWKyEy?=
 =?us-ascii?Q?eH1FPXPig3V004+uGBhd3VktoVtI8HkWMCBzFj21FRp+K52jGoCsxqm0ARO3?=
 =?us-ascii?Q?ma/aNmv5jK9+Z8YKyS1+kNEs2gAppLtNGvBm0Bqyqe24C9vWutGtMDeJ2za3?=
 =?us-ascii?Q?sCjNGs/Dax/yk+KNIXqzHaQVTPtGGLQcvfa5Vi+jUMxl41wVfdnPluPS52C9?=
 =?us-ascii?Q?JxeJ4RfJu5YjkJTus1kJDsUIF3VtyaCj3Dk+c/2TnrW5hWiwXM0w0/7g59Zj?=
 =?us-ascii?Q?3w4bYugqaryRlmWnpddrOqrrHaIdtyVorzdIHZw143+Y61jk7lcH9pSyMamH?=
 =?us-ascii?Q?qtI3XPH6uf86Cgva217fKZjVmVKV9dDCL95+eaKF3J3UvZkF4dir1E4Y4qbL?=
 =?us-ascii?Q?4v2EEyBOSnSYXZbkhxnvwTddPuj1zIxQ0yEuiLHL0+uEanfD+baFOKJXQden?=
 =?us-ascii?Q?vYieyL14j4m0DD97I9OvvvWauGPb7ma8JznkjMwIJtbn0Jt30EE17ZYfj+SQ?=
 =?us-ascii?Q?2AYLvtr6ycTLvPgsGEtqxSa0HVmUxK3LMdS1r1fhBKo2LvZk8C9IUdOy4rB2?=
 =?us-ascii?Q?eaINcKI+ycb+ORQFZMotC6vFm4GkKWNsAPtr2qtWkyw4SAgSO299hX/2bNCB?=
 =?us-ascii?Q?hT1P26lYAxWwIFGJvxH7ZJg+0lpfEtgaM1uzj73TRIcWiKQb8JbGu/UZ9oZi?=
 =?us-ascii?Q?Iy9vN7NsasgxYOxCcPYTU59uAXaw8zCgF8In0bJenuXUJ9ryN4GHu2i7QZSX?=
 =?us-ascii?Q?dVyP/qzBwWcB9Gf2elj4MJ18PdtJKMsXxKtQjl7HoZvtRxCYKKtVvRlwFsRg?=
 =?us-ascii?Q?Vc8vDZhkgpWaBE5CZj4xrOWfqxYj/CStQP+VzMrh1vhQGAp5nisAsfuCm/6V?=
 =?us-ascii?Q?ypGVYZ/w26+MIiPAuD3vnaSnLUHFBGxxG0bP2vaSldPNMX1drvygvDyEVwVR?=
 =?us-ascii?Q?9+qV3uL05Wzqmr7mcLsQlHm6p/KH1orcJ+SGza63JZjbYKiYXBuyePY9rtr1?=
 =?us-ascii?Q?/w1Ekp3l9BysTNl1kEiS1unIFQDPfXTa22c661fVBIT0xevwYrUWIjAolF6C?=
 =?us-ascii?Q?Le62bTnNBcydjOel873dbpNtVcsBbkAUgnkt509gdJOz1nyXTkzm1zFaDL7B?=
 =?us-ascii?Q?2qXyWnSMnMV6lrraryi73MWHof1VbjrtUYv8fNRiC9qy3QTFMY4kjMLooYNB?=
 =?us-ascii?Q?qbhuEg5CUVajKgn9aWY9qw0iaMc1+lm4YoFQLrzHq6d3oXfAOPb/vOIBKFVH?=
 =?us-ascii?Q?1CkZ4WH8m4EsqG7mwCQ+iYqbfyXs6Q6DUP9PfUiCski/+s0W0UgLiaMzHmyQ?=
 =?us-ascii?Q?E5TNL8mJQjsPYjUhLawnmo+AKur9oB0yU3SIj9KMcioxJ0a93ljdhw/66dA6?=
 =?us-ascii?Q?6Yy0BbGipcNZyR74XyvKpboW5koEjS8s61e27jFMDBA0pszDnmT9J+XUwzgM?=
 =?us-ascii?Q?v6C/5SMnX7/fLFZc+uiNzpf2SNy2/id6aYons+SZYdFBe2lPNOQT2Sx+9xQT?=
 =?us-ascii?Q?Q0f2cnhBiCp02Xx2A+/RF1pzyQJhkhVQgNxMS4zB9VHaE79h/yRIMaSNf7JH?=
 =?us-ascii?Q?hG4MOO+usppl2f7nPdcldW3og57hYQE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf103080-568e-4fea-e8e6-08da2cfcbbf3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 12:02:02.5238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ubIJZUr29c6R/d6d7F9SFkwP4Zm4UJuv+ZofUMbByILGxf5owa6w05tXTnHC9BUZC0SYOEgdZ1FsNDx8v3bog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9480
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a series of minor code cleanups brought to the Ocelot switch
driver logic for VCAP filters.

- don't use list_for_each_safe() in ocelot_vcap_filter_add_to_block
- don't use magic numbers for OCELOT_POLICER_DISCARD

Vladimir Oltean (5):
  net: mscc: ocelot: use list_add_tail in
    ocelot_vcap_filter_add_to_block()
  net: mscc: ocelot: add to tail of empty list in
    ocelot_vcap_filter_add_to_block
  net: mscc: ocelot: use list_for_each_entry in
    ocelot_vcap_filter_add_to_block
  net: mscc: ocelot: drop port argument from qos_policer_conf_set
  net: mscc: ocelot: don't use magic numbers for OCELOT_POLICER_DISCARD

 drivers/net/ethernet/mscc/ocelot_police.c | 26 +++++++++-------
 drivers/net/ethernet/mscc/ocelot_police.h |  2 +-
 drivers/net/ethernet/mscc/ocelot_vcap.c   | 38 +++++++++--------------
 3 files changed, 31 insertions(+), 35 deletions(-)

-- 
2.25.1

