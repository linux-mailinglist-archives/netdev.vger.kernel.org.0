Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5FC6E9683
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjDTOB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbjDTOB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:01:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B541FC7;
        Thu, 20 Apr 2023 07:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681999285; x=1713535285;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wlJbmtqDc9E25l43RQJrlmMnWx0JfXHFjAkWdzDpd/I=;
  b=cN1I++b/Uee537/wesfacfwUQOnAzF3urJ1PWYuyBWBdbZOfNJcWsWwG
   osYzVO4mV5JEjl8vEB+icwtVRqgfGTCAGCF9r7pAqH3/kNC11uICi/cHX
   ABHoMdLDyZmJOd8/wpnoggLg2fLWj9ph7+42jPebnypdDj4D2RxnSX5qA
   SDTPMOTEn5nl5bJ/Sy+lrYju1QUqu6qfU9zj+mC6d6nWhWDZTT77gkQqn
   NyWnDc9I++rCkpSc8de6if2/unSPkKVqVr21dN1Cv06L6aAlwBgpGPgi+
   6fhyts55+mpdrYNFuq1TecqY/DlwsT6KV2h9B+9pYJgZy0vF+5Y/byFmu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="408653651"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="408653651"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 07:00:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="722379519"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="722379519"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 20 Apr 2023 07:00:58 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 07:00:58 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 07:00:58 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 07:00:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 07:00:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXDupKcZA3p3A8dMjSfKu5NA0owxwkEWtKZdjn5PhRpv9wXGaLr3Pzx50i7gRKXS1uTl7jn6uDfnO6bci/RLuHZkZEXSseidFmO94ez0A0ykNJfj86wW1FBBzbPY4KtznAVF2NmXuokH9XlOaiT6bQZ7wKMNZyzxQkcmU2Y5MLjBTVMB+T3jQK6CG3t6q7ZtqBU1jHlB0/apAhKbqgnNDCJmWGwx6DgpykP/zBaq1x8RzISkpvYXojwsCf0OZpwBZdy+FnSTjZvjpxyjELva2YZGo4NB7lqrVN3mCoChMV4cs64PjftRlnWfZ4afW3e0oH37097RcyTe3XWDysWyqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMCPh8pzTEQt4Xnkcp1p5ydoTZtJIqSnpg33lQiYKyQ=;
 b=N9SnThpsqL/NgB/8H9nrL2l2nwhiYLlGur/WZZX3kLZZztpN8prb+qIm927uYfVEbOAH5eXIGuYorNxK+yMXlfiTm8LqXoHQqEaYiR8CTOtBLjwkk1K4mmBQcfVTvQ8xlhpgcM+xMhDS5hhKvc1L7hMCdLoHFH6kO9ktDHiDwrg5BL4cKRuOES/2BuyGEPCvkFm8E1nNDsT2UK+sDC5bsqCc0A3aZeZ2ym90O1Hn3jQZW79DMFNb8gxNFASKKG/jSwn5YHFWVYZarJEADI1uroViXsZe1VneqGYTSOCy2Z5ltTh3+GL19jysfk6RHflAN+bWbWiqccJQy8dfdEojlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA1PR11MB5876.namprd11.prod.outlook.com (2603:10b6:806:22a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Thu, 20 Apr
 2023 14:00:54 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 14:00:54 +0000
Message-ID: <ff3d588e-10ac-36dd-06af-d55a79424ede@intel.com>
Date:   Thu, 20 Apr 2023 15:59:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "Maciej Fijalkowski" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20230417115610.7763a87c@kernel.org>
 <20230417115753.7fb64b68@kernel.org>
 <CACGkMEtPNPXFThHt4aNm4g-fC1DqTLcDnB_iBWb9-cAOHMYV_A@mail.gmail.com>
 <20230417181950.5db68526@kernel.org>
 <1681784379.909136-2-xuanzhuo@linux.alibaba.com>
 <20230417195400.482cfe75@kernel.org> <ZD4kMOym15pFcjq+@infradead.org>
 <20230417231947.3972f1a8@kernel.org> <ZD95RY9PjVRi7qz3@infradead.org>
 <d18eea7a-a71c-8de0-bde3-7ab000a77539@intel.com>
 <ZEDYt/EQJk39dTuK@infradead.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ZEDYt/EQJk39dTuK@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::15)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA1PR11MB5876:EE_
X-MS-Office365-Filtering-Correlation-Id: 6034ead9-3586-403d-d1d0-08db41a7a843
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G6hbnyKebgnbQrYTukuwWLXI+oULjE+GApo+E4sO5VHRArr+kvRzPhQnXlAKVR4Oh7t8hzBKN0sBSNG7veNycoyRE5t2mol196a7vvSvnmL5Sn4rALtumEcaPBp1DqFd9cosNUlZB0XK6g6GbqhZLbRej4ZmOKm4AF/fAfq+yYflARalN/5m05UBz78eYa5qtvtCRd/HcupjkZHZAjGpdj1trcGAp+9kjyB+DpTkue+vhMx2Qxrf1NKTQIOgn+LKKdJD+N6P5JErF/s1i0ZyqykPECwvFGfR1CpmUyQ0bnTdwok2QeoYFiG2vA1CzYsn9+zajGuNcDffE6qvY5euYlyApohbszN778IOCPxx/E9Ugs3NaVH/bYiENeEPQwRPqXnTtNJ58txJHQNBfztqEtFBK4slPs1Nvvofq8xGjLbslVYoaqsAsGP9aR6UJxD965Ze8D7aQyZ9gNdvHnNjALoJjpTYYYvj7Cj/uh14882Qe3s7craIuKpeVVU9OLUC6lmE6neKqXqhI68uPxxs70ELVpv7su9JObV1f9zrQQHJ9TLZCdeAvLwPS7ZO8+2wdX3OPU9cG+HCkUHo++dvj/PAMFxXasz1ClHNU4dqDdLyaCP9tJ8LsPiCiK7jrTQ6rS+rdkvUdBPy/o+Ci4HmWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199021)(2906002)(8936002)(8676002)(41300700001)(82960400001)(7416002)(5660300002)(38100700002)(36756003)(31696002)(86362001)(31686004)(478600001)(54906003)(2616005)(6512007)(26005)(6506007)(6666004)(186003)(6486002)(6916009)(316002)(4326008)(66946007)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2FMNi9yWVUxTmNFWVYrckdhbXBRN2pSbUpDVUk4dUYwQkpydytJeEhpRkhy?=
 =?utf-8?B?UlN4ZmFaemcrQ2VZVGt0dVI5bk5wYmNmcVFBaFpmNElTQk5EWEZnQy82Ti83?=
 =?utf-8?B?WFVtbis2eTB4czBMREJ6S1VzUHRPMWkwQWJienNscXRJK2poS1RUUEo5NmxW?=
 =?utf-8?B?dyszTXVVeGM0RnVET2ZocVQ2T0xMWHhHcWJYR1B2MFdwbUVrdlZWdURyL3BD?=
 =?utf-8?B?RlJpWGpaclQrYkdLZzhKYVp5b2hWRFFuUjFRa09CTWlOTDhtTHBNOXQvQWdU?=
 =?utf-8?B?SGtIZFdBUDVvUHNzaUt4R2VmWlVtY0xpV2orVjkzNGIyTUI3RVUyYnZrWHM3?=
 =?utf-8?B?OVVrTjZTNEgzeU5lWUtFaFIzN2wxeHBDblJHMHNLWUpPWm5Ma0dELzR3L3F3?=
 =?utf-8?B?WWJQYk0raEExT1NHZWkwaHI1Rk5HK1IxOC81eUR2L204NGVWK2RqRVV5MFVK?=
 =?utf-8?B?VFJJa0pnQ0tyWXMvUWVGUS8rblo5QXFaeVFTbUdoZ25CYWVleE1icVpWQU4x?=
 =?utf-8?B?d2w4eGtrTzRlUmVkRG9yUEtJbkdQTmN0U1E2Tnhkb0xnbkFJOThaOGt3UUJL?=
 =?utf-8?B?ZC9idGtoSmlFdmwycjZvM0hJUVpFSzBzUGo2UnNCeXVCWnhnK2U1bEFRcTl4?=
 =?utf-8?B?eTdwaTZDQTZjaUJ4alFKTDR3NWwxZTMvQUZveVlXMXNjd1BCdklTcUFBM1lE?=
 =?utf-8?B?OUp1NmlwamhDd1c4aVRLdmNUNnUrNzBCSndqMUtUdDdXSWEzYVBoWDZKTW8y?=
 =?utf-8?B?M3dSdkh0YkxvTzN4S0NFZDZmbXdjU3ZLRUFrYjdzMVFJMXpXcHl0ZnZsQVVw?=
 =?utf-8?B?VERZclNkd20ybWwrZ0FHQURCNmhsZEc1M0JYNEJRMm9vWkUzMmxXU2ErOHRT?=
 =?utf-8?B?RGhOeml5amh5TUN1MHprRmlPdWdqWGlES3IyMll4cktaTDg2WjVjVkd2VUlO?=
 =?utf-8?B?c0Vpd04zdjliUE9QVDNVQWgzN2JkaTFCbmpnRDlKREVDNDdwQjBtbWk5YUxL?=
 =?utf-8?B?bTc2RUd4aFdwRm5DZk82NlhNNnFBVjFkRXZmNFlRSEw4Q0I3Wk0yN0J5N1R1?=
 =?utf-8?B?Z0MrVEJRbG1tbnAwWFZPeFM1bXAraG14RGswWDJtMlpaZmJVdytPZTIrY21v?=
 =?utf-8?B?bWFZT0VtWm5SNURiekZDNWZBZlR3d2M2S0tlTyt3OVF3dFplVUdHTGM3TEd2?=
 =?utf-8?B?d0ZkTnlJZ2xoOGhLd1JrVWdUaFAyMGlJUi9JNDNSdDFsdFJSbGVST2x5cFN0?=
 =?utf-8?B?ekhBeWlSRFBLWG5VMmx5N0JxZGdmaVRBYUgwbTVvUWlQY2Z0cEZQSG9DWTN6?=
 =?utf-8?B?dWNkMjBCZi9OSExMWGt5K3R1dEZTZ0s3dWpHQkQzYll3NURBZzdoTVJ5eU9h?=
 =?utf-8?B?RjJidzYxbDZPY3RGZkhBTDhoRjg3bm9LemtZWSs5eWttZ1FuMlZKNVRIcGJj?=
 =?utf-8?B?R1hPbmdvSVBQemFZYXhlTGxRVEN2WnlnS1RMd3NtdGh3Z0pPVDZBa29Malpt?=
 =?utf-8?B?OTRxQXhaaEF3aDBVb2VjcFBnd0lXUGc5UElaRFBHRWVFRExaaXhhL2ViaDIr?=
 =?utf-8?B?SFVLOGZoNnhqZzlMcldoM0I5alVDOWQvcXh3K3NITFoxR0M4MHoyVU14cnUr?=
 =?utf-8?B?NW5qZXpmdVFPblBkVXlJamFlVnRTaGZyTHp4aHVIMjl2UnRETWw1bk5JQmZ5?=
 =?utf-8?B?Zm44VkJvUWtwL291WEtUQko3SDFZRmRjdWFoeHVFUjhTdVN0RHgxUllsOWM3?=
 =?utf-8?B?eG1VeHlncDJWQjFOeG1aUzhZWVVLZmYrWEF2Zm5obHVqVzR3eDFUdmxqMmVn?=
 =?utf-8?B?T1ZmclpFc2hMYmlYMEcrejlZYzMrNmNLV2Z3Mlk5MDBpaCsvMVZ0S0NWZDAw?=
 =?utf-8?B?VklmZHJBQ0lkZGRmTmFPZUdFNGFMY0taNGVXakd5dUVVd3RvanRjVmd2VUN4?=
 =?utf-8?B?OURtZDhBQzZyVUxUTThKZ1RmMktiMGJCVUZ4YXpYK1BsMlNlcHY0OUxLK0dN?=
 =?utf-8?B?UG5rbTJxUUFJUG9iclpwd2puaVFvRW5sZDZHVjBuUyt5UnRmMy9TMmNQNndy?=
 =?utf-8?B?dmNFVUxtQ0U0NDN6M3hiZDh2STVWVWxaa1RPa0E3MDFiM1dUMlV1QWFlcG1N?=
 =?utf-8?B?VGVETDBhbTE5ejRwMmJSeERlVTIydDhzZENGMTJiQkpGYXd5aXJDai83QXdn?=
 =?utf-8?B?eGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6034ead9-3586-403d-d1d0-08db41a7a843
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 14:00:54.4510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XSKAcPxWY1k3CpjhauRGXCbqwEwGdoXcJ9yRWfxWF5/6h2WAWxjINlIt/DtWjrd59O1nHS6fGyvmPMlKspnHIcHzofnRhcae3txWuzVd9vU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5876
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 19 Apr 2023 23:16:23 -0700

> On Wed, Apr 19, 2023 at 03:14:48PM +0200, Alexander Lobakin wrote:
>>>>> dma addresses and thus dma mappings are completely driver specific.
>>>>> Upper layers have no business looking at them.
>>
>> Here it's not an "upper layer". XSk core doesn't look at them or pass
>> them between several drivers.
> 
> Same for upper layers :)  The just do abstract operations that can sit
> on top of a variety of drivers.
> 
>> It maps DMA solely via the struct device
>> passed from the driver and then just gets-sets addresses for this driver
>> only. Just like Page Pool does for regular Rx buffers. This got moved to
>> the XSk core to not repeat the same code pattern in each driver.
> 
> Which assumes that:
> 
>  a) a DMA mapping needs to be done at all
>  b) it can be done using a struct device exposed to it
>  c) that DMA mapping is actually at the same granularity that it
>     operates on
> 
> all of which might not be true.
> 
>>> >From the original patchset I suspect it is dma mapping something very
>>> long term and then maybe doing syncs on it as needed?
>>
>> As I mentioned, XSk provides some handy wrappers to map DMA for drivers.
>> Previously, XSk was supported by real hardware drivers only, but here
>> the developer tries to add support to virtio-net. I suspect he needs to
>> use DMA mapping functions different from which the regular driver use.
> 
> Yes,  For actual hardware virtio and some more complex virtualized
> setups it works just like real hardware.  For legacy virtio there is 
> no DMA maping involved at all.  Because of that all DMA mapping needs
> to be done inside of virtio.
> 
>> So this is far from dma_map_ops, the author picked wrong name :D
>> And correct, for XSk we map one big piece of memory only once and then
>> reuse it for buffers, no inflight map/unmap on hotpath (only syncs when
>> needed). So this mapping is longterm and is stored in XSk core structure
>> assigned to the driver which this mapping was done for.
>> I think Jakub thinks of something similar, but for the "regular" Rx/Tx,
>> not only XDP sockets :)
> 
> FYI, dma_map_* is not intended for long term mappings, can lead
> to starvation issues.  You need to use dma_alloc_* instead.  And
> "you" in that case is as I said the driver, not an upper layer.
> If it's just helper called by drivers and never from core code,
> that's of course fine.

Hmm, currently almost all Ethernet drivers map Rx pages once and then
just recycle them, keeping the original DMA mapping. Which means pages
can have the same first mapping for very long time, often even for the
lifetime of the struct device. Same for XDP sockets, the lifetime of DMA
mappings equals the lifetime of sockets.
Does it mean we'd better review that approach and try switching to
dma_alloc_*() family (non-coherent/caching in our case)?
Also, I remember I tried to do that for one my driver, but the thing
that all those functions zero the whole page(s) before returning them to
the driver ruins the performance -- we don't need to zero buffers for
receiving packets and spend a ton of cycles on it (esp. in cases when 4k
gets zeroed each time, but your main body of traffic is 64-byte frames).

Thanks,
Olek
