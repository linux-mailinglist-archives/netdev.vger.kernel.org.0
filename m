Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124A86247A3
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 17:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbiKJQyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 11:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiKJQy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 11:54:29 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77A81F633
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 08:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668099268; x=1699635268;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9KtrKFKnDcgtM8xaVDBgiiDDHtOq5LYluKllB98/JMg=;
  b=OjMr6CBz5JaNiuWwNA/CiA9ypXYGS4Q6UF02ACLy3MC6JDcHV62Rzlqq
   MjgmXkb9mn3nCI5Z05SucSjxxVisZYq0xStOXZL9Eo6iqtYmizbzjG05v
   efu+rgAAGyyDOuGAwq5QEZmwDtkIfDY6BPcAfWCrQbeg5W9MYZ8jp/INm
   RHTECBq/IwSt7yk8jPsAxrYenezMgxHmXrceFdM3oOYez343etJJpuomI
   zfymmf+rmO63CSGQHVc11K9qc++kC3qhcU9F1R4eiR4suZiN+uKUUTus7
   XMH6c3S7eoN1VOjP4hZ4Um/ELcX5XwCMDl/D9Uc5fxnonsMfEgFWYjVgR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="291766088"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="291766088"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 08:54:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="742923179"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="742923179"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 10 Nov 2022 08:54:13 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 08:54:13 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 08:54:12 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 08:54:12 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 08:54:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KdrkLjrC2OQKZEvFOfjcOhHIlX7m3QL4aP3nVGzoi7h8ej55YgWQg4PMTWJBMEdghuKp60Qy08I7AQmgI1umiNx2jLumWjmM9yCjOw6zw6JkegD0MSSpbFDVwI4yd/7PE+x2BPyirHHWoYbFYr9ko8DkwW3imr6wp508CIIP1La+sIZl/ShRnmgGYSyW9ciFDRqubUuUIq79BYl2o8aFdKGe5b+ckaUWDZq8L3rAdymzkxkeVJNJQg/JNpeqtGLzxKAyuCl3KomVL5Rw/adiKptf4dfmx7h6+9+xLPZc7/EbfCZohdJoQMmpmAcA37vIhHpl6pn8+IvvV4GbzipQLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cmpNA4IMMukxRBqeXTA1IqsMlKjMhwMUEzwK6gRAL0U=;
 b=lbGOgZqFdSfUZisa3kRZ5HhRkZKtQTgSr2eTcPCrumn2k4dgRhzL1CPBRCTZqxQOluGfHRLbCFQO027xya/2TsdZu053Rgn29RBJ4zXAmxym6JLgc2Xokg4nKD5MKpKChGUfY3t3JCIyzDZViqZ4FobKTdAWYFlfZHKMab8DRyc3ZZzet7NfWwaa8ZkXHqXQFjDnmSAXKCARL9rh6vuxmI+Game8EPNSjS/hn2OpHD/SaivV0yTBwgCeHYoBaSsXAmHdhSwyKGK9mOujIr9FbgGhEWJKMl0QCZkFs9TSBDUXLD//MtlvtsTMWIvjoGeuFwgHmfX0s7DEmqKn6ExqrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by CO1PR11MB5156.namprd11.prod.outlook.com (2603:10b6:303:94::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 16:54:10 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634%8]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 16:54:10 +0000
Message-ID: <717a9748-78a6-3d87-0b5a-539101333f57@intel.com>
Date:   Thu, 10 Nov 2022 17:54:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v10 10/10] ice: add documentation for
 devlink-rate implementation
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <ecree.xilinx@gmail.com>, <jiri@resnulli.us>
References: <20221107181327.379007-1-michal.wilczynski@intel.com>
 <20221107181327.379007-11-michal.wilczynski@intel.com>
 <20221108143936.4e59f6e8@kernel.org>
 <de1cb0ab-163c-02e8-86b0-fc865796a40a@intel.com>
 <20221109132544.62703381@kernel.org>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20221109132544.62703381@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0094.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::9) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|CO1PR11MB5156:EE_
X-MS-Office365-Filtering-Correlation-Id: 62ea3dca-79ae-4af0-6738-08dac33c3066
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ZsYSl4QWUEtL/Q8cAmxHiKSeRPolT4i6x6fpghQtEYsGp211MnSLU7KUVNQTdyaFWRGq6gHuKnrJuphv+fPR7IuPCYZuRNljnijfQyunWW+yd41+OhNUa4YxS8KFJZyaDj7eoHdp1pE/LPYvU6pBoT0a9S0kOOgxUdAN2dw6dmmRRrt8t6wVUb4ssE9xSXI022HWtqSNAZKpskTAKlzjICspTTe3rkRClguKLGhQgVlKzu63PRiXi/PCsE8W5cuAOpqO9o3DpEP0KXqL5AH7TKUJbYatmZtzX6a1pgNi3r5bGvBwpNCbySNpksu9UmP1gdx+y5+VDDJnCQbp4KJOw3F9jCy/8pEl1xsFRJcj9fiU2qMKR+upTAx5BTTJuUkJ2Yoz3SvWCRoxVEq9WSK+fwAjIG19LS3s2fgDIokHL/CjI3CpBwfcO3mNopeyFhdWR9hdwHPTJIkPHX+B0jvyLZ32UoUUPCyhleiyGmQ79tG6RY1A6jL75nBsesnPrHgciQaW6GuzjwPqjTdOLeL3uve1kHvHSIw3q055VCeM7BUDVOTIMvwU8szt9nm7lqJ745eZ1vJq2p3D4SllSh/1NQ+iWRxUTNQUtD8S9sGFAK8Q7sz2pEWTA9JFvlhasfwRZ5QqvBjGnC3I8MMYFow62Nr2iaH8nkpvaXf2tvFbhiqh1MWpxKECLvtZ1sCPAgUz+FO/+81BYY4zbmNeyMa9SqOFWePLxkj5M9EM8hBZPDcFc3/ePdZYIqCmcsdW3NYxqZ3N5n+n6S8Xherj7mbYj7dvC0WmYGrruZI+sd2HKE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199015)(38100700002)(82960400001)(31696002)(66946007)(4326008)(66556008)(66476007)(41300700001)(5660300002)(8676002)(8936002)(6486002)(316002)(478600001)(6666004)(6916009)(186003)(83380400001)(2906002)(6506007)(2616005)(86362001)(53546011)(6512007)(26005)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlI3R3NIbjVyLzhVb2JTNmpRNnJSRnlNVWJQcmZqaXgzYXdQZHlpQzN1VjZv?=
 =?utf-8?B?elplNkVrcVBkZ0p2ZFBzMFVsa0g4ckhxTVFvSEwxQTBnSmlFSFBKM1pCMTda?=
 =?utf-8?B?TFRka1hwak9NZzJOc0Myb3c4Vng2WklYR0w5MzRwVnA5ZlNEcHlWU0xMc2s5?=
 =?utf-8?B?Wkh1ZnRERVBVRWdqVXlmcEhDajJJK0VXNnhmaFZqSDhjNlVNSFArUkZhK3lj?=
 =?utf-8?B?cDNKcHdSSys5Ui9PUGdjcXVpT0NoQ0VKTTFMSUJNR1pSRytlRjBucnoyMzVY?=
 =?utf-8?B?LzNCM2hxUjdmdG1SRHkvb2VraTBXejNneG42MDVUSm1IWG1EdTM4RDE5NXZY?=
 =?utf-8?B?V1lYdUpOVDk2Y3pSTlJWSE40cVhJL1dYeUZwWlF5MVJ0aDdieG9qZUR6TXhS?=
 =?utf-8?B?VzNTcVFDY20yTy9wbTgwZmVnTmNKSUk4U0FJVStWaVlxbjFVTlVnR1lvUEdT?=
 =?utf-8?B?UTFkUnpNK2NTVzBlUkc3b3NVK1FRRjZRbjhKZmFoR1A2eTljSHVQYnJFTGp0?=
 =?utf-8?B?bjZCcWpacE9hVEI0c2VpMUNzNlNtTTZjRjAxandPSHJ2ZUdNMFJPdmdoNk5w?=
 =?utf-8?B?c25TdWlkTXNWVGIzc3RVZmlqemo3K21aRGRKc1MxSklEVWRwUzZDekNPSi9a?=
 =?utf-8?B?WXRteG5LTFowUWFWWTJWb2FkM0pOYXR2Y2twRVI4RTlYWm9xKzI5NEx3M0pi?=
 =?utf-8?B?dk9NUmVhMm96aEJ5TFNXbUljWldyd0lEQ3dNMnZuMjlCNDZycWo3YnBqWm1Q?=
 =?utf-8?B?N3IreTdmY3B6NHdDOFA4K1Qyb2F2VDBXeGhQeXZkcU9MNTFSU09SSEYzL1VO?=
 =?utf-8?B?Z21EZ3RtclE1OGVQNktKM2poMmJMZE1xVDVaK2xsd1prRHVBYjNERFV6WEc2?=
 =?utf-8?B?NW5qaGoxN3l0c3R5N2RnMUcwZ0JaUkR2aWVqL1k5VEZkREQraE9DZ1hRaXB0?=
 =?utf-8?B?aGFoWFBqZTY4dTNhSklSNjVESFFiZnBuMWZoVmV4aEJNdFZhNVgzRDFtaGRs?=
 =?utf-8?B?S2x0K1lkeEYrc3BKUUV3MUJRclhaanVwR2FMTWVXcy9UNGFDazRIa2ZKRDRv?=
 =?utf-8?B?Q1B5YTlEdFhjbHhpczkyejM1eUJTQzQ4RGpuODcwSW9RSnZkazVmbnBHVFFw?=
 =?utf-8?B?QjkreUlQSmpQSGlseG5ZeTZoT1ZZOEpQdWRsNmRseXFHbzltcXdENVlvYjM5?=
 =?utf-8?B?bEoxbXMxVlFMN3IzSUlPR3hxYmpIMkRmU0JuTE92UUd0dXBUQVdLRldjNkxL?=
 =?utf-8?B?cG9xTlZ2YUNmWUlLcDVvbU93MzFQYjlhb2orT2F1QitmLzh6NDhQalNJTlRM?=
 =?utf-8?B?NEltQjNTS2tTU3VMNW5PcmMydk02aVVzYmpVMGRKTDJNODlVU0k1SEdWeGNq?=
 =?utf-8?B?OThKdjdZSk5qWW4rcTVRNUxaZHlodXUrTjhFcnhnVno5NVV4U0hsamFDblgv?=
 =?utf-8?B?QUxkY2NXbjh5eUs4RmVTWlBLdU84L1QvZy93OUdET1A5ZVdEdFNFbkZKWklX?=
 =?utf-8?B?eCtYYWdJNmo5RzVMcXZiRDVQM2txK09hSEc5dDZVR3gzMHRabjhGQ2xVNjR5?=
 =?utf-8?B?VzRhUEs0dDU0b2VXOW9TQlhWWGZ4QWgrU0NBKzhyVERxV1htdkxTRy94RCtn?=
 =?utf-8?B?Zm9OQWd1dExNWGtjRXd6cWVkdmNINGZBQ1JYUlp4RGd4NWFWV0tHYkpxWGpR?=
 =?utf-8?B?ZzAwYXh3ZnlsYUZwRW9zNmw0V1ozcWRlYkRVVkdZSnM1ck1WUExCandIZ1VD?=
 =?utf-8?B?L253SEd5RWhnWUJFTzdOL3gxYzBKdnVrY1VuM2FDdHRRTUFaeFhXZ0ExOXF2?=
 =?utf-8?B?dzhwQjF4Z3dnakVWbDdJQ1dBeDJndEtpQzd3dlB5N1RxV1luekk3RGt5R1hG?=
 =?utf-8?B?QWJYMVhyUDlBVE95SitUMXcyTk9aa1I5MVFubkhnY1Nwc1RTZ1BPN1d1eExL?=
 =?utf-8?B?V1BZTDQ5aDUycGh3aXk2UG9KQmhSdm9YcTJOUWE2Ui9jdUhEVmJVS2p5RFIr?=
 =?utf-8?B?ZjJlQ0hmRXVqbTAzUS82VWRtVDdPdHlBYkJ4Yy9EWG55aXF3aCtPNDczQVJt?=
 =?utf-8?B?QWpaTlZGcVdaZVZyRHh3L1lWcHJhbm50VnZaZDVDZHdabGs0UkVwQkpScXN0?=
 =?utf-8?B?OERMUGRkOUlPZjluUGNBY24xRjBqYTNxOUNTOVRvcEVYMm1oWmVjUVBvNmRF?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ea3dca-79ae-4af0-6738-08dac33c3066
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 16:54:10.6161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yLxKLVVnIlWzng2V1ODQv8XPynkevDiQ1LKRjCNOzsyv8UeIxHzPvZ/NDNPnxWP0kGZDQ8CHosSwYqtr8XqtLiXguvlRO6pp1InHWKUmIOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5156
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/9/2022 10:25 PM, Jakub Kicinski wrote:
> On Wed, 9 Nov 2022 19:54:52 +0100 Wilczynski, Michal wrote:
>> On 11/8/2022 11:39 PM, Jakub Kicinski wrote:
>>> On Mon,  7 Nov 2022 19:13:26 +0100 Michal Wilczynski wrote:
>>>> Add documentation to a newly added devlink-rate feature. Provide some
>>>> examples on how to use the features, which netlink attributes are
>>>> supported and descriptions of the attributes.
>>>> +Devlink Rate
>>>> +==========
>>>> +
>>>> +The ``ice`` driver implements devlink-rate API. It allows for offload of
>>>> +the Hierarchical QoS to the hardware. It enables user to group Virtual
>>>> +Functions in a tree structure and assign supported parameters: tx_share,
>>>> +tx_max, tx_priority and tx_weight to each node in a tree. So effectively
>>>> +user gains an ability to control how much bandwidth is allocated for each
>>>> +VF group. This is later enforced by the HW.
>>>> +
>>>> +It is assumed that this feature is mutually exclusive with DCB and ADQ, or
>>>> +any driver feature that would trigger changes in QoS, for example creation
>>>> +of the new traffic class.
>>> Meaning? Will the devlink API no longer reflect reality once one of
>>> the VFs enables DCB for example?
>> By DCB I mean the DCB that's implemented in the FW, and I'm not aware
>> of any flow that would enable the VF to tweak FW DCB on/off. Additionally
>> there is a commit in this patch series that should prevent any devlink-rate
>> changes if the FW DCB is enabled, and should prevent enabling FW DCB
>> enablement if any changes were made with the devlink-rate.
> Nice, but in case DCB or TC/ADQ gets enabled devlink rate will just
> show a stale hierarchy?

Yes there will be hierarchy exported during the VF creation, so if
the user enable DCB/ADQ in the meantime, it will be a stale hierarchy.
User won't be able to modify any nodes/parameters.

I will clarify this also in v11.

>
> We need to document clearly that the driver is supposed to prevent
> multiple APIs being used, and how we decide which API takes precedence.

OK, agree will do that in v11.

>
>> I don't think there is a way to detect that the SW DCB is enabled though.
>> In that case the software would try to enforce it's own settings in the SW
>> stack and the HW would try to enforce devlink-rate settings.
>>
>>>> +        consumed by the tree Node. Rate Limit is an absolute number
>>>> +        specifying a maximum amount of bytes a Node may consume during
>>>> +        the course of one second. Rate limit guarantees that a link will
>>>> +        not oversaturate the receiver on the remote end and also enforces
>>>> +        an SLA between the subscriber and network provider.
>>>> +    * - ``tx_share``
>>> Wouldn't it be more common to call this tx_min, like in the old VF API
>>> and the cgroup APIs?
>> I agree on this one, I'm not really sure why this attribute is called
>> tx_share. In it's iproute documentation tx_share is described as:
>> "specifies minimal tx rate value shared among all rate objects. If rate
>> object is a part of some rate group, then this value shared with rate
>> objects of this rate group.".
>> So tx_min is more intuitive, but I suspect that the original author
>> wanted to emphasize that this BW is shared among all the children
>> nodes.
> Ah :/ I missed you're not adding this one :S

