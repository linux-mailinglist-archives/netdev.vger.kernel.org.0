Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3667670EBA
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 01:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjARAiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 19:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjARAhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 19:37:42 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C92653576;
        Tue, 17 Jan 2023 16:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674000441; x=1705536441;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lL9sOpyLKHdgcctyafWT8bMtACHnJQpFY63b2BXHwUs=;
  b=hsNPXjQDa7Fw1r8XKUh3/TU4y61KDE1gOqRz9Tjsi2a0FTZd6+G2Mj9w
   3la150bv6nn3zlB3KIPD2rF9E87eyBlo+X1eFn488+m1Gfp8Q9l6QAfll
   5iOJAcRJfGv7bLEahNz6/lQr5SC4m80Vw19uYfAeRWUqFEulwIwvCk5Bg
   J33HSUNeXFWXUj7Fz9cpbRpDr+tBxJ9nRGPpmVEAGxiHdlP8VUazn+Pso
   vPvyBFrjag4EhU5uFe8cu3p7ZIYuJMXyxFf03Wn943ETssMdLQRBxQwET
   ub8Sft39rhEKgHg+oXjn3BOI4SVai2xqqmG+P7xn1odyNCaDn2XXsvcXU
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="387202679"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="387202679"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 16:07:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="661501296"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="661501296"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 17 Jan 2023 16:07:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 16:07:19 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 16:07:18 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 16:07:18 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 16:07:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LAUIKUJXLvoJgsg1tp00IeHCHUFYpRPVgIp50emvL3N7IZsm887rvI/EfRn7geXbGwqsd+4Gb6N0FwzN8mUoVTcFz8tv9YFxqlbrTNFQKTMnyG1hrYlE+LfKFpcoY/QidoE1V0ORBhDNDo0cGUMk1bQYNYKX88gDebkeLEKUHniqtJfc5iPP9QSfMqHhHTnhUuxj9Wqk4objvlF9Gkx1HszkW7sqCYFOhkv11w5dLzsVGSeOFTwNFycPRM5iMnIIjAvT8eO9I6lURuorIPtA2Fjc/5M2mK4g9PSlwH12TVY4ObTejdrWxzcGUFlMU/j1bK1EohgAtw//5KpRF6qd9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOtKzmldUCdvk0iu3QIuhDpYv+C8pna0OskiaZL80yg=;
 b=EAj2dETv8cbJw+nbkyMnCvDHMM5MbHDIQL2lvYvPkmWuEMs8xMn4XIzzHPAjIHGXSHybpVOW0sBqcoA/VktM52uMaKREgp5Vq1lh8az6+clazT2NgDycLaRANIKQQ7eBJpp4yhnNtYxe9wwg+rZGIfD9NfqERy7tAUMAY9aeVYqRemJO6/0C55CEg+4Ixm6kfOz1dbeSGRcicTuS6w0NXQFKRvgHptWyfi52VQDkelqzGkHxqkNjiG0ZsnruGv0D6dvD5FFzYMWwREUsOT14usywiQNLctQqglWBb3V5R1cWjpYQ1bRf4YxJMVYg8R3MJLOpO1NyWf4AzENlsstDkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ0PR11MB4974.namprd11.prod.outlook.com (2603:10b6:a03:2d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 00:07:17 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 00:07:17 +0000
Message-ID: <0946c513-867d-0ddc-a632-b03fea2cc921@intel.com>
Date:   Tue, 17 Jan 2023 16:07:14 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net] net: macb: fix PTP TX timestamp failure due to packet
 padding
Content-Language: en-US
To:     Robert Hancock <robert.hancock@calian.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Richard Cochran" <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230116214133.1834364-1-robert.hancock@calian.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230116214133.1834364-1-robert.hancock@calian.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0037.namprd08.prod.outlook.com
 (2603:10b6:a03:117::14) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SJ0PR11MB4974:EE_
X-MS-Office365-Filtering-Correlation-Id: 55db633c-7b6a-4016-a2ab-08daf8e7f576
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sqBTESCYk3WMMlw4J1ybKeLI3L6TZWZ3zR6UBfQuZFxBW9NhIokDf+lzKV4pEaqxRm0DEiwhaU2BDiyhF3W0YcUrkf7UXyvhuuWcqvLwRqZUzwKRqOXoTTRpklkCpHzvbYNLmYsvBTJhylh9Y1MgiREvFf0RShymrHBEzWKokslhUXaNyGnTrh+qNEemRpve9uvSyejoV2ObaxAuIi+m6rabkc/6pgxTnvnveg2P4PYyzKhiD0zL08jktWVpu6caqWNC4dlLkOUvxv8r3NMUpgjWwmugguvQ7tg4sDKbR9BhjKezHFNqh9IdYxTqkHC5oGKN9baOORBh/G0OJ+BYGwL2X+SrhwE8pmzA18e/aGWuHeNqhWQ+6bJ62wrH0xLzKBwjJ98kngmsJlApwDT8mKmuJV2WNML7CEjeX+tPePW0OGxCRN9j3pR1WFyHPtezbJtSku3dRy0PukalwuHCRiw8kbvWhSXa60Kn7mM5TcEIYwxyCmmqlXaRqLUXVTwaG1bZyOC9x0n8rEGtplMtlUJpht/coOjuh9/XvCYHvGMZdHcOqk/NSvq9jKAn4ZmRHwjMYkvF/j6jFqjSrUwtPDLIEXBSe6VlvEWayc/P040brc9WKWJK+nRPioaElp5Dvcna7dnLt6KTG9q8dHF+FbdrZaGg+zb+7El0vtXvJBA2UXkE/0NpPYLdXOaQFjgKbkssjEuR8AnwjQH9gNMVr4xOJIIRfkZ4k9rrEufGKc4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(346002)(136003)(366004)(376002)(451199015)(82960400001)(38100700002)(31696002)(86362001)(5660300002)(8936002)(7416002)(2906002)(66946007)(66556008)(66476007)(41300700001)(8676002)(4326008)(2616005)(6512007)(186003)(26005)(83380400001)(53546011)(316002)(110136005)(6666004)(6506007)(6486002)(478600001)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXdSUmRZVVZ0bGhFOG5lSjZ0M2xKRUxjaHhoTXpXUVZzSWczS1RhSThhYjBQ?=
 =?utf-8?B?NUxZcjZaSTVEU0tLT2pRL0d1Q3Fkdjc4ZjRmWmFFZHZ1ZXE4T1dMN0FNSTk0?=
 =?utf-8?B?aU0zRWEyS1ljcjlUMEl4bkdwT3RRc2tzRjJpTW9yMHhpNGlZRlpTNFJVTkdJ?=
 =?utf-8?B?YTkvS3NGUHpjbW43Z3VHaGxXc1VrejZnNUJ2UklNM1R2YXhvbXlaSmM5Q2tC?=
 =?utf-8?B?dE9rUlRlNG01TzdXd3pUbExQSUU2SHFFRzI0NTNuaFRLS0NLbkJVWUtWVDBh?=
 =?utf-8?B?ZjNxQmRmdHlNS0ttQ1JidkNOU2ZoaU5JcUZ5V1hQeitLNEFTWE5mbWtrMHZU?=
 =?utf-8?B?WFQwNDVYeGFrbWJWSXlVeHNSOWJ6RWtGcWQvSENqdm8xeENuMlppOEs0VFlw?=
 =?utf-8?B?Tmk5TXZkYkpZcG0rNCs3YTMvdWdydU03NnMyL0lEWkFtcCtUYmM0NmdSOW1D?=
 =?utf-8?B?UnB1Qjlsak8wVXFKY0Q1cXdrMjhTWGJrZk5HOHBEV1I1VHlwR1Z4S0tLbXdJ?=
 =?utf-8?B?d1BDN2hITGJkQlpYR1N3RC9xcUFsT0srdXVIL0tkWHN3WndHTnloS1F3UWsz?=
 =?utf-8?B?UVd1U2hzTVIrRVg2RC9qQytGaGZKY3RBZmVpdFBha2YzeDhqWWpEeWdxMGhS?=
 =?utf-8?B?ZmxKZTJncjdmb0NuQkV1Zm5ETU5tczNUYkRweTI1eVZHdS83MXV4c1M2d1FZ?=
 =?utf-8?B?MjQ4dFova0Y5UE9yU0NYVk1MekEzZE1Bam94elVnTlhYVmhYV1lUakpCc3N0?=
 =?utf-8?B?L09EblVJeXduVTFSZEpteFM5Q1ZwQVIrTzFRMUFpeGVlckU5eTdjMytBcW56?=
 =?utf-8?B?WGZwbkNLUnMzMDNML1dBU2E4eSt0b2NMeU1ZdDhuVHRYbTMwZmJ2OUZQUjl5?=
 =?utf-8?B?M3h4dWhIVzE4bUdIUkgvaGZ0aUZPcTZqelRIMTFqcWVkZEZ1V0J3OGJEVmFo?=
 =?utf-8?B?NVVqT2pxSGx2WW82SWhrNlJyRTd5bnF0NGF6aDhobTVwMHZ0UGJwcVY3Z1p0?=
 =?utf-8?B?UUNLSnM5SENqZWw4blZKd0RQVG9NNi9wNytObXZFQ0JSM3ljRTNLMWVKcjRP?=
 =?utf-8?B?Z3RNTkJDa1BDTkxSNVNWVzExWUV5ZVBSSm9sN2hyeCtXK1BmSjNRL2szeHgw?=
 =?utf-8?B?RXdHaFJZMEdFQjduRXVRNUlBb2VHaEFpcStMd2NKOEtLUUJsUVRGWXZwN05I?=
 =?utf-8?B?TEFLYWI5TDc1dEM2cEVxbXZuQUlEdWs3UXlGOVMydVNtS3J3RFYra0tPcnBo?=
 =?utf-8?B?cnh5azRkYThieHVIZG83NWdxbGM4U1F0VzRNSnA0a0UvcXZhTlpwWFZYaVhW?=
 =?utf-8?B?Qi9CbVFtU1g5bFZVMzJiOXVNaFBFUHJSOThxT3d4Y293N3hoT2tCRHlqRXN1?=
 =?utf-8?B?K3Z3Y2drWG5EdFAxM01hbnVaUnAwWmlYbThuNysxcHozSWM4SGwzaEp3NTlS?=
 =?utf-8?B?akMxQzFVejBrTTFWZVUrQU45OGhrN3pwSnJacHRaaFIvTExXZjMvaXVyWTZS?=
 =?utf-8?B?VEhKakc4N0ZHRFRhZUlpd1pZdWFxb2hNcFJ3K2RRR21mMnR6WWd6WlV6dmZO?=
 =?utf-8?B?YkhodmxvWUNtd2FBdGlpM3dVd0puYkRodW5NYjVRNkRMZTFGaUFYNGg2SzhX?=
 =?utf-8?B?NW9oZU0zc2RIL3pQQmdUSEpWSTFnd3NSVTc4QXd1WmVsTVZXNVpucEUxcDBT?=
 =?utf-8?B?eGxGZE44TjYyc1hsMUpEMTIvWUJQanRvTHFJSzJrc3pYV1Jtd2xieU1nRUJ4?=
 =?utf-8?B?bXhSL0VCYm1vb29XMEhSWjZPeVVRUDdueDFWSU1MVUZZa1UxYU1qZHFkay9P?=
 =?utf-8?B?T0JlL1FpUGpqOWhkVXYvZzdQLzNhaXdibEUramRSSUloRytYbnU2Y0RobFhv?=
 =?utf-8?B?RlZkSlJZR2MrYUFvb1dxWTViZjBQWW1zdk0xRzZDWjZ6WHdJOExMOHIxVkhR?=
 =?utf-8?B?K3lkUHJYMGs5amE2VUVGT09HenI3MjFIVkoycmZ0bVJmWEMrM0xUZ3E4UVdE?=
 =?utf-8?B?cVlXV0FheVd6bDZIdnFsVHBwYkRaYmlPRVZ1TDRlLy9EVVl6aVdTeUJudFhM?=
 =?utf-8?B?SFptY3VBam5pU1pEUWZCNXFReGY2ajFHYmMyMnpiKzlpcW04RlpVYVhLNDJv?=
 =?utf-8?B?cU1PT0EzMk42cnV0cHZKWktVM3Y2MWd5eHV4cW5wRmtLeEJsNytEaEhPSnBT?=
 =?utf-8?B?NXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 55db633c-7b6a-4016-a2ab-08daf8e7f576
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 00:07:17.3484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5FKYzKdP3P1U/RI/h7uFrSkzNzUjHACBtizoa/+g4igBUBhBV0MIzmKE9ovx/Rq/F85+JdDAL7eNAjMp72Smnap12CDy6eAe5ckX5FhYIwU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4974
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



On 1/16/2023 1:41 PM, Robert Hancock wrote:
> PTP TX timestamp handling was observed to be broken with this driver
> when using the raw Layer 2 PTP encapsulation. ptp4l was not receiving
> the expected TX timestamp after transmitting a packet, causing it to
> enter a failure state.
> 
> The problem appears to be due to the way that the driver pads packets
> which are smaller than the Ethernet minimum of 60 bytes. If headroom
> space was available in the SKB, this caused the driver to move the data
> back to utilize it. However, this appears to cause other data references
> in the SKB to become inconsistent. In particular, this caused the
> ptp_one_step_sync function to later (in the TX completion path) falsely
> detect the packet as a one-step SYNC packet, even when it was not, which
> caused the TX timestamp to not be processed when it should be.
> 
> Using the headroom for this purpose seems like an unnecessary complexity
> as this is not a hot path in the driver, and in most cases it appears
> that there is sufficient tailroom to not require using the headroom
> anyway. Remove this usage of headroom to prevent this inconsistency from
> occurring and causing other problems.
> 
> Fixes: 653e92a9175e ("net: macb: add support for padding and fcs computation")
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---

Makes sense and is a nice cleanup.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  drivers/net/ethernet/cadence/macb_main.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 95667b979fab..72e42820713d 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -2187,7 +2187,6 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
>  	bool cloned = skb_cloned(*skb) || skb_header_cloned(*skb) ||
>  		      skb_is_nonlinear(*skb);
>  	int padlen = ETH_ZLEN - (*skb)->len;
> -	int headroom = skb_headroom(*skb);
>  	int tailroom = skb_tailroom(*skb);
>  	struct sk_buff *nskb;
>  	u32 fcs;
> @@ -2201,9 +2200,6 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
>  		/* FCS could be appeded to tailroom. */
>  		if (tailroom >= ETH_FCS_LEN)
>  			goto add_fcs;
> -		/* FCS could be appeded by moving data to headroom. */
> -		else if (!cloned && headroom + tailroom >= ETH_FCS_LEN)
> -			padlen = 0;
>  		/* No room for FCS, need to reallocate skb. */
>  		else
>  			padlen = ETH_FCS_LEN;
> @@ -2212,10 +2208,7 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
>  		padlen += ETH_FCS_LEN;
>  	}
>  
> -	if (!cloned && headroom + tailroom >= padlen) {
> -		(*skb)->data = memmove((*skb)->head, (*skb)->data, (*skb)->len);
> -		skb_set_tail_pointer(*skb, (*skb)->len);
> -	} else {
> +	if (cloned || tailroom < padlen) {
>  		nskb = skb_copy_expand(*skb, 0, padlen, GFP_ATOMIC);
>  		if (!nskb)
>  			return -ENOMEM;
