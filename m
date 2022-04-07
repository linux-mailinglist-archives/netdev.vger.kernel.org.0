Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7580A4F7050
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 03:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238399AbiDGBVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 21:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240535AbiDGBUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 21:20:04 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2090.outbound.protection.outlook.com [40.107.215.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF7117FD2D;
        Wed,  6 Apr 2022 18:18:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TY64cCU3gG+BO3KL7s2oiHFoT9o+0UI7MpBZ/zUWPAqr5S6QCBZXN6rTjE0pA2znRzoU2uwjc887LRmvln015d4SLj3QkYegATENcPr8zuKdRhla4ngQwM3Lm2h2u+3fHnyIbuHvfSjW87ueQz8KA/xcFUoz53zulth9pSMa3X3EHhOc1ED3cQ2wYPbAQviaCQYS1FqEJJcdPdHIsortHqieueg7Xij/HfFXT4npOi2+mCqRCSp/HRPVzhR568jtCNhboboFLweUoshJqsXVyDoWbTQQn+fc3hFuUwYI7y77FM9zpnHW1A3S6q2teo/Cevpy/+ID6V/WP4O8dTQ6qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6NUM/fNtLxUyxz3cofw86ZeeamCeINycOnOx/+8olOg=;
 b=FoIq8T1pAaQCa1Jh9NL96D/dOL4ktkwTa9n8n0f41BnYKXQPH7QDO5HLB18hOiucJdoDASmZesQ8KKLY650dK5T+KMRbCp0c6yUof+7mTgsowV2zaIyBde0Rfo+TtjROGHKEasMKEjjsI3f+3bJVOPbuwHFmsUmggOg+FrRLZ+/xV3gJ6vEjvV4oBpoxBAXNyPgb+wiorkfq/1C9xwlfg0RNNtiT6xTMYkOdZumlsAPp6xXKdgXdMC3OIfvS4i+4ogGEpPSIurNT43QFhx4iyCGtV/1XTTSyFJhSt5wEybO2nU+PENhCBF6FCqC1Z5u/aUc40/XyyVLlS+3qtN1MqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quantatw.com; dmarc=pass action=none header.from=quantatw.com;
 dkim=pass header.d=quantatw.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quantacorp.onmicrosoft.com; s=selector2-quantacorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NUM/fNtLxUyxz3cofw86ZeeamCeINycOnOx/+8olOg=;
 b=L1JNKHjT7/AYLmtAO9eyAGFP6npUHordWTbmUmw1zmIcmuy+jdLANd71RwpPmpyYXzb62ku6Klz4JzVPSjyZBQKulhNY26eEbHRz1kF2ImPDSBa14EcjAF886u3cCHrH+vm3AmZHb7t4tKoXfiy+15p2FsZsBemY+k9LCrq2JkY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quantatw.com;
Received: from SG2PR04MB3285.apcprd04.prod.outlook.com (2603:1096:4:6d::18) by
 SI2PR04MB5412.apcprd04.prod.outlook.com (2603:1096:4:141::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Thu, 7 Apr 2022 01:18:00 +0000
Received: from SG2PR04MB3285.apcprd04.prod.outlook.com
 ([fe80::e94c:1300:a35a:4a1c]) by SG2PR04MB3285.apcprd04.prod.outlook.com
 ([fe80::e94c:1300:a35a:4a1c%2]) with mapi id 15.20.5102.035; Thu, 7 Apr 2022
 01:18:00 +0000
From:   Potin Lai <potin.lai@quantatw.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Patrick Williams <patrick@stwcx.xyz>,
        Potin Lai <potin.lai@quantatw.com>
Subject: [PATCH net-next v3 0/3] Add Clause 45 support for Aspeed MDIO
Date:   Thu,  7 Apr 2022 09:17:35 +0800
Message-Id: <20220407011738.7189-1-potin.lai@quantatw.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0143.apcprd02.prod.outlook.com
 (2603:1096:202:16::27) To SG2PR04MB3285.apcprd04.prod.outlook.com
 (2603:1096:4:6d::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7e6371e-8d75-44e7-c798-08da1834748a
X-MS-TrafficTypeDiagnostic: SI2PR04MB5412:EE_
X-Microsoft-Antispam-PRVS: <SI2PR04MB5412B1ECFC9E0A1C7A14AF2F8EE69@SI2PR04MB5412.apcprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UgLYPQFdbPRw4e3Jqcfs24YaxFyznQcVvcDasn9H+pkd4xvU8EX6xlehOvqOJlK+Jbdr5JHXDzLE6pLtDtoFS6f14CtzW5VJXKp0RxiAfNIY4pKQ3R4KWx9NkhCRlDUSi7L/5Exdd2URHUOiOgZlk+kPCcgk9Nq6hA+hR3Kgkj1EfdqxmxkG93lQhCVhFk9qRImkkEroBp9F72VDwXF8wqFH6W+3a2n/iEy6QPcNP4/i+Iqe9+bb775uY0V+oFRpYDVgNdINmUweJdMSk8bh/2CelTz/VTt/Zsyp5FOn1VDy6vi+gpZygfOBralSiOl2Uu6q5gdsTqq9i/+43VadeYmo2QYgPEtT+evOW/bJvPDxFSeHvz5dxsp9LmcUvAfhIREIOCw3HVUpAxCQeg7L9H2+z3XazO+yQMhslaka/lFWHSwpsdNHTXrbxnXpmo5IpGuq4OnDUlfEgx4HRqCcBds0VM+UYMJ26WEv3LhvgN6s/AWny0a1Ra3fUid+F9JaIdDxdGvJ/KmxgtXzcc57wR5rQ1UXlnPo8717su51qdVm2AoSSZTxcrQ5MrrX24OkMNEuM+DIflen4BVM8+7RiFleeac1TNxAtx64BcXioV0ZwjmUy5sD3aRP8KkfWlFS5Fb157lJ4V1zPliVlsyCgMcSGe1hj2/83MqkPskPqCE/FQtOqIsF9rKmU/2vP5Yf8I4fOpR00Mek7RVBwnvfVJ/a/6ulW/Y8ivV3mTSqwuW4I09oJuejUt2r1Myg+ebNsu1J1dFhKNqB1TkvuWHlHS/urtxCbO5F3RqPitwOqbZhYb/eLNoIzWLMo6VjwgX7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR04MB3285.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(186003)(107886003)(2616005)(26005)(52116002)(4744005)(7416002)(8936002)(2906002)(4326008)(5660300002)(44832011)(1076003)(36756003)(316002)(66946007)(66476007)(66556008)(54906003)(110136005)(38100700002)(38350700002)(6512007)(6506007)(6666004)(83380400001)(966005)(86362001)(508600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HTKCQWSgHCM2Md/DWKdevWSf11c8Z5yojT/+rV4eoWs0CuQ28cZxTwUdOmWQ?=
 =?us-ascii?Q?hiyHIzjDdqrnIHUCzsSzo1GNH7GjW6nqq+DCxtHmkc9a4pV8iySrAkYsfWCn?=
 =?us-ascii?Q?fSfVJ7oUrKgZiXw1wX6297sT5m6pHJRPQ9s4J4pGP3aBK0Fg3kqrjmXbCaLL?=
 =?us-ascii?Q?K4g1A4+1WQJJfE1w7vs1KApBvA1KQoc414rybdryCMZMgOKf7gS5NQuTiIrJ?=
 =?us-ascii?Q?TBo70SXK7eadroGUpblPB8HxFrkEsiC7DoKvhlqaPzzgL05ti9t4gFix2aiO?=
 =?us-ascii?Q?LrYTqR9J9chTbcqAx0XXEy7Pt2E+3H5Q4A2ok8eQECuBFKmttMDOY9nZ1VYT?=
 =?us-ascii?Q?079JcT4hzG1A1wEZCUtwBSvdRYOQZh0PwIZyph2BL/zuNxQcQgVAA+QRNqgT?=
 =?us-ascii?Q?LnXo8W8k+GC+kyr8z9/O33KiJEEnOxAXukiFxPzegsk7jEoUxvKuEJaHgcn7?=
 =?us-ascii?Q?YIq6D+77H+aaVwZMyS811krDtkFKldgbzLH8FHw+4FqzGBH8YYXK7o0qpMGM?=
 =?us-ascii?Q?9TF8452YyyIk4WDDVmZ8e8Nkrah8LkXPRg//PJh0kn20R1ZFcbmCU3ASI4LA?=
 =?us-ascii?Q?S4jRO/H54T3EfTt7vYphqSTmBean+9WDSM5Rl5nKjpz8fizl5VKesfPxakR2?=
 =?us-ascii?Q?fBZY3RXPNne4qnRM+KJuYcP2uti087Qi1YNMnXgWK7Cs8Uz8ccHNun0Uj80I?=
 =?us-ascii?Q?K6xsItdeg18uu8J0OaZiNBIzCQa1M8giXA+JTbDp7vQdC9+os05tWwYHBbU5?=
 =?us-ascii?Q?ByU8PJe04ubSTTmggPHm4GdxD/D74IrQWRCFvFLS+8bjAadk0YjJwlidVHRj?=
 =?us-ascii?Q?twRx4TPLhoudEGPp8G6joCWrcZ3TF6iA/pWgwPuMxsY0X3UcfnJX9VNGVNtr?=
 =?us-ascii?Q?VgmPv1WdOdQo3xO9f7bN/MrahTDjuYKCeBiRQJmwlbMQce9oDkNbNH3j1BkR?=
 =?us-ascii?Q?8H3NVMsxTMqxJZZ3aJ/Jh9Acp3IpwSpeA2QvWUbBETRlG8VyI/1OGPjjJpDN?=
 =?us-ascii?Q?fpE4yA7Dz9SZYYLGaqeX5/gHJoHMLZvy1e1nZTIEWqoS38rhQu21skUaX+t5?=
 =?us-ascii?Q?9laoxH4j4/K9X+KSxaxyBhwBoEsge4uVVz5X1kr1reg9swOXbp3rlAC1duJD?=
 =?us-ascii?Q?SefDt3XZWKVX+IeIrP1FVe0CXG5457joeUfDpDcJcXr0zrDq0aMmijHSMsE2?=
 =?us-ascii?Q?Fd29HdXj20MpyJTkTYdSb7tPqo2QvnW5bqFU7EbhFpxWwUZI4gWuvsSyr3Gf?=
 =?us-ascii?Q?ieN4CDKnzzc4oy8WRf0Pcfwf+UMFE6ACIPEmqBmsMfv2MB1z3XFgNfabYiV6?=
 =?us-ascii?Q?YBaq34f61ckaIINF6mhpGUpeWA9z1YFZ2oe35zkwrco7jWKBZKiQlyBIPYT8?=
 =?us-ascii?Q?MCHI3+Wu37veYQQL5dpuc5aXhSvPlT49vaM2fQFc9uezNOlM/GOlV3zH4x0h?=
 =?us-ascii?Q?DSZ0MiqknvKfYYgllM54bFLrXkGS2TreuoRJbtppl9BFV/uddwF7eLZJNexm?=
 =?us-ascii?Q?GCUFkBAkirhKusM0QtLioid/ykE3+yk1JhC3Cct4St7rT6Eoyh6xaoZL71ro?=
 =?us-ascii?Q?PhlNaMGQSv8SWjkxp8dJbwy4ovjHiwBqMa0iPqfdZrDIa3e/JuDSoa2JSee4?=
 =?us-ascii?Q?voSpDigb7S4E64lWqaGFRazZjCMZaQcquuca4qW03AlCGLanwXer0IyeQ6RZ?=
 =?us-ascii?Q?YQiDnOWfF+KBg2LhtkQ07SHuxZ6owgK10vJAZ7RqSnv1dRTevA5EEYqFu8v/?=
 =?us-ascii?Q?CeV0xJCmfEhkwbYV0e1AzNU9+KOgJTc=3D?=
X-OriginatorOrg: quantatw.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e6371e-8d75-44e7-c798-08da1834748a
X-MS-Exchange-CrossTenant-AuthSource: SG2PR04MB3285.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 01:18:00.1933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 179b0327-07fc-4973-ac73-8de7313561b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uy2YRF9oQZmingLsDrl93MMZeyqJDsXldzVUJLilkKHNZAzG6XWIyHzYLp/Bek2yTzWBKfZyONVszdoYH7z0dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR04MB5412
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add Clause 45 support for Aspeed MDIO driver, and
separate c22 and c45 implementation into different functions.


LINK: [v1] https://lore.kernel.org/all/20220329161949.19762-1-potin.lai@quantatw.com/
LINK: [v2] https://lore.kernel.org/all/20220406170055.28516-1-potin.lai@quantatw.com/

Changes v2 --> v3:
 - sort local variable sequence in reverse Christmas tree format.

Changes v1 --> v2:
 - add C45 to probe_capabilities
 - break one patch into 3 small patches

Potin Lai (3):
  net: mdio: aspeed: move reg accessing part into separate functions
  net: mdio: aspeed: Introduce read write function for c22 and c45
  net: mdio: aspeed: Add c45 support

 drivers/net/mdio/mdio-aspeed.c | 123 ++++++++++++++++++++++++---------
 1 file changed, 89 insertions(+), 34 deletions(-)

-- 
2.17.1

