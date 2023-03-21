Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4646C3753
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjCUQqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjCUQqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:46:51 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2090.outbound.protection.outlook.com [40.107.220.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ECC3C1A
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:46:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9yvHZPctIcm7cwBWnvXZ5Nf/ETgWmJ/gARKv9ZvEfqsoE24kEAVrbcrrLEL9MT+IKp7Yslbb2tQ04oFMdFh9ydpqOnQJ8mL4b04kTyhFmzvpPYYh5nrrSh3HkHE3X+5AtG/IxVBNx0bUm29/LvzMgwosGDX55ImDCh5+TSKT+kRegHJCxza3OHJUqE9UvC8GtZnsoTvo/ZpmYj0lQrLJaWbRoOLji6GHvEszTjP/P4yWc/jclXcl2mwPzQV4jIV9OcfSTGLDrDN3sWesF6cywUFNcc12jfVgpvdbsH6BK+KjUtYaaeXYIqicO63raY9RHIxusKXhv7Bmm47jgEQ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tg0MPqyJane5gbtwsUtJPMCKsc8d4BzgS/5czG/54p0=;
 b=EqTwDzS4EEY2xZeA1GYj/NJkeBLrmsT3owW+/zjNj74r/cf3feC1xdZdemcbMJ0Hg6eHln2iJkRIkWFkLMoEMs1FVv+bVmPFNtfzkWAZBaE3hHrMQ/pmEi107Vm8e+oH5K+n/PZy41lmo/9qKJ/JPJ4B8GKiTPMQpcdg5+wJXQmOXiDv4jCTIDgY13OsTNxGzsrzamIl23jaCZsPOJpNl/5IwyziVun92dto4ppe9Gl8MbnoiLUFCljIc0rcteNhvf5A3cuSgodINQjQUMSWG55pisg09xY+tZvtkzoZILiuew2lsPcicU/aDaEDmyle/wyCqYvEE8nmSOWA9ZsOAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tg0MPqyJane5gbtwsUtJPMCKsc8d4BzgS/5czG/54p0=;
 b=v07EeKTq7+6g3tWSRR/DaV/z65aJ0os08n1+rGw0kh6Ut/K+Lbe0UiDhbH1tzd6j3JdG9c4lu3bTyLMFMakYaX9fjtygc6aoCDAwHCg4doh/w3ChBlqgKbxbPD3rqtm1TZuQvaaCLeFUYyvjT09AtyrfA1hm6qW0i4EBPzoVHAQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4844.namprd13.prod.outlook.com (2603:10b6:510:76::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 16:46:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 16:46:19 +0000
Date:   Tue, 21 Mar 2023 17:46:14 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] erspan: do not use skb_mac_header() in
 ndo_start_xmit()
Message-ID: <ZBnfVkpIftKsriqo@corigine.com>
References: <20230320163427.8096-1-edumazet@google.com>
 <ZBlUXFdZybQ8BJ/k@corigine.com>
 <CANn89iJzniaHGYDWL4o8BWp+FBMH_RMaZuCzt+uh5gHicJQ+Pw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iJzniaHGYDWL4o8BWp+FBMH_RMaZuCzt+uh5gHicJQ+Pw@mail.gmail.com>
X-ClientProxiedBy: AS4P251CA0027.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4844:EE_
X-MS-Office365-Filtering-Correlation-Id: e3780367-0ba0-47d4-d65b-08db2a2bcb8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cMLOpt0P9DecQddEH6TisIiM9sUe4uik/uHF4c1e1+IQi84yuG5WLwTkP2NLuKir7I69DwuDr2JUShu0L8Pbf66+fIxEDGj8DOL/9hfLXbyFsfYAxVLLG4Rv5mK48iEtKnplio+Xhu5GXHkm+PSIVXpPwaru6LVXNfWK+yCErevTeEOqJAGW+5XteT8orWjmES7ENtvnsfyxqrhpWbP95uZ2s3dUfMeymw77rAaDmtPhLGpw/KQvHLGlNCnFYvnLlnWY13doFxaVvOEdjh0uPQ9twYLAYNu3bZ3oQ6UZ7xV4eISbdFvrn5jPmwN/DeWV/QjsDi8VOmlNqvXwmCPlTquVg0esBOhwMraazyY2eqcPPXTO6FC50TVVELVufZfRwh4ee5Y3bt7iNJbI2bNgNiwVgxyTJC0hi1SyqguBkpx7Dd4yEhE4TE9fY0YnVm7tsspkS2bhQGyQ/lc7NAEqcHxf+cUzKKvhS+IG54XboZLKETvOV9kdWMjWRvMtZGM/RsyTv0BRtL8u5PUWnoZcpi9+wcT0IDz2jTr5Nfm8o7l9nz3yyFCW7TFZyenHR3hif+1LSTWe+ozjzfqtREzEVvpe6Ug0u9V4iG7NtUcZRO45TKvmKN7Nss41hsJmD93RpBsSF22vnGU35Dph0SuPS0UYWnVH/nvKWgs1YW5vTAUdcKl3vttKVf8GxZS0Ffie
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(366004)(346002)(136003)(376002)(396003)(451199018)(53546011)(41300700001)(186003)(8676002)(6666004)(6512007)(6506007)(66946007)(66476007)(66556008)(8936002)(5660300002)(2906002)(6916009)(4326008)(44832011)(2616005)(316002)(478600001)(38100700002)(54906003)(4744005)(36756003)(86362001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THNvd1d5eVVtRHVmTDhPbWl2Q3NtcTFSZmlGMEJBYjdLcXd4bytIdHVFekd3?=
 =?utf-8?B?dll3Z3QrLzBEUitzK2NTSzVlcU9UdndoR3RUdmc0Y0Q5eG13TnUzRXJGSG40?=
 =?utf-8?B?T0swekZZWEhTc0xFbnAxYklvQkcrVnljUFQzeGJqVHl0c2tiQkhPVjU5THAx?=
 =?utf-8?B?WXkxREU5WEJodTY3cjVJTTlzbGpZUEtqaG9iSHprcDhQQ09xQVBMSDJ0Q1Mr?=
 =?utf-8?B?RERRZFVmRVVRdlRyZ3U3cmd2aWZtRXFjdXBHMHFrenVESk52SFNhcURHMFFY?=
 =?utf-8?B?TjA3SUVDNW5mVkdzekJqT0t0N3FQU1NOOTRwODdFS1hyZS9kRHF3TkVoMVpx?=
 =?utf-8?B?aEl0T3g5TFZPSnJ1S1kyaklnZDF0M2Zwd1Q1TEhITUsxMnlGc2FTL1Fvem84?=
 =?utf-8?B?d0xGamQxcjJJeUJxNnlRVHpTMFZUdVJKMXorSzFEL1RGRndlbWIwN3hXcGpG?=
 =?utf-8?B?QWRwcFhjbStoWTBQQXduRiswMjdnZjRQbElIblFBZlhpNnRTNjNkaHNYZFp6?=
 =?utf-8?B?ODcweGtrdXhJN3ZGb1pHS1E2VDF1NFdGUmNRT3hBWWlHbEVQTmVxeThBa29u?=
 =?utf-8?B?Z3pPWUtaZS9PMHY3T1pyTHJWQTY1Qyt5Yndha095K0RXYUh3NkF5Tm9jMjcw?=
 =?utf-8?B?d3BKMW1pQ01lVTREYk9wbEYyTXh3TW00TWhBb2FPbURlRkk2RkN3S2hJUjla?=
 =?utf-8?B?WmFhbW9qRERUVDU0SHZXcUlXUkQyWTBrUzF0YUpoUTNWbkgrL3ZwNTNlTUVU?=
 =?utf-8?B?UFRIc3p5dURtTTVPUWVaQ2plMkhHRG5reHkwRHE1blRBcE02Q2czSDlDQ3pX?=
 =?utf-8?B?YmxlMyt0TWxQTDF4dzcyYklldUhRQmhGWkhNUVRBemt6MzloNUYvYU9LMldm?=
 =?utf-8?B?cDBlOWg4blhoODduMU9aS1F6U3R2b0laeEoyTHZwdWRyVjFYNTJNa3dSa2dR?=
 =?utf-8?B?akdPK0xmRjU0TDluY3ArdEl2enFvRDUwczVETFkzRjNjandZL3MrUGlGcXJT?=
 =?utf-8?B?SHBBYUdxZzdoYnRSUTF2NW9aekJaeG1Oenp1aVkrd0ZQSVptSklVaWl2WUkz?=
 =?utf-8?B?NUNDTllKUWxpNmxoUExDajNQd0tSVkE1N0YwZVFQbllQOHNhMXpkUk4zbnVL?=
 =?utf-8?B?NVh6ZUR0NXNBTXZHdTMvazVvdHN6MUJsaG9sWDQ1YnA0dVYybEVMWEJsUWwr?=
 =?utf-8?B?RWVmRy9uSHpNQnkrNUVMWlBmREw0ZkN1WVFnZG9NQlVRL1BVNUlrZTBZb2Rx?=
 =?utf-8?B?dU9EL2VxUDdsL3FKNUtWMkw1KzR4TkRQdnI4a2RWMzAyWDArT0FPOXBiT1NR?=
 =?utf-8?B?ZnhYZloydEFPczExOHUyTCtUQmVWaXVCcGs4ZXBmRU9vdEZobzRmRlhZOEI2?=
 =?utf-8?B?ZkhpczVsM2t4NVRhVTMrZS83STFUbitWOWxFN0JkbnZPL0xzSTZNcDJXUWVQ?=
 =?utf-8?B?b2lDWUQ5ZDBUNmNjRllMdUtjVUxsZG1kYVFOVjh0a0VETnZOWXF1OVNiL3Nu?=
 =?utf-8?B?aWtBSXIrU1BvK3RYYVJRSys2TU9tc2lUQzlPa1I5Z01NbTZ1ODBvRE5uQVVM?=
 =?utf-8?B?S0RrRDdHdno5cEc5R2Q0dVJqN2pqQ1BHeHlCNWZVcm15QmJLaTlxVy9ESVE2?=
 =?utf-8?B?cjZValB2N0VrUHcrS2FzYVF6ODFwMEF2Nkt4NnUyaU50eGxSRW1RTGxXeisy?=
 =?utf-8?B?SkRZRGNJNkdsbmRDWHNCM3dnMC9DdzNMdmppZUdMU2gvL2piOEhkUlBXb2Nh?=
 =?utf-8?B?WTdJWUtwbkVRNlREMGcyUHNIMTJEa2NCY0IxRjNuT21UYVpCSlV6Wjhkc3FN?=
 =?utf-8?B?aE9Oa1NEbGJXckhDOGhTckJOVDF6ZHRYejM3d1BjTEJKU0ZnenV1QnIrR3JL?=
 =?utf-8?B?RFFNQmFKSTZ6dzNqa2pDWTE5dEgzWUYyeUtyZVdqMEt2OWY1K2xKZUhIUVFD?=
 =?utf-8?B?SExPenlxSkJndUV4MHM5RER4QnFDTzZvNll5aTNrTGRlb0ZacC8vUWZQd1Vj?=
 =?utf-8?B?cXdoSktBeGNNWnp3V0JBdTJQNlZJRlhneFNUWWkrNDVWeHk4ZG1QM0R0U25H?=
 =?utf-8?B?VmhIcnlNWGQ1R092dnk5SGppMGhsZkJ5WUE1VDN3eW85QkVlNlFySjRscmtB?=
 =?utf-8?B?RmhORGhsUkw2bU1rWkpDYUlOVjUrcUh4dU00My9vc1I2bEhKYk1tdkQ5UCt0?=
 =?utf-8?B?UllQRmE1TVI4RHc0MTJUVC84ejJ3aWo0dEJPcmVMdElhcGVIWXQvdXFwaXdv?=
 =?utf-8?B?TFBvZ21FQ1REZVVocFRraE5xYXdRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3780367-0ba0-47d4-d65b-08db2a2bcb8b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 16:46:19.1518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l9pl+urZ1YQXryiuJ0PMPdq/5ayuPq2Q/mxFDmjOOpQa7VHDrEGsgDeVmdAAUHnpx+ZyesS+flRMHizFVhDBIuCYkPrpc/zkxyT2sIdPJ0w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4844
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 09:26:45AM -0700, Eric Dumazet wrote:
> On Mon, Mar 20, 2023 at 11:53 PM Simon Horman <simon.horman@corigine.com> wrote:
> >
> 
> > Hi Eric,
> >
> > A quick grep seems to indicate there may be similar problems elsewhere.
> > I didn't check them in any detail and I'm wondering if you might have.
> 
> I have a patch series of three, but for net-next.
> 
> My plan is to remove skb_reset_mac_header() from __dev_queue_xmit :)

Excellent, thanks Eric.
I'll look for the other patches :)
