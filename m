Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7EA56E15F5
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 22:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjDMUgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 16:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDMUga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 16:36:30 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8961D4EDE
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 13:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681418187; x=1712954187;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=m6KDU99DRa6QEyB0JZJow5BJhZqfIiRP9KhU0KmIJRI=;
  b=hV0PMPMAAcBo0AlPIiVqQHiwI5virvvgPSb6HtXZCU7vvFX10KuAy/Xd
   p2QBhtCvG3AHHdGei8/2M1/T7PIz4vqcO875Uv+q0jjIAL1tA/ZNGuwwA
   p05974em9FVMBtmOQVhpEasoeZndUaChs2HhYjaYex6pwakKkA51g6pND
   Ko/+fuzFNMiXesurgn4b9kmGQeZNIUrGwzvFiiuE3qym6O3/viLInp/60
   JrPeiJBnQN2O8nkjrFOzKTMYC8zfTD8cCYUhzShVb0+EVaYV5AOnb7Y9s
   mxtSNlBfTZXYvw9YZQfAgNKegdjqymQ5XNFisqR7EWt84QCtoNKAsBHNX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="323920928"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="323920928"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 13:36:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="754151167"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="754151167"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 13 Apr 2023 13:36:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 13:36:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 13:36:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 13:36:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 13:36:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJeIBmqw4UtBCqYdEkDi5Jsp7Ev1QqyzsGitJQBPwYydj50KYripmFP/qBr/jgTMUd4bqG73LbaUMbSWHbATYMqlFJzxXRdjl7rYD1nXl6Fj6Go/rJxp1HIVoLlubFxWKgwZ1517q6A0Txks2eiWag9dhQ/lxaBAc3fhokEYzSKHAPjlp3pVQ+sH/w8S8aWIqyhFUFHFC7Wj1WgEH7TZPBaQ+1cd8cgrFs6BvOe/6FrcmtteLWIFbF+ZzKoMDKM5uW0iof873dgJW0lEaYlJc4M62XOUG0YnSMLTm3ZBYqREuRIvCCpYmMSy/UYlU2DSqN3obcxktJQps8/zq7yJ3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RzJrSSETWXc7SMMEQrvOewL5XtX9wVJqL5FlmIKxRrg=;
 b=Z2XUJgx8vadEvbo6DnxsxlMmx//V+9acmB4bZHEWi63q7QcZCHucxAK06+Su3FzUIzYNSGirbYygtwFP7ap4U/glA6xqnCOUcPzsjndj7sCgdPvG/NoYQl4a0X0ao4DBaXvl8vB9LowLgPyyGvi7+glMIPFITpktt39G8BCMc/7td0BUCPbp8sWSdtkR2GW1OP0LrAP5VqJMUDJSrxSOALDUkbuAbAPE1w05RM7TZFqqd5WT+0MlqtzuzGZUGlB6ZDlYC+l6oc+XrtnnDv9tnb/bNS+iejKM3aRNjfh98OorAW9A0p4efuaAU6dl1YIeYCOmNcCHKrbxHwBa39eSUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by MW3PR11MB4683.namprd11.prod.outlook.com (2603:10b6:303:5c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 20:36:24 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::922:4817:b4f2:c7b3]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::922:4817:b4f2:c7b3%5]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 20:36:23 +0000
Message-ID: <3b6186b2-86c5-4370-b30b-8e416a93505f@intel.com>
Date:   Thu, 13 Apr 2023 15:36:19 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v1 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs
To:     <daire.mcnamara@microchip.com>, <nicholas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <conor.dooley@microchip.com>
References: <20230413180337.1399614-1-daire.mcnamara@microchip.com>
 <20230413180337.1399614-2-daire.mcnamara@microchip.com>
Content-Language: en-US
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20230413180337.1399614-2-daire.mcnamara@microchip.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::28) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|MW3PR11MB4683:EE_
X-MS-Office365-Filtering-Correlation-Id: b747c252-c58a-47e5-d0dc-08db3c5ebf38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sr/BrT0WODqsPb2f3so1kbya4EC77okO+B12snNAcG1RyCvOqT0sneNIYQHpqVw/zKAhpLtBtgfefRQ/yzUbMcS2br9nWjj1m3w49hHWab4e4BliEcIX0KHUDW8KJKvHgPwQjkMl8GgvuG8h/jpkOOHwV3LuOJrqITltHvzOl6rPgJjbejTUxDL/7pi9lh2YAyHfAsgLIsOEhyBZOZWFA5AZrdY8f8pJUVwS988zBEl95xLp8VtdJZR/xtEqVe9LMO91am+IenRdbNOAcBXzQlSMdl9lJ/2WTl4VvqmZ/+qRYTIFLkboAmUG4+J2Q7+6s6d6kjCFb3dsAn3N4Pi0jZ8BejbBPJ9IyjjAs/u+6UHNfgHFs1NfkRYqDLbsQbjHRRLCsMpi12P0E7jaxKvmtLGB8UafI0+AiYSPGbgDy6g4g8d1mfFfnQIGpKV7tfrJCdPe9mf8xowulXH71uVsYTElLTOYXNXRiLxmVUseZrT+pbN3SC66sFW1qD+HgtVYZGiMAx65dSiQA3py0ubMexweoN6xvvPejo6MDzQP4H+uhhvOHVWvBZSLFvk8uGLXd1IzttZn8GKxnUNHpSG5YaMpMV3sQE4BGQjBNeDabUPVUWr3HEE6JpfAUzsr70DQRmvvrfnOFm/myfzfk2sX7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(396003)(136003)(346002)(451199021)(38100700002)(6512007)(6506007)(53546011)(26005)(31696002)(186003)(82960400001)(66476007)(66946007)(66556008)(8676002)(316002)(478600001)(86362001)(6486002)(36756003)(41300700001)(6666004)(4744005)(5660300002)(2616005)(31686004)(2906002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVlWR1dKVjgweWhPeEpTak5MODcwUHZtWnVIR3pSZXE2OVpRNVMyNTZ3dWU1?=
 =?utf-8?B?VjhwWlVndlZTUmNwMEVXQnNNYjVZQ1I3U2pBYUJLOC96T0JGNEYwd202R1Yz?=
 =?utf-8?B?Mll1M0tQN1JQcHhQaTFkb21rMW1YWENKOWQyK3hYRzd1RFZDOG83cDB0cXNQ?=
 =?utf-8?B?dUZRMEJRSkRLU3BKS2lYbXJqTzhKa1VMMDE5OTZxS1BqRW91RW9CYnZDTVc1?=
 =?utf-8?B?RVN1TjFneGhhV2ozWFl4Nmx4R2tBclB3MEVZc1I3cXEyUkhhN1p1ZHQyQTJT?=
 =?utf-8?B?M2ZtUlBtQVpEY3l3Z1d4TjlhSXhUNWJkRnJlV0dYa05nYldpSDB6R241RHhR?=
 =?utf-8?B?MXhnUUoxZ1pURGZ0SUJaZWU5cGZ2bDB3d0xOSjZTTG5PYXhYRnJKblA2Wmxs?=
 =?utf-8?B?Y2dUN0Z0Mzk0bXlXVGhCdUhKY1p1cEw5VHdreGFycFNLRWIvWkx6dDRUMkNv?=
 =?utf-8?B?OHNNZjVMb2hhbS9QNGJHdXhvNFZJcllBdlRHN2tlRUY5NEVEMTlFK1B0dm1k?=
 =?utf-8?B?SlVSK2tSakFYSkJrOU1lQWJBZmZvWVRtbCtmMjQzRlg5cSt4VUIvNHQyNEU2?=
 =?utf-8?B?cVdTQnZramRyeXlMMmNnQ1k5MzlrTXVNOFVrVm1aeWJLV0JYTVM2eE1pUDBj?=
 =?utf-8?B?aEhIRmwzd2tIaDY2SFVMaGRSN0g1ZS93K1pxbmRwRXBTVmc3SVY4UnJGdnE2?=
 =?utf-8?B?K095YlZXS2hvakpvcmhHdnJCYWRaQ1dLSHhvSXlQb2k1ZTJSK0J5TmQzODVM?=
 =?utf-8?B?TzBDQzlJOTljcE5UWGcvRTJ4MFRmS0l1ZEgrTUI2dm9YcGFDRkQzdXNhMU9P?=
 =?utf-8?B?NEc5RkVkMkpQS2ljZWRjbS9yeXUxdXBhUEg2MllqaEttbHFRRFVMVDBUejIy?=
 =?utf-8?B?NkhEYXd6c1d0VVB1V3IvOVpCWms2a2t0bWQxdXRTSExxemRCUUdVM0JRUXJR?=
 =?utf-8?B?Zmx5NGxEWG9DaFZ1RE9LZEVTbTdBOGVPT090UUd6SlpFbHllNmlLZGUvRGFY?=
 =?utf-8?B?K1B4ZnMzVGRRMmNLYlZFMkN4MExORytEdFJSU1pCZUxEc2VmNUtkblhZaEx2?=
 =?utf-8?B?bjdWZ1gzTnlnUkFGTXVLRVY4NGZFV2IwZGRVMUZ6MDBieXZCc0ozZktpcVF5?=
 =?utf-8?B?UTk2VWtBejR5RXlkNDFXemI1dDBNNlM0RVJuc0hsTVJtalgwR2k0VVRiaHBj?=
 =?utf-8?B?VFRsSkxGQUlCcXNvNStNV052c2ZwYnRSRFlWOWkzblhnZTZRWXJQSTNrbHBT?=
 =?utf-8?B?WUVCUVBqVThOOURRa1JKMCtuU291WVJKZ1FjVlNxU2ZTNEFTS2VJeHRnWEk5?=
 =?utf-8?B?ZDNZL3d5WjY1WGt1MTY1K2FSMy96ZEJBbjNBcHUrTEZURW9DbDdKM2hHVldE?=
 =?utf-8?B?dWsvSlBIdlFISC9JVTByTUlzS3JQNlV2WktlV2lPdFdDeVZUSzVhNCtjOVo4?=
 =?utf-8?B?YXd2YlMrY0FVZHRMK2RBcHVyaU05QUVtS1hRNUJaZ1dxeDFLOTRleWVxY2FV?=
 =?utf-8?B?bWlrd01pS0VUYTR0WlZIT2xoeGxuVThMYnpQNWUxcDJibUZtZ25RL2c2bG8x?=
 =?utf-8?B?SGtMQkxhT1MzUS9aQWZkMDZieVBLQTNqYXVuaUY2NEllaHNvTW9wVmhSZWM5?=
 =?utf-8?B?VndFSTN4Qm1LeUxVdFJZdEtZVWdVbTlMdkZXZGhyRFNxZFJhbGZPd2NNbmFt?=
 =?utf-8?B?Rlh2eGdrak92MmpZSndIWnRza1dHY1lmSXFGTURITEYzYXJVbkowYlUraFlj?=
 =?utf-8?B?cEpCbWRKOFlXSmpvV2l4eGtieUkxN1dsSkNqSTMxWnVCbHNSL0JRa0FFSkhC?=
 =?utf-8?B?ZnBoZkZmV0dMb2JMZUtaRzkzNWlZYzJxaVRIU2FReWFxY2gyQm9PMHUrN3Fj?=
 =?utf-8?B?RHhtZnA0Zm5NTWNCQVN5NDVDTVg4UHhmRm16SDlxZUtpdG80VHhmemdkZFpG?=
 =?utf-8?B?aVhTdFQrYzd1Qi9vbjc4cDZLMXk5anNrWWlTbk9QNjdEL285TG1EeXVCQ04w?=
 =?utf-8?B?TkV0d04ydzVybjdtWDF5WmVaNkFGQWg4UXlnWUZQdXEwQlBiTFRPR3IyMFow?=
 =?utf-8?B?WU93c2VKajdsMGFqajhnQjFPOGxrOFQyZnlZRERxZmE0Qk5laW4rV0RRV0Rh?=
 =?utf-8?B?M3BTSDk2QWN1ckFHSFQwMzFFZnlZWExUeUVQQjcxNXFBTnpva1F3Z1ExMnJh?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b747c252-c58a-47e5-d0dc-08db3c5ebf38
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 20:36:23.8239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zf+o9MoxhZdBYLI6pMDQnVqcXFYTfQdrrgW2FWKaDhdFr6Lxayj/IJ3y6L95+EsbZwDM3yZgHXtGRZh+kEvJjqbVsU141KLDclk0ltC4lVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4683
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/2023 1:03 PM, daire.mcnamara@microchip.com wrote:
> From: Daire McNamara <daire.mcnamara@microchip.com>
> 
> On mpfs, with SRAM configured for 4 queues, setting max_tx_len
> to GEM_TX_MAX_LEN=0x3f0 results multiple AMBA errors.
> Setting max_tx_len to (4KiB - 56) removes those errors.
> 
> The details are described in erratum 1686 by Cadence
> 
> The max jumbo frame size is also reduced for mpfs to (4KiB - 56).
> 
> Signed-off-by: Daire McNamara <daire.mcnamara@microchip.com>

Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
