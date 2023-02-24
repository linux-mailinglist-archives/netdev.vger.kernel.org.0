Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88C26A1F59
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 17:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjBXQIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 11:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBXQIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 11:08:38 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699C9166EC;
        Fri, 24 Feb 2023 08:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677254917; x=1708790917;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r96F/dV4R0fTtwsXU0jJ3YAn3hT3HC0/Ps4mQPyUcHM=;
  b=m/x/6lK1ICR2k35nTZ08Dzp3Jc/xY82s3R8nCJCbwz1iya0zmuN13jBj
   CnuGaepU4nXOS0PmjWAn06B5gOXFoCq7fyS5pu+vsTtlFKtF52/Sxyum9
   US2TgBRo+ZnDDq8hhmSL0xipPzlvH9/kHbzf5Fvl2NSFWFyWAE0fRTHZN
   wzVo+Bs979IP+t7cEHLz6NQuMLBozoFO/4dsgLQNxvZkTWR0j0k2p4Tbj
   KFUHDrsSOjApKmZUg1+2RAtD5yackP7x6Om2wjtdofGpjZLf+jXGyC8hg
   BjaktnS5e1cZMu+8wvDw+nM0TUi5+cZcwEtZ7SiFrV4ojN+GUMsjN/9n7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="321710491"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="321710491"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 08:08:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="782417106"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="782417106"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 24 Feb 2023 08:08:15 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 08:08:15 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 08:08:14 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 24 Feb 2023 08:08:14 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 24 Feb 2023 08:08:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvN6TKzarqXcpGse+rYc5yK47fX5fL80XWo1BY5C7CBW14Y/BEu2hPZyj7wpNCcRmwk9gTGp5G87xp9UPINgd8/YKE3D4x4k7GQN4jy82x1ENrCCgJ49r6RhjQTamstKYwcO9YQNusxHakyKY3TPDsLLZGnVNCQuekKAeaZ85bgmu5rtwpu/IgTEo+xVtE5Flh+ogECV4rg2UjSQ1KbBeQDDCax+s1zwCOwpcoQJA5znv6UHG1TMLJGNCGNZhL3AmUn8tTdgHZ2DqAkmdR2aYOQrho7rhZ9Wxir32PXHEhtxVwX+xq5NP6FsQEc8MajzMXh1HWAH2EhPbxZ5/jEV9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yh361HA01K5GBvu91MWfMict6n13ar8odb80uFz+Koo=;
 b=BKwjssDx07Ka2lYFGPbsf2hN2RUNX5G/wyXo3bwBlNtuIB2fqllV7UmJBt7Ft0kZ7P/hhqZgnHWxGnoXrsbkA8TNFbMw6XALlUzLsVOZ6FaegaWL1bE3+vfJ1kJuXCejleXcLqTWAK3L1T00Vg2V88EZV2lKnMjyNO1Ulqhl4unFuCGCNbSUVwfP8TwCxoe+N5FqYusCMWZP/xdSMl+U8Zo8QtmkXzAinntUdbSYGtRfXAlFged2m62HpP3b/p+8dXPC9iKPaobXqZVGQqsTZuknOhJOyV528A+r4RimAO9uIcjQZCN+MeMhJ6q6kLb9hc5SxgJU+xn6h1M9OKH7zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CH0PR11MB8190.namprd11.prod.outlook.com (2603:10b6:610:188::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Fri, 24 Feb
 2023 16:08:02 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 16:08:01 +0000
Message-ID: <47a67799-27d9-094e-11c3-a18efcf281e2@intel.com>
Date:   Fri, 24 Feb 2023 17:07:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 net-next 3/5] net: dsa: microchip: add eth mac grouping
 for ethtool statistics
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
 <20230217110211.433505-4-rakesh.sankaranarayanan@microchip.com>
 <84835bee-a074-eb46-f1e4-03e53cd7f9ec@intel.com>
 <20230217164227.mw2cyp22bsnvuh6t@skbuf>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230217164227.mw2cyp22bsnvuh6t@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0111.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::14) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CH0PR11MB8190:EE_
X-MS-Office365-Filtering-Correlation-Id: 17597150-c72c-414d-1ff7-08db16814db3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lfvEOSVXKQRjZCMVUbCBnY1CJfrmUNaOj9NFjHJVLE4vOP889i96YY8dqFrhTNAJdKj8maiXrRNzu5b3VdHfc0mfObyySnWqJGcGQMJeqOz/52cXlXpFQ9Uxw4/Hw7xUAF/20bkP83xXeF8tCuCaLKMT0vS33tAOzQFNFDSVV/biAwATk0WlIg2t+6j2Rpm5fNpinuk2pYcCVg5em649NdfUdMtehhklz5HKs8LUGlKKiFrpTXMzAKsiWDiia9X4SMxm8lefYbJn5Y5rRwYsWU9BdQiN9Z6yn68b0IqoEf8KD0FxQ4DvDSiF9hVWnzhOw2iWUJ0OycPv0A0EUQyotgeIqIwRL2Df5+a9iJzJsx4BdkSWgMWIWfVkcM+OqrdT14HqlZNbYUsbEIusnQOLRFMH580lPcyHwkHMLjCgi57NiLtrBSh8RdRw95aUS6TUF9UjnXz9gCcYJaiN2SPxToho9NooxqpSgWBn0yc/+auhXdauvMb9InoURsWulBWIrqtS022Pr57mZLhCvEWAwmiuXOxDmVd1EdMUW/Ct3QozS1fK6kBsK5y1QSzVswt1P7lH2X+BhdwuPjhDTM5uN2dU+5lww+KsHcnsQ6DSUCqN4nmoMV5Ue5IljEDIMhU+MX8vNneTvU08KlJ8ee9novU8F6/IWR9tkzZi4NAeF7nudN2ehEOoE/c0sp3W43l7VkA+8E2lH3iv9qYjIQHGjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(346002)(366004)(39860400002)(376002)(451199018)(6512007)(186003)(26005)(31696002)(31686004)(966005)(36756003)(6486002)(2616005)(6916009)(86362001)(478600001)(66476007)(8676002)(66946007)(66556008)(6506007)(316002)(41300700001)(2906002)(4326008)(8936002)(7416002)(5660300002)(4744005)(82960400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXRtTGEwbEFkOU5UeDlnT04rdGo2aXBxcTJ6T05sbmJNOWJzWFNIM1gyeFUv?=
 =?utf-8?B?SXpaWjlyaG1yZ2JpYWNDSGlESjJ0cStPdHNIVVlQYWQ3YVZnTk9RZHFEU0U4?=
 =?utf-8?B?bDZzTldnbnIzQm54QjcxRGw0RXBVU2psZ3pyQjJIRTRLQk1MUkt3b0hYc2lw?=
 =?utf-8?B?M3YvZTV2ZUEwRWQ4MWNwZWhnWUZ4Y2ViQ0tWN3dFMXhNdHd2SGgyMFF3NmJr?=
 =?utf-8?B?WUthQTlMTEJibEZvUENhOW9DUlJ1OVp5YndZbEFLUVFSYXJSSEV6OVY5Wmxk?=
 =?utf-8?B?QWFLb0dlcFJCeXdtQTd2U0dCK2RnRVBqbGpuZzQwZmpJVmhvU0F6dnYzbC9E?=
 =?utf-8?B?cGtIU3ZNOFJrS1FNZU03S3YyZFpGU010RUhFbWswZGZheUhHRnh4L0NqMTgz?=
 =?utf-8?B?WFdLbkJhc0RuRytXZ21XNEJsMkZKaEt0djVaSUtkeE9XWWdqRngrRzRkOExV?=
 =?utf-8?B?Nm9XdTYvL2lZZitkcmZhMEQ3UlZKazkxVTdOQUV5M1RZUkxyOGpEZUprcURq?=
 =?utf-8?B?UTU0eEZlWE1pYmtLSk5rL1pVNCtIbzNQNlF6a09mdkZ6UlVKdGc0b0hQL1FF?=
 =?utf-8?B?cm9WQjFzMXhycmdiNDBsSFh3RkhrUnJnZ1plWU11TTNvdkhhNExRcWI5cEFR?=
 =?utf-8?B?SklqVzdpQW5mc3ZrRE9hWXpYMERsVGNHZXN2em9CMUpJcStrTG5jSnE1YVBV?=
 =?utf-8?B?VzVqeEl5cHdhcU82RGpuKzZ0NEJoSzArQVRReTNEdHQvdTR5WlptOWFWcHpL?=
 =?utf-8?B?cktKaGsxRWcyQWxTVXZGcEV1Unp2OS9HQmxnOG5WbEI5N0JJVlIyOEt0Y3BF?=
 =?utf-8?B?U0thM1V4S2s3dksySm01RzRTeWQ2U2hrcy9yY0pzNTlhMWIvTW5WbSszQXlj?=
 =?utf-8?B?bUo5ekh2OFNJWkJzenRzcjJxZFlPYlNBVFlmWVNFZ0RpRkZVcy9DRS93N1Ir?=
 =?utf-8?B?Um44MXBjV2xPM1pBbzdWZlBCb2poWWJzTUlSQk5RbUljT3lqcGlORUIrVzM0?=
 =?utf-8?B?cU1RclJ2STdRNnBSOTJGSDgvenVtaFRHNTBLSXdvak9DK1BoQ2Fyd2VmTmFy?=
 =?utf-8?B?SWY4MER6UlFIZkhzSWU2UlBMODlvOW9TWm9OOTEwcEZLOUFJenovdG9nZUhZ?=
 =?utf-8?B?djlJN011dU9Rc21hdVJyMSs0ZTRvb2tuVkVtOUQydlJLUVRkNlA3SGZDRWU3?=
 =?utf-8?B?S3V6N0lQS1kyRzVTNzdQdGdJVkdpMTEwb2dBKzhuSzdLK2drQzBTbzlIL1po?=
 =?utf-8?B?d292Z2Zjc2oxQUJYdUZ5Z1ZQL0owUU9XOGR2MkFFRnkxSlhDMStza3hiVXpQ?=
 =?utf-8?B?cDN3NWN6NmU1YUNrK3FVdGFTd1BITmw0SW5ORXhiY21VVnZ5OHJuY3QrYzZy?=
 =?utf-8?B?RkdyQXJWbGNPdU9xb1BqM1V5RGM1N21mMmRRajJkVmdQL1ErRUJZQzJqNkdL?=
 =?utf-8?B?c1B2VC9pbzZTZkJ2cFN1QmlhT05FWEYzY0pnQ1MwUGQzSmd0cTExdjBuMlBj?=
 =?utf-8?B?eXRjNUxZQ3JhbVM3WWFIMVBHM0R1VXA4M0EzMXBmLzRISWsybFRjT3dZTUMz?=
 =?utf-8?B?WVl1VnhuS2xHbHRRamptWGJFNjdvdC9LK2l3REVtWFFRZCsydkZveEhNZmhV?=
 =?utf-8?B?THBDL3F3KzZNeHhOZ2JjTDNjRXFvcG0za20zYUIvSndBTGVFKytQQjNEcmtG?=
 =?utf-8?B?dW1VTlpwbU1XUlRSS2Q5VE1BUFVLWUdDdG5lemRucEdFL0FOeHd0NWtxV2Rq?=
 =?utf-8?B?SjhDU1VSUm12Y3NMZld1cmhWQlJtYjc3NW5WWWc0OFZKM3QzQnI4VnArTlZI?=
 =?utf-8?B?clR5dkhib3kyTUhJemZ2d0lCZTByRkhPWkdoM2FCSCtxbnNQdVdiTjg1Yk9D?=
 =?utf-8?B?cU1GYUVXZnFTRFlKSzVlVndCNGJYaTd4eCs5d1hWUjROaXYxME90dTdGd2Nh?=
 =?utf-8?B?L1FrSnZTV0hVRWlVTHNlSXloc3ZIamQ1dmMyZEhSb1BWeW5lNlhjVDdpc0Jl?=
 =?utf-8?B?OVdpeGlVRTBNWFpjRUtOSHgrV2xLYUxPSUdKKytSY1lMNVdwalJ6UkEyMXNj?=
 =?utf-8?B?UFBHcFRzTThnU0lFd2lCUDN3TStjR3ovY1dPN3pzK2V2emhKK1EyRVhrbS9V?=
 =?utf-8?B?VndZKzl2NlpyME1LQzJFdzBlMFpNcWlDYWFEMDc0SGhoa243ZTdnYTVXVjcr?=
 =?utf-8?Q?JYKcFB4pV6Q0T9fX66VGrXE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 17597150-c72c-414d-1ff7-08db16814db3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 16:08:01.6046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Rh4q7DWXqs9Q2ROHq+QaYC4/T+KtjeD3M3MMRfQfKhd0oKuzSmNzBiGgCUogDds2+4RdOLVyC2Y03F+d1iiPzLqOgFTe5pEM8AIpHaaez4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8190
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 17 Feb 2023 18:42:27 +0200

> On Fri, Feb 17, 2023 at 04:01:15PM +0100, Alexander Lobakin wrote:
>>> +		++mib->cnt_ptr;
>>
>> Reason for the pre-increment? :)
> 
> because it's kool

:D The most common reason for it usually ._.

> 
> Somebody not that long ago suggested that pre-increment is "less resource consuming":
> https://patchwork.kernel.org/project/netdevbpf/patch/677a5e37aab97a4f992d35c41329733c5f3082fb.1675407169.git.daniel@makrotopia.org/#25197216
> 
> Of course, when pressed to explain more, he stopped responding.

Haha, classics.
It's not so common for people to show up back in the thread after you
ask them to show godbolt / asm code comparison.

Olek
