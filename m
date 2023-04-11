Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E701C6DE835
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 01:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjDKXnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 19:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjDKXnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 19:43:20 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0948246BE;
        Tue, 11 Apr 2023 16:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681256569; x=1712792569;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7Vk9EzIv30HkPnigih7IlZ6Iq+GfdqLTKjIkrPa1UEg=;
  b=eBIcvShLiyoSO3HXYrYr4ODkIqx3laBXfloMutol+R3SYn3k/a7e9cSD
   /j4DyJ0Ba5hi7eJKkW9qCft9wYClCmp/+IiVOQxeLHEFhomYvTPNBTDAv
   fPgK4rnsQ3OH8enP9nqRgIOf9V13hrwI3OIdR5cw2u9rLaq1sbe73w8fj
   JD6OIdJHl6y8HZ4XrwnMJ51d0rOhrq1hhQ+td4UPZ0OXdDp25EDvkAqcc
   TEHNzmwD7I61S8AcIJi1g7d3L2i1v6weW2qoIye2WeEMTevRBE2YBwLjT
   Dwni7fnstsJgtdalbZd5E3qdUXg/9fXFcIcwNANbtrHVhN9c5E73Jgqu+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="406586619"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="406586619"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 16:42:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="812770877"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="812770877"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 11 Apr 2023 16:42:47 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:42:47 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:42:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 16:42:46 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 16:42:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mqb4oARC/JMLPNM2JehOmiMUizvy6127s2iK+L8yL7kuzLiN96xLHTMH9n1MWjbXpZC5502YSKQdNFV35w+KRW6ovxsAXpLODu88ZPkVCinEL21RPEccsjQy4W3jKKW6VNw6YzucOMfV9DyVHXmPN8UFnqvQwzKQZxMbc21bgG4eCkCKjww99WgBXPTRo6IJkdmTYr9NqZc3ibt2L+6ssYlYJM9Qeqn6d6tsUcvOTLVmSvRhq+CZk2M+kKevGsxHYGm6u07IGklfskTmpXlnPNehKFVtXsGi9XRPrP51zb8QygXf9nNBZTbIl/8haaMfWS+9nwihPzEGz2Q5osi95g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S4R+f1LPI3hQ+0Ybnj5yBLaw6C/OINJaGEO/AokY1Zg=;
 b=nrKjVym1C2imm4WB3QKDuRUvmoVSMRjq7EVlYhQgJuMYtw0CcHTj++QZ35F+ItNM/xGKu+r4p2tc5L/bOc5WrK8Ro4/ig6iyvjuBN3PBfNnp+VxvEayhTNCD5j7gyB2Eb+w2d21tPplU2Xy330VTaYsE+EhtnjyUTTSBX13u6O2jRoUtQOPAdr4AJCxvFUOD/+PxgYhF8IMBO9Uz/EkiCkUxSWKlyunAr0bsMh6PKuHWWIbShEAtBrX1L66oM1tM9JmEDi8+0YmF5to/+cQdGxQtBhospu21/U3ueKVh0tEmAH2NXsM75aMCpOzrU+PMMVmy1Y38nMn2TDz3nt6lHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by SN7PR11MB7044.namprd11.prod.outlook.com (2603:10b6:806:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 11 Apr
 2023 23:42:39 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 23:42:39 +0000
Message-ID: <f2acb0ea-90ea-dfbf-6367-c3d44f0e8436@intel.com>
Date:   Tue, 11 Apr 2023 16:42:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v4 10/12] net: stmmac: dwmac-qcom-ethqos: Respect
 phy-mode and TX delay
Content-Language: en-US
To:     Andrew Halaney <ahalaney@redhat.com>,
        <linux-kernel@vger.kernel.org>
CC:     <agross@kernel.org>, <andersson@kernel.org>,
        <konrad.dybcio@linaro.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <vkoul@kernel.org>, <bhupesh.sharma@linaro.org>, <wens@csie.org>,
        <jernej.skrabec@gmail.com>, <samuel@sholland.org>,
        <mturquette@baylibre.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
        <mcoquelin.stm32@gmail.com>, <richardcochran@gmail.com>,
        <linux@armlinux.org.uk>, <veekhee@apple.com>,
        <tee.min.tan@linux.intel.com>, <mohammad.athari.ismail@intel.com>,
        <jonathanh@nvidia.com>, <ruppala@nvidia.com>, <bmasney@redhat.com>,
        <andrey.konovalov@linaro.org>, <linux-arm-msm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <ncai@quicinc.com>,
        <jsuraj@qti.qualcomm.com>, <hisunil@quicinc.com>,
        <echanude@redhat.com>
References: <20230411200409.455355-1-ahalaney@redhat.com>
 <20230411200409.455355-11-ahalaney@redhat.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230411200409.455355-11-ahalaney@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::17) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|SN7PR11MB7044:EE_
X-MS-Office365-Filtering-Correlation-Id: 6179e9b3-b3fd-4570-ca40-08db3ae66f49
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ns/3IwpvQQdc3UZ57OKkkinnBu7kAdMvecpwdfc0In7SIwOC36+DVJ+Sv0E3wdQsGuvZgQXu1i9TtYueDhEVyulWlhSzJAyURXNvd8Qub7yTA04sbkLl9kf7Ht8pFE2TWHOeS9l9YZmXE2ApqkJ/HM9k8t+83jsMceh3GutUl5QZ9m1cbgF8EL5Ru16ZnLV0xtWypHxIerX8agqJiSlctlNCTkwhOclavt09NBKP0M4eCjTH00J/7+zxg6gcpmW6+mlAvkeglU3QJV24WjL9JNz9k4k/yHY1Cbaln8L8jU/eXJhZEygfJJX2vKKUVE8c5PYGG5X/yijJzU2mc+Tv2/Q9e0yYMKtOSJoovHTKzNewJfbvEglvMmu+mHPMjLTaqXUb1IX+QMVbJtQwy/VBvm80ZbeshPOxSeIaZZQNbHDpYoUNdnV5tN2gi4wssReLAxujo0KvFKlcLot3cR1rJ8chJ+feikRX2GwLRzDXsTcU8iCVZqG9JPWSJTYOiXPuDs3aK8z1mA267qasHrQ5xbXzojYX8m6krvyaskADI6Q/W9gC0G7AK3JDeTs2leRttB5NjrEO8LLkbNaR9+HudxlrSUvqQS+5koVRa5ulKtrh51YfRRXHuOJ062ofNGVtWiRkcMikWYnMsRqXULKNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(376002)(346002)(366004)(451199021)(4326008)(86362001)(2906002)(7416002)(7406005)(5660300002)(31696002)(31686004)(66556008)(2616005)(4744005)(66476007)(66946007)(186003)(44832011)(82960400001)(53546011)(26005)(6506007)(6512007)(6666004)(6486002)(36756003)(38100700002)(316002)(8936002)(8676002)(41300700001)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWREWGNBek9XV0hraEd0RjlKWmt4aDhuRXBxK2lxRXp5aGIzRmFBZWZkVlla?=
 =?utf-8?B?ZFYxK0VSNWNKMkp3WkI5L3JBTkppSzUvR1lLNkg1QjdDVEhsY1NGd1ErY2xB?=
 =?utf-8?B?R1NRNW5WWngydkZrbHVQMXF2U2xEaVZLMmZQM0p3S3BtajgrQy9tVmU4cnox?=
 =?utf-8?B?OUV0Sjk0cGpXVVhTQmcySVRyV21POFJHWjEzOXJLZHA5dUhnSXorL2kwRVpX?=
 =?utf-8?B?dkZlRlRra2tOVUhzM2RxeFJCK0E0NTRzSVYvUnVSbElrMXQzL0svb3NOWlg2?=
 =?utf-8?B?aHFFS2ZYWjBHMG8vTTFkcmpJU3RkOGhRZXc0bnAyQ2tXcUl5Tm04QWdRR0lw?=
 =?utf-8?B?eit3UlQ2azh3aGtyNDN1OVFIWGt5REVVcTVtWUxKdGYrUldzOGw4dGcxU0ky?=
 =?utf-8?B?VG8rK2V0WUZGdXBIOWxwS1lvOWFFdWdPbzRSaVVEWGJlSHo2MGQ5UW1tOExt?=
 =?utf-8?B?ZUh6NDZhZVJzTXFsa05wd2dkei9tVlczSkw0RXREVDFMVjVlRDBmYkRzWkli?=
 =?utf-8?B?aFByVHlyTWdwOFV2cGFtbGhEOWhVWGRGeHVOOWEveldlNWd3MjVPZ0x4STAw?=
 =?utf-8?B?NU1GWTA0aVNMWWIvMjlZUVJEZkM0ZG1lV052NmxpZXdXZ29Cc1BzMWV0cEhp?=
 =?utf-8?B?SXRwWDFNcHp5KzBSME9LVjFUaGF6eXdjOXVPWnl5Y1BWdmYrQXZoMzRnbGpE?=
 =?utf-8?B?WjZ2d1dkOEhPd1EzYy9OTmMraU5WQ1pTNElPbWE0WjRGKzlic05yK2RvbklL?=
 =?utf-8?B?YmFzS0lzQ2YrR0pPSFNpbWdITFpuSzY5WktsUlZnb3JqVHhoVkpZdmUxYTVl?=
 =?utf-8?B?cFZCK1NudmNLaHVWcXZoejRydy9ncWxBOFNMMmxSQmFiWk1oeHBBSjcxekRs?=
 =?utf-8?B?MDZWdHBRRjFqVHUwd0NEd2REZXlZWHJ1TnRhVHJOcUoxSzVZV1R0dnh4QzBQ?=
 =?utf-8?B?eDRXbEVOMWJyTnc2eEdrQmhUSDVidTBlU2l2WG4yNVUwMHRQTHlTV2VURzVE?=
 =?utf-8?B?YU1sOVZuRHhyRlVTZ2V5dzZVcUtWQ1dMczVsWlJSalhUOHMxYzZYRHUraU1q?=
 =?utf-8?B?TUE4TVZsaDRCS3RYYVYwcWdsMHFCdlBzemJvSHFMTzhXb1M4Mkw1RVNCT1Jx?=
 =?utf-8?B?cDNEUDd2WlJqT1QrczNvcUsycmRHbWNxYU0rMEJQbHo0N1g4SFFFM1JIS083?=
 =?utf-8?B?dGp2UWNEK3JKNTBNU1o3Z3pVVmZFa003UVppN1IrLzk5NWxuTno3SmhRYmtI?=
 =?utf-8?B?S055bEZ5NWZjWExLVFZTeWNTK3laNGhPL2RuWExidWw0WU5zSFgxelY0c0k1?=
 =?utf-8?B?UnZ0VE1MQlFDaGtMSk9qZ2FHT1ZzZnMwb2dpdFBwLzM5Yi9ubWRpVk1veWpG?=
 =?utf-8?B?aTlCQXdoN1Z6TDEyRlNLaDNsVUpLYlRqK3hJWXBxK1lyek03cDB3QmZBZVkv?=
 =?utf-8?B?Z1FKYTNKOERVUzdVdHM3ZXhTUXppbk9lUTlNNFdUNmh6M1V0SUZqUTRYWDdj?=
 =?utf-8?B?RmozZ0FGY3ZZMWNVbVFzcW52S1dWOGRJL2VkUnFZQS9ZejNrSHQ2Q01pWWZh?=
 =?utf-8?B?T2RzMEorS2Zxclp6MkRhUWZJR1dBRHVhOUk0S0FlWGJnT0g5WHJHSGR4VVo2?=
 =?utf-8?B?c0RDNlJlNjB2MzlIOXFiZVVabUFVM2poSGRCajM3Y3JMb1lMSWxaT011N1lH?=
 =?utf-8?B?djJQZ0dFWTY3bUZ5YThJWE1TRHk1VWVNU1hPOXZyR1puYTVSRE5vcDRIWlRo?=
 =?utf-8?B?Tk5mRFFNdXVjU3RUQTlCUW1mR1R6S0QyN0VZUEM5NjdJVmd0djA3UmtGbm1S?=
 =?utf-8?B?bC9YL0lrQWdIWDF5amtBczExbmplOEV3NDc0cWJKcVNFd3UxNGtrNnYyblVn?=
 =?utf-8?B?MlNTbWZvbDduSzVJcWcvcVJhQzhETktLWkRPeFBBY1Z0ZjlWWENHaWFDTlhx?=
 =?utf-8?B?R21XR2dzcGF4S242U21iUWsrU2YwMWNGSFFTWHd5NitybDlkZWxnbWNqK1Ew?=
 =?utf-8?B?dGtyRVpLS2pKek9KbWVjcEYyWDFaRnR2QTZqdWJLMlk1ZUxod1BVb0JRN3py?=
 =?utf-8?B?anZhbmljNGFLd09jWGdNZXBKWEkxZzlaaHBhYnVaM2NWVmdWcXVSc2hBSWhS?=
 =?utf-8?B?OEV6OXBUSXp5ZXJYaGFwdmNlQzNZKzBlR1V5T3lvUmdqN0QvOE56UWV0MTlj?=
 =?utf-8?B?VUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6179e9b3-b3fd-4570-ca40-08db3ae66f49
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 23:42:38.9858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eCDnL9mN9JJO8PTx94wwYQY7ccijzT9+mCLYsUPN66IsFbbfirpgJEHNFnZ1HTxwDe+XGkFIIc4e76AiiurlSfJOy9XGmVuf4SXHKok6/5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7044
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/2023 1:04 PM, Andrew Halaney wrote:
> The driver currently sets a MAC TX delay of 2 ns no matter what the
> phy-mode is. If the phy-mode indicates the phy is in charge of the
> TX delay (rgmii-txid, rgmii-id), don't do it in the MAC.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>



