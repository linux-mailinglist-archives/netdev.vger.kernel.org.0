Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D21869F050
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 09:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjBVIea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 03:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjBVIeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 03:34:25 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2135.outbound.protection.outlook.com [40.107.220.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1678367CB;
        Wed, 22 Feb 2023 00:33:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNpXrRaPVe6Se3cRblUPiLxakBBQu7pSYVAaFrrjWXFOzHq74jpNdeAtSCX9RPOEH3B+T+95/9U8mW54tTHKAG5LesvwxP/Y9uYsx15tfuy8/ISGqNjywuYrQtriQPztBAt2XNzzqKBo4k6mlSPkuoAqRPDylzLzjQJoXskcmWkSEqpufHuktcInOPFJXFNBo/5AUzEFptblMjNlo/ciNIsyBfoGrn9EX3I6fob5KlqvId+uYjoqtRBXCH7liXIpLemIqruxUH94DYQSivWP1aje3ibJ32Hqfk+Cer0tmA3WVPmMuinJOBu0Z2xLvnrN84ljh64cz0j9f1Jno0XbgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8yeIAipMFpLB+4hT8DAjmhgvpROd8DN37nu5cEIKH9k=;
 b=CeIq8TsWRQQHi/BbB4bd4nZFP6scONv+OVgbzsq3Cz+vrE4n9CBURDgMjW2934bDfssg03UpQOUMhAHtXIeJltDydckXrKnrW4nFQjx4vBJyg0Hvzx15OwDD5U04mGGz7FXLP15WFzUZFn5r59mgtWhdxOIdI0sWteKteiUiC/KTKkC3JJGdgEQC8f+gbXEG7NjKnC9WrNxQD41HftiFTSsTis6pw+khsbxy7rAPzbHcDDmFitb1yu6TnWRhOrt8aIudAdZfdpfboppKEoxW3vO81ETWQfK1Osx9sZp7ZyhKcyif4ksmZ7WJdNUEHJUNOA8qNckZWAnKWaZm1UJqZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yeIAipMFpLB+4hT8DAjmhgvpROd8DN37nu5cEIKH9k=;
 b=c8iTqhieimXYsexiiV6i9kp5o4JaDrAzCjU307wo1PgdaYb+oKZphhYgc/C3Zlr7+uEh1E4QYYJrdTCt5XHC84pVjyT5K+018jsC8F/AY74V49XSG5lZXsmAGgt1km89SgrlhWRF+oAYN2ZsInD4SwJ/2NqPqhW2FB+cLp946ns=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3939.namprd13.prod.outlook.com (2603:10b6:5:2a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 22 Feb
 2023 08:33:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 08:33:55 +0000
Date:   Wed, 22 Feb 2023 09:33:48 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net/smc: Introduce BPF injection capability
Message-ID: <Y/XTbFvYYJevb18V@corigine.com>
References: <1676964305-1093-1-git-send-email-alibuda@linux.alibaba.com>
 <89600917-ec58-3a30-dea7-bae2d67cc838@linux.alibaba.com>
 <Y/Twbebt2p1TEsrl@corigine.com>
 <8742afeb-afbf-3079-21e7-a52b32ff3ecd@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8742afeb-afbf-3079-21e7-a52b32ff3ecd@linux.alibaba.com>
X-ClientProxiedBy: AM9P250CA0002.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3939:EE_
X-MS-Office365-Filtering-Correlation-Id: adef6758-0b31-41ea-f215-08db14af88ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BCjtGxRWPQO6CjbBqWjL9XHAXQnyAYF3y7N8bOIHQxfTNLHm30wcSo7SL7DN37DbW4tANkR0iAUV9k8Fcge6EwFd+QxgkUL0GKs/YjcC+UCOnhNKYmL4eJh2oMERM7fYWiKEGHE8wE/aJ1dBuh7uyOB3P4dHXImESaqXZXeCYWyEbd3J0YMSBiZ61IJj4upXh8i4zANKtM0vV2Sz+JeOXdx7Es1/pLW/wUZDDRVx/nNwHfYRI12rFCCerHso94SjC5s+U5qLxt2mH9e/zuuAfHiSv8U589K1z8R9qYGkVw+U4eBHvfZTh4TNrh/WDGEhDlVafz6Ud/89ai0ss66zEUit2+IjjP5vqLqUDeNmq54Jop3r4dG4NWd5Ol1weI6eVWzFLfyWeL0fIdiBWOS+BHstxajmovBcJEQS4MHp4pxtdREBQULD3o1Laj0Hf97BjlZxUlrBfT4t0KeAENwK4duPICeUvxyCLAYFO8PA2GDMXSXR5/D5xojeyMdDV3WOe7hAWJ0WINLLcC3Li2b7Ee7t6cfvRGn7ojTjjGIpJEyFmfOiRONZ6e2qy34U5x3HfhaHULTVjfVazSJP+s5TogJq1V84w9ggg9+7qiU3Bjw/BEMBe0hy5c7rcNd+gwsSzfOlEawMIDb91HCO/itJ5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(376002)(39840400004)(366004)(451199018)(478600001)(38100700002)(4744005)(86362001)(2906002)(44832011)(316002)(41300700001)(36756003)(5660300002)(8936002)(83380400001)(66946007)(66556008)(66476007)(8676002)(6916009)(4326008)(6486002)(186003)(53546011)(6512007)(6666004)(6506007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+oWKC53Kc10LXvGzUi4mZ5lc+dq6mcU8TZX6cLwj0CHugOaeEQa94ZoaLxA0?=
 =?us-ascii?Q?fEyNbWQb/bsIeCPqHMx//gyMP6fclhAmUUbk6GMBh6OO1UM7j0XlBBKUPtwS?=
 =?us-ascii?Q?06W6URkHsM/VoMkZbquns8dp4HtrmxSRoq4m88L5Fjq3ile18uY8zFvLClJQ?=
 =?us-ascii?Q?H1kwxBSbq/8gpfJB0NtqsImCl/uiVbZUOSKuofSX5QrxDmE99d2mlF2pi+fx?=
 =?us-ascii?Q?5pwznrTeLNvUP8fu8tLSn3662L0n98uL7jisERbThUDM4vw8Ld7027ruBrKT?=
 =?us-ascii?Q?4+sEb5wV1I/ooGPTakXV0fEzWSvJnFkSXAiT5xc7kED6T5QqQWsVuO18ONTJ?=
 =?us-ascii?Q?3QbjkSuBBTUsaczNo3SDLK/V8n/M6zvnXjg7Jy+Bsjy5GtQ12kOtz/A/bb5X?=
 =?us-ascii?Q?ECk2l7Pa45/h297SK5TS7mHR1tRGNytJ5rOtNqDgLdHa5hBDt5sbX6Qqi+4J?=
 =?us-ascii?Q?SA0TyDpEoBADI02sdsOo2zYk3VkNxGS61fxWUB8ypr6qQOz3qSPt6bvhRsun?=
 =?us-ascii?Q?/hNM/ZUyoVwNKvV1Pei/lFRaZOnarrSjBNZby65Ba8HtYnqZMon61l/Xcx+f?=
 =?us-ascii?Q?M0BvFOoPfiCiIJwxnAiM1PbV9emO4HpzPoDKt9eF9LruMjqB+VkhrhA//kmA?=
 =?us-ascii?Q?UQIPm5gecApsIRp3RnDFPaEwaLqek2g/EUIn+k9Y5ZewJuDNkpghrfHaynBo?=
 =?us-ascii?Q?QWZqDfIXM6byD4qCelbfS7miSbYKx4JNI5aUuv+Xjcjg+i/fiGyjTa2dkEGu?=
 =?us-ascii?Q?RFfp+SF06W4yRdBOk0C6bddevovXANV+AVhju41do2hSmjyxs/0tIvMzXsGr?=
 =?us-ascii?Q?74djZMzNvLDRN9RaWIjE9j92HBkaZz05HnbIJ/lnz8GIMhphj2Gwa8tAMGJb?=
 =?us-ascii?Q?DFJikVpbwo0WMOJCHFTjggm68rmNo08R5gxBHO+qsY9YNHDVSTUpV8AjmVtR?=
 =?us-ascii?Q?EaAik4wybQFP4MpljwN3NWQ+hgr5euoZ7oixh48DBBkcb3ZJo2CeJ7tcf1r/?=
 =?us-ascii?Q?aeJ0Wzxy7geBTznzO8Qkm8GY8gCa8KeuUfgpLFilO9gu5GqTBUUuzoUMe2AW?=
 =?us-ascii?Q?qYAkHQx2WZG1jTokafs97hyOecgXf11gzcG6Z44C8ykjr7DhulHELhvkVrPK?=
 =?us-ascii?Q?QQEwC8NZbQ/ImiqKkMc4tUxi+nMpifOlctjqUBE5liLU8NCSaKQCZNWA1s8m?=
 =?us-ascii?Q?Rvr5f/fBjxdQz2IPKrIDqwtZxR59fGqWYL4FHCYOdMApgiEqZqTwO4fnvQFV?=
 =?us-ascii?Q?gfOIu2RVYg1AjWx9kt5++A6NhHCbXPpAXWsy+2Exa9vJcSQzggHKx9sDgtFD?=
 =?us-ascii?Q?XfvfAWmc81KBpHskaOQWmKB3X+f4HfiLGnUa0FWTr8q0Uz59OwupO9Ogc+un?=
 =?us-ascii?Q?Im6fxC+bc7WeP7GDlqNTyCEJ2/V4n2rhqxNQ4z+dWHwesoU6ZSl/PJ5fw5yo?=
 =?us-ascii?Q?KSRJlQD7vMKTxV79PdvtU9HdGcu1egbbuR3mCpXle74QIV2pgXTD8HLrj0DO?=
 =?us-ascii?Q?BSvMPwI/rl5psYUf/hL1kGb2UlkgLv/JHC3so7ZDE0iwb+/sD0HWniM4+rh1?=
 =?us-ascii?Q?kcqIM4JFhqFWKc0a1Z5Ce1rlSSrQPlDwu7qAgzkWila7bE0zuOQemjXhI6aT?=
 =?us-ascii?Q?CyZtFPVgOWvcTUFC8kTnMAoznMInKFqpUuk7rxPWAyzMBd6CaKnfs8oEDNc3?=
 =?us-ascii?Q?4kx0Dg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adef6758-0b31-41ea-f215-08db14af88ae
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 08:33:54.9462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YcMZNmaCqSEwBti/Rw9Y5YrYsrDLn2/wq23/+xr8oOro2/5lab39amPYzqSVaX0/KWTr1KpLBWaZJcb7cMYGojz0noVV1yy4/Vz4aiM8Vkg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3939
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 10:37:28AM +0800, D. Wythe wrote:
> 
> 
> On 2/22/23 12:25 AM, Simon Horman wrote:
> > On Tue, Feb 21, 2023 at 03:29:59PM +0800, D. Wythe wrote:
> > > 
> > > Sorry for forgot to cc the maintainer of BPF,
> > > please ignore this. I will resend a new version.
> > 
> > net-next is closed.
> > 
> > You'll need to repost it, either as an RFC, or wait until after
> > v6.3-rc1 has been tagged.
> 
> I had repost it to bpf-next, but thank you for your reminding!

Sorry, my mistake.
