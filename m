Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E55A6E009A
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjDLVRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjDLVRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:17:10 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021027.outbound.protection.outlook.com [52.101.57.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678C3769F;
        Wed, 12 Apr 2023 14:17:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EprBzDM3u4NB0odZzbudJGaJb4Q5lx1h1P0cREuUNdZug71mWAZhZnqWensk1YgmHedM0Skm7u40qmnXEmrnYtzGGpJNus+rlqZFD91/ItvLfFt2sWYWq/CVFZmpwAqpAeUx/36LQPnl8wK5d1ijJn+siHstPJzLkTuBG+wDG7mLfM785cT/ZPc4ipWloxw9WW1/DALugAL83RCiSBZooH5ynQuv2j05Xkx1Ho3gRBoxeL0Oo+JYJkLwSJr7iSG8grdvG2rvseaJGeDCZwqBWkbxIIljYd+Rz0EhfO4pD2oUhqGbc0xx+Xc47aI7ZmG9+rEjP++YbOBUp0GZXAoijA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kimHZ+QVn8EUGXrew2ON/+slxYbjAUAYjKQBPn6+Uek=;
 b=ZaO35SppPvTjjSdZEKHx0hG4FD2sSMpVO8Lg4aArU4X5lTCruEbleooeE6qQowAxPHeqwt3JIUQPxwi69iWuOCMexyzk4sHg4MgunattYNkaaIeVcM59Tn0fFLPkfIx2CtLMiCvpNzwyn196WkvhiZQtYPNFByxTbfh5oJixoXaFQmxapbewv6L4czblRdaB4fX4Fz9r1YI6jH0b6ByRn+OslgjHt/Iaahw6JFLGw/+IrtFUBjawHEg6sNG+dqrXtQeofakzrBshY+EGx7HQ/w3PUBD5JQ5v1FdDF+80JHxo2/Ju3ZB/7BOIjeOplQzZNN+k4UMag0ps8KY/S7NydA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kimHZ+QVn8EUGXrew2ON/+slxYbjAUAYjKQBPn6+Uek=;
 b=b+pO7WFFYw31o5p+WTPLICm948OhFrSBgwcPaYaHOpYu3++8IDfMikVkfSgo/pqWTJ0DDo2+0TD1o+2Uiln5Efx95tSri/wpmbdbmzq56aDKGJHYnQHwSgteerxJTQN07qsYxbXD7eBuHHuL9c7c5G+nSua8wqrQ3h9wGPASKxA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by SA0PR21MB1881.namprd21.prod.outlook.com (2603:10b6:806:e6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.4; Wed, 12 Apr
 2023 21:16:49 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968%6]) with mapi id 15.20.6319.004; Wed, 12 Apr 2023
 21:16:48 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, wei.liu@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
        longli@microsoft.com, ssengar@linux.microsoft.com,
        linux-rdma@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        sharmaajay@microsoft.com, hawk@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3,net-next, 0/4] net: mana: Add support for jumbo frame
Date:   Wed, 12 Apr 2023 14:15:59 -0700
Message-Id: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0002.namprd16.prod.outlook.com (2603:10b6:907::15)
 To BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|SA0PR21MB1881:EE_
X-MS-Office365-Filtering-Correlation-Id: cd26d9b7-3c14-4480-972e-08db3b9b3a13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6czPxJDQOKSHAwFi1HuV9e+rMj0ed4TAVd7umaOYvRW9U3mqphdSOhJd6uhaDE3wPOL0txg3ie9xUg+roNGiLURPXr/ZcB/0eNsjzRSR6/7Fr2IdnN9ff6W5g8cRSqW5M1ynqgVQiYZ45xTKcJVXLa9DZowyduCWTu5BqVAJ7r2X81IctgvzlAHsR2oCbiHSwajskOnLLaStSftWIBJJSTZMGeKvHydHxyGJllUx/SkT7TtzLk5UN8X/qm4itbR31LjiULb7QmgC/pTG71Yq2IIURqgJjLGxuoC4fL59qw5Da7UyJoAe4T7u2fekU5cPcKnSWwAxFo8hG2/Nn9ka6sRH2+G/LAzTSGUkCVW7bbfeGZjOGKZLobDawLxWIEOs9hfI3B1wS7LKiQ9TdFa57gW3zmkMH1NAbIMgIPIIfoZDyPnG6lcH8caiFyqoH84AA4c5OjyhWUaoOsBPTU9/TY4cnQ+z5UQ7nFg1ayLehzbG0LrH5VCrHBdxcU+3CpqZOu6mlFqgKLHHsNb2fp7phKf/e4gS1mTUHH04LwuYnL/hMOXsEHwED8lwceFvcmZydH0VuMNtGAOHDFRmOdTqrl9MewDQS2btx+3HfWMxaOBitkAoM4hwl1v758hswNNr5Q41znOYEayYqdRBvIYu7bydHjC57QD7oeT8tnu8CEI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(451199021)(8676002)(38350700002)(38100700002)(2616005)(83380400001)(7846003)(186003)(478600001)(52116002)(10290500003)(6486002)(6666004)(316002)(26005)(6506007)(6512007)(2906002)(4744005)(5660300002)(7416002)(36756003)(4326008)(82950400001)(66476007)(66946007)(82960400001)(41300700001)(66556008)(786003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mFNkkozCWyB8i+yA3EpX8K6M2pxq8OuY1v5dI8JJVGhLxLqb2+SUOmTERf5A?=
 =?us-ascii?Q?1mvB92LH0QdsDArO5RT0rYuCaqbWlGcRLbyduTbGRyqZy0WbLyum5YCY+1uk?=
 =?us-ascii?Q?vgVyuKB2Auq7VUl+Kmd7D4Qn4leNJFhyGl+miL/uQma1yw2v9TXK7sCxl9iP?=
 =?us-ascii?Q?9V97G9Lq1wjhrZVpYUFBA7kbZw6BMgcUnD7X7lORRWXw7JQTV1Vr1d7FC88J?=
 =?us-ascii?Q?2wAB6Z6B6jocUfIDEdgTqnUc1vvPjUr/3qM6e9pq2nj/TXaZh0B4hLz/HGJF?=
 =?us-ascii?Q?e69/mnP526B121aIKTcgBi5k1IxXKN/evHsr666n2zBmpzvn4yBsWofJT5HW?=
 =?us-ascii?Q?cf5qwbf8fGAt0bYbeo2PbhyuCFZwGdh/gRL0hQS6yZtfzUwusZzGcgWYURyB?=
 =?us-ascii?Q?wXyx0X9AS39M4v/MtFgBY4Kx+h7Bjabsjf54OD+kFhSjgdJmu7zTbqv2y6UL?=
 =?us-ascii?Q?ADbDhuoBWw+1Vx87Z3vw4ZYFwnYeKJLj0fgA2/RuVnFl3odayF8WpsyeH6p9?=
 =?us-ascii?Q?rIyGxJNQYwDjTvWYuNUf+S6lR4TLrbBcDkTWYtODDVjkXD75OFH+qq9p7xMS?=
 =?us-ascii?Q?HMnU7Rxsr9YeZJY9mjCObIS5dIEQSb+MD1bOK6kuhzx2dNbk5YvI1giOEWFU?=
 =?us-ascii?Q?130OM2pX9/ZCQkt3w6+iKxhLc5NiGdRE4yJ6sR2K+L7il60NDTtVImG1LSld?=
 =?us-ascii?Q?DwU3atniViGAS7HP1v1XPmhqUGTYmx4Ob0KvOsrUYoHu5PPmfmfMSjkCgSQW?=
 =?us-ascii?Q?rN3xbssDrB3yGPoSzh/HPzZgVv7jM6r8e1TF/kteGF4Nbpx+ftssO9HvA0NH?=
 =?us-ascii?Q?jIWFixuBTYIqp6jYY4A9vLL83ogd4pZz+ANk5/7NZK84FYi/DRjx0W1CeyBL?=
 =?us-ascii?Q?1j8JilSL8WNOXqUSZAhaKmfxc5K+aB/31uhDv+bbHbtO9OAGAAIiugWkUgCF?=
 =?us-ascii?Q?vwGv77UojCE6PJDJQv5iO+gTocCtmztrLFNVT9HN0hdaeZZ5ME/7ErpS5RHc?=
 =?us-ascii?Q?ViPcnKapQNoU5eLzo6wO4vjNuDbk0xPwKS2RfMxHBr41LqhEqJROnFGGsni+?=
 =?us-ascii?Q?VnB7JSYh6pjkg1qtvH1C1+Ka8VGRyaZH52cAA8Ko2ZgHraq3z0mnBMSMdptu?=
 =?us-ascii?Q?iThsJz1eTLBaKP85yAO9eXkQZLbZWVge7uuU5vG51f/4iUnuF/FjCXYps8bI?=
 =?us-ascii?Q?s/Ji9XJRH+Z9M7F1b8nD8mfNJfLox/CKbqlnRp9vpppstIiCcmpz4kIFsJJB?=
 =?us-ascii?Q?KFxrnewy6IxWWoLegi4LSfiI1YmTIGZzHYhbawXpPXHFjzrEk8ikHnyzeGsv?=
 =?us-ascii?Q?cDB0wAkszx8V6BEIyDXh5xIWagQL+6thAgh+2Yvapq3MP6Xp/uZaKIWQQbYV?=
 =?us-ascii?Q?wZefw9Gv6rUZ+fc6Gq7917PYQwlF3I7qb4NEuDnz4vhYH/TA76wVbUB+wqRd?=
 =?us-ascii?Q?ao+5LX3lhs8akMFaCyGBrKTQ2DI0r6q6Hmd8yniqPs0svctslhKE/Z0cD5BI?=
 =?us-ascii?Q?IiyH4mKn51LpUvh4j5+shnzxDRQPx9X+mdoZGhplWHh1s/FyAQSlgslYRz34?=
 =?us-ascii?Q?P1Soy3yZFNBF+d29iT44xjZcOMKj9EAb3NzJJeat?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd26d9b7-3c14-4480-972e-08db3b9b3a13
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 21:16:48.5984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uosgb0rlmWJEJMSd8A8aX6qJM3yJsmw4nxHgb05VOWL0EWcqI0MIzcmY4SY5APvGSwvTNzbqm9GcML8eefhyaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR21MB1881
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The set adds support for jumbo frame,
with some optimization for the RX path.


Haiyang Zhang (4):
  net: mana: Use napi_build_skb in RX path
  net: mana: Refactor RX buffer allocation code to prepare for various MTU
  net: mana: Enable RX path to handle various MTU sizes
  net: mana: Add support for jumbo frame

 .../net/ethernet/microsoft/mana/mana_bpf.c    |  22 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 383 ++++++++++++++----
 include/net/mana/gdma.h                       |   4 +
 include/net/mana/mana.h                       |  27 +-
 4 files changed, 346 insertions(+), 90 deletions(-)

-- 
2.25.1

