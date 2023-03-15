Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF3D6BB898
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbjCOPxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbjCOPxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:53:18 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635C6746E7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:52:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVsxDyIV5BeoR9cluSDBy7lUdZ+fLrSouizw30EJnEkKmdwMS+MNaXwnv3/+LnVB9mdbifYpjPSGvvuT1Iv3cgmqhNOKWPCKat8epJwyS+RP5sv7affFOnXaoIPRoqbJaxUWQdVz1EPgQJlStoKHQJGCvNiS0sFdb+XBgQSS9SP29w5ut1Mwl4zeJzb6FYEu8lQpFD/jvbrD7qiL1SB1d07H425QCvZGnt0WReLnlIB1dWOHbrh0J3cRtl/jJnZaWBEgXeUc3MlKOtvK+SDwvDuMGDNKnwERsoF+0o+Zy+HZlIfO3DGl9CjN4cayqewkJNETPjckLpHFwxK6GfJ4dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wlsVz3pt1G+sEuUvXPF1INCVSYb8C20qDpzeaBFRH/s=;
 b=oJriMzuHVCsV/oN3LlpMVMtJnNsy7S+n+2joI7rqy1mH5ceQl/+2iRC1WK+jsYi/MSxFhgAIaURxTBu5Q3WY2WGXvz4YbEnHVZhWFWfdicvBDZUfQBzftyoNpYqsQYc4DHZx7IOZbIFHOY4nqWHY9nuMUXPlQDyI6FpFO9Pe0tsGH+q1tFR8mUMWiRhkaCkuYxNWDm+CA8JXT/2BJ1Py/qQacvd3VhGe6n5BpkYsyu6VEUZZsYx+0rPu23H28xHco7N22ti/2r8AawO0qGLTJqlnheSU9+0Zh64095l4mg9dn3jHys4uVYyxXHtoDccAJlK1FA24sbfkdbTqFv2Qmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlsVz3pt1G+sEuUvXPF1INCVSYb8C20qDpzeaBFRH/s=;
 b=JWmXlD7svXRAfLvp/KaDQ41HLPsG6FzIjC3iemls39f2F4xlhdZAFHvCR2nxEgxGBzrAENriDOUwl5G4EHQq+Hf9qGhc+IYiR7FYpYYA7DGOjhvq/b9jdoZdb6y3y22DYIZyxrQq+Ngb4e64UZFG8KmwlnwnCDelbnXdr/f4pSs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4980.namprd13.prod.outlook.com (2603:10b6:a03:362::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 15:52:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 15:52:44 +0000
Date:   Wed, 15 Mar 2023 16:52:38 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v2 2/4] net/sched: act_pedit: check static
 offsets a priori
Message-ID: <ZBHpxkSdQ4SKNqN8@corigine.com>
References: <20230314202448.603841-1-pctammela@mojatatu.com>
 <20230314202448.603841-3-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314202448.603841-3-pctammela@mojatatu.com>
X-ClientProxiedBy: AM0PR01CA0165.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4980:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a44eaa0-e568-41d3-2856-08db256d511b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cucdy/wDaqnve65YCZVHXFMu9bjl9RA/xl7v81intEJ9I0wf2bkoReBHxSflqwWRdYlFKMene5kV+2AL+/LGX+hNQ0O9slDGBDNpWEJer+vU/wySFRS8Z74+1jPqaLejiCYSJUCTRgjZLd4d8krLkAJPD977yN3kyTbwuoJrrAPThGlKcDeVSZpbObdMvYDd8ok4JPNv2r8Wc1F/x0fM+XTGLDT6j6NG8wm3rOoufFHu19yP5DltWmHFkme+rBIPvKwZjjjpZvK0uB2lP8NJAxSBynBceGaiZbjgwxI276W+LFq3laNFRmwD77ruu2fMG7GOtRyEow1agJpXdWw+DF5zwIkt/Ox6LEKNYAIe21zZoMhnS0kQ6UVlbAykrZUHzSKajoiOLmzEp7wWJt1cUqOIu91aKcvH2XzLzLn2AD3iboWKS1uJRU1CzdO2xIiAS/iPqjG3wtrD7eVPC+Iqk0W70eEx5fhA6p8R7+4vxjUq7tkvqaALaLh3R1Aujciy/qSVOxm7MNj3f8ZQSQjytXtMmjnwUNPBxldHpt6oMos8czeSS+UDH1AYzGtOvhIri9uSPMH96W9r02ZiUkOLh6+t5MVVGMtw97zLROG6PKcy/jPYdMjVCS+UQoqjcAtZGaSw2h3iMdQJv5lkpMEQeXEckuukEiOyiwMUhc/fwLJcamqEL9/aFyBWlDmMxjSk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(39840400004)(376002)(346002)(451199018)(66476007)(66556008)(4326008)(6506007)(86362001)(6916009)(66946007)(41300700001)(2906002)(8676002)(44832011)(8936002)(4744005)(6666004)(38100700002)(5660300002)(36756003)(6486002)(6512007)(83380400001)(2616005)(186003)(316002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GLKb4q02dDacX81ZqJutzcBYQxj2zEPbDawhWGePU1+gZ2zV15Th8u1hpRKe?=
 =?us-ascii?Q?JK5wZEWasUUMBGCW/SOJj6oSoA6xxLUOXhvG94Z4PBKVwtHbNv2WCK2eUbHT?=
 =?us-ascii?Q?JbDy7gE9CLhlYwJV+doj07dIhF+ZusA1zdQA9t/RKNy9F3Ji28pHjvklM6nz?=
 =?us-ascii?Q?d/31RGppYtBqf2JhotAo79VTrv7dIKBu20kM9UMeQiki+gwr90oIduC4NGi/?=
 =?us-ascii?Q?FVaDDqShJD/s7NV6hQ+Mqa09ThOo6HEZqjJedRizy/s4I8OoL0FmFgI6UkXC?=
 =?us-ascii?Q?zRAbUZjpNb+5+6U1oIRD1tEaNY3SZlmzN19ycZKlDTuISBjEX5H5nDkZrZTe?=
 =?us-ascii?Q?0rCoBrNyHMai8kbfknzwOi9vouDrF3eqiZkDF/YsLdwMzbRql9XLz+E0H6GS?=
 =?us-ascii?Q?D8oYSBduX/eHkFBvTk2vz0qJdYOQTqfQbUaI2aIxDbWUlpLsPMvk/FODptvq?=
 =?us-ascii?Q?5ptOIEtGwbthKJ+pArvy4/VOfv50lUrpiLvcD783d7op0WU7Cg4BsjN8YPyA?=
 =?us-ascii?Q?YpJoCivjPSXtlGwbvDsdYGT6nG4LoSBUcPCopdQZsXwvFjVXWR3x9ldbQ59i?=
 =?us-ascii?Q?s4otjjJercTFe9md6szQxnEcCMpek4Yyr5bd8PABnWDx1t2sOzhfw5FaD8Pm?=
 =?us-ascii?Q?KsByIy/Dnxgu+wyKITkE7BzBcTMhZzg/kgCw2Suui7qrVCos6U5dK/SD7Z9v?=
 =?us-ascii?Q?sfvV0gm8qJvZC037QAA49XCF1fsn5yhw05Nz9RTs+a5tc5Y5I97LvTvMydk/?=
 =?us-ascii?Q?mQr0qDYpYSNz6xMMgnAB/GU7/6m3qyC2JUCYIAjCDzWRUgA+cJ6iiqHnF0PN?=
 =?us-ascii?Q?pADcX1H6W/DK17D2kEB7qOkdcYk6CqHmxRs/RqoO91kouoeCARcQV3RrBlGl?=
 =?us-ascii?Q?TuLSvJCM5wz1kGOSdj0dvphfF6o1o7ii+KqdKhfOP13OnTMnTnb7LIUQilqZ?=
 =?us-ascii?Q?du8hHt9qr06loXyjwi0KWhfe5R4UVqOOmV99aDhrda4Usi/jyYtnILtDNns5?=
 =?us-ascii?Q?9Ceu/UwXFWMGN20Kx4jwuDn37F8fxs2e8RxAsyUrbBpToZMqVC5W2Au1Y+Y1?=
 =?us-ascii?Q?Hjx8yBU2bsGlEHkVY7TQOFfDdf91oqriYQK7ju6PtdA9dmq2EKHgWm4dZLvg?=
 =?us-ascii?Q?gkENGeG62ZCBiav8DbmBYiBka06/3p1TYUkg2oapaPrNUE3S006PoECUJpCq?=
 =?us-ascii?Q?mNVMBHrh1HYg1ma6bxttndvKEu0KVBBTLuCxyxnSwcAnwAMJ5GlZyEe0TerC?=
 =?us-ascii?Q?ZNMXihigODxYhkHo+BQjO1015+inZ7g5h3c3jPztPhntOuYpmUzr4HunC6/Z?=
 =?us-ascii?Q?cxdeaqOjRaa4x5tcdQ0l4fUNvQaI11xnyi6HBh5Zp27NlmbeFIgWFBemAN/g?=
 =?us-ascii?Q?rOkkJ58T4ClWrDpJ0527hH22TYfzmHkmEhTsf6lx3RjH9EjH1C+Ufsfthe73?=
 =?us-ascii?Q?bDqCqoKz86UWV2k9lHoV+wSV0Cv70X+2ew326nq+gXe6G/0+yk8UBkGwA21I?=
 =?us-ascii?Q?SV/kx6eCq9u5CHboYdwVhaU9V+CW4zJu0peIArHnNRSTGGiO7XKbPm0q9AvI?=
 =?us-ascii?Q?n7T0pmwo5NMobIczlr+s+E2o8czXr6CUKCaL1qA1ZZDVY2FpwlrYYnU/9oW2?=
 =?us-ascii?Q?HWgXpiASbiV6CcYZiFoPiWcXoZdXdJys+sssvHSHNp97cPe6h7ooCJQf+Juk?=
 =?us-ascii?Q?0s7A1w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a44eaa0-e568-41d3-2856-08db256d511b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 15:52:44.7016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VMgTROg/qDaTcxKe8SiJVDmfjUCTkqRvdRH3ijI1Hq/Jyl7JZ977Ig5QwnQO4zwc8HEqM0IvinfH4uV+vZ1RBhjrmqX2YaBF6hyqJYBFP+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4980
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:24:46PM -0300, Pedro Tammela wrote:
> Static key offsets should always be on 32 bit boundaries. Validate them on
> create/update time for static offsets and move the datapath validation
> for runtime offsets only.
> 
> iproute2 already errors out if a given offset and data size cannot be packed
> to a 32 bit boundary. This change will make sure users which create/update pedit
> instances directly via netlink also error out, instead of finding out
> when packets are traversing.
> 
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

