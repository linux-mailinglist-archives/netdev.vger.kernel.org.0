Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D4C5E813F
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 20:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbiIWSAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 14:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbiIWSAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 14:00:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859B22F3B2;
        Fri, 23 Sep 2022 11:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663956000; x=1695492000;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jsYaMD1MTMA9H9Grn9lWeiSjQdKBMANmn3WqLhTNZHI=;
  b=ericfapt9hRLJQV4GC92XuLFy3BB0jcSCw84xQDVhdAeKWW8UInA2JWl
   zlXGgXC9W5AUvAGcExYY1+ANUhU9EBSNDB9i0p8eluqbg3+VPrZMXq/1h
   rZzNqMBmlOb0gFbJrD/osrfPxlvDn/raUVjeeE4mk5nYlppHj5jrfgdrZ
   ZJXIbYKGYcxEpqHTGXTq4Dnrf0vGkiMIGhDAuU1ebYoa/KLN1e9a9E6IH
   mWyNRvbj//XcZ1yt1aNlda1rXGGf1SVBNQiHsxMoc2lyhrmcy0/Nn4fKc
   fvudfPhoT30wwbdD2W6EfNRcpiU+Cqn/qN4/HRCDdUKI0cRYnW5Y4379A
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10479"; a="280377411"
X-IronPort-AV: E=Sophos;i="5.93,339,1654585200"; 
   d="scan'208";a="280377411"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 10:59:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,339,1654585200"; 
   d="scan'208";a="865380314"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 23 Sep 2022 10:59:44 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 10:59:43 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 10:59:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 23 Sep 2022 10:59:40 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 23 Sep 2022 10:59:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiAu75+aaQHGXHJlx5FgqjTRBhyiQDtxtJmtRPuu6kD7Y1nlCSZQvL8eMR4ctJv4UPU/y+0ZJuw8pHUxrfe0r6DYDmG1LPa1OmwyS/9iZJVcN1tmjSQ8q5oTXJx12T2DX9575X6mcxfkAhSYvzE3NZoc48qsqOSoLqtBWCMigYShJJ6oElLXVE53axb7WuYZ+Az97fRXZvJSzpFHY0cpfEKHcAV/iRErwWXun4mLzY1004Pz+SgX40jr6cmNtKXGpnbMZYPkRLXqwzmGNDvp5tmyY0TL+kgJzkOHjVy30udRBe0p0uvw/k/HesBCEIj19PdskmhlT06CJqy9kSrtrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1BEK00v0nF3WLpiZupqhzFuQtGdiS15bKVOoyHzzcTw=;
 b=DFjWE7F927wExSZs61AHbOxQAKOrpxwhuky6jEDE8rR+NZTw2a588Jua8Ngedd9lfPwaglmJJms5EG7kyzAVB0kZVNxQodYcYLEUBm/R3DfHDrg9Ei+i9DBjtQAl58y3itL5lkZKIHDg8rfZm+o/VfKEYvjrr0KOJCKuengkOo1YqBAaFWSkXBSfZ2UU0Soz93K/PhzjVRjpG4y+M/3ubz03KKdK8Q8ednWhA1wOQxDAEhdZ/19EY82CB07jzpXA8IyOMPtYpksxyMZEV4Cf2CV07vtUKOODLKHEXFPD1bKXQHVHs4BJCHozueSamH634P07keqWL6/27vTfVkoe/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by MW3PR11MB4586.namprd11.prod.outlook.com (2603:10b6:303:5e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 17:59:38 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::e82e:c89f:d355:5101]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::e82e:c89f:d355:5101%6]) with mapi id 15.20.5654.020; Fri, 23 Sep 2022
 17:59:38 +0000
Message-ID: <01fa5b0f-d209-6eb5-9911-b7522eb491d6@intel.com>
Date:   Fri, 23 Sep 2022 10:59:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [Intel-wired-lan] [PATCH] ixgbe: Use kmap_local_page in
 ixgbe_check_lbtest_frame()
Content-Language: en-US
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Ira Weiny <ira.weiny@intel.com>
CC:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
References: <20220629085836.18042-1-fmdefrancesco@gmail.com>
 <CAKgT0Uf1o+i0qKf7J_xqC3SACRFhiYqyhBeQydgUafB5uFkAvg@mail.gmail.com>
 <22aa8568-7f6e-605e-7219-325795b218b7@intel.com>
 <27280395.gRfpFWEtPU@localhost.localdomain>
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <27280395.gRfpFWEtPU@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0028.namprd08.prod.outlook.com
 (2603:10b6:a03:100::41) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|MW3PR11MB4586:EE_
X-MS-Office365-Filtering-Correlation-Id: 8205854c-df68-4e94-fb86-08da9d8d61d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: itJzJwxB4xp1eT0nH/s76CtOZ/Ck7asCZZVs9xxg2/VJakVirMYoelQ7rOrcNW9jQJJR4nViFDyMgpCVlYPUPZ6YzDzY0q0hZpLPCzupDHXZmK5TMFCxrJGEs3W9i4oj/fCCWV5rSShg6oMFITA2+4dyPmEw0uMQYtMoNeWlepK9rekvG5gvQ26YPI9atkmXk+50qgE3r7zXXdEUi+CrGADSvz8ZHGaxV7sZ48IGsuq1X//E0od4DTxEgqXQwCzqtuvt3yVbD8iEWhb996mVVSCW0rcJA0m5qIpZpsgu+7um4bSeYRelwq8EPmdYIFCZgBruCuZ9ZVZOGtuMNy15rsr/Xco4YsAE4jU0tTDtAMP3hfQdg/jSA15gDU9lZMkrBMtXP/Tl8/iRBVwJqYoKAkxAuXS7WiS3/yhBS8EEw/N7DQ+p1lgYH+cWyFujySnvE8qJBp9A0rCZ4LFeZRgWdPzbBarmOIrnVgOVXiXOVY0KUZUo4sy5iY/LbxgorQHd5h/GS5z9vpeMGhTqzq73oqRCKWn9xvmbhwOSrAJkP5PXViyT6bvze7CEVoNnjeRsuZ/djBnA5LKnS89JXPWmz7Dvh5DxBcZdVthWudjPxYaKA5FHIuZ0v1KIG7h+sX6Z3KnLoRJh4TfZKr7GF6fNo5AigVQKeez5Z6Ri4IFKhlBZZG3g4W7laOMB1x0Lnk8dGFVGc+lH7xCauebCg6RvSK+l2BbWP8OsBHgCbERrQj+4luH/xsUhlO9qWTaHquLIzgjwdqC4xUj5VUB3weaH4BSeRzY1xUS2VjX+H8ouEcjOWMCLIzzSAfn+XtBoHQzwN94VXSQ7RaLBbCcWYhLtG6V9Df2huk+O4SxoRzPiDX8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(366004)(346002)(136003)(451199015)(316002)(6486002)(7416002)(478600001)(44832011)(86362001)(36756003)(31696002)(5660300002)(966005)(8676002)(4326008)(41300700001)(66556008)(66476007)(6636002)(8936002)(66946007)(110136005)(54906003)(6666004)(82960400001)(38100700002)(107886003)(6506007)(26005)(2616005)(53546011)(186003)(83380400001)(6512007)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wm1VQU1MNVpacys3Vm85eHFDYjJ3TnhiSElFY1F3SzJqR3Z1NDMxL1JMZElp?=
 =?utf-8?B?U0VKOXhKeTdCQW82dDVIclNrNnAyLzBEWG9ZeDNvVHUzUVFaRTJIOHQ4NE5y?=
 =?utf-8?B?ZnVRbzFsMFJBaVpHU2lqd2l0Q0JsdWI1cWVOMW5SOXhwTG00SkZlOEIrSUpk?=
 =?utf-8?B?RWZMS3B1UFRZYVV6MFo5bi9nQWd5NWNKUnF5T1JWK0tydEdGT1BGY0VnbmJP?=
 =?utf-8?B?YmorUGhiK0ZwRWd2N3QvcFA4dXdDMkRxOWowLzNCcUY3VWZnZFBJS1gwTE42?=
 =?utf-8?B?eU9HbVFOc3JMMzV1a2tRL0NsZldzSDZ4b3lnK3JDekR1c1hLQWFEQmVQeUlo?=
 =?utf-8?B?NjBiVkg3NmVmNldJMWx4NTZ0aFlZNGhyMDdRekUxcDFBdGNxdFdNeUFkMldv?=
 =?utf-8?B?cEpKN3JDRVZleXNaOEkxMndiNVhqSXBsanBtUkpxT01UdTVjMzhrblNtcmFX?=
 =?utf-8?B?ZTFXV0RlMy9ZNjh1UjRsZlNlRDV5WklhempQNWxWVy8xOE53bDhzUWdWNGZu?=
 =?utf-8?B?amU2RUV1WEVDQXU0eGI2bThackF0bk5iVVJOc3JhSitYQmt0NUJRWFBTbjFT?=
 =?utf-8?B?bjRjTlZjeXBLTllOSjVmSENvdDlIazFBSjFaMjgxSnM2VkVoZy84VUIrUzFN?=
 =?utf-8?B?T04zUkVrcTc4c0VzL2lnQWNoNnRjNjh0N0tPL1JrNU5xQ0ZVODN2QTZIeHp0?=
 =?utf-8?B?OEllakxXRFhON1E3a2ZyWHdBeHp3RnVlZjY2VFBXWUlEWU5FMGJ0ckFnQlVP?=
 =?utf-8?B?Sko5RmN5cDREWE5lZWpacEdUSHBUTm5zZVZuSkN3UFQ5ZEJwemRnbmZ2Yzlh?=
 =?utf-8?B?ekUzYU5qM2NseTU5YkZUVDRpL2NQa08vYUJnaU1Qa2pEUEtpMkdsK28xbkNq?=
 =?utf-8?B?aXhEVG4vK0lYMkdzWmtkTEFMUjIrMmF5b0tmL2cvd2FIaGpNNDRnMUtVbWJC?=
 =?utf-8?B?eUZ2LzY5L25zQVJwZHhxczJObVBUdFYxZWlmMTY5NWZqOHpiZ3NiZngvRXR1?=
 =?utf-8?B?YTZWTEJvMndUZGdldENIeFFyanU0TmZHQ0cvbmVlYmJSYWVRaXR3NHVUZ2k1?=
 =?utf-8?B?eEJCUUdwLy9LWTkraUVPbWlCeFdRSWc2UzhhejhhTjVzMkFkdzh0ZWwzL09U?=
 =?utf-8?B?MkQxWUkwYmFFMWxwNjE5YWZSMWpobjlDNFBqZitIdzBYWjhsUGlnVHVZQTRK?=
 =?utf-8?B?TjN2NzQ5cVVBTHFFR2h3bHEwTUVRN3BNcklBWmVkc0owVnhqQ296QUNlSFF1?=
 =?utf-8?B?RDY0OGJVTHdhaXI1clpCMTR3YjRXc0wza3FnTXJpb0dZQURUdU4ydm10Vmt0?=
 =?utf-8?B?MklvekJNZHN5UFIrTC95Y2pwSHRZUFo2cTdmTENGcGxQZFluenJyV0VuTlJL?=
 =?utf-8?B?SjFOWGh4N0FhWXljSjFWeXQ5N1lJM29ScVlOUGZabkdaaDZTV25qS2tyRUFQ?=
 =?utf-8?B?R2RuRDhnMkFwZUVsd1hrbDJyTElaTlJFNUc3TkFrUFU5eHpqbTZkenU3VXEr?=
 =?utf-8?B?a04zYjBsMVRTT2dOZkxzSEZFaUFVUWR3SXljcWtCMzh6d2V3S1V4ZUNETjVL?=
 =?utf-8?B?OFMwRlVvWWRtN3JVNnVocFZEME1Ua2dOb3pIRkVQMEFiRVh2eGFIRHg5T1RB?=
 =?utf-8?B?c1FVZnN2RFEvR1lOMlFIR2xFM0UzbnpTV0tYK0VrRmZmQ1hhOXB4eTRtQUs5?=
 =?utf-8?B?WVQrSlNCUGlYZVQ4eGJzYkhrMklMUVI2MWJvYzZXaHlTdzE1Rjl0UkJoVHJG?=
 =?utf-8?B?ZWZCV0t0RmVDcHZUS2U0dVJNdmtrbmxpR0tvbFVXTWJFc3l4UE93QzNPcnR4?=
 =?utf-8?B?VzN3ZFRQaCszMGxTUUJWWjAzS1JtU1VDNHBJRkRpdXQ1VmtZYU1pUGM0OSt6?=
 =?utf-8?B?bW1FYStFWTNzUDJiME1ocTJQZ0hKNVVXemJyWVIxSFpDMk4yRnUxaFBpYit2?=
 =?utf-8?B?emhyZjdjQnFjSWNPcW9pOFFsN3VsR2xtbCtMSGhOakQwRE1kMU53OEg5NEpW?=
 =?utf-8?B?Z2ExNnh2NWJaTUJ4SmxxeExsWXZyM2RoMEpYb3Bqem5QYmk3Q3I2emNHbHlh?=
 =?utf-8?B?S01XV2ZCS0hyWjdKWWFBKzJMenhoVWZicGc3SnVEZzFGTjR4NHRjTFdhQ0dU?=
 =?utf-8?B?MDJ1aHdvcHVGUTZaVXY1b1BVMnpmVlVuRk5PVUNTZWpMVHJ6V3ZrRGpYZUpj?=
 =?utf-8?Q?UvSW4Q2vtASdsUQMzzSmEWQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8205854c-df68-4e94-fb86-08da9d8d61d9
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 17:59:38.5533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7erSR0BgLSrgQ4zcbLj+mpuXJ+ptN3sWwKx1gdYNBil7r0S44vh0HDGZDKJOEVSbknnkCMovY58KQIyX/bFFhqVftSEt0G1zaisEwLrLfdCMyu/Ots2keSWUxa//NOB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4586
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/2022 8:05 AM, Fabio M. De Francesco wrote:
> Hi Anirudh,
> 
> On Friday, September 23, 2022 12:38:02 AM CEST Anirudh Venkataramanan wrote:
>> On 9/22/2022 1:58 PM, Alexander Duyck wrote:
>>> On Thu, Sep 22, 2022 at 1:07 PM Anirudh Venkataramanan
>>> <anirudh.venkataramanan@intel.com> wrote:
>>>>
>>>>
>>>> Following Fabio's patches, I made similar changes for e1000/e1000e and
>>>> submitted them to IWL [1].
> 
> I saw your patches and they look good to me. I might comment and probably
> review them, however I prefer to wait for Ira to do that. Furthermore, looking
> again at your patches made me recall that I need to talk with him about
> something that is only indirectly related with you work.
> 
> Please don't rely on older patches of mine as models for your next patches. In
> the last months I changed many things in the way I handle the removal of
> kmap() in favour of a plain page_address() or decide to convert to
> kmap_local_page(). Obviously I'm talking about pages which cannot come from
> ZONE_HIGHMEM.
> 
>>>> Yesterday, Ira Weiny pointed me to some feedback from Dave Hansen on the
>>>> use of page_address() [2]. My understanding of this feedback is that
>>>> it's safer to use kmap_local_page() instead of page_address(), because
>>>> you don't always know how the underlying page was allocated.
> 
> Your understanding of Dave's message is absolutely correct.
> 
>>>> This approach (of using kmap_local_page() instead of page_address())
>>>> makes sense to me. Any reason not to go this way?
> 
>>>> [1]
>>>>
>>>> https://patchwork.ozlabs.org/project/intel-wired-lan/patch/
> 20220919180949.388785-1-anirudh.venkataramanan@intel.com/
>>>>
>>>> https://patchwork.ozlabs.org/project/intel-wired-lan/patch/
> 20220919180949.388785-2-anirudh.venkataramanan@intel.com/
>>>>
>>>> [2]
>>>> https://lore.kernel.org/lkml/5d667258-b58b-3d28-3609-e7914c99b31b@intel.com/
>>>>
>>>> Ani
>>>
>>> For the two patches you referenced the driver is the one allocating
>>> the pages. So in such a case the page_address should be acceptable.
>>> Specifically we are falling into alloc_page(GFP_ATOMIC) which should
>>> fall into the first case that Dave Hansen called out.
>>
>> Right. However, I did run into a case in the chelsio inline crypto
>> driver where it seems like the pages are allocated outside the driver.
>> In such cases, kmap_local_page() would be the right approach, as the
>> driver can't make assumptions on how the page was allocated.
> 
> The mere fact that we are still discussing this particular topic is my only
> fault. I mean that the guidelines about what to do with ZONE_NORMAL or lower
> pages is not enough clear. I'll have to improve that paragraph.
> 
> For now let me tell you what I'm doing whenever I have to decide between a
> conversion  from kmap{,_atomic}() to kmap_local_page() or a kmap() removal  in
> favour of page_address() use.
> 
>> ... and this makes me wonder why not just use kmap_local_page() even in
>> cases where the page allocation was done in the driver. IMO, this is
>> simpler because
>>
>> a) you don't have to care how a page was allocated. kmap_local_page()
>> will create a temporary mapping if required, if not it just becomes a
>> wrapper to page_address().
>>
>> b) should a future patch change the allocation to be from highmem, you
>> don't have to change a bunch of page_address() calls to be
>> kmap_local_page().
> 
> "a" and "b" are good arguments with sound logic. However there are a couple of
> cases that you are not yet considering.
> 
> As my main rule I prefer the use of kmap_local_page() whenever tracking if
> pages can't come from Highmem is complex, especially when allocation is
> performed in other translation units of the same driver or, worse, pages come
> from different subsystems.
> 
> Instead, I don't like to use kmap_local_page() when the allocation is in the
> same function and you see immediately that it cannot come from ZONE_HIGHMEM.
> 
> Sometimes it's so clear that using kmap_local_page() looks silly to me :-)
> For example...
> 
> void *silly_alloc_and_map() {
>           	struct *page;
> 	
> 	page = alloc_page(GFP_KERNEL);
> 	return kmap_local_page(page);
> }
> 
> In this case you know without any effort that the page cannot come from
> ZONE_HIGHMEM. Therefore, why bother with mapping and unmapping (and perhaps
> write a function for unmapping).

That's fair. When I suggested using kmap_local_page() even for 
driver-local page allocations, I was thinking of situations where the 
page allocation and mapping/access happen in different functions in the 
same driver. Not that these are impossible to trace, just takes some 
more time and effort.

> 
> While working on the removals or the conversions of kmap(), I noticed that
> people tend to forget to call kunmap(). We have a limited amount of kmap()
> slots. If the mapping space is fully utilized we'll have the next slot
> available only after reboot or unloading and reloading a module.
> 
> If I recall correctly, with kmap_local_page() we can map a maximum of 16 pages
> per task_struct. Therefore, limits are everywhere and people tend to leak
> resources.
> 
> To summarize: whenever allocation is easily trackable, and pages cannot come
> from ZONE_HIGHMEM, I prefer page_address().

How would you define "easily track-able"? Does it make more sense to 
instead say "if page allocation is module-local and can't come from 
highmem, then use page_address()".

> 
> Honestly, if code is well designed I don't care whether or not within 5 days
> or 10 years decide to change the allocation. I think it's like to refrain from
> deleting unreachable code, variables, partially implemented functions, and so
> on just because one day someone may think to make something useful from those
> things.

(a) is the primary reason to use kmap_local_page(). (b) is a co-traveler.

> 
> Greg K-H taught me that I must see the code as is now and don't speculate
> about possible future scenarios. I agree with him in full :-)
> 
> Very different case where I _need_ page_address() are due to the strict rules
> of nesting mapping and unmapping-mapping. I recall that I spent days on a
> function in Btrfs because I could not map and unmap with the usual Last In -
> First Out (LIFO) rule.

Right, so maybe instead of me saying "use kmap_local_page() everywhere" 
I should have said "kmap_local_page() should be preferred where possible".

To summarize, how about this for a guideline?

- For module-local page allocations that can't come from highmem, using 
page_address() is acceptable.

- For pages that are allocated outside the module but passed to the 
module, use the appropriate kmap() function.

Ani
