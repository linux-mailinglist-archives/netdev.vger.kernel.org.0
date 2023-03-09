Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95566B26B5
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbjCIOW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbjCIOWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:22:46 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272B5F4D8B
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 06:22:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHrLAkgWUzOvjLCcMurQpp9USwmgxJ2jhsDoiTdzxO64XS/DFoQBIR/QskgLHiFoykYQP/YhMWn+Y5cWU0PeUwSuM+rkn7t1YkQQfMdhbVmpRJW4xRKo2f/gUObFSAXXVk1z9E/XmITuZ+yE/avaOnVlmu+HnlTDnVHofv7ET7uWLQbOJAPmTt9TkDnGcGkw1r+Em9zo+L6HYijojuBcJ9Qg0nCLF+xt3udueLtEwp2TZj1+esGpePyA6pbnpdisv8HtsGHrTq8MGO9fnVlfN4KVzsbPEUc5K/lTvHFBr2jemhvlzxNedr60NzvWBDZWyglfyk5rHD+mJ8LFT+RR8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bwUWGbJ/HgtT6lc0fFzbv4WbF6zNwbzXmKZ+J3+xIZg=;
 b=AvHNEhdBCulHhlhhaeO5igwE1Rva+BZYARCW/pH3nHhxvRwt9urQgg3sk5Nw5gEO6i4iyvOvgTJEH3EPupEsFBhknvfP3DYcOd+Zb5lb+cljjVJx5UjjAB3mGYKEO9Y/3tMpAMU886nqk5lN/1xI1tEVZ5UgHaiThCUSJD9TyVnvEDOo21ci13WWLS/Fa9dIxLakJUgGMA83BokEwIE//ZEZHDQ30WhOHsPI2OD7JCX87ApcLukMpG8JVUK+ez1iMAi7bKP3DvsSkRRHEMC0ZmTRnbTqYRPlfyNWXEOmcKb2rV4uzmdpDQCRISxSQfxlCgWrLK8kFlc02Lfg3m296g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bwUWGbJ/HgtT6lc0fFzbv4WbF6zNwbzXmKZ+J3+xIZg=;
 b=b3dflso6ZTr7c3Q+TAT38KWpzUzV3CgIxhAK2EzlRQFNxF+KO/b1CSyJ2D/X2SHLibpQ0O5FRC6Bv8jyedvjp+6WgDqDCY+B5Ol/25zpUxGXd9H6WfaykPg/DrhKFsz6zUA9G2KD2mRapGITCuMq1lq5ZYNYd3JUm3y3mlk/XKo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6220.namprd13.prod.outlook.com (2603:10b6:510:24b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Thu, 9 Mar
 2023 14:22:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 14:22:28 +0000
Date:   Thu, 9 Mar 2023 15:22:22 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] man/netem: rework man page
Message-ID: <ZAnrnrKzuE3Mj8K7@corigine.com>
References: <20230308184702.157483-1-stephen@networkplumber.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230308184702.157483-1-stephen@networkplumber.org>
X-ClientProxiedBy: AM4PR0302CA0013.eurprd03.prod.outlook.com
 (2603:10a6:205:2::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6220:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a2919fc-9384-4a1f-fc5d-08db20a9b60a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nOU7fU0uFb41r1z9lwAf88vyvasIzWxYYBlvhmL3obJyeSLMYL37bbVlGl4v4A8mYavS9UhNm4iuur/JPkShgOm+BEmvuR1UpH1f0mN2nDx3ejKfTyABG8CizwJ73bS4oVIbKZkGMuS91pr5ilzk6AK5jATjz1JyL90sNjTiprlX1wU6DMw85M/pQR0N7KmVUUUzevXwhLAf685qKAk/w4ndkcNqgQj1heKJjrko3zyfNRAWP0Q/Woto6Tcpf/jOR7u+pL6Mh1v97458uphI8bq9JbeLqz+MKY8Q6ZdTWcuoDqcR/GqjkcCdspLCzCQMFjvkOxhUF8TA04XZZZ+UWfZLK4NmpCaJQew92i0egttWzMgO5avDWNm3qziqMy86i1dLVSybSCMBSBXKIh+cxvFJgcXbz4UnmcaxS39j+GExK0xQwvzncFdWHiwQXPoHr6c86yYSHzR+S/bFvq1tboMuUGZHanducWiFQY9MJYzZsoaDDfJcdBDz9te4zMkjBuZt0J+0J1yF9WSU07TXceUSP6jJFbitoLewgNK2pI2TVwkDg6D8cbv5az0BSxGR8AgR8+2GchF+9xgguxmOYZibFXqSftl+rTuecD2X7FzMu9DppQFQwMOvCF3XdASPLvnnN8J7ao7BCBvvSuMYBvwf//5q9qg60/yL3fS0WsI0i2Og3NzeZZcU+sg1GfDC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(136003)(396003)(376002)(39840400004)(451199018)(38100700002)(6666004)(6512007)(186003)(6506007)(83380400001)(2616005)(36756003)(86362001)(6916009)(2906002)(8936002)(8676002)(316002)(5660300002)(6486002)(66946007)(66556008)(66476007)(4326008)(44832011)(41300700001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVN0NVl2WFA0Z3UvdVpneDUvWTJEN01rRVAzNzh3Rmc4UmtXK1MrbXhYRi9J?=
 =?utf-8?B?MlRZdXh5cXFPVmtsRkZteEwySmdJeFZ3S1dxVG8zSG1waDQyN0xzcWh6cGpk?=
 =?utf-8?B?a3l5c2l6bFl5SnBUS1VVbmRtd1dyOCs0TmF1MFNkZnNBZTREZkNzNWZwUmdM?=
 =?utf-8?B?d3VOZXh0YUdHcGJTNkVGMjdDYWl6L2VhVWl4eDZRSG9UV0VTWndqbThMemZ6?=
 =?utf-8?B?VTFTVjRKUFlKRDNpeGN6Q29ESmNucnk4ZjFDTmJuYmlYRHIzeW1UWTVJcVk2?=
 =?utf-8?B?NEh2ZkNQdTQ5RkMvcFFhS29kWGRXNGNjZndkeDdMRVRqSFByRHlhSlNydHht?=
 =?utf-8?B?a0VwcnpUWTQvQzVIODM5c3ZCUjA5MFdqR1N6bXVmcHFKSUlIZFFPdVYveWpz?=
 =?utf-8?B?ZG1FZ20rVGpRc29YdmVHcHNjTXRoODJrbTJOTmFkalFZdDVFZUNVWHA2RXJV?=
 =?utf-8?B?Nkh5WUFCejB0NXhnbVdkWDhjTjUxaFd4aEs0emwyVUVCMTBsVk9VNUhjUGpE?=
 =?utf-8?B?M3BjY0JVUjlpTStCcEFJdWQ5dmovSHBKdlBuZk0zWVJLTURpOGwreXlsTDl5?=
 =?utf-8?B?cGkzalpnVEQyMTR6WkJMbjlRZk5sZ3BUYzNNT2YwSGpUclpVN2pwbmJ1cExm?=
 =?utf-8?B?WEFIc2ZnRkRpV0tEVy9HWVI1NkRnMytmV0JXZGVKTk9NUDR2a1pGVWY1OHov?=
 =?utf-8?B?aDFrNWdyamJ5c1k0QWVJTWpmTGZaRnVYNllzTDBrYXVIN3pmOWwwbGcyWmx1?=
 =?utf-8?B?M29ZdG83eS9sNkdRd2VTT3RxQWg0a3RVVUhJbmpCcGt3dS83L2p2a2EwREVY?=
 =?utf-8?B?RGl4a1NVVWIyNlpEbVJicHl1dlRObDd3UXFsMG45OUwxbS8vUzRyT2pGWVhn?=
 =?utf-8?B?eVVTUzFtMEFqK2tDdjVSMHJtaTBMRGFhQUNtZEZyekUyR0VnUi9naXhoa1RU?=
 =?utf-8?B?c0huaXIrRHZLWmRlcjZDOGJ0UG9LeHI1bVl3K1RlbkpwSWt6YzJiNG41WStz?=
 =?utf-8?B?dGdhZDh1RkZFTVEzaXhGVlcyNCtBNlU3bEhtTXIxU3FXVmUzMUovM0dMMHhU?=
 =?utf-8?B?MkVqMVB5ZWtiRHZrTVRDOUREYnR5SStZbGpRMlRlTlRkc2hvQTgrOTRCOHlP?=
 =?utf-8?B?Z2IwclFYK1EyZmpEUmJUQTRDSVV6RHZPZzJCQlFMc0JVQSt3UDA3RnJqZVlj?=
 =?utf-8?B?Y2xaV3loVHM5SlIwY0VxNkMrdThpcUYxOFhIaUxlVWtUbkFKZG5QNnVuUDhm?=
 =?utf-8?B?OHFESmlZOGc3dVE5NVhVY3ZjYTA0TS9najU5TFNFaVJPNDM5L1hYZWdIWENU?=
 =?utf-8?B?MUE2Q2tTZ01HQXNQZ2IzenhkZUc3TURNRk9LczZvTUpHUVBjbmNoZzdvcmJa?=
 =?utf-8?B?VWJKOHBienRac2g0aWE3Qkdvc0J3eEIwWFZ1UWs4NTNiRmNKYWZ6clRPVG9X?=
 =?utf-8?B?UDkrUHo4aXVvdXlkRXBESm01ckw4QTFFNTdCVTJBdDgzSUtLVDJLRktHemN5?=
 =?utf-8?B?QkJYWW1tQ1NRNWh4UjFpdnpJZVZTeXNrUFh1bTgxeDJGQ2tjand4cEsxcVM2?=
 =?utf-8?B?RXpha2JZQTU5VS9zdkdEZ2RVSFJsYUZKa0gyNzZpb0t3SzFtSDQ5OWZiQnJB?=
 =?utf-8?B?b21rNGF4S0loNDNWd2ZTS2lBMktnV2ZtZkhINVBSRmMrMnBoT2gyUk14cTc2?=
 =?utf-8?B?M2EwV1RWS1ZrZllPQXZreXEzZFVoQWxhQ2NCWE5hVVlIZnFXT0V6eVlaaytu?=
 =?utf-8?B?N2g4cVNMOVNGaU9taEZxK2txaGFMSlZVdHFlVzQwUkloZ3UxZllTbTc0QkNh?=
 =?utf-8?B?dXRuelQvL1FtclBaS2IrYWh1MElmN3o3VDBrUjdySkNwZmprNHoyMEFHMzVq?=
 =?utf-8?B?UFpqbWNvVzNpTlEwd0p0RURxdXdLUmtxcHpXUnlsc2UwNjZOU0lmbklOOEE4?=
 =?utf-8?B?cWpQbWw3eTRPQlE5c1dwUDErVVpuRGRZVnpvOTIxc3FzNThFRGIxUjAwTVVR?=
 =?utf-8?B?ZHJCUE9nL3EwWXJ3ekFkbDZDVWdZUUpHdGgwWDRmODl3R0EyUjhJOE84Mnlj?=
 =?utf-8?B?RzgzazhDTzcvY3hyTkFkTjBQd3d0aTdidkJadkVQTVZZRFpueHU1dnk2YlE4?=
 =?utf-8?B?UXVyc3B1RXRmSjNzMTZMNzhueExZWS9zOWJReVlmQkpNejJQL0NidGtjSnhZ?=
 =?utf-8?B?UUhLTHRNVUxsNnc3UDZ1K01MVTJsb0RvcEhVejBlWmNIa2JmLzJNelFObVRJ?=
 =?utf-8?B?bzFQUE5Db1A5Rk9OWi9QN0JLVmVnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a2919fc-9384-4a1f-fc5d-08db20a9b60a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 14:22:28.0198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2v1XVpsx4J8q74Z+gcmoTtWEItzWGhBSM/AHthNZdVOimw8xMNKJeNSXFCsyMcu41r2cllHoj1JcGvky9jCf+iKa5kgz1v3JCFC4e+JrTvY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6220
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 10:47:02AM -0800, Stephen Hemminger wrote:
> Cleanup and rewrite netem man page.
> Incorporate the examples from the old LF netem wiki
> so that it can be removed/deprecated.
> 
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

Thanks Stephen,

some minor editing suggestions from my side.

> ---
>  man/man8/tc-netem.8 | 423 ++++++++++++++++++++++++++++++--------------
>  1 file changed, 289 insertions(+), 134 deletions(-)
> 
> diff --git a/man/man8/tc-netem.8 b/man/man8/tc-netem.8
> index 217758541dea..b7172cddf955 100644
> --- a/man/man8/tc-netem.8
> +++ b/man/man8/tc-netem.8

...

> +.TP
> +.BI rate " RATE [ PACKETOVERHEAD [ CELLSIZE  [ CELLOVERHEAD ]]]"
> +delays packets based on packet size to emulate a fixed link speed.
> +Optional parameters:
> +.RS
> +.TP
>  .I PACKETOVERHEAD
> -(in bytes) specify an per packet overhead and can be negative. A positive value can be

nits:

Maybe your pronunciation is different to mine here.
But for it would be ' specify a per packet'.

And perhaps: ...overhead and can be' -> 'overhead. Can be...'

> -used to simulate additional link layer headers. A negative value can be used to
> -artificial strip the Ethernet header (e.g. -14) and/or simulate a link layer

'artificial' -> 'artificially'

...

>  .SH LIMITATIONS
> -The main known limitation of Netem are related to timer granularity, since
> -Linux is not a real-time operating system.
> +Netem is limited by the timer granularity in the kernel.
> +Rate and delay maybe impacted by clock interrupts.
> +.PP
> +Mixing forms of reordering may lead to unexpected results

Missing full stop (period) at the end of the line above.

> +For any method of reordering to work, some delay is necessary.
> +If the delay is less than the inter-packet arrival time then
> +no reordering will be seen.
> +Due to mechanisms like TSQ (TCP Small Queues), for TCP performance test results to be realistic netem must be placed on the ingress of the receiver host.
> +.PP
> +Combining netem with other qdisc is possible but may not always
> +work because netem use skb control block to set delays.
>  
>  .SH EXAMPLES
>  .PP
> -tc qdisc add dev eth0 root netem rate 5kbit 20 100 5
> +.EX
> +# tc qdisc add dev eth0 root netem delay 100ms
> +.EE
> +.RS 4
> +Add fixed amount of delay to all packets going out on device eth0.
> +Each packet will have added delay to be 100ms ± 10ms.

maybe 'to be' -> 'of'

> +.RE
> +.PP
> +.EX
> +# tc qdisc change dev eth0 root netem delay 100ms 10ms 25%
> +.EE
> +.RS 4
> +This causes the added delay to be 100ms ± 10ms with the next random element depending 25% on the last one.

Ditto.

Also, possibly
* 'last' -> 'previous'; or
* 'last' -> 'most recent'

> +This isn't true statistical correlation, but an approximation.

"isn't true" -> "isn't a true"

Also, possibly:
* '... correlation, but an approximation.'
  -> '... correlation. But, rather, an approximation.'

> +.RE
> +.PP
> +.EX
> +# tc qdisc change dev eth0 root netem delay 100ms 20ms distribution normal
> +.EE
> +.RS 4
> +Delays packets according to a normal distribution (Bell curve)
> +over a range of 100ms ± 20ms.

For consistency: This delays...

> +.RE
> +.PP
> +.EX
> +# tc qdisc change dev eth0 root netem loss 0.1%
> +.EE
> +.RS 4
> +This causes 1/10th of a percent (i.e 1 out of 1000) packets to be
> +randomly dropped.
> +
> +An optional correlation may also be added.
> +This causes the random number generator to be less random and can be used to emulate packet burst losses.
> +.RE
> +.PP
> +.EX
> +# tc qdisc change dev eth0 root netem duplicate 1%
> +.EE
> +.RS 4
> +Causes one percent of the packets sent on eth0 to be duplicated.

For consistency: This causes...

...

> +
> +.PP
> +Example of using rate control and cells size.
> +.EX
> +# tc qdisc add dev eth0 root netem rate 5kbit 20 100 5
> +.EE
>  .RS 4
>  delay all outgoing packets on device eth0 with a rate of 5kbit, a per packet

'delay' -> 'Delay'

...

> +Netem was written by Stephen Hemminger at Linux foundation and was
> +inspired by NISTnet.
> +
> +Original manpage was created by Fabio Ludovici
> +<fabio.ludovici at yahoo dot it> and Hagen Paul Pfeifer
> +<hagen@jauu.net>

Missing full stop (period) at the end of the line above.
