Return-Path: <netdev+bounces-8188-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C6F172308E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:57:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6D481C20D53
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FCB924EA5;
	Mon,  5 Jun 2023 19:57:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0792414D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:57:07 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6BF90
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685995025; x=1717531025;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5kb7Q/kB+BuSsm5t56qAiCGG2IyohXEeYq5HnuN8Xec=;
  b=gzxcuBwpPbDDUUA4068I4VDfIbY98u+wlBjELYLB62TL2WdgsSfSCXps
   xnlFL67zVrskgXRvfXUC6IxsNpPx93Glx7O+QS2rj3K4yxQ+1JYWkzCVJ
   P9BF18rrCv23VZP+GE50GlhsX6bWlifzIgholBjzwXAL/8xftM0N/lClq
   QcbTINl6Z5XWq7aObNzf0+VzSFi37EIQgIeOm/9kZhQe7cMSEl45DfkOz
   R8qM1KjzNxEHSw4FI+67OdUow4EJP83lAjSQrwohmDyp3SD+xk+BJJZrx
   feYXeqO4+0WK1IdDMunPPyZ8LbjdnqvUvwPK1DpXwWFdwSYq3FQ72gfmR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="442845423"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="442845423"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 12:57:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="686237886"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="686237886"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 05 Jun 2023 12:57:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 12:57:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 12:57:03 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 12:57:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 12:57:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSCQ+HnzcuD8SlrSG5tqIRjd67Qe8ZK73TIpBUbDWiOYpBSEIBKMIFiVshiKw9H0YR4xkyOAx+o9YmbXXvSRG+AnJkGc2gK2LBPlsBXSdaZciAqOr/N4Q8fDkpNSH0bsfEi7txxwsSPvR3q6iXuyksuVw0qJM4jIilHi1INmaXg2hBA+ctLfCogvhTDYEelpq+J/gwetW3hKd3Vf3e2rbqfOVSVoHgKHyxvgIwELgzhgZCwjTRqL+770/mngTrYDXDk2jT5CBUbfVBpVHJmeCdKdM08RXuHXtQqwnBybMFMtuRteGeVVTuugHzaZO+TO+WvVKaUBOZjirjULUDoZXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDuw0gay7UiWos+STpkIyYNp7RaGhLwdv8x+MOOS8Tc=;
 b=hut5mC/QgNY7r2Lxzmy/3liWCGRYMGx3I2WDVmBDrqSDeM8nyTfbNCmlAQ8vCD9eZFf0dro867rZCKJ5ufl+m/K+f+Kv5gKiMt4D4xQFvMdD/SYQVAd+FouuzrFRxg6tlShVjaiLqm98ZZ1uEqdyMN+Hon2sKLwVoSWmKy4X9EgvvgpkGdK22tngsty7T+noAy674Agb64RWcFU7sz1xPPDNQZ6gmaQ3FVZIzr3Ebw310zwN1v5EL/m6OOA1Mfg6tx2Q5ar/+nqBfIF/QfheIzBo5LRKH3RLv1DIL1/EHDUlfARfZTA7oWAVCyPSvJ/eun18eSxua+7fAPrHjHk1/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7420.namprd11.prod.outlook.com (2603:10b6:806:328::20)
 by PH7PR11MB6497.namprd11.prod.outlook.com (2603:10b6:510:1f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 19:56:56 +0000
Received: from SN7PR11MB7420.namprd11.prod.outlook.com
 ([fe80::5194:555b:c468:f14f]) by SN7PR11MB7420.namprd11.prod.outlook.com
 ([fe80::5194:555b:c468:f14f%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 19:56:56 +0000
Message-ID: <9b4c8cfb-f880-d1a0-7be9-c5e4833f3844@intel.com>
Date: Mon, 5 Jun 2023 13:56:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 3/3] iavf: remove mask from
 iavf_irq_enable_queues()
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Tony Nguyen
	<anthony.l.nguyen@intel.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <netdev@vger.kernel.org>, Rafal Romanowski
	<rafal.romanowski@intel.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-4-anthony.l.nguyen@intel.com> <ZH42phazuTdyiNTm@boxer>
Content-Language: en-US
From: Ahmed Zaki <ahmed.zaki@intel.com>
In-Reply-To: <ZH42phazuTdyiNTm@boxer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0086.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::14) To SN7PR11MB7420.namprd11.prod.outlook.com
 (2603:10b6:806:328::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7420:EE_|PH7PR11MB6497:EE_
X-MS-Office365-Filtering-Correlation-Id: 02e1c85f-8717-4289-6a7d-08db65ff03f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LUJcxuws1BiG3lKwY9HrfcQwnswp9wXGJ3Hx/eGhPk8o/uZomeRq0rahVEkIj3OChqCZF675kXhQDJZgissR7il91sAFgIllqdZZUESL4FzZoc0SrT6Vj0glrRIV23k/n69t4qgbHR9fMrfmZICVhNRpPJ99YQtY5WBLbVb71w3iE7gEM4C5mu05F/WRNRLBNQl2Ho7qliGwVEeSUS1GpEAGv8zblmFZPsKobgeMuLzgPq8pyppaIfdGUUNk6USXfeGxpvP+xz+XilRHlQyUDcx+bi4uuu4tVrfxyk+WUW5PjnugITB4STG6WcfNvoG5i6EhXaANW+KzN1Zm/js3CLWxT/PQ3jGiaIJVBVDgtMgGE6jXxO5GmjNzbdn7gu0TS5IyJJ9dIzPwZP0L1AccdGnBtU/v5c9mu716NDW8jJy8sfUrWTcVw48+VHA/ArJ6TAF3ieK7ZYxuwBLW8AUQH+jFfMQwO9JPXKdENGfc/94MNf5BYW3yqtAMD7JBiZkzSGuhwvj3wlfYTaEO1nMttDrYlp0+TJQqCLrHk6TX6hHGgx5jNiW0zn170uUsgCwmx7GiKVM88U7lrZ4tSIX4iHEjh16wNpFAfvXxtsteyFepQ8t//QjalE03nRNqbErHPhhkbl8/725H5hG+qWfu3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199021)(107886003)(6506007)(6512007)(53546011)(26005)(966005)(36756003)(83380400001)(31696002)(86362001)(82960400001)(38100700002)(186003)(2616005)(41300700001)(44832011)(110136005)(2906002)(478600001)(66946007)(66476007)(8676002)(4326008)(8936002)(6636002)(31686004)(316002)(5660300002)(6486002)(66556008)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0NxUFJLdmpldlVPY3BEd0YzdTJLc3N0UDZoZDNYZTJaVjRTWVc1K1ZtOGN2?=
 =?utf-8?B?QkYvbnVNU1hnTEJBYkF0U3dWdXZrMDdibTloMUZxc01LMEdwa3B0TW1KdTNw?=
 =?utf-8?B?Z25JY2tnY0E4R0JkTm9HNm1sMzRiTTVUcE5NdFNtaFZnc2ZJMThJdXNIUHpw?=
 =?utf-8?B?RlNZRDRINSt0RkN0Ni9kMzc5QXJWZzNEUFhJNC93LzlYRW9JWTNpQ0JlY2Vy?=
 =?utf-8?B?RjFHbjBXRjV4R0pIdndqaFRseDdDVDd3enRGdVNqQmlicVpKTVBWckZjMG5V?=
 =?utf-8?B?MUFhUW1md1VZMzdpSGZKTFhOZnlqVXhBMUJUWWFORlprNHl1dEJackNIR2NX?=
 =?utf-8?B?cEJVb0tOQVFkN3ViRUJteDlUL0cwZHhjcUk2eXE5VWYxVk1HOEZtaUxYb0da?=
 =?utf-8?B?NHRtN2pPR0I1YzBSczRJRXlOZ2NWZHBWUHluUkJidkRvdkNnVXVwM3dYZnhl?=
 =?utf-8?B?YStxenZwOEtxZTBtdmJwSGlVaEFpZTQ5bmR6MWFERjhEV1l5ZVN6K1QrRFMy?=
 =?utf-8?B?V3M1RFpYb0ZlRVdRdVRHeEpvTithWVFKM2p5b0piUXZUdVR3RTZYZXpDNzBu?=
 =?utf-8?B?TlFoTnZCZ2tTUXlOaS9QVFdqZytyTDBrMnhTQzR4L2R5eHlNNlhFWTZBL2xO?=
 =?utf-8?B?STdCbURIWmxSblQ2TWRFbU5kU3h2WTZXRXJRcGVCZjJkQ2pJaDhqcFFFUkFU?=
 =?utf-8?B?MDMzQ2Fla0tiMUF5N0N3bHdzendWdllGWE01VlNaRmNHKzBXdmlJR3V5M1kw?=
 =?utf-8?B?eVhlc2tJd3RNSVhGejlzOTRmOC94SXJqU2QxTFB6c1JNMHRMQWZtVExyWkVK?=
 =?utf-8?B?Q01SSEhTRVdZVnFYYllzR3dJZDZtbmNFR3RBVkZkWTFYdXIwek1zeTJBbTlh?=
 =?utf-8?B?Nk5WK1dGTEwvV0hESnNIbzFzdUYzTDlZWUZGVzhJOUxUc2J5WG1adlZ4U0Rw?=
 =?utf-8?B?QUJLYnNiMlVzbWlkU0M0cVRUQWdNemZQeFBlaWlBVXdjYW1Ta0RSbXRxL3JB?=
 =?utf-8?B?cUdUVUY1TFhhYkRtSE1tZzNJUVR2VW9qZG9JVkwrVGF6YVJURStPUkEvRTRR?=
 =?utf-8?B?U0gvNHBMOHlCS3gyZHZncTBKN1I4ZWVIUHZKSWV1dy94S0xjUnJ5ZDZ6ak1o?=
 =?utf-8?B?bHdUcHVTMlF1R3VKeDdTNHE1L0cyMDZkT2N6VmhUUTc5cHpxM3NlNE50Njh0?=
 =?utf-8?B?WG1wcGpVUVJQRlZxZVJ5Y2VjTzkrcXc3eHdobHZlY3J4VktleGUwRi9hQjcz?=
 =?utf-8?B?bkFWT3BoaUlqQUxpdVhweWc1TjZSOUovejRqR28zNkMzWXFKZFRicnVPMUtL?=
 =?utf-8?B?WENiNytibExLY0tES0kvYnRGUlNNUVBjWjhnWVAxb1BhbzhNTDhUWHpxQVRu?=
 =?utf-8?B?RVV0cmdXVDRWRGJUOEdvR1l5YnhvSVZxSjlxRS8wUEtlUXRhdllsLy9tMTFT?=
 =?utf-8?B?eUszQUxIRW5GdE1zNmJlYzJvMXdUSStTemN6YkxKN0F2bVpRak9aMmM1a0Yr?=
 =?utf-8?B?aHNIektWMFdTdWY5VjZtQ1pEcnJIVjFycTJQS3U4bkZZYnpsdytSMnZZMy9w?=
 =?utf-8?B?ejJuVjNGWlJsT3dVN0Mxc3RteEFlb0I4dEZBSStRSjUreWx6b2pzdUtsVGdo?=
 =?utf-8?B?c2hUTUVFamZFeEl2UTdJOWdEY2kwYmY0VmVBdUl1M04zRHRVdjRUaVJuSlIy?=
 =?utf-8?B?YlBRZFpUWC9lTWltS01CNmpUYjhKSUNHUkk1cTVENkRqVDJFOGhLZWhaZDIr?=
 =?utf-8?B?MXV1cVBibEhVY2Izd1hGcnJnNXlSNld6RnNRNnYzVDRtUkttc2RyRVFEN2VS?=
 =?utf-8?B?WUIyV3N0M1ZqalFMT3VISjJwT3NzSCtDbWMwNzJLN090djZJYWsyaU9id3ln?=
 =?utf-8?B?eldhZXFsMlc2SEEyVTZuVVZNajJvMldTbjJ2YWxEZnYrZTd4Um9mZVg4QnVN?=
 =?utf-8?B?VVVBbC9RMmtvb1RFNFFKVFNWMGtkTXBVd3NJbTBXSy9TbmpkTnRkT29Gd0ho?=
 =?utf-8?B?TE5qOWd1VzFWSzJQbDE1QXUxVnZMSmd4T3Zack1KUmpBK3FuQTg3Z0xTQU9w?=
 =?utf-8?B?UUY3blVXNGlUSmZTT0x1N1ZJY3RIcGNWanRKNDVlUFRQc2xubU5aSmVjOXox?=
 =?utf-8?Q?0ide1ldOlWH2BeQenystuEsOJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 02e1c85f-8717-4289-6a7d-08db65ff03f6
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 19:56:56.4254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QrN5GJ0zLO54dw34QzLxa1fJB0PXYxPdFEERT4+28dzIOboRvb8QkFwbx8oTrmaBH6QAclRaZFKi9uG4Scbv9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6497
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 2023-06-05 13:25, Maciej Fijalkowski wrote:
> On Fri, Jun 02, 2023 at 10:13:02AM -0700, Tony Nguyen wrote:
>> From: Ahmed Zaki <ahmed.zaki@intel.com>
>>
>> Enable more than 32 IRQs by removing the u32 bit mask in
>> iavf_irq_enable_queues(). There is no need for the mask as there are no
>> callers that select individual IRQs through the bitmask. Also, if the PF
>> allocates more than 32 IRQs, this mask will prevent us from using all of
>> them.
>>
>> The comment in iavf_register.h is modified to show that the maximum
>> number allowed for the IRQ index is 63 as per the iAVF standard 1.0 [1].
> please use imperative mood:
> "modify the comment in..."
>
> besides, it sounds to me like a bug, we were not following the spec, no?

yes, but all PF's were allocating  <= 16 IRQs, so it was not causing any 
issues.


>
>> link: [1] https://www.intel.com/content/dam/www/public/us/en/documents/product-specifications/ethernet-adaptive-virtual-function-hardware-spec.pdf
>> Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
>> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>
>> ---
>>   drivers/net/ethernet/intel/iavf/iavf.h          |  2 +-
>>   drivers/net/ethernet/intel/iavf/iavf_main.c     | 15 ++++++---------
>>   drivers/net/ethernet/intel/iavf/iavf_register.h |  2 +-
>>   3 files changed, 8 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
>> index 9abaff1f2aff..39d0fe76a38f 100644
>> --- a/drivers/net/ethernet/intel/iavf/iavf.h
>> +++ b/drivers/net/ethernet/intel/iavf/iavf.h
>> @@ -525,7 +525,7 @@ void iavf_set_ethtool_ops(struct net_device *netdev);
>>   void iavf_update_stats(struct iavf_adapter *adapter);
>>   void iavf_reset_interrupt_capability(struct iavf_adapter *adapter);
>>   int iavf_init_interrupt_scheme(struct iavf_adapter *adapter);
>> -void iavf_irq_enable_queues(struct iavf_adapter *adapter, u32 mask);
>> +void iavf_irq_enable_queues(struct iavf_adapter *adapter);
>>   void iavf_free_all_tx_resources(struct iavf_adapter *adapter);
>>   void iavf_free_all_rx_resources(struct iavf_adapter *adapter);
>>   
>> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
>> index 3a78f86ba4f9..1332633f0ca5 100644
>> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
>> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
>> @@ -359,21 +359,18 @@ static void iavf_irq_disable(struct iavf_adapter *adapter)
>>   }
>>   
>>   /**
>> - * iavf_irq_enable_queues - Enable interrupt for specified queues
>> + * iavf_irq_enable_queues - Enable interrupt for all queues
>>    * @adapter: board private structure
>> - * @mask: bitmap of queues to enable
>>    **/
>> -void iavf_irq_enable_queues(struct iavf_adapter *adapter, u32 mask)
>> +void iavf_irq_enable_queues(struct iavf_adapter *adapter)
>>   {
>>   	struct iavf_hw *hw = &adapter->hw;
>>   	int i;
>>   
>>   	for (i = 1; i < adapter->num_msix_vectors; i++) {
>> -		if (mask & BIT(i - 1)) {
>> -			wr32(hw, IAVF_VFINT_DYN_CTLN1(i - 1),
>> -			     IAVF_VFINT_DYN_CTLN1_INTENA_MASK |
>> -			     IAVF_VFINT_DYN_CTLN1_ITR_INDX_MASK);
>> -		}
>> +		wr32(hw, IAVF_VFINT_DYN_CTLN1(i - 1),
>> +		     IAVF_VFINT_DYN_CTLN1_INTENA_MASK |
>> +		     IAVF_VFINT_DYN_CTLN1_ITR_INDX_MASK);
>>   	}
>>   }
>>   
>> @@ -387,7 +384,7 @@ void iavf_irq_enable(struct iavf_adapter *adapter, bool flush)
>>   	struct iavf_hw *hw = &adapter->hw;
>>   
>>   	iavf_misc_irq_enable(adapter);
>> -	iavf_irq_enable_queues(adapter, ~0);
>> +	iavf_irq_enable_queues(adapter);
>>   
>>   	if (flush)
>>   		iavf_flush(hw);
>> diff --git a/drivers/net/ethernet/intel/iavf/iavf_register.h b/drivers/net/ethernet/intel/iavf/iavf_register.h
>> index bf793332fc9d..a19e88898a0b 100644
>> --- a/drivers/net/ethernet/intel/iavf/iavf_register.h
>> +++ b/drivers/net/ethernet/intel/iavf/iavf_register.h
>> @@ -40,7 +40,7 @@
>>   #define IAVF_VFINT_DYN_CTL01_INTENA_MASK IAVF_MASK(0x1, IAVF_VFINT_DYN_CTL01_INTENA_SHIFT)
>>   #define IAVF_VFINT_DYN_CTL01_ITR_INDX_SHIFT 3
>>   #define IAVF_VFINT_DYN_CTL01_ITR_INDX_MASK IAVF_MASK(0x3, IAVF_VFINT_DYN_CTL01_ITR_INDX_SHIFT)
>> -#define IAVF_VFINT_DYN_CTLN1(_INTVF) (0x00003800 + ((_INTVF) * 4)) /* _i=0...15 */ /* Reset: VFR */
> so this was wrong even before as not indicating 31 as max?

Correct, but again no issues.

Given that, should I re-send to net ?



