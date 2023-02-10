Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8179691A4D
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjBJIuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjBJIuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:50:01 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2139.outbound.protection.outlook.com [40.107.94.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6BC7B166;
        Fri, 10 Feb 2023 00:50:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TK6yLLGPugko6viAPZ4cW3fX4PqK3Q2wPzmUanr565j3gwtSSA7kgkh1+eWsuZ0jnt++51sCtBCp0H1WosjQ5WgfLlIz2AwRCGAflzVZ9OwbiVUBQDP+KJ2DacL/FF2O5zGJA63Iz5siqnBHmT6jNlcKk7r0Ex8uBQsic5vtnzuQ13Rm5dJQGlD2f7vFBg7LDfeoWGxpicEgAoesQCjC97XWdttkIGbDXZZO+7mTsuc2HcHARYep/PPhZzzj1HdbG7shsHgEBrbHXFVUMWQDTDdsEK9PZRNEDYklDC80hxLkSSK5kR++OljZI46z7KpfyfMePKk5wzE/s6gKGQOl5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ItYVBywEKFN98saQfOqUWIAjym4f0unFb96iy+O66WI=;
 b=c0WWX/6kImXq/BVUQbIBxlk0JspnIvtxqVHrnEKuR08uGmmYI9cpRf2jhntZabaLhrI9Rnynlk4N1TGexU8SGlNVYRrrLVP5g6m2+sdp289KIgtT2bT1HVuybOwUQar6EhAJsvEAGU24h0DBLXOFgrd26FqukO8BvEwTRa3RQFJCHIJBzVUrlXDp2CQZixpNTsji275dubw9dbBuj2mfbO6FdvVt/lUiNZHqD2uHfSReyPy5hptAlsZR34KG4u7I1AtL8F67z4BJ9ZTeCowRtqgcbQILWDvhCn8MBiQB54cccHB90j8cchMzK4AOvMJx/XRBFQOJqbU1fNRPhKmW2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItYVBywEKFN98saQfOqUWIAjym4f0unFb96iy+O66WI=;
 b=EULhAyWJ4xljeaC9Bg/GKhAaYJYqInaFgEUsTigdWb+FubJhIrPD1+uOrzMzIOiM4ud0Ph9BJfSiDarXdEitj6WolRb8bnCq50GIQo18tpbClxowwBhxAqysbmnFVvE0/R1h75J1mqjJWwV0zU3pFRFBG/fcmL35JP5937eLp2Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5776.namprd13.prod.outlook.com (2603:10b6:806:218::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 08:49:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%9]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 08:49:56 +0000
Date:   Fri, 10 Feb 2023 09:49:49 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Hangyu Hua <hbh25y@gmail.com>, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, xiangxia.m.yue@gmail.com,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: openvswitch: fix possible memory leak in
 ovs_meter_cmd_set()
Message-ID: <Y+YFLccEN8Gr0nZE@corigine.com>
References: <20230210020551.6682-1-hbh25y@gmail.com>
 <6582F9D7-D74B-4A4A-A498-1B3002B9840E@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6582F9D7-D74B-4A4A-A498-1B3002B9840E@redhat.com>
X-ClientProxiedBy: AS4P189CA0045.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5776:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d10a951-9244-413f-4304-08db0b43c8e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s3Ih5u+VmOBb5eiQnR2S7DInpBjzO1NWpi1TIqtEj+ivSq9l+/uRtGD4myEaoIesX8AHie2bP5x8dJ/XTJFd8AfHOybpSE55bXGSaUA87LBk7Z5wKXmr78jstTHb7+tZeGFcZi+KRbk3nLCw+h+HwDvedSSTdx6N3KKBvyi48JL93WwLodlsi8Rwkmw7/KAlUqPjgGbfnpHl0aTPcGK/Y26vaV4cAlrpDwrdMvuK+YFmKif+nDeZMhombQdTfn6DjwGtB5Y5OeQGcUQxwL6pOLY7HB6rphTgqD0ZBcS1xWLZ7XWu4cBqsQinydSxnzqzHK+mWRUIez/Ba5z4hlUwwVec0i1Myof55KxKCY51rlGZD+/MQpQovRvYNxyfbqAFmUEwUsMxa1QnREAO5I0mamVnT73G3bqaa9CEaFCsGUW4agAlAUU7zEGfVndwE7sOqYup8pwChTWGz22aCGUvymCNYqTa+2XO2pV5l3ECEStMW08rNqIe95p81Mig8y2LXBeEKIkFiQtfSHyKFGWECW/iXi1vo3ys3OHmSgIjJfHzc16NhHrFvPSPbYeG11CSj5K3B8aVScPuKLwcYh1+cecOFcPjki4XOh7L+CCHSihvzgzXp3yI5/NbqjRDyCZ6dd6vF4KdgDMYSnRwbbV9IRNjR5JDoI2Vh/iOIPrZquA5AwY+MqyMqRhJysMmrA6l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(346002)(39840400004)(376002)(136003)(451199018)(2616005)(478600001)(6486002)(53546011)(6512007)(6666004)(6506007)(186003)(86362001)(36756003)(38100700002)(66556008)(8676002)(4326008)(6916009)(66946007)(44832011)(41300700001)(5660300002)(7416002)(316002)(8936002)(66476007)(4744005)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ncupHhesRhfOkRlQhpwT0JZYfyFKWxoD+MGKjmzbLLPeeYajwC9Z7xeqNEo/?=
 =?us-ascii?Q?nZmqcrgiBRnaqVT0BXw21hzlfP5JHjsTegPAYSy9K5Vr37UZnUCYEK2y2gWs?=
 =?us-ascii?Q?DJWVFxUpzF5z9rvvicc0Vmk2RrZnPQNGgnNamCFDBgsnUDE2kodQLoWMfzpl?=
 =?us-ascii?Q?QweenIkHKMq893FOKotSbh0Y92EpCe4rEw63zvfrZ87DR/5ddfKbSjOgUYOp?=
 =?us-ascii?Q?uM2T/hnnSwHy7mwWAIc5z/mxm290LXQKRaOv98HidpXQ4imF+qJV06P/4JXl?=
 =?us-ascii?Q?2VCg35EY/KlJ3F/uiKJ84tA+wwg1f22sonTYOlv8+3s3BZ4ge+5YkJaZFaUV?=
 =?us-ascii?Q?/cdYNauvTQ0bIDlqcJbh14vo0IyA80JIc4nBsaOXmp6uOtKd+ZpzePrLnKqM?=
 =?us-ascii?Q?QNjtOf/Km4Tjpq8HMcMEvpbqjxqMkzOFKRVU0J3SkA8a91gO/SAPLaTh2Vc6?=
 =?us-ascii?Q?iv5EdGnr2k1I4VfBKGZJAu4tjbxE9UCqUGTzerWZXDoIFBXzOGxDYCjE7Fuk?=
 =?us-ascii?Q?pVLpKvnX39J3TR3Bm1KDt48uk93mZtYRozQriPUag5Cc6kkEyPF+67G9DfPN?=
 =?us-ascii?Q?6tO5xDSNPgetEj0iAhf29kkgip3xJnm5xbn9hA8FgSunmSUwe+nYRyqoP+OA?=
 =?us-ascii?Q?1b/PC41/IumQJb4XoK6NhvvQACvCwZMXQD04j7kzw43Aq6hgnF0k4G0vk8le?=
 =?us-ascii?Q?72tp+rrTeNxnPk/jLfqCZaQLrNDxKIYzcAsNlKiENMncEy2SVCSBZHsj91tK?=
 =?us-ascii?Q?BMkOLAnv04WJKvoDJ1IfdHJvxd+xjOXT4BQLdx0trdSw6LULechKj60P3eJn?=
 =?us-ascii?Q?z5Qqjk3WUkTHcHIsalxPIVd13d6LaAxqX4FdIT9C9GSJDUNW2My/Rf5zEfs8?=
 =?us-ascii?Q?ayRu0pMmhtf3zG73ajQBypZ89OjwfmyJGcb1JE0Aere4Lqb8rZUs+wMaFT1b?=
 =?us-ascii?Q?X+N5hYfFw7h4hIgXRQBelHam05tapu7OOVp/6IenUPl0eng93vPwjNH1P/Z2?=
 =?us-ascii?Q?sdwXYfWphVd8i3BPhP2+IkIXUGDDTFzex6ZybBVtILwYvBBeUiKfbQE3wGK7?=
 =?us-ascii?Q?FnbONiwRLtOhFO7RopoV/nkAhFqmR9jqIyHPtyHgVbA3kHk3xSaf38lFQmmo?=
 =?us-ascii?Q?YNIwoOmRAgXn3/gPnLlHhgGnx5K3nahkX/Ziou6aGSxC8UeDMHeU1+uMuFMK?=
 =?us-ascii?Q?pUI4AWQOQZgiwlzqFbl9ZqzA4rBOGmvb9kJGMmlyGrOiblTRdlU4XSaTNf4A?=
 =?us-ascii?Q?EPOvbZaidagJXolcTWM3+n5+panTF/0JWtw80j5K54IyzEIM9Bf/LfF9YTXD?=
 =?us-ascii?Q?iflXC8forqsmusAGo+2Gy0j93UtdSSXko0TLtHMfo4AIJnjThgA4kUBc7XqY?=
 =?us-ascii?Q?hOcd7ZTKlhqGFJOChCs1l6wny9OLf/AN02ZkqGmpV2Ncr52qTXWkA23giSVF?=
 =?us-ascii?Q?KZv0jBb4hjHd0bI3koof8xU44uc1wseL9GClbVrCuIxESZBjOVT0YpHxCTgi?=
 =?us-ascii?Q?5zfJdvtsw6PYj0Lgt+6F0PRKCQSJc2H0kiraOTJokUxCOSvfucjo3OK6aReE?=
 =?us-ascii?Q?nyqv9ec2+PvyGUq8o258goR5Mti+GPWAQPl+D7FJvLL2HAXs/scVffFbU5gW?=
 =?us-ascii?Q?yF7Osa38LD4V8w8ipKA47vEhZM8eUldeIaksW/vX3afQR8Yiqo3kTznSDZ0X?=
 =?us-ascii?Q?2NjJDQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d10a951-9244-413f-4304-08db0b43c8e8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 08:49:56.6154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jEh3PXgCtYJk+Or5wS8UfLJmHRKo6C3bZen26kJtzKM7pVZERolRNr1cB5JBjdr8ut88EzMW8nWka3BXgEZZB2Gb7Xpuc542qiBFHlTa5+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5776
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 08:35:50AM +0100, Eelco Chaudron wrote:
> 
> 
> On 10 Feb 2023, at 3:05, Hangyu Hua wrote:
> 
> > old_meter needs to be free after it is detached regardless of whether
> > the new meter is successfully attached.
> >
> > Fixes: c7c4c44c9a95 ("net: openvswitch: expand the meters supported number")
> > Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> 
> Thanks for doing a v3. The change looks good to me!
> 
> Acked-by: Eelco Chaudron <echaudro@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
