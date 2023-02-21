Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7753269E4F8
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 17:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbjBUQm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 11:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234782AbjBUQmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 11:42:19 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE322DE55;
        Tue, 21 Feb 2023 08:41:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1+rGWvdB6p/LrRRMQY55hjxVbbcB2rSIkaVdXPltuRW7OK/lq1JmPE0H1oWWv6GCVpWh5IPDUKCbcedvpGYNrLMANvlJNy5HR1xtw0D7IvDD366afux1H0YUXhhFw7wAEtUiImS1GpQwYEB+PUTj3tWTpsMGkuOZ8d7z/QqsthTuqd1VHZAneVZnbPmoHHCFaSbzmDY7XL//jCQoVxwx9yxOfVY3ZctGT7Z6hYE4VKAYcvpTVq6Z0nWzSdSgU8KSlew8lMK7oL1f/L32RCh3v1bwiBfFBo9bPKGmmWwU8qgSVelZCP5WxYTnGd34zPfzAcXQK74Z+dmRfOVtP3dOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMWnNGpesmhDqJ0g5cwKQDO/ub3jS2hRFywmR28We8o=;
 b=m5l47Agzk2QRVgIPU34PcDTFtrEqT+JltC4naH6xiwJOKq8x9CrUXN0IiMp2qCmyNwk6RSSjw2PD/HFpU6LNc9pnRcK1maC5JWGSySesKDpRAfjndStEIEt2VFTpKZtNZCrqiltVlw9G6PzmImbDsZiU4hUeqACSTajxmB+LdYzRpUqWChdSjzmDZDkO9nf7wKXZhwX4KgSjvNPdJO3rMgHLzcPO6jdDZ4foAb7ewlNyCLLvoZGa2OOEOuNW4l7DwQMAvdJjlXMlVfHpEHZghNBnAYy60WEx9luQyKd6jxPs7fjcxEFk2OTLKPVNgtmiP3WCP0wBCXQ7HEhGfaQp+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMWnNGpesmhDqJ0g5cwKQDO/ub3jS2hRFywmR28We8o=;
 b=GuTd2snPOUiazU8ZIaGN25Pji1pf4jw8oVoX/XpO20H1UMCXU5fAjrkri/qfha+jbi/wX/pTbYk9KXKF4EAlj7BtpObkydWFdIBqihygatGiZ+zebpqLd1JuYrtf7MU06JNlpaOP0jrdeTQ9LBq+rzZCnPqMW1gkL9DgT4s3LY8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4998.namprd13.prod.outlook.com (2603:10b6:303:d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 16:41:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 16:41:32 +0000
Date:   Tue, 21 Feb 2023 17:41:25 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jochen Henneberg <jh@henneberg-systemdesign.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: stmmac: Premature loop termination check was
 ignored
Message-ID: <Y/T0NRtorZn74EH3@corigine.com>
References: <87fsaz6smr.fsf@henneberg-systemdesign.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsaz6smr.fsf@henneberg-systemdesign.com>
X-ClientProxiedBy: AM3PR07CA0101.eurprd07.prod.outlook.com
 (2603:10a6:207:7::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4998:EE_
X-MS-Office365-Filtering-Correlation-Id: 01a9fa49-6efc-400d-fd1b-08db142a7cbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jkpGBNgH2wvQsKliIhdY1rZJKcreADGzfFC9waJrTyctLEuRSPWhPW0utx0CsuqmJEWNJTTZ6grBCYz775mR+H4TE9aa4DwNWawUa2XqRzUEnMmyqkt+olPk5XE5obUfYeaV4xWJXvoVX1cbTqsJFFQdKYGBhUKBDUsjYsba/yzstRCgIoqdIlEOXq9OJbBpQFFYcj8wlK2fuX0yWi3UYtltlL1FXFQcvPwp3GCDm8Q1nTEDUxkwdpzZ9ONbfOub3d1lzDgPK7KeSDXu+Awj1uSkzvMqrX0NV9uQ8w25yQ7mrjgeYUxTeUD94ZFsrnKbgwjaWDCt0kPrNn757WG8aQEXIC1QBcQlkCX6AYpgCvZi0edmFMZVC2vQDvLrlkM4+kyzr7ZOPo+bhJ2lNjlgh6Y1P3HFOhJQthU/u3Cn7rfjIY3vDcu33o3i8VoaLik37N2J6bW0Y6QMSfNqFN/kkJ6XySFbGTfcmwvfEaxbeQAVkf7QFypP4e9lQuUUs5g6bg9G0BNSc7wmmD3bCf4A+Y/LAO6ItsVD54uNEl91rOUUFwNy3oMGJrozUCI670O6GffyjN7X1kEk0JGBKj9pj8zvf9TitqHE6fNWcug/JTgi/SYcX/e/lDjROqsf27zCqLqAVdQhjA7vsLBcLhD7aQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39840400004)(136003)(396003)(346002)(366004)(451199018)(83380400001)(41300700001)(6512007)(186003)(54906003)(316002)(6486002)(86362001)(6666004)(6506007)(478600001)(36756003)(8676002)(6916009)(2616005)(66476007)(4326008)(66946007)(66556008)(2906002)(38100700002)(5660300002)(7416002)(8936002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ogz+EoyEc6fktcK1B+pDAAnHKTZjjLor5TlnWejyPVIyidocmDUMtulbm/NJ?=
 =?us-ascii?Q?pOYeIUXYV0qfTM7S43V8V0zdRiPsOcVNWr25c5KEKzqrANijJ5CgDTjxaihs?=
 =?us-ascii?Q?2366qL7CDZdZR3ztClOoA/G1z3vTN4Tk89sUxtlM3ZO1t1J0PXI+lOTOCLqi?=
 =?us-ascii?Q?DG9k1s6pAIodIwaql54BGkoq2SSUzZE6vViF1005vB4FrlhMHNy005DsgSb7?=
 =?us-ascii?Q?RCeySSbJSzF1PCo29Qu/ETV02v7aWUgxx8qcH1FflBwuWJxfOUT0UOd0O6ME?=
 =?us-ascii?Q?WJ10dZshIiSwhwTI7DiZQovZAh5zAh8tmgktfpk48sFkQSFyVUEawhZwNuwl?=
 =?us-ascii?Q?CJtYHaWsNdL+CAm85HvBQYjw06ROZriSOdJBvMwpqFVQR1urk6dE7+TpaBTO?=
 =?us-ascii?Q?78fouI+SjKSi6085bgAznEODl1tjWDaHqln1nDN9trhweoDh5E6HVcTKqqev?=
 =?us-ascii?Q?O7SFnFhOsSyfbkAxFNwztJSuw4lrASjA78EnVoFecRDIsQsVJcHGciEFj4hP?=
 =?us-ascii?Q?7vULGiFiaLdHmL/8F7IjcJfniApeeuEd21m8KBVKNRlWahdGj57e11wXMw3J?=
 =?us-ascii?Q?3/qLHRP9jRT1Oy3uA/nRDHiDp1ZLLAQ63/zQYrC+q8NEtjSsR9A0Kvfhqw3e?=
 =?us-ascii?Q?3nC8qV5RKuO/xPHRIR1lhwSVDuGC8B0t6zclVaAghf2cEjokpzYkI6dT+zr4?=
 =?us-ascii?Q?4ZBbh1T7m7G18wr6XgJ8us8HjvbpVDvynj+N5gLH8cvzk62f09xxqGSwTlcf?=
 =?us-ascii?Q?cpjbKvtRd9vnMr/7QuhWzkDzMKfraMHGEmxuhYlexDChuBB2Dv3SSuiJIACI?=
 =?us-ascii?Q?Zv3hzCtnn5bCslz9BhRyaRNaeY06hoR8/ApTt84RRx6cm0vq20wmcB+2Cn21?=
 =?us-ascii?Q?Zu5JkQylW8tVr/2opMzS2Asn1nPfQKwPJSfz+2HrXYebJZ/z0jrAVZ75NoUt?=
 =?us-ascii?Q?8eqE8E24hHhWSZWYGobJBN+RaAKqum5lb4FMFyEAsjGphyNhvb5CjOeuaceJ?=
 =?us-ascii?Q?UcYEGo8xU94ImtxRtviNxEF+pNIDSgeHzPKwbd5tM4nmOlDTGeTgF8S0/ImZ?=
 =?us-ascii?Q?pgcuRYjJHaSCk3hMKprtRkf880TagE3cKvn35pAezJTqTa1hCHz3K8yc4qMT?=
 =?us-ascii?Q?cVLq/YcidnV1QuRxqn5UTft6aCtO1PzEIdRU0uKk0/R/xiNcc9VMQ6Lrn0Zu?=
 =?us-ascii?Q?Wyel8ErEx7F5RvEcDEIsanqLGU8v2OlSbR3fyQ3tZxy6YZQvEQbsBwDq5guA?=
 =?us-ascii?Q?eZDCyv5sxDlXzfWBlUOqK5ZWAGx1nkLg89MrCRJ3YoUu5zV40VU9fz1lBoVS?=
 =?us-ascii?Q?ZkV5x6sh1qxxH25CJw44btfjdp2f9gXmN7T1HAuMPdaWFmDgnqBsivtGXjlZ?=
 =?us-ascii?Q?w+aV515RZZGDuzLelSvq43++abP2JIecLiQx13mhvvxRNT5hEEhr8XWhjEiZ?=
 =?us-ascii?Q?0Of41o2X5s6YaklDK90+pEu2FRHOWesQGGNS8x5vtMeqfXwBSReTlwNVZujn?=
 =?us-ascii?Q?Od2u9oTLeIxqUlcIE0Q4ShDDbiOPsQUhJLaWkH+BK8XBFvGuVoqXyaecqbqy?=
 =?us-ascii?Q?GzBOHSC+EDGniTfIZ5s4aardXUfCrULmDc+No/gMMZXr+lYF2jXvGgecE+kM?=
 =?us-ascii?Q?eidsX5g53ItNWc5MMpbu3i1Y2FDBWq0Co4+1Omy/Hlu8v1Hm67QtefGhPqsB?=
 =?us-ascii?Q?DKfzrg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01a9fa49-6efc-400d-fd1b-08db142a7cbc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 16:41:31.9399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Am6fZf1aF8SsQwcSr5ZStQOC+baREctcQKylRWu41cq3skk1FdP+iAsntiZs2e/puB6rUokvVwSCLxv5HpiDykAdRF8vvZxYvTR1PvEVpVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4998
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 02:38:27PM +0100, Jochen Henneberg wrote:
> 
> The premature loop termination check makes sense only in case of the
> jump to read_again where the count may have been updated. But
> read_again did not include the check.

I think a fixes tag appropriate here.

> Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Code change makes sense to me.

> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 1a5b8dab5e9b..de98c009866a 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -5031,10 +5031,10 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
>  			len = 0;
>  		}
>  
> +read_again:
>  		if (count >= limit)
>  			break;
>  
> -read_again:
>  		buf1_len = 0;
>  		entry = next_entry;
>  		buf = &rx_q->buf_pool[entry];
> @@ -5221,10 +5221,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
>  			len = 0;
>  		}
>  
> +read_again:
>  		if (count >= limit)
>  			break;
>  
> -read_again:
>  		buf1_len = 0;
>  		buf2_len = 0;
>  		entry = next_entry;
> -- 
> 2.39.2
> 
