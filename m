Return-Path: <netdev+bounces-10778-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F23AD730447
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:55:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3449C1C20D5D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E711210963;
	Wed, 14 Jun 2023 15:55:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CB32C9C
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:55:45 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D438D193
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 08:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686758144; x=1718294144;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i7vkOynjHRpfUTYdLLZQq3HExdbvpAuhXIxlHSArrJg=;
  b=nUpdMarT/bdL3J4oWqVehaynNMsQga3y1MFQJ55CUpzMjGILlneEYZ61
   KvVPDaTCi1DzlhJYlxCTjS6lVqfAN6P3inRtdUc8dW+7sGcY9BNTkSWP8
   /+J/YlRwjA8AEycw3Cfwk9+uAWHOFWO12c3VfHXK2J6E4A8yFWJ/Ax/dn
   UHxRCTfrn634ad/5AGwZBhlSIaGzOrhEEBMcawvoXZ7Tvy4sFY+D7/2p7
   jtbEoF6kp0aClssTnOVTx+dE51wEN4AY40122Sa1oFDXvpkUGcv+n/wUo
   JC3N6G9dlwLiA00EXNFaURdaRysiRv+RU1YLKsoUARfkOcsUzF9PHQBBX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="357535333"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="357535333"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 08:52:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="745133956"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="745133956"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 14 Jun 2023 08:52:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 08:52:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 08:52:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 08:52:29 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 08:52:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anbQyqwzSfADe9ROT+A93EWds9St7bkgMidPWcIeluVSjUXwDmX39Xz82tjgoq4LGlJiZb2mzMvxG8I/8dBailQc0l/6HwyvvdXrlzEN85eQeShm2XjYheVesyMnCA3+J54HM4xYwfq0GIb6RvHSBQuwnJ14mbBYvJjKuz2aHNScWfhT/O3NxyBjoCCudIzLcTkaaGSK6TXdmyhvMhMqjteEMbtcv9ROOuNLNdjwDb6wquIEQLSjIa+EdBxFj0dH9inwois0XtSxlPev4cuxGopbGe5FnQUIw3UH3/15jVQciEsDDTlSHeqmg7HZQm4Xc4T1RIlLkNY7I0I37RUmmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6h7uQdhIsyM4m6ER7hPtawpTa1IFOF1TgzdmjKYbiiw=;
 b=T790q0K9dDu0bo5M0pFxULYu9ftAkI01vOac9c5KMaXvjmvLI8SmrbMQ15f2ndcv2reYnJRqN1LKoWqnPpmP0PbH3lvrYiRoj1XuDmRKwcTRQmZsE6H0AsOOVzSbmxStkjLQd/fNvKF6sposYYmJFoPxd+n+fb0RNf/wAjVcLwwN8yHyxskRcv5jV3qep98PZZItzb0DVdA7lCoQlE5jkNPjxPFLGjYa1ouXZtdsqKb8lxqS2gaYbhBXtu5wLRvYy3qD24Ued6IKH3B9UajpuyU1GwVYzBPfdWil1daUYL6BbV4Aotr+wWodyn9A8S+wqkQG6qRpcF5hL1Qoi9lZqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4451.namprd11.prod.outlook.com (2603:10b6:a03:1cb::30)
 by MN2PR11MB4565.namprd11.prod.outlook.com (2603:10b6:208:26a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 15:52:23 +0000
Received: from BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb]) by BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb%5]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 15:52:23 +0000
Message-ID: <041fcdb4-0ecc-6ced-d77e-e042db186fce@intel.com>
Date: Wed, 14 Jun 2023 17:52:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next v3 0/3] optimize procedure of changing MAC
 address on interface
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC: <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
	<przemyslaw.kitszel@intel.com>, <michal.swiatkowski@linux.intel.com>,
	<pmenzel@molgen.mpg.de>, <kuba@kernel.org>, <anthony.l.nguyen@intel.com>,
	<simon.horman@corigine.com>, <aleksander.lobakin@intel.com>
References: <20230614145302.902301-1-piotrx.gardocki@intel.com>
 <ZInhqR2RspvkMOYF@boxer>
Content-Language: en-US
From: Piotr Gardocki <piotrx.gardocki@intel.com>
In-Reply-To: <ZInhqR2RspvkMOYF@boxer>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0087.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::20) To BY5PR11MB4451.namprd11.prod.outlook.com
 (2603:10b6:a03:1cb::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4451:EE_|MN2PR11MB4565:EE_
X-MS-Office365-Filtering-Correlation-Id: bf6e23af-b022-4749-3fdd-08db6cef57fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AXzHzw1+WQL8o8u1q5Kq8UTC7K1MXkffJRq1EeSlv/quN+Ib57jBeZdyt8Qw+hUwHMTnoV+fhC5oJGb4T2eG13sg6a7F63Nujxs1jf7Dq8b/WEexLIZoFZoC/4Mn/+9f2fanbvJAcAoRsH3oULRxErd1li/FAnQAbJhEpOV1H1JjWMGBTtJwvHrn8phIT5q6fgbUN9ctubzNemaysciG9kYwscUvxOWazzWYscjhIDTbqsYjjOh5uzY7PSb5rA0hZXouya02g92bIq1hKOXdc6n5A1/OegQp9NYxZ5PUkBadgbMDU+H2StLj9SugLOFJo9ISuhYFD8tDsRvOcuXjpDu/f1y/vYaeciyRcw6KRDUVhsjcs3DoQJM0vTR9TPMoYcjgAM9R19s2NZ62g/fXGzfkHxsIehA3Bp2F6L63/wlLBWncOAWS1dKUrHnHn21mTCduil+DsOUSQFMOEuIgTh12tSZiKDG860B3wdUmAFVYHyCctnYAuKmgAJVQdd77BCsDpuGU7Hd6K31g6ZBhZTsvY7tlw5/0TFCaS4c4mHEs01DxweqottWmfZecOgWRsaGH2td5sYVolDPTAf5U0BrUlypuLZfyNl3sJGeL/R/4u3m4HCgTmKGFYg+pS3yVC+jAwZ8JG+Xz/E81pX5FDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4451.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(346002)(366004)(376002)(451199021)(6512007)(53546011)(6506007)(26005)(36756003)(186003)(478600001)(6666004)(6486002)(4744005)(2906002)(316002)(41300700001)(8936002)(31696002)(86362001)(31686004)(38100700002)(6862004)(8676002)(82960400001)(5660300002)(37006003)(2616005)(4326008)(6636002)(66946007)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGVkbVE2dy9SWWxCNVpFWlgrVXhKUGFyVGlTWVFnNldacEM5eVdndENVTzlV?=
 =?utf-8?B?U2RzWEltVFhoRkNvZFNla0RHVmQ0NUtCaHh3QUJLc1ZsWEkzVER1ald2dm1N?=
 =?utf-8?B?MzlqdFdVZFlLYWFHZDZ5NDJhWkNWRUtKQ09VUUM5bTBZaGd0VjFsK0ZnNGJu?=
 =?utf-8?B?cFdYMFhNektWQkdDdjh5UWR0NG1ONFpzSUREZ2ZaYm1LUGZQOEVodHU4Q2Vz?=
 =?utf-8?B?dUVsTVFrck9SVE0rczZ2NDQ0b0QrWFd0cSsxQ1hjTi9kY3pweUdhbTVQWlps?=
 =?utf-8?B?Z2ljdEtRYm56RWYzM1BUTnIzRWYraStPU0xKWlZyTjZ5Tm1nK0kxWDJ3VzVy?=
 =?utf-8?B?ZVc1a1J3L250T2JwUU1RL3JLVEZSYU5qeTFzSWw5Q24waHE5ZmRnYXB6azZz?=
 =?utf-8?B?am85TzNUcU94MUhReWNrWHNtQkZ0RWFYNmIxMnBobWkzVEY5bCs0eEdGaXFk?=
 =?utf-8?B?OW5HSjlxK2dxSTlGdGZXMmVzNitwVHA2VEdoN3VVcEhhb1dILzBEK2xaaVZl?=
 =?utf-8?B?bHFxancyR3ArRmVDTUxpNFdJWGZRMjl3Tkx4V0pOK1BHUTAxUVBMOW85N3Jh?=
 =?utf-8?B?NjQ1TCt3MjRGWURYOXB3ZnBiQld5OTJOZ1o5WmJKci9rZUFVSEtIMkN4QzEy?=
 =?utf-8?B?SmJvd1VLQ2xLaW9SNW1XdlVsWGlueS8walMyWUhKdlFRUys1Y3MybDBnWS95?=
 =?utf-8?B?aUlScjJ0aTlrVTE2b2pGMVpHbU9oazljUzRQaUIzaXhZbW5lcXlJSjFucWpM?=
 =?utf-8?B?SENza2xWZ2xEYk90WUNOblZ3N284TUllZWNXU1l6YWZEQXl0Q3VicTFMVUMv?=
 =?utf-8?B?STlIeElVWmxybGlhdEk2THIrWkNsUkg1YkNmdGJGL2MyZUk5TWxEZlFIbkZk?=
 =?utf-8?B?eW9ZNnhuT25Zc1o3TC9SK1JSRytsQ3FPWm04ZldXam42b1lkTGU4ZHVoSzds?=
 =?utf-8?B?MXlHWXU2Y0ZESVdTVDVUS3FIclBBT0hMeTE0aUozSExyMHE5dThjaFhJYnFL?=
 =?utf-8?B?Q0xabVU4czZuakpwVytlQW5WTDdHam0wb293R0h5cEg4azNKR0FuSU5hSDQ0?=
 =?utf-8?B?ZmRsdzJvWFllaUNCZmgvZEhNYUorU09IdCtKNTZidVUwRHNJbVc0ZlQ3S2VC?=
 =?utf-8?B?dkVUVnY0Ky8wTGovOEJoL3JZUy9XTWpaK2RJNlRrUUtlL2IrYmZRNVpFb1Q1?=
 =?utf-8?B?QlQzbWhSNVBSZVZsSFREZE80cVlqYUhsQlV1OG5qdFFKTU8rVGc5OFVkV2NV?=
 =?utf-8?B?YU9qQWdORmlLK2VUanhzUWdIU2VicHNrQzZ2R0tpT2RqZCtMUTlFZDFWcmsr?=
 =?utf-8?B?TUZjeEl5OWZydUF0SGEwellmR0xkeS84VTYxSEVla3NLUk13Z2U2OEUvdGhI?=
 =?utf-8?B?NUgwWGM2dCttRjBwaGVtd0paeFJDVGVib2w5TnBBalg1TXBZNTI0a2JQbHlE?=
 =?utf-8?B?K3VTT2xCYTgrWHMrb3RXRTFmWEdSeHNOSk1YdWFGZ1dEN0tVNFlxY0lZKzYx?=
 =?utf-8?B?VytnaXJMcmpsUDUyTVl4OXkyMWF4TDFBdzBQbXVhaDkxTGpmTXRhTm1zVWhB?=
 =?utf-8?B?djJJV3RpbS93cXJsbTlUK1pscVEzaFU5ODY5cW8xQ1paQjFsRlpHVTlaV3hP?=
 =?utf-8?B?YkVaQTh0dDNMQ3dLUWo2TGZ6dlhGMVlDdHhtVnhJWEFsZDhOK1BrTVZmRFZZ?=
 =?utf-8?B?cE4zS3VyQkNsNEY0SUFlZTJPUGwvMzJvSGs3dnVFOHVhdmtJNVV4RUdoMW0v?=
 =?utf-8?B?Z21weEhnczF1SlJsVE5GK0J3T1AvNFdEc3g3SGI5NEVQRXNBM2lQZEErWDJM?=
 =?utf-8?B?ck1sSW5DS1pjUzFWcVE3VWhqUGladHNwUjZ5TnhjdWEvTkR6Y3FGRlVJNEpt?=
 =?utf-8?B?STJHU2duM3F6aHZVeVp5L1hkTVNwOWxPaWhYcUNaMWZnK2ZkWW5Rbk9xOEov?=
 =?utf-8?B?T0RUNW8vU1dCeWkvNVRsWUZtQi9ERlVaejhrK1hsQnhFbGFmMmg3cVdtaW5l?=
 =?utf-8?B?Z1dTaW9uSkVaMzlJTGs0THVQUlI0ZXJ2K2lCMEhHSGhzMnZIakcwckkyOThJ?=
 =?utf-8?B?aFk5ZmpyMGVDREt5UG9zckVqdlI2S09vKzJoOUNqNEoxZkhPdUVsbDg2TnlG?=
 =?utf-8?B?ZWJvdkxYMW1WTU9IQUttaysxb1VxcE91b095YS9sS0cyT3FwMDZDek4xakw4?=
 =?utf-8?B?MWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf6e23af-b022-4749-3fdd-08db6cef57fe
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4451.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 15:52:23.5073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WvgtdpLR7WsPVvKNtEepkcnrobTzholXHcFHIdrbCjGtST6SXIMLRbLhCJLpM6iuvWTD/hpLtw9cz5tLNeTpyqKmKs5EhC72C6txfBToLy8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4565
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 14.06.2023 17:50, Maciej Fijalkowski wrote:
> On Wed, Jun 14, 2023 at 04:52:59PM +0200, Piotr Gardocki wrote:
>> The first patch adds an if statement in core to skip early when
>> the MAC address is not being changes.
>> The remaining patches remove such checks from Intel drivers
>> as they're redundant at this point.
>>
>> v3: removed "This patch ..." from first patch to simplify sentence.
>> v2: modified check in core to support addresses of any length,
>> removed redundant checks in i40e and ice
> 
> Any particular reason for not including my rev-by tags on driver patches?

No, I just forgot I can include them when I'm not changing the entire
patch set. I'm sorry :(

