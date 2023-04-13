Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675CB6E0313
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 02:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjDMARA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 20:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjDMAQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 20:16:59 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE2C2100
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 17:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681345016; x=1712881016;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=REEeosf6oQJTQU+/CIARwiLjM0A2O9KV7F27wD7tVQA=;
  b=Bx28gwMc1fzgnuDx0YVzkA1pd7dyiBV6RC2kIUbFz2vWWmqze4nTG1Gy
   Dmgl39RT/jqIl0ZiZwqywIcLDRN3NNpEVnSwXkvL/c2eGq+Rvws9pwduO
   oM+54Nu7nDsb0Jj8jZIWG34HZn6oNNSy8V2geo7ECEiL8CcBMhtrYcG7N
   iSrlShyC6qubGPe2aLovQ8JpLDka51WyyVfYsC0FzZ5jlcmwcx3qweSca
   ztIzf93wxwLbRSuaxszE7SzQFm0jGar7cpOAt9VNdbWE8uJaZM9RJspp1
   pkJ24WtocH81XY3umIhLVowvYYC/iZLKlSyYm6ekUlQ1SXdt69R54nqq5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="341547545"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="341547545"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 17:16:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="691719322"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="691719322"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 12 Apr 2023 17:16:56 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 17:16:56 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 17:16:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 17:16:55 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 17:16:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dIy5noEqzPZnd2zxck0rgFo0EFt8PoiF6+ZVeGwt/SosqY19Bzs9oZ7MSM+iQE4LIZ3k5uD6oZ1mPLGI9PnlisMV5/77xdgfJyd9NGMn1pBKyBEZ7i44dmA5YMK8Noo18Xem9KoB+8JbXw+6WGUAp6m6pCgfbPUBJos0ROnUhsWNLrRPoNGKHORu7rOkdgaN0kc95nbo+Oj/3jT+i56wOhcPnrboiQZKyYzqxdSOnh36fNSPe0si24BsbiTjvbpCWyuQVruZzLJG6fyGICqAf7EhKJg1x6MfDmymkXDQuT+5+2RPqOkM4fpqrrQA8JW3kw66yD2/scaqe0Br/VHCPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1tbk6uSP/8u8hRnrOTgkTPdyJnBJJyy9oxkwPqrs4U0=;
 b=di+o2rljj4rPKGtOCoN/QH/1siqvv4dDWMl8L05ec9iGkftt0YhaVMZGbxYcmByos+TZjY66FB9AwKPwM2UIOQ98GGHvpriLdbxQ8QZSXM3pCTEkVSqt2lvdBwS70JdMlY+yYsu/E0Ohb6EX13HbYCjYGn8kf++I5gyIXlAu+Gdd8Lh5ejDZ1dMhiLWNYPPmDwcG3OrsxjOEp1b70vgeyqMK7OvlfyPHyCzAB/zV8oAzweeDJKV6oevTcd6FlbKFi6a3bI3XiQDVH4uak6wnnrGZuRBs+R2i9bVWC3CrxAN3ffKWE+HOk3x5OGTxrWjUCld+jzyNmE4Jw5iTgo8mxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW4PR11MB6958.namprd11.prod.outlook.com (2603:10b6:303:229::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 00:16:48 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 00:16:48 +0000
Message-ID: <e871431f-bc19-b4d1-83f4-6cee9cf3cb53@intel.com>
Date:   Wed, 12 Apr 2023 17:16:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [pull request][net-next 00/15] mlx5 updates 2023-04-11
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230412040752.14220-1-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230412040752.14220-1-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::22) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MW4PR11MB6958:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e92f850-f1b5-441e-9f8c-08db3bb45efd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kYxNx9h+ASYmuuvDCTiLtx+Avaclqv0UZg3rfYoaeprE9n9VFh9xN3WBLXn42+/eMq7sOn2B+c6pcxPYo7SsUx9WSmm+gICdJL2D3anyga6n0YFtZGvcQ0+qbTIxKysPKmpZifIQ867EqmOHjyjUxfZf9F+AClp+mwHs3Lmqkg0X0zLpAfcgo9k7C65tk0gIl9J6p1oWLJzslLmrIAw0haVf7ncZBHnMQJutV9heiyysEhShz+xbqq1AL/bOPUkktG2arHjFoFZs9fLUYNGqQzzkcL+LP2MNXLRp8SxYTxw6a5zxM7mcjM334mbtYEqEc56jtMA2IVQRkYGmcrRq65KUVpabiLipomaVmIDCaZkcel0vYPid7MD7hhaCIOt3iC96d2rKHZt/yYmOQNCyqX367mPom2HOCyROql5VsZyUH2K54yXfrgG4kaBRMy/10wVk57FTaSkGCJU9fZfqLjFKGboVZZYObwcfGUwlGJqJojT25pIBWs6NvaeBqYuOHHa4o1qUAgWj6unsJ8n9qjcgse68AtACggnuT8+NPlhVILDeBUe0Ppck1KTaVW2dOL22xZlufGfhxb12Drvt3uOYfABbjBAWyfmiGQV03nGR713tnVHsBzEGF8bGlUUWvd5gEh0uhKhxoSl4uPBHhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(396003)(39860400002)(376002)(451199021)(82960400001)(478600001)(316002)(38100700002)(110136005)(54906003)(6506007)(2616005)(83380400001)(26005)(36756003)(186003)(53546011)(6512007)(6666004)(6486002)(2906002)(41300700001)(8676002)(8936002)(66476007)(66556008)(4326008)(66946007)(31696002)(15650500001)(86362001)(4744005)(31686004)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWNtcXcxVVZkMG9pd1cvK2N5ZjlNR3dPOWViM0FBT0hXb0wwM2lXUEhnZURr?=
 =?utf-8?B?WDRaZEJZRk5tYTh0OGd2NjFGTmZJYlhNbCtNcWNOSUh3M096a3hqbGZ0UmZN?=
 =?utf-8?B?alpvZ1hhYjQzaDNuSW1rcWpUWEg3V0Y3VUZhQ1NhNWpwSmlMZFFFUzBmR1BS?=
 =?utf-8?B?RURNMHpXMkwyOU5WRStSZHdEc3dTM1pKLzdXYTk4QmRobnJZODhSejdhWU43?=
 =?utf-8?B?VWRWQi96eXJ6QkdhR2ZaanE4cDRxdW1SMnlETmJjMTJCSG03bzVXb3doMjZw?=
 =?utf-8?B?c2k0WTYyQWdXZ2czVVFUK2J1aWFtWFVQRHpFSEd4R3pVc0xKMXdOUEUvRmh1?=
 =?utf-8?B?b1pCYlNzN0YrY2JZekJZcVlOUDF5V1ZXNjBsaHNBZ1VyOTNiY3ZpaXdzN2Qz?=
 =?utf-8?B?U1JnM0trTUFWVXI4dUJEaG9ydTBGby9kcXdmb0xIUDJKUlNsWXU0YlJLRzUx?=
 =?utf-8?B?K1ZWTnBWK1JVcXhQVkVkZmhpOFRQdlhvdzN0ZFhpTWxPN3c1SFhUYlFvQVF4?=
 =?utf-8?B?Mll6MldSUHF0MmdwcUh2K0VDUDBNLzgvcEVHTnUzMHhYRElHaFdub3BiTmR5?=
 =?utf-8?B?RmhrVm1pWk0reHp1K0ZJeGlDV0svenJkdDJnZ2hXMkxHOWR1VENxUFFIaVcz?=
 =?utf-8?B?YjdFUS9MSU9pSkFCL3FwSU5MWktPVVpDajRhV1dFVll6L0lma3I5RFFiKzJK?=
 =?utf-8?B?Z3RDQXNuMUNtTW9ubHBqcDd0dGJacmJXVkNvTzdlZHRja0FYNE9pcVNqRmth?=
 =?utf-8?B?RWZYV3ZRM3RJSWVRcmZQYzdBRU81cG5XcjNNQVdCcDU2WHhmM2doVStOR1dq?=
 =?utf-8?B?YTRVdzlXbW5nRSt6OUdyMGs5RCt4dldZQjhiTlJaRDhxZGFCdzVVeGU4MmlR?=
 =?utf-8?B?Q2V3ck1uNUJBOGNpVDhoSkRKaDh6TmpuS08wWE9IaEZnYzB6RElod1J1RWZn?=
 =?utf-8?B?OTlmTnJxbXVuWGJTODJUNUhEU1VwaEpsR1dBS3RIaVo1eXBHUDBvZDg1aUlu?=
 =?utf-8?B?WnVtV0U5TFNrVzNhdURFbWp1RlVPbGhCNVR5V0VKQVBrWUxFZjNZclZlZEVP?=
 =?utf-8?B?MXVIMDIvNnhVVWFBME91RlVpV29qMU1tWlB6Qkp1WVd1SWlxbVdya0pJOE9x?=
 =?utf-8?B?UTAycGwxeGVXQ0oyS3FLQzJMN0poK3hWRUJGYjVIZXViOFIvczREeUJzMzNq?=
 =?utf-8?B?QThrZ1ZBL0o1U0hyYlVmeHI3dXVYemFwa0RCQXlDL0RpeFAvVzFXRXV0Zmo0?=
 =?utf-8?B?dWtzQjVVNEV1bVFvNnFxTlFqZDVWa3BOa1RsMHFKMnVQK1AwWXFGbVNlamVR?=
 =?utf-8?B?VXdWQ1BmOE5oa3RsWTR0Y0ZXTGllOTJHSDkreStBMitsMWJIZkN4Q1JsUDNx?=
 =?utf-8?B?dDEybFBFdkdYTGVtZGNZZkZqYWhaakZlWkFTa1MrN3hWTVVzbWxzT1NTT0xr?=
 =?utf-8?B?UEs3TWNlN3FzNkQvMGd5WFkvVHNrRmEwa2p1UGNTVVA4bmYzbnI1VElVcGxP?=
 =?utf-8?B?M0NRMHNqV3E1MkJrdVJtMDJqc1dnZEVFT1dzRDNjcC9iN0E2TXZ5dmMvUmZ0?=
 =?utf-8?B?eXV1a0N0amhHOFZCMlA3WTdGb3dCNjhsUU0yeWdkekIyY2xGYTFzQnkxNHlh?=
 =?utf-8?B?Mm5td1B6OGdJUjJnVGNvSEw2YnZnQkU5UkwxUFkzOFFLeFdCOE0vajFJanM1?=
 =?utf-8?B?UXJpcGh3eDdkejUyT3Z1TktONng4WGE4ZWxZUHo0NG1NSEhzUnNyT1RUaUtB?=
 =?utf-8?B?N1VldlRCRHNtM1JWV0w1cXZpM2g0bkxzQmoxVENhV1ptc0w3VkttVzhEMGZa?=
 =?utf-8?B?Y0VkR1lieWJSOUpVbHV1bWQ1bjNQS0k2RmszbWRnN1hBL21BaHQzSmxaVDFj?=
 =?utf-8?B?MVZDUXFndDVMQ0o1dFpTSDBTd08va1djL1RSUHUzRWkvWmZuVENveXVUaldW?=
 =?utf-8?B?WElIYXV5bGpEQ3djdlpPZVJ5dndxbTZPYmsyU0xNSXc5a1JCUWJXQjNXTlgx?=
 =?utf-8?B?azFkWm5YUmNoR1JGeklQRHBWNm9iZXlpYUpZaDJWTmxyenc1NXp4RkNlNWZN?=
 =?utf-8?B?bXFwM1dNLzl5RVlFSEFtSm1JVVdxYzlJVWsvQkwrN3Q4a1orWjBURGZ4Mk5Z?=
 =?utf-8?B?YTRBVmszQ1pjZldIanhPYVVNcGs2emRuZ3FUY3dRcjgvV2ozUEpJeHRVcGt4?=
 =?utf-8?B?emc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e92f850-f1b5-441e-9f8c-08db3bb45efd
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 00:16:47.8990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +z5ubEhSiGLmZe6BjH2+BSj1Rrl9Hwl5eq+whIVP1tuum78rjLvrhLOyH0u466Fm7Ap8PcMwGwWwSAi9aZiPX0s6wKv2KaQSGbE+DzzaCrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6958
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/11/2023 9:07 PM, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> This series provides some updates to mlx5 driver
> For more information please see detailed tag log below.
> 
> Please pull and let me know if there is any problem.
> 
> Thanks,
> Saeed.
> 

The whole series looks good to me, though I don't have a full grasp on
1-9's multicast offloading support, I didn't see any problems while
reading through it. The other changes are straight forward and obvious
improvements.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks,
Jake
