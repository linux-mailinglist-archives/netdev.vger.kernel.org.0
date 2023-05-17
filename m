Return-Path: <netdev+bounces-3470-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3821707529
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 00:13:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C359E1C20F86
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 22:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEBE410950;
	Wed, 17 May 2023 22:13:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A505433F6
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 22:13:17 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D8D35BC
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684361596; x=1715897596;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Opzp2CF4xa+SiWa6pnV5UcrL0Cr9MmlD+kVtYnfMs4c=;
  b=gpFwVxAxlk03zWhti1kCtA+ZQ1ccuHrzMkhTCC9PqqO4gD+/ggmcuOEQ
   qZLITU27qNbB3kfiiqAnI2BFKmEeY5aEaIEXBJeGetlpJwIgklcNJFVng
   84/hzMLzw9NfDfS74zbmbed09axA9r+wfRfEap9hUuQLv30L0gSfpAlUv
   m1PA1vVHpg186Pwahln+siEuiAu6KlXLNERjF2qDrUCh3UqJ3ut7eoXii
   UaM33d2VH1glzZKpWH9H3eKses74GXrtj/PJdT5SRq1wF/x37qBEEUPSg
   hsVNy54BMZmvK+kb/I2vUt+N7mLl6iIQjcwrVvKbHecYRGbGcyQ+F7exK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="350723356"
X-IronPort-AV: E=Sophos;i="5.99,283,1677571200"; 
   d="scan'208";a="350723356"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 15:13:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="948426890"
X-IronPort-AV: E=Sophos;i="5.99,283,1677571200"; 
   d="scan'208";a="948426890"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 17 May 2023 15:13:12 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 17 May 2023 15:13:12 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 17 May 2023 15:13:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 17 May 2023 15:13:11 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 17 May 2023 15:13:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6K2EiorC1vUZMKrKyJGrT5R+PdR4k6mG4Ee6w771Age0lnHOQjuIqJRncMAD84h6fHNsGjn3Svdgfr8mLVhos6CNhZsQdZjvLin+B/J+6Ywnbgww1pU1/rzPoTXz+YYD533zbsspXgqtlJmq3zIdGYF+dkt5b4Nw4/+m2Xx1rhfh4EwxcGnh+DCFz8PmM+8fy0hKWfwqwCwRqYBy2oLBxDmD7cSafb2ATZN56ctX3swGM2D6t3TiZMfVb7DgUaPHDz+3wvLbu/BA+Pm/9ZWBAE3qE+QI+dZReATiMduec/voz/vYjWI8rdLi7d6auHrwMKs9Fu2fmbpZQvikvMn5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/xE4Hf/Ap+DpY0MaUFZ3Sd3Ojoy4ZKJJ4ILFXZysuY=;
 b=cYWq0MrMzXfHw3Q+LVkLFQz3J0gU6wF8FMqKjdtKm3zs+lrA0wl56mHIu4lQjAzOoBA6MO1TD5sPZZCD17rqjwyNy9pvgfQd8R7ADt4kUWiVbtrni7G5nl9Adtfv1OEmv5h995Na2W97ifIxYw9QvsnUY72Rn1jiMneGybFauWem/bcanHsJ8r/g6MCAFrEDbrJu1VKS7uEDgSCVISjL8rNFoMs8cOSXqT/ARzmooTy22robbN60vnh0221DVZYDZIUDC6mVe6cYIoM+1qa3+Lz557hxBWTaKf47gbOOsS758CLIAkErsFyJLzqMpCN4S97/p5sXF62jZ4GTsL/0ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH7PR11MB6546.namprd11.prod.outlook.com (2603:10b6:510:212::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Wed, 17 May
 2023 22:13:09 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::27fc:4cc8:6fea:1584]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::27fc:4cc8:6fea:1584%5]) with mapi id 15.20.6387.032; Wed, 17 May 2023
 22:13:09 +0000
Message-ID: <5f9a1929-b511-707a-9b56-52cc5f1c40ba@intel.com>
Date: Wed, 17 May 2023 15:13:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>, =?UTF-8?Q?K=c3=b6ry_Maincent?=
	<kory.maincent@bootlin.com>
CC: <netdev@vger.kernel.org>, <glipus@gmail.com>,
	<maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
	<vadim.fedorenko@linux.dev>, <richardcochran@gmail.com>,
	<gerhard@engleder-embedded.com>, <thomas.petazzoni@bootlin.com>,
	<krzysztof.kozlowski+dt@linaro.org>, <robh+dt@kernel.org>,
	<linux@armlinux.org.uk>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-3-kory.maincent@bootlin.com>
 <20230406184646.0c7c2ab1@kernel.org>
From: Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230406184646.0c7c2ab1@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0182.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::7) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH7PR11MB6546:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c9f37e1-d4c9-415c-b76d-08db5723e5a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j/fcbfRws0BRNByk/RBJ8sPA//6wLCBIAMyod7XeQFd33iYkgw5au0R04Dpq44IF0cagHcgZUV/CucjXAsh3lK3GwI63UUE5dTkc6nVdiFaImOSzFnsESWrCsINyOf38mngtNwWaB8SLu0bmXbTKeVdfSF8528e8hlBdGxYZNuQ8mFswfAgCQt7X2B+PzxVf2XlxzYfb6f2YBxRZdMFrQY4B5dtGZEuamabo0IsKO4txGjR2BcEFq50MxzfwrLUlUNlRhBUmz9Y5783OOm6e6eb8nxi0/z/xgT+ASNu1orv/nmV3PMbXSEa9DPAUduf3RJoirNIWukty1XvUEqZWxSpj43dJFgxhIB7U02XEfGOt5JfDhXPoyQV1MrUa3vclVTe86uHc9d0LV7ZAjh78Re8lkTdKYo8O14dOaFTfF/ZDfzTGsSfbQTHWmtOJTKxuFscm0vRrAt25pjYvrIs8P7I/c/dZl8O1MSrWrPQ/j1p06bdXaRJX6iJ3fZm+Yb3jJcU+06/2TtceQgI1Daui1dEFcgZDhIM279URjcVM+ZzN0w4PFMyAVV3t2OL6317xwm4+RgMqQmJCj/KISp9d93fYCiwQTIHPBkiqnn4ZDAWbKFSo233Lczqna+58T9NY51UcCVEYAvams0mEV7JMdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199021)(53546011)(478600001)(186003)(6506007)(6512007)(26005)(86362001)(6666004)(4326008)(83380400001)(82960400001)(66556008)(2616005)(31686004)(6486002)(110136005)(66476007)(66946007)(5660300002)(41300700001)(316002)(8936002)(8676002)(7416002)(38100700002)(2906002)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVpoNzBOUi9VN3lOQkNlZVRVM0hGZk84clkrcFBjbzZTaW00OGExaU1hUTB5?=
 =?utf-8?B?bHhyOXZNcnZVbjhWb05ST3JMRk44RW5STTFvOUFqRzdyT3B5RDQxeGR6UkpW?=
 =?utf-8?B?cDdWQnJSUUVkNTJrSmhIQjhTQlRqTGRDRmVEMklHUWsxdmoweTJzeXhaZmh5?=
 =?utf-8?B?d045QWgvZ1BmUy9SblNGZDVXMjNmRURxN0FHSG5RNXpBeXgrRlpnSmFjUHNN?=
 =?utf-8?B?Rk5WbDJFSUxLaFNjNVkwbGhoMzYyRktBTVV1SGFGS0d3Wm1XZFVrbUt2L244?=
 =?utf-8?B?U3Z3VVJKTUxvRTUyaTRYS2hMM1BldGJ1Q2J6cU10TytHVVYyek9xbTRwdlpu?=
 =?utf-8?B?NHpVZUpYcVkreWdVZTJ2NzJYTUNFNEFLWGdlL1pJbHdUZW4yeUhrOVpORXlz?=
 =?utf-8?B?QUpkR1ZGbE4yeEtnZCtXSnVVUGdDY25JbHZiQ2ppTWtuOTNBbUE4ZG9KSWxU?=
 =?utf-8?B?bkpBQ0lmamNYNXdIQVVZMTR2ODJ1RGk3ZzVKcmNzdk9iQmdOMDdKanlqREVN?=
 =?utf-8?B?ek5CcExsL0tURmJtRm5qYWQ3bmZoVTRSVHhqZ2pGbDJnSi9wZlZyRDF0eXU5?=
 =?utf-8?B?ck9aS2ZGVjU5c0JCSnh3dWRhUVdwVDRPa0ZSRUhZQ3dXb1Q4UFRGK2hqdXUx?=
 =?utf-8?B?ZDhXYVg3Nk5OVkJCRmdjOENuTExxUzk2bjhQakcrbkJjcUN4SG1sOUJoZzZi?=
 =?utf-8?B?dUYxL2VDM0xHZUplWElHQVdZays1eVBKYkpFOFpGRDJiZi9tTDR6YjFqUGFx?=
 =?utf-8?B?aGdGVGdwa2J6blV4V05pTUhnMUdYdXo1ZzNHQWdFR01FOSs2WE1aYjYzeUh6?=
 =?utf-8?B?eE1SZUxtM2NjdVVTemwwa2ZqampmNWNjay9Od0hwT3VsWjhJQThkOGY1WDg3?=
 =?utf-8?B?ek9TSW1lcEFSRFRtbVArZnJyRGlVMVZiekFibHJwQndQNXBBUVhmL3BMZy9W?=
 =?utf-8?B?TTVvSTUrNjJieGFqOEZBUXMrWXMvb0prM3BSK2VJSExacXlIcmhOeFkwN3VN?=
 =?utf-8?B?Q0VuZWZ2YnJPd2FJUE5hQ2lCdjAvU25JM1F3MVpFQUFzQjd3T2ZwQnVWVmto?=
 =?utf-8?B?OG5lb2pzUEVuMDZ0Q3RyNUNSZ2RjTkVOMHI2Ti9pSVltR1dXRDNYZVo5aW9B?=
 =?utf-8?B?RFcyc1J5ZzRsNW5tL2dha2o5QUJqelVKRWRiVTRXbWlMdmpUUTNFeGs3ek5l?=
 =?utf-8?B?SHJRckE0eUlGeDBDQzhsZWVtWXFqV2E3YWJZRWVLN3ZId044STFnZDd1bTVh?=
 =?utf-8?B?ampwRy8vSmJXTHZYSDJUek9MUGZoeWZlaDZYeEZLR2ErTkZxa3llUGF4bGQ1?=
 =?utf-8?B?ZVRWME84Vi9DQ2NseEhzU3U5THVKOTk1OW8yWUN0S2ZaUmpNazcyZENFOG9K?=
 =?utf-8?B?UzFIRTZtcTVGMXJhcXV3REg1VFNwbDlhczhjSXlaM3VwcXAzZjhGVkxrcXZr?=
 =?utf-8?B?MTY1ME9tRXZyazcrRkZMQlZ4end5ZTR1dVhNZjNuR1o2dkdNNWR5MVU5dHlv?=
 =?utf-8?B?UE5xUkNOK2ZYYW9GOWM5VXlOVExnVmpMRytBdHU4eXlydFBtTnQ1OGo1RG1v?=
 =?utf-8?B?WkdjQXVUeXpiWE9SNS9FK2R5LzF6NEVFWVlGQUNzbisySDNPMk1ycjh2dmtz?=
 =?utf-8?B?dG1Oa2lPWXlaTXVWYnNoUEZ6V0NGcW80U1RMVTZhVE9tL200OEthcWlGYzd1?=
 =?utf-8?B?QlhoQkZObjI0OUsyb3R1N3g0K1NJbjJjd3czWEs1QkFMRFNFY243UjJwUzh5?=
 =?utf-8?B?c2dOU09aQWp1NUk0aUl5Nnl6bVBYaHkydUhYTmxtaG52OWpQVU5aTEpueXlz?=
 =?utf-8?B?MDZ4Ynd1UThGZ0hIZmpDSlNFOXNQT2lWTEk1dk1hVWk4M28rRUFWaTlIalNF?=
 =?utf-8?B?aDlmczdTVlRiWVMrNUZrb3o3S1FpcU0yaUVibFlzZ2xoUDRjdjZZdlczNkwx?=
 =?utf-8?B?aWdVKzR5SkhrVmxDcFFHaVNZZGtNcTNwQ0xiSnA2RWVkTW9JREdUdVU0NHdw?=
 =?utf-8?B?RWZIa1Mrb0VsTjdVQXo3ZGFSR0tTcVpYMEQ3MnFNTWtSNTlpRU9rUm1jZmlR?=
 =?utf-8?B?ZDJreTN2eFJ6Y1I0ejFSTjJjckVZTGVsSmptMmlxcVdvMCttODFRMEVTZUkv?=
 =?utf-8?B?SHhkWGovc2RGcFhTdDVnNGp2ZUowTEpFN1JPQXQ4ZFNHVitTaHRYMlZLY0lw?=
 =?utf-8?B?cWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c9f37e1-d4c9-415c-b76d-08db5723e5a4
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 22:13:09.3053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BFO6pq1fQcIo6f4CW/IdP+lwSCxBV2PmZVP//KUEJE2gEdCQeSdsb/671UAZHHwhVVZOpS20J2Xv2dZj8fNBtOHz0Ufd/rMOWoh3e6Itrg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6546
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 4/6/2023 6:46 PM, Jakub Kicinski wrote:
> On Thu,  6 Apr 2023 19:33:05 +0200 Köry Maincent wrote:
>> +/* TSLIST_GET */
>> +static int tslist_prepare_data(const struct ethnl_req_info *req_base,
>> +			       struct ethnl_reply_data *reply_base,
>> +			       struct genl_info *info)
>> +{
>> +	struct ts_reply_data *data = TS_REPDATA(reply_base);
>> +	struct net_device *dev = reply_base->dev;
>> +	const struct ethtool_ops *ops = dev->ethtool_ops;
>> +	int ret;
>> +
>> +	ret = ethnl_ops_begin(dev);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	data->ts = 0;
>> +	if (phy_has_tsinfo(dev->phydev))
>> +		data->ts = SOF_PHY_TIMESTAMPING;
>> +	if (ops->get_ts_info)
>> +		data->ts |= SOF_MAC_TIMESTAMPING;
> 
> We can't make that assumption, that info must come from the driver.
> 
> Also don't we need some way to identify the device / phc from which 
> the timestamp at the given layer will come?

For example, ice hardware captures timestamp data in its internal PHY
well after the MAC layer finishes, but it doesn't expose the PHY to the
host at all..

From a timing perspective it matters that its PHY, but from an
implementation perspective there's not much difference since we don't
support MAC timestamping at all (and the PHY isn't accessible through
phylink...)

Perhaps that doesn't fit the use cace here though where the issue is
with supporting both MAC and PHY but no way to configure that

