Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143606B294A
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjCIQBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjCIQBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:01:30 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2135.outbound.protection.outlook.com [40.107.244.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C211DF31CD;
        Thu,  9 Mar 2023 08:01:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3JiiPoKTtEXi55nwUZsTMHAa0QQKg7Vw5drT6/kq36WIKBJ7XnLOb4I9KsHixMn5iajCj0TedCQnu3TiDAZ2cfRIdi63MHvW/vyfnvzyJn9kYHZCaMupu/eTQ4UfqrQ7yWFMz696XN0S/+wjtT6F2UHi4H/XLI9A7chxpkv5XsVM2bF5yxKyuAVuNV5v/Mda5rVS05BEyYAneVE36Gr62sqdMVKKRyPlcqJeWaqLQ0yhC4QBV7++ku1/cilFGoujrsuR17IV9UH6Ra7uAZPl7uHbIpaChXFg7ADUuSAm/spLo8N0y4OP0zBKGk9PgAHh/FcBlV20laZ/0HTW620+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7nCheueDQew7kJEfDoFvMfzelFQ2e3X4KWRtL/6c8+U=;
 b=F61QregjLIt2xm9St3FkbNoE/KqeBZnJJy9Yqcyp+JKnGncmh206J4iSbmm0Sj2WNvgXHxwBYyfkcPuO1pYfKAEjpAk5cUQy8bH06vRe53zlJeIluULqnJxxkuI2WIhbDs2k3J502s17yVm8YxSUVS3V2mR9U5iFKUNAa4CWSr38OQiqeZC+s432MDAiKVMPporz4YRPZxNtkFrfPPBkh4/bT4EZLZXQhd7dh8U6aUwXh86JLjRosEu0tPDz20Lp/VNHkLiqZrJLw+whF/hWPxhoZ+ICG2CnthpUzbEEE+X1CFFW8qgR1769vJ118yPAzDq6toYNEwDN721x+aE8Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7nCheueDQew7kJEfDoFvMfzelFQ2e3X4KWRtL/6c8+U=;
 b=fygRkf2mkdPoOfEIxt5W1Vkzo0oNTACk79jRZ9VY7BxZIdPj5wn3pyN10pyYei3cWhVedMZQoSCmRgTnbhwIWbBnPXKK8itZ5EpfcANjn6zthBrG15HhVOF3l7tMvoV9XnN7ug6KAtUc66ixB59Zn9BY/t7TqSMnnANl2TqTVLk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5619.namprd13.prod.outlook.com (2603:10b6:510:139::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 16:01:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 16:01:23 +0000
Date:   Thu, 9 Mar 2023 17:01:17 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yuval Mintz <Yuval.Mintz@qlogic.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] qed/qed_dev: guard against a possible division by zero
Message-ID: <ZAoCzbwBBVfP/bno@corigine.com>
References: <20230309125636.176337-1-d-tatianin@yandex-team.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309125636.176337-1-d-tatianin@yandex-team.ru>
X-ClientProxiedBy: AS4P190CA0062.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5619:EE_
X-MS-Office365-Filtering-Correlation-Id: d5398451-8e49-474d-92d9-08db20b787b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4YCAhw2rmYkTtLEWS7yFVxJ2AHsNCDtletfartGSZc9geGO7oAOV1NB/YP0BrjUtFS2c5IXF8YEcJVEeMfA5PkPa9vUZSWNcbIMDbWEMZtJUwl4AlThIDbaXqevGVkTVknTwugKdB2utqU9yDmuPGeIVOhuFoTQjuS4Jj6cYb3Wg6Xs169khrKe5KZi88dMDz14nASz4mxC3yv2gtJVyx97FiJJUBeuwfXXOuC3UW9IVrzgkZT1t0qdsl6jK9gARSVbD4lVUCnejOLLvpqyqnnIwAbZakiGxCQ9ABTRl+nxXja6aKTh8+CngAkKpx7FYdKScqNk2SkPdPwiBe0gfngoR0I1JpgObu+NdjG/9ab9Qd6ahnjxE/407a/jZuDpEUZ9bGkS2vAz/Sg/A0anw9Wb8LXUmP5syTbbgRIeOhWBOQRmIaVtask0nlglI4nPaNsNKjnxvGze+hq/7+SFSG8eDJfxN6dnQqYpgsC1Lpmj3wP0MjntYqrqz/Y3clnlkyeOWocpECVh4pgopLmjiA9utqQUURmL5Jm7EX8UHlkJ1hl3FfVSFf5SzSA+TGwUi/h9sfJvApvr7LAqkMLUfpe+a9uipSWlL3+FgVAHzv2s3pKyPybgT/DnoPXJZNfARXX/U901n6nZKapSeAOKp6s9pfauQP2nKSxNxJyHxdr3RfjBjFxsDKILqFPFK5yzx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(376002)(346002)(39840400004)(451199018)(54906003)(36756003)(38100700002)(86362001)(6666004)(6512007)(6506007)(83380400001)(186003)(2616005)(7416002)(316002)(5660300002)(478600001)(6486002)(6916009)(4326008)(41300700001)(66476007)(2906002)(8936002)(44832011)(8676002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OKIK9EtOUokrKh/VMil7trz8Sw/KUph+Zx/5QOpqvkeOjeE7GvMEpDoIXIub?=
 =?us-ascii?Q?Dfrj29RGN60x3HhlaBJ39OSOtZeafxVNPZycB3yjdhw8hMRRCR2xI29AaNmh?=
 =?us-ascii?Q?V8k+lhI/hRJYpZ2SAG4SsSRI+dxiVrWDqmSumGlKgQZrsjxUODELaJtbFjkZ?=
 =?us-ascii?Q?31zVBnKE2iaaEpwjRt/pzzV8h9tSFnyUTICu71QOl89jivh5hbvJKoHT4Szp?=
 =?us-ascii?Q?AegUBB3QDSRrHLyoQWa0cwp1cLikhxMPwrHtYRiVBEJ0MkJO9plirIZ7ofrn?=
 =?us-ascii?Q?MhgtGLJCEtaRZW9dsAIKz39YNwllR1L9snc4J54MNW4ZbD9rd1/e+2IvcUlL?=
 =?us-ascii?Q?1YiNt3ivUhzRbK5jdXjFp1oR/aBEzYWgJN9QzrLyeGhm1UwwdGwLInjxQnvE?=
 =?us-ascii?Q?I+PRylYNbkLoWHkSjegy4DpWMsBD4zy+Zqo3iB6gS/RxMfpW3Rs9VoFBxx9G?=
 =?us-ascii?Q?LmgeXQOFAQm7ia7IxLlGfFBahCs7geLi/IfNAcNKHVBxGasEodjRQ5iG6z6J?=
 =?us-ascii?Q?suzjIHz+/WfntiT5VLXg7RCbO2vQH+O60e902wolHnNR0aAbqBxhg0woMWyc?=
 =?us-ascii?Q?AIzH2dz5jT4K2mhI1kx/6m+MPJgiCIYucIA9o8ckm/dbHkFOFcXigU1DAjlC?=
 =?us-ascii?Q?2wU3l2gJzND9dv8rkfzSZvCv7aTdp/oY4NygsasEQp7nYk3hcuKHVeGz10LM?=
 =?us-ascii?Q?L0kxnVzffbv9rDMlaKd+kJoALW9RodMgE++Cc2xLEIPy50jJZtQU+PUFK0FT?=
 =?us-ascii?Q?uR8XkmKLnbuodlwORMFmvrGMQz5x3sCnfyYQiUcJ+zl/eBhS88jX8MJH0MOS?=
 =?us-ascii?Q?v5+o0qbao54VyljmwyQEwDLgu9d7o+2L1Vj1cGS0u3uDpazBmn68oEVVds9g?=
 =?us-ascii?Q?eA35uhcfAeGTglNc3JP3qOxxrjCHOu6YAy8SvNOl6jqz9ar1lByjiApyODgs?=
 =?us-ascii?Q?7ufh4alekmtzig0wfCnRLbUR467b4gULiFlBufpEwt7h2aB4dBhQ58KDTQi6?=
 =?us-ascii?Q?KqHS+0oMasL2cxaQcz+qJI5+7GGmdpqfbLBMnvZxFs1lPv+lFpDE2wwTYwuQ?=
 =?us-ascii?Q?H0EGCfmL6sstjiF+FKMwZaD7R15uqqkVbx6sJziUbH07qLnkyK+hb5Ronisx?=
 =?us-ascii?Q?FqGaVyLxY1z28/P4sdmgLMYXLKPoNzouNB3uxUOHVK33h5EGJoZRYk2+Yp48?=
 =?us-ascii?Q?4I4/DrnFumAczSEGFJON7iQVG0YfKvkVZvONURhRP1b7QDE48IlHB4S8QUt0?=
 =?us-ascii?Q?a8zRrR4GKGvyp6mvj9inHVDtCg7ckWbiN8SFXo1zasMqR72GZCQsWNJP7ypm?=
 =?us-ascii?Q?PZioI1ZG1tOFKi1jqzFuBEQq+iy5TKh7bjM6R+tL/JvWfyGk7qg12wxbdVNk?=
 =?us-ascii?Q?rvgxasxpdrlCTqnPW1m4eibMhF+RPXW6r5yxUn4DpcgcWuF2BzO8cz8AFsiX?=
 =?us-ascii?Q?U1MGAYKdIfEauAlsOGRMBLmISIITGWskFIKHvZkbfQ9H2DQlfdCMu5xiA0ht?=
 =?us-ascii?Q?77Ml6HZjMulMXQhU6ZNjkU7chquYz2X/CCzDggfQnqDIcq43NoDJHIzDjMNR?=
 =?us-ascii?Q?2z15nqcnirX4N6EggnkuoA707cEQjwygDB35fwAVbiKcaRJXeVwaDrhwE34K?=
 =?us-ascii?Q?eT7hAIVriI+q6vXwxKLbDX54TmucQqBd27wfc+LxOTSNuUyT8J+lVa69RkOj?=
 =?us-ascii?Q?SwdZMw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5398451-8e49-474d-92d9-08db20b787b1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 16:01:23.3066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GEz2bbRYaG7SE7fPw2nkOu/bvCenmCilow3y9Q7V1ujfkM3K9UzfrFe8ftAwiTkIYD+IYIySYnWdeuVY3lJEM3VzknwQbcPOFps6IA/1Em0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5619
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 03:56:36PM +0300, Daniil Tatianin wrote:
> Previously we would divide total_left_rate by zero if num_vports
> happened to be 1 because non_requested_count is calculated as
> num_vports - req_count. Guard against this by validating num_vports at
> the beginning and returning an error otherwise.

Thanks,

I like this approach.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Fixes: bcd197c81f63 ("qed: Add vport WFQ configuration APIs")
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_dev.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> index d61cd32ec3b6..9aaaf5ad3eb0 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> @@ -5083,6 +5083,13 @@ static int qed_init_wfq_param(struct qed_hwfn *p_hwfn,
>  
>  	num_vports = p_hwfn->qm_info.num_vports;
>  
> +	if (num_vports < 2) {
> +		DP_NOTICE(p_hwfn,
> +			   "Unexpected num_vports: %d\n",
> +			   num_vports);

nit: the lines above are not indented correctly, however,
     I think that it's better yet if the DP_NOTICE is on a single line.

> +		return -EINVAL;
> +	}
> +
>  	/* Accounting for the vports which are configured for WFQ explicitly */
>  	for (i = 0; i < num_vports; i++) {
>  		u32 tmp_speed;
> -- 
> 2.25.1
> 
