Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34C26E12FF
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjDMRA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjDMRAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:00:55 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7272AF28;
        Thu, 13 Apr 2023 10:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681405242; x=1712941242;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Rft1boMguD1UAB1shnizI0NgZqo2yjln81LEVoZrbpA=;
  b=L6ikLam9arxI4z77ayRJvidFrE6hq/RrFdBYgijFt/+E40jDqkZ/+/Mx
   imDpiZTf637sTwV6Hr7ZqeDFKiIL7uODCySaw38nm/9g4/pOKDkvWkQDu
   8Q0257InwjNyNQ4+jeoIyiuOY7VAy5mD3yLjXO/LqrZuId5emPb4ZyPSJ
   /h0chsqQvsEITO/Ece02kdc5DsXh92mSC73fQ93sS2AGUxRlbg/6QiobO
   yr0AuA24cmMrLgkCsycjb1U+ioKpE0w0sc5RUBEpuA9gg78GfdLDaBuau
   Qv8LUiUauqeDb3kAJdMRGLQ8JxgaYR+gKUtzfaA3UisBAufXZIvU/8d5Q
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="409420937"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="409420937"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 10:00:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="754083273"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="754083273"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 13 Apr 2023 10:00:41 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 10:00:41 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 10:00:40 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 10:00:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 10:00:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gqWB+TGXJ2B+UhHIDs7pg78kXronbr6GElznESstfTuMdckMKnF96jNv4Nlg7sSssSXI5HNuszEiB1XZ1iJIV6e6l/BCj6LHwfj23FzepGAVwyUGCjlO36FWmD+gAecwnrvJbSzD2CYNteVqf937JNkZhnNWotMtikBCC/0liS5XGJ64ou6bQI86+eIkk4SEziLx12sBOPPEZvp2rfWQ+l4MFgYLtGWmD3PdS8VhZY0pr6356c/MzjEg8eYj2YHU9QJD4MoCFhtQbSzk8bet18N3Toa3oE31tIp6Agn8LIkErU3PM9l3/kwFMnvhHPaAmhCsLLg8/sktVFPmFq8vJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OR63SuJCMJnn3vBQNzQEnO/7GNjnA5GRVTSh/WSeIBU=;
 b=ISYHDUmya/dzTjozFE2XDC4yqtLwNpjh5BFqX/LlxS8nZ4yJRHEXR1/FA1HOL+gsLrRheDalcwbGNwEy8idhv0QWSyhOHRxEc+qcB7NAlQOTdjaKYv2Coa5Y3ng/+UPw4et0bUIDLsLd2T5uukol+loQD7B+EAJz77gJqU20IX69Z9fIyt3ieHSIejNj1aoELttb1UaKIIHw16tUeQv+HBLR8knaeip5nee1VAl1mRVhM37NTj2NIzbpXRoV7v0/s5Cq4VWQyWVSjquh5aZAl19Pp69H8DXni1VPiGnZyBI8b2V0HUmM/zePwjR6MN+dkh6PzgHpvOyY7U3XAF2rjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 17:00:39 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 17:00:38 +0000
Message-ID: <de8e3387-6224-d367-d897-a4f61450cd7e@intel.com>
Date:   Thu, 13 Apr 2023 10:00:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] net: stmmac:fix system hang when setting up tag_8021q
 VLAN for DSA ports
Content-Language: en-US
To:     Yan Wang <rk.code@outlook.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "open list:STMMAC ETHERNET DRIVER" <netdev@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <KL1PR01MB5448020DE191340AE64530B0E6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <KL1PR01MB5448020DE191340AE64530B0E6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::8) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CH3PR11MB7345:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cb22970-6056-4503-d090-08db3c409abd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 683og9E77ZPr9L3V0X5gtOZP60d+m6rw1+g+qeVwZ81ttInDhPF7G/GIsD9NiWDKYzeqdXaxip7Ezc7hVFL7TTjyTRDhaYKsfvyP0lb05SUHdaklRyt8o8X9qXZC9O0oAuTc76y21yKuFn2LVvCZJv/zTwmkBfYRR1NAeRrqQ1Xdh+lDeMVidU09OkNAbYbWmH6z645MzwQ3HgR84gnT3fQEPZ5v95+tiVGUlS2x3gU3/n/1W/40mN1WC/JUUAVZzy5rSJiteV5SJ9ac2aeW0nBnsomD2BVQebhZTFqTGZWXGPD8cUl56T39ZqPx9TnHykttqgFAxXO1qy2gXAspJPrfA/Vt4G/cYFj+t9Xdfm2xQtCtNxsRo/inqc7IFCqFYCdahe7zIIXM+6s0HfrHvlG4iT9hbm/rwmRmhOklPCw2aYPwOizqTKRaJLxznRWFZlVmpDDa6JMGJ8M5ibsQXDzF5hvF3ZIRiLxBmiTvyjl6cjmiAen6CFASQYvpNf1cCx0a+yvrmYMCIWG/k3S5BcV+j9gm8YDtLtgOwRuyTmgR7mXBZ86uEXlKYEs8+Bo20TNs6L+zrT+InTIYK+o5AvUPoCXWi16iIQ6BICgco17Db2U49FGbWjZwhiWBE2CyD1EE3Chbrerok0imPa+hhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199021)(6666004)(6486002)(66476007)(66556008)(66946007)(4326008)(36756003)(2906002)(7416002)(31696002)(86362001)(41300700001)(82960400001)(5660300002)(8676002)(8936002)(316002)(38100700002)(478600001)(45080400002)(54906003)(53546011)(6512007)(6506007)(26005)(31686004)(2616005)(186003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDN4ZzJmaWxRZU9kanBjVldYM05GTHJ3MWQ4Z2xKOUhDMDNUSHpPMHNsTngw?=
 =?utf-8?B?RVNMbEJ0dk1JOVBzTlVGMGU1bVBpSHNWUkkvR2NtUmVNcFU3VVlTeWVTYm43?=
 =?utf-8?B?VFRqdFNTREVJVWEyWUNER25JNjZid0dBZW5zWDYzalJBbktWbTFCWlYza01o?=
 =?utf-8?B?alBHcWFmU2VWeHFTdzNLS1pkU0x0RGRZaW1mZmlvbmJldy9DdzA5WkxPckZF?=
 =?utf-8?B?Nzd3ZmJOU3NFYnZFV3dnYW0rc2t5eEFWTWZXU3gyakRGT25SVCthSkRhcC9Q?=
 =?utf-8?B?Sm9UcFYyUTJBdEVCRUtLMXZ2T2FGNXdXSDhRSERYcXFPM3U3MzlKL1d2eUdS?=
 =?utf-8?B?Tmtnd3FQdWlnMHZpeWJNbHpXL0JpcTJTMWxUWnNuYjJ5RVYwWVFKWmVhak0w?=
 =?utf-8?B?Q1prc2R1ZzMrdERuZGo5UjZ6bjdtOFdPRERKZytTb2U2L0xLVVZYNjVhVFZi?=
 =?utf-8?B?K0UzM3lHWHVZZ21ncXhDNGM5NDEwa1dINWs5aWY4OTViaFJ1OVVFUlVieXE4?=
 =?utf-8?B?ODRSRGhRRmswdWhpV0YxL1BMSW43cFdmQmh2RXVNdDlqNFZZTHgxd09SZ0Rr?=
 =?utf-8?B?czVMRTc2WTAvc3BmMVllSjFjNldVNXh1WjVaVXgydGZxdVJub0N3RzZCK2Uz?=
 =?utf-8?B?S3lta1cxT1lwSGlSTEJraWJ2RDFqT1NGWjZYVVR1SzlhSjM1aUxkNGRiMEFD?=
 =?utf-8?B?UGl1WC9nVGFaTU52TWZoUTdZMnNJVzVLMUpLczBzWnlhTWxGb2tlQjBkcjNp?=
 =?utf-8?B?b3VoSkRpLzFNZmladVRrOEttWmZFSlpTRTBsRnovQ3pJZm1IVzVGcXNad3ZK?=
 =?utf-8?B?cXVoYTJvWEN2L1RBUnNWTFNuMEFwM3d5NmtOM3k4THN4eVIvUTZzMWJ1Z3dY?=
 =?utf-8?B?TzQ5RkZTRk1VaW5TbzRkSCt4MWtlRjgvMnJqNmNwZjZMckZmS3pRM3BweVV4?=
 =?utf-8?B?SW9mMWp3aTBVTjkvOFNkZWs4SVdjTFRkbGxRRGlzbU9yWDQ0eERaMVRBZFRu?=
 =?utf-8?B?ODZXR3AzMFdJUlhyalE2YTdQY29uMTgvclVIZEJmejN3c0J6VTdGaEJmRFlX?=
 =?utf-8?B?Z3l5WmVITFFnQk9pclJJY2VNaEFVUFphTEF0aE14Rk1ubnhFaVVFQWxwZHN5?=
 =?utf-8?B?djNQem1iNFg1VE0vQ20waUQxY21saUJ6SitsR0wzRjlXWDV1MzVTM0F3eHBO?=
 =?utf-8?B?U29iUjVFeThxOW9NNWVzc3RMblVGQ0VzS3RTTWhlQ25aS1A0NnQ0K1ZPMjE2?=
 =?utf-8?B?ZzNYa3ZPZWIvUk1SdDdlQjZaemo4SDB5RUlGK0RkOTdMYWQwWEdPTkdySUlv?=
 =?utf-8?B?d2V6U1Z4Z2JBbTRjOHRDcCsyZWRqZ201czRWdGRld2hyYXdyT0QrVXpLYi93?=
 =?utf-8?B?YmQvVlhBaTlBV0IwZ3lSSTR0MnBwdGdueTNjNXFUbzJOMDFoUUxremtuWUx0?=
 =?utf-8?B?WHhkbnB2dUtwa3ViNGFBNm5Ibi90bSt3UHUzV0ZwSXZ6YkRlMzE3ZnlvaCsy?=
 =?utf-8?B?T2huUUlTeTJKdHNYUXFlaHJ5ek9Ud0tXR1lCTFZPM1RDZjV2VHdlbUdOVnBX?=
 =?utf-8?B?OTh5RXBqbzE5dHE3UDJTRGpkNzVBVXlXT2QyalU4cEpnWEp6cmpYRjMwZWNy?=
 =?utf-8?B?SDJiWkhaTXB2TWQzbU5VN290TkdjdlkwMzBGeklybTZBL2ZrZ05SaUxZMFdu?=
 =?utf-8?B?QmlSc2pER0h2K2pOeWNVbFhsRTIwZDUzMTVwdFlWOTY3UzY5R1E4V0xQcHVZ?=
 =?utf-8?B?SXNJZkZpbWx5cUZNZEZMbkh1TzQrMVhkTFh0dDFGVm8xQUJUdGNPZUJ6dXdn?=
 =?utf-8?B?RVFqZ3ZmdFFqSHZ3Ny9SUSswYkp5aXJuTHpPNnlITEtsYzVOLy9xMjVHd1B6?=
 =?utf-8?B?MjA0dmFOUmxGZDVwS0tJdVA3TFpmZHpacEpFTnlMdTNEYzlTWW1tNEs5NDVQ?=
 =?utf-8?B?bDRhc2x1NjZ6ZjZTR2wyZTIrN0V6K2ZRb1JPSDErZjA3amZBK3pRd0ZmYzRr?=
 =?utf-8?B?WFcvQ3hpN3paU3RlaTRIVktTTHRVSWxlY0tnTnc0aTA0azhydFZIdEVEL3hj?=
 =?utf-8?B?U3hoa0ttRnY1TXdELzFOTUl6WXFFSllLSXJhSEUwVm9vQmNMVm9OT2xjbmRW?=
 =?utf-8?B?OHNvdUtwckxsUHE1MW5BZldGV0pPb0N0Zk14SEdwQ212R3NKUFlrRlpZMHEv?=
 =?utf-8?B?c0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb22970-6056-4503-d090-08db3c409abd
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 17:00:38.4453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oQMSnMbx9cE0XBRcINM4zEc2T6wuPFkw3eESdTja1ucC4bk5uJCBBwZpQPniawsZrDc+d+xs9yPmUFN8H+X+1KWTDc20tBeVXi4uV9DDGZ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7345
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/2023 6:38 AM, Yan Wang wrote:
> The system hang because of dsa_tag_8021q_port_setup()->
> 				stmmac_vlan_rx_add_vid().
> 
> I found in stmmac_drv_probe() that cailing pm_runtime_put()
> disabled the clock.
> 
> First, when the kernel is compiled with CONFIG_PM=y,The stmmac's
> resume/suspend is active.
> 
> Secondly,stmmac as DSA master,the dsa_tag_8021q_port_setup() function
> will callback stmmac_vlan_rx_add_vid when DSA dirver starts. However,
> The system is hanged for the stmmac_vlan_rx_add_vid() accesses its
> registers after stmmac's clock is closed.
> 

And access to the registers basically just waits because its clock is
stopped?

> I would suggest adding the pm_runtime_resume_and_get() to the
> stmmac_vlan_rx_add_vid().This guarantees that resuming clock output
> while in use.
> 

It feels a bit odd to need this within the VLAN function, but these can
be entered at an odd time where its possible that the clock has been
closed... Ok.

> Signed-off-by: Yan Wang <rk.code@outlook.com>
> ---

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index d7fcab057032..f9cd063f1fe3 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -6350,6 +6350,10 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
>  	bool is_double = false;
>  	int ret;
>  
> +	ret = pm_runtime_resume_and_get(priv->device);
> +	if (ret < 0)
> +		return ret;
> +
>  	if (be16_to_cpu(proto) == ETH_P_8021AD)
>  		is_double = true;
>  
> @@ -6357,16 +6361,18 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
>  	ret = stmmac_vlan_update(priv, is_double);
>  	if (ret) {
>  		clear_bit(vid, priv->active_vlans);
> -		return ret;
> +		goto err_pm_put;
>  	}
>  
>  	if (priv->hw->num_vlan) {
>  		ret = stmmac_add_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
>  		if (ret)
> -			return ret;
> +			goto err_pm_put;
>  	}
> +err_pm_put:
> +	pm_runtime_put(priv->device);
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vid)
