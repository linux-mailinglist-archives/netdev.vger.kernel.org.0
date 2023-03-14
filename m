Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7A76B98F9
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCNP1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjCNP1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:27:11 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2122.outbound.protection.outlook.com [40.107.100.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B671FA9DE4
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:26:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKs2Tgu798UmReEPtDrHw/onHU/RslDzfepmNh3AMHu/35U/FakcoAQcuEOJn3n86n9PKpf+VaGj04NfTozo4ooCGRm8+nz/XRvDIQJh8I2pSXbM05HRITtxkTkAtLZO94iiYUAD9WhieNWepgTnnBOS3HUDk/gaXb/SBz/G7lyk/WQf2i/3Z+DFlCSoIA2jiB6WSM0MJDw7g9Hk+rJdvNnBoDDVo9eOmIdketzfr9rSkx5MIN1CdeeSLqI6J9qSpwYYFY/IG9nXM8ZmAL1M9bj+E5EjauXG8OT9PixvcqFOeL2JKTDADm1OPqGkhs6r3ulbgWVmYO1ex+c3kY/QZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WTsBn03GLUXfKTs8bQ56SbvbMDlGPuokzfFcCPIiWOg=;
 b=kkVsDfr1INlmnHH5uWgNnGpN+0XRhYxZJvquIcGhl2VMSd7fiS1CRw1ZaRpZZwYywKs50vEdvyjnaitpcSH096u2lVFO4z5G6NSf/oOvYYHpFfQUpehBo0lnbJtE2lNDAC1ohiB/qaWn9GJg8HssEBiP7DWsVhMNWBajB7CSwb3rz0tlfhcpJ6laCw9JClxyS9Lypw+moj6sfLwk/a7hSJBFhCgGSbHwZuyaQTmqh3OSPxq61QbVIamNdgVqKqhKScuXVoCWA+sAATdO/qkKYD6opwwah+CndbLunazNX5p4xU2ie8Dh5h+bBDpU/be6OfgPMsk0FFzoLWOVjjZEIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTsBn03GLUXfKTs8bQ56SbvbMDlGPuokzfFcCPIiWOg=;
 b=BYj0Jb5lbnAF56q8yGMs28ccTO92K1s/KdbE2TFTeTuy4v4HSDM6orMpM7iKw5OIThM4g1iXMZbrRprioo7QWbk6vuavaUB9fRDO4WQcGCy5R6AmGKG+gv9+g1gPxUp4Sr8yzKeHtYAmEPvYWhZg5sARKRzj4+QITL4GNs7jwfs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4057.namprd13.prod.outlook.com (2603:10b6:303:5a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 15:26:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:26:56 +0000
Date:   Tue, 14 Mar 2023 16:26:50 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next 3/3] net/sched: act_pedit: rate limit datapath
 messages
Message-ID: <ZBCSOi6y8w8NUtTe@corigine.com>
References: <20230309185158.310994-1-pctammela@mojatatu.com>
 <20230309185158.310994-4-pctammela@mojatatu.com>
 <ZAs83FgjdfizV3Nh@corigine.com>
 <dbdb0bf7-2bc6-4002-d7f2-e561d6120856@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbdb0bf7-2bc6-4002-d7f2-e561d6120856@mojatatu.com>
X-ClientProxiedBy: AM3PR05CA0090.eurprd05.prod.outlook.com
 (2603:10a6:207:1::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4057:EE_
X-MS-Office365-Filtering-Correlation-Id: 762acfef-60eb-4098-7450-08db24a08bf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +zyJmGU8QlGrLtx5lWytLE3vbSxHbCx3kiL0eAi2EqB+4A5vDAepL2HcXxnP8+gX6z7CUaoYlaPcLMyZKv9gpkHuWhzRGug41J3dd097Tn50QWHUZte5D7lh5scBi/r7yhPvRdI4WlMhMtWNuqvULEUQCECVXr6fiCm/6dGRRvCpc1xpTC4AsjmxbBt216jvoG3kxWqe0WaaBVLAI5xZqqzTcJGDcd1iXCGcXVHi8g6mZ2Gy7QRXSIiez+twppOfklxwWcNq3Z1wpbCV0kepaKCK1BIYiyK0uzCvX9wM+ME/oyUP7Dul8aErc4qFcEfJaMWSRDtxY1uxSKia3G0xNVghGZnLwLhaz47O8BWe/jDQq3hcDKR6nEvMbTqw3JgidHP8Pd5EzmM/ooVCYKDlpaG8dbxA0wsEGEVzBMqFibcyHdXXOmERS/MIZ7nT12H9RigJZcTaRY40kO2YUVw+zFrAVu6DYBhiP0X+Kx4zUgr9pVXVHhMKwyozAEQOIpBKDjUYcCb4sn0xSEsGafMNxBXPBo4PQVNZAjhPZ3Hm0fvH5cVGGRzWjlA9ighKoY8xo0mgSB1gXEtEEqIvqHKlZfmyxCxcjtD1MQuQdmZMPqblMAuHFXU7VE2W0njST28V2g/ac7nnafnsJKUeLxrudryjkzdaIZVCcrjYp9Zo6eZNDxOGZPRtEHis17yzDgop
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(366004)(136003)(376002)(39840400004)(451199018)(15650500001)(2906002)(83380400001)(5660300002)(36756003)(44832011)(41300700001)(66556008)(66946007)(6916009)(8936002)(4326008)(66476007)(8676002)(38100700002)(316002)(86362001)(478600001)(186003)(2616005)(53546011)(6486002)(6512007)(6666004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y73/Ekz6ZF6vpHoIy5Txww4LD23zLytUrxmSkjNofyOQQvVWcdxTiZRvEg12?=
 =?us-ascii?Q?SJBz1G1dAuAr6/AbdxW7p675sfr85K2RX7Rh2IE0iRGesH3jBCiTXb1Zf4Ld?=
 =?us-ascii?Q?YPtR0Nc5j/EE25bToYzAA25bIF3tcy/aX2jtHL/2poNJoulqSsbdD4iQMw6G?=
 =?us-ascii?Q?upJmiR/JVh5+i0lKoN6RonyHtAljB+GzQkGIovV+TkUz9H47VdnipAHNmyXN?=
 =?us-ascii?Q?wADkjp6IrpCu7dpOVlVL5RJi4EVnbnwGhr/cckxEq7bC/Se61ij0JxS+1epp?=
 =?us-ascii?Q?sMLl9q7WVknhKrYFMS6AKkZ1DwUfNjdP3RwfpyI2M6CENS9OJn3Wdl11e+q5?=
 =?us-ascii?Q?fb7W5Uv4Ze9gtl3SkhrrRx0srwOHLTyBJFjIzLQa1/1jiCgPIYEb7wSUW8Rs?=
 =?us-ascii?Q?rEv8+sdklolYlEqcVqWud0JrbU9HGU4ZVhDLMi+zGfQm0i6VuCfMH6KjWn/D?=
 =?us-ascii?Q?OPNJqssOPrpmby5YvISeJkoFapHGOtxVcqUdLa1r4697p1SXOz+Eh1mp6kIO?=
 =?us-ascii?Q?bzHPRat3dReUfQATXKr968ww3rLHwHwOC93GA6+dduQGWzLY9xOtwMYC6QJF?=
 =?us-ascii?Q?WyFmzGz+SFav9s+m6uy1PruAeDOBzGw2ev9z7eVOleboNY+rFHsnZfq2+5uc?=
 =?us-ascii?Q?R5MOVO8KbOqRZWinmIYsSei+pg7fkNSJR7yLY2HPPCgZPmUNKe7ir5hrg7Os?=
 =?us-ascii?Q?1SHSco3Q20sRw8iNmnhlAMxhOtFk0BQPi7RwOcM6CGdjuEqU++YtmgOxn0WZ?=
 =?us-ascii?Q?p2iXa51pxeJiOXBQr8+EzZySMDpth2xrae0ohnu11/QSQUtnWHPMkRWJf7y8?=
 =?us-ascii?Q?BwvJba3qGHK7leIe4uFAEJHHz+KqtP9uvHoXQTY4KIxmniB5wPbLtWRmFPfm?=
 =?us-ascii?Q?eb+e7B6+xh+orM+C/s8O3Ef+IzV2hZVPif8n7pZmW7vOw3frR5U+HBnsBv6Y?=
 =?us-ascii?Q?BiiAmw7BM+l5R6QwPOLaDSTtI6mFE7gaCjqgFtcm6T7jbki8XNNrJf2Gncqo?=
 =?us-ascii?Q?qLW1SO2dcr7fQWYWHYpid71jBIFCcfLR1XCCmniq8uHe3x0fxacMCwBCQ62N?=
 =?us-ascii?Q?BiE1mGbA0Vy737KJI5L+YUUL04XAqr3JVD+Uwzg4715N8lCKyTAnM2EuOR1J?=
 =?us-ascii?Q?myRpUAaddNYSKM+UCr14wjioYcWiCg6iGOpctRbUENvWbrm0SpRRZapqenPg?=
 =?us-ascii?Q?/p/bVKNCM85nsraF1E2KNrXn0g6md/TB4GtKEUbplIj2E4WNsFLPnwhnmkw6?=
 =?us-ascii?Q?IQbl9mqelZnPHHQpx6aswW78aYjRrGSx5K/i8R1FUDmZe+9SqUQL7PxnuEbY?=
 =?us-ascii?Q?eM/9U88wsOrOy2fxFNYHONRJZn1kZvA/1cRkcwl4NWebR6SpNKMrgtJFZ1VX?=
 =?us-ascii?Q?NdME0weutLbMIDipWZyy44Gqol4Nt4K9N1N0MaEX2LfSACMCrPUs/6b6RC/C?=
 =?us-ascii?Q?yb4SXmuQ54PpYmfOIFs+ZukEjQJi3jA4XfS+qT5CO4fkusKGbuwUYbueSeyY?=
 =?us-ascii?Q?X7qCnUdb3+gTr7XS5zOnjS6Um7P3bpY1ghpqUklbIx6C6BYIZBNiOh7X5Lsf?=
 =?us-ascii?Q?SxAbZlSJgTHs4Fjdcc4Y2mgGKHw56wqh5zQ90kxocMpH+7bCS7NuHc3JbNJc?=
 =?us-ascii?Q?af8a/LV6ZenQUOFiGqjfjGx4vr50aeEd7npX9WAHwtK+YbziaFVQzXMNzg87?=
 =?us-ascii?Q?/CyGjw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 762acfef-60eb-4098-7450-08db24a08bf0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 15:26:56.6246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aPoXK/36q6JdKARob3DBM4M8Uo3CfzMF7w5HCoj3qKfJQdSl2Kc+7+1HPUtSiZHtWA78+tmhNwcB7msYHQhGtIJoSIr0WmKe6CPxe78Av6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4057
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 03:24:47PM -0300, Pedro Tammela wrote:
> On 10/03/2023 11:21, Simon Horman wrote:
> > On Thu, Mar 09, 2023 at 03:51:58PM -0300, Pedro Tammela wrote:
> > > Unbounded info messages in the pedit datapath can flood the printk ring buffer quite easily
> > > depending on the action created. As these messages are informational, usually printing
> > > some, not all, is enough to bring attention to the real issue.
> > 
> > Would this reasoning also apply to other TC actions?
> 
> Hi Simon,
> 
> So far, the only action that has datapath pr_info() messages is pedit.
> This seems like it comes from the old days, according to git.

I'd be in favour of unifying things.
But perhaps that is a topic for another day.

> > > Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> > > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > > ---
> > >   net/sched/act_pedit.c | 17 +++++++----------
> > >   1 file changed, 7 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> > > index e42cbfc369ff..b5a8fc19ee55 100644
> > > --- a/net/sched/act_pedit.c
> > > +++ b/net/sched/act_pedit.c
> > > @@ -388,9 +388,8 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
> > >   		}
> > >   		rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
> > > -		if (rc) {
> > > -			pr_info("tc action pedit bad header type specified (0x%x)\n",
> > > -				htype);
> > > +		if (unlikely(rc)) {
> > 
> > Do you really need unlikely() here (and no where else?)
> 
> This case in particular is already checked in the netlink parsing code on
> create/update.
> I was gonna delete the condition initially but then thought of hiding it
> under an unlikely branch.
> As for the other branches, I didn't see much of a reason.

TBH, I'd drop the unlikely() unless there is some performance data.
Perhaps you can drop the log entirely, can it occur given the checking
elsewhere?

> > 
> > > +			pr_info_ratelimited("tc action pedit bad header type specified (0x%x)\n", htype);
> > >   			goto bad;
> > >   		}
> > 
> > ...
> 
