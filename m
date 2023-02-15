Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D866981D0
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 18:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjBORU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 12:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjBORUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 12:20:55 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F2539BA9;
        Wed, 15 Feb 2023 09:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676481654; x=1708017654;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K+owO7m0zadP/ObaA74RFHX+weqx6XHtEA39Unp5M/Q=;
  b=ELDpyaCn5pr3TRokOsmUu74GpF+SsIogEv9FOB8rGnlBf/B7DTozY/L2
   qenREo/GQcLOBY0kUz/u9AD/CJOohsWbRS4YgIZq0VW6lOxPnfV5kzBrU
   OYP0N++JHca6nn5CNUWC+w55YFlcL13DU9NRm0PpS4PLWNeG9dnkUj4ZN
   yMx807I7S3VuFe05BaF3aSgt3giCk3Ru6MAHuQnY92CENTD+9cAm4LFKP
   H88hPYYAU4sQrP9D41IRcvaf0jhNRUq6qdUBQZGUiKAtY0vm57KNRVNNh
   itxpnEjWo/Y9dQgEA5sP0wVI5ksMLOW3sKlaAjZKXr49TrXfHd7qn0isz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="315142043"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="315142043"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 09:13:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="738428417"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="738428417"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 15 Feb 2023 09:13:16 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 09:13:16 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 09:13:15 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 09:13:15 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 09:13:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDS6R9nvPWHByLMgZ2cUH9zllqbU/D4TvuPj/NB4FT8gJsZIi55bfrGQgPna2wfpXeIDsD66XbAtITVIGeZbjyR1LlMygh9JC9WGUB1IK0PtetFS0nnxRvWTvNUnViIAYyo7mWCJEaxk48lAoJe6FKCntLeVckeTaZC0o+TwGY6+RoRpXPnfhjmEZUyOnmwZN0HyoudfaRPKE8/9yDAyOAwfgTp1s73XIYgLYAF73jUXQV/oNipvet5g8j3u7RTKkddLPjsxFHBTTvn4wufEqLlupeQNHRiQE6AP97GYa49w3dliQKSBhcUNLJM74/vKaH/vJlUOftfFE5ZpwlwXhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+c5L9Tp+7DcxwY/+pDCxE+5TFiT3qrDsGbiF/sNfa8=;
 b=lN3qbIbMu1LzjYfgNkOUIxftKw4uf1xH/66ws6mFxhllmU5lwexQvnm+Fk3+QsaONitXDfANOAinGgFJtlrAgs8WV05+s8wbG3ulzK40Sq8x7GjGGOmpQPKmW6GQWb7Xi8sfZYQjgvQdcvQ3v6myNLV87N6/exD6MKV/gCGdvfsFNYZqibHrv0EQiEVjzB4z8q23Rkm/nAJkVRWFakq9EmSNx6IJdfLPP7J3M4EJhrwdY8dUViGhbMdhuBlfPOBTLhEMlH1noxdFr45sZBkoZHbaTqRdu0IXqFUIC7spjYxXpOT2+vHdJAuaqqEU6OQ4uN9oMncJscWo6h6wNr3HMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MW5PR11MB5929.namprd11.prod.outlook.com (2603:10b6:303:194::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 17:13:10 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 17:13:10 +0000
Message-ID: <c9be8991-1186-ef0f-449c-f2dd5046ca02@intel.com>
Date:   Wed, 15 Feb 2023 18:11:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [xdp-hints] [PATCH bpf-next V1] xdp: bpf_xdp_metadata use NODEV
 for no device support
Content-Language: en-US
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     Larysa Zaremba <larysa.zaremba@intel.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>,
        <martin.lau@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <alexandr.lobakin@intel.com>, <xdp-hints@xdp-project.net>
References: <167645577609.1860229.12489295285473044895.stgit@firesoul>
 <Y+z9/Wg7RZ3wJ8LZ@lincoln>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <Y+z9/Wg7RZ3wJ8LZ@lincoln>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWH0EPF00056D02.namprd21.prod.outlook.com
 (2603:10b6:30f:fff2:0:1:0:f) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MW5PR11MB5929:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d19b4da-411f-4393-7137-08db0f77e9bd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7zlkXEAGc+qKdBn2j+AUhvg6+IIczb7NKUOQ8VA2iJkUH2CIUEjEHKFzcjslZDWQwdn9NSvRDIALjEvKF1CSUY40TOabPvxMlB+HBXl4+pUypQdTYHh0N42JzR61fWG8BwjkTcpGFXkLMNvQbXwk8jbpqHgI2dKeC0J3hLeuNCPpQNwDgE3IYf3uikOKDXhucF8d1MTS16evj0HAHjT3vaDb04PXGs0XCmcVGRElTjxPJo1EUewaXb+EME6BLENLWl4YDZ4JXZ6hAmpqLqyiEzY+OY1EvVeGCOyg5rSqaBidtc0s9DOmdeH3OBCW60FRk0a98GQQCfPfNpoEQnwTEeVyFS2KsFWO+a16f6W24V/bRWsHjpFicJuOwvch4mNaxzLO32IUGCvivgxCHMxxitg+5ult8Vl2OdvV7zlkMkaktyA9g7OToPoeB4XejBubEjXuXCnV8vl7pOSBosvLIX7m7wVZOBuEpzpDp/AKk2eN0VYe42qgTVIa1GeurWyXkLiMv5Dgdn6evbNmc9wwNqTerjMLU4p0kiY7Jc8t704i9/91+qBBjmjFYKQWmnizkRtfaHIagCr7f/b8goWSP3aUUUi3uGRX3xg5tbfZYY7b7nYdY75RV7MmaaMEGJTtQV+Y751dXfP8fq8qgN1c4Eot+bQX3wgjMCHfc/uQryuzG4X+GoLqgtRaL9042xyv0fW41c3YZMOW6d+ehBs/9z9DIdFlX/SZCligMWwmPQA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199018)(5660300002)(2616005)(66556008)(36756003)(478600001)(6916009)(66476007)(86362001)(316002)(66946007)(4326008)(54906003)(6486002)(8676002)(31696002)(8936002)(26005)(6512007)(186003)(41300700001)(6506007)(6666004)(2906002)(38100700002)(31686004)(82960400001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0hRcW1iQ0VBVGpkMjk4NHBib001N1R3Uk5ZeG1ZVElucmlta3BaSmZYczNC?=
 =?utf-8?B?UGg1Z3FPYnFhSWpLU1RmNHlPV2g2eXQwdXo2Q2piK2o4c01pN1ZkbEhGVllK?=
 =?utf-8?B?SHNvRnNES2F2NC95YzExZytvOWxCVFBZb2E0YmtnVm5aZXJUUXhiTkxxTE1v?=
 =?utf-8?B?OWZQYTBVYlBOd1hEbEJCdjlZZ0Y0WDBsTkh1dFhrTEtaaXFKWFYwbXVPeGpK?=
 =?utf-8?B?bVhERFp5UmpWYnY0eDExNWIwL1FQRmlVei96UGs3eUxUVkM4MHJxSXN3Qmsr?=
 =?utf-8?B?emJCbkJNclpDa1NJUG5nTkdoc3lhK0J1YTRPWEU1c3h1M1FBZzRqOWpxdHly?=
 =?utf-8?B?U1FBdGNxSUNGeFV1YjFrZzMrTXd3bVhKTit6VkJNOTUxeHVvVXVyMHVDN0Fn?=
 =?utf-8?B?aUdMVWwxblAxVTZlby8zUlQ5L1pHZHhDU3dRWkEvRE9hMWd0TFF4d1R5VHJH?=
 =?utf-8?B?SzdlZk1hTTNJb2kxYWJvMjdwTzE4NWhZd2paT2FuekU3MUNncWsxcjAyQjBZ?=
 =?utf-8?B?RzVPSGUzclp5a29pUy8vbUsrVWo3cUM2T1huL2wza0pnNERMVTJvbWFyK1Rt?=
 =?utf-8?B?NDNUdUZ3UW1BNEZrNXJSdlcxT1k1a0hRZEkxdmhsbzdpRTZRd09mNXhmdkw2?=
 =?utf-8?B?Zk1ETWxnWWlhc1JjQlNpMTZHQmdtNVJaOHB5Mzk4L0RhM3A0Z05VeUxCVWNS?=
 =?utf-8?B?TER1emFPL09RSFZZeit1U1pRTU15LzBPTUNKWHRJSzVkTUVraFY3Y3c1T1d0?=
 =?utf-8?B?ZmFPMFRESm5nWjBZLzhsamxiZGtpOElMUmxrT1RQK3lrZ1J5UVE0UG9MVDY2?=
 =?utf-8?B?SW52NTBmNUxzU2VRZGdqWGZpeFJlNDcwMmtFNTY1OE50Q0hteUZGeUlaWjg2?=
 =?utf-8?B?T09BRU9ZdWswZFdTYzRoNnd1cE56L3QxN0k1YjEyV2dGNjIwQjM5YWlDK0Fn?=
 =?utf-8?B?cE1GeGRWRWFDOUhVdDBvUm84YjVydG9qREFxUzZybjRpRDBpU0VVTTc2dC82?=
 =?utf-8?B?dGJRRUU2ZDd4QmdPTE16ZGZsTm0wcVdidS9TWjc0bmlWZFk0ODIxNFdJTWNF?=
 =?utf-8?B?QkFZcldsajhqV2JtTmNPMm1vbjBXOHhYMTlueG5YODI4Z25rUDJEY0JVMXBL?=
 =?utf-8?B?S0U4SzlsZU5CVTJuaHd0UTU1Z3pzUkQ5QjZ6TFNXU0duNk95bTYxMll0WUJ2?=
 =?utf-8?B?anlZdDNoa05wTFdGOXdHWk00cHFKdFlqbnZISU5JWWRYdEdNeFVlZGpzUlkv?=
 =?utf-8?B?LzlMempoOFpyOVQwVU93SlB6bXpQdXczeTZRcUp3eWFLRVBzVEJWc2VqL2sx?=
 =?utf-8?B?RkV6a3gwc1c3QjR6bXFHVUlBVnRHSndtN3NPYkRJZ2lkeVRFSk9pK1hhdWFk?=
 =?utf-8?B?TlJXcUpXb2R1NjVBR2Fwc0Z5MVRpUzc2V2wrbmlsWnE1M0JFT3M1MjRFMmgy?=
 =?utf-8?B?WGs2cS9OOUtWekdGV0hXNVZTSklCV0tGOTR6SFk5M1lXc2djUjRaYWtqZVpJ?=
 =?utf-8?B?LzV0elhmc25sUitBQUt1azlBeGhHVGNBeE94b3RJU3doZjAyeGw4a0dsKy9L?=
 =?utf-8?B?RUNlUnJ1TDBJYW5vWGZ2RVNmZnZIWUtMaU1xR3lyWThSR3kwcFliNmZzcHJo?=
 =?utf-8?B?ekpxaGEwbURIa0ZoWmJTWWRJdGxheUlvVmNqcWJTYTJIU1lGanhLODR5bWMz?=
 =?utf-8?B?UGVoNG14eEIrbVBjeHZDblhrMHpvc1NDMjVoOEZpL25wREl6WkZyWlN2Rnhq?=
 =?utf-8?B?azQzRU5hS0RialA2a3M0bVNxWmJiMmptelJkTHFGSm1sUld2SmRyQW5zOEMw?=
 =?utf-8?B?S0ZNalpUNDJMRVB4V1J4MEc0QkxRZSs0aW0xUWd0YS9WMXZaWTI5Y1hWVFIv?=
 =?utf-8?B?dk1DK2RNK2g4Wkk5NjcxbDc5SzBieExrR3QxR3FmSHBnYXVIZFZ5Vms4bDU4?=
 =?utf-8?B?ZEtiVFgyR1hwelNUUW5ZaTE5VXRGU05IOVhTM1hUcER4ckhReEhEZEFvSXBK?=
 =?utf-8?B?QUdGd0l1QTJwK0JZeS9Bd0Nlc2dXR2x6YlkwSi9ET0xodTZBbm1ZWVpMNWhM?=
 =?utf-8?B?WVArMWd5Z3pnQnQyTGJoM1VCTTZWTThwOU5kMjU4d3cwNkR5cU9yaW52aThx?=
 =?utf-8?B?cUZDeDVIRVp2bC9LajNwOFZ1WlRRWW5VdTRzdmxOOUlnTEo4M20yNHNRZSts?=
 =?utf-8?Q?wCGV3I42VygEBK3VRtpJLY4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d19b4da-411f-4393-7137-08db0f77e9bd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 17:13:10.2119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2yu0/6UF+YWjMrvSR6H3g3uTXIi0aM3EZO+07+lbG7RWl8Ubobt5Ot3ybzPhyrMw72uWLtkb0hwG9iTai3sz94yTxc+/FY0K8NOLsKcTuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5929
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zaremba, Larysa <larysa.zaremba@intel.com>
Date: Wed, 15 Feb 2023 16:45:18 +0100

> On Wed, Feb 15, 2023 at 11:09:36AM +0100, Jesper Dangaard Brouer wrote:
>> With our XDP-hints kfunc approach, where individual drivers overload the
>> default implementation, it can be hard for API users to determine
>> whether or not the current device driver have this kfunc available.
>>
>> Change the default implementations to use an errno (ENODEV), that
>> drivers shouldn't return, to make it possible for BPF runtime to
>> determine if bpf kfunc for xdp metadata isn't implemented by driver.
> 
> I think it diverts ENODEV usage from its original purpose too much. Maybe 
> providing information in dmesg would be a better solution?

+1, -%ENODEV shouldn't be used here. It stands for "no device", for
example the driver probing core doesn't treat it as an error or that
something is not supported (rather than there's no device installed
in a slot / on a bus etc.).

> 
>>
>> This is intended to ease supporting and troubleshooting setups. E.g.
>> when users on mailing list report -19 (ENODEV) as an error, then we can
>> immediately tell them their kernel is too old.
> 
> Do you mean driver being too old, not kernel?
> 
>>
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
[...]

Thanks,
Olek

