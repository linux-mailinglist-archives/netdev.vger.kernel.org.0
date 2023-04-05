Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC266D7DC0
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 15:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237738AbjDENbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 09:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238246AbjDENbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 09:31:11 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E031D30F3
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 06:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680701470; x=1712237470;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ChVNQixmxtSbPuW0ZvCalit+g4iTtJab+N8tI/eEH54=;
  b=gcayGzR+1fPZAs2hx5l3Nbd3wVA+RNdQML0Ui7FGh7hkU52a2HVPnZCO
   9oty+ZxQVfhtYlJ1gHgmMUHAUzNLD4xr4G2kq8/v/G++YsB2trS6gADE2
   iekk0KCMK0jh+gzXCwouqjuOxZ2LYTLAAYfITAMwL0WX6D43XXmtx4BoC
   kWCoOfedcfdtJnOy8boK3Fsaagv1Bl2Wbr/VpsrWT00ZP7op1ZgwT/PKi
   j5J0Se8ofDjoV/BU4WC21UAxAUGUvQTbYwP5kxvrQzFra5IHyntU6nc+T
   rUS7at52mJDQzkE6P11EN3mRS0YAf4qvDajiV57DydZE/lNnKxmbbWqSl
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="342468150"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="342468150"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 06:31:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="830363534"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="830363534"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 05 Apr 2023 06:31:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 06:31:09 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 06:31:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 06:31:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 06:31:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BixDqn++VXZtMIodLu8Hh9sa78Ipj1esNQPNMbhMOfU4FeRZQhFD+RJ6y5Ygdet1kVedU4CQmAF6A0wWPu5n2dxWvLK38cwtwhFcCrOAm+vUfKDze+yMpZyArnYjsHcimo/yhyZ16rt00zwr2PCMvUnHRH6uJCnLxlO0mRlIWcksvtYyjRJ5JPvs7iaMWI2eNO3nzHxN+EHKt/j5aH79bBJJhPcVj3bGTtwwQIlRYYi8b0iLFEAIgLqXSoevG9XOYcYiP85YfGwRpM+UnGYvzSL7R3MB6RukRCjXXDiUT4Nb7Syv3a4si0pkjeBCzmzhbOG2PNOEMYv/ksdURQXB5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqpqMEVdzdQOkHcOCJYXkJCB1e6UHrhDSnCynyr8odU=;
 b=KPMmT9Mia5rs1ECeqf3w8chU4P7elv0n5hhITi8/q6SUVIsNQVp7ub3M27XmABV1gVB7tj0UbAZ+W9EtuSBG2e11+WPuHnRl1S2sEgfg8OZVrlRJsz+75alW+jU0lSu7uZiyNX/vn/SiWoRwPoZ7dXMlijByXU+QwVoA5/L5WG91VI65XTbTMBfXYI/TR5kpL4H4BhXN8+0WDqa8As8K+l2lIojmt9vSiCbqkjgm6xSey4sIzmkttHoApH76lydxmxYkcRUwhlk0zaN9atpMxEbgxAJp2eTGBrzc9sR2LYQ71HNqLshkAFHhsWVzkqKS1OvHzVYd7xYjAd3X+6FRXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH0PR11MB5208.namprd11.prod.outlook.com (2603:10b6:510:3b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 13:31:07 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 13:31:07 +0000
Message-ID: <8559d4df-71a8-8d4f-b2f6-91f69281f2d9@intel.com>
Date:   Wed, 5 Apr 2023 15:31:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v3 3/5] ice: allow matching on meta data
Content-Language: en-US
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <wojciech.drewek@intel.com>, <piotr.raczynski@intel.com>,
        <pmenzel@molgen.mpg.de>
References: <20230405075113.455662-1-michal.swiatkowski@linux.intel.com>
 <20230405075113.455662-4-michal.swiatkowski@linux.intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230405075113.455662-4-michal.swiatkowski@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0161.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::8) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH0PR11MB5208:EE_
X-MS-Office365-Filtering-Correlation-Id: 038f7197-0d6c-48ff-9a26-08db35da02ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NQ0dkqUb51t8/dYgaGLAqRSXH/f8aUtxy+PKPnTxhNtEsiYdbX2YlHhcKRE1Jah5W2DQyPn5MB5iSUPKHeHms8SxI9Q2EN2XPO4p47psckpmQ9JLC44JDtC3bP4cu+quS40/MKv4pJBs13ttAVaL7jjjpQWjwa5vRJz3VVmYdLR2VheNpBa5PqynIE/QBddKrBjB9nlnuetRXcQNmQz29/oObT/L7eNFuuxE8HI+XJF/3LBDgmAXsuxzeKsgMMeI2FIudCyhIeQRAewEYclnggcp9oD9WY8gE2DpsAnDoZTj+Ps1782bi4vQjjuL+9PDQgkq/yoT1R5FVafHsKeL0F4r1Hbii42hGVPMfMYAUSXzQBq0+3onvN7zJWr3wJzsqs8JvvXgXH26LWs5n1wxq6QmqLdhmO5G3VtXglqJF/NhVAsPp9O2kXt4Lpd8KoUUX3QKcEg3lE/DCmvhr+WQ1PweedINE5GFQt1G1mb/FziWGsC+sxoE50vDmMcyVcu0eEH+pou2g3yCfqSMp6geJqVuSxlmvuXoOENVZPnvXLCewgGl48VcStJb4PJDO+AsAbV5+/xb9Pmp6e6n1Lj4mKPur19pPUbJAfmjRRZSSV/pobR5TvjQ8ip6KTpQWwc2WzysQNrXpCNNhoIEt9lxFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199021)(6666004)(186003)(26005)(66946007)(8676002)(6512007)(478600001)(41300700001)(2616005)(6506007)(316002)(4326008)(6916009)(82960400001)(66476007)(66556008)(6486002)(38100700002)(36756003)(31696002)(86362001)(5660300002)(2906002)(8936002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzVKK1ZqUlZWK0FTUDZBbnhpQzBLazh2UHdycHUwYm1XR0d3bXUzZlJ6TURY?=
 =?utf-8?B?NWZKRVdEdDRiMGJoUG1HeGNveW9uQ1l4c2ZTTUdXdFhGeU9iUnFKTEZyUTBh?=
 =?utf-8?B?c3NyeTRLd3VubzlHMmY0VWwzZXNJb01lR3Yyck52UGhROFduWnVobk5yWHFl?=
 =?utf-8?B?SDI0TXBuVWVod2p4YWhNVFRXbFJjaDhRektVQWxlbzlOUHBwRTFqbHhKRjZy?=
 =?utf-8?B?NjNMMHVaYnVnZUZ1N2I0UE8ycjhHSlFsZTBYMElORXRTN3pieER3Q2NrcEdI?=
 =?utf-8?B?aklXclJaeHcycXlDTXVVKzZsbUtYNVNnMkR1S09MMDdXWFJuN2FlZ1RpUFNX?=
 =?utf-8?B?ejlmcElpdHUvRHltWHVpVkc0N09IRHVxUWZSbFBDQ21DWmx6REcyb2NVeisw?=
 =?utf-8?B?U1NpZldiN1lYcmtleDR4VVEyeXV5Nmd3TWFtUXd2bHRIRDk4VjNWS0R5SVZP?=
 =?utf-8?B?dDdZRTlna0llUDlJaUkrWmNOdlEwNnhTc2p6MUJLWEdPaElWTGRQbm1ERGtF?=
 =?utf-8?B?SnYyeDAwQnc2Um4rbmFLMGtmcGQ1TURMNFR4VUFVOHZDYzM5V0xOL0ptaDc4?=
 =?utf-8?B?K0RyTUFvZUdzQzc2ZjBTa2tZdTJnQ3pQNklOaFJLbTVjeCtLVzBJRm04SU1i?=
 =?utf-8?B?YWlCK1JER01FcWtTaFVuUVF1aVpRa1hpeFFnTHRISW1CaVJyVnJ5bXZUWXdo?=
 =?utf-8?B?d2gycUJHSWdVbnh2TzZkTlE2Tjh2TlNrQlhFczNUakVUS0hwQkVDY2N5cFRX?=
 =?utf-8?B?Y3grT21NMFVFcHVQT0RVN3pOZEFHU1IxU3MvVE9iRVJkM0F6NStjanduZ2xa?=
 =?utf-8?B?ZVY0KzdaaEF4bEhxQWlrd0h2akRtelpVank3Qk1sa2VvMzMrU1dyZ0M3a1ZR?=
 =?utf-8?B?SG9jMEpHclVLRUpSYVYwdWpzTmk1RzVLSUY4dm5XOGErMlRocGF6bHBvc0Rs?=
 =?utf-8?B?cHB3M21mU1g2UnpVeWdCaFY3dktFVmQ4eVJCWVFaSjlsVkMrSTJqT2NZdWxK?=
 =?utf-8?B?STNjby9JMGRaVFhqVXRjOUpyY0dhOFNDdzZ0blBHSTdEbjRLRi9BVnFuemVY?=
 =?utf-8?B?ZzlYYmNQZ2FsMFJUaVJadEtya0pMbWVwY0xoWEhSZzFBTUdvVUpJajJJYnFO?=
 =?utf-8?B?ZU9PcVExWmVyaHBxVGxnMzF1SVB1U1NFdUQzdFA1UkxsdkhCRzIvUUc1U2tJ?=
 =?utf-8?B?cmZOYXMwR1Z1d0dUcFgvbnl0YWl5amZMVmdQWWF4b212UzFIL2M3MUNsT2RW?=
 =?utf-8?B?MlgwTEdKVWF2SVhaN0hxWVdoclZJZmZIdEMzd0pWM3V5OVU5ZnpNMjNieUF4?=
 =?utf-8?B?M3ZBUXJXaDJXUjBMeW93S2l6M1lOeGRTU3Z2RDM0d3JtdENPZFNUUDUyaVpQ?=
 =?utf-8?B?Q0c0SGd0YldnRzhFWmFkbCtHck5lNkJJRlpNaytueWdQV2g2Ym5KZ0IrNHB2?=
 =?utf-8?B?V2xXY0JIeHVLYTVUTjRoZjdwTXJncnFEQXhDNTVzWDlzVnVIbHRUR1VXUDg5?=
 =?utf-8?B?ZjdGcVNhU0RSU0JjNTBkUVhNeTNZNlovdGRCSmtvYStsVi93T3VCNGNlOGNK?=
 =?utf-8?B?VXNUcmtjckVHNGxlOFdHd0RUclNhT0dsOEdJYnNGQ09rNlBBbEQxbEsrSGcr?=
 =?utf-8?B?MDk2a0FDQXZzS0NoUk9GZFREdVg5bkNrb2pTSHRZQy9DYW8yL3JOV3o4Vzh0?=
 =?utf-8?B?ZHhJRDYrZE5hVTBQS0h0aDBjaGdRZ1lTRU8rM1BVRkk0YU02R0ptVUlpby9r?=
 =?utf-8?B?dkM2ZEcwS2ZYbXlDVGR3VkNkN3NsVXl3NzM4TmwzaUxTaTZpMFhpN3dYNXp2?=
 =?utf-8?B?TDdZSTRmU3dTSlo4MlF3NzRFWkViNHJaYitWM0tFVmpzdmc1Wi9VbXVyUDl5?=
 =?utf-8?B?Q29PQVhNNU50c29STE5Lem5aNHU3TTJrTFVXYjUyU1VsY1hRUDFtN2YwdVI4?=
 =?utf-8?B?QzNRV3REVHVkZHFTQTNsOVlWVmZhZ3FRYnlLRE9EaGdHZGFyNHdMN2tNa203?=
 =?utf-8?B?OFVvZkE2cEczQjAwY3ZKOEtrMUliTThmSS9iZVprWVRUTDhiemtwUHY2VVVN?=
 =?utf-8?B?azhqR2JRRzFGN3R0eU44OU90MkZyVGFYRzU3NXJtQ0tFMG9jT1htaUtySFVI?=
 =?utf-8?B?THZxWFoxMHdGcWNoVEpkZ2tMdWN1NEwybUVrdFl5RzZ2M0doRTBOU0Z1YTV4?=
 =?utf-8?B?VkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 038f7197-0d6c-48ff-9a26-08db35da02ad
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 13:31:07.0061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rs2KCmpgXvp46Z1Ck2KkYqWypYPT1huxdRb7glubcfL7Dk2gl+10rDmiHPH7mFRKHMwrCVeBo0BeydoqG2swY5FLyUKxG5HXszyTJzZ7J3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5208
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Date: Wed, 5 Apr 2023 09:51:11 +0200

> Add meta data matching criteria in the same place as protocol matching
> criteria. There is no need to add meta data as special words after
> parsing all lookups. Trade meta data in the same why as other lookups.
> 
> The one difference between meta data lookups and protocol lookups is
> that meta data doesn't impact how the packets looks like. Because of that
> ignore it when filling testing packet.

[...]

> --- a/drivers/net/ethernet/intel/ice/ice_switch.h
> +++ b/drivers/net/ethernet/intel/ice/ice_switch.h
> @@ -186,12 +186,14 @@ struct ice_adv_rule_flags_info {
>  };
>  
>  struct ice_adv_rule_info {
> +	/* Store metadata values in rule info */
>  	enum ice_sw_tunnel_type tun_type;
>  	u16 vlan_type;
>  	u16 fltr_rule_id;
>  	u32 priority;
>  	struct ice_sw_act_ctrl sw_act;
>  	struct ice_adv_rule_flags_info flags_info;
> +	u16 src_vsi;

Minor: since these 2 bytes will introduce 2-byte hole or padding either
way, I think it's okay to put this field somewhere around rule ID or
priority, i.e. other primitives. So that when someone is adding new
short field, he'll see there is a hole and use it. u16 after 2 big
structures looks a bit off to me, sorry for the initial confusion with
this "please no holes at all!11" -- it's highly desired, but not by
sacrificing logical grouping :D

>  };
>  
>  /* A collection of one or more four word recipe */
[...]

Thanks,
Olek
