Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472106EAC42
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbjDUOFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDUOFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:05:30 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2123.outbound.protection.outlook.com [40.107.95.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3407D1BC0
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:05:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWRF81PkFvHItMN5ox02HIWRdg1EsPH8VyC+JfG5RcNMquvYHXVmmjAI7KULVCAN4bM9oUTRro60VkgMUqzhNbfJkIHRm4uKAFUfk+TqQIxH3SjGnN7+lPzszjV+G7ulFMs/+k5FYZAkhGCIQgwV6Wn6idfIKncdtbtkml9EJbpAbPBz8ymFQiLJ4lDFoNurSx2A0RV+fEg+8T4qotHezR3o3eieA7v56N0GbyZhwNpyjmHKuAbre+MSTSlIF6lLCVrIUtBWyCAOXAKXUWkBpMfpZ9HkhIkeihpTuK6/5+XB0KvXkLd31Yq1rhmKO8/GET2y58mBZxp3FuEgQjDdDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Sluy9xKkf6y0ijBmpG7UonPI5lY8sYWG8Mj77lZw1I=;
 b=TdensNDn0wMMRbh2ZXMYhiQHh9/zVEcW9K5kVLQZvni/QvOdxEBNUI0hZXSWmZmXJbr6ZhNcmwWULz2kQq+Zu3R/t2eJ/xlCFWEq5MSQjRZFfyTmBn8N3bPjtr+2v7xkI8MWL0Nn3Ae19oUZkzrK0+UrZt+0PYv2a6MfgRKVl/vTATYEuvTjl74IbCTwlR9pQkd7MsOEvUX1/mvl7hNajELAXgfZ42chIP4g58MsJznRIs48oiUm3xNwoAxyHoUF7hp16MBgKLyzt7zJYbmuFmQvivOi13mdBWgh/8nv0lpbUzlZZ0CU+gMm1U/E0itBPuIQN0EJpkiUnxPqq8kdbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Sluy9xKkf6y0ijBmpG7UonPI5lY8sYWG8Mj77lZw1I=;
 b=Y1peYXWYnDzbtM6aXZpC4EtO0VFjRSNx40gg3JDjqV3bBSuldlJK3v7r8HpEMfmpT2ZGfU+RaT6phKgeCEVxR5++kJEgjEQM8wrL+z2cQsb54LwvPm0kat0QjwcytYs/v/lxYfPdKscofwOHqkAS5lL++LL5kI7XLa8C+K/NQ2o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4095.namprd13.prod.outlook.com (2603:10b6:806:98::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 14:05:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 14:05:26 +0000
Date:   Fri, 21 Apr 2023 16:05:19 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, daire.mcnamara@microchip.com,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs
Message-ID: <ZEKYH0FblGmAOkiP@corigine.com>
References: <20230417140041.2254022-1-daire.mcnamara@microchip.com>
 <20230417140041.2254022-2-daire.mcnamara@microchip.com>
 <ZD6pCdvKdGAJsN3x@corigine.com>
 <20230419180222.07d78b8a@kernel.org>
 <20230420-absinthe-broiler-b992997c6cc5@wendy>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420-absinthe-broiler-b992997c6cc5@wendy>
X-ClientProxiedBy: AS4P250CA0010.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4095:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c92babf-1928-41a6-bd83-08db42717466
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6WlkspEaMhTs+1WioxpCciGAjFdlHbJHk5Kge3Hj8V4e79IMkW6dT8gTj3ifKr6d0Qon6OONcmRag0tKQFwouT7SV7YhgI+g5dZ1wvPAottH72liImAu6JYB7dpoUNusUIIDJjIZiTZUOQA4PcblX+2Wt7ibqjhxUCtueUg4Td054oWwDu1ooD5YX/+sf9mVQK+fh2yXtTIw7lsqnPscAna7rpiy1EzgAs8Hd5TewqJzh6kVuXrD21LZAxxMuCFTEIUTBFujFFMk0IB8pPGIo6AzL/pe0/Grxz3UrdBEtDlSZgQzacq3nhqs0bp+IVZLLuwUrlZuZUwzutQBkAiZURtbv+qn4bHl8sSFJVsBroh6tRwJz8VNVjJC/HFl1uRHkPOo8H6qefXaj166mED93lS2Xtc5p+ZxFitS1Z/bMh+RK9KNm/eeUeGmp9C+uFzbMQbVsprxQETJQ0jc4EDYwwVhAdzxboNGYjvqCtLC+wEKcltO8vKADoivdDQ2iIenH7fGzfAgJMRLWZ9050o0IBsvkFCMmsPtDsmvZxuUeqWwedavh+Kb9pwnK/WKII4wufMttU1eL0I07DnFsjMYCkUWyZJEEvM9+uL7JSj9CYI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(39840400004)(376002)(136003)(451199021)(478600001)(83380400001)(2616005)(6506007)(36756003)(6512007)(186003)(38100700002)(86362001)(6666004)(6486002)(316002)(8936002)(8676002)(41300700001)(4326008)(6916009)(66476007)(66556008)(66946007)(5660300002)(2906002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BgI6SlsqhBwtzz0zPlREUHi/e/ZJrXRG9sqZdtU11w9UmeYe3W1XNobCJ82H?=
 =?us-ascii?Q?lWJEdi04PdpgJGZFpwgOQCqS9F8gm3VuKiGBASGCD2mm34PxF2aRcOckFeET?=
 =?us-ascii?Q?vwVhJi+GiCg4v4ZHg54B4fyfYGiEXl8OMWVRHan/6dzrG84aaTylFpDVQamD?=
 =?us-ascii?Q?MGd/+RxWj/pzLdrdzovmYvdXowc6MaPPMw2PsfRApp++mSnifzR19YiOzNsm?=
 =?us-ascii?Q?Ew2yRSKQvKw2Q6Aoq6UivPUVP3H5pDf4Op/prQCcF184gaKqJ8l5wu92iYY/?=
 =?us-ascii?Q?x3Qm5PJ3GBlnRnNLYvg+ckOqjQK8oWsiAB7SFBSGceJMyO4CAFqhHmj+FX4B?=
 =?us-ascii?Q?prpGYu3l6k3c2mJjyHubALWiLIrGEtTtUxEO1WIvDl5OeLOTk81aQcbPitPK?=
 =?us-ascii?Q?6v5UHDN54W7/gvorsl8ci/jLl8mtO5mnPvkIbrrHx1FQqF2LhnKYtJkxuoIG?=
 =?us-ascii?Q?QzOTZ7k6NpfwDKiP1D2Duc46f9i2M6LZXJJYceFVK5Jt5WTg6Zk2tt/c4Bnt?=
 =?us-ascii?Q?eR5NvAhA4kpgQxmjieik1BFvJOWr89qJYHlnC26SQwX/thXFhURJAwIuf87y?=
 =?us-ascii?Q?We3ysSqetBkGMR7P/LjnVO+OO0RagLFRkN0/iEJkPqKD/YN7kAus5BKTcV5e?=
 =?us-ascii?Q?NDbbXefxdYy2wFn237J3KzOHTGXbIV1BB1e67WtrRBueziUMeSIlGw8GrbQm?=
 =?us-ascii?Q?ReyhEvbOKcxzGJ3pefB0utoHf0WLl3UOa0FH4JRAEO9UWq+ZyeZx7G0UiD9/?=
 =?us-ascii?Q?bSTGTseFpI7/ZaqTtbgzCltKFjzuPz4UbERhf2OsxcNSDMK0jFiSN2teYz8b?=
 =?us-ascii?Q?cC8/ZbgD+8gd+q5bXq7grkS3pYK3yRloA7fxB/XbSdwwo5K+xUiRYsjVsPVg?=
 =?us-ascii?Q?IOcvyftkVZfBG1hJYqyY78V7X2gOAsx5YeuiBk44MD0+UOy2k3sZJb1xLRhd?=
 =?us-ascii?Q?3WpLzVGtBBPUvTnqGnFttNDn6s5pAlwflZ1GdXai9kmQo1SXP3bpZBj5zjBG?=
 =?us-ascii?Q?4lRmiqV9p4lIBJJrTFOUtJxfeYZp9PlNJLPrvVxHcFI6BRvr1/fcySskmbVH?=
 =?us-ascii?Q?0Rifz8BqfqJIgy7sQ/SFdvdK5lf2jpJ+ZzYwyD4yJny6g9oY8E5G0PdJXoiG?=
 =?us-ascii?Q?wXQotguTuuTUYGQg1VJ3kzHXxdWVATPCRdvKFWhtxS3ycj/hn308Rn2zVDAo?=
 =?us-ascii?Q?X6ljkwlqovEpDtq5ebts3u9vBjeORHwJ0CPHys0U994iBMnrfMGwNROm1pOF?=
 =?us-ascii?Q?9z9iKbKY8vsqPA10JmZkwdlU+7FhYp5+wbRzadvvNw0H5gYC15R7OLQQN07p?=
 =?us-ascii?Q?hmVuC7g2J00Lid0F8SRiK8T47ZM/+WnmCeW4/KNDaNNUNmio6H7XA/l3B9+C?=
 =?us-ascii?Q?RA1pu0JY84awJ9mLXw/4t7jV9DEXGELYzVAZNle6VkZYPE8t551S18D6MzaU?=
 =?us-ascii?Q?QBtwuMqRdGkMVwR96ZsThWE5KlIHXQk0fO/cxd2pqVTyW+Ob1NNl/6jHs+hG?=
 =?us-ascii?Q?OcYeILeLy/H0Y0oBEes4FcJ39QZIgrrjk8aw24s7OU4BiwZaJfa79a6SzSFw?=
 =?us-ascii?Q?zcL3N1Tv+AxB52kkQaGRYWVJgQ7vGlmkEnPFqpUQzEL2YsZ/A5d+hilNER/L?=
 =?us-ascii?Q?by37/cnvR33iyGiHaRfEILe7DpcQ8RguvC2Ch+gKOeGCD7e+NdmC26nOj0Xg?=
 =?us-ascii?Q?WldBfA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c92babf-1928-41a6-bd83-08db42717466
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 14:05:25.8430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SQKO28BT9dlcj7ceYpliAXOB4SB0Wr1snlg6WiXDKTEDjbiqqF6E/OU6ea1eVTmz2H5kdgY/oHI8yHzpKWLIKrwbdWCfCYF6RTclzT1fRUc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4095
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 08:18:35AM +0100, Conor Dooley wrote:
> Jaukb, Simon,
> 
> On Wed, Apr 19, 2023 at 06:02:22PM -0700, Jakub Kicinski wrote:
> > On Tue, 18 Apr 2023 16:28:25 +0200 Simon Horman wrote:
> 
> [readding the context]
> 
> > > > static const struct macb_config sama7g5_gem_config = {
> > > > @@ -4986,8 +4985,17 @@ static int macb_probe(struct platform_device *pdev)
> > > >       bp->tx_clk = tx_clk;
> > > >       bp->rx_clk = rx_clk;
> > > >       bp->tsu_clk = tsu_clk;
> > > > -     if (macb_config)
> > > > +     if (macb_config) {
> > > > +             if (hw_is_gem(bp->regs, bp->native_io)) {
> > > > +                     if (macb_config->max_tx_length)
> > > > +                             bp->max_tx_length = macb_config->max_tx_length;
> > > > +                     else
> > > > +                             bp->max_tx_length = GEM_MAX_TX_LEN;
> > > > +             } else {
> > > > +                     bp->max_tx_length = MACB_MAX_TX_LEN;
> > > > +             }
> 
> > > no need to refresh the patch on my account.
> > > But can the above be simplified as:
> > > 
> > >                if (macb_is_gem(bp) && hw_is_gem(bp->regs, bp->native_io))
> > >                        bp->max_tx_length = macb_config->max_tx_length;
> > >                else
> > >                        bp->max_tx_length = MACB_MAX_TX_LEN;
> > 
> > I suspect that DaveM agreed, because patch is set to Changes Requested
> > in patchwork :) 
> > 
> > Daire, please respin with Simon's suggestion.
> 
> I'm feeling a bit stupid reading this suggestion as I am not sure how it
> is supposed to work :(

Hi Conor, all,

just to clarify, my suggestion was at a slightly higher level regarding
the arrangement of logic statements:

	if (a)
		if (b)

	vs

	if (a && b)

I think your concerns are deeper and, in my reading of them, ought
to be addressed.

> Firstly, why macb_is_gem() and hw_is_gem()? They both do the same thing,
> except last time around we established that macb_is_gem() cannot return
> anything other than false at this point.
> What have I missed here?
> 
> Secondly, is it guaranteed that macb_config::max_tx_length is even
> set?
> 
> Also, another question...
> Is it even possible for `if (macb_config)` to be false?
> Isn't it either going to be set to &default_gem_config or to
> match->data, no? The driver is pretty inconsistent about if it checks
> whether macb_config is non-NULL before accessing it, but from reading
> .probe, it seems to be like it is always set to something valid at this
> point.
> 
> (btw Daire, Nicolas' email has no h in it)
> 
> Cheers,
> Conor.


