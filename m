Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C34647159
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiLHOJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiLHOJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:09:23 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2127.outbound.protection.outlook.com [40.107.237.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24164286F3;
        Thu,  8 Dec 2022 06:09:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ULBbK1zED5Jojjs6FiW7RYKGnRwZ7vcioRENBJZlApE6UU02RlhVMlSOz0PkI7KAys79St1KxJfYqpnTH0Iv7FGPnZbjffJ1gI9QVCIXlRjMwCGp9T0sDUhYr5NLOEZd/Abvm7pbQQa/DZ1gnv/edqtzOSW/kFoEM+9XrAphV13H0otvb/83oSLnRfQpbP4/Y5ItafiiKeDFDF1ggoBr2fSc0ijADnLWhGckcMMvOdd36R5wQ7lgks0BvuraNwsidfFfw8Ru+d3ZrkXx1v8qPHlDUKITclq6wQBKlqd6XLZRqlJVpDniN5g+Z0ce9Ckh2CggL43o4wLmDEOmXy8nOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZqOnzEOAKsaZdT+xWO0zVr+YjGT8QWTbanS8aCnyo5Y=;
 b=DD44hsQ+8dnCC30YBXurOQxMDE/ktCf2j867L48K/0rmjdOauv+suAw4HQxSCZ2TO2w2MmGHxCal009oKz2NbxgXbS4Fmik9kVSHvFfzVxyr1oTn6GK0Fj9AgUnV+EQUmSqHpx3mri/n7sa5+W0JCuVlU8Pesbg/Bi49wXmlfkvuEycqyC8RB8E4XKn2d2RUpXBJ9853NKtbuXqpC6K7t0P0OmNTLqILHCXjukG67G4dykdyqMmc/6Dpti5Aai2HaCG9VX+yozls0+y3jRGstANNbWCTigeIq8fY7yHTZaLinshpowwf95bDhTLPeCeHsjnc4+RebN5qnXn9BWkAeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqOnzEOAKsaZdT+xWO0zVr+YjGT8QWTbanS8aCnyo5Y=;
 b=bycOfHkEi7WLT2QhgpUpQinQn6Yfig1hRQEyXNQ2bAI6lHmNbz/EM3eDGHhgOLrq5VVFRdoXxyT0Awf5zm1hgOIf5KATvBAUhDuJ2HqqBy123Xp+yIwuynukdtYgIHNCgCZQ53MX77oZdH7D0FKNFOUfTu0nFOxlIpqxywp5lHk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4669.namprd13.prod.outlook.com (2603:10b6:5:3a3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 14:09:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%9]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 14:09:16 +0000
Date:   Thu, 8 Dec 2022 15:09:05 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Lee Jones <lee@kernel.org>
Cc:     Jialiang Wang <wangjialiang0806@163.com>, stable@kernel.org,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, niejianglei2021@163.com,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] nfp: fix use-after-free in area_cache_get()
Message-ID: <Y5HwAWNtH5IfH9OA@corigine.com>
References: <20220810073057.4032-1-wangjialiang0806@163.com>
 <Y5CFNqYNMkryiDcP@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y5CFNqYNMkryiDcP@google.com>
X-ClientProxiedBy: AS4P192CA0016.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4669:EE_
X-MS-Office365-Filtering-Correlation-Id: 6947ec20-9ed4-48f7-c74d-08dad925ca8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o0z7mVqcHNnhzC7wQ6ZWyNW/vDSilS0ilUXm/UR3+t32vPCxUGsisQDz0g1tO5ozQ55Yfin0BUZSAmTK8ielbFM0bkbTkjPKvcLQcObcHKHbM1jf/xw8Gu4zqxqJqL0Kjph4cbLbwyBVZWuOIx7FyD8qDDhGfTFcbqU7NqsiBTnOeklyK6HAmHyKk0wqJV0PlH1iybmh1XwW9gMDT6/S4ytkmvwIjyqV0X2S/y2PGBoW0Oqtd67Y3CE/3/Vfb9Aj5R4jMctSt+q7jkHZ5nzwgpGhK8UsrqHbu378AgqPN3XdrPUoOYfU+xXU/kzQPLaA3sA+NfPjX/p7eUhLx0Ee/5OHyRmZAtsGW6n55QHGDsDbNMI09JNHWx77DdUDnmPNk9fcwdCJmOh1T4l+uXHWB0IY+q2PgsQBxoOVOjmKH6T5fSGpd18UJ64XfEFuxJ4vs+pdcYsep3VR4zhEtXPKFfejzs0rQfWLxx5v4D52fRsHLJO0ExI/pN3EfMxKjMdqTnRtRjhsLXHcglzSgs5pM6dZxRx34NBtihiHJJxL9EWXYpmwvGCAGXS8ZiSaxw7mxGYzqE4VcT2rJ15aktoH6lE64wqiyTcze/8rd6S+eBlmSTlEmqHfoKCBSFR1z37kg6jh5ev6WWEon8kBko8EoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39840400004)(366004)(346002)(376002)(136003)(451199015)(6486002)(83380400001)(8676002)(66556008)(38100700002)(44832011)(4326008)(5660300002)(66476007)(2906002)(41300700001)(86362001)(8936002)(7416002)(6512007)(6506007)(6666004)(186003)(316002)(2616005)(66946007)(966005)(6916009)(478600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0IxUUpadlVLRzRTejVhVVRqckppekgxbGJueUROczhQMkdOSFFyajZXZkYw?=
 =?utf-8?B?aldMZWZQa2ZnSG1CbzFMeDZ0UkJZY2h0d2FkaU9sYzdCQmdaTHZTTUpJZzFN?=
 =?utf-8?B?RmZINTlrY3FIS1RFMVJMVldyanVLdTRvRlpYVjZPb0RqVDNWcEQzS201VGJW?=
 =?utf-8?B?Z0FpSkR5U1NudUx3N1ArTXdQNThhdHF5bTNlemx4bzVOSWNMOU9PVHpIMitB?=
 =?utf-8?B?WmxYaHQ2QVdsOWJKUUlQNjFIMURhVTZsekJDN2FaQ1NvL1JBd1g1YkxDNm0v?=
 =?utf-8?B?YXcrMFpSd1FiN0l1NWdEeWhoektCUWROazRQZEZvQ2ZkN0pVWFZzY2tuZlRF?=
 =?utf-8?B?UnJoMVk5V1VDUzNwdU1oMWZDcXBXVDBVdUkvT3RLTTNPRERjM1padHl2YnU5?=
 =?utf-8?B?OEQ3YlRrTWRTcHp3R0wzZXdRM3VGRnZQaVNHNSsvTm03SFA5REdnOERnd1Zu?=
 =?utf-8?B?TnVsQ2lqTFhHeEdiVU96QVkvWFlHVXFyaHBIZ29HUzJJeTNjR2cwYnpmY28y?=
 =?utf-8?B?YlJFb0Q5aDF2ak5OUFRHRlo2YndvZHNGZkdZSXJKUTVEVXNjMmlKUlBqcjhH?=
 =?utf-8?B?cUo0VHBneEN5V2ErNVJ1YmhQcVNFUjlJNFFmazlhd1ZzMjFKRzVPZVhPekVt?=
 =?utf-8?B?djJSd3pReHZ4eUljQTJHT0pQMWV3dzV1Y0JjZUluVWhFbmp2czRDa1R2QWpJ?=
 =?utf-8?B?SU5jQVQwd1FTQjFGZUZuTWkvUjhSZHZYWDlKYUtXNEFKTktFU21heEJSYnNJ?=
 =?utf-8?B?TGU2QVllNk9RYmZNQUFJV3VkNHAxTlQ3b1VQdVRONVhTdEFMVXhMeTdpWWp3?=
 =?utf-8?B?WFU0UkJPa0FIN2IyVHlxSDlIZWEvSFNTOFI4QXdLNlE4NVU1QU9xcTFoaFkr?=
 =?utf-8?B?VXVsc09PckxnMUtSRnFYWDF2UDdlWWRNbFVVam9GUVBLaHlpQUNLOWJYYTlv?=
 =?utf-8?B?MzN4cjh6OGFUSFFPT0c1TzJEdzh1K3NtbElpczBxRmxQRVBRZGgrN01OZzBV?=
 =?utf-8?B?NEYrVHNiQUEwWThIUURGNHlZZmR5ZUtsZzBUK0RHVDJYTVlnR1dpSXBBd2VI?=
 =?utf-8?B?RVFFalVGMWh2UFRiWUJ2WXdmTko0Y0owNmM5MEFhV2xxQi9HRThQZlFRWm56?=
 =?utf-8?B?RVllOWU1NDN3L0Y2dExFWjFvU08zT1ViTEgwQUk1TzhNTmNxWis5RnQrRU5K?=
 =?utf-8?B?aXpEM1RLU29VbC9uai9HQUVjVXhPSHFybWRjd0dPNThKQXZZbytYaFhVbTBw?=
 =?utf-8?B?SjZzSHFnZmVjdkZ2WXFzYzBMZjJMWkNnOTB3VlRXQ2FuVnpDTEl5K3RoVXlI?=
 =?utf-8?B?T01EcmlVcmVxek1rQlRvQ2JtMlNZRkdMOGNyaW4rK1ZoU1Z3ditVdFY2V1Bl?=
 =?utf-8?B?OXFEbVk5eHlsVFhlblVSQXFQLytZbitjSVVaVytpRGRQbGQ5U0VZRXVZTnQz?=
 =?utf-8?B?TExFb3p6NlVHMzRnZzVxT0V4VGk5dXNxaWtpNEVlU1pScUJIRkZncm51RDJ6?=
 =?utf-8?B?QTRrTWllOW4xNWdJT0E4Tmt6Rm5xbmxvdUZNVm5kUVozSmxKY0pURExPa2xo?=
 =?utf-8?B?S2lZV282bEhhc3dSU3dDOS9hcUxEVk1RVTR6bDBqOHhDUmp2OVhYejJCbzdG?=
 =?utf-8?B?em8vNkxxYS9icFBtU0g1dEd0TTd5S2VjRmFsM3FObFpoZFpFejlkNEhTZ1NZ?=
 =?utf-8?B?d25jSEJDU0pxUUh3MGNwQ2xVaGFXMURIcytJT2NUYnREVkVhdXNNVVBhTGg5?=
 =?utf-8?B?VERLL3JmUG1obUFoR3Y0OSttdytvUUR0aHRjVS9wSDRaVmdjS0JoWG9PbmJu?=
 =?utf-8?B?S2phTUFsNzRHUVJRRlB1YU44YXdnZFBQcWVXdDdwdGNzbFlHTytIWWh0UTE3?=
 =?utf-8?B?Ync3Q2NQOUsvczhXYVRVeFZsMUhSMkxsdjJHcDBHeXg1QjFnTnhnTlp6NTkx?=
 =?utf-8?B?OGMzK0NFQTZVNFY4bE9Ed29DaTgvcmd0RUNXYmsxK0hyWi9wZUVlZm9NMmFh?=
 =?utf-8?B?MmxUaEZ2Um1EalplL2JyTFRkZnhaTFN5dXZHWnZkQzJrUjFGcXc3UmpLWW1G?=
 =?utf-8?B?cGFMam5ac0lxOVZ2TFFMZ3JwNmxDUnhuRmdhdFdNU0NHRStUUEpvYm9oOWVr?=
 =?utf-8?B?L2tNay8zeHI4eUU4ZVZDak1YSFh1TkRCaFNRTEZTeU4rY0l5VGFOWUNsQVdp?=
 =?utf-8?B?eWtRNmN3cDJ1NG5TOGpGK3VpeFBISVlUVWlRd2dnY052QUNmaFAxcWM5ZEhz?=
 =?utf-8?B?UUpQV1laaW82U1dRWTdjVzZPMFh3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6947ec20-9ed4-48f7-c74d-08dad925ca8a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 14:09:16.4112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VWtZ1SnMTZFE2KioExb4IzkSJCPHU2WTiXbb/0iazuA9gMe3Ul0hle0Y6IQKfWvHfdEg7x0bZ5f7zslxkt1mDTg1h+ypjYlXnqfmPvwrzu8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4669
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 12:21:10PM +0000, Lee Jones wrote:
> [Some people who received this message don't often get email from lee@kernel.org. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> On Wed, 10 Aug 2022, Jialiang Wang wrote:
> 
> > area_cache_get() is used to distribute cache->area and set cache->id,
> >  and if cache->id is not 0 and cache->area->kref refcount is 0, it will
> >  release the cache->area by nfp_cpp_area_release(). area_cache_get()
> >  set cache->id before cpp->op->area_init() and nfp_cpp_area_acquire().
> >
> > But if area_init() or nfp_cpp_area_acquire() fails, the cache->id is
> >  is already set but the refcount is not increased as expected. At this
> >  time, calling the nfp_cpp_area_release() will cause use-after-free.
> >
> > To avoid the use-after-free, set cache->id after area_init() and
> >  nfp_cpp_area_acquire() complete successfully.
> >
> > Note: This vulnerability is triggerable by providing emulated device
> >  equipped with specified configuration.
> >
> >  BUG: KASAN: use-after-free in nfp6000_area_init (/home/user/Kernel/v5.19
> > /x86_64/src/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:760)
> >   Write of size 4 at addr ffff888005b7f4a0 by task swapper/0/1
> >
> >  Call Trace:
> >   <TASK>
> >  nfp6000_area_init (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> > /ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:760)
> >  area_cache_get.constprop.8 (/home/user/Kernel/v5.19/x86_64/src/drivers
> > /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:884)
> >
> >  Allocated by task 1:
> >  nfp_cpp_area_alloc_with_name (/home/user/Kernel/v5.19/x86_64/src/drivers
> > /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:303)
> >  nfp_cpp_area_cache_add (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> > /ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:802)
> >  nfp6000_init (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > /netronome/nfp/nfpcore/nfp6000_pcie.c:1230)
> >  nfp_cpp_from_operations (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> > /ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:1215)
> >  nfp_pci_probe (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > /netronome/nfp/nfp_main.c:744)
> >
> >  Freed by task 1:
> >  kfree (/home/user/Kernel/v5.19/x86_64/src/mm/slub.c:4562)
> >  area_cache_get.constprop.8 (/home/user/Kernel/v5.19/x86_64/src/drivers
> > /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:873)
> >  nfp_cpp_read (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > /netronome/nfp/nfpcore/nfp_cppcore.c:924 /home/user/Kernel/v5.19/x86_64
> > /src/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:973)
> >  nfp_cpp_readl (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > /netronome/nfp/nfpcore/nfp_cpplib.c:48)
> >
> > Signed-off-by: Jialiang Wang <wangjialiang0806@163.com>
> 
> Any reason why this doesn't have a Fixes: tag applied and/or didn't
> get sent to Stable?
> 
> Looks as if this needs to go back as far as v4.19.
> 
> Fixes: 4cb584e0ee7df ("nfp: add CPP access core")
> 
> commit 02e1a114fdb71e59ee6770294166c30d437bf86a upstream.

Hi Lee,

From my side this looks like an oversight.

> > ---
> >  drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> > index 34c0d2ddf9ef..a8286d0032d1 100644
> > --- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> > +++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> > @@ -874,7 +874,6 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
> >       }
> >
> >       /* Adjust the start address to be cache size aligned */
> > -     cache->id = id;
> >       cache->addr = addr & ~(u64)(cache->size - 1);
> >
> >       /* Re-init to the new ID and address */
> > @@ -894,6 +893,8 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
> >               return NULL;
> >       }
> >
> > +     cache->id = id;
> > +
> >  exit:
> >       /* Adjust offset */
> >       *offset = addr - cache->addr;
> 
> --
> Lee Jones [李琼斯]
