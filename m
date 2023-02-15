Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC84A69889E
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 00:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjBOXMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 18:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjBOXL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 18:11:58 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E053B0E4;
        Wed, 15 Feb 2023 15:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676502715; x=1708038715;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T+Pa0MXsnblE3qF7Gii0aFPt+XxYjjqoTcccKiGgyGY=;
  b=bEciCwNC42AKhdjQhjB92v9LNjTdoam2h4D+06DheQVXNe+R5VILzpHz
   JCuNioyxoCxmN2eXsLC8EUcC0eQZ+oUyrksnH9zCmeeZ0ituAEAa2K79S
   j7ikDM/lKwEwpBx7ftRQgGcV+1Nw0+XvDScCHXwkttBMe/GOB/A8+l4bq
   /Vh8OaofiCKiYnB8iRtrUxCPudDW03eijVXrYSIwZmec69FQjFermpeEV
   8J4Hs2Bc2oiEiw2RcVn52gTWP5UJKYcQrIMaVq1kA6RAtIYhB/b7y7SIB
   NvIialjNqpdmeRw2MOaTKUq2Xot4zN9kZwwHsFeiDWyQ2bJVaNBRYqsDW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="333720261"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="333720261"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 15:11:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="702347457"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="702347457"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 15 Feb 2023 15:11:44 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 15:11:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 15:11:43 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 15:11:43 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 15:11:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MFreqj+CtEeKArQWmwnB53WGAJ7PRQ7V7Ecym0yP6vwI9P92VsMUA6cP4CM1OlcqoJhM20tfoK6uW5zCCnvzLsPCK9rbyRTD5dWQ+5GlQOBogh9SiCQDMCCs5LD+Tcch1OJWbx0dhzzfFuuQGEu4k6GYBp11KHw1rkQWXtghPfXOKLs/qNl/joxJDRn5qYlsy7qH3zGZgymCtaaHlM9VUhxtQqECwklOqgg0o4LiK8Kjd1IjPvA6GZm7fUEEr8LOTc5ukNa81Jq+44SIhITQms6ufG+Svx7iuD4OxFU6+foMwdr3Go4+8UqfV3bG/3UosxR2FWABeoR0h6/GqBeaPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r9UgS3MP/Caphmo1WcY8r91m/mXB0QN6X7sW04poY4c=;
 b=Hbk2PBVsxsNT1nwwV/kKo47hqbUcvuJxae3b///Xqak3V78+ehIfiT/FuO9mOLB+wQl9EsdxSvDpHoBcwhTRScsCzxzvCOiLj9HbWVi2hy+esGK8pipwuhkIjDDgbtMNJJBpVurq+qJCenBKrM1C7f/KtLRyIw+EfIzMMe+s1n0E2+gIFN7UbYquB8ozJn/zZPx14gzO+jSbFBNjEfhG8z3di3d0DfN446Rv0DxdKVxQyxqTFY6MsR7zOMX0Aru6neQeOucP+ubLb3o0WwsqaNbRqL/wXFBrSmjzHWZ1RTPahSvYZFD21vNTtiWDrydeWchErasMJkaw7iDEej80Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by PH0PR11MB7635.namprd11.prod.outlook.com (2603:10b6:510:28e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 23:11:36 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 23:11:36 +0000
Message-ID: <140c1b9e-263a-ac2a-9595-6490d6f849c1@intel.com>
Date:   Wed, 15 Feb 2023 15:11:32 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH intel-next v4 4/8] i40e: Change size to truesize when
 using i40e_rx_buffer_flip()
To:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>,
        <intel-wired-lan@lists.osuosl.org>
CC:     <jesse.brandeburg@intel.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <magnus.karlsson@intel.com>,
        <maciej.fijalkowski@intel.com>
References: <20230215124305.76075-1-tirthendu.sarkar@intel.com>
 <20230215124305.76075-5-tirthendu.sarkar@intel.com>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230215124305.76075-5-tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0066.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::11) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|PH0PR11MB7635:EE_
X-MS-Office365-Filtering-Correlation-Id: 88d49560-31a4-4e97-56f7-08db0fa9fc22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vpAOCytV5BbY7cQP0alOSwDIz/Qn0NAVVwUateSBihAbMLB/mbmJVRQ5YEdqkcCzS2v+ysuTbtHeN8mp6H0BaTVPbDarPOEFMqSS2Sdyh8EBjSW0IS8nJBJ+oY6OxjghLQBW8ow/2ydB8J8aWUobIlfldD+jM6qqoxKP809cHwLN4wmIyvOeFzQOEA1zpLQCFNZCD6P/kTsFzje+jtg1/JN3LZ+pgnRO9H0mvcN9Nax+TB9LlnWa+AG8iP5YminXk5a3CyUJKei90nZuBx9rmbDy14yU2cZx3do60mOW55EmYmhYqd8taoMVjD2VsKmB7K5VwwYsU/TBjYa5jBhv3+6rqtBnRATQ14ZgBsWw6+vwa13CQChz9WJ4dyKWNmwkPueFILAMKyK6DmNePESfkPSTLECbwQuvHSvr5BMSJvpn19dgja7Wgao1V7oeISnc6YIUNWx0LfmjV3HI3ifmUHYPomBbs844SjL3Bq8P9cEX/YUQ0lXv5n+1at2eQXVSI+96lOj0cAxCCIPmKcszYZeIxEF8QqXHQbFKaNvbroi0PPsb6WFg70JTVnGbOAGcmPP44IDrDr3ukfwphSWd9OnGCbMYUAcY2GafC7woaGZ4BU6TrrUFnWv8FFwYHXbB7+xy7dFJJkO3HHAyYh9NazilSXU1kFJdiRhSC1zcukOjZU0fRQsTcfyeJMO3swYiaefiP6RSngS1VbTwi1z/rsqE0CjqXtf6Tutp+HJzu7o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(39860400002)(366004)(136003)(451199018)(8936002)(41300700001)(83380400001)(6486002)(31696002)(186003)(478600001)(26005)(6512007)(2616005)(107886003)(53546011)(86362001)(6666004)(6506007)(82960400001)(36756003)(66476007)(66946007)(38100700002)(4326008)(316002)(66556008)(8676002)(31686004)(2906002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dG5GamwwZk1EY0ROMEoxOWtWQkRDMitLeHkzL25HTU9FcG5hbmFWUkZpOFBR?=
 =?utf-8?B?ZWVmYVhZdWM0MEhWNnNvSEQzaXNKVkJSK1oxTzU4RExQMXpEOG9JYnM2ZVJH?=
 =?utf-8?B?UzVpbFlzeUE2N0lZWWlaM3dpU1pHRzIwTFhFTjR5dHhCUmlzZE44bnRVcldI?=
 =?utf-8?B?enJVcHFsM0JBUExWWFJPTGVUcUxPMVkzeEI1eTdmMHg3MVhzcUFOUk45aTNL?=
 =?utf-8?B?aERYL2Z6SkpFaEE0WHVpejk4UEVrZFB4ZjAvc1Z1dVorTTJCRXI1emRDUG9o?=
 =?utf-8?B?ZEUvaHpkNUFic1R1SHdiMXNacUVuVThMVDJPcUJaVFZvaWl2TEdSTnJjUGcz?=
 =?utf-8?B?QzZ1aW13bGsvaXNDTnRidmRkY1hjVk9mZElnT25heG40YWlhUEg1cGpQTEt1?=
 =?utf-8?B?UitzdE1PZGJyYmpETnh1ZGZRZmlPblVMNHBVU2NUNVdqVENHdmw4YkJNaGxD?=
 =?utf-8?B?OUw3ZzRXb3BMcXdkREtTMVhBbXJlWlpIWU94SWRZT2dNWVRDQjJ3UkVJT2dl?=
 =?utf-8?B?N3FjYTNwM2tWLzRLTEtrM3VBcEIrdVk2eTE5RnBzeWw0SktlWE51dW1BNDJH?=
 =?utf-8?B?dmsvUnRueEJlWVFzdmx3cTZxd2dSVngxV1U0SlhNaFgrYlptTCtucnNKNjZk?=
 =?utf-8?B?SGpCZSthZXRTbXVnc1ZvTEpCZ0JsOUVwaU8vWmNaVXlCOGdMcWlCMTdISFVI?=
 =?utf-8?B?Y0NtVGNoREhWWEc0cGRGOTk2MlozTkRLYlNuWlg2RWx0eWFHNGZTcTF3dFBs?=
 =?utf-8?B?M0NCeVdrRG0yMGRSMGNVN0tKUWFOdVRQWFJoZlFOV0N6eHlERmlOWUZIQmd2?=
 =?utf-8?B?ZnpJOVBxYUlRL1JEajJjcmxNeVFZVjkwZ3JzWFZVSWtXb1NQMzhDWmpFRTNh?=
 =?utf-8?B?RktlVThwQllKcS85R1RYcUllS2Y5anNhZVptbjEwSElEQ0d2M0RwRVdJakpq?=
 =?utf-8?B?UjE2NzkvYjRrQUhveWIyeThPYVhlTHhSZkVzdVp5b2kwOFlJU0NoOE9LL2FN?=
 =?utf-8?B?SlhGNXA2UzVPYitiR1RZV2VNbU5wdlFvY3JxZDNaK1pHamNnWjdNcUZONC9S?=
 =?utf-8?B?cGVtZkJKdXZwU2M3bXJzT0tTSmNHdEo3Q3V6Qnl6SWlTVDZmNDZuVmFCV0o1?=
 =?utf-8?B?WGlrQmhEaFQzTnBTenZncUhXTjZoenV2TzhqMWhmbXdneFAzYk1kMFZMa0ZI?=
 =?utf-8?B?Z0NjUWQ1RTBHQ2poTTl5OCs3Wm90ZFlkSkt1Q0l1aUZaMGxrbUVHbHJrU1Rm?=
 =?utf-8?B?RTY2QUJtUHRSK1lRV3V2ZVpLeWJBTEVmdzN5dTlRa21PQ3BTRkVRdjdDd1JH?=
 =?utf-8?B?ZTFTSmd4d0Y2U2p1YVB6NmVBYTlaMUlWT2JJMkF1QzNjZE9RYzNUUTdTbDlj?=
 =?utf-8?B?blArYVptc2hFRk8yUkRnbVNSWi9NVW4vMmZ5OXFNWkRobzNJL2lFSFpCalBJ?=
 =?utf-8?B?dmdtVkRsZEorZnNsdXpJNGdNUXluYmtBVTNvL2FwR245cWNzUHJFQ3lxQnhJ?=
 =?utf-8?B?aitDK0IvSjNTMnh0cC9oc1g5dXJ1U2FQUzlhK1NUWEU2aTVpR1JhUFpCa0RP?=
 =?utf-8?B?VXRoYTVNWHgvRnFoWW84Ulhmenh5YVE2a2paamQxYlhwZ2ZWR1NFV1o3MDd4?=
 =?utf-8?B?TnpxaWJyOWdXWmQ4dldYL21hTFVvdloycnpkSnVZTlorRWV0SzhwTGFFOU55?=
 =?utf-8?B?VmNNRjV2V1FISlNWZHBVclovakMxY3V2RGt5aUdPMXNSUFJITDJwN1Nwa0c1?=
 =?utf-8?B?VENKa3dQbFRWVmUxQjZoN3BBaHRiT3NEbkZ4dFdSakZHakgxNlRBSGJoTXlh?=
 =?utf-8?B?Rkp6WGJ1MzR5SlZsNXF6VlJVblUzM3RMZWpzM1ZRMEpLdGh2WnhSeGFqcWw2?=
 =?utf-8?B?cHh3bXJ3MUU5K0h4QXY4d1ZCcnp0MFBZQUpOVTg1STlOQjN5M2NxRVIvMjBx?=
 =?utf-8?B?UEkyck1zaEZOS0dnc2NkZVlESDBwdzM2dndZZThCL2s5cmtwSEVFUkR1MlFZ?=
 =?utf-8?B?VlprOVN6SmJ4MjVVTlRDVG1VSUFkRlhyeGVyazJWaFBQandYajZCQzhxd21C?=
 =?utf-8?B?amlOUi9QOHJwMm5sbGJXWDZCck51bTRBTEJCKytIRU9EdWhQWU5veXdpTTVR?=
 =?utf-8?B?OVVxMW45RmpHb0FpcWZ1UHQ0VnBzUnhwakZuSHA1QWlQd0tPNkZUYnltcWxu?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88d49560-31a4-4e97-56f7-08db0fa9fc22
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 23:11:35.9399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tvahT+Qimrsdih7bDvVKzCwnOjFDMyt9gtOBJvVEO7ifzH9aJ60PglH54gDP/28tbLi9ASyKVv3+siwm5t9gnEBdSUAZltKhGu3UM12CPBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7635
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/2023 4:43 AM, Tirthendu Sarkar wrote:
> Truesize is now passed directly to i40e_rx_buffer_flip() instead of size
> so that it does not need to recalculate truesize from size using
> i40e_rx_frame_truesize() before adjusting page offset.
> 
> With these change the function can now be used during skb building and
> adding frags. In later patches it will also be easier for adjusting
> page offsets for multi-buffers.
> 
> Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> ---
>   drivers/net/ethernet/intel/i40e/i40e_txrx.c | 54 ++++++++-------------
>   1 file changed, 19 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> index a7fba294a8f4..019abd7273a2 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -2018,6 +2018,21 @@ static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer,
>   	return true;
>   }
>   
> +/**
> + * i40e_rx_buffer_flip - adjusted rx_buffer to point to an unused region
> + * @rx_buffer: Rx buffer to adjust
> + * @size: Size of adjustment

s/size/truesize

> + **/
> +static void i40e_rx_buffer_flip(struct i40e_rx_buffer *rx_buffer,
> +				unsigned int truesize)
> +{
> +#if (PAGE_SIZE < 8192)
> +	rx_buffer->page_offset ^= truesize;
> +#else
> +	rx_buffer->page_offset += truesize;
> +#endif
> +}
> +
>   /**
>    * i40e_add_rx_frag - Add contents of Rx buffer to sk_buff
>    * @rx_ring: rx descriptor ring to transact packets on
