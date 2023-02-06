Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D42668B9D2
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjBFKTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjBFKTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:19:14 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E076E55B2;
        Mon,  6 Feb 2023 02:18:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bEuZco+C0tgRMLbxFdezlg2QvjwKOW/CKJ9puGrppEDU9U3P/rELIHOrj+T3u8+iBzP/QZtqgf7ZGSuEHNpjmx+bxMEXa0eMZeCVaWeZMTRHt8ob0SMLKSvmm/ZVLZfK5QXKNHv7a1kG/ykM1kq5IQ8NHTgDx1j/5a+gPwH047wLkDZPIikhlqxK+iNwkGGmef/Zzz+W9tlWYEkQrcu5OdMd9i1wcs7VSqMElnOEDkhxtgWcG4BviC4zKR7F77N+PhHEKbZnGZCnNwKbqRXle9RvNyySEY4+hcjC4s0X53cytd644vR1XF6ToGxY0g+WlG44tZ7DgCIfKQS0MKiHdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qcbToXedEk8nMg4tDAsg5PVSCZxyb615DAhOCYVOpAs=;
 b=N4Cl66HL9b9yXvkvJJb9uwv6lW1PQJy+6PGPLu7VMBWjiv/m8lhOCgYrczZG8MiYhlzVNof59h5tIIp8oYXEs48PV2GSoDKcsIELWwTugur/XfLKkjwzHF2XwHUvJQDc8ge1SoJFaJXZbIfTw0KnkYTIKg66c5kJYybD6UjUDyokHg6ejXYgfMqnSzX/XovfQmZ8G+McXq2VasPvl8u67ruqz9WwZvHikTs6C57us144HRHCISHkLQbYrKmmjJjqaYDK5UkG/62srtYnRnTfvQ0rJNxuhgtyCzMUqJ6w/3X4/IgHjoqswvam0UKA5CyMZHmwlTgFhTDcsp3kZ9VQ+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qcbToXedEk8nMg4tDAsg5PVSCZxyb615DAhOCYVOpAs=;
 b=YLNNS2l5RUwYKucepJ1TEtIM7L8F/3sLiHCePwsWYeCSgQfK0D8Km6n+KjCVzpXuhVG32fOIZzIU1LZ0Ak+IYK8wI4SBYJw7tHS9RxdvrljxgnfwuIisLFub+S6f/voquZKzy3pELk61R2DxyIuPzGfKpnrk8ynfsEgZ4FvjiLo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3800.namprd13.prod.outlook.com (2603:10b6:610:9c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 10:18:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:18:31 +0000
Date:   Mon, 6 Feb 2023 11:18:23 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Daniel.Machon@microchip.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Lars.Povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, richardcochran@gmail.com, casper.casan@gmail.com,
        Horatiu.Vultur@microchip.com, shangxiaojing@huawei.com,
        rmk+kernel@armlinux.org.uk, nhuck@google.com, error27@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 03/10] net: microchip: sparx5: add support for
 Service Dual Leacky Buckets
Message-ID: <Y+DT78lbinHKcxvb@corigine.com>
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
 <20230202104355.1612823-4-daniel.machon@microchip.com>
 <Y95VRJWV4NfSDYUR@corigine.com>
 <Y+ANVTMT7jgV0i0l@DEN-LT-70577>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+ANVTMT7jgV0i0l@DEN-LT-70577>
X-ClientProxiedBy: AM0PR02CA0027.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::40) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3800:EE_
X-MS-Office365-Filtering-Correlation-Id: c19e344f-0aa4-405f-de2a-08db082b7ec7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: io1ZDMMjB0BFbMUrEbfm+bsdMnRRAk8PBwYd7mT+KHySe5lyoEbPWncj2FZyJV/Q7VQeutcc5H3AFoqXoEJ+bpWL86G/YiWlALeJTtsLtLfvlq3miVAadfbpZpQfYSQsQItFit3VGukkD1R7qqhdKxH/B2y61Pc9wj8nvDDJSjhjnHK8zMWXrZsg+3e4ouTRfUg0wOzRYgYAb/cO2t/wh8Li29rWCHVoecIRxdduDeqSCB5lDs+jDEsiCD6C7tZON74lDNhe36H/qlyAnuGff7rTLQAqk3ZSBM748o3noq6mkR9Z0BQJpNDFWjaK5+tyrahN9J0U63u8jtWjMlppEIoH72NbMVvlNzy1Cpp2HN89ShJmU6Bc6h44v98qbyEDc68ocXYffnX+Lqj8F4lmpBC7XYfBobzhi+A9HRtAVS7BcGODKhjzozbftZeYpXdeHAT1W/HpDpWAUFE4T9j9z8o9MpWnjXpIsyhpGVyFYHgGpuXzw3v1ebtb6Gx0RaYqH37P4QwUcE0l9WLNuT0nZ8f5WqJIdZNpdFY9sumoKfbT2NajoBaEix0c2U57OPPLvPp0GUSCp2XB51bWuL5DLzA/fWukZ7sJN23Ll3AsCe0ssn4VwF5IsBF7Sw4b87MeawO9vNVwEyfbiuFlipX5AAtimrlnYfzX+v8jVu+GHq6iRDPWLEG2cUSJoo8jOd6nsu62i/+avjA902U3EdoCC5ZA7jGo1EWVNF15UgdPsYA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(346002)(396003)(376002)(136003)(366004)(451199018)(86362001)(36756003)(38100700002)(41300700001)(316002)(2906002)(6486002)(478600001)(8936002)(44832011)(7416002)(66476007)(6506007)(4744005)(66946007)(5660300002)(66556008)(6916009)(6666004)(8676002)(4326008)(83380400001)(6512007)(186003)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CeIggitKQVOdLLvvbZwRSQiiKStt4QmZR8btJZ58kg3iZO+FoohR9Mn0+Gmo?=
 =?us-ascii?Q?ARJgnjkYQkQJ2Fr1w2VwRmgHUWGewxr7JOeShKOJSWlZ4oehEXwQMWYvCk/5?=
 =?us-ascii?Q?mI/0ZaV9IUQGq20jfE/HL1kC6NWjjFUEzFGAa5v4gnDjvdn5y6KZxRCtivGR?=
 =?us-ascii?Q?3RsaFLCaX672TEaspx4hvOMrXG+Q2bN2+LQ3nhoOwYpk1pHBi59M1FlpO8V7?=
 =?us-ascii?Q?KR+Tw1xQ2W0Yiy8U/fOc81CIfDym5Ogr/TxkBz4rurDXTiHDmrwqajYciqO9?=
 =?us-ascii?Q?8CvGA3dEgrSFYOOUfp4xE9Vwn4AXipQQBJaoEu23NpgrsgMLHUk8Xy41kjLQ?=
 =?us-ascii?Q?Q5KUqWeITr5n9GEbRpmfgZezXGdh9cg4X5puIaJ2Dp28LPT+C5dVlyD5cgjG?=
 =?us-ascii?Q?dmjgLdz97k0dJrWTKVzOnDQpAGhRayxau5xuxbqs3X/Z050VuCYBu60IlZOQ?=
 =?us-ascii?Q?vMN3c3s03cFcPazrnNFZEBOa9WKbpqjx82MS0/M3pFpf6Dg8nPib6uVKX2IV?=
 =?us-ascii?Q?pTP49IqIsdD5dNCoZAG0bFtUG1e9yXWFO+BosI3EDFBwtmxkCU8i4F77+aGc?=
 =?us-ascii?Q?Xg77NuksgWQJ5n1Y3DgBLVEJPUE19RWZEr9EEur8mW04STnpJG9bfTQ6XTxZ?=
 =?us-ascii?Q?NnrSkM0I7FncgKiiP4pyqTZng9FnriCn0NlQ1lJMG9nOGqL17V1kBUITYslC?=
 =?us-ascii?Q?oP1eAAOmhaaIY3taWNYUsDmOmCVukR5dsRtbgQ+WgpmPgX60QQhNy5hX9TjQ?=
 =?us-ascii?Q?+AamlSgn5sJWCrtGvWfScfHbpx5mcXHNU9Rlk00bD3pffgpbs3mUB3JzN8fI?=
 =?us-ascii?Q?d5pqjgQOWfIlJJHw4bnkWipTsP4IXVmHJlPPJ1cjpJH1QJWdIjirE2o6BJpz?=
 =?us-ascii?Q?s7R2GvBW1lF4tCOjlBbXDfLUailaByh9H2o9NAODb8i717eg8FF9L0LSkdH8?=
 =?us-ascii?Q?wttglI0daIqUXvG6Uob16Sr42LpLmhLLFnu9z5iutCFHS+easgAOWcIstp0a?=
 =?us-ascii?Q?2+/w4oXBDchY5fRe/pvvKjwZiQ7YhAhxaTbhN2tyh8ILbkBjwNwBSHg1zWvM?=
 =?us-ascii?Q?FogObXJ6t6hOYkK375q+qPSM+E3MIpbagfYXr6xTk58xp44CZu11U0WBoSsI?=
 =?us-ascii?Q?XZA579xLIM6gUI0uYV0gWU+TCkjFesh2krb6fxK8YQE/iqbEWkBbf4Gecn6s?=
 =?us-ascii?Q?R31xD+La1jk9jZgyChLXVSNRynflu+tpl44dR0xIJh/pmDlMlMGDEl1W/hNO?=
 =?us-ascii?Q?IF3V4QGfU9VVCKGALwYBG3sS+gVgBuNe8IW6HdZPECfCph/hHj97ueAkaCQ3?=
 =?us-ascii?Q?aeW/hthhT+qmeooLx0bR6F/BC4fcbcZ+AevYxj53MI96PbdsC8vPmGahAIzI?=
 =?us-ascii?Q?nS+YT7Fn9ohb525LFtixmaXqMxAZwrTYGPU3CDcq2soiE5DR2uKR7ZR01Xnq?=
 =?us-ascii?Q?6tXXNIqw+qxlmguzAPVdqfHd5bNJuNbslWrpV+lFBBxeVs2fGBNYu7r2PHdc?=
 =?us-ascii?Q?xxHxY2WwasMiKFsbMUrF9ncgXcnC9IgsGyZSKCyGQoBMcj2xamf06mc109Tu?=
 =?us-ascii?Q?6AJ2v0LZbQxJXrij702wBWLxJslXgTnCgevh+Nyt1disKDm9s5EhEca2/CkQ?=
 =?us-ascii?Q?mUVhgw40Qpxq+WOSWM3mUXBZJ87bTMZdgVokzoyeu5Qme1Sor+oIgVgSxTCN?=
 =?us-ascii?Q?I7SB4Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c19e344f-0aa4-405f-de2a-08db082b7ec7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:18:30.9669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oglx6gtkWQaOJ9dhRjacCxzNls3PRWMs/TiVnWlMBrwffS6haG9UVO+Ey1/hNqYRd/2ijCnCi716mTW0TH16vZKQSoLeu41PcOa2CDQmcdM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3800
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 05, 2023 at 08:11:02PM +0000, Daniel.Machon@microchip.com wrote:
> Hi Simon,
> 
> Thanks for reviewing my patches, appreciate it!
> 
> > > +static u32 sparx5_sdlb_group_get_last(struct sparx5 *sparx5, u32 group)
> > > +{
> > > +     u32 itr, next;
> > > +
> > > +     itr = sparx5_sdlb_group_get_first(sparx5, group);
> > > +
> > > +     for (;;) {
> > 
> > Unbounded loops like this give me some apprehension.
> > Will they always terminate?
> 
> Yes, it will always terminate - unless the add() del() functions are
> buggy to begin with.
> 
> The end of the leak chain is marked by an index pointing to itself, and
> this is the exit condition I am looking for in the unbounded loop.

Thanks for confirming, much appreciated.
