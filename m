Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08FB6D239E
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 17:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbjCaPIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 11:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbjCaPIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 11:08:41 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47985C174;
        Fri, 31 Mar 2023 08:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680275320; x=1711811320;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I5OydxUZvs4WSFmgxCkmOCOyhBjbAEvkf8u0zit5lTQ=;
  b=EBs8+pVwpL1dbCrAINhL7ZfRsn0exzNEuXvGD2qcm1xWqe/j6IEGSLHn
   PDT1o4Md+5xVu5d+/LH7pH8r+T0cA1rcFgjZwVJo4AxQlcayeklU/6ACc
   Mp60uElQQxdRaY7AO4yLQ3YbR2D5eCrSzfseuPVJXtqr/E81g1dWj+2FW
   EkkOt4YiBEVKw6JZnaRnJ5rTe/TPu7O7MfCBjDd1QG9aY3F27aQJ8isZz
   ag5hpwIdZL2hrC6hIvuYWuaJZDHc+vopfufRbvGIlPVU1FDdBBRPNJqt1
   6kMWL3iyz0LnW58FBYVMemDdPC68h1LUfev1zwDYH0RsSVWPqb/hOlOsH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="321127485"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="321127485"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 08:08:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="774391103"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="774391103"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 31 Mar 2023 08:08:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 31 Mar 2023 08:08:38 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 31 Mar 2023 08:08:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 31 Mar 2023 08:08:37 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 31 Mar 2023 08:08:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ObNwKgNQRHcU7MS4cTZAXdkIWQ+6HCrecRXF6d9Q4ywgjNAFIOVHCXwIRw6kJS0v0arzyUbIS62Qc82mlaouTaEI84NlzEjCTNzvqwZP9dTeQcSMX6v6px4kuziEThXqxL/9YOOP8lM/9e8xPBa/AdWOvlTUA1N8EiT5dBZnvWSTmberMS+YJaiWAV87lHmL5MQAWw24OEkUBExRE9WFZmAkyXG0KLpN7yG4sc1qWrOPsvpghH7foshZKhCqWIzoXP9M45J1uOdLodl4iEW0KxjV5oYocD/px5pheXpG0d69qXHWkKP7hZbq9OYIQVEt/oDyL1EAubqSTn8eqmDiUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gddXBbKR139EQrZQGZxASdFVb6fD1lbmyTzFHMX+/Rk=;
 b=k1MPueKeJAyy9aP9MyPB7KjxgtlWaHhrfCABDVfT9sMMpT26ViO+zlSDsOEnYmZN3n7/9Zedf+Bt50yvUgsCKyNJbVE40fvGJWCDsSJhjU+RozKnv5VJNZJiDfm2w4G9EFGDzlfZH+bhg/XEXuJT+BbkP0/49xGZ3u+MUIsUbINk2aWo3qGGeP7Z1O1ndMR6/lHK58p7FmtP4cq8Aq6h4BPOP1IwxdOtJr5nqhRt4VkiRDUWm/cVVPTsB3224CPNZuiqZa/pw7ANQ/PsRM5CfzRygqAFyec964kQyz3LzM8IXFMU79hBj97dhRYA1nDLxu1qqA8JEmBet9NiBHzkhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MW4PR11MB6786.namprd11.prod.outlook.com (2603:10b6:303:20b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Fri, 31 Mar
 2023 15:08:34 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6222.035; Fri, 31 Mar 2023
 15:08:34 +0000
Message-ID: <8dd0ab75-d007-8aa7-e546-c5fe93f9e03b@intel.com>
Date:   Fri, 31 Mar 2023 17:08:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] net: netcp: MAX_SKB_FRAGS is now 'int'
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Nikolay Aleksandrov" <razor@blackwall.org>,
        Jason Xing <kerneljasonxing@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230331074919.1299425-1-arnd@kernel.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230331074919.1299425-1-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0095.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::12) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MW4PR11MB6786:EE_
X-MS-Office365-Filtering-Correlation-Id: 841ca2fd-bd30-40d2-affc-08db31f9cbf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5TriABdorpop1ZbjyU96R6e98EqLXl+WPPe0stdmPmUJ/n+taGNfB6MTFqZ66IHxGOTqaqbMc6E0uwsatCUpnU6cxZY9WgGE4S2EsNs3LxwktXQNhHIwDRQtAf8JPIrw0shGxjC9C9HNgcZvd0tncUh9qhwKtnSm2rG5u1EysMxiuzFONOpGmymQhpspfE/pat8aXIeSrdp1/wCiRjtN5z+hmdjAaUsgrsEcHc2uqOOzsIX+VdjlbmS4UG3qKpsydZjlqC+06ZcHsF6LwWtLJeCTCRT59TXANLYRmQoBjw8gVIGAnHD4aPJ/uPIuyybKz1kXgj09YJd1/B2mwbdCx/y/jwJlybEXBwPqNbfso0oKvs4SmnaX+HQXpj7QcLOjVVjwGVa3IFukv2UvchSblDJMsa3tvZLyjsXVxv5+bcVhzJivBpMjoY5gO8XBNQvEanALzNzQcaT4CaOwAa5rDhhvylHPi9au+vW/9tREg+xQTOGTQ2BEt2bfzQJpUS7g7uO+QlZBtkWT0kfvzqxmz48JZIap8Ny7LNd+5qDlUqxstMCykNvIdjYZof+bRJCFBAa/yUi5DninQisJZ7HUhyhSJOXtp+Yin8OasY3tFKu5XGwoa8z9hjKwWkm6WwEzolu82fsfo56sKMZFwmLAkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199021)(31686004)(4326008)(316002)(54906003)(8676002)(110136005)(6486002)(66946007)(66556008)(66476007)(36756003)(6512007)(6506007)(26005)(6666004)(38100700002)(2616005)(186003)(83380400001)(5660300002)(41300700001)(8936002)(478600001)(86362001)(31696002)(7416002)(2906002)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akRSZU1LYW9lVXQvMXpaSVFsNHdUc1ZtN1hEQmxOWDd6UndPZUZ0MHdIS3ls?=
 =?utf-8?B?RjgwK05RK2hKTHYrMndDVTN4azVUZGFTVEVvTWVLOTQrd2JjY2RWL0lMa2VH?=
 =?utf-8?B?cXRza3BVZm1TeUtTOFVQeEtkMjFTeWR5RkZTbGcwR29BYlhib0dQR2gwUTlz?=
 =?utf-8?B?Wm9qL1k1dHd1QnUrejZCTjQ0bjdHVWhwNkg3MFE2Z1h6MjRqUC9ha1VrMW4z?=
 =?utf-8?B?WWRvWmY5VEpOdXExUmpCODU2bUZVeW9LL0lVQnBqLzBFaXY3aHFKQS90QWty?=
 =?utf-8?B?d1hKREpRcVBOK25GNW1QSFNvUkIwS0x4TmFUbHFTQmxWMFZ1SFh2UHc5VlpF?=
 =?utf-8?B?WlFOYlRKMG5qZ3RkS0xNbVEvclJuamVQQnczUTNsdklXZ0o4c2dWQUZhRnNY?=
 =?utf-8?B?U3VXdmdNY3dLQnp4ZUtjT0tCdkY1OU5Hb1NJTHJFUFJaQWR6N2NhY2tnSEtS?=
 =?utf-8?B?Q3hVYjFiaWc3RGszM0xBTlFTVVlTd3VyWkVEYVdJeWFhN1pUU1NWeDlHUFVU?=
 =?utf-8?B?STF0U3ZFek5lTFlJRVFGcHltTXVxUytibDM4V1FraFNwREJMWkVHaVBMV1hr?=
 =?utf-8?B?eURkQXhXeTQxaVFrNW91NzdCMHRZYWFaelBrRnFoT05qVmxFaUZxNHI4RW1u?=
 =?utf-8?B?Nis5OEJCWG1DU2JhTXVKMnN5NVJmQzd4cGFCWTRHblFqc01ONkJIY1o2UEpv?=
 =?utf-8?B?TllSOVF6cUE4bXBVZ1V5RWpoZXMxK0p4bUJhbThzdDkrSEFINnVpZVp4ek5j?=
 =?utf-8?B?MVhvLzB5NHlHTHZVM01IcHZ4cG1uaEcxZlpjdWhpcEZTTWdRWnVQazFVdnlX?=
 =?utf-8?B?cnBWeXkxYlJBWnVMYXUrbUF2ZlM0QjhhQkk0V2hYVlhnZWdoM1RhWktURUwx?=
 =?utf-8?B?YktTbXZNaUM3MUJLU05QVXZXQmhFdWw3MUFJb3ZyUXRTVmpzazZLRThHTXpu?=
 =?utf-8?B?a0Z5MzF0OVpsazJ6cXBVQ0tZZnBtL1dHaVBCaXBxYzl1QWRQVFlKMEFzQ3Zj?=
 =?utf-8?B?U3JqUjBPZGpvZ05FdHlYZ2pxSGtuMTdxLzl0VlhUVlBaOXlIMjhWaFlRRGEy?=
 =?utf-8?B?ZEtEb2dPaHA0MXVmd25VK0dlWnhxdTZESUhLUEZaaS9QZTMxRnJ0WnQ0azk2?=
 =?utf-8?B?bW5qRWduNFc3RGxydm55WkhHY3RpNnp0VE0rZnd1S1lKUlhCcUpnMld3c1VV?=
 =?utf-8?B?dUhlYUtYTXRWSjNHYXp2QndoYmpxK29PMGdlU3FqcEhqWkdyRldRVlNTanU1?=
 =?utf-8?B?NnlyZEtPMDdUb25vSkNodFJZRkEzNERvS0FQN1N3S3RnLzhvWUhMNU9zcys5?=
 =?utf-8?B?Sng4SGRldnVoNjlmTVBlY0pYUEFqVVRoZDF5QnU2VEtQTWZQTE90LzNWSG5S?=
 =?utf-8?B?ZUp2cytYM0lYdHJwQ2pTeG9MalY5bXpTWHFyTXU2cjlIMEZiYjg5c3d0Ym5H?=
 =?utf-8?B?VU0ra1NMb1hxWVFQUTJndXNSeE1EQVlMVERqZWFLOUJXQVFGdm5jOU5OUWEw?=
 =?utf-8?B?VUVqcTFCaGcvZnhpZytaQ0txTGZZaVJqWnVPSkgyMVpRRU1PYWVzUUtLRjdt?=
 =?utf-8?B?VXZteVRKVUdmQmtmM2ZHZUtvaWdqSVEweVRIc1pmSEMxellRTUdjR2diVisy?=
 =?utf-8?B?WitYWDFyYnNMeGs3WFB3NHNNaXRKZ05tN0dOVnIxMGk5dkNLSTJ4WmpMcWxx?=
 =?utf-8?B?bmJWczdMb2sxS01JY0IvNWJwTjhoMEtFbkZ3NlU0anY5MUlPckFZK05ScEo4?=
 =?utf-8?B?VHd3dHBNend4SHdCbHJaVVg4ZjNvNUZXYlplamRub1hhWFZmRDdFbTk0UmNs?=
 =?utf-8?B?T0xaYkVjYlFOSXV4b1BIUlc5UEhrYmY2TVJpLzliWkRVRitRWGVTeGl4U3k1?=
 =?utf-8?B?VERKRmQzTFRMR2RSYTdQdFV0cUFFWHJ0UXZYUEhrczdwMkU5T0pTbEdxWGwz?=
 =?utf-8?B?N2lnRzQ0WHQzSGtBMFd0Rmd3L3pUbFZmSW8rayszMTNTNUwzTmNzTlVJaFJU?=
 =?utf-8?B?YXFKV1czRWNCb1VwWXV5L1U4TlNNWmJraW5IdmR2eHRON3lKbXQ1TEdNSjZJ?=
 =?utf-8?B?eXQyV0RuZzkveVdNTm1aMnQwTS8yb1hXUEpHRkc3QnQ0ZHhFdXBRZGRmWGc0?=
 =?utf-8?B?dEJ2QXJDNHhqbnljRkRCbUhUYStYSTVHaCszODA1dnVaRVBoclhBUGxUNXd2?=
 =?utf-8?B?QWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 841ca2fd-bd30-40d2-affc-08db31f9cbf9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 15:08:34.4079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hi9Z9fImoy9tEbOk0/URvqD2ZF+EX6GDuqo8DviS0I+U9mRfgigSiF00ws7tXanaLrUtg74EHp4ukCFukbtb6gjV2c1NUq0qxLqoveNKiUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6786
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@kernel.org>
Date: Fri, 31 Mar 2023 09:48:56 +0200

> From: Arnd Bergmann <arnd@arndb.de>
> 
> The type of MAX_SKB_FRAGS has changed recently, so the debug printk
> needs to be updated:
> 
> drivers/net/ethernet/ti/netcp_core.c: In function 'netcp_create_interface':
> drivers/net/ethernet/ti/netcp_core.c:2084:30: error: format '%ld' expects argument of type 'long int', but argument 3 has type 'int' [-Werror=format=]
>  2084 |                 dev_err(dev, "tx-pool size too small, must be at least %ld\n",
>       |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fixes: 3948b05950fd ("net: introduce a config option to tweak MAX_SKB_FRAGS")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/ti/netcp_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
> index 1bb596a9d8a2..dfdbcdeb991f 100644
> --- a/drivers/net/ethernet/ti/netcp_core.c
> +++ b/drivers/net/ethernet/ti/netcp_core.c
> @@ -2081,7 +2081,7 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
>  	netcp->tx_pool_region_id = temp[1];
>  
>  	if (netcp->tx_pool_size < MAX_SKB_FRAGS) {
> -		dev_err(dev, "tx-pool size too small, must be at least %ld\n",
> +		dev_err(dev, "tx-pool size too small, must be at least %d\n",
>  			MAX_SKB_FRAGS);
>  		ret = -ENODEV;
>  		goto quit;

(not related to the actual fix)

I'd personally define %MAX_SKB_FRAGS as `(u32)CONFIG_MAX_SKB_FRAGS`.
It can't be below zero or above %U32_MAX and we have to define it
manually anyway, so why not cast to the type expected from it :D

Thanks,
Olek
