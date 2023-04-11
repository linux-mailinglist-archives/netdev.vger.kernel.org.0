Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149966DE847
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 01:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjDKXqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 19:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjDKXq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 19:46:27 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18C640FC;
        Tue, 11 Apr 2023 16:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681256782; x=1712792782;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=diImu2o1fM1fWCiBklnta4tzUsGwC/bJDHDQOUbL3BE=;
  b=FE6rGXcwKYIdlXPxtasdwesCCYjdP9n3elRH28DmmFbDVUKncBY5Ux6H
   lFrvciADpSHdzdNy+rs3YqbwqwE750EuaoyZrgVEUDEpA+hWgkR1C5w60
   qVzZWg9LbmIcfAlDLQEBDqltGRYEpvSVR7PDv1xVBRH8+qP69D767YbTv
   lzou0wgYH8nf1xysmy3cVB9QPlHBE93i5Ty8eOUt4qcD7aIDCP5tjp4CV
   1MasaaJNyZSAziez/Mq/sslDJmFn4YTt+aTko3X2sjvBxH/PpK7ObZRbB
   JClXElGqJ21dnTGp0ODFr8EJfsrIKni8uEhG8uDifpA+/nUMG2oSXlanK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="327865533"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="327865533"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 16:45:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="832518130"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="832518130"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 11 Apr 2023 16:45:50 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:45:50 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:45:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 16:45:50 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 16:45:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VpepDWmd9eRrlXtH1c6dAlYufXj/PFYHKhBZoP2s3tZYCPKTqHknBm6unP4DHQylk1fFuzyeCq09F3Zc1gi4Rm/rf08QNG60c27MQbJJzhUH7YVDREAy6ul28yRbFma+NWS3+eieBRrxxEx418ARAO/QyQtq5OBAvS0eANiedCRP6rUKdxcdaV0FY5oZlnm5wI7pGja5JJJLK8cIF0Ltj1K+FrvuYDIUzwlZEbaHwTUW83uhjikISpDgFgiT7vck8eScuIqQc5fDNWp/Ccc8TLp9Abaj1U2ta1rr6hOWIOsVJ7pyacWjbLtMbT5cro/NoIqpb2lqq0XV4DxhREVHmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/Nvub5HWCIUuecgrQRZLjFkDWqBbpTjMqZfw7AV6gg=;
 b=FgNPfmusSwVcQzlCkotaVRBwNpIAW1Pw/NF+Eg0xqUBUEak/mLiK4HNttahX6DqaR7Q91TufmCmBLAaawoyGk8h6XxcIWisycJ68t6rzx/8vDkK0eiNqflYa7pAwKYe+wti0THpalKUdiZxRG2cpv+11upHMuRItsJEt+WJb4Edog6ZX3GLKhlevKShf4tTr67o65SHR1IYILPb6L+zLyJkwfMHw0ERvXro3fdBWuuohdqo3tbx2+QoHLjOAzgA5WssbDC0xjN22kKIjxYDMrkAIim+kX8Clz3/KwkL/xrIHMC4U84XoULhAs86tKwOTHBvNnW2D2LXZDzz7aDYpHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by CY8PR11MB7194.namprd11.prod.outlook.com (2603:10b6:930:92::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Tue, 11 Apr
 2023 23:45:44 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 23:45:37 +0000
Message-ID: <9819f309-7542-4182-0e7d-a85b6ac9bf58@intel.com>
Date:   Tue, 11 Apr 2023 16:45:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v4 11/12] net: stmmac: dwmac-qcom-ethqos: Use
 loopback_en for all speeds
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
 <20230411200409.455355-12-ahalaney@redhat.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230411200409.455355-12-ahalaney@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0034.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::47) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|CY8PR11MB7194:EE_
X-MS-Office365-Filtering-Correlation-Id: cdecfa45-3500-4366-04a5-08db3ae6d9af
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RWlSUCIsuePKej8/INdRKQOlnLhjumf4/O3XSxmLfc4X56YvbWuAWJjzDjx0jpHZ+srNusRy9L7HGkX800gx8ZxV3IjEUpxOKCM+vqG78yuRpXzQwcEWsvpoWkPB9peP44fggqyNtR9BIEa71kx2AkS/zvjlVL0PcUdX9LZOqOT2dk96qaGG8WoSqhIC68oCD3Ny6Tsk7jhBCQrQOFYktg01Eyv3S8Upirb/M45HTHhILa0uClpCWDTCQlSoOF41OEWwp2dg4DWu6x0uxpc8cz3Ssi8tmo17c/YL9MURamZG1bTHPEot1rYzFm+0aj+gy30tDyxBN1ToA386qqoV1DSWlXk7VexSZt50kyeS8toB8PtbDIoAG5BC7oSaJP/BA0QMc0UWkY7JD99KhgQSOG1fP/qucSQlQ9Lxx8jNT/pfzQc1smj6M+w/LSlYc2JczrfT9C1tRPXN8fg056/fDb4V84j5Skrkx6fQ4VbXL8vWeR6c/Hl0GTBeVOfBX+jZzYZ2FTmQ54/HFZZEIiK2E7QoLAD1vIzmAmcIVSVUFnQMD+q4pS7ZkSjelsRhxg/MQrFzo7YgBiKwy+jWLJmME/FpgxTGddcGeM2sU8iAVJ1xazVEtSmdoac405tXONks/QGcKS5Mde2SxkAFuNWN8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(39860400002)(396003)(346002)(136003)(451199021)(31686004)(38100700002)(82960400001)(66476007)(66946007)(316002)(8676002)(31696002)(86362001)(66556008)(478600001)(4326008)(2616005)(186003)(26005)(41300700001)(36756003)(53546011)(6506007)(6512007)(2906002)(4744005)(8936002)(44832011)(6666004)(5660300002)(7406005)(7416002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0ZlRTVTZXhocXhzbUhPaXJXcmdnM1lYQ3c0RE9HSEVRUXVGb3RVVk5pSGxL?=
 =?utf-8?B?b0ZjY1VqdFBsMENtMWoxTEx1VFJobUNLYVN4YWk0S2FUMW81YTNqQ1pidnhv?=
 =?utf-8?B?NXdqNUNVTnBQblBsdUtrRitvL1lxSTdkaW9wSkU3RFZQQVNKT0J2QnZwbjgr?=
 =?utf-8?B?bGoxcXNyNks1RlQ3V1dtNWU2Tk1YNFZRZzZFeUR5SjlxelRtTkNGSi8wVG9q?=
 =?utf-8?B?UDE3ZjUxMGFtcHhnZHBEb25US3cvWEkxYzYvTExhWjhlaVlWY2s2STdvU0px?=
 =?utf-8?B?SDhBMjFWTjI3Smplc3lTV2RaV0hlNWF2UDdDanVGWU9qMVd4Y3BhNTRhdUl0?=
 =?utf-8?B?MG45MXQyd0lPbVBBekRLcGhOVEFpK2o2RUtjRTk1djd3aWs0d3pCNVBXVEM0?=
 =?utf-8?B?enlwV0ZsWWFMZmFuY21NS1VEWmVJN25FZXRjcDN6a2hQS0VVejU2TWprWjVr?=
 =?utf-8?B?MFBpUHE5Rnk0eFo4S3Z6QTJUYkNSQ2h6V1ZseHN1M2xzaWhUNnFPVFhES0c0?=
 =?utf-8?B?RzBnUlBSeGd2NVFnQ05LZGdBb3hsQmJCOWxoZDZ6a3pnRVBhSXhydmN2SmRx?=
 =?utf-8?B?OUllMldXanpFNEVvKytaT1E1OEZXcTJQeTZoK0tIOW9FcHRQZy90cjBZYk5J?=
 =?utf-8?B?U1JCUUZVc0x3MEs4RGVpVHVCVVVsc3BkY2hKWS82czIxdHFxU0VhTG9uWU11?=
 =?utf-8?B?Tm9reG56NTlJOWdwd0RGNGZ6c0lxa0gveE5lZnhlSWpjaFlXVU95RmpicHJ1?=
 =?utf-8?B?M0VkM1k2V2xlY09ZZnRSd08xUXhjblNvcjR4WWNOUkx1ZEI4VkRoOFJleUhJ?=
 =?utf-8?B?ZGZwTE1xbWQ5RG1jMHVFN0tXc2RQdU9RdTJZcWxHUkZ2ZTdxaVJuZk5Dd1Mr?=
 =?utf-8?B?QlI0M3J6SFVhemM4dE1xQjBWcklDOXRodmVIdDRlVXhJaWlBZUN1aXhLUWRU?=
 =?utf-8?B?WkRmdjd2NmFMckZUVFIvVXdRdG5zVTNxWlpHMnFURy92VHlnbTlRYStlWjg0?=
 =?utf-8?B?aDVBTnZmeitSYkZybEZrbTdMUXk1QTdqaVBqTEJ4dkhFUUxveTBGY1FwelFs?=
 =?utf-8?B?NG1PVldGa1E1UllCUUNpN3h3aUJTLzhKOVFmdkM2enFscGNRU3RjNG1IZ1BT?=
 =?utf-8?B?L0dFMEx6d1lKR0pka0pIdjVHazRxc3FUdWxmYmJNaXd3RGkwNEcvSUd1LzVi?=
 =?utf-8?B?QmVWZ0hHaC83VDVzSjFFS2x4cXplYWpZbGFGNEgwdlQ3MWxKVEp5M3NmeFJW?=
 =?utf-8?B?LyttTjl6MzhxY09WT1hGRTJ3MHBVcm9rRkp6aWtoTVRpQUxURmhoQ3pmZEpK?=
 =?utf-8?B?a294V21kT2xqMFpQZXRIMmdHak45U29nQU4zTnc0WExkbk1TTk9RbTBkdUZP?=
 =?utf-8?B?dVJSNy9IallrTmJaakhuV3dZTG5wNmZoTmpjNC9GbFZHS3d4QzI0WVovdFV6?=
 =?utf-8?B?Wk15ZXhnRU1oenArU0dNZlZkUlc1bnlOMDdaazgwOUxrcDRDZkZTd09rT1NG?=
 =?utf-8?B?a1kyNkNtd2tOblR5M0FJU2FmWktGdGlYYkxub09VRDVUWVRISzAvN3hRQ1lK?=
 =?utf-8?B?MVdDSmVYeVFYV3BrbnVzNXFybDl3bW9FaXdUb1N5aXNkaGtPODVUTDR6emZt?=
 =?utf-8?B?NzlneU9odkRZY2VhdDNJL0Voc1V3cEIxQ043a2RnUFhqMFNRK3Q2Ky9qTzBW?=
 =?utf-8?B?RTl6dDN1empId3NHNW5wWXVnTEltclNTd2M5c01WNWg5ZWVVOFVoYWVFOURX?=
 =?utf-8?B?eHl3d2RHazFmeXZZeGFuN3FBY05hSFpmVHJtaE10NnJBRWxmVGtjNE4zMlpz?=
 =?utf-8?B?OE8rTVd5QlprRmRMRHUra2kwaUM3dllEdC9OeThIdWszRVBNRTBpbEp5djBu?=
 =?utf-8?B?bGd0Um1XU3JUVEY4Y0c2ZWp6eDFVMGkzZGpDcTk1cENVOEZGREF0c0RDT0FS?=
 =?utf-8?B?N3ZxaWpXdE5xZUZza3lqczhIM0RiRzI3Wlc0cUtTSGtUTFY1NytrYnJ3aGxa?=
 =?utf-8?B?aTB6RUFmRG5CWWJLak96UWZTWGNwemxudFBGOUxndkdqcU1YSXdYWUk2K1lR?=
 =?utf-8?B?UXB2VGNQcy8xWlBmUHhXNEYzajJNczdEa1d2enNacTg1TUdPYzBCcWxFMkFG?=
 =?utf-8?B?SlhpRFdiSzAyZjFLeCs1dUhSR0xLWFZqZ1UwQ2k3b1kvRUViQTRsOWcxQm1h?=
 =?utf-8?B?OVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cdecfa45-3500-4366-04a5-08db3ae6d9af
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 23:45:37.4484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yQG+SNKo7IL+87/PsiRjW6eJOMSc3mNJyqAbedBF7AtvLQIC070+XtKbA3eR6sDPKfXNctSCsGABgX01GjpiJVBSxHN4wWlc+qcHF6FSlbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7194
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/2023 1:04 PM, Andrew Halaney wrote:
> It seems that this variable should be used for all speeds, not just
> 1000/100.
> 
> While at it refactor it slightly to be more readable, including fixing
> the typo in the variable name.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>

Would prefer the future use of bitfields in a u8 instead of a bool in
structs, but it's really a nit, and they're already there you're just
renaming them.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


