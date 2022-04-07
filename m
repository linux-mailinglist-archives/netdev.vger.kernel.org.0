Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C710F4F8AA1
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbiDGXD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 19:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232454AbiDGXD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 19:03:26 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2120.outbound.protection.outlook.com [40.107.95.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1421114DDC;
        Thu,  7 Apr 2022 16:01:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpoCqeIjeSMRGq/BKQ+7lMg972LH2utwrK4vlgAfFqKn0fPv2SVPffYOWzDxXFyv4s4yp0vA0FQimLID6+pQBxio+rE0G3veD+nZc0aaUzyIP9HYk7Lykwj/sxpPwzSNBf4mq7GFxc949sk/pFij/L8mWYB/yQzgUeOTnQankOnMODrqtL1zyee3pduo4Qtcr+1waDeO2nZGhmWtv2ZXlA+/hVF6AltQ7x3yDbLid05bxJ/NyvOullfDxfOynaY/OqwjmuHWkhehsVKB5ta3fB4eMcPHJPOOzDmlE0U1KsiyeFZWkl+rY8Ypmv69Cz01UOhfnxB2u8RebaRJr/rCbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g8I3lw5wYMjbm8d4lp1ZA4Aqadq4PB6Qx50uqSgD9KU=;
 b=eMEfqxrD+X5n1Nc7hpat1YBPpVKgTVtZsJeytxvs4fFvc2l8+1lx3oXuIEVvm2bwTKK9g2xDCC2maDcfKKwg7m6qOvljFyDw/kUMuM5YNHhO+kE5xXntoSYuOXwt38aeIZgE2gPRT40uyrKLiseoTpPXogvJE9Pyet0+kZRD6GlCFZ26Mqgz++xwmiLn1zlzOXVHv1OUujxxuB5apkDgp2vPPhPOy7K/rLH4x1qsdiOa6tZgySSkpSo19F4mOKyI9YdN9BqD46NsDVv6qtvEjtGphCYYBpJMyfnN5ZmEVz9cRDtBt4ebNWIB/Opg9tg9mv+F6jriJ2zlk0c15uakQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g8I3lw5wYMjbm8d4lp1ZA4Aqadq4PB6Qx50uqSgD9KU=;
 b=xabTXx0BS+vw9cI4WX4++wlkQGeYzzrQaS0LjyFEY9sQFSdoK/F3PwHiaQo8iLNgmrv6ZgTV+AeUXUWeNhZ5zWjbMW532x9QeiqcCL2QEobeljotTIXUBXiap+HbODgeOgauuLKjsuuKUwBplNfWTiZxjKpLH2jHLL8GacDLwyM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB3125.namprd10.prod.outlook.com
 (2603:10b6:a03:14c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 23:01:21 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 23:01:21 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v1 net-next 0/1] mscc-miim probe cleanup
Date:   Thu,  7 Apr 2022 16:01:09 -0700
Message-Id: <20220407230110.13514-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::13) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bef5d32a-4902-4e83-bbf0-08da18ea87ce
X-MS-TrafficTypeDiagnostic: BYAPR10MB3125:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB31259F21958F8F89C6B60CB7A4E69@BYAPR10MB3125.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jm2N7CwKy3pGrs8tdpqu6sTNXYyi+rSuMNXQfSPfoIy55iXNHXnZ6c2LT7qPPf2zoUkre0zRNq6iH4pMC1gVWXJ4TbjPOJe6Z5W+QNMb+HkEdhNGj5Yie+wrxBhm6qliCJ5zPpy6rmy0wdGMnz70fqxUIu6rJQVmMW00ZGCYoZvHzIQL7I8tMRu3ACvy+kKSdzA0UvPbHgJlduAR64tzisQyXmIXgTTpb+Xm5f24bfFZ97XABFPov+J8GZWLpDNxmr3NKr4yTwEbLmgRFUAskLB8iRL5Mp9Xi0rk2Rp3l41r1ZukIy68eSlhGjDrClV3tcBsVyx0c/WzvNP8DSlToJkBRSULls24L0zVMAeo/OI9jjRnpq1LIjKLN72GomFTf+sKu1iN/uEFeTx5MIXtZN7E/JPZXAMSiQsPGEOtVHqMoFxG9jtHriRwYpKN9dGdlV26N4wvWyk7/3wB8O9Q2t2sGQRcazeYOSbOeD6A9VmYELpIUAY13IjrdjNQxEpOAmi+1MFU1qzWdL7k5O/ztvz8rIu/OIEbgl6XY+WS2z8ydIIiJK3yBr21rScbC1SfGvPsWtI67QZquZ03/zPxsUkiORHY7UcdFiW9Ix+WlZYa/MD9BQRlfwkq2EuF7J3g8fM2aw1wtmRJdi0ZoFS1NzvYYd+OtmkHh7biWgNHCd859ixZHd2cJO8phUp2dch7q9Cg879h6s+eyRKaYeZaFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(396003)(136003)(346002)(39830400003)(366004)(5660300002)(4744005)(4326008)(44832011)(6486002)(508600001)(8676002)(2616005)(66946007)(66476007)(26005)(186003)(2906002)(6512007)(7416002)(1076003)(316002)(36756003)(54906003)(38100700002)(38350700002)(86362001)(6666004)(6506007)(66556008)(83380400001)(8936002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uEiyfJA6pKgxBKrSrnN4Ukq9o37RjmKV84acew2PZlG4u5J0qMiDBUYzmLo8?=
 =?us-ascii?Q?+tJP7/EGsuGc3X2ax/4kihNmR/Ag2zBkL1hmvOdR6D98avxL3VEZ+90D2T0o?=
 =?us-ascii?Q?joHOkfgkiABWnslPd/PrZK1wJdh2v9fKrpFlJjneg3KzxHwI2kPwE6pl+qhX?=
 =?us-ascii?Q?6TeEeyKdyvi5zDmm35fiSmNE6y93C1UvVz/aQFr7cHnw3LaA+cY7QpvdWVds?=
 =?us-ascii?Q?8oK5FrsjMBMocmf0HKovOfrFg5z8BJR6/l65P33+6ySP/fjWk2jTJQTCvciA?=
 =?us-ascii?Q?y7yfkHBKlsLAF+mNv7kUvJMOP7RLIguq/oD1TM63W7YPWQ+ApDAeCz7Po+EG?=
 =?us-ascii?Q?eK8F5N0g07CJQ6tjnzSGweII+cbLaNU3dj9Mrtk2g0kAkeYorNGVCViBqxeE?=
 =?us-ascii?Q?SiWYaOXAEcAaRF5Kx6vkNHS0o8W52XDVPbv9HQfofugtez9TuWFUFQahRAX1?=
 =?us-ascii?Q?ULZhR/8T0o7yx5zKLkqcR4c3qCQxzcQ+ebVqH3uM7lVCew3/DZlCcm9DTZr4?=
 =?us-ascii?Q?MNCCk4Up1G85E3GBpv7SNaOmnIi8aFR2XoxC0HF7KIsYvLfejzogw0MThICX?=
 =?us-ascii?Q?4gFvXOrr3x5qHUUxTAaFljBneejhZjZR9idZa/y0cxMlyIahfbonlIs7MBF+?=
 =?us-ascii?Q?fIxvV9Cm/zQgzXkuNYW4nllTObvZ9dXTowCrPD7SXq3iCnCB1++vJiYQ+ZO4?=
 =?us-ascii?Q?THYhKvL+VStzGcga8Wnkx57wZNy+boHi779ppFcZvDAGkgPS25foIW+HIfLg?=
 =?us-ascii?Q?PH+yZGGEuiYLcnRVyO9QrVXu71u8oKXuk22kJSci9icCF+I/vcZpZbgKNS4e?=
 =?us-ascii?Q?0bZ69uRfmeqcUiDla9jymnh3qOtG15aoabrMnUKfrbVZIw73axGiNyHHpAK4?=
 =?us-ascii?Q?f3zroUoLX/WMJ39JtBeN8IJrMcibYeOoafWkDqPz3Y+1w9Cn0GcWQJQogaRy?=
 =?us-ascii?Q?4x3XwQc4eU+lLfBZrxRHQ9UejWY/ucG+fnaau8CGTXQ2Sl59lW1hWJVGpJKA?=
 =?us-ascii?Q?E/3GQwgBLlPL7rTXtYbjnqv4jIzr0CcB+kem+o60RdTF8+B/00TZbhm60Xko?=
 =?us-ascii?Q?PoFzxTHNczoog93pESS9o5vpbUtHz+Nu9aLgVh6Epf5YAwmOomjQEay3aY1g?=
 =?us-ascii?Q?+JVufxp739ddX7TTpwqsMRB19ZtiuoFAlzdDqmYT0Q/IY68/xhtOCnoyL5Le?=
 =?us-ascii?Q?z5S4goPJth6dXoNLfJExl0KhfvjmRcSSNvH6+3as7DEdDaH30UNORCSpOgOO?=
 =?us-ascii?Q?jqEknMf7hiYxFPdWX+l74c+gFU983tWGcP+iQkOwYHy0BoxQg3VACIdCYUEn?=
 =?us-ascii?Q?IBhCYF/8zeNmffFF9bZM5a/me5wUnAuhi3oS+7qx3SZKDlMOYBE0Or9GH8YB?=
 =?us-ascii?Q?iloaS9cDN6hdBJkGfdLR+/19qlKABnaZkXOnqllVjmXHBo12HdskXEiiHzIh?=
 =?us-ascii?Q?MJY9ZJdvBQbpWKujeDSscEiMnr16hgncdQlrzAts72UZRPzX3m4TDJM1UsWI?=
 =?us-ascii?Q?YRoPgWOm5kE+OdMRKMS+tY+I4ypfvTbvyKTiPowRyjQV90FN01XWlf6GJFeV?=
 =?us-ascii?Q?aseqHFGUml1k1vvLXDa7yLxQdTPABUpsdOm5g0ydbhF3AdqtK4cRDFFdoJck?=
 =?us-ascii?Q?ESuaDKVuCWVVsoG4JKdGdGTYEMQLljmwcu5g0gvJnx2Ct7PR41ZNTiqtJRqN?=
 =?us-ascii?Q?lePkPkVMgbvUfvxjS+JCHZgk7M2Tnwj6BhHaRFcCRVUlAo0yYBblBJrFnLf3?=
 =?us-ascii?Q?Ahm40Fht8BD8XAdXfW3woMJpUPAi0cOHhdFFwQ2TM24NLpAmTiYi?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef5d32a-4902-4e83-bbf0-08da18ea87ce
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 23:01:20.9201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4acT7efTD7eIZT9dNz0WBj1de5j+Z9RuL6QTF9tGweXvDPW1Aj5a33nXfeBvEE1r/gizZh+lkmSQgFzSf9ifRkOhbkI6TrhG9M/3kaAWwY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3125
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm submitting this patch independently from my ongoing patch set to
include external control over Ocelot chips.

Initially the sole patch had reviewed-by tags from Vladimir Oltean and
Florian Fainelli, but since I had to manually resolve some conflicts I
removed the tags.

Colin Foster (1):
  net: mdio: mscc-miim: add local dev variable to cleanup probe function

 drivers/net/mdio/mdio-mscc-miim.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

-- 
2.25.1

