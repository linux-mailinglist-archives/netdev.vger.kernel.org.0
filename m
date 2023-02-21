Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB9469E3DC
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 16:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbjBUPpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 10:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbjBUPpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 10:45:39 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2098.outbound.protection.outlook.com [40.107.93.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B1B2C664
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 07:45:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrxYynj+mDesOh4qkawOJRYJvQ3AXHwEvM5xFMlfkoh58xK+9LXiehNlaWzvj6xnoHWg9iKH6ruoBjfwTr95+iph26GL/0N87xOxrfk36nmMmz4azRMEecyhJ6W6Tjciwib/UK1phdSBII5WqsMNv3AQnRKDFNvyNvjxV9tW7/NgRjsDnF/BSkUC5DeVXy5E6XJTxbsc8pCSUehV8Fds/xTmFskFIJwEwNDvBPp0Bebpa0XmQe9Mar3J+Lg9ByhHbCLR+VZOYPYia9uF3p5K3eZQNI+u4mCTyfbg/eG9nN4KJ0mUYZ59N5dWmoK6z2IpjStK25Kj5HrNh2tKWP+Xhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+DH+1KUXE2lKoFANmCzHCNzobt6p8CyrXCt1kp/yyTg=;
 b=c5upo8+ifQdM34ZjP46y+kl+VFQ0cmLwRNBbrtNDXDFWFAFg1YQkSfcKc9WCeNuXF58ZG+7BB+pPfuWceXQzqJvr5JoMjMvSsn64romYQFkSgu7e6n6xxoeWi6CkKdpKRVcYsCvZqPM3DQXGa4rQcbnbsNtJjf+IeuqDUqPFr/9GOyEg8QhVVHddaP3th2WEuGFoPyYske672luwxBjfTbUfT6bGF0eEmDCrRPWKL7+IIE4UXk1qYLs0B1iLJoj46KzAfRNndnEo0oI4q3WqeyYkciLVyQTxYtCFXD7qsawuN00jx7qi2v/vUM2GmGOulwnciBc9Ofb2mbpv3L/tWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DH+1KUXE2lKoFANmCzHCNzobt6p8CyrXCt1kp/yyTg=;
 b=EZ42Ml7SKxXttUfOFOr58rrCzERXZYpfrWv11g8DiTh+nAbjt2BDzwNjd61BohVpYM+rF4xcppmBf6i37dKuMIFvLNEPcKiI63LkBajKAT5BJCsF8oceCTViUWbNHUAi5NEUGLqU105vSy4wCDDW/KrP7IMGT/FiVKwPVZc3NHg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA3PR13MB6229.namprd13.prod.outlook.com (2603:10b6:806:2fd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Tue, 21 Feb
 2023 15:45:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 15:45:27 +0000
Date:   Tue, 21 Feb 2023 16:45:21 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v2 net-next 1/2] net: make default_rps_mask a per netns
 attribute
Message-ID: <Y/TnEUMQ9BT1rG3u@corigine.com>
References: <cover.1676635317.git.pabeni@redhat.com>
 <25427ebf3d3f533bca446f9df4794a1b7021f318.1676635317.git.pabeni@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25427ebf3d3f533bca446f9df4794a1b7021f318.1676635317.git.pabeni@redhat.com>
X-ClientProxiedBy: AS4P190CA0032.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA3PR13MB6229:EE_
X-MS-Office365-Filtering-Correlation-Id: aa821467-0440-4d42-6261-08db1422a717
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d1j3RMmlC1Xfnvw5aB68XENijWyix9PiBNGLyaoFb2DMgVPmKgTx7S37jaxvEQGP9DDry50wWnKe6PUxUDU7tKk4yOzQo8yM8yR/8N7sqxzwIXj8A7aR8w725onAJ1PlqFNAOi5bd2WcnqUQKOdZxitgKo88Ap5scjF1sIQgSP138942KRiUYA54DQciOspUx6G/638DLbkMyunQ57ima2flvpihyKL5sDM34L/kAmgXFsnqoZF88sjIB9gVueWl6Cze7nt3/9cg8qB1318A0vNWffaXsFsC94jbie1ILPs1DEd98SLnhozCKaa0bGQyLfyegbhpm4/IhR5DriDKNntu1KfB7sQTlmTL+3xscI1I09ADoZWv2TBGOpKp/33vmTOvkvfOcBIF28es29tRdWKeCIrrCYE0Xgvkalg+M9XtGXjO6vOaoErLdQ5yYZ72+OytZgJbNHH91I3mKgQisl5RVRnEUUEz/B1xT6qdV87Pr3vHogqpeJAMq2pfeTj+yZmF1Y2oWRtOnWBEVpZ+ZxNita5uLOixEIU0adsBd+8BSaUOgC803IbTuyKzER078ljzTciq6ppUj9px0gLpDSyHTGL90HR2erjagRoRB/c56DyTE9MYOZ6f0s4tOo3HbXuJaI2rwmH7ElQ8DoepEJYFNbnup48KYe+pDyFmN9HqFeh0KaW9GwcCeDPMLD/l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(366004)(346002)(136003)(376002)(451199018)(6666004)(44832011)(8936002)(83380400001)(5660300002)(41300700001)(8676002)(2906002)(6486002)(86362001)(186003)(316002)(6916009)(66946007)(4326008)(66556008)(6512007)(66476007)(54906003)(478600001)(2616005)(6506007)(38100700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gJRtSPpZXfIeZElysXQRwvpAaDstuEK4iA/b3aya506BaQUSb44E5zgYNrvE?=
 =?us-ascii?Q?RmcSdvCtu/01DUbSiFSIo3uKLj6/5X2Q+Q1jUGqcPEykFHlWXtSt3VrrZRYr?=
 =?us-ascii?Q?MrjMpYn3dFLRD81Hlz931jj2JkbHgXvbuPXwL9q5dZPjzZRoHQ/hbgVSj8og?=
 =?us-ascii?Q?IoLUBrt82QVge+SexwQPJQPftyakZjdkx2jgvwtHJaTOesr3VxflxOczQAOc?=
 =?us-ascii?Q?Y0foUNahC3uuYCrCM0O5U6iH6FMMnvCnNyjTv3EDo9/8was/AfJ2UBrq6iGW?=
 =?us-ascii?Q?EMYm3iwGH5VAQhKGuVU0LXK41iDezw8ZZ3qhLg3dn7u2yhvy5eRtaOZgHfKN?=
 =?us-ascii?Q?4qjkqhuaxMQR2vtfxv6VAd+TTfVavCgalaPxp6s3ZjVQU49pEE8XGj3daJiH?=
 =?us-ascii?Q?hpo5qzGjbvhnwO9+YFHX8g7DeQT7JA3TQ1UQNkm+FDpTl6PiLHBuc+mW4NDb?=
 =?us-ascii?Q?GNLviI8pcIJiTomskznYaZWJFv7/1ho9u/yrPLD2xgv9FUB3BR/mDWnMD8b3?=
 =?us-ascii?Q?5LxRtHZSF+bWPLdlUBprB8fzIeenmWKR8GNe1bMc2AoltcjWVWjcHk3vbd8Z?=
 =?us-ascii?Q?tKN1WbqSKd/BjPkwvjEzD20oV8Et/eDh6s+sZdlbvC6B7Sc6YRLEOv5djeOy?=
 =?us-ascii?Q?i7uOGHwAnvdihNoUJvHWatkYMTbAQx4f3W3KqWuk0ZPXez69vTm6kvpIHkCL?=
 =?us-ascii?Q?9PiHyQlUYPTGPNgoFyL4p/ymjD8K6Nl6S68JYs2N6P9Z1BvSGfW+oKMFZrsU?=
 =?us-ascii?Q?nV1OfFYL7g3jfzvW9VS3TAn3g8NpeCoLnrFAIYP9iNcXI92BNkFnwcw0PLmW?=
 =?us-ascii?Q?0NTY3eWWbQqmg0J8JN47gpL7MY7FhL8sZF1aUi6pyEdg93VirB335Smnr43B?=
 =?us-ascii?Q?Fm8nliTeE9rjIA0UILckYXkpQw+RojfTgYp/pHrKXAkLgAFCxiRNHZ0BQELz?=
 =?us-ascii?Q?l0AZ1KM4Xg/qQfvRqc53whGJeluPepgjPB81D9PKiM3+R4mXlY0DpJhtPGyL?=
 =?us-ascii?Q?hkmvZq8xVG1P1ge+DDVvnq4ioOMYwdhlXqpk0eYrEgfWz2zwIJY0T1qkS0yn?=
 =?us-ascii?Q?DgcVZEqJER7jfjzGDE5ZmC5zw7ixg8jbs2b+4D5yum9xn4w0jji84P89hrR0?=
 =?us-ascii?Q?j8O7kjo6fi6ln6dNTteeE1uexdaivPgxCLZ6MOpzAc+uo3hervG2Q/ZLi7Ad?=
 =?us-ascii?Q?uWz/BuDx8gAaRe5gZa0AFLemImVRu9rzS5HNLMextJBWOVErXzlspgrIJ+2K?=
 =?us-ascii?Q?YHtq1xImhojdH/l21wNnBT9qM/QPVbkO3d0UI+OkIuklsoBn+34+GD52Z5LS?=
 =?us-ascii?Q?grTL0HMtlgvYI2oNoujDYYiYSF/CjaDZeF6B+V8dV9GbkxnapRFE1W84cnvh?=
 =?us-ascii?Q?Oen/Opot5YA/8nlg+ejjFh5AcQPUzMrSswb0/QKGO0QB0znPTDj0v6HnTmio?=
 =?us-ascii?Q?t0TtQEQJvFJsOJekiMnyGye7llgXbnTNafV/A/eTn8hVF62NdlFce9cCRcFB?=
 =?us-ascii?Q?Y3N/bYKcYmwzx7i1I2I8BW8QUJPdsNIa8AU6JHcfvtHmJt/R7EUv3HLktixf?=
 =?us-ascii?Q?OxAYCg0G7LGieN8CnZbik3G7py/Im5hX8Ew1bi0HJ3VcfOsgwzrC8RILw2PX?=
 =?us-ascii?Q?dlqX2PaQfMBxp5Do+Sh5qFVZAvh+yTT2ipYB/kj7MuZmzRsZEpqpjDpuy4OH?=
 =?us-ascii?Q?mFE69g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa821467-0440-4d42-6261-08db1422a717
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 15:45:26.9997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +CYKr6oqiFPaJLJL4QstThZfSBJ9HO6kaH4SYPv62MaT99SzdkmUdgKknI5dHNzS2bEq2RfuCAP2o+zc3+C7bLDQ/0CEuw2a/pnnh6FCa08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR13MB6229
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 01:28:49PM +0100, Paolo Abeni wrote:
> That really was meant to be a per netns attribute from the beginning.
> 
> The idea is that once proper isolation is in place in the main
> namespace, additional demux in the child namespaces will be redundant.
> Let's make child netns default rps mask empty by default.
> 
> To avoid bloating the netns with a possibly large cpumask, allocate
> it on-demand during the first write operation.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

...

> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index 7130e6d9e263..74842b453407 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -74,24 +74,47 @@ static void dump_cpumask(void *buffer, size_t *lenp, loff_t *ppos,
>  #endif
>  
>  #ifdef CONFIG_RPS
> -struct cpumask rps_default_mask;
> +
> +static struct cpumask *rps_default_mask_cow_alloc(struct net *net)
> +{
> +	struct cpumask *rps_default_mask;
> +
> +	if (net->core.rps_default_mask)
> +		return net->core.rps_default_mask;
> +
> +	rps_default_mask = kzalloc(cpumask_size(), GFP_KERNEL);
> +	if (!rps_default_mask)
> +		return NULL;
> +
> +	/* pairs with READ_ONCE in rx_queue_default_mask() */
> +	WRITE_ONCE(net->core.rps_default_mask, rps_default_mask);
> +	return rps_default_mask;
> +}
>  
>  static int rps_default_mask_sysctl(struct ctl_table *table, int write,
>  				   void *buffer, size_t *lenp, loff_t *ppos)
>  {
> +	struct net *net = (struct net *)table->data;
>  	int err = 0;
>  
>  	rtnl_lock();
>  	if (write) {
> -		err = cpumask_parse(buffer, &rps_default_mask);
> +		struct cpumask *rps_default_mask = rps_default_mask_cow_alloc(net);
> +
> +		err = -ENOMEM;

nit: Would it be nicer to set err to -ENOMEM inside the if clause?
     I think that is the only path where it is used.

> +		if (!rps_default_mask)
> +			goto done;
> +
> +		err = cpumask_parse(buffer, rps_default_mask);
>  		if (err)
>  			goto done;
>  
> -		err = rps_cpumask_housekeeping(&rps_default_mask);
> +		err = rps_cpumask_housekeeping(rps_default_mask);
>  		if (err)
>  			goto done;
>  	} else {
> -		dump_cpumask(buffer, lenp, ppos, &rps_default_mask);
> +		dump_cpumask(buffer, lenp, ppos,
> +			     net->core.rps_default_mask ? : cpu_none_mask);
>  	}
>  
>  done:

...
