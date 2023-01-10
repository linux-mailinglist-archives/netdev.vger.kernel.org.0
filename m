Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8946663628
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 01:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbjAJAWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 19:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235154AbjAJAV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 19:21:28 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BEF39F8A
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 16:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673310087; x=1704846087;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ogOGiVYOvSvZgsQLQV50EIZ77PddU9X/3XRHxvioOqw=;
  b=EyTudR7ufRg4KaBDVRj1BZYguSM4SPrEYn8XqpWutod4xt06ptRpNd0k
   BVUFMUAT37wmGw+VNkUn3CjLxeHbGrTyCWIidmhh/NZR0YiASuuUD9fEA
   P6ZSL9Vx9k2LQDgbcgZamesc+4NPA/Gjeza1wNSUxPL2Z2TU8O4Rjs9oG
   hYNzDuFfUu8Zp8ifiqvY9BqnfVdwqskUoeajbkkYEuQfEuSD3/aph75Qi
   oHpSxSmXbbolaDcMvhHpLwp0M1lG2D2SvZM7vED8yaJYBILUR6mToNbst
   bdvdY5YRedzT++yoDs+vk92nRhCUpcQT3+Pi1rjZxfR5xueF9M9A/WRrS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="324264224"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="324264224"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 16:21:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="689226846"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="689226846"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 09 Jan 2023 16:21:26 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 16:21:26 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 16:21:22 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 16:21:22 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 16:21:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UuDEMD12BT169KyP7OKLhZex46gtjyS6c5PJO2jX5M2gNgoFnL6d2mdpU8S18kYCpU6pIsxOh2fiRrajrQBsCKLoxHqQ7ARf7gkdEixdnX+AlS4TXlTFPEf9fcpIfJAVF5fQGxflm5d0MxrxrrU4/sijq9Mxv3JgQYg0vm1emxviDXtH3pHc7+7gJmc5aAoReD3a4l0wyx4o5fTvoTUNgDOlzvabrNF1yIf72irk9zxGRgXv6e1tSY4cgcYsgVqR5Pluh9Kb2hxEM18kLULPSOT8KCd7Xz4LQGvTnYRsymP/bjC2BHdF6sn9cvuG3S2tQlLVgvCMv0mIehAiPKMIbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lqLh1A4Z3+1OdxYvbuHRsZU9s0sZLYO2fEX7oXF7Jrc=;
 b=QDIOCioqG7xIYwnCmDOTX99FlTbRvGG7ZJvR+a/TpmcN+ZNKugGaMBVW2BaQyMu+ubIim0iXERV/p8oOhuySVgNlu1m/hsngoD8a8E/X2HLROBWSg/+MjKlQubTlMNnqYWhVWQdGDIoY8jLwbKsNIH6NmEIU4165LN9phsExWJuv2xNjDZnqTBZOCCk4CW9cLM0/ZsoBgbX2sie1SDXmd5t4GzPzphQ5oKu3PlWiSAvq9mzDtDWjZMKnVpVdkFMWEfzcGurBt7pWEU2C2tj7/PnjK8KKPT8xJhN09SzPYUAqrLEJ8JW7ACbgMmhZlp45tfo2oLAlM88ZM8GaQZdDeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB6455.namprd11.prod.outlook.com (2603:10b6:8:ba::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 00:21:20 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%3]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 00:21:20 +0000
Message-ID: <14cdb494-1823-607a-2952-3c316a9f1212@intel.com>
Date:   Mon, 9 Jan 2023 16:21:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters after
 the instance
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
References: <20230106063402.485336-1-kuba@kernel.org>
 <20230106063402.485336-8-kuba@kernel.org> <Y7gaWTGHTwL5PIWn@nanopsycho>
 <20230106132251.29565214@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230106132251.29565214@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0032.namprd13.prod.outlook.com
 (2603:10b6:a03:180::45) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB6455:EE_
X-MS-Office365-Filtering-Correlation-Id: 47e34939-c873-4571-eebd-08daf2a09930
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /aqIp30WheWyA7FIuFHfo8i1LpzcFMcEU4k3cLA5+fkgYOL0KJ8sHnVbgh1ylfegaL0yo1dEnAMwanoVMSbdiLkXKp5pj3s0EKKXhFzyhImY1kitnwFNutByEJPx0xAH97mu+Bk/VU9T9jgk4RPwkd07HDi2mA6d5xSnmGsUnIQs501TCobgvcYgFiSJofcaHUjxF8g6sL57MepVYmmsA3DOIg7uAgbqlMSx9UWBsxZyiSA8yrKm09ImRtRHwlFzpLge/w7SWtiwIHKZBgan89U0jvcdfWYg1/RBIFM/7R+SC2SB7Uz6h+uXe6XXfGt1vyHj1axh7uKWH/cXDSZQhBH5bUjgvB2JB0mKqHw0AgCveBT9K0yndbioO3qRFA0WTUnpZi4t8j6r924Ti9NTpRhIY2mtJQCmG+eEFQaetUexUJXuxBthQFV8DHUEgHMg3lsyhmEn3jpP5fEw53+nv8jQqfF48NzFWUU59vSp1sgEsv+nC74mvDPpqMxJ676sj5H/8ZCT6cc/HG19jZlI39p/pyo+2Bnw4jQsueGfMUqr+6LeTVzgRHZpivcpK+I+LASoZaNRDFdpIKCswlJ9pFZE54Eed+Qk9UQa+LyrLmNknmFLn9n8Zu8Tvq2l8hULf5YSd3igujV/rDWr8pQNEj2bwer03ZOtllQWY57Sl4P2ZG+ugUTT6PDGoVvbRb4AoCWgyKUfJhw7IlFelpDBZUNALcg5+TgN3hsy5koXvLU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199015)(41300700001)(110136005)(4326008)(316002)(2616005)(36756003)(8676002)(66476007)(66556008)(66946007)(86362001)(31696002)(82960400001)(38100700002)(8936002)(83380400001)(5660300002)(2906002)(53546011)(6506007)(31686004)(6486002)(186003)(6512007)(26005)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0hlVnRmSWpoZmo2MUl5U2JjRmkyOG9kZlJZRGFSeTVsVTJIcFA1NTJWbU1Z?=
 =?utf-8?B?RlQ0djhNSzNSTTBIZWIvODczTkNZZnFFeURZN3liOWluWUFOTC9MbkY5TFdq?=
 =?utf-8?B?OFhzMk9PSHVNdjVLMXc2TjN5N1ZGK09CMzNSQloyY0VZTy9MbVc0SmxMZ1B2?=
 =?utf-8?B?NWV6V1BWT3BucmxDRW1aTEFnc1hkcnZacTNoVWlSUlNxLzMvS2dPRjZtd3M1?=
 =?utf-8?B?TFppdjVIUE1IdG8yVlo0a0RsRWNCQmtJUW9kY0VCcFNwbUgzdUhmbUQ5NHBu?=
 =?utf-8?B?dmpSZzRGaWkyTloyWTJSWitLMmduV2ZtOWw4VVlEMEhzUkIvdFN1VUdPQ1Ra?=
 =?utf-8?B?NmtYOW40Y1NxaEl4ZFJRMkpiSi9PVkd2YnBYdGRkbWJkTnRmZnhyMDZSeWo5?=
 =?utf-8?B?VEFEV3hENE9EUXluMEd5d1VaZnlXU0pRWDFQRjJueTBrRnNpTE1VOFhqSUFZ?=
 =?utf-8?B?NkJmY1Z2RXBRZ1RXU3UxUUlpSW1YVkVsTkZsTFZhOHJXYkxtYWR5cSs1ZTJ3?=
 =?utf-8?B?VWxLVFRlVlVhMGVWTUt1WjRvWU1HM0hkdkFlajFOaU9xY2ZQcm5aSlI5czZG?=
 =?utf-8?B?elgzL2IxZWlEYXhTUmlxSnJiaEdLaWN2eWpCL2tDU1ZRUG9zenFZWkRaQjFJ?=
 =?utf-8?B?S1FtTlVwVjNxVk1TSlhTaG1zbUY2Q01QTEt1ZURCSVkrUVhCc2FxOGtTN3pH?=
 =?utf-8?B?bUxsU2syK2xvaGVMZkN0cktlK3NMTGxjbEZYVEhhV2ZFWUhEdUVSSmdvekJu?=
 =?utf-8?B?RTVPbnYxS3FiVEpKYlVPRnkxMHI3WEpVQlBjWE1qWk1CaFRRTHlKQXk1R0hL?=
 =?utf-8?B?OXUyTzJHbGtja2lPdTR4VU1mYnh4YmYyclVNdHBpTXhFaTZvQzdEcFJPK0d3?=
 =?utf-8?B?MUFybHNVUGdFOU8wczZaaTRQS2h5bVR2cHZkckRMeDNGbzJYZWNpM3NNcWpW?=
 =?utf-8?B?KzRpVEJqL2Vkd0E4UjdYK0E2cWVvT0JlbitkNU9ydndCeE5GMklVMGpocGpP?=
 =?utf-8?B?OUJWdCtuSFlYRjFKVktQTUx1L0hxVmZUMElMQkJwdzBGUWFjM2ZhS3VIemp6?=
 =?utf-8?B?SUptOHdrcWVMNlF3ZVhqaXJ6SmhlRitxb3M0ejVsWU9YZkFXL1hFdy9YeXZm?=
 =?utf-8?B?bkdEQjlmUG1iN09Fc2JaTkhqQVB4TklHSlFRUjM4ODNkaWxJbytETUUvcUJU?=
 =?utf-8?B?Nkw3QTJKYVlsOHdibFFWS3NGbEo1ZW02djlzemsxTjZ2emRsNGRYei9zcUhj?=
 =?utf-8?B?RXBMdktrczlMRjBMTnVZSHE3U1hlbjF0cUZoZDhqSGpVcUh4OHFKWHBob0FC?=
 =?utf-8?B?S3MvSUsvVnRZdnRCS3VEbGY2UjdEVU1CK2FPSDZYWEhFN203Y1psQkdiekQy?=
 =?utf-8?B?K0RuOWJXbjJWL3IyY1BFVkdHeTFFSXA5SWsydWZZUkRsYmdyZzFmcGRhRmda?=
 =?utf-8?B?Q0NsQUcxZWFUSTUvSjQ3bm1jVGZEMmJRVjlrMUFrZWo0VG12MTMwQmx1SjNu?=
 =?utf-8?B?YWViTFphK0pSb3FQekRaNjRtTXA5MmFxVDhhZm9yTUNNQ0hsQmpxMDRocjZ3?=
 =?utf-8?B?MEJuckFXNDBtanY1Wk8wc2hsZFJUOENzTjZScVVIdGIwZ2JTQVdRcFZGNVR5?=
 =?utf-8?B?bmFLcTN5bThHMXZtUDMyU1BkT2o1YTlDeGJSK2MzZ3hVMG85L0ljdmFPLzZC?=
 =?utf-8?B?L0dNbHhDQnVTYWk0MVhuZGVTWUVUZkNvZmN0ZDlNUnF0UjdxWEI5em53d3pu?=
 =?utf-8?B?SnhkVWlLMmZWWTlSQkM5bmhsUlpZbTBZSzhLc0h1aDYwQVdvblk0UmpwUzV2?=
 =?utf-8?B?VnFwdGFONlpDczBtSi9JWlB0end4K1lzb0lSME1EOENFbSthU24yd1VCcEpZ?=
 =?utf-8?B?dzJ2Zmc0LzVTbFhEb3VGT3BnbGVYOVNUMmZOdU4rSW1FRmtmZ3FkaFk4MjFL?=
 =?utf-8?B?OHhsL0svaHl5VWdhWThaOUx3UEhxNGRvU1ZidVRiWER6TkVlOWpEd0NFNkJR?=
 =?utf-8?B?NzBEMThWWFJoTThMVkgzQlcrWnE5WEhjSkFic3poK1RMQWcvZDFtdW94UUVM?=
 =?utf-8?B?cUVIakZJVE9uT0xNYUtyeUFTUk55dTZ4ZTFsejEvdmRIYUgrWE14cEF5N29H?=
 =?utf-8?B?TlN2aUwweUt1blF3bURneEUwVnZFMkxHR283TDhzbC9GOXMxZDNpTDg0aTFz?=
 =?utf-8?B?V1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e34939-c873-4571-eebd-08daf2a09930
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 00:21:20.6874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AX0szq7NRhufcApl7PaY7cECF8FhQHqy6Azj9akoDiAaJ8q7LHt2xI8DSYM5cmoo5HS/M+DMujr7wh4F8mBt6N5Ql5jKy4EiJSelfW6HIhI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6455
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/6/2023 1:22 PM, Jakub Kicinski wrote:
> On Fri, 6 Jan 2023 13:55:53 +0100 Jiri Pirko wrote:
>>> @@ -5263,7 +5263,13 @@ static void devlink_param_notify(struct devlink *devlink,
>>> 	WARN_ON(cmd != DEVLINK_CMD_PARAM_NEW && cmd != DEVLINK_CMD_PARAM_DEL &&
>>> 		cmd != DEVLINK_CMD_PORT_PARAM_NEW &&
>>> 		cmd != DEVLINK_CMD_PORT_PARAM_DEL);
>>> -	ASSERT_DEVLINK_REGISTERED(devlink);
>>> +
>>> +	/* devlink_notify_register() / devlink_notify_unregister()
>>> +	 * will replay the notifications if the params are added/removed
>>> +	 * outside of the lifetime of the instance.
>>> +	 */
>>> +	if (!devl_is_registered(devlink))
>>> +		return;  
>>
>> This helper would be nice to use on other places as well.
>> Like devlink_trap_group_notify(), devlink_trap_notify() and others. I
>> will take care of that in a follow-up.
> 
> Alternatively we could reorder back to registering sub-objects
> after the instance and not have to worry about re-sending 
> notifications :S

I did find it convenient to be able to do both pre and post-registering,
but of the two I'd definitely prefer doing it post-registering, as that
makes it easier to handle/allow more dynamic sub-objects.
