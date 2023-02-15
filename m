Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5DB697272
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 01:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbjBOAHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 19:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjBOAHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 19:07:16 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D362412C
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 16:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676419633; x=1707955633;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qg9pXKfLQFdteulMaE54UrF1tU1QO6YCsNTQaq+FOrw=;
  b=Cu4kSYaLluFnFEG2j/LfjS0mXECxF580ArojVg+ovMPWJdRzK6Z77JAH
   UjmMVUpnYxVI+fiACMTLbNvW0Q2YWtoX8c1qpWG0oEBmom8LNnUyqOM5s
   AD8sRofiyULXL00pe1WQj5z63LeyuRVRjj0InG4CiYN24XyjQejQTSwRB
   inEblSSEKdsEm3jtdD0FzSmTE6HMz9hAr4C4vMlOHkwk7KYWjiHAaop3Z
   SOR2tzaAKXubJfZ0TvWlXQWvuARARKUy2jJj3aiGkRS/zHUkB482/kPai
   dTS/QvjHdy4EumBksXY8Wjy4r3Nsi3vKJvU/4Tz/xjpbQIkI+075Eh2xZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="329020474"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="329020474"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 16:07:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="793289155"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="793289155"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2023 16:07:10 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 16:07:10 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 16:07:10 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 16:07:10 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 16:07:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNva+fPwlOYh4aWYTh4InhrZueKHYYhKzJJKnASuJ0MTn3qa1MRwqAE1iVTPUzrL/u6FrfsPsB+tiIg0R1bk8QB7IJ5f9NnG0Jy6RSJqhhmfS48Haf5tLbYtabAMbOlDyAFQ+bhzaXQQh/uFXb+VN08m2BEkFM6njbxYMmLcJVHRQfrHHqrbWMAgKg+Rjw9w4ojoHT12x4COGMAijegR1bdrFmo8IsTwaT64H2qNxuzV/Tx4hC9A/RhhoIAbxCB6CikXw8wrTgshKq/BCB0HYrmQzmISFel8qoFjbgIoK8Op58AQ5V6cgCvr0Q++roABNRgSStgzsOCoe0ZzeYWflg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MONxkIu0fAdZFaHf3owRv5NNZDqOO390N5UOJDVXt8w=;
 b=RCpS9d5b32o4iycM7wh1QlRPGDr1xurd3um7mCs2XtONNhKKkLVtQ1zCFFgXTbXWZ3QXxxgksNDo52ThFoiUAT+iKNJ07+Ta1JEbee1ur4hm520zAVGj+K4roGYsYpKD3BvKTkxwRkjFTM8ioA/W8xeXuhLMSdhpG9+aAtexleVGLEFudMQGJolFZy2DDok7BeOCS6v9iBI51XTzCxQXizEFF+392NgLwWkjqX269kn/ePUm8XPzyIvJhYlVgbZaLe35gkJjLTDrMvwsFcN+/9h/PsNJkiczcuEFyWMmCUO1s+S9VlefYkZWyKL5I1O1WOVur3LSxT9SSQpibUs5pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ0PR11MB5071.namprd11.prod.outlook.com (2603:10b6:a03:2d7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 00:07:07 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%6]) with mapi id 15.20.6086.024; Wed, 15 Feb 2023
 00:07:07 +0000
Message-ID: <8098982f-1488-8da2-3db1-27eecf9741ce@intel.com>
Date:   Tue, 14 Feb 2023 16:07:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 0/5][pull request] add v2 FW logging for ice
 driver
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <jiri@nvidia.com>, <idosch@idosch.org>
References: <20230209190702.3638688-1-anthony.l.nguyen@intel.com>
 <20230210202358.6a2e890b@kernel.org>
 <319b4a93-bdaf-e619-b7ae-2293b2df0cca@intel.com>
 <20230213164034.406c921d@kernel.org>
 <bb0d1ef5-3045-919b-adb9-017c86c862ec@intel.com>
 <6198f4e4-51ac-a71a-ba20-b452e42a7b42@intel.com>
 <20230214151910.419d72cf@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230214151910.419d72cf@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0055.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::32) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SJ0PR11MB5071:EE_
X-MS-Office365-Filtering-Correlation-Id: 39edd35a-2feb-4275-6756-08db0ee89334
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XonDS+sEBiwo58kFQGPOgca9lOVS+6eQQJdjd53dTC30BKG+dmhkqV0hrT3KPvpGzoGP1NFWvkFiZMZrwZ2Uq+dPnZ6Xv607OxcGntvDFWecIJmgI7yzvO73KlejAi1pVZ4+Af2pwYd3xd6LaXJ/GPFhhr3LM01Y0EOA/TT/QEmq2ymO8s6hAJy+CFS8n3+ipJZ4SPV0gVB+e8CbDVLnyTortpvEvHkl8cWO2WT7gS+v1GW4DKo4Gq8WR+ogfWepY+wn/psGO23VTfpGxzCUSzMiwg+QDpc7PViiRuh8Nl0sl05l4EVmSI52CRKtzpJIFYAk6ByiLXiXNIdyZmgZBIczFNQbaSqUViuXhqyIiNI1+dA9XkLsl+vaaM+clQWsyqTMbQPe5bVPk+aPs6mMTNnHeust/IFxiZAnQ+rq4o6OQgbg3j7RulHjnNpZF8eXTam+HLqQZdceggqdmdJlsnj1mMD+UswH24rdHQbo/iKNsXYlplNFC06tNxi0dkH7SV8ab65kbCv1wYIvGlnP5N82EFQicXVkUMh67bOabNY6aBlZnwR26/+hSFtBVnXllVWLAlRM0287fb/tcF/xhzVvE85E3VRgKVKGusYJJMs6WtZAJqsDUimepPzofp/qhW06/mGfY3n/7wkRzfifU+gIhuGw53IeY3A9fW8q4iogF01Z4KnC7fxpYdzNcskq/77t4I7eQ5pl27lv8n3Jkar6eHyy3lNxZbMrGjE8awc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(136003)(39860400002)(376002)(396003)(451199018)(31686004)(66899018)(2616005)(31696002)(36756003)(83380400001)(2906002)(6486002)(26005)(186003)(6512007)(6506007)(6666004)(86362001)(82960400001)(66946007)(38100700002)(8936002)(66476007)(4326008)(66556008)(41300700001)(8676002)(6916009)(5660300002)(478600001)(53546011)(54906003)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0F5bkxXQlNWQytibmhwZFptRG85cituRVF5clFIQ1ZqWlhPZnZ4b3JxcjdP?=
 =?utf-8?B?QXhZWjE5SmVOV2l5UVYxOGdZOWhnZzdNYVBVNTlvc2VQYjJYMFhBUXdmNm5Y?=
 =?utf-8?B?M3crTk92b0lxZFFwejM3UjloL3U1ZjdYRjFaTnZnNTc2VEs0QStJYUdjekxP?=
 =?utf-8?B?U0wvS2J1ZzU0cld4OUFwaFNzWVJjcE5xNVJzY2tpNjUxTmpoOURHYmlkYi9P?=
 =?utf-8?B?aHZIdkJjUHNvNHdvSXZIOXVVSlN6djdFVGRqTnRZTjhDUnM1ejRVMG1qTWxn?=
 =?utf-8?B?dS9wUVhuK3cxMTFxSDYzdzNrNkZNMGw0b29BQ29EVXhrTnhsbm1lUXNBcm00?=
 =?utf-8?B?K1VNRjFxakhuRFIxcnZkYVI2NHZTU2EzbWw5SHRoVHJ4RkFXNVplckoyK2NO?=
 =?utf-8?B?bW9EckdVSDV4NHFlVE4zQVV2QzRoODhKVkhvOFo4T2JPVGNQd0NjQ0dtRDN1?=
 =?utf-8?B?T1JjVFVFUy9ydE0zbFVhdktpZ3dHeXloeWh4M21MVGd6dkp0eDhUcER6MFUr?=
 =?utf-8?B?RmhNVk9DSlBQcEpLaGNYMDB2LzZLcEZQVHJxRDdVdmpKcFdDejlPdW40UVZa?=
 =?utf-8?B?d3Z6UHVVZDZsNzM0ajFDUW1JNTZkbldnTHNPbkh5QTNLQi9LU3IxM1p3blRO?=
 =?utf-8?B?T0JTZ2JGd2tIbUVZUmFmRzhrQVlkbXV3YWhGTXk3MFRuQ3NDZ2ZMRHZ2TFls?=
 =?utf-8?B?NndFdy84SmV5Nk5JYXIzaFBXSzRxRGRrekpmVGRzUjEzdHRieGhWcHJTM3Ex?=
 =?utf-8?B?YXlpeDNYcElYRTdFTkNVbHZjMXhtNGJGVWFhYWxyZk50N1J2NE1aeG81NGRl?=
 =?utf-8?B?UFFRSUlvNTVIZFhNTWxlWk5LTzFnc01CTVVXR0p4UEdFZWxxQXIrWGsyNW5w?=
 =?utf-8?B?WUtDSnRwQ3RrcFFhNy84c0NTb0xmRHNQTVRUK2RrdWFJVzUrZWNFcjh0akdD?=
 =?utf-8?B?TVpLd1ZnQW00OFZNMStwTk9WUTc4MHBqR1ZIMzdzTEpCM2RvZWNlYkJFdEVS?=
 =?utf-8?B?L29lN2t0Z2VMcHhuYTV0bWJwU2tXRFlnVDRCUlUwU3dJUkVYWlVHbjYxWVRL?=
 =?utf-8?B?MzJoamY5ZGM2VTg0SFQrWjVpOUtEalBua2VhelM1YkxnQ1Z2YjZzVmJKWFZY?=
 =?utf-8?B?R2xrRnJtb3haYzdUWkFQdVBMampXY2FxRXhwQnRsbHhYWHpDN3dpQVdUQXMr?=
 =?utf-8?B?a3pyYzAvYmpRWmJyVmlVejE0Y1F4eWVHSG43d2c3Y0VHQzZ1cFhlaHhqTG93?=
 =?utf-8?B?bytWSHRXNmJvYVVSVzFoQnU5YnBPUFpaOGczcGh1RGpRNnJiNm5KUzc1UEg0?=
 =?utf-8?B?UmFIYkdhVGJ3bzBvM1ZvZEhUNllRbG5UNEY1OWUwcFJpNHI0SjRuL0V2dE4v?=
 =?utf-8?B?b0RlYU1tVmtSRDBhMFd4VVhHZHBpQ05rT2dMUmlIZlByWGNhRitOeGhyUkZM?=
 =?utf-8?B?UmIvM1p1ZEpyYSsrRzk2bnFUSWFLdEYwOEw5elA3RzdJZ1E3Q0N2ZVpYVHRv?=
 =?utf-8?B?V2JtbFlueWszTGFYR3pSSFVqZGdSMG5IK2daZU5TMk1jU0hiMlNUVWRLVnBw?=
 =?utf-8?B?bXJmSFZSTWxnbTA0b1BrN3MwTml5NVllR3ZyK3BZRlJMZWtHcDk2Z1hib1Bi?=
 =?utf-8?B?OVVucDJjbkw4VTUxTUFpY0dPYThzditHNnRITm51MCtOQ1UrY0xzdkMwc2Ir?=
 =?utf-8?B?WDF2N1FuWTFjV1o1RTFLQ1Vkc2EwRkZsVHJVd1AzTElWK2tQd0hxb0V4SGQ5?=
 =?utf-8?B?VTY1NnRDM3UvQnVRaVd2ZWJJS25VWkR4YVI2TzhIUHhPQy9mN1E1ZTlIQisw?=
 =?utf-8?B?anJlNi9WM3c1dlBNbWsyM0lVSDNLc0VydStqSnZTanFxUWZibE9EUnprWWJJ?=
 =?utf-8?B?Z1c1UkJjNHN6dm5UdExxWmpONGFTTGFHSGRiRGZDWGhoWnZJTUhYa0lEVGtQ?=
 =?utf-8?B?eXVzTjNodjZ2aERnMlQ5OFVCQ1ZEWWlVcG9nR3drcms0ckhCRUpld3hydGt4?=
 =?utf-8?B?MEZDNFR4ZG1JUE9nRUhxSzJwZkpnVWJRaTNKaVFMeWNlcE1DMDBubUx5c3VJ?=
 =?utf-8?B?Wk1QOFdmZ21MbC90SWxCM1c0UjRDYi9LMXNBT0ljamRFcUZPKzFQZy9WRGd5?=
 =?utf-8?B?OXdCRTB0aHo5YWJVZHNsOFgwQVcvbktBNnJ4YjFDTzFoM3lmeEgyTThkb0Mz?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 39edd35a-2feb-4275-6756-08db0ee89334
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 00:07:07.0131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gw+NGvUO7EZdSwe80w/IX9pKa/Qs3xjekom4y6seeNlobEHvTu3w0OzpgHtnhJeFYSqR2Zd8VwecxPDcNTTYqwQxrtyhQt/2Xx2YbvZdd5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5071
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



On 2/14/2023 3:19 PM, Jakub Kicinski wrote:
> On Tue, 14 Feb 2023 14:39:18 -0800 Jacob Keller wrote:
>> On 2/14/2023 8:14 AM, Paul M Stillwell Jr wrote:
>>>> I believe that's in line with devlink health. The devlink health log
>>>> is "formatted" but I really doubt that any user can get far in debugging
>>>> without vendor support.
>>>>  
>>>
>>> I agree, I just don't see what the trigger is in our case for FW logging.
>>>   
>>
>> Here's the thoughts I had for devlink health:
>>
>> 1) support health reporters storing more than a single event. Currently
>> all health reporters respond to a single event and then do not allow
>> storing new captures until the current one is processed. This breaks for
>> our firmware logging because we get separate events from firmware for
>> each buffer of messages. We could make this configurable such that we
>> limit the total maximum to prevent kernel memory overrun. (and some
>> policy for how to discard events when the buffer is full?)
> 
> I think the idea is that the system keeps a continuous ring buffer of
> logs and dumps it whenever bad events happens. That's in case of logs,
> obviously you can expose other types of state with health.
> 

Ok so in our case the firmware presumably has some internal storage for
messages and some set of masks for what messages it will "store" and
forward to us.

We can enable logging and enable the modules and logging levels. This
this enables firmware to log messages to its buffer, which is then
periodically flushed to us. The messages may be for "bad" events but may
not be. Sometimes its tracing information, or other details about how
the firmware. This is all encoded, and we (driver devs) are not given
the tools to decode it. My understanding is that this partly is from
fear of tying to specific driver versions.

We're supposed to dump this binary contents and give it to firmware devs
who can then decode it using the appropriate decoder for the given version.

The information is very helpful for debugging problems, but we can't
exactly translate it into usable information on our own. The mere
presence of some information (once logging is enabled) is *not*
sufficient to know if there was a problem. Basically every flow can be
enabled to log all kinds of detail.

Additionally, we get messages in blocks, and don't have any mechanism in
the driver to split these blocks into individual messages, or to tell
what log level or module the messages in a block are from.

>> 2a) add some knobs to enable/disable a health reporter
> 
> For ad-hoc collection of the ring buffer there are dump and diagnose
> callbacks which can be triggered at any time.

Sure. The point I was making is that we need some indication from user
space whether to enable or disable the logging.. because otherwise we'd
potentially just consume memory indefinitely, or we'd have limited space
to store messages and we'd overflow it.

The volume of logs can be very high depending on what modules or log
level is enabled. Thus storing all messages all the time is not really
viable.

One of our early prototypes for this feature hex-encoded the messages to
syslog but we pretty much always lost messages doing this because we'd
overflow the syslog buffer. That is what led us to use debugfs for
reading/writing the binary data. (Not to mention that since its binary
data only decodable by Intel there is no reason to spam the syslog
buffer...)

> 
>> 2b) add some firmware logging specific knobs as a "build on top of
>> health reporters" or by creating a separate firmware logging bit that
>> ties into a reporter. These knows would be how to set level, etc.
> 
> Right, the level setting is the part that I'm the least sure of.
> That sounds like something more fitting to ethtool dumps.
> 

I don't feel like this fits into ethtool at all as its not network
specific and tying it to a netdev feels weird.

>> 3) for ice, once the health reporter is enabled we request the firmware
>> to send us logging, then we get our admin queue message and simply copy
>> this into the health reporter as a new event
>>
>> 4) user space is in charge of monitoring health reports and can decide
>> how to copy events out to disk and when to delete the health reports
>> from the kernel.
> 
> That's also out of what's expected with health reporters. User should
> not have to run vendor tools with devlink health. Decoding of the dump
> may require vendor tools but checking if system is healthy or something
> crashed should happen without any user space involvement.
> 

So this wasn't about using a specific "vendor" tool, but more that
devlink health can decide when to delete a given dump?

Ultimately we have to take the binary data and give it to a vendor
specific tool to decode (whether I like that or not...). The information
required to decode the messages is not something we have permission to
share and code into the driver.

>> Basically: extend health reporters to allow multiple captures and add a
>> related module to configure firmware logging via a health reporter,
>> where the "event" is just "I have a new blob to store".
>>
>> How does this sound?
>>
>> For the specifics of 2b) I think we can probably agree that levels is
>> fairly generic (i.e. the specifics of what each level are is vendor
>> specific but the fact that there are numbers and that higher or lower
>> numbers means more severe is fairly standard)
>>
>> I know the ice firmware has many such modules we can enable or disable
>> and we would ideally be able to set which modules are active or not.
>> However all messages come through in the same blobs so we can't separate
>> them and report them to individual health reporter events. I think we
>> could have modules as a separate option for toggling which ones are on
>> or off. I would expect other vendors to have something similar or have
>> no modules at all and just an on/off switch?
> 
> I bet all vendors at this point have separate modules in the FW.
> It's been the case for a while, that's why we have multiple versions
> supported in devlink dev info.

So one key here is that module for us refers to various sub-components
of our main firmware, and does not tie into the devlink info modules at
all, nor would that even make sense to us.

Its more like sections i.e.

DCB,
MDIO,
NVM,
Scheduler,
Tx queue management,
SyncE,
LLDP,
Link Management,
...

I believe when a firmware dev adds a log message they choose an
appropriate section and log level for when it should be reported.

This makes me think the right approach is to add a new "devlink fwlog"
section entirely where we can define its semantics. It doesn't quite
line up with the current intention of health reporters.

We also considered some sort of extension to devlink regions, where each
new batch of messages from firmware would be a new snapshot.

Again this still requires some form of controls for whether to enable
logging, how many snapshots to store, how to discard old snapshots if we
run out of space, and what modules and log levels to enable.

Thanks,
Jake
