Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0844692671
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbjBJTeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjBJTeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:34:02 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F99B7072A
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676057637; x=1707593637;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r4zsLd5ZGAUzst+DIWw3IwR1zYU8z1J0jHZ5hKVpNng=;
  b=Z66gVk2RW4igYCXM9uin7q37ZWWiJGo4/ZcCOBN/Zek1FIqplOxha/OX
   QfJdJcGoc00UU68Q2s31C77SM315oWjaSSAwqRVLViPDBUHqQQmOB1c26
   YTQz7y2zzBgHGtmNDFBcIkuCq/7zrr9reEn0BJCY0jaXGm+0E+L0mcs1Y
   7nCJ57W0PzPpVuOVp47+ritYbQo+qF8bmck0dtqX1LWHE7RKEZtAvKgwY
   CSJ2GMaDty3DPy0D4/OWI13L81wsp+4qg8fI91SE3pBFev1yFspIE+pjX
   +1JWEiLCqIquDAilsZW4uHrf20cv4iAhqNEw5lc67tYsSmwtruG6k38sF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="331812373"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="331812373"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 11:33:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="997049499"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="997049499"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 10 Feb 2023 11:33:56 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 11:33:55 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 11:33:55 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 11:33:55 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 11:33:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WphpB5CZWaIG+bIka37rXAptEC3P2J0dxtZy/SINgqoU1Zt2GpBNpBn0R4XrTHzIKk35eyddooMLhkPCqeOD9i5q9YFd7pB6GHS/WK8OvTUJovciO0H5qJ/UsCTLn2+coSYwfoIFulS0MVK3ItdOZsGak7mjUil8ujtikxHW4/oEyOHqg8zEFliU7SYd3/HIDwtZ5p46mHSUdEGW8cARB/HrDMY/UZmMtSU2pcUtMosrePHp5faMf/4qEcp24JVBrk8EFuSjNhrWJB5cdQvK8PVuuWoVjHSH6U5Rkm8la6uWJjq0Q+mfg67nwFOJcwXB7aF1JN2YRsIS9DbvCiCXZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K52SXvMg7A/as6esztLow0k1JtLbh98ohFt+ibmyxmY=;
 b=ZTGf6+Nwt9DDbD+Yq7gTpq/EvFUyNU7EHDWi6576nQvzJskUlHO0lCEuYLS3zviUduM5reLhEhKCwA37wp/NwMZAriVBn29iuiMVFExhJKVO0xHqtFMOfb6jxfthifl6t2orYlXWFjmb8+80gUixEgp8uJ4zGmtr1oGfbLmDKEepSjxjJkxc/iIanCBmi5i+ZpoWpaE5yMHpnRKqNdiSRES0FbIjHFn7Ii7pgmQ4sS2lbyQJJfckkTTUePlZPv4gC7Pv3bsSBWEtmqH7buWANf0RRBpoKI7QXRdrNLogoflJ/HaAFJuN/RXFyp3RXSNKgznuS9hvH6yEMTfCXuqpIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by IA1PR11MB6467.namprd11.prod.outlook.com (2603:10b6:208:3a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 19:33:50 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6086.017; Fri, 10 Feb 2023
 19:33:50 +0000
Message-ID: <2c5a1a54-abed-9fd7-cce1-dc9f7c06ef24@intel.com>
Date:   Fri, 10 Feb 2023 11:33:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v2 1/7] devlink: don't use strcpy() to copy param
 value
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <tariqt@nvidia.com>, <saeedm@nvidia.com>,
        <gal@nvidia.com>, <kim.phillips@amd.com>, <moshe@nvidia.com>,
        <simon.horman@corigine.com>, <idosch@nvidia.com>
References: <20230210100131.3088240-1-jiri@resnulli.us>
 <20230210100131.3088240-2-jiri@resnulli.us>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230210100131.3088240-2-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|IA1PR11MB6467:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c1d82f0-62d1-4971-7d24-08db0b9dbc24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z5QbRxQRnJIWJ7fzOqI80BuxJI+imOBG9Hv12FCAa3CYkxtcWvDD+silVKsDAE7xgH2U6zhR8/AWOe7dl8rmh5qTix40ykfMQjKElHVwyKptjftoa1VXgkowUJELjaSiMvCARgjts2EdKZPBbu3cFh+Undfw4ak8SkmEnkMrMLtn5k6CD34dSNw1lHgFsMVbcnUW8bYejQ76MBLhFw5Dzv9tkElwCRftt3FMLqrFF16QIMuINiWALR8WGSlntP3777v7F9G8eU21QD9f2vlfvQHK7pxyq8CiBLhxXn+xEL28vE8vBn5CL/jb1la0hTi6xDfbf7yuGgWGhLMD8poa9Er1lNqbHTX6SDoGXcU4QysoMaaBmJcmEnvcD/cU8PfJVETQjf9oi2flwDa4osm3RFmg+cUnqg8QLvxgJm0G1lesjFhFhVcPI8lojTi4z9tGZwOtjTmcR0mKDNc08/hEDOmyH2zGZGtIcrnQ4itsUzvkyYC1ZDnRYyVw86/6PM0pRRdrdB0B0vDSdZjFcXx68ES4SbqlNmskKm3zMm0ZJ+3JJDCZgDqswykHdSE6ZNNTDyVE3wJEiCNYcEJ0WVAlK8MiLkg8etoPg+jRfKNYKKA2Hz+4t8PvWWOH1qP7DBCJEk4H/yiMSY1k3l0u2uqCykg076Ys0Xj1cBevM1UAOeukPoPUhEctRVFxpZsPluoQgaL7eXDrmT6zBR/WAV/X7NDjK9uo9ROjW8fRKn+Coy4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199018)(316002)(478600001)(6486002)(6512007)(5660300002)(26005)(186003)(8936002)(53546011)(6506007)(2906002)(7416002)(83380400001)(2616005)(41300700001)(38100700002)(82960400001)(8676002)(36756003)(4326008)(66476007)(66946007)(66556008)(31686004)(6666004)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ti9haE91d0FKcjMvSVlCQmVreFU5eUpPM1BDNHlnbGgveUFZM3B2ZTJiUnVz?=
 =?utf-8?B?dm94bnhGdTEzb093YTBzaUIyekZiNlpzNEdMWVQvN2VlKzFzWXdubndUa05T?=
 =?utf-8?B?MnFyQUJjOVNHTUFZUzFBY041elBLUDM5U2hsMnArOWJVOCsvMjlJanNwQ2o4?=
 =?utf-8?B?Wmd2MktzSThZR0xYV3VGd05FaEJYdU1mOThibldFS1dFUWhTQkI0czlNcDJn?=
 =?utf-8?B?TGFDSW1WWmJLL0J2QWdIRTQzQ2kvcGJLTDRrZ2lLTWdqalovZERUc0dWNVVi?=
 =?utf-8?B?ZjNzWmZNenlMMS8wMm05QzhxR1JTcS9QeEY5K3UvZmZucllPcEtrdkwzK3Vw?=
 =?utf-8?B?Q2tmY1l1MktSRDFrVUVONGJRcVRtY3lJSTRVa2QxOC9JcTZobFgvQ2hVRVE1?=
 =?utf-8?B?Uk0xeEZBR3ZXTStSSDcvT0RmNzBwYXFOMk9OSjBVY2F2T1RPTm5jNkh1VW5B?=
 =?utf-8?B?TkxFRjBTSjFsV1VtTWd4U2YwN1pOK1NBMndJVWJkeEVLdEhSVmRnd2dUMmxx?=
 =?utf-8?B?TENwQU84OFZERjdOOVdYaWtSTGN0TDZ6VGRIMndOTHoxME5ha2F1NTJDaTJs?=
 =?utf-8?B?YzAvUzRETFpyRU0xVkxReW5vMXlVQmc1OXZVRUNVSnZjZWxsdmd1bTJhQ3lX?=
 =?utf-8?B?M2lTOXpqUkJYTktjRkVqRE1SQzJJdythbGJ5alhPL0MxdnNpcElMcENza2VF?=
 =?utf-8?B?U3pYVjJLSEUvNG1yQkJyT1dTUjEydWhjSCtSSDl3TkJxUnJhdVFFZllHaVc2?=
 =?utf-8?B?YWZWM084cjgxR3k5a0FVOXBURUNzYmtBdjNFMndpdkxjNU45MVkxYW5ZN0tI?=
 =?utf-8?B?b1V2MUE4MzRuOXRVN1E0a3JCcFhqYW1XMkpZRTZOclArUWxRTEwzR09idkhK?=
 =?utf-8?B?Vzg2L3RQc0FsZmJnYXZnaEhtSkgyelBxaHVCSU9JVjc3UEYwemwrSVlQL2hI?=
 =?utf-8?B?RFM2VDNzMkt3MTBFbUVqWW93YXpGaDl5RmRUZlJYWjF2ellxSkN3aC9tUW5r?=
 =?utf-8?B?M1F1MUovYzRjR01SaWwwTmZSeGplWGIrRExCelVIU1REVzBoVFBPSjZuKzA5?=
 =?utf-8?B?YTB3WnFHbzlGTHdSc0xNSUpRK3BuN1hoelJoY2VVQm9UK05mdFphWVAvZmdu?=
 =?utf-8?B?ZWlyRHhjbEMvT1o3emFTSXV5R2NsbE5Vb1lMUXpmd2tndXc4RkdKQ3hwQnFX?=
 =?utf-8?B?Q0RBL2hiOThST1BwWFNsb1NNN0hDNWlodnZIN0dJRDVXUU1FWmpWemo3cXVh?=
 =?utf-8?B?VC9neVB0TXc2bnQxZTVVTG4xOFhubE02a09DNytiRjNvZTBIMVZ3R3FYNS9t?=
 =?utf-8?B?MS8xb1Q4YnNsdXpQaG9NVkl6OEt3Y0xVR1pCRzZ6Wi8reEdHYVU0TVJmNVNq?=
 =?utf-8?B?SEtmMzlLeUhIYUwwNkZMeUhqNXlYQ1dJQ1pNUm93MnoxUEc2Umsya0l6d3RJ?=
 =?utf-8?B?N0xGbnZUdVcrRkVJQ081WjQvV2toRnBZWUdQck93MjZEL3dic2lhbXhPbGo4?=
 =?utf-8?B?Z0hJOG9nOEcrN1ZJS3VFcjg3c0JNOGR0RjhMZW5LaVJZTUNvaE5wSEgzQkVY?=
 =?utf-8?B?SDFmajltelQrRXptZEVxYnUyZFBqUXlTNzRucG5ycE9Vbkp3MFREVFhnQlFy?=
 =?utf-8?B?aFk5amcxekNqYW96YTViVDQrVGNGNW4vbk4wQ1d0dVJoaktYQ3RjVU0rYW1u?=
 =?utf-8?B?a3RjaXo1ZVNicG1GUGY2bm9LaEpQdU9MSmF3a1pkZHNGaEZjNHFSV1IySDBP?=
 =?utf-8?B?aUp4b29BS01yeHBhZ1Vac3htaVJaRDRkVFh3QnE5THloRnJWbkNDcTNSVlBN?=
 =?utf-8?B?aVNwM3UzL2REa2hQa2ZhNWhIcFl3WGdaVm45c3JBTjFxNlQybnU4bjBmMDVj?=
 =?utf-8?B?THQ0TkltR0RBMlBsV1k1bkFlamNNelJQQjZ5Wk1TSUJTTEVnejlGamFsQlZt?=
 =?utf-8?B?cFl3OEhnemlqY1JnaG5tZ1Y3a0t4djFHclgvVEVEbVU3Q1czcHBxRU5QSDBG?=
 =?utf-8?B?bW55SVBHdkVycWVKaFJiVTJET3p2UWYyckJEN2ZvUFZkQVNCZXdRcm9UZmND?=
 =?utf-8?B?UE1hYThWOFlSRjhmdlhNcE45MDBmV295bDlkTi9JT2FhS3BMcHBFOG1UR0xM?=
 =?utf-8?B?V2VPOFNBZUhsYnNwbW1pZ3k5ekwreFkyMm4yK2E3aEo4ZTJwZ2pibElPZ3JZ?=
 =?utf-8?B?WUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c1d82f0-62d1-4971-7d24-08db0b9dbc24
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 19:33:50.1866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1UBqGoNMpob0vahU4sGPdtg7+HrWIV7iQGTeCBP6ATQa1pZNqUg4LrjJbXuTkRo2jwSgwfpDzMlHhddWutPd8t1JqZ9qvkOXwbSkyBMBVrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6467
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/2023 2:01 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> No need to treat string params any different comparing to other types.
> Rely on the struct assign to copy the whole struct, including the
> string.

I suspect the strcpy came from thinking about it as if it stored a
pointer to the string and not as an array struct member.

Makes sense.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/devlink/leftover.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
> index f05ab093d231..f2f6a2f42864 100644
> --- a/net/devlink/leftover.c
> +++ b/net/devlink/leftover.c
> @@ -4388,10 +4388,7 @@ static int __devlink_nl_cmd_param_set_doit(struct devlink *devlink,
>  		return -EOPNOTSUPP;
>  
>  	if (cmode == DEVLINK_PARAM_CMODE_DRIVERINIT) {
> -		if (param->type == DEVLINK_PARAM_TYPE_STRING)
> -			strcpy(param_item->driverinit_value.vstr, value.vstr);
> -		else
> -			param_item->driverinit_value = value;
> +		param_item->driverinit_value = value;
>  		param_item->driverinit_value_valid = true;
>  	} else {
>  		if (!param->set)
> @@ -9656,10 +9653,7 @@ int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
>  						      DEVLINK_PARAM_CMODE_DRIVERINIT)))
>  		return -EOPNOTSUPP;
>  
> -	if (param_item->param->type == DEVLINK_PARAM_TYPE_STRING)
> -		strcpy(init_val->vstr, param_item->driverinit_value.vstr);
> -	else
> -		*init_val = param_item->driverinit_value;
> +	*init_val = param_item->driverinit_value;
>  
>  	return 0;
>  }
> @@ -9690,10 +9684,7 @@ void devl_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
>  						      DEVLINK_PARAM_CMODE_DRIVERINIT)))
>  		return;
>  
> -	if (param_item->param->type == DEVLINK_PARAM_TYPE_STRING)
> -		strcpy(param_item->driverinit_value.vstr, init_val.vstr);
> -	else
> -		param_item->driverinit_value = init_val;
> +	param_item->driverinit_value = init_val;
>  	param_item->driverinit_value_valid = true;
>  
>  	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
