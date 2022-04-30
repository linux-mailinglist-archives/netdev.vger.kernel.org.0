Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E946D5160FA
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 01:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbiD3X1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 19:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbiD3X1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 19:27:06 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2139.outbound.protection.outlook.com [40.107.94.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FAE5A5A7;
        Sat, 30 Apr 2022 16:23:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7mlWljwCnLk01hS06j7mEjTkmnw+BXqkbKf/zhe3D6XTXOdKAjsDxz/+0BQlMIPzaNXBItYDNEQKGfEFTvet8aB9UX1b2s/D/HwfuAcI+njCeOUIWJmsBHx9VpE9enqN+4Ien5T5czl9mQieriaDDOlIOJvUjqY6KveIWWEZ/nxCKAXynLbkqBceeQPF4LvkVzrPSyJCkF+3AggaXec2Y/6lAAzm7ViK50Nn1BaH9vuZMZJyTkVM1Rq2i0w3ywAjaiOt9LGzmQML6Hc/5Rd9i4j2zCATNIfekyn+ixeFHdsa/7soL5ncOEG7LoMJPQbKFGTMc10IkfJaxGxljQIPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eN02WzS31QTwevn7g/w180OsGJPKU4kHUSaNahaVfTc=;
 b=Iwm1w7xMcZS1Gx3V8wlM8lVd7kmE+z/Crv3ibHj+6cJ4YnPJwUsgaHHt5EKCOVUb2AYpRt7EC9W9TWSjcZOeWfQNkUF151jeKWuCbEy98SWuc7fcbEazUtb7MYDBmFAyGzbHWFMNVyX04BABsXnQyJk5q3Y1IH3u8HLX9cDDcWnVFlgKDtr3Gwo7OHmBZSOuMUR5Gt2fOVg9nFjsFtdjnaP5Afhnf45FamJQMO3jjrrhxRcAzVW2p8NYO3UmccpwNHCIm4YuPPJgG3Az7+UB6UD19KvLdNoqIgWiWMQUu9Zsz45Q8rZzg9Yio9GKxmU5ZckLc4DOBVutgsyFLBtNYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eN02WzS31QTwevn7g/w180OsGJPKU4kHUSaNahaVfTc=;
 b=csHEcd813XknOg8FDKCH0DdaQgKPy3Dyeu1LLJq0E2xjkU9yzmb0jMYh+DUtfRndT/TR0LP2uT/WvIO2pbQyEae5aKhsxXRT6f3BxA6Q3IN59EOpffnTDL4H7nBQxMxe23ncgmdf+l2cRQDbIbqyzbsIn6IgZ0hIgRCf8HJT6pY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4802.namprd10.prod.outlook.com
 (2603:10b6:303:94::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Sat, 30 Apr
 2022 23:23:41 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5186.028; Sat, 30 Apr 2022
 23:23:41 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 0/2] ocelot stats improvement
Date:   Sat, 30 Apr 2022 16:23:25 -0700
Message-Id: <20220430232327.4091825-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0199.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 005ddeb9-e8dd-49bd-75d4-08da2b007687
X-MS-TrafficTypeDiagnostic: CO1PR10MB4802:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB480214C34C0B3AC12864024DA4FF9@CO1PR10MB4802.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RRSN71P+GKMj652uc5cqrk2H9jPk/zds1usibYoWx8peIu6zueQQcveN2FFc8ayBUEjkJ4PM0+c6vQl2b4I6cAxWCJFeEz9jPDNPXzoa2T4s0DgSj2bHe1Jm6hwqpOyRaAxyXD0pPck0hAq1CVH19sVzBksKQSkoe+b+ruhfnkkvSAir+DPtJxuCzFQEbIs/qOBROuICBg0Nhy5qY7Gf5BjB5lWlefMgIciXhQU09h+e+BKGhBTbw0aMAKyaMve+NKz7HKuxWxWK9VtiFhd9gLNf4j6o9R9uQad1oNoHEyaeKazlGCChwrg1tohCt3bxEvJ1Z4zhji65J1X4v06SJiIeLnXe/lOYuv8mdGCcSIOWyVeZANRoUcxktZyh2N4KqDLZR8JJ+hEKG1oTrxVqO6q8ziBCfrfNBau0/LY30ZbkstHvqpMMYWyOdZucLa60qCd7zSt7n/idA95ts9qbb5xw4sSb9ZL5h/81NZkSZcqjfRicEAXYPm8BqfUqEkragh1sGB/GpHX+EGdTxeSAgMnTqntIkAMoJuEIYGH99Yh9ITVdcbmVQeEbDl5kRXVYij7EWGpOCxt30Dpw09+8ajW5DVtnOpY2fWsX+sF+2UOxXSvnBLKpTCfVfTVHDfOWrF1emF2hcTu12cinyYmhP0qiEcSmK3UT5GWMsyHUWihAmBcdXDmatXE7fTZZ8ajanHG8yE6BPX4xLbRpOx6tng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(366004)(39830400003)(136003)(396003)(346002)(52116002)(6506007)(186003)(6512007)(6666004)(26005)(1076003)(2616005)(2906002)(83380400001)(5660300002)(44832011)(4744005)(8936002)(54906003)(508600001)(6486002)(66946007)(316002)(66476007)(66556008)(8676002)(4326008)(38100700002)(38350700002)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dHKtitlSNKe4L5zR1CQNRzdg5vwk5DoBPX6fRL1zJMoB5KIeTU17H27N+B9q?=
 =?us-ascii?Q?HwtTY8ZSSthhwSeupNM7UxdC+WtZQC1Nzx+QzwkNlSniJ3kOiNqRJbrOGh73?=
 =?us-ascii?Q?UG02m2dj5MimXdzL34U78xPm8eHKpZLp4Nr5o6TiFV5XH/sBnPzyPeGo8zUO?=
 =?us-ascii?Q?Do53S0p+G5UX1eWgznlseJTqmWDsaf1GmyzWBPSzACm4A1hpfQhOJO/P5YLP?=
 =?us-ascii?Q?KO9BO0283HroZH/amb9dGd6X4ObSSFpWIuzzIGBOGhw3pnRjNtQ0M7A6TRib?=
 =?us-ascii?Q?o9NhzZQzhVGo0NzqEKSGqrORUQY/pIg52EpW3R1NqfC9zOx/+v4rtWyb/rIf?=
 =?us-ascii?Q?oDBo1JizJr71KiC/+gH+dGnBBYwUTOA51LHPTthJcTtYo5SmfFqTNr4eHh9u?=
 =?us-ascii?Q?+K4npgM35uv59uwG8JKpFUpX6be9zGqRr6lDCZlGiZI9XCjCdvY6Zz4Phqcm?=
 =?us-ascii?Q?z0JI1Kdvy9kmoYzFxxixtISuXSU3+JnvwAnfXNt0F5z+2D9NXMPY71+NYiXd?=
 =?us-ascii?Q?4VQEPkp3oUFKiP1BkSsHYfRHCcAgGDEnavv4FIBKHrv+oh+CK54pH6+KJkSE?=
 =?us-ascii?Q?zT7GaUwljQYjtDHUbTpgXsjByWwwhYp38ZsIL0SSAJNZLpbPQR4PZQQsAgrO?=
 =?us-ascii?Q?xbzEA3M375hk6sqCrXy0XSxItsbFuqj364RcuWYj/TgDDBFlaS4zhM1sadPc?=
 =?us-ascii?Q?fuRt/EE7XWYikxpLCP7aTzfUo13PtikzN7wa4SyBJ26vwjuPrNqQVMyiDIke?=
 =?us-ascii?Q?PmKfO+OEJGl2GqBDVLP+Lb/6K5Kerm8EZMP5ouBs6xvxoCzw7WaG7GaxxLnl?=
 =?us-ascii?Q?lop2H6dhJa3a9szm+A9mC2TNp6oLgnORNgysWgDiBbuOg9NIDd5xO0ogluMX?=
 =?us-ascii?Q?goaV88EogjMGQv3ao9zmnvSSzps754rKC7lupt/Xp8K/H3TUg2AI1etTqdLx?=
 =?us-ascii?Q?iBYEKn8FbjkHhWk9u74Zn87Ti7sWdJBOyPoG46XKCL8Pvcs6KZTaZKRCDnjv?=
 =?us-ascii?Q?i1t8KojNagDTN0mCoBLWo3lQRrMjfoFnAzEPtaKLaO/Xx65lE587Vnd3zulO?=
 =?us-ascii?Q?9LHYDUmmAY3AViLC/YbkDNML/4QluIHsNfBAN+aUkmVyjnPmtdpQyB44foDG?=
 =?us-ascii?Q?nyBx/EfIWSVMMhZlusKmx+eXT8f/86bGiMGYgiBwToLvMZqAUOjHma526Ywf?=
 =?us-ascii?Q?hC4kNIy25o6YhbsaxZI6W5QYq3JrZlDIW7jQuXrHRSwgY8Ns+4VS39LEKz7i?=
 =?us-ascii?Q?h69i4nb/r9MyzIYNr3NXzrx7c8KOsIBKdy0sfJUGKjowQrqqI9QOHWLmPqjt?=
 =?us-ascii?Q?/Vomw+feYIHqMP0AiH7D9QSWAJTOpeBcyJppZWMZmKdBNGEDkjLAxRrpteNH?=
 =?us-ascii?Q?x9LQj0OoZGFXmv5zXU34foG4qDpZb2qQfqtMYCWGTjIphINSIeNXtKOb/hjt?=
 =?us-ascii?Q?kVQYPdo+jLRzG8MFiq5SnkcKHOgM+EeyY9ohn+3G1YwkLYtIZ5dO9H8toFm7?=
 =?us-ascii?Q?lG5sfF4ayaqGhQIkP9Ydq8di03sm6jFNNZD8srO4j/Suaf2IcbBlo5Bg65qw?=
 =?us-ascii?Q?qHoYDINk90CdKk/X35hWs2qNGypB8vO2+MmlnzU1SughmBa8DG6gqUTdig8p?=
 =?us-ascii?Q?MQDpZ7zy6ZECt5Qdx1TZUuWhQrUUkiNci2Npbibgs1gEHc/vdsbtxWGfjlD4?=
 =?us-ascii?Q?A2c7ubFxkxnMLJKZq0Li0y5W/PYr3NSZKZMpVmMwmPXJ3HLGQo1OPzIjBP70?=
 =?us-ascii?Q?hbLoI5nBfswyH6fWS8kI8KXJfAPN9xRrCnJJ+9Z/ZS0q9XmDA3UF?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 005ddeb9-e8dd-49bd-75d4-08da2b007687
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2022 23:23:41.7117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6FUjgTDZOupD84Vdz4ai6SGjjG5S5i4b0ISPwkrXM+gaZ3OYN6QoWEgV6tii52Mqz8vTccgocRxxcQFOFv+g5VnUJnMoDZdOXxx0GoeZhyw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4802
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A couple of pick-ups after f187bfa6f35 ("net: ethernet: ocelot: remove
the need for num_stats initializer") - one addresses a warning
patchwork flagged about operator precedence when using macro arguments.
The other is a reduction of unnecessary memory allocation.

Colin Foster (2):
  net: mscc: ocelot: remove unnecessary variable
  net: mscc: ocelot: add missed parentheses around macro argument

 include/soc/mscc/ocelot.h | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

-- 
2.25.1

