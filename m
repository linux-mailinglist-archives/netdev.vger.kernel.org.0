Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6729A69984A
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjBPPFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBPPE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:04:58 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2408131
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676559897; x=1708095897;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+FumyZ5PhMl1EIpWksrrZ6TtLYZdIheXLyAOXkHfI+0=;
  b=lJEEMg8GnjgqYHQw/pxfo6HgVSY70j/nVR23dZxRbk2DcV++04urKaTf
   3BOWF+W9sBZozQfNwfgvKgMxdb7jLRZRE6wat6srdH2Od5cQU2Mhud1LJ
   V7/ta/fca7cL+Drm5jXhVgpKT6WmIB7LPbgNztXRhpgzlpQhIAl0EWHbN
   rCXA9em5DPEecRdSzjj4YBc7Z8NB+pr+oNPesyTfcH2/EckXvKsrT2WAj
   oG/Swssl+KNuQQ+KgSYQY6D4ifbVm7pFd3kabTVoqgRrKB4WIlA3gKN9j
   qqAvg50apf10JtprirQFUVFlbhADoL/aZRcQCdfSvioxFZOcoy+1+5Z2Q
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="315417633"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="315417633"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 07:04:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="672177907"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="672177907"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 16 Feb 2023 07:04:46 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 07:04:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 07:04:45 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 07:04:45 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 07:04:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJbgVghBqS1ncVGj/JLlIygDurkJr0EW37XdrZYfHcs3ShJUNLb92FNd8ODsfM+5y+KHXu/TDOKqagYJVbTZFNA50JFag/P+nJW6CuCOT/hg1mSr+QYE0EQPkkJfRfKmqRQ7mJgjSmbPo3PGGmPYmJDJ4osIASSTCYRN61amYMntfdYRDwv+NeOpPtjFmnM3Sdev1DQBlc9qhqGb1ZJFv9Yrf0Vus+RsdRevf7485OHJ//n3FykYB4slO08foFs+lGqhIRsOKRFOKt0TKPfCcaFs0OLi35p9d8YxBokbYNaZwBNGJlP9gGpmBIRSQRjfTtYr3KB87VH6ZynUxejNXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BlaFvHa5EW4Wqms6wKoEcf8RpbKIWzp2iRsW2DI6q2A=;
 b=dI2Ff+20Ak/yXVDBMkOxSKSH12G04dR9k+EC5OP82wciSqEhPO5zpRa/COu7XlHrYv/1Ei5nxyPp7/ZDLGZhMfAxacRbdiCKKWJu3UATeH1UeyiVhu3Rxq8dIhwmxX1G69YkVgvi/CYaBz6fAV+2iEl3TStxGYq+3/fKJlnR3lYnupnX721IIadjk04piKCbdK3gGo3tfJqYD72nkv+YXInO0fO08Mh07nq8OR5TclZAgF4Fq84Q6X0Tvm50nb94MxSK2y0eYLrICKybVPEZLG2zQFV1H4wGdJ4ObAvdbM4eIISuQ1wp0DfrY8oXgxuMLkH0I5UCdWUfSspYrIP/xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CO1PR11MB4964.namprd11.prod.outlook.com (2603:10b6:303:9e::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Thu, 16 Feb 2023 15:04:43 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Thu, 16 Feb 2023
 15:04:43 +0000
Date:   Thu, 16 Feb 2023 16:04:36 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [net-next 2/9] net/mlx5e: Remove redundant page argument in
 mlx5e_xmit_xdp_buff()
Message-ID: <Y+5GBFpx5M8rCpVq@boxer>
References: <20230216000918.235103-1-saeed@kernel.org>
 <20230216000918.235103-3-saeed@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230216000918.235103-3-saeed@kernel.org>
X-ClientProxiedBy: FR0P281CA0149.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::16) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CO1PR11MB4964:EE_
X-MS-Office365-Filtering-Correlation-Id: 47e0e59f-a151-434b-2edd-08db102f2269
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cgdRNvMQ546alVuepKahv7pw7KXhSZZ3pbNQ7BS6bwfiXSCSC1VSeFi0vRINFSDUa1cDHW1+NapXLXeea0FdinQqDq+h8ApZ8663GMCJPPoqrmK7/UhoAR0y4y3cFSZfwS8YyoYIZuBiyjKm+axStKXm2+XiUjApdAQI+RvY0+tY++5MnMK5jWx0aOf1bCHSb4uMQ6tCLOXa13TuZsMEMLepoa/ugN7Xo7Sqva+8oMb+FVEjWz4UrBg9GkoAv2Jk4aZairQ6Tro4WtOM6VG9aFPamzprwlMqK3QVGh8xsVb9LmqkP5NsqNSqR9U2YIwi74hIufzYVpA5TTcJMEbYXKKagZbGOR1iwWVF9Up7ymvCEOPy7Oiv05nLv0FU2YsCwSizM2mAhOjFboCEk7GGulC95hj9EVvLqog6SPtKu9JhtvNjxslHn+nWxNRE/oCVBCnLc6GWjg7NfyChfq/EECXjywfkT+jAa00+aVmmzWNjaE1O13xnWYfD909hypLTF3QSWFO4WVybnrhOcQBfQIxFgs4NKGkVMHFgQoIacT8/PsopokxvUmS0rBB7w/ZgzRS52HNwiaTQxtYuTwH7wM+TaZvBxjlP/A5z64XSlpMxoVSCRP1KCGBUthuXTLoSFYkHyIaDRBEulnLKy4XnIzIUu/o1/C0j3JMq4FeTkyx/M9k8UrkYcY7vTF2rawMP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(396003)(39860400002)(376002)(136003)(366004)(451199018)(44832011)(6666004)(316002)(33716001)(54906003)(86362001)(478600001)(6512007)(9686003)(2906002)(66476007)(66556008)(26005)(41300700001)(66946007)(8676002)(5660300002)(6916009)(6506007)(4326008)(186003)(38100700002)(6486002)(82960400001)(8936002)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MJ1a6edla7Owq3gmvkue9t9OwuwdyFvOSq45448dLBSAQy8OGGxwFeSLGyYI?=
 =?us-ascii?Q?8KZiKkzYliGPAnGJ20pf0ZQbBVsQflr5t43av7ssiF6SBJRK6mmsYAgSoDRi?=
 =?us-ascii?Q?h+NrwN709a+3OQWVfolg/F9fZW5+zGW17WxwyR2Bf95EXdt2K6o6XjGgiBt/?=
 =?us-ascii?Q?YhtJbFpZFgLLAeEKtDTAtbha3Kh/DfpflaWsJFsQCi2nzOEmj112Jr+aE3jh?=
 =?us-ascii?Q?AxUbtN9lZETu71vtfRivKqV4VHbnZVDxWK4w+qQabEDd+gjJmR68/fvcr5/l?=
 =?us-ascii?Q?5DPfFH2lAWhcRkxPJ23m1LHCjJ7ecPUAnMaCg4Ocr7XefeznqoZJkm9rbAVG?=
 =?us-ascii?Q?l8LFsUSWgemyNQg5NusbHYF5iUgJkFYgLtpKMwwp6AyI6m2Xf+AtMJkB2IWs?=
 =?us-ascii?Q?8WjgKTK39Fg/cwOCt55D0dEw6ndIiI14mQaOV23DX4PV5nS5n6y9pSMNCrIA?=
 =?us-ascii?Q?q/fwEZmv1t3azRRHZXPc9mYn+nAnt4vJEMkEFJfltN7efzUk0UaM+WdCx8AK?=
 =?us-ascii?Q?eiAPlQ0Jdi94ETegXQkzEdbyBvF3ruURFa0kOLdXoWcWAvYQVx8UkwF7G614?=
 =?us-ascii?Q?9rvZGl0gh6Y8QnOOhKCWiy9Cb55LJbGqP9EexbhYU1CGXjkrGt+A3ZsJloGj?=
 =?us-ascii?Q?pD7CabUKi4UUOk28m+OjZLK0KUo6TAMDfcujIKQjm7BRPOCG7dbrdPhIDODB?=
 =?us-ascii?Q?4S+eRslb8Zwit2wViVEeFB2bLpLBjFMjmELwD5JuqCQKcCMg2vPfFUg4NEMa?=
 =?us-ascii?Q?DJ6ZhUK452UA/8XzonzMor1voPRg+r0ypKvgDWC3uOiBv91qTXWTLhTNLzNh?=
 =?us-ascii?Q?gyqiywE5U0sRz8h0B2BaNDGMbnx3h2Vam//ivR4Fc8l1fZyc3DQsQKzFRu/p?=
 =?us-ascii?Q?Cd79Zhgcj26yZxpGHMNi0K0OTq171cd7GIbgNLzyyT68Ym7vilJpzb/JhTA1?=
 =?us-ascii?Q?2/FpiIGjVtmsg3C1wCRbve++ZrnbaNbkSRiPEn/bjCjTod0qNNkTA/0K7Ut5?=
 =?us-ascii?Q?QY/cD4sipJtqegmor4WHoZFRbb8O+znAiCBQPNiZf6W29Ac8HFPsN3am0m+D?=
 =?us-ascii?Q?SUYoWH2RRp97zxA3D0KMAnh95AoD6FMUvGOPOfCeNcj5yzaB6ydZXgwVTQZI?=
 =?us-ascii?Q?1T1R9wroFuF85q5ukCcyUToehrGPeuSyvQRQBRbmxX1QVN7BlUm4Z6aqfjZp?=
 =?us-ascii?Q?GSMR5gRM3POsMFyx0HFvxs2uJ1Zrb9VyBSUXBGywQbDbhpJkDbSWy3NOBDgt?=
 =?us-ascii?Q?8obDrz8hFeUfuZi0gEp2yjDqEQEQAtM9fFPkTktlbwrOrehB6GzQNXX5+POM?=
 =?us-ascii?Q?PwcSbPLIqJsIaKDobf6QBXItyTb5qolR8ntJa3TdRBHZt0hrS93kuyYo4zDv?=
 =?us-ascii?Q?FgbHcbAUbvTHO5M0IOijCDPULY4pA1Bzl1mzVyIIpZOwV1UU2WpFFTCSceDP?=
 =?us-ascii?Q?ftj52bSU7dFui9558l/kuAS2WlMy6snJpsd5l/dtFgtfma7GSm4EeIEjmCuo?=
 =?us-ascii?Q?0ij2nrC3LDzBxp6hDOSQw7e6iLsfRWeSdscPXtGwM3lrlMGYmbGOdNvhuECu?=
 =?us-ascii?Q?ATmxXllqwYdX78MwBbrgdMtMhGu3KT7Hu8rQt16gRBaadHQfeeCAGQCz13Sn?=
 =?us-ascii?Q?KFBjM0WdE1iEHFr37mDHAGU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e0e59f-a151-434b-2edd-08db102f2269
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 15:04:43.1445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MmkAe8BJCnflcbOtfmW89XIrdoh5u1wxvAIVV95vw9+sk/QFAcSODFSubDJZri3gtvmqYT593ckt/ueafUpO/1EFMKg+ejpywmL1DJRY2LY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4964
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 04:09:11PM -0800, Saeed Mahameed wrote:
> From: Tariq Toukan <tariqt@nvidia.com>
> 
> Remove the page parameter, it can be derived from the xdp_buff.
> 
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index f7d52b1d293b..4b9cd8ef8d28 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -57,8 +57,9 @@ int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk)
>  
>  static inline bool
>  mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
> -		    struct page *page, struct xdp_buff *xdp)
> +		    struct xdp_buff *xdp)
>  {
> +	struct page *page = virt_to_page(xdp->data);
>  	struct skb_shared_info *sinfo = NULL;
>  	struct mlx5e_xmit_data xdptxd;
>  	struct mlx5e_xdp_info xdpi;
> @@ -197,7 +198,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
>  	case XDP_PASS:
>  		return false;
>  	case XDP_TX:
> -		if (unlikely(!mlx5e_xmit_xdp_buff(rq->xdpsq, rq, page, xdp)))
> +		if (unlikely(!mlx5e_xmit_xdp_buff(rq->xdpsq, rq, xdp)))

is there any value behind this patch? you're not super excessive in terms
of count of args that  mlx5e_xmit_xdp_buff() takes.

Maybe don't initialize this right on the start but rather just before
getting dma_addr? This way XSK XDP_TX won't be doing this.

>  			goto xdp_abort;
>  		__set_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags); /* non-atomic */
>  		return true;
> -- 
> 2.39.1
> 
