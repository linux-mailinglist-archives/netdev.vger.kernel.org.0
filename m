Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6EC5A8761
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 22:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiHaUPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 16:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbiHaUPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 16:15:16 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C72143E48
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 13:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661976915; x=1693512915;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vPL1lJfr1e29W1xz6kIoSYorWt2YjWeVpN5qwwr06wQ=;
  b=mtfgvzYqp37Vq7njyT1TgKjWr48RG7wK4K3e8fTWSZAijbbdSTGl3EGY
   a4Ywob50Cx6GY4hUem7pGpOaD+KUL0K0inDMUzXq3smxl3TiZ2+Bbx6EC
   GrYDkJlSctfU4rxX2IA/mHqtQzjbse4z3jl1Mh+q5OiQkpx0/x2enmPum
   LRbvH8c7cw/DRzzlVPQqzlput808tQ5DtKEnJwWsPIUpJiLj2PHp8fUhU
   ZAhVnidacFALl+MdUSH+aXakONYF6xCZpbqkD10xrG/6GkTMYiAgwZVd3
   i3CE6idSJPArV5W5ptOuccfoQZW9705A0DR6g/1QSVqXBo9oXeYbFcVd2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="296816546"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="296816546"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 13:15:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="738227153"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 31 Aug 2022 13:15:14 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 13:15:14 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 13:15:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 13:15:14 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 13:15:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dm1/2w4k38qQCEsSr4a7CSQ2PhfZeV1uO7o7WWqHGtxMwQ7xts1m4UI/RZRvTIzc01cd7TygGvy03k7OGnO/qBz4YXC90vLaBTtjvT73VXy/kdKh7eFZkMov0kuGMuDLoMnt7pNwOJh3XnzZTowlOViG6MzM5BMEnDTEPSFqVpzg4oXvFmWBhfNofsGLwNbZn3K1PI5KycSnY2cLUabSyuus0bTzpo/EeVVb4mZon/fy8VPEHgz0Xq0xgpVxf9A8lXcLarTfUNb9HYqYGCh0sNowAc9/LzeqJ/lrPR+bsjnf/GPfDKnTHPl+YjOzV7YZBopw4PjR0HCqvrfpKYfDJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=59UG5kikd8fAMyP2TwgAX9h5bW14L0PEKEtnhcgpO2Y=;
 b=gDkvuBGNTQY3bGw3itQUbBYSUxNUh6+RVNl3jPeDqlaKyjgSeobTAhp5I3MugorumAWFGFgKnVyXTUlbTTdUo4AViIqkuv671dSodcWDeXoZzTw5tfxhdd4vEbhVZgLyaridHKh3UuLPo3rlPNkfvUvc6VAkDMJhj2EueHbuIu18l80aQIEMcUjW/awhFOBPs0LF4iW/tBslyMDJFBnPYYcM6cJ4sQPw0wh5iraYK+1z9kCJU3kMMVmx2xR/9IR1OpcBQMV81llBPEkwjRfYtdibKcGOP6UnbCfY6yi9mtUGtfxF3tVoCSCh3DgwUjyKIbOKf1BMbpu7f7yf/mvw5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM5PR11MB1483.namprd11.prod.outlook.com (2603:10b6:4:e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Wed, 31 Aug 2022 20:15:07 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::295a:f0fd:ffeb:2115]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::295a:f0fd:ffeb:2115%4]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 20:15:07 +0000
Message-ID: <25286acf-a633-8b1e-95c1-9e3a93cd79ea@intel.com>
Date:   Wed, 31 Aug 2022 13:15:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Content-Language: en-US
To:     Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Andy Gospodarek <andy@greyhouse.net>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
 <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
 <20220825092957.26171986@kernel.org>
 <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825103027.53fed750@kernel.org>
 <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825133425.7bfb34e9@kernel.org>
 <bcdfe60a-0eb7-b1cf-15c8-5be7740716a1@intel.com>
 <20220825180107.38915c09@kernel.org>
 <9d962e38-1aa9-d0ed-261e-eb77c82b186b@intel.com>
 <20220826165711.015e7827@kernel.org>
 <b1c03626-1df1-e4e5-815e-f35c6346cbed@nvidia.com>
 <SA2PR11MB51005070A0E456D7DD169A1FD6769@SA2PR11MB5100.namprd11.prod.outlook.com>
 <b20f0964-42b7-53af-fe24-540d6cd011de@nvidia.com>
 <3f72e038-016d-8b1c-a215-243199bac033@intel.com>
 <26384052-86fa-dc29-51d8-f154a0a71561@intel.com>
 <20220830144451.64fb8ea8@kernel.org>
 <923e103e-b770-163b-f8b6-ff57305f8811@nvidia.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <923e103e-b770-163b-f8b6-ff57305f8811@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0067.namprd02.prod.outlook.com
 (2603:10b6:a03:54::44) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51cec99e-839b-4c27-54b7-08da8b8d7f68
X-MS-TrafficTypeDiagnostic: DM5PR11MB1483:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a62h7EfeDG/qLvLFAXSwFe8B2xxhqO2w4wJvkPe0kLeGr7s2xiH5nArwe1F0TVAxIBxqiaUushyE7Y8zU6d5E6Mu1LrAtWXpRKzCVoDOsxzWxyEwir0nxGoaOhZRlWsmRctZSqRBMAmvf+uiiwxyvwdKzz7Ar4HYgkkhqOh0+IQH91JVXB+g1venvJiEkuGxmBxJgFIMLoeQjuQhCuFNRlvoPO4AsWXBk0G8+Hlxy9F7z9j0Rmajlfx/dDOnkWH9OblJHM6W4bLh/QpwPwmbUpGIBWK7tCDB1KHcKPzSylghf63Rgn0m9gYHwZ481dhCtSqfRL1rOQC2KSt56sfzN7i5LdBDOl5qsDKHUsZFme9GdjiwNnNgo9f7rxsf7YI+nNPAO7NQTNdxAZRKbk4DmgdCS2sRF2wS0FP4+p8Wi5jb58dHOUm27N0xrpRyT5xnfB+/Fa7EleoXhkI4e9++Dv+4Xv80muj63lks1FOC9vWPjIOOQ4fpa0EF8JQl7jKm88Jz/D6Xe9M5QpLJ9uCJ/qVOM8mc4VEfhhfmUXCEhhUIqra9D4UrAC9TgwSBvE4DhsTgbg8tabbYy3JgVxxVsCH6ZvbD6McDd5rgnVJI1tgSzSIfqiZjOZ0q9+kr+VStooylyb4iWzxUa9syHWmC0Hb0a+Nq0xC0ztWamtt19VFvCgDCbcX+p4NeprIog4FyZIpBAK6JcVau74ff3AtXm9jrdKOkYId+L5tEo6wUseoIWBY8yyKjIaqyU5fKnjJ295sMlJf39l8QG5cVigGfdAJr+C7D8NTwfPzqu7EPjjY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(136003)(346002)(366004)(396003)(6512007)(31696002)(86362001)(53546011)(6506007)(478600001)(6486002)(41300700001)(26005)(38100700002)(82960400001)(186003)(83380400001)(6666004)(66476007)(4326008)(5660300002)(2616005)(66946007)(66556008)(110136005)(8676002)(54906003)(8936002)(2906002)(316002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1VuOTFNUlFkNXRkdVhmT3lVTjQyNTRwWU9EeVM5cFYxK0NyNit2Z0ZVeERa?=
 =?utf-8?B?ZTBsd1A1cVY0Q0tqY0tXdit6WVluK2grTGVnV2h2VTlKQXlmeEhHbHBFM3N3?=
 =?utf-8?B?ZkdkVWZjZTNaWUpWbFlYUWVWZ0hvQmRNSEx3NkxWME9QdmdwZnNmSHZSUHND?=
 =?utf-8?B?bGEzSHBicDV4aVVLQVlTbjMrU3lNMlVNR1o5a3ZjRjdoeGtGSWc2NC95QStz?=
 =?utf-8?B?Ri9sM0F2eWlrM3RMMVJidklwYi80emFzVnU3ZDVBbnRKVVM4N2V0YkIrVU42?=
 =?utf-8?B?amxlQ0ZpTE81bzVuQTY0TGZGRXpSZElZT3JRVW04TFNWSUFta0hhZWdGbmh2?=
 =?utf-8?B?aERJOWFWSHZaZG1PVTRtRWF4V0xjb0Q1MGVncStJdlEveTMxQUNTNndIa1ZN?=
 =?utf-8?B?TEpicEp4cXI0dVJldGE5a2R3WEpoekNrT2YrdjJHVXRSckdHVzlTRmJjdEo2?=
 =?utf-8?B?eFpXbk9PTUZvdEsrSGdBT2hka2gvMHFTbXhWWTVRaWZ6c2p0c0hwYmdkWUhQ?=
 =?utf-8?B?UkU2NzRnZytFOUxJd0M2QnZvdG1nUVNGTkQrM3QxTjVWd1cwUU1qbmwrdUcy?=
 =?utf-8?B?MldKQmNqVWlDYnpWQmhZOU5na1ZFMDZVUkVTSGRWK3h0Wms3Ui9RL0hROEtu?=
 =?utf-8?B?M3ZVNEEwd3VFTU1JOWlibzVtVWFZQmlzdkNTTkplZjgvMG56ajlpUVBZVEw5?=
 =?utf-8?B?YnJXdnlUUnFVcDlVRzVXb1FHb2hWUk1jQXk1UUEyZHBJNlhFa1ZMWGRnZnZt?=
 =?utf-8?B?TDhDeVlyWDIrM3J5QXFlQ3JtK2JBblFCNnhVNlF0Vm9BTTlOYkdKb3UzbTJU?=
 =?utf-8?B?a1c4OUVXQzZlWktDdXZrUFQxR21mRHNlalppbkczT1I0czhON3Q4SkdSSnli?=
 =?utf-8?B?NEN5VEZrYnYwWHYzYm9vdTcyK3JLekpPVDhZZVB1MzRURTRnOUMxa3pZTnB5?=
 =?utf-8?B?eUYvTDJhVjRRSGhaL2NNRGJHNzVyaVJUSTJiRGQ1NHZuZytkckZsWXNFR2Rl?=
 =?utf-8?B?QnBwdXhPWitJbHZYUEljVE1kWWVaMmZBcGJYNHNubEx1ODhGQXVZRW9oSHhG?=
 =?utf-8?B?RDNVczJ0MmszL0wyeUxWVzN1M0JXbFZRVGtlYzViWVYwU0M3WkI0QmFiUmQ1?=
 =?utf-8?B?NXd6cDR6SzQyNVhJZ21OczdmdU9WL0EvQ2hGWFJuYi83dmVaRnVIcWphbVg0?=
 =?utf-8?B?RjcyNVV1NWRlUXFpb3lBZTlBdG50clhockRoV0VPUjhIODlPd3owZGFxYWpT?=
 =?utf-8?B?dFZsV0c2U090ZVF4LzBiVUYwN1phS2ViQm9XbmMzb0pmcWdBSlMvOEswM0hw?=
 =?utf-8?B?RzI5OCtGVHU1V2pRbVArZ3hBdjhENWhYcVB5TDFwZEJEN2RiUzBzRUNnQUpo?=
 =?utf-8?B?TDBRZFhvOFNTYURaNjh0Qy9pQjI4eGJObHo4Z0NRUURKVWtsUW14bDRISFZu?=
 =?utf-8?B?RUdyaXpTYjRKdmo1eFVqb0dKUW9zUzFLZGdkSXM0TDFVWWdvMHVBdHh2cEM0?=
 =?utf-8?B?VnhJUWhhN2trQitDM3pVVTY5dDRYbHY1a1FmOHp6VDhneEFQZllqODhKNXZy?=
 =?utf-8?B?emJGY2lISUp6S1RzaHRidXZLckZlUFUydDBIS0NaSnd4RVRueEZQQjdOVVN3?=
 =?utf-8?B?elRRNkVjYUxzSThka2NsYmlZTHZ5V0ZWeDZKOGNyMWlMVUF3dVdzU1oyY0dh?=
 =?utf-8?B?dUIvZFVJcTh1Q2lITVV4cm1Ha3J1cHNFMGlJeFpFOTF4cDYzL2ZrZVdtRGo0?=
 =?utf-8?B?NnNDVHMyUXR3SHpybjB3VjlaMU9nV0V2NFBpNGtzVTNBZ1gvQkJUdGtFTDNS?=
 =?utf-8?B?VkFLcEpaZUJESk5NZlczY0ZoT1YvcytXQ1NhaW9QNlV5ZVFNbDVubjkrZUNx?=
 =?utf-8?B?bVB4TE1pUDVJelNYcVg2WHNtbDJYRzB0YkE3TERyVEhySlE1dUQ3RVp3VlRO?=
 =?utf-8?B?ZUtYR3o0NXJPbmREeUN3TVZLQUxsSlpGa0Z5TkpQM0duUlFJTjZqQWxhOXJ2?=
 =?utf-8?B?S3BCZ1dWbDhWdnpVU2xUWlJkWHZXT0pCQTYwQjRFKytDL1RZenBaNUpJNk1w?=
 =?utf-8?B?bHRZQjA5WkdOVG5BNzZaQWNQK1ZtRVNleVVzZ1czV0hZK3M5ZGF4OUhWVFVH?=
 =?utf-8?B?dENhTWs5VWVmNjByM3ByNmYxVCthSHZ0ZDVQcHhJNFJSOGpFTUVDTjNYam5p?=
 =?utf-8?B?amc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 51cec99e-839b-4c27-54b7-08da8b8d7f68
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 20:15:07.1633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3PCYCc6NybIzaVBAtizd8HmrydmMphlkIkqI5wZgOgJ1wPgBqf01Rqh2BYiiMvEoyRCIw8AS8MrCb4Y3HUkN0ZLzJg1uohL7NeHZUjdF0yA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1483
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/31/2022 4:01 AM, Gal Pressman wrote:
> On 31/08/2022 00:44, Jakub Kicinski wrote:
>> On Tue, 30 Aug 2022 13:09:20 -0700 Jacob Keller wrote:
>>> Gal seems against extending uAPI to indicate or support "ignore spec".
>>> To be properly correct that would mean changing ice to stop setting the
>>> AUTO_FEC flag. As explained above, I believe this will lead to breakage
>>> in situations where we used to link and function properly.
>> Stop setting the AUTO_FEC flag or start using a new standard compliant
>> AUTO flag?
>>
>> Gal, within the spec do you iterate over modes or pick one mode somehow
>> (the spec gives a set, AFAICT)?
>> When autoneg is enabled (and auto fec enabled), auto negotiation is done
> from the link modes according to spec.


This is the same for ice, except that the ETHTOOL_FEC_* configuration is
 ignored. The documentation indicates its only intended for when
autonegotiation is disabled.

> When autoneg is disabled (and auto fec enabled), the firmware chooses
> one of the supported modes according to the spec. As far as I
> understand, it doesn't try anything, just picks a supported mode.
> 

This is how ice works if we don't set the ICE_AQC_PHY_EN_FEC_AUTO flag
when configuring our firmware.

> This whole thing revolves around customers who don't use auto
> negotiation, but it sounds like ice is still trying to do auto
> negotiation for fec under the hood.

It's not really auto negotiation as it is more like auto-retry, its a
simple state machine that iterates through a series of possible
configurations. The goal being to reduce cognitive burden on users and
just try to establish link.

I believe that sigh ICE_AQC_PHY_EN_FEC_AUTO set, we still try different
media type settings but only one FEC mode. The exact way it picks such a
FEC mode is unclear to me in this case. With ICE_AQC_PHY_EN_FEC_AUTO,
each media type is re-tried with each FEC mode that is theoretically
possible even if its not in spec.

> Looking at the reasons Jacob listed here (unspec switches/modules), it
> seems like all this can be resolved by simply setting the fec mode
> explicitly, and to me it sounds like a reasonable solution for these
> special cases.
