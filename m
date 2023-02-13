Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC70694C06
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjBMQHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjBMQHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:07:43 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E52D1C583;
        Mon, 13 Feb 2023 08:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676304462; x=1707840462;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cCIt9Pjprk4wnkO7QXt9+CpW/Nnjm3pYRjARdcTDYFE=;
  b=daWS7kac9dPCRcvNmyxvUVXF07oK4TjnMxoT9ZEYus6tIwifbXS16YKj
   StJx02aQTt2+I9dVPk+eu5q/zhUauTafurOsm+EmEZJvDEtlKZf2JD/y0
   bGNng7lEeZk6o8h+azD0oAHwKdd8E+zdxViV+1ZZRSoSRBD84tmnHvPHn
   ACUlnnPhII/SotIlPC/EWATAhQNPmg03UXkXwA4j3L6jhcYE2AjdoOh9M
   yjHt+HWltdH0E8FGkiFaeRmIT23mJycr6h/32GmzJle9FlRNmTFuLZccQ
   LOgerlcnqT9v6wUTuPjCqsLj5KJMOlg4BxMV3Fy54t7v+5V77RqWxILJS
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="310556362"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="310556362"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 08:06:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="701312258"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="701312258"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 13 Feb 2023 08:06:04 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 08:06:04 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 08:06:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 08:06:03 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 08:06:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnjCxUQ385yTOn1YPr3LTA05EBBBtzytUG9JhDKfjJ4vCj0QyqupDxNealWhyMFEQ4SSgVZktR2w2cgQwkYSsLQJ+TlPUAhJBX07OE4WkGm9fqgkmbB+rAvrLizB0tP+jvZbUaduXnRCjvLn8CzB0AY10fqNHiEgkCPXka2e03w3cMmIRwlQwiMHz7s48HcCGef4ZIZbDZyAB4EjzuOfNqrUphYNrCnxhNwCyJZLQadlcm5UB7By/I6gB9Yu/SyK2IDgmtZRflY5cfSEOTOL9R3pvIT8DKrC7uMH+5fqnM/Ba162pnBbTtklIJ5pBsbVq0uS9QT1S+j5MkN5IjOQUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nHeSB4Qal7jF/EyE9jmVwXOlzBfW5Gu5XdfouK4ahCo=;
 b=Yj+7DMLwK6Yd70BzFdy2XeBzkE7vv7z4r3gKN1AxxVjOzS4IN88EAOU3UHyNOBm0dYZYI+GzZ1sQ/QRwQnj0jiPem2G+jCB8qyrN+bmG1CyGqKrt2L1r9UoxzXZjMkbS3DJkkZLQKORUCFIs5Oa15jkbiGmCmnyn/9kSdBxwPHW1YrveI8LbY53VWavb9CrtAXmyqSkd0S9dz9sKs6aFpGCqhLwTs9FsL7L6JurrDDD7+0lroQrviH/r5PR9E8toAD0RmUWvcJDgo76q2AYrAC45MiuhefF7m3VsGX0pkWNEpIQDGuasTRz1MnwRJZpPw2it+n3b/y9OtBHMDuLP/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ0PR11MB7703.namprd11.prod.outlook.com (2603:10b6:a03:4e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 16:06:01 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.017; Mon, 13 Feb 2023
 16:06:01 +0000
Message-ID: <ed27795a-f81f-a913-8275-b6f516b4f384@intel.com>
Date:   Mon, 13 Feb 2023 17:04:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH V2 net-next] net: fec: add CBS offload support
Content-Language: en-US
To:     <wei.fang@nxp.com>
CC:     <shenwei.wang@nxp.com>, <xiaoning.wang@nxp.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <simon.horman@corigine.com>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-imx@nxp.com>,
        <linux-kernel@vger.kernel.org>
References: <20230213092912.2314029-1-wei.fang@nxp.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230213092912.2314029-1-wei.fang@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0008.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::16) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ0PR11MB7703:EE_
X-MS-Office365-Filtering-Correlation-Id: dfb5d7cb-654e-4ec1-8a2c-08db0ddc33a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ExzJ6YlCBjeyZwI8S347+2ulpSYmINlxtXGJqtErodOnFZBVpUXLgMc0jl9bGUMY5MFX89LzDnMBTM/oygE2kwvF7CGVhkTkB2+G81Wd+5WCetn87Xxg+4OXIoFu/RkVFtawYGV/OmSsQc6dp6NcEaj/1FPqMpH+j+2L8BbUtWX5UPYCvr0orqJq0xmrsypiWQz8IqFtETm43JUPwbixIkgFAdf2zjzjdEGrUVYP7ERpCw7B8m1pfCes/K62geJRdXpoxwNFPkNzK9kQvmlh96LShhRx9+nmGuow8280u3zrG1CvVQVcftOUQAG94K8AxduOtoOViVWVSkRKA1EjhjMtiHQ5DS3u89/JASrbmxhyG/b2QMhjOODkJDD8rLNHRyGQwzlV9jLcacjEx0TXLL4aw9cI//3yoMHLl2kiGlr+KV9UdzBVH52YFaMkxMLQzEZsvIvxA3uIcUDO2DU9fL5roeyzxtRrFupvE6vysiCFummioNN30Z4gWev/P37JXjzPlY2oMYjm6lWLovXZMYjBw+NoFkTpExuNkLDXrgYrs4XUK/lHv9hPxZwH4ETfkH+CLp99otv28GGQMhvSqWvWpIVDzw1KNcv21SkGakl6EPakUv6jSHoGtXk8EaKJ0QHmIiYKdyP4a3gvpvG4PO/lY/vfafGh8YqcnoG8DubYrnJC0Q8rzOQ2SKgKZBp+Y+sntg5Sb3rLvTHBtCEjmon4e97yZKwBY+0chkhNyhg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(5660300002)(7416002)(31686004)(8936002)(2906002)(41300700001)(66556008)(66946007)(66476007)(6916009)(4326008)(8676002)(316002)(6506007)(478600001)(6486002)(6666004)(26005)(36756003)(6512007)(186003)(38100700002)(83380400001)(86362001)(2616005)(82960400001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnRTTE9mTzhYNkt2QXArZzNqVHBLQUxlNWkzYTlDdmRZeDFodnRDenZGZ3FQ?=
 =?utf-8?B?U3VzaU1SbHV4ZVR1TWR4WWVGTElOT0J5dlpFQk1sT1BTQ1gzam1wbkVKZ3JU?=
 =?utf-8?B?Sm1Zb3pmMldIZ0ZZeG1aNmJoVjdvWWpIcTVnckhiK0p5VVZEUVIzWFdrVERJ?=
 =?utf-8?B?eHdpNEVPajFISkFFSmtoZmJXcWo4blVOY0Y4SS9nR1p4RDdZYWVRT2t3czAy?=
 =?utf-8?B?OXgvV2ZBTjB4aWxuMHcwdnIzVXh6QjRTekpScStkTDhXZjQ0Y2s0ZkFoek9F?=
 =?utf-8?B?VUdhckJTNzdKTmJmK0p3azNnZnF1NEFnNVdKS3k5b2lYZUpJTkFkMXJxVEtR?=
 =?utf-8?B?cTFsdkYraUpQUGRGSHBBQmdGc3N2MzUwWk1MbllHTjh3bjE0K0Vqa3ZlK3pQ?=
 =?utf-8?B?T3pTeEpFR3E4RDBxVmtEOXV6cXVzTytCREwyUk9aYlJuV0c0QUo5cEZrUUQr?=
 =?utf-8?B?SHVBYU1YQjc3K3QwTEVMaGZGQ0pFalpwdFR6Z0R4SEVhOUUzUVFTd011S1Zl?=
 =?utf-8?B?SStGQmY2NzNtNzVURVRsRE5rQnpJcGhSUWsxTmxVZ2RranBIOTM0Z016Y2xV?=
 =?utf-8?B?L1Q3bklkcHhIcnBNaHRKWmVqV3kweUt6Um5WVkl3cGFJVmNxdkkvVE5YUVBD?=
 =?utf-8?B?Si85Q1p6TllVN2VvWVF3aU1WTVNlT3NyOG1NVmNzU3BjVGJYaXR5My9tSE0y?=
 =?utf-8?B?UjZ6VWJTK1R6NmJSTGdXcENtM296ejJIeE1Yd0hNVnNWd0Fzd1lEb2JjSHIr?=
 =?utf-8?B?YWF4bEhaMTIxOUorRVVNemhyRlZlQzcrZ3UyUzYvVk1CUGU4cGVMMG5LVFVr?=
 =?utf-8?B?RE5MQU5SR3dLZU9UWEJGRXVZZGZHYzdjR2xrSkYzVHZSNGNQUGQ4aUUxRDZw?=
 =?utf-8?B?YmdOL3N2Yjkya0o3MFNUcTF3ZHk2NlZuY3pmd01NOEFLKzZBRHE5bFpZSFc3?=
 =?utf-8?B?WStvckVzV0FUbWZnUStqWmVFVWk0YVJlaDMydzRLRG85RllWYy90NHdvWlho?=
 =?utf-8?B?STRQQUVRV3V2RFY5MEc3WVBKUFVOWW5obDMrZFVzcXZZUnF4dVREcndheWtT?=
 =?utf-8?B?bUpzV1VlTWJYZUR0ZGpQbzlpeFkwcGNJZ0d4ZGNpS3htT2FiVk91cHFuRmJQ?=
 =?utf-8?B?WVR4L2dXZW5JQ2p0aW5XY1JYU2oyTTlleU1DRVNqMEs3Y1JmY2ZLd2JyT1NI?=
 =?utf-8?B?RUVQVTNjalFIc3hKalNJYzN1UnZDZzZxOHJqdXQyL283VmlodHdOYWZLbm9H?=
 =?utf-8?B?ZUpNaHZ4S3d0NEs3RHR6amoxejNCZyswREtzTE0wcTAzVjh2ODh1RFVZY051?=
 =?utf-8?B?bXNOR2x4QmlCMjFJR1RMRHFSK1F4d0FMOGZ3SUpkNzFTREc4MXZXRlh6VkxW?=
 =?utf-8?B?SHlzcWFxdHh6bUExT1AyZmdDM1Q4OU1NQmtLQURvcmY4OFA5bE4zSURCQXZP?=
 =?utf-8?B?bWlJTDJ6dHRCbDNDbHVsMzlrYnR5Znp6dHo3UGJwYzN5UDNkbVgvOTc5OXIz?=
 =?utf-8?B?VTdDbUxpcGN3alNoc0R3UDcrbURxU0JPUGk0V2hCTW9DVmFVWDZqazBDL3dO?=
 =?utf-8?B?YzRJVVFsMjBOUEE0YldpRFRnYlFwNUI1eWNOSW5zVHlDUm5xUWUzbFFha0Vm?=
 =?utf-8?B?UkFDSkdpZFkyeHBVN0FET2huYTRwYnpYd0I4aStmQW85TWFvTWVqbk9neTA4?=
 =?utf-8?B?elZOZ2JPWXdqekxpU3VmS3hFR3YwZ1pDQnVvVjJNMlRJa1ZZcWJiczdTM3ZR?=
 =?utf-8?B?YUxZNXF4MXgyOEhDN2k1UzhnYXY3QXJoUzd0ekRCZWZXbFBJOHNQQjdENk10?=
 =?utf-8?B?cXJ2VXZBSzhCNVVXNkJNampIaDdXdmVqRURnM2VpdUpJVWtoTFFXaWtCOFRU?=
 =?utf-8?B?a29sYk1kWFdYd1JyNnJxM2FiVjl6d2w5cWM1VW9MN0p6Ykd4ZnYxYy9JclJr?=
 =?utf-8?B?MFgrVTFldm01ekk0bGtXRlpSbWdMNnptSlhlNUs4UmdOSXppN2ljZUpES1Nh?=
 =?utf-8?B?U0ZDbHhadkgwYTRpdnN1cW13akZjRGpDTGdvVWpKVjNkallGbE5WZm5zaTM0?=
 =?utf-8?B?d29NellJcDBhOEh6OVJtT2ZWZlY4YkZNZjNkcmttQzQxMldrL0swTFpFMGJR?=
 =?utf-8?B?QVdHdWEyMTgvaW5oZ0kwVEhWM1p2Z1dyd29VeDM1YnpGSVlobFNpSUtZWUxS?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dfb5d7cb-654e-4ec1-8a2c-08db0ddc33a1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 16:06:01.6060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAia2265sYMYAzF8z3mpFC4z+krvvgoOaN6/V/4MS7MQZ+O7/FKYPzKYsy8pxTRnQzOCC3w3Xcswz2SfsGtf4Yztdju+s4vz61pgAfyh7y8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7703
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>
Date: Mon, 13 Feb 2023 17:29:12 +0800

> From: Wei Fang <wei.fang@nxp.com>
> 
> The FEC hardware supports the Credit-based shaper (CBS) which control
> the bandwidth distribution between normal traffic and time-sensitive
> traffic with respect to the total link bandwidth available.
> But notice that the bandwidth allocation of hardware is restricted to
> certain values. Below is the equation which is used to calculate the
> BW (bandwidth) fraction for per class:
> 	BW fraction = 1 / (1 + 512 / idle_slope)

[...]

> @@ -571,6 +575,12 @@ struct fec_stop_mode_gpr {
>  	u8 bit;
>  };
>  
> +struct fec_cbs_params {
> +	bool enable[FEC_ENET_MAX_TX_QS];

Maybe smth like

	DECLARE_BITMAP(enabled, FEC_ENET_MAX_TX_QS);

?

> +	int idleslope[FEC_ENET_MAX_TX_QS];
> +	int sendslope[FEC_ENET_MAX_TX_QS];

Can they actually be negative? (probably I'll see it below)

> +};
> +
>  /* The FEC buffer descriptors track the ring buffers.  The rx_bd_base and
>   * tx_bd_base always point to the base of the buffer descriptors.  The
>   * cur_rx and cur_tx point to the currently available buffer.
> @@ -679,6 +689,9 @@ struct fec_enet_private {
>  	/* XDP BPF Program */
>  	struct bpf_prog *xdp_prog;
>  
> +	/* CBS parameters */
> +	struct fec_cbs_params cbs;
> +
>  	u64 ethtool_stats[];
>  };
>  
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index c73e25f8995e..91394ad05121 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -66,6 +66,7 @@
>  #include <linux/mfd/syscon.h>
>  #include <linux/regmap.h>
>  #include <soc/imx/cpuidle.h>
> +#include <net/pkt_sched.h>

Some alphabetic order? At least for new files :D

>  #include <linux/filter.h>
>  #include <linux/bpf.h>
>  
> @@ -1023,6 +1024,174 @@ static void fec_enet_reset_skb(struct net_device *ndev)
>  	}
>  }
>  
> +static u32 fec_enet_get_idle_slope(u8 bw)

Just use `u32`, usually there's no reason to use types shorter than
integer on the stack.

> +{
> +	int msb, power;
> +	u32 idle_slope;
> +
> +	if (bw >= 100)
> +		return 0;
> +
> +	/* Convert bw to hardware idle slope */
> +	idle_slope = (512 * bw) / (100 - bw);
> +

Redundant newline. Also first pair of braces is optional and up to you.

> +	if (idle_slope >= 128) {
> +		/* For values greater than or equal to 128, idle_slope
> +		 * rounded to the nearest multiple of 128.
> +		 */

But you can just do

	idle_slope = min(idle_slope, 128U);

and still use the "standard" path below, without the conditional return?
Or even combine it with the code above:

	idle_slope = min((512 * bw) / (100 - bw), 128U);

> +		idle_slope = DIV_ROUND_CLOSEST(idle_slope, 128U) * 128U;
> +
> +		return idle_slope;
> +	}
> +
> +	/* For values less than 128, idle_slope is rounded to
> +	 * nearst power of 2.

Typo, 'nearest'.

> +	 */
> +	if (idle_slope <= 1)
> +		return 1;
> +
> +	msb = __fls(idle_slope);

I think `fls() - 1` is preferred over `__fls()` since it may go UB. And
some checks wouldn't hurt.

> +	power = BIT(msb);

Oh okay. Then rounddown_pow_of_two() is what you're looking for.

	power = rounddown_pow_of_two(idle_slope);

Or even just use one variable, @idle_slope.

> +	idle_slope = DIV_ROUND_CLOSEST(idle_slope, power) * power;
> +
> +	return idle_slope;

You can return DIV_ROUND_ ... right away, without assignning first.
Also, I'm thinking of that this might be a generic helper. We have
roundup() and rounddown(), this could be something like "round_closest()"?

> +}
> +
> +static void fec_enet_set_cbs_idle_slope(struct fec_enet_private *fep)
> +{
> +	u32 bw, val, idle_slope;
> +	int speed = fep->speed;
> +	int idle_slope_sum = 0;
> +	int i;

Can any of them be negative?

> +
> +	if (!speed)
> +		return;
> +
> +	for (i = 1; i < FEC_ENET_MAX_TX_QS; i++) {

So you don't use the zeroth array elements at all? Why having them then?

> +		int port_tx_rate;

(same for type)

> +
> +		/* As defined in IEEE 802.1Q-2014 Section 8.6.8.2 item:
> +		 *       sendslope = idleslope -  port_tx_rate
> +		 * So we need to check whether port_tx_rate is equal to
> +		 * the current link rate.

[...]

> +	for (i = 1; i < FEC_ENET_MAX_TX_QS; i++) {
> +		bw = fep->cbs.idleslope[i] / (speed * 10);
> +		idle_slope = fec_enet_get_idle_slope(bw);
> +
> +		val = readl(fep->hwp + FEC_DMA_CFG(i));
> +		val &= ~IDLE_SLOPE_MASK;
> +		val |= idle_slope & IDLE_SLOPE_MASK;

u32_replace_bits() will do it for you.

> +		writel(val, fep->hwp + FEC_DMA_CFG(i));
> +	}
> +
> +	/* Enable Credit-based shaper. */
> +	val = readl(fep->hwp + FEC_QOS_SCHEME);
> +	val &= ~FEC_QOS_TX_SHEME_MASK;
> +	val |= CREDIT_BASED_SCHEME;

(same)

> +	writel(val, fep->hwp + FEC_QOS_SCHEME);
> +}
> +
> +static int fec_enet_setup_tc_cbs(struct net_device *ndev, void *type_data)
> +{
> +	struct fec_enet_private *fep = netdev_priv(ndev);
> +	struct tc_cbs_qopt_offload *cbs = type_data;
> +	int queue = cbs->queue;
> +	int speed = fep->speed;
> +	int queue2;

(types)

> +
> +	if (!(fep->quirks & FEC_QUIRK_HAS_AVB))
> +		return -EOPNOTSUPP;
> +
> +	/* Queue 1 for Class A, Queue 2 for Class B, so the ENET must
> +	 * have three queues.
> +	 */
> +	if (fep->num_tx_queues != FEC_ENET_MAX_TX_QS)
> +		return -EOPNOTSUPP;
> +
> +	if (!speed) {
> +		netdev_err(ndev, "Link speed is 0!\n");

??? Is this possible? If so, why is it checked only here and why can it
be possible?

> +		return -ECANCELED;

(already mentioned in other review)

> +	}
> +
> +	/* Queue 0 is not AVB capable */
> +	if (queue <= 0 || queue >= fep->num_tx_queues) {

Is `< 0` possible? I realize it's `s32`, just curious.

> +		netdev_err(ndev, "The queue: %d is invalid!\n", queue);

Maybe less emotions? There's no point in having `!` at the end of every
error.

> +		return -EINVAL;
> +	}
> +
> +	if (!cbs->enable) {
> +		u32 val;
> +
> +		val = readl(fep->hwp + FEC_QOS_SCHEME);
> +		val &= ~FEC_QOS_TX_SHEME_MASK;
> +		val |= ROUND_ROBIN_SCHEME;

(u32_replace_bits())

> +		writel(val, fep->hwp + FEC_QOS_SCHEME);
> +
> +		memset(&fep->cbs, 0, sizeof(fep->cbs));
> +
> +		return 0;
> +	}
> +
> +	if (cbs->idleslope - cbs->sendslope != speed * 1000 ||
> +	    cbs->idleslope <= 0 || cbs->sendslope >= 0)

So you check slopes here, why check them above then?

> +		return -EINVAL;
> +
> +	/* Another AVB queue */
> +	queue2 = (queue == 1) ? 2 : 1;

Braces are unneeded.

> +	if (cbs->idleslope + fep->cbs.idleslope[queue2] > speed * 1000) {
> +		netdev_err(ndev,
> +			   "The sum of all idle slope can't exceed link speed!\n");
> +		return -EINVAL;
> +	}
[...]

Thanks,
Olek
