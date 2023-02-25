Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE936A29F1
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 14:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjBYNIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 08:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBYNIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 08:08:53 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2121.outbound.protection.outlook.com [40.107.223.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AFCF759
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 05:08:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTKLapWrLj6vblgV3a4rvIp8H+VwHOsRc0XQy/xYgPXA7zdGJyxpv6oxevKf6eu/D1zsD+gyQATIJ+hjkzHsbxn2LRkAx530at61YOjgIF6rzqkeulyDaD5EwQuE0aZTc2gek6AyQAP2IbqqKsSd2Th4tuOZS5vHR0qG5L6VqLm7Fpl7kqgcSk/D1hgzULoOmzQeyPNLG/2MkBcKE1S2Dk4B323jc0+ScCLJsHpI6+hvVuXTZPQtY9c9Upj6q6MSmMUk81OfElkpbnWxhfjP0bdvRkkqEPU5Ptalb+5WWgRNUOxbLbEFoiG8VM0F+b0DXIli7bG+fkVKJltpmP5jUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OrBXqny0o5FqXsv4EetOx8X53kMzrkgDPyObhEtuop8=;
 b=ieq60H4mZhW2rbuaPebH+yYJxQyPWtrHNc9i1iGWHpvvBSzKaeNU1AQKw7HFEzeXpMzAeIDmEXAyjEXCu2tTa2MEmXKJ9JiyIG5kHCQb9ASenbHoyhDqOwtQ8fHT73dZ+xLqdk5NBqEcFXjopOBY48ovShm2Imhb2qeXfpfC+V+dc2JmNRfU9DND+vi41Jd3CBHcMM2alcO5wrhqlkTpCPBvTPDVgJQcH1ujNiR2aD2zr/iUvQwsw54S8ABSoRAB7iojbXSHF9J7pzFyUSf3sp8PVtPa5mZbxKjEvhe+EaBCPJ1t4BTGYzULBB83TUSePvzFyBDvLLDn0t7bKL51JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrBXqny0o5FqXsv4EetOx8X53kMzrkgDPyObhEtuop8=;
 b=CHeeUdWJwMVUDgcd8RwlzGwn5lUX6KxFlggyc9cuHXL1+JnO10vJbyFHVjTkHmZRYMg4/48PrJGO3o1l7UNiCkJ1IxkTp1H8ddu35sGwdxhvHab9R9UFrtRXUcyJl/eB+tqnQ1jW/ziDzYHxQASpmlNxTWqzivyG8zBs643OT9k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4580.namprd13.prod.outlook.com (2603:10b6:208:326::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 13:08:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 13:08:48 +0000
Date:   Sat, 25 Feb 2023 14:08:40 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, amir@vadai.me,
        dcaratti@redhat.com, willemb@google.com,
        simon.horman@netronome.com, john.hurley@netronome.com,
        yotamg@mellanox.com, ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net 1/3] net/sched: act_pedit: fix action bind logic
Message-ID: <Y/oIWNU5ryYmPPO1@corigine.com>
References: <20230224150058.149505-1-pctammela@mojatatu.com>
 <20230224150058.149505-2-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224150058.149505-2-pctammela@mojatatu.com>
X-ClientProxiedBy: AM4PR0101CA0046.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4580:EE_
X-MS-Office365-Filtering-Correlation-Id: 58e425ed-9728-4d2b-9668-08db17316e67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4gkZcC2u1QXwGDI5GlbZ8Uz/8kgfAQkE6o2TWWcZ9NJhmf0SA4BB8jg03Gb4GyaNssLISamoIBbIzYdJlx5zg/4YZHLBdrqnaOJsSstiRcwbOUSxcaMJtPvkNHCi9Ma0cemsemMm3tHW8tQIKHQGwSJC3EbwHNWpiSK/Aq/P3xvvzXT3LPwNmygdx8bRpQ46iPkYRn2+moBBVCsHd0KW+wh1RzKsCZ3f7p8GEYmZO3jmoulqGOtFqZln4KqUC9BhlhmXvfScWkiejYsqX8R6MGIEys3Q6MRnl1onzBJANxRjxujfF17D/me3N566HbmzHhaZKERcvVshg4fHS3D7w7ggbThGf6FKa8tOqYHA7u70kPQ3ZeiZk8Jn2cqw7cgS8X4UFmA4P/5QvY0iyIArFEqcjI1mOmhO9g8k7zJbbs8RMQpn3ibeZGg6SiZyU00LwKwUdqkI9ebEqKGNiGmcs3X50rbj0RqRDnN7sMNkFFc+F/vqsS6WiNhBEcqeFA10Vrw+cgv7lWs/BvBXnkApbjjRv97UkL0oopcxjUgKWgokYC0mW55Mao0596SJEsiLZZ6LQt99476Gmo1HaM9Gm2/2klL7M7y+Qt0lZEzEsDdBsQteBhccEbtiLzoET1X6NzcnrKKWktHu/AOL0/6C5e61BqZWlTkIoOGRXrCLLx373o71TW6jhabI7Bn85Ahw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39830400003)(136003)(366004)(376002)(346002)(451199018)(86362001)(36756003)(4326008)(41300700001)(6916009)(8936002)(66556008)(8676002)(478600001)(66946007)(66476007)(316002)(5660300002)(44832011)(2906002)(7416002)(83380400001)(38100700002)(6506007)(6512007)(186003)(6486002)(2616005)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yi9VT8BWv9XfH5EV17tBmCXmjKd2gU8PoXsK4zJQv5zRw6k/x0CPQ4SNSZl3?=
 =?us-ascii?Q?N7NzSAKz+56NnZyUJ2tnD29VOuWRO/gGjKKmCv7lChrnmKCdtxsWtUdp3tLk?=
 =?us-ascii?Q?STYf7Z8HcvlGiL8LLgfG9afZUU+qJwjbSGdL+CrCZmquOs4sUYBdqzzh0CpO?=
 =?us-ascii?Q?Wh5oH8Oeic2egPhLnB8pgki50o+Rpy0IX6w4hYtIStrznzCoxNRn23Z+Eyn6?=
 =?us-ascii?Q?cUCRC7lAhyJYVS0vvrOSapmS/sOWrxExCwXGGN3bOpIW1C/vizWryVw/CrkZ?=
 =?us-ascii?Q?C9JvusdD1ie10UhLr97BvPS4CT7GkObKJr87Oi88Jeuhta1oJn7O1HGbpkTJ?=
 =?us-ascii?Q?YWhlFpJ//gjTjYVHPt//I16lcnuRQso5j1NioMlk0heMm4wyaNX5JF9thWbz?=
 =?us-ascii?Q?T3oa36OMFVNOUX+d4sVj/ibkoZdvdLJMlbN6Dpbk9KgOJrA+t3Excy9LyUL4?=
 =?us-ascii?Q?/FpMfBqlmjGyadBmTZiAy9nkNOhYY3TxDX9lJ0p+TuWIwW/9UZIx+a7nxXBp?=
 =?us-ascii?Q?tQ7YXkFzm+bgxP80c9QWS3f/Ohqj+mTYIiWjWxeMB5wLkq1+27alyj+ijz0J?=
 =?us-ascii?Q?UhLJ8xxmYBuxVUmYwf8B1gLunbXGC1sFlfztxsTgoPNn3BX/o9mNErv+GSY+?=
 =?us-ascii?Q?bYH0FUKCOw/FxuYuML8VkWLPb+igG6kR0h9v2up0nnF28IZlhkKxVWVUyKkq?=
 =?us-ascii?Q?oRPsRhuUeGUHZIsYmPAS4tjAuIEhCdGVnwCAfjKB5tmM5+XnY7iB1WWIg4jq?=
 =?us-ascii?Q?m20FLIIiKZHSYX9GWyDfSQC6z5jwsJd+iD8/IuXCudVVp1leEnFnCxxExJLO?=
 =?us-ascii?Q?7wBty+o18m8piGozcObyylDV+VJeXgMBstIFKZbFoHq8uUNOvQPHevqABtwL?=
 =?us-ascii?Q?p15z+TB8qLvOi7RTCX9ZemwEwN7nyGek6yjvI8Ti+vmdNlz4rq9CtrDdg1pB?=
 =?us-ascii?Q?T+drzP6CMdZRUAu1S/3j3/wVQOdzjIVHxrTo6kDzkZ9SXGobaCJXrbdhOe5F?=
 =?us-ascii?Q?sgvXiCZcCH6Fwt8+3YN3bhqIyFbqV3hqfaYD7ixeZMPZj8apjKGoztTeHsGr?=
 =?us-ascii?Q?1SFIiWqDxhBs+62VvJ8FA9aagS7VjWxrFmlPtulKERfMNRldckp8tzgmbR53?=
 =?us-ascii?Q?WXtmP6cEPfHj4W/p2uw04hJA06te9NJj7TtTq+06x9oPSwXrSpxhIUif1rH/?=
 =?us-ascii?Q?0hLvKj/ADRat8b5lqamXsJuqfOVU5wZXWMtXIGmcWpNLBgfKJ31B5eMxEFug?=
 =?us-ascii?Q?nTqVZKRnBe8N+Vs5H7kqzHbmDer1ltjKXsR+dHkeaKzPkOXyoVt+ZDvclF6R?=
 =?us-ascii?Q?nUmQI+oVfPaBSFxueEHRMyrk4CsCHJEZTdSELFHsQ52fykIl8zuVMxuinaNa?=
 =?us-ascii?Q?yBMDXdjrQJSQNeGQEjjLFvpedEpNkSLEowrXN/edyn8aShRre1R2sjmhbtw8?=
 =?us-ascii?Q?yUONme/phf2kGUZfd3OIGSyNGtks1GOlBrI8mLdqJDwO3TsHnIwVqEV3zi6a?=
 =?us-ascii?Q?oJ4KfyWIS7GvfZ0R89FO3zeljYd6wxpxD3rNrkr5EvyT9isxv1nFjIRFAaXF?=
 =?us-ascii?Q?MQjMre/Wc6uHlQcL479xoS5DXn8ZSD9aqa/dAze6TAh7+vLb8kK1fWp9LYzg?=
 =?us-ascii?Q?76MOwplMFtDweyl226qYHw8cD7+zGBNa7HvuFKjqjTcUvdroZhqigFF21DTC?=
 =?us-ascii?Q?UVid9A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58e425ed-9728-4d2b-9668-08db17316e67
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 13:08:47.9925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWsca4WO3Qds3WNfOYVVRJkHlClKG3yCYnBTOmZ8BT/7GPAYFyFgUuZD2tGdz6WPZtRGqeiOx5duar4LEsryvLi8l43zApy1XYnsTbsvWIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4580
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 12:00:56PM -0300, Pedro Tammela wrote:
> The TC architecture allows filters and actions to be created independently.
> In filters the user can reference action objects using:
> tc action add action pedit ... index 1
> tc filter add ... action pedit index 1
> 
> In the current code for act_pedit this is broken as it checks netlink
> attributes for create/update before actually checking if we are binding to an
> existing action.
> 
> tdc results:
> 1..69

...

Hi Pedro,

Thanks for running the tests :)

I think this patch looks good - though I am still digesting it.
But I do wonder if you considered adding a test for this condition.

Also, what is the failure mode?

If it is that user's can't bind actions to filters,  but the kernel behaves
correctly with configurations it accepts. If so, then perhaps this is more
of a feature than a fix. OTOH, perhaps it's a regression wrt the oldest of
the two patches references below.

I've haven't looked at the other patches in this series yet.
But I expect my comments apply to them too.

> Fixes: 71d0ed7079df ("net/act_pedit: Support using offset relative to the conventional network headers")
> Fixes: f67169fef8db ("net/sched: act_pedit: fix WARN() in the traffic path")
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

...
