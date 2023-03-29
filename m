Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FDE6CDA80
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 15:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjC2NUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 09:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjC2NUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 09:20:03 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2119.outbound.protection.outlook.com [40.107.220.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C0E524F
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 06:19:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDPL1zG/AQkHIm8sx+9rY7SzW9aM6apIHUH/3GDPNqvnEI9qy+zpCiTSXosnMKNwdic4ACl991h0pqei0ca1unMnVfl/dWAcePrTD+d/DpybvevK8EXtmM8l6lQUg8qKuco7cnvU5eFC8yhRQMOOK3y0PqDXrTB3vi8D+Z8hv60hoexHvdzGDygbOpqDXK1GBngiBRbL2Ym0xA+53It7fiYOtBf+q6LQIBMqpRLOlRGeeMiO5Aox/H7Luh/WUt9+yyFkAIk3qar5MucFQ9DD6myziXOWXCrjUDR9WOCJf1lb0KXcDflHNKgkszU+1apT8emzO3+yjcUD/nUAkqHxUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/F27gsHLjF0XFuWFg1DOhid3cO+CbdIXps7RL2zWBo=;
 b=hN8bnDNQP9CGmvSBuu0+3H7a556D+vuRimugSjwyhBuzA7Z2AFAfPQ5vaKsughbZ0+NEToJHuX+PBpDKdG5S63dtC1VHFmMLfmiN7wQGxyZoJfJ87WNzZvhs1L66n6uwKLfv/wlpBUK2xR5G/at7QhagotGZKrqozSK7arOZPDCk9Npp9ami/yiqb/gB5fDbOl+2pQAMTSFCtdsEHvgrygTntOOpKT+w6C5q2VlPntJ6wjwkCIklbqcRq2iRq+hvASzmdgpZ12yWGgPeGHQz0dmA05VCxFUz8Pb0G7tgy3zSWReOJCUp1zx9t6ke0YSjtlLolpiGwNhyZ97WGV2dLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/F27gsHLjF0XFuWFg1DOhid3cO+CbdIXps7RL2zWBo=;
 b=d1tLqC1kpdsJNS/j0JVgQOZtFzLOBm1LJwz2xOeUO1dSAGsWm7yowpYqP4XQ4qkDNd7W2AWw8BTZeWCqzdz4peDcOXthRjlO9gBDsSoIHhbdCvHKQARJTnrJ4AWeXLdsznySWz+LswlisEQrFvKRVMP8m9ptzWH3eYvaK5S4Tm4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4967.namprd13.prod.outlook.com (2603:10b6:303:f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 13:19:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Wed, 29 Mar 2023
 13:19:25 +0000
Date:   Wed, 29 Mar 2023 15:19:19 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, gospo@broadcom.com
Subject: Re: [PATCH net 3/3] bnxt_en: Add missing 200G link speed reporting
Message-ID: <ZCQ6117Ifa9yfaY9@corigine.com>
References: <20230329013021.5205-1-michael.chan@broadcom.com>
 <20230329013021.5205-4-michael.chan@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329013021.5205-4-michael.chan@broadcom.com>
X-ClientProxiedBy: AM3PR05CA0139.eurprd05.prod.outlook.com
 (2603:10a6:207:3::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4967:EE_
X-MS-Office365-Filtering-Correlation-Id: 676e55d5-c174-4339-05c8-08db305837d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GdA6gcI5c6PZOgyVlVb6emGKOGPMZ+eWDa/dJsAv2u2q4OJFXV6RAKKz+2ry8RBscma9RD5VVSV6jf6gqKU1HeQ6JhTGYg/K4wFrDQhtONs8/N+UgWNv17F5Ov4s2nFxBfAlin3JAg8q7TtWYzvw77Dm8eObKL7KvVyvdGEBxqH5ZFsu4KRfa75ROsyCPTS85EbfqCDH8f3jI6hx53fEBaEwjfVk7rFhUy8XgwUgNro/47vcHMEyXvJZ60Dm2nuG4xaKtmV7L0TtO6mnq/3I3IXOUM2Dt1rGWlCxNeVjxh4xwyvtM3YqNJ20nay3XhArmsqGVjYdcPGiDt0SGE+5eZVYLYT4aMdiGa/qmVp5EOGsi6x4dq2VHQasNvmpsTDIF1WRH1+cMTYV+ODj7CcVQspJPlzcFlWkBIVDEnETWiD8735/f+cOaoJAoRdLFU+BHQt4zoH1XqRoBZxGSUnQJ0Rcd87BO3I354tX7N5Obeb0iHKd4gjptrhkS+HCNTe8YHoMNlxEEEZ/T+MpxEM3sNU1K9kxxy6eakWuoUT37w0/CxdQy48eYYTDDyonvLad
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(39840400004)(346002)(376002)(451199021)(6666004)(6486002)(38100700002)(2616005)(186003)(44832011)(4744005)(8936002)(2906002)(5660300002)(478600001)(6506007)(36756003)(316002)(86362001)(41300700001)(6512007)(4326008)(6916009)(66476007)(66946007)(8676002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PqGYj359y/ADd5AVfHAWd6SRirTml8H1TwXPTReJRgqtLeCGFgSOdMS7UA+J?=
 =?us-ascii?Q?5+ejGON6kS+zY5N4uUpp4Ziqq3Uml6Nh7Ab5WrjcSp4RpPMT+wDAteDBgYHr?=
 =?us-ascii?Q?NVpQhLkswwvdMPtfsd+AuDW5m8mhG3inc4oOBlAZnxRUOGnWhfCpuzjOiaxd?=
 =?us-ascii?Q?ncapJwTUXozglXlSFUScVglA44uiNDJkIuT7vZhuFxGfndGYfo/kLsyzkvtS?=
 =?us-ascii?Q?ZAZ7erHf1crLwYqe3ZbEFiqF01KbsNmkTs0QlHQxGFObLDZn2EUJS2sU/2FY?=
 =?us-ascii?Q?m++ThH6NaUXWkFyyQAp3Aan0vzUGBs/CbVpYWQWHc0UrGOmeFdhRFlumO26M?=
 =?us-ascii?Q?9nfHSK2A7ISe8aZvIIT8ZxJCDByHPvBTP9NwVv+G1kAoi18MdaUPR5U2B6F1?=
 =?us-ascii?Q?x/B/c8tzEucO0tzJYaWFBu939bZOC2DaH3UTg/dANMTEg2znZ1QYW3khhBwa?=
 =?us-ascii?Q?1uiDi/8D3AuKhK/akEEq4JAUsxXnc/eBG2oqjXPcV4YGiM17Bm3viixhmM0O?=
 =?us-ascii?Q?cBBoyXV1bcT2VacII0fzb4vV1DAnq3zdzB9pR8LGvnib15CuuTMc0iZoVUzZ?=
 =?us-ascii?Q?2RaTs3bYALvfmBqSaj+5aE4zQeYdboajYoDtlf0JHd9gO+bN7YalzS61PKAN?=
 =?us-ascii?Q?sba0o2Ue9tZ1qQGvZJ/IaFkc9HKWhp9qmJZWn4eihR2xi6nYOsa3aIyPiWYZ?=
 =?us-ascii?Q?E9oXb01GiCfp34N2acE0mfOoH0hag17PMeDWAQNkJtVIx3Eb2eVWhyphx4Nl?=
 =?us-ascii?Q?A7qK899wBEC9zNIPuQdnXeRJmg+rO+1uF1rjeRRk4CZ8weQApdQBCqlgbVf2?=
 =?us-ascii?Q?SjG2vraAcfKbuDneYQ3KPxVgQhu4F+unPHKwjFapyZ3KfJ69O+4j83TBM26W?=
 =?us-ascii?Q?aSL8e+Uj24yxIWSEuJhvMjE9xBbg7j7gTacjqKbrZbaQj8mHugsl3nZHnavK?=
 =?us-ascii?Q?ctn9YZwWMwO430dcmcJfVmogTD1F4AAh2zC3CPeFrlL9o+9dhbyJvoWCpPe6?=
 =?us-ascii?Q?Pb+dYwXQ2fgec0GzuVRzBBluQYMG876njvAI/7mooO37ciI7AJUF4/PCliPF?=
 =?us-ascii?Q?YgtoTmQJ/REUHyzTMwdJBATJfkNwTXtcIR3szIRCHRTx+PgqlcyUkpHqt8Kc?=
 =?us-ascii?Q?Jdd+l2s7A2RGCMn4SFRSx0UCTMvWt03iSBxFpLvCfviC9sQ8tA2411ejKq1P?=
 =?us-ascii?Q?J5I8xg44UbylvXAuXI9cJDEPfjLLTmnr1obqRdhhMVHnn6kfm2BC5OWwvohn?=
 =?us-ascii?Q?TTyOrpg8PcOSZlfo7EXlFTBYQu8UGu31SewZU3ltNCIfbzi1l3QGzRzVZBbq?=
 =?us-ascii?Q?GZxLtHrAPr1YiywMiF0Z/uFFuRBH/UMjAM7OqBB0VfbY8LokaKt8Trhnta8x?=
 =?us-ascii?Q?VGdT9ATdMy/z0frBrRUzXsVO+IvRBA1UIsffyGqsFsCeSNMdlGNdGoLzKdYa?=
 =?us-ascii?Q?gtdW/KEtzQ89N0mJt5sHuVDkWTJP+IlECpGe/RM9S1I25VCc4jAa1lsH1msP?=
 =?us-ascii?Q?EmTDQ6pdBbLYMlhHI6jQaR0DCI81jsKKFneRA7Uqo3DQOFIW1gA3UE+EqiKt?=
 =?us-ascii?Q?PvjbafbCcJU9El5rjlLhk0keOCazpGzEYKv/hllKAV6tswVqgJXC1Qj/f1yc?=
 =?us-ascii?Q?RwgpLA8uy5JAJREncHsaZvWRYXUW93g+rAAj96tvZm+5Z0kfME7vdnWmaXNx?=
 =?us-ascii?Q?v4CSzQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 676e55d5-c174-4339-05c8-08db305837d0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 13:19:25.6517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nb73vpR0V6T/NbnT/qjlj13cE6sMpjSk9KMEGDKxvSKxW+kNs7uEft4psMyyyeV9/7Pp3RpjJVk8sIce1Czq+LeZT54umpFyS5SXPjj7z2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4967
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 06:30:21PM -0700, Michael Chan wrote:
> bnxt_fw_to_ethtool_speed() is missing the case statement for 200G
> link speed reported by firmware.  As a result, ethtool will report
> unknown speed when the firmware reports 200G link speed.
> 
> Fixes: 532262ba3b84 ("bnxt_en: ethtool: support PAM4 link speeds up to 200G")
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


