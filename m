Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA678694E4D
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjBMRpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjBMRpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:45:15 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEAF1CF6B;
        Mon, 13 Feb 2023 09:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676310314; x=1707846314;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=18gO/DhkVTAE/J5W1hK5vCor0AR6WYHp6E5QaFkses0=;
  b=ORBmXtBelEABTtYdaAkNPzF1jYDZoMfRjVkHHGKCuntpVpOfLXWxIBav
   PHvc/rvkk9Uxkb/ssXNO6KfdIbTq/dRUX95bICZPM+2KlKdZa6vrAax4N
   alEynmpHyfa8M7hvJcDMaf9gWpvGDNM85hUyiQaQVFFQUm+hc9c9Cghg4
   mgalE1E1kuPhXF0nxz5rYXnoaEx/P1KiiL/6Vpj7VIXfp0f3FU/T/YOrb
   BCPQOgZm3sAqXyXafhzCaoybokbjVG+DZVNSi0R55R5tgGSd6Eka9nw00
   GyXxpDs+wXkWjzcxB1CxwrSJf89Onog20dYGtPKRfb1pDGN9sszFVgvEQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="328654660"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="328654660"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 09:45:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="811682244"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="811682244"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 13 Feb 2023 09:45:13 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 09:45:13 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 09:45:13 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 09:45:13 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 09:45:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3QNMHy9e81r/heIoY7oUtaRKWxETPe6DuebU/fBuYGtqeogUMsXPAxTiNJROZTR64sFYpO9H5Bp2rYp0k0uaxC5/ChLF4WGHaN68GkH18Ler7UxIJCXsNWaMeEYwIYTUF5pKNCzbUwv0lauuYS/KM7MXI1A0pcWQKZ4qzY/4Va2TGiM9tndXKZQSJeLrL41J1rqhmaLo3iNzMZssKWTtY7jbQwqA3UXIfh30PuzwkJpyQIbWMvP80ZW8l5arK0JNEav164S7C9rvfAkpTowe2rYJ2s1W3AXvxsVRdxg+JnPD7axq31OE67VLtU4TZbiWOoA+Rr2AgI8dUE7FTAfdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dw2EyhTDJkPOzMPS4hY57zG9tidcrE+Taj3kyYqQ93g=;
 b=O57EfojVxWxWfsaF5y550SWACRdcy9QR7xirbbxiK1QzWhLsMh0aol0sm2LZmOc6ku5fEAm9snYu4OeHBZTamAAL8mJH9k8IHPofEBjVzoDUSzLPO1SRh2R8RuuZkKGJjRPHT2nAUABwisayBj9jn9vnjIyxn9aQEugtlpc1OPYdj/d+RcaWF9TQi6Yckwz/708e1zJ5eppxUe9GQqbVNKC4vJOg+Rw/t6YnAHwAay7FkdKkP/6jDe4S0ImEkKbZEjTh3jv/g/kdM9bKh8TauBsCatMd1EYW4iGCUhwz8qcq7X9rEECtTPGyH/gWa6+HLVz9SMbrx69Crjlm7g9A9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA0PR11MB7305.namprd11.prod.outlook.com (2603:10b6:208:439::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 17:45:09 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.017; Mon, 13 Feb 2023
 17:45:09 +0000
Message-ID: <8b25bd1f-4265-33ea-bdb9-bc700eff0b0e@intel.com>
Date:   Mon, 13 Feb 2023 18:44:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH V2 net-next] net: fec: add CBS offload support
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <wei.fang@nxp.com>, <shenwei.wang@nxp.com>,
        <xiaoning.wang@nxp.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
        <linux-imx@nxp.com>, <linux-kernel@vger.kernel.org>
References: <20230213092912.2314029-1-wei.fang@nxp.com>
 <ed27795a-f81f-a913-8275-b6f516b4f384@intel.com> <Y+pjl3vzi7TQcLKm@lunn.ch>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <Y+pjl3vzi7TQcLKm@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0120.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::7) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA0PR11MB7305:EE_
X-MS-Office365-Filtering-Correlation-Id: 07cd7004-d542-42c5-227e-08db0dea0ce6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T91ErE40Foyfyofj0YdYpObb6y6fDpLFILGxyd1+d38QlXkLutnCn0VrRtAOUHsYgkoIdSkU3zHgiUy1eRLltbi6R3mywYuMoL8YzRg9DK7BnAKL6pmmQDF7gTd0rhLXCIpp6VuACaTWZ95A9LomKgXaiCE2BX1wm7J32QG1oZyE7ZEFnyHFu+SKfXDWHQ9Jiy9XguHQ7nf5bBHQ+kaP9X1cSw2rhTdSDK5/M8sv7kZVc9waTVEgnhPNxT+UEwn2hWtJIUvIgpgWWv6EuZToNMJMFzaPS4DMo6Flbn1bGO2xBNBxTluaO8j8FQ8triTHLtBSjV8EntgaU8TRIMdzui3TwYc38xDJtM/HJY6dc69Riv59MTmZsDozpCfFIBqDFwo7lz0YremsWYAFIAp7H45Mizcp6yvQHc9bvHkHHgWIOEr0xPoban2b1b+3STTVOZyymBTykjJBw0lUFMyzGcpo1iYiZR5KKnNodL5ZkCSf6v1wPVyrrMtwopTaphbV2sg199HygcCuHRtyEkPj48aWBIqHdRlu9sW3TLOzmZozmsBpMG2e87/8765V1wdZt5C6e0e7PA0FHC05NTBw8byqAbZKoEWcKRZ68aLj1WOJqgnsCClpiHiV7TfHe05hYmpaKX5284513Wapkw++iaJO4k/lYv/arxTfO/nvRmlvcOOi/+l8vrASw8pzqfItzcKhELhjXkERegtkvt/C74L5UxEIf40GyWnMaxiqGCs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199018)(41300700001)(38100700002)(36756003)(7416002)(5660300002)(8936002)(4744005)(478600001)(2906002)(6506007)(6666004)(6512007)(186003)(31696002)(26005)(86362001)(6486002)(82960400001)(2616005)(66476007)(66556008)(66946007)(6916009)(8676002)(4326008)(316002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eC95eHJWalNta1BDb2lPQXZ0QUMvRHJFNTlLTmVVNFJzakRmS0dNVXN5WmdT?=
 =?utf-8?B?bjRkZk4vUGRoejlzR1pyMko0QllUZ3BISHFONGJGWXI5S2djU1haYm5zQzBU?=
 =?utf-8?B?R3k4RmhXbUhvZEVWZER0NElYbjUwTCtORHV1Q3hoWUs2ZHBwLzZIR0IyTTZP?=
 =?utf-8?B?cHd1bWlOU3FkRno2eVkvN29jMVc0UlhnYnVJd2FOaVh1U1ptUUROZ3ZjVTlC?=
 =?utf-8?B?bnZDbVRWZS8vT0Q1dXdhM20rMndPSEtNSitDYS9HUzBCTVEyN1VMbmRMVURK?=
 =?utf-8?B?bFhobDMvemFQdElQSE9NOXU4TlI5UWk2THdLL3NOTC9FdWxnajdxWlpMbXYx?=
 =?utf-8?B?YWtqNWlXMTRRb2krTGQxSCtUNkFxRDVLVnlpU2ZlazZwZDNCTFFleVV4VTZ5?=
 =?utf-8?B?THBqRkFROHhlV25uMUhaK0dtdDY4QnprZlZxV3poTnVjNlV3enZrdVA3OUd0?=
 =?utf-8?B?YTRKWHh1cGVDUk1INGtyQzcrMzh1Ykk3dU0ySXZwNTlGb0o3NnJVUTJSNXdV?=
 =?utf-8?B?eUNXYkJocTl4M1V6OVRGSHBHQlJ0MEZPalZDSHlrcW5NN3F5OWdpYlJQQlF1?=
 =?utf-8?B?WUpxbXllblE1YTBSUzN6Q2RvOHVWaXI2SWpwcndjOEpHZzhhMGlsb09KNmp4?=
 =?utf-8?B?MThmd3RpV0MyWlBMQU02ZUlsYUJnWU1GQkduVmZMV0U0U3ZJSTNhM1RBbkxw?=
 =?utf-8?B?YmdCZXFVMk1EWWNPRjlkWllvT0hEYm9haDR0YnpQNk0zYWpvRFRHVWpaNWpI?=
 =?utf-8?B?OHBldk5wWURQaWRIN1pHWThCZk9pWXVOcVpidjRtdUN5aHR1VHZxc0F6VGhI?=
 =?utf-8?B?OG15eE1vUlJvUTRGbHdBZnBJTUdNRVIvbGdwQlUrbTJlby9scTlvRTdBRzcw?=
 =?utf-8?B?KzdBYVRsQVdjcWFKN3AxczM4cGNtYVhINHp5RVU1ajhpazczMi9qdXR6NElz?=
 =?utf-8?B?SkdKd25xcnBzZnNKVDg3UnFIUW5KalV0bHNQZDRkWjV0a0JHUUVMWWlKSlFQ?=
 =?utf-8?B?aXVCKy8vdlJCNC9SUjl6R2NpLzN5a3ROcjJGTlZJTmxad2FWbU1BdW9aOU45?=
 =?utf-8?B?TXBySG84ekg1Zkc5OFRYcW9zMzkvUXA0WmNOVGpZbEtobGxLTDZrOHFTQzdD?=
 =?utf-8?B?UnFXR0I4OFY4QTFWZEF1TmxDenJPRHZ2bUExVzl3aUNXZlk4MlVSOWhqcDBm?=
 =?utf-8?B?YnNaQWVvaEVHVnhCeHZpNlp6eEJVenV1eW43WVg2VUtoV2pUalpJWllYS2pL?=
 =?utf-8?B?cG5XeG9TdUpMRHNDTm00bUpyc1pXbXJXSm1HTSttcmF5SVI4TUxKM0ljMFNw?=
 =?utf-8?B?QmEyV2VybHVzUmVpV3hJVEV4MkpWSHBpVlZWZmJZMGpBcTM0L0poUFltalRL?=
 =?utf-8?B?cGErQmJ4eU1ZckN1Z0dYZXE3NTFMd1JWVk0vT1NEMjNMMklYc0ZjNmZVNXVa?=
 =?utf-8?B?RjNwcDFFdmJQRmdHMWdKTmowYmJCRVBKbXZIREFnVDU3aU83VVREZTBtOXBU?=
 =?utf-8?B?clZCdjhUMTJyWG9zcXBDcWxIdnNSVUh4VFdxU2tpNVNibk9VSStzWVdJL3Bv?=
 =?utf-8?B?RVcrelZ5VExNQmZacm1DS2RQZDl5RWJ1THJkSzlicWRRVkFYakJ5MUVZRWZY?=
 =?utf-8?B?RVpSY2lhV09zcURCanRLOHg1U3pZaC9RVUlOcHdoWjYwVCt0c0lUYUVuZHpN?=
 =?utf-8?B?OWFaV0J1eG5WMzJxTFRsblpEY0lVYnB5RlJtOVZXZGVxODNzczNoRE5Oa2xw?=
 =?utf-8?B?ejZzOGpId2NFRytPL1pNanplcDVwN3l3OGt6RjBwbDZDenBuZ2xzNWo2dWZt?=
 =?utf-8?B?RXJna0ttQWNCSnMrZGJyU1Nuc09UV2pYOGRhYVMwa2l6UGxUYmVoV0d4SWZx?=
 =?utf-8?B?cXBiU3pMOG5rY2dZckRTRHV5TlpnemR2clZLYkRhdzNzV2M2ZE13NFNqRkhN?=
 =?utf-8?B?Y0xwVEtJSFlVWUJCQXc1QkQvK0xNaEErM2tCWGhNTGUxRk1QYmN5SHEvMzdW?=
 =?utf-8?B?ZDZ5Vk1yVFQwZFhtUEloRUFEZHZvbGtWSnB5bVZBamN1TXZVUmF6VWVNWmhW?=
 =?utf-8?B?RUNmdFZmWWxGK1g2Q0JIR1lCODI3c2tJd3NyaGVMdWFnZFZibWF6M2dnUjla?=
 =?utf-8?B?MjdXdUV6aWJUOENGL293WW5UN1BnNURVUHc3MkIvMEFqb0hOVFE1eHNPWXo2?=
 =?utf-8?B?M2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 07cd7004-d542-42c5-227e-08db0dea0ce6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 17:45:09.5942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ITGoI0FGOvpiQnGvxqNQ0LDgHH2W0IjxmWabpjud5sa/1zWjZIoZODYTSIQ9UVTyr0oh9YCnCq6mEMCv4MyLyAFwZuRuPC3QEqwfQL4infQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7305
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

From: Andrew Lunn <andrew@lunn.ch>
Date: Mon, 13 Feb 2023 17:21:43 +0100

>>> +	if (!speed) {
>>> +		netdev_err(ndev, "Link speed is 0!\n");
>>
>> ??? Is this possible? If so, why is it checked only here and why can it
>> be possible?
> 
> The obvious way this happens is that there is no link partner, so
> auto-neg has not completed yet. The link speed is unknown.

Sure, but why treat it an error path then?

> 
>      Andrew

Thanks,
Olek
