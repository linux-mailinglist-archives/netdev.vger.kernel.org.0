Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5525465155E
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 23:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbiLSWKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 17:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbiLSWKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 17:10:20 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD54276
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 14:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671487722; x=1703023722;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R3yGY0xVKhi49ZYkGE1fk6Fvb6BWoHZ4lZVgRXk4jBE=;
  b=DeFGTzUYwJouM3+7HkiyImc4+eA+qBJ/HtOK7iUsrJuyfDEczXPsWJDR
   9HdAppuQh45sPOxH92eujiML6/tLABmJRDwwgahb+u6RfdYRwEoe1nMSh
   um0qDguD1Bbo3MADKVDMqUzJ+UQFrMJ5Y4+DFPUlg2Mvsiej0ouhr+fBe
   nS3ApQgs0RxPKxvXnWrGno48fylSsdzElAUS3wNAi+9gzS2P15VrNxC4B
   Ut3BLCxo7stXHDM/6GY/MgqkVe0x/t/lbuB+/+19zDrLZFZg5/okLnKAE
   SbHBqoYI9m6P/ceXSabtEgXZMieNV7rWmTvnLAlzMvaiR5JSVLj12BzrX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="321362475"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="321362475"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 14:08:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="628476657"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="628476657"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 19 Dec 2022 14:08:17 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 14:08:17 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 14:08:17 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 14:08:17 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 14:08:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CntzqcLBB7Yh1IQeyNg59Ty700SOnvv4lEtD1jFUXi2OXqrsnoZ4Jgm9+Y66x7H7lIN34Z1xZxalSpd1x4PJF+vDYVfyBDm5LLp0vi7PtKqbjlXEpYqKyi3cOAbZCvLBTteye8z72yd5KQgyctSAO/7/oeTMsbQ3deTPK42N5BYG++n5wYQxqhtGBnXjsWbnH7zlO9tdaR5FzcJC2wNW9hi2ulrq+o/NkdaR2PYBij45xfJ92ZQMhqVK72f3SISFkxz+4WYblU09q9VYo7eIwS2EddiG8AjOaLtxpf7YjPqZLVsX/6xut+sAXctPhhBWLeKbtQOmLRc1oqVbL3xYhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94gAvV07maA4fy56ztVWu2Fbmj0rBCoiLBzMFfL39eo=;
 b=gcEdYCXWN4DulM1MsxBziC9LvAbk6vAJiyUEdACfbL0Pf35ls7pniwDde1QC2UC1i64xIHRgBHcETLbo+AZoo54OcZxEAPHaTUVBM3KIjCth9Uy9/m07WWhgdntt5exOX91cugQKHlJ+Otzvg8c/XZAGAAnbkJHEUqhm1M6e9qcBi8/ibzULXCeBR29Pnhesx+dlJcx9vNgDKPOZbsNq4rBlt4mpFVcYxe+iRl3/V2LEYhVavz3GE1VfVgyJ5aKH4L5hB86VJXlJEiG5t/UdSZQ4yK4IieqSz0UHOK4KeXxrHeMeaavaVQVdCYYlBXq5maI+yBWJ+XRiWg+L+2t9fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by IA1PR11MB6394.namprd11.prod.outlook.com (2603:10b6:208:3ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 22:08:14 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d%7]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 22:08:14 +0000
Message-ID: <234f11c3-b83b-3c7b-2ee6-8e90a761cae1@intel.com>
Date:   Mon, 19 Dec 2022 14:08:11 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 04/10] devlink: always check if the devlink
 instance is registered
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@resnulli.us>, <leon@kernel.org>, <netdev@vger.kernel.org>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-5-kuba@kernel.org>
 <84151471-4404-d944-417f-2982569f44da@intel.com>
 <20221219135541.6e0a7cfd@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221219135541.6e0a7cfd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0106.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::47) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|IA1PR11MB6394:EE_
X-MS-Office365-Filtering-Correlation-Id: bd3bf001-fa9f-4c10-23fe-08dae20d8620
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bdhOTcE7Y1Xw39VESJ09QhqsA7HaitN0VzsTYZESgEIzNEt4JX73oX23ffT+6Nfnak8Ph1SPaB4Rrq9Om4PRRiiA7YlfEhHbxpmuGyGQt2wBSTNJ5pCR5zHr6Abu9mf//JHTRKkWFUA39Kt4ytfCERErQvBwVx05r4muC5oyF1Br/DmwZ49jWJrcvnWJKG8Bb3J1+SH7XeHRed6FUtPjkPN3wTskU8DKDo+xdZer41XkATGsJFoSxZ1vhMszRpMieP8IXeWrZRRy5Vl2rwMOcaTxeWj7DXphr5kfTGYnJpl+vAegPCH2/AvZSVYquGfJ1rwjgSUgXe8Sl7+EzuAkCTAfAIsjQyalOwDHoSL9by66roSZ0Y/L7OQGY5ftgBWXGMC5qDqbQUBAG1WhRbvOEbtBSjYWrSPPEbWp5ozNu4IMebTszUiKAVBVEzyPeA0dXT5hBhwYE8UkQf8ciOlXpHP8+FEjt6Ff28nrGORaN9xzWD8ChdJe0gPuneeBPpU3YRg2ujp7MqJSdJCKXUHyB9iT7tvhPdmzVxzRBo/qiIZUz/SCxzbThGg62cCyNWF/DmY0BtIqRbxZQ/ryRAt8s/z6aDt8Wo5pJnzrjkfRGOjci2b/wkF+OJjm22F8g/93kaYTogmSgsLVK7WJsSPbIJ93jPDi3QXVBZI41hgDYB5zteBv8ZG5mELAlOUvKqCIq3eiQB4ylXIyKeSDoOBJMyTDMVW2fSkQqR9ZFLIiOLE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(39860400002)(136003)(346002)(396003)(451199015)(2906002)(31696002)(38100700002)(316002)(53546011)(66556008)(4326008)(66476007)(66946007)(8676002)(6486002)(6916009)(2616005)(86362001)(6506007)(36756003)(478600001)(5660300002)(83380400001)(6512007)(6666004)(26005)(8936002)(31686004)(82960400001)(41300700001)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1FHUHZSR3VVMWNSMnFqQjlvUHJTMzl6RTBYNHYrbnhCN1ZSUHdNR29YQS84?=
 =?utf-8?B?eFFIbjZPRlo4enovL0tyYTdGMzV1bXoramxlVTFYTi80c3Y0SXB4clkxOUM4?=
 =?utf-8?B?enhNWFl0UU9lMlNrRUF4bGNuRmpqTHVIWW9sWGRxS0F0ZVJ6Zlk5eXltS1Mr?=
 =?utf-8?B?RytiUDJ2YytwS0pBeDRESlNDay9tQnVzd3NTb1BFN09mdzJMdmpNWnp4SWdT?=
 =?utf-8?B?OVU2cW5jNHBCaDJqaldEbDJSM3p6Tm13M29ndXduMEMxdk8wV3RuR1BLRDF2?=
 =?utf-8?B?NW03bG9NcU1Rai85Njh0OXJhMDhpL0N3RTNybVNlU0E0UlpkRnN2QnUvM25F?=
 =?utf-8?B?MGRCWkxVbm1UZHF3aHZmbjZLSytybitLa2RBU0JIS2EzWm1KSEN2M2ZraFZn?=
 =?utf-8?B?dnpKeE5Kcm5ZQm1WRzNSK1RvQUNOWHNQVTJSVVUrQTJlMVY1bGNlRHlTZHpB?=
 =?utf-8?B?dFB2MVp5QVNNSVlZVmdPaE00dE1vWlBNc0dVU3Era1pibDFOK0pzRkJUU1po?=
 =?utf-8?B?b3ZSRTY2TnV0RkRJM05UbW52RHpVNjlpL3dsVDNoTUwycXUvZU1UTlJGQ3RC?=
 =?utf-8?B?enc5ZWxQSEdFNmZ0ZlFYZ3pQODY0azUyRjNMOFZkVlhBZ1lOUTlkUlJFK3dq?=
 =?utf-8?B?Vy8xdTUyREluNFdqaHdRRmhoN1V5c0NWaTAyT2ZEZTFJSFU5N0xHY0FBTWZz?=
 =?utf-8?B?N1RVMzB2ZzhqeWhNcDFyQXZ5ZUVTWGdYRjBqVFZ5Rit6WUMxbytWcVhWdnlL?=
 =?utf-8?B?S3VsdVRmRndoWlR0NWdINWV2YjVLVWdVNWgwcGk0dFFMblVmSFp0ZFlJQXZ5?=
 =?utf-8?B?WjVXSS9RcTJFZk9OT2hXZkllZW9EOUV6amtwZjJHd2FVTFpJbjFPOFZOeUZy?=
 =?utf-8?B?MzhDTHpzek9jSEJFY25HME5VbzFpV2ZFTy9xMzErcWZCcVVRbFhJMExQTmJL?=
 =?utf-8?B?ZTlSOXVqV0I4TGxaRklvbDhFTmN4NkhhNU5FVDNFeTJwVVBZcm1TdXMzWEI1?=
 =?utf-8?B?dnpsZUJ5d21tenlZcFZHMS9SaGNQVjJBY1pOK1M3RmZ3U1dPV1B1d2ZITlRx?=
 =?utf-8?B?OG1lS1MxSWlnU3RJK0RTcXhKSEFqbVlzZCtWZW9VQ1ZVaDhEUDA2cjZETjMx?=
 =?utf-8?B?VmN2QTB4WlB0djdST21HRiswRW1yNnlKK3YrRitRQTEvTUZydzdzYkdzYm1k?=
 =?utf-8?B?bjV2N3hhMndNaDdCL3BxZ0xZY3JnNkJmRllLRlVFaHYzOTZJTGFja3Nic3NB?=
 =?utf-8?B?dmlrZlR1Y3hCVEhzV2V3Vm1UbXBmNGlodGgxWStMeUt1bWgrUktsV1YyUkxP?=
 =?utf-8?B?enpNK0pxVjlOK2tmMWxBUDkraXF3cFA4Uys3bnRhSzdTV3VkY2U0ZVVIbVlZ?=
 =?utf-8?B?d2tiWk1IVlVEQzROVUdiMFBvcXVyWUV5bWUvM1dWZ295NnA3WmVkbEdDWUZG?=
 =?utf-8?B?TjVyOEdlSHBrbEFqSlZaY2REYkhScWNCVEpvb2dLWEZnQ1UrNWhUVldGTXcx?=
 =?utf-8?B?MHZNTDEva3d3Z1Q5OUh0OG9Ycm16UGRRa0xrbUJTVlB2bERSdjg3SmlDbnJw?=
 =?utf-8?B?QlFsTEhXSlZobkhjVEpTc2lmRGYvYTdNeG0ybHZ2MFVpREpEOUNVSFJjSlMz?=
 =?utf-8?B?Y1doMHptQlBhY2Q0WEtqczJ0K3VzQlRCUWd6RGplcnRZcktQMzU3b0RsdG9v?=
 =?utf-8?B?MUxUVERBZkhyVzNJaDhlODhvbnlsb1JWYmFpMFI5N3hqcUNGUTYvcUs0dkdU?=
 =?utf-8?B?cGNhSm5xZ2VvRURVSG5KOCtRaS9kayt5cTBwdzVoS2Z3b3F0UGpVQWFUdmJU?=
 =?utf-8?B?M0E3bzVaVGg4dVl3ZTdOTzc2MHRLLzV6OTM5SElrcnZpYXVNakdyZGIrcDNX?=
 =?utf-8?B?TDJrWWNLNFYwdXFtV1R3Uzl2QWFoVlBVTWx2SmFxSE53ODVUeVBQdDI0RTZh?=
 =?utf-8?B?RDBad1M0Q1o0OGRNV1g0dE5CUHp0T0VRQzNhSUhmci9UaG03TGZ6dlJMQnF3?=
 =?utf-8?B?ZXB5VHlDK1B6cVNDSm9NbWx6Ry93TFpFZDhGZ0VEMTN2MEloQXJxbktGcTZv?=
 =?utf-8?B?cHFCZUJhQ2lQRUJmMEliMW9BaEVuWC9iaWhxYVBIRkQ0eEJqMjNuRDM4SDJ2?=
 =?utf-8?B?RmtrUXJiZUFtbTFkSko3U2tGNUV5Ri9MWWVOc1J3YjdxSlhvUUJBY1VUbTNJ?=
 =?utf-8?B?M0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bd3bf001-fa9f-4c10-23fe-08dae20d8620
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 22:08:14.1551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: izgsCaOd8A+Aj4QNm1gbj/L3Pu7GyfL7cHWtgeF6yXsfGRuptUF2v5p0Y7vTgqJDXuLHVOaFAvi5hxmjMgxJQ4xEoNkhnzkL69f55o91DAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6394
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/2022 1:55 PM, Jakub Kicinski wrote:
> On Mon, 19 Dec 2022 09:48:54 -0800 Jacob Keller wrote:
>> On 12/16/2022 5:19 PM, Jakub Kicinski wrote:
>>> Always check under the instance lock whether the devlink instance
>>> is still / already registered.
>>
>> Ok. So now the reference ensures less about whats valid. It guarantees a
>> lock but doesn't ensure that the devlink remains registered unless you
>> acquire the lock and check that the devlink is alive under lock now?
> 
> Correct.
> 
>>> This is a no-op for the most part, as the unregistration path currently
>>> waits for all references. On the init path, however, we may temporarily
>>> open up a race with netdev code, if netdevs are registered before the
>>> devlink instance. This is temporary, the next change fixes it, and this
>>> commit has been split out for the ease of review.
>>>   
>>
>> This means you're adding the problem here, but its fixed in next commit..?
> 
> Yes, I can squash when posting for applying, but TBH I think the clarity
> of the changes outweighs the tiny and transient race.

I would agree. The only reason I could think it to be a problem is if a
bisect lands precisely on this commit and you happen to hit this... what
are the side effects of the race here? If the side effects don't include
significant issues I think its fine.
