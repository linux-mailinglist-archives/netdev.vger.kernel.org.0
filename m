Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6046BB6DA
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbjCOPB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjCOPBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:01:31 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6265B44AF;
        Wed, 15 Mar 2023 08:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678892443; x=1710428443;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=24cN8bb857t5S1RvNfMC1HoVeZNPmlm01in0PVOhX4Y=;
  b=RNmJ/1tDSZfLv73tXA8taKV2yQnX5UedfpUpWRKCxMtg8OhqpILxWXYU
   tHm3GN08Xb5viffSoHzX2cRnYK9e7d6hcd+16UBZaVuq/2Yp3ZNCEEHXB
   RLQevvDW1axX/3UsNi/5z2POWq5MZ/5XfIZ5N1yAszIZpjPYkn8rdQ7ue
   F5DztvsyK9fBs4o2cZfkAUfrML8r3l/G5WdkIWXGB4UzHz5CarzbwQcEf
   9XhyqdMoU4mj6ciPe0pBuGgyxlDrgwSKOqlpOIaXx++pQLEesEbkpT1pr
   Ou9gAhhQuOp913/aKqHWNUfdOmaKV0YnGvjob5Yp+pk7hdxF/OzEccwdV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="400305103"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="400305103"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 08:00:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="789826393"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="789826393"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 15 Mar 2023 08:00:16 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 08:00:13 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 08:00:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 08:00:12 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 08:00:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iP2vzf7pdkOSQ42sFidxpJJLyJufgNjaqzURsKnn3i2/3D3KXfFA1VI6HFOlOqB8dT6nbEhSlRZPGbrps+PnC//n8K2uRazdIIlhvhY68VnN/gwbONSZexxeGNmqtk1SrG0oZRA8WG+PqNBZquwGgerSh1xrn+BdjWBQJg78tLGQWTcBFZ+Of0S/T0zPaoNA/VmBOIOVqSjq0TMJ+K/SYdCbw2Iygf87XAr0h1g8XGRYcWUttdwIxOGAVjcNp9mXtJTLMGlPPATQPaI8RQN2cKiWyp0xjs2kh3CM0+QYeDdkeSPuF5M4SacMk5IsSEsqq5VWVM770xUXjJr3PyMaXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YCKbMwB8NiCYTfxJH4w95EkXjp3vlTGdz6JPMaZ3x/8=;
 b=XyqVLkxJko/vdlAWupRTYeyUN2xMZ6wnzuuxCoPGYZ36DPXoJHRJz1QmrWSFUJlMPqTNE9wWmVO5hZBvt8hWFahHEw15NaZdjDPkjLQMZ4h9G+bXndY7/lOF1G7Ndx4RNb8qtAfG1DQhBWh8MLj+wvBvANBP8Gp+OKgqu5qx6ixJVSHl8+XwB8RLd6RKdzlqAQxh/odPmvxkGslJIlPrRnMNgDJ8pX1ndxKBVqRduqQp9TXrgKIA7760UacXoGX81RIPJEN4vmnvbLMMcYbKsaqh9ikeUaq5tV+pF5n7zymjX+QYbWfTNVmRWFgQfhWKTqN+1H7ytD7B2sFfn62wAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 15:00:10 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 15:00:09 +0000
Message-ID: <85d803a2-a315-809a-5eff-13892aff5401@intel.com>
Date:   Wed, 15 Mar 2023 15:58:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v3 3/4] xdp: recycle Page Pool backed skbs built
 from XDP frames
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>, <brouer@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        "Mykola Lysenko" <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Freysteinn Alfredsson <Freysteinn.Alfredsson@kau.se>
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
 <20230313215553.1045175-4-aleksander.lobakin@intel.com>
 <11e480dd-7969-7b58-440e-3207b98d0ac5@redhat.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <11e480dd-7969-7b58-440e-3207b98d0ac5@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0091.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::11) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ2PR11MB8370:EE_
X-MS-Office365-Filtering-Correlation-Id: fec07c2b-1cd3-47e8-4f4f-08db2565f84d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +z1Ka3HrqsJJfvulZFgW1RNBfd1uXAlue9KOCdHsBqle7He57e7v4qN4+VJ4vcTMFnPtyZKBVWHtc7N+Ssf518g5TjLsklXwbFmgwCsbaTzxkQUNik3O+/bU/0upHd2oO/8TuhRN0bi6cqBF3MYX+PMAWW+k+Xsj1tmCTBTUF/4cuzEhX4olOaKRvhYPVhEIjHrCKHWGCoi3C6GKwQYWGWfUttotFpkWuZeYJyvCU9jafILi6lVNcGVUWwMImDTz8mkqjEI5T0SrMx6jE9/KI7yCWsYvD9f0IB4joQZQLXdv8W2OxhoSDuwNUGyF8qNeSMW80DZjIO4p/Or1XlEYdNw9tRfG9IDUAKn2yUhN7sVysTd6ERmxBV7zwMx36T+39aQMbLmdIWg2byJd6pbFi/1bFiR1bhLaMADiK4Gd6/Aj4QrJVVOjmtGFk5PNc5U5Mes21eNsO6VjIiIqXKVgAwm6fSeYciUMBF3JOKBFL5C3SIJ6APcxpp+wmGVo/xNVEyX6h9DhuWg8X1KQRawAoEqsykRYosb00qrAoqu5DnSNfMYryPSdIGPYlc6boKUAl9u8PrIVqwwOZF0OAo1CkAVy/t+u/+PkzZWDyAzyRiEG46LHprndF2EYh44blwlMDM0iukDOomRs7xG6dtsCbWWu1Tpuse639FUiNHBzrsW0XY7aM8mEdOZFHvRr3MccJpcEmedncoMMFGYVMqEc6MbDgAN/YrSF1BsU1O11QTk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199018)(478600001)(66946007)(66556008)(6916009)(4326008)(66476007)(8676002)(82960400001)(36756003)(5660300002)(38100700002)(41300700001)(31696002)(86362001)(7416002)(8936002)(54906003)(316002)(6506007)(26005)(6512007)(186003)(6486002)(31686004)(6666004)(83380400001)(2616005)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkFkZGhGSHJ0Um5UOEdXWTVaektqYjg4WDFzakhoUGRNS2pYTCtESkhkRXRC?=
 =?utf-8?B?Ymsydmo1QXg3d0RRVzRzNVlGcXBTVHpvZm9hSDI2UnBuQW9tZ0t3VUsxUTly?=
 =?utf-8?B?SXA3cHhBLzl3bUN3ZnYzZ0ZBTVIrK3hhVUMvdzNVMDhFWFh4THVQUFlMQ2Qw?=
 =?utf-8?B?NjVyL2h3MEVIM0orOWxFRHRGNzNwQ3MxT3o5emgrUWpaVlk5Y0pQcUpQR293?=
 =?utf-8?B?Z01uQlFaa0xubXFROHExZW1lQm1NUGdiZnhIUmRsdmt3N3FpakhlMm5uRTVi?=
 =?utf-8?B?Y09vY3ZLZkdJOHA4c3ZjdG0raDFlM1d2dDZYaVhQOWphUHJqUkxSMTd2dHd1?=
 =?utf-8?B?RmgwUzlnTFBuczVIVWNGUEJOV2lNLzd6YzhuWDJuVjFJY0p5b01VUVR0SFBN?=
 =?utf-8?B?aHZVTFFoK3JMTXBvbUxSbUxWby9HaGNUOWtNK1FyNXpFRWluUkdqK2VYUHNz?=
 =?utf-8?B?R2RSSkdwSkJRa3RWOVZaTS8rS0phY0tHc3pqeFFBbFRuNDhDMnBaWFhmMHg2?=
 =?utf-8?B?dkw5aDU1dXNLWnhaaitGWTcweE05cXRTQ012SGRZOERGN3lZalZhZnB6Uith?=
 =?utf-8?B?VGZtejNDZ0tXZnJoUmlJajdWVTMrTHIxSSttVzF6VDVGTVJFMy9Oa05aZmYr?=
 =?utf-8?B?YXN3T09PaW1tZ0tlTjlGelphRlZLVnBrUkE3KzdvUG56VEJrTnlxdHg3UUkv?=
 =?utf-8?B?WWJGckVHb2xzTElHVzYvdTdrOXdKT0tpcUpkcXpROWRjbGo4VDhsd1pQRStK?=
 =?utf-8?B?TGxZZDg0TGlidExUMFZIMkFmcHczeHpBOUZWV3lseG1qOVZFb1FrTG9Ic2lq?=
 =?utf-8?B?R1lIRjVJYjVFNUUyREZpb1BtRUluRjRCY3FpbWpQdi9vMmozNVEwb20zZ2x3?=
 =?utf-8?B?NzA4VHB5VWJsSDdvOEVOdnh3ZS9YMEl5OGxqYU5xVzIvYi8vTjRnM0FDT2VF?=
 =?utf-8?B?YW8zdkV3b1lOK2l3M2MxaDlodkVaUm54T0ZYWlBKbzZPb0trdUlMd1FoUmFY?=
 =?utf-8?B?Vkp4K1dyamF4SUw4T250eEc5MHJrOGhjc1VxT2YzMGxMS0tnM3JBdWJlZFdN?=
 =?utf-8?B?Qks1Yk5WSVZXeWRVdC9JVlVzMjZPdDYwanl6L2hEU2RmU0gvdVNpdU53ZlRD?=
 =?utf-8?B?aE5rOXp4ZklVRFhUWHF1aEtqSFhRWUt1Sms3UzlOVTd0Zmx6QUJDQmgxa2l2?=
 =?utf-8?B?Nm44dy9DTTUzMzVlZEIxU2Roa0RPZTVDam9RaFBreTVwL1o2Y04zaEs2YmF1?=
 =?utf-8?B?bHRlZ1QwNDZOTnVmRXkrV2ZOWnlIb25GYzRFeFRkTzJjRWszRjgrNDNEcTVP?=
 =?utf-8?B?dzF0L0p2ZnFwbjQ2cHRNaVdwa0Y3R2Z5TWcxL2dJOExtK1J3WHlJTFlqL0k1?=
 =?utf-8?B?ZFpoM0NPY3lQUDJTVENZZzRDZUhlMzJmT0xySkM3SXplWTZFU2h0MXFxQTRq?=
 =?utf-8?B?ajk3cGI3UVdCWlN6ZUxJQnd2SlRDSURDVDBkZHMxMTZQY0dPdFBxemRHU212?=
 =?utf-8?B?czgwc25VdTQyQmRONEtncVpMSlJzRTFIbW10cGViZW5DVEJweXpzb3N4SnVO?=
 =?utf-8?B?Umt4a0xJTnRqdzVmSUZQb24xY0pBK2hhUjVDWElOM1FXbnRrOW9SMVlBUHVp?=
 =?utf-8?B?anpmVXhFbzN6Y24xTjlUUG50NXg5YTI4MnFWRmc1Q3pnVGsyWFRuOUtsSVh2?=
 =?utf-8?B?WDB5Y2psWm1VdUJTLy9SaElHbEloLzJCNWF5MUJYQW1XbXA0YjdYbDlNemJQ?=
 =?utf-8?B?SEtXeU1vSXZrczdkQVNjRE9WYnJ2dTA1TzdIMWg0Viswb3EyWGg4akh3RTJQ?=
 =?utf-8?B?V0hSK243UVZWNHVUaWhYT0xMOFlNVms4RzNqZjZUZld5aWRvVC8xMnBMVCtC?=
 =?utf-8?B?UEppbkpVcHhUa3F0NW56MStobFIxSlJWRmFMdWJFc1JjWmorcVdNQzA5TGNl?=
 =?utf-8?B?WlhYMVh2YXA3V0VkZmNJQTVzdXNIa0tUQ1AzSzFiTFR4MXRpME0xeDZpc29n?=
 =?utf-8?B?L3M5ZnovYkZHbExZWmlkbkplK3U3Z0dycy9qSXpDendCb25HTGJXLzhsekRo?=
 =?utf-8?B?ZFF5Rk9RVGdubWhTNmNBdUtyanBWbXY5YWhmWm9CbXJBUVZkOW1JaGd0M0lT?=
 =?utf-8?B?cjhYSnoyNzlVSnF1VnQ4ektvYnRnbThkWDIxMnc2dVBzT0Q0SnY2d3M1enNI?=
 =?utf-8?Q?/ZcWd1hvj+Is7oOAsgGQlUY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fec07c2b-1cd3-47e8-4f4f-08db2565f84d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 15:00:09.4391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dnlnhr1YDpWJDNMhsIxks5AKHwn+mjOHpGiWVDbyjIz6ZLfBdWRNBPuBEozrRC1KJBq1894v8BCNFuaFgbzai6NwuP+5VB09pqlHBByStDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8370
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Wed, 15 Mar 2023 15:55:44 +0100

> 
> On 13/03/2023 22.55, Alexander Lobakin wrote:
>> __xdp_build_skb_from_frame() state(d):
>>
>> /* Until page_pool get SKB return path, release DMA here */
>>
>> Page Pool got skb pages recycling in April 2021, but missed this
>> function.
>>
>> xdp_release_frame() is relevant only for Page Pool backed frames and it
>> detaches the page from the corresponding page_pool in order to make it
>> freeable via page_frag_free(). It can instead just mark the output skb
>> as eligible for recycling if the frame is backed by a pp. No change for
>> other memory model types (the same condition check as before).
>> cpumap redirect and veth on Page Pool drivers now become zero-alloc (or
>> almost).
>>
>> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
>> ---
>>   net/core/xdp.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/core/xdp.c b/net/core/xdp.c
>> index 8c92fc553317..a2237cfca8e9 100644
>> --- a/net/core/xdp.c
>> +++ b/net/core/xdp.c
>> @@ -658,8 +658,8 @@ struct sk_buff *__xdp_build_skb_from_frame(struct
>> xdp_frame *xdpf,
>>        * - RX ring dev queue index    (skb_record_rx_queue)
>>        */
>>   -    /* Until page_pool get SKB return path, release DMA here */
>> -    xdp_release_frame(xdpf);
>> +    if (xdpf->mem.type == MEM_TYPE_PAGE_POOL)
>> +        skb_mark_for_recycle(skb);
> 
> I hope this is safe ;-) ... Meaning hopefully drivers does the correct
> thing when XDP_REDIRECT'ing page_pool pages.

Safe when it's done by the schoolbook. For now I'm observing only one
syzbot issue with test_run due to that it assumes yet another bunch
o'things I wouldn't rely on :D (separate subthread)

> 
> Looking for drivers doing weird refcnt tricks and XDP_REDIRECT'ing, I
> noticed the driver aquantia/atlantic (in aq_get_rxpages_xdp), but I now
> see this is not using page_pool, so it should be affected by this (but I
> worry if atlantic driver have a potential race condition for its refcnt
> scheme).

If we encounter some driver using Page Pool, but mangling refcounts on
redirect, we'll fix it ;)

> 
>>         /* Allow SKB to reuse area used by xdp_frame */
>>       xdp_scrub_frame(xdpf);
> 

Thanks,
Olek
