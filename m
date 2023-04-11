Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02ADC6DE009
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjDKPxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjDKPwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:52:55 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77A65FCD;
        Tue, 11 Apr 2023 08:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681228364; x=1712764364;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AU0+O30JyUE3E3VdomAl/bPibCrBRG1cVwIhl3B/CC4=;
  b=Ye3bM4fW9GmTSie+jh1ZKKDcZifWiWp37DnWX2NajBSV1RzBCB3DunFp
   NBw88nXJZqsMAqDX1LZ9PGPcdzNGEndTXAwe7G0pZpIaTRbpxeVvn2khw
   PkdDFgPK42VWAncfSzQ2U5rC53ByQlqsrpWwjAmYrjICOst9Ja4anQ0qf
   nVItSjFLvhocXbkQt7cRIEdTRlEV9CpDGKriLqi/U85tXuw3+URYrxNGr
   d7J6cNeBDA01D6WnQa0H511bxTPw0Oj332/xDCdbUmI06sLS0Rc9b11XE
   yDUf3k16I+PNAYs87tRWE9l/sqiOk2q85gajWO3UOxchFTO1iioZ43REj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="429945338"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="429945338"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 08:52:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="753187937"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="753187937"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 11 Apr 2023 08:52:16 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:52:16 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:52:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 08:52:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 11 Apr 2023 08:52:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0rfvsnUtqa+LbpS0HIJhJMC4jyj9WYIx+w38/tXXpH5AwcoGxeR3AACA9haOm+T1CWa+/cgG4Gm+9baB5/QJ1M+/3aot5duyPg2wsumgaG+JKdSZ53xRpI4v3jDDVlT1LjfQrssvg6KbbfT0AgXdy+omwElQqFTJ0ntkf0+bm+HgeaFHWjmBtm1A7s/6S8E2vRzb8Q++31IdgBcXvNew0MWfEgqTjcD1NT2s8au8oQwAMFnHad9dOWfZXzrzdEaW6JbAJVZcnamH5c5OJs1XmaV8pVjcGMzrmDV/WM43ENNhfe1QdwBVLMhO/i+OLURw07ZDPWKg0sm36jarcSasQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dKVsbQEYJXhdjJLrFtWxt+Tj0fmAJAMApUfJjGVX0II=;
 b=OHtslfaNg/9Y9W4QMcCddiXqBQTaWFhxNaj8Z+OB6kdye+QMrUsg8qH8AianJDHe12gOA125iBjlptKVuTMjdC2Gu4LEVbyyYb84wXD3SoFIolIthhCiPKgkaBN766RiuQ3T0Ioi6qkzzsYoO66PVqwMBddR7cGlNAp4AZ/Os8its6xYPw7mjWiJ0sPvBgL8QmaT+sPyQBUctfxl+Y3UaPoQiXa6QjLccaQpej8diEQWoytphKLbVEmkaqhAM2vAI8sLktHrH0HZUVWfBiDLlMA6DjMygyZNUOQafGZCuXIwU1RdHFc0WAHzYrXroKttEIZCoMTol5kSIzRH+joa9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by DS7PR11MB7807.namprd11.prod.outlook.com (2603:10b6:8:e3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.36; Tue, 11 Apr 2023 15:52:14 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 15:52:14 +0000
Message-ID: <c4e9f765-87f0-5aa0-3eef-78a3cf60a944@intel.com>
Date:   Tue, 11 Apr 2023 08:52:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 3/3] mlx4: use READ_ONCE/WRITE_ONCE for ring
 indexes
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <tariqt@nvidia.com>,
        <linux-rdma@vger.kernel.org>
References: <20230411013323.513688-1-kuba@kernel.org>
 <20230411013323.513688-4-kuba@kernel.org>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230411013323.513688-4-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0154.namprd03.prod.outlook.com
 (2603:10b6:a03:338::9) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|DS7PR11MB7807:EE_
X-MS-Office365-Filtering-Correlation-Id: 46624573-0c4f-4a10-85cf-08db3aa4b817
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mn/I8oxclxo0F1inGxj2Obw9DfbsmjkimlPf7UyOqrVBrUo5Ipx+GWyIKYbpsL4mGWr8NR9+xzrwoFHV1QyAgmsD5XxufbvK2qoVA8TS8jq3pUGx0oZzBegXyWXKP9Mqmch0t9L81CpHyjHCDA5gS9DOdFIkHJ8jqVyDmCPA+qYPvXsrKM3MLutonAo8MIBIRC3c+5dxmI7nMGXY4ubP2rr/LPlc6nBhYaOCl48r681eiX4YGhaydWMzCDK1mNYVuxfVoUN92A+5BArHxSoqwHYk4PqQV+T27pthE7BqTqQN467ckRp50mcRgPo5AEqFZtlP8uytZ78ihl2Y9bl5WqB3wkDhnz/p1GBBY8HeKBnvZYOnw3YRX2dnTrQwzzKfzehtces4TM1Vw8MBzNRmcR/B0ylLRBlGhOG87o/y4mDQ5Vc7zKZOnBJhKEWQk+aFBzDUNy3M7MyQIn8p8KElkGeu85AFAQclFCe+ZG2FCb9oZXsLaBwUVcCWHeY1MGJn3yWAk+1pxsQpUcVRdcBhHJ1tlLml7QSKM7YBHT7mti2Hw0NS+/LZnTXL9jIDQ6ryBdELg/DB9X+w6bOTfXmeXFBXxtNNQtpfSqHyqEghBSLge2oxjUZZ5Dsqb6KJbN/4XHz3waHEIz7Oq/e6i9b+/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(136003)(366004)(396003)(451199021)(478600001)(6666004)(53546011)(26005)(316002)(6512007)(6506007)(186003)(5660300002)(6486002)(2906002)(4744005)(44832011)(66556008)(66946007)(8676002)(41300700001)(66476007)(8936002)(4326008)(82960400001)(38100700002)(86362001)(31696002)(36756003)(83380400001)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dE4zUEtaRDJLaU42cVh0bVM5aFdvbVFielVpb3daamYyd0d3bVFuREVXb2Zi?=
 =?utf-8?B?aTQyUmJwakdIZzJnSE03SFhMMmJnUmlYV2JQby9Tb0lqZU5sRkFYdWxkaE5z?=
 =?utf-8?B?dXJ4THZTanI1bnZlb3E3aDhweG5FMUt4TFBUZkZPdHN5a1MxeVFnRlJic2J4?=
 =?utf-8?B?Y29iZ2Nra2c0VUlTemllVDJMWTVoeFpLeS9tOCtjTlFWb3l1Ym1XNG1vUVRu?=
 =?utf-8?B?UEZEVzJkVmJGWDdzdFcrNTdmcXFrSUVPbHF0OWI3UlZKVll2SzNLWnBnM3JC?=
 =?utf-8?B?UlJvM1FIcTJERFdwQnAwa2NNaHFRMlZUS3JsS3U0QkUyT0RzcXVqemhmNkZM?=
 =?utf-8?B?YVlwZ21OOE50SzZCSXNtbVNuVSt4eldjQTdOUkovbzFyWFF0bDR5WDcrVlpK?=
 =?utf-8?B?SnNyZjl5SjZST0FUc3VtaktMcnk0LzFCTmI4V0VzSGx3VGZpVjRjbDJGZ1Y4?=
 =?utf-8?B?V2d2UFNHSGJ5akE3SUljbXFFN0ozSis2UzAyTTdtZ0ozU25lOFNQNS9kRU1W?=
 =?utf-8?B?VTVNZlowUDF1WmF1YlkwUjIvbW1RZXJrdE1RbkVzYTlGNVlVcDBhVDY2MUdL?=
 =?utf-8?B?WjFQa0dpOXBVUGlTVUVlNkdjU3YrUHJHWHpBZHd6SmVZam9qWjNwS0NsT1RX?=
 =?utf-8?B?ZVVjcUR5c2RhZnV4NmV1MXNJaTZuOUNOQnI2ODkxWG00ZmxLdURXQWRRaEIy?=
 =?utf-8?B?dHlucFNNVHV4eGZyQXhMRXdJVXNndE1helpwN1piVTNsWWY5Y3BsdlYxK3dS?=
 =?utf-8?B?VFAvYzNWRWhRYlllYXRWMGE0dm5HL3BNS0xDVk4rZjlqNUxXVkdVOXhKN3dj?=
 =?utf-8?B?WWRhcUZaenFVR0M5K2h5U3A5dUYxbHdWZ1hXM0d4dGRBaTFpOTZXUUNkWWV0?=
 =?utf-8?B?ZU1CYU53eUZiSjlXUXYrQVE3Y01qSDhLTjI3d3hrWWl5UG9PYXJqZFZXOU9v?=
 =?utf-8?B?Mjh1TTFRN1YwUVZiVXkzU3NSQTBzK242REhvcVhVNlVTeTB0NFhWZHhOaTZF?=
 =?utf-8?B?K0lXM1dWSXQ5U1RhVTRPMXN5a2g3V2xnTnFBc21hYzJpU1VqQkxZL0NMNE53?=
 =?utf-8?B?UWhqcnV4dW9OWXdHSFhYMlJtN3J4dFYyL2Q1NzFGSzIwWElocXM1Mk1PNDMz?=
 =?utf-8?B?cmdpVUlUT3RTTkVWSHZoVkFlQ0tORG04N3luKzVXaVo2K1RoV0RIS3JjVG1H?=
 =?utf-8?B?SENlREp0YkNnY3luVEIwMS9Id0hKekNKYmd1ZlNFNVZSTXRDM3B0ekpoR2tK?=
 =?utf-8?B?YXVZZ1FHOFl6R2NlbTNiQk81a2FkOVRxenZ4cU1ndXpLcjZmOUxacnpsWUo4?=
 =?utf-8?B?SEsyZm5KWE9LT3RjNlVTNURXU0hEMzJSRUYrQ1gvVkRmazdMTEk4OGJTRW1k?=
 =?utf-8?B?TjFVT1pGSzdIRFl6VWhLZnQ5SDcvVjlIeEtrczFQZzJycGp4Y0I5ZnlKTWt4?=
 =?utf-8?B?RytUTnBaZlpHd3pkVm1DdEdVSFIzTW0vRTB1dzRnSlNLbmpGV2dRMlNaVEhD?=
 =?utf-8?B?cGJtVno1cFF4TnZaRERkdnJWWXdDeUhWYnptQ29hWUxWcFhCQmp1OUtZODVU?=
 =?utf-8?B?TVN1MmgxSWFXVm1VWWh6VTNJN1BSOGUwOFhtQnk5MG52ZjNUWjR3ajdBOHJx?=
 =?utf-8?B?MFVDZUJZaXhMQ2Q1WFB3WnhYVDh0MzZZSkhxZ0p6eUJCVDFsK2xBeDBGNW9W?=
 =?utf-8?B?NUdPbHVvU0NLSGlnVmFWZTRISTZrYkV6eHpUSEUvSjNqdzNncHZDM3A5TWc3?=
 =?utf-8?B?aEdJb3laMno0Qm1qUkJwWVNveitIWnZIcjJKcXl0RVJmU2xHZDZxNVh3c1VN?=
 =?utf-8?B?U0llajBHTHlBS1VPd0t3emRhelI4b0U2em9yT1NxOW5iVWIxdS9STVU2aG4r?=
 =?utf-8?B?Zm5JdjN4U2FPdnk0cklnZ3JxcnNWU3hnZ2tqTlA3d0wyUC8xblBxNjZ1UmRT?=
 =?utf-8?B?aGZDUUdUcWpKN1EvbjRTL3RURzVUT1hYZDRIMXZua2g0SXdjcmZBRFRUcVVS?=
 =?utf-8?B?c1VTcm9tVEJYMVY5T2JsL3cxZEN3RFYwSmZySzNWYkU2bFVQSGVRUW1xNUV5?=
 =?utf-8?B?UkRyaFdXTG9tS2lyd1dCc2Iza0FCazZIcTdleEsrR2hDYmdiRXovNjkzVlBR?=
 =?utf-8?B?WWdlSUU4VG9FR1NZOEozc0dFTEIzOVU2anU3aW5RSWRjVkhPWUVmbEhzWldo?=
 =?utf-8?B?UXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 46624573-0c4f-4a10-85cf-08db3aa4b817
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:52:14.2655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H4VYeOyy1qm4Scnnl0MkVkLWcT8pz15Uz/n2Us+wjzKIr7FKFKFmiMdH/HcAFZN+VmBrHHFDMaoCpxzZjqvjBz4N3ay+LJ+VgDc5oiWwrp0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7807
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/2023 6:33 PM, Jakub Kicinski wrote:
> Eric points out that we should make sure that ring index updates
> are wrapped in the appropriate READ_ONCE/WRITE_ONCE macros.
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: tariqt@nvidia.com
> CC: linux-rdma@vger.kernel.org

There are a bunch of these issues in the intel directory too, KCSAN was
able to start pointing out some of them but I haven't gotten to fixing
them all. :-(

For this one, looks great!

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>



