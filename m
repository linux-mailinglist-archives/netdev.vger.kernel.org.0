Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634FD672AC3
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbjARVoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbjARVnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:43:39 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50795656EA
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674078185; x=1705614185;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5SOIzSq9wE6OGoJvwDuhOyj2NkJt/c1xQFD7pPYeW3A=;
  b=e78kTY4gjzFlWsF8SiG7Fy+nZ5Dutnqh4y14TLqNeH+fVPI2xV04KPqm
   e6QlA/Ppc8A6S3m/avLu0NJFCa9eFCNjXTbgw6lRkV5qg9Xj4nd9jR82A
   KxV8CQ+vJcXi4OBplm5j2TDbKU1JiqFg3pm/OA2oUDMsp6o06tfHyImU+
   EfuYOmFUHnkJWclFBOBiI1ZrtfP4mbq6ZEYJu8CVbGh5nIgNqAL6iKacJ
   j0WIaSSuxQq5ysSJH+wkfjHQ73NdW0U45kzseTEDcsQa80cqphzHfGc3i
   tFX7FpaMpUSci7tCOlzRCtHAPkkLUgeUT5o94Vvb5iNhrkOMWp/A/9Hjo
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="327182960"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="327182960"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:43:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="905279131"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="905279131"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 18 Jan 2023 13:43:04 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:43:04 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:43:03 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:43:03 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:43:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXRIwDw2xIQGVZnBAqFhPrK1tgOCWNmU8mqkv8Zok8d5tis9U/OvBywJ4G+H9lMV4eYwCH0Seku4pABDGbaG/JUWfjpKL5Z9Idjp9BvMP6pQH1kDIJI7M4TC+QU8c95T+tPj+h4IusAgDqzu7s2lg6e9QKUWCKjP2LU99nG6+SWRhS0DaaAqmtayq5UzXWG9SAgzDzg36UKPDyKXLNC8WH79+yOE9SNGOPu0a5WzzMrC1JHaeUbTKASvSQZpGvIcaT4Fqm+FFB/KX9RL6l8vSzUOwSy7mP9SG4pfgP3Zf1ZML8Lvd2UB/HX0+cUMzxL7r6yeYO/z7Cerro9A1zdwfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/EsdZg6dkuILny1via5ARs0wZZ+J/oqlY+Tu1sT8xk=;
 b=gUr00vJW3sC5nRECHVzERr2vCkWwkXmYb3tJO5/X06dmnvcMuu0VHgl0QYBpFd92xioR0RQXk8QcGQqXqyhSMGjObbtQPFulku1oCErIgv3LYX0eO5+Cx0dwHnsxS1ZNwWlrOyPpXcHpfvbWdkhrFn+GqFv3UB61YNN7GQK09udz8EsClgXn60UE4SHNv8dSZ7wFuHg5K/MlN3tKzU/7puHJ/8b9elqgsMcL+b5p0AiRuYuAG0zmXaZJnnG0i3rlMIuT79dNjYyI48MMTLqxmZVssssE5v2uupP1iFKCGp3zr6moikEOi+d4EyHKwX2nhR09vMOQqKeXA+xuzEnLaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA2PR11MB4825.namprd11.prod.outlook.com (2603:10b6:806:111::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 21:43:02 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:43:02 +0000
Message-ID: <955f1d7f-f588-609d-dc3e-4232169e5bee@intel.com>
Date:   Wed, 18 Jan 2023 13:42:59 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 08/15] net/mlx5e: TC, Pass flow attr to attach/detach
 mod hdr functions
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-9-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118183602.124323-9-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0110.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::25) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA2PR11MB4825:EE_
X-MS-Office365-Filtering-Correlation-Id: 004d9134-0c3d-4fdd-80ec-08daf99cf939
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pr+csUrvRZkvu0mx3RcJsW2mn5skarYU2E6jQ6yCYFEgILdsuhcIN4m0tFaF8+JV3Brmlv5w97VMjbQsqlPORSUaPmhGisp/WnTDOFXUO4Oc2e5MVLZ36xVFcOhPxG9HYQOD62FFHGKH4tKm8vR8T7mLmrLG0XohGcRlGe6rgihFiAXdyPsg1bv3JszqR/+9sNQ4Td8DqRARx7SFMDF9I8K0LOKmVp+GnRbSIJqszeSrBFf5U+UCJkT0CmUAtAO7DGAI2ggwkwxV5qcHqTaAbiZCGvg43F7TdVs3r6iy7kdb6BYcXXT18poiLc0Q+I5M/f1OkQCKNbtbsyUwvOe1vw1OeJlALEeQrE3dW7Tyw7MAt0N/ffJUiPp6qOH/xEzIPecQRJfz21TUIbCfIqkSprug7vr0jlN3LbqgFfkOsI9V6dCRm/14Lue1WJcvG3a+vppW+WCcCIwnp4hNKmzOl3892S0kfY4QR5n5cVNsem7DhU3tmJbOwBOY9P2EeUjXJ1P9PzItvLgZSjAt30y1ztwRReOLoZGncTRWvkiSE4dNnSMIhNWVxs4Syj624uYyUxjs0Mm0OHtlqDn2hIwBkynjxtwRNGrnNYGWhCqrpRdyTesCgaEY3EgbvIQGWghGO4g7rOW5u49UL7NfnkxyZ+1Ur/vmReJHZfkMAXZS2HmgvPCqK0FtgIqjKx3rUiradvD7DEkbICU6evp0OH+zbbhw3w3XVfugEVvBERhRl5E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199015)(86362001)(31686004)(66556008)(4744005)(66476007)(7416002)(8936002)(5660300002)(2906002)(82960400001)(31696002)(66946007)(38100700002)(6666004)(54906003)(53546011)(316002)(110136005)(6506007)(6486002)(36756003)(478600001)(41300700001)(8676002)(4326008)(186003)(26005)(6512007)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUxMQTYzdWRPUlZweVIyZERRZERQdE91cmFpZ2NSeFJKdzlyeHBMcVkvaDRj?=
 =?utf-8?B?RkxJbHNTbjFnckZJRGdVWnBQL1ovVWJUbTJsZDFXUmorSDllSk5PVW80OGZp?=
 =?utf-8?B?eDFYeU9PTzdCRDBaaXowZFJ6b2pVQzEwdlNQT2pyblR0V0RxVjk1dDYrMXZ1?=
 =?utf-8?B?akVKdWtkQWFtblVVWFByZmFNSXBBeXUyWUM4NHAydnNDVVN5RGpxU0l6b01q?=
 =?utf-8?B?Q3RxcUNZMFBmWmswOE93TkNCdkRTbktaTzQ2NXFHVnQ1ellYL09ybXVGSDRS?=
 =?utf-8?B?Y05TUzBlY3RLOXRMM2N2cGpod1hnVi9Xdk5qT005ZmIvenRNdlpJOXNLZWcx?=
 =?utf-8?B?MmUzNlMxSFFWODNremtiREppM1dnZ2Q0ZDgxQ0kwM1dESmZ0NWZ0elNGSEo1?=
 =?utf-8?B?Vnl4WVhmcDYyYkZDcm5iQ216Y2k0NVg0VjJvOEJHT1E4OUFjampxUGc5bnFO?=
 =?utf-8?B?VFdMaXlxVDY0YTJqL01nQU5vQjV5bUlZcFRNZWU2Qi90b0NVMmd6ZG41Q2Rj?=
 =?utf-8?B?SCtCbHhGUVREREJNZHI4UWNFNjlTQUs3UnF2SCtjK0JsRXNOU0hyWDVuWjVS?=
 =?utf-8?B?anpSOWFGdjNRbE0xV0I2L2pSSHptc016QytJaEVXanRYSWtGNnZ3bXlIa0Z5?=
 =?utf-8?B?Qi95dlcvWVV3RGpGcWQ4a21reTBBOWZubjRpekJSWUJHaldIRWNwWE43NVlL?=
 =?utf-8?B?L2Y5VFRNbDdUUTV5U2tXQitwTWhUcDNXdTArV0JraXVyOW1tcWpsa0I2UDdQ?=
 =?utf-8?B?RkJMYjlQLzVFZlpBeWRzWDRlNDkyLzFPdE5paVprNmVIK29HQW9DcmFWOWt4?=
 =?utf-8?B?S2dVZyt2NlhzdHEweGVBRmptN3AxUkRFMlBpbTRyWXd3TXRsdk1xMWp4TENh?=
 =?utf-8?B?REtlWjF6WXdSV0kyQ2N2TENtSE9XaTZXYlFCVU5LSVUzcGl3YlFoc1B5SXls?=
 =?utf-8?B?dXhLY2xodlB4WmErZDgxSXN3TVlpcnF4VGtsN05pZFB0THpDTUQwb0Z5QUJz?=
 =?utf-8?B?VWUzT3VhYzV2ZU05V1ZQamNtL2FUWGNBVFkzYW1lVTVTVkhtaUZnU250L0M3?=
 =?utf-8?B?QVVZVWp0bzk2VGxtSDN2cVcrYXI1YkNkL0s3QlhlTllQRGUzYXEzTkluRGw5?=
 =?utf-8?B?UjBzVHl1YXNLOXpqSWRUUk1ZMnhqaVdvZUxKQ1JINmoxZkJpRGZJZUxJbitB?=
 =?utf-8?B?cjdhNGtmc01Sd2g5MCtwODBaOXhhTGkxVXZKSVNlS2g3dGVkak8zNStVaUtR?=
 =?utf-8?B?eFgvbUNRSU1VUDM5MFluaFZWRkNHZWFieGhKZGx5UVVBb1JaTEtJanBYTXpo?=
 =?utf-8?B?M1dUdXBEUWpEL1RyMXhPMzBUWkp5WHV4M0Y3b0E0SStsU3FMU3RjNmhMcVdq?=
 =?utf-8?B?NXJhYTBUaTZoL1Flc2xLaUZBd2N2UG5nc2xOaGRPMXdyZDhyNlo5d2VtbHNR?=
 =?utf-8?B?bFNIYUFnc1pmYW9pUElOYXVxOVorVmtkaHFPdERPdTFQNHp3YU1GOUZ6Zy80?=
 =?utf-8?B?eE5XNnh4T3cra2c2UCtIakMwUVBNbjR6aTdzWmYyazRKeGRtcWZPT1FINkxR?=
 =?utf-8?B?S0pNbHZhL09ycUpITyswQURhL3ZKWGh0cy8vZFh2UmdheS9CMnhpeDBpNWVw?=
 =?utf-8?B?Rkx4OGcwd1MwbFF3d3BXY2dscjVucURpL3BsalJyNW0xVHdudGN6YmtVT25w?=
 =?utf-8?B?YSs3WFBJTGlDRURwTWliZkZVRTFjU2VpVWpoaHdqMUY1RFlJbm5BdzY1blpX?=
 =?utf-8?B?c2tuWTk3WGdFS2drNFJiWjlRWWp0dVJrcWpvMFhTaDdINjUvVnozZk9ZZVBh?=
 =?utf-8?B?VWc5MUtHaEt5TVBUOEVYVnJZMFhBREdyRDhIMk5JUG8zbkpvSjA5YjE0U0Yy?=
 =?utf-8?B?RDNQV0k2eGtUWjdpWUFBMjFrWGlUV041Y2ZTL09vR25LdHVtZjFmcDRveGJT?=
 =?utf-8?B?VkRFN3JoMFpiYk9jWm0zVk4vdHN3VE82T3B1Zk0vbVVJQkFpbXh1NkpVK0Mw?=
 =?utf-8?B?WkRZYjQ5cDRvQ0RrWWFLVkd0RjlYRlI3WjNmaFQrdDFHSm0wcEQvaCtseDRL?=
 =?utf-8?B?UnhXb2wxVFBVR3NNOVBOUGdPanFtTnlBOXdYMUxna2MzUlp1eG1zSmZ2aERT?=
 =?utf-8?B?bW5pQWtrc3M2bVl5VkorWjdtd0lQcDI4ZmVWTlVyZmRjMUJYMlZ0c3hPZVhs?=
 =?utf-8?B?dmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 004d9134-0c3d-4fdd-80ec-08daf99cf939
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:43:01.9418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ETm4PucOBdGFRRuEp4MkVrQw4vfJBDz1WZlaZJ5OdNY2pKFxCUn+3LlFzRHipT0eloUZeO1II4sKTwK4IrC7pmnrJXvpt5wXjhN28/8QH38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4825
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 10:35 AM, Saeed Mahameed wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> In preparation to remove duplicate functions handling mod hdr allocation
> and the fact that modify hdr should be per flow attr and not flow
> pass flow attr to the attach and detach mod hdr funcs.
> 
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
