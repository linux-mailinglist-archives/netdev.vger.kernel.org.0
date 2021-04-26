Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B812D36B5F4
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 17:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbhDZPkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 11:40:15 -0400
Received: from mail-eopbgr700071.outbound.protection.outlook.com ([40.107.70.71]:8288
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233829AbhDZPkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 11:40:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPFmp+GK3FIZhvuUt+Avqa3BbukJ42X56pFUBnQ/c668MUcErpXDkestybBYeRS2XNXvUv4rUys3UD2pekd6tU2jRVcs6H1Rp9UuVpwJh+c7PHtNVAaNyzZSXhGRpoSN5x7XVTJLulBV9cD4mXIK3QqMJwF2JtaILPGgZqtwItffLc6YFrysTjFv6DsDcO2un5/ipwNLaU7WpO5w0vPFUuod68zEjf131xIrDRwqKRowtcjE/OboHj+7dT5Ymuifit/Wd69p6SJpUqVCfsGPezLww0/uOeOd5KNt6LLxvUJiqewVjFF60APIhnq0WV80hwuhClZ4yQ+7zH142qeHEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAyIvH6kpfBCfm7Rp6bKOWHb7tzs1amp6FWoqm48lZQ=;
 b=EJA546dKXNiinlzEvOLhsvUG8Hgt+L2o3Jo3F4xTz7R1GOQ7VesM4fkS6RxRWDmzXY0EWayi+Y4cnmHyBVgp5SJMkyeVsgnuR8d4a1ZAOyBqUVmo9tPch9jvkvn8RSgNNwD8eRLgsuPww2THT5SwzlSsimoCxgOkmnIWUl4dWvhNs+9d06zYnVU2Cjb5lxKhwh4NM4ZsFljTnAXVe36vEJYpMeMsWK5WVwkY3jEQkavBnJEo4+bwy8bdg5KsgOm2MUc10Be2DCzPJQ5hYTeaSkUeUi/yZxhG0LISUtvI+gMPnjc5wLhZls+x7UjF+dr3fGsLGYHAyiL1Ar9VpI0Cfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAyIvH6kpfBCfm7Rp6bKOWHb7tzs1amp6FWoqm48lZQ=;
 b=aHTjqgyQ7FJFT/RKoMfaeoO3ywCLgGhGjh9G3Tnwy84jOUQzoSEMPlSfbnFOEQ0PLH5CW/3vNjT0JSrFyAugK+QB5oMqr+NqP8oMARIiG+vfua0EyBbM/H7L7o6K9Hw+3tSg31lmyKBRzsjPwE7pDXl96VZZp8/D5YUCikJ9n4ruCtcYWFqpghPlwOh8oxYWf1ZUJTAzlAU7/kTR8K0kb2+0Dwr7HIoJjgSKIAIq/BUA4PC6I0u1q+t4T8XwvxSlWkrVi8V0Q2OhrUyvB9+S//A+d7AfI5dGscemp1RATOMUsUiUky0xfX0Y9+keenwpMKGGbhmRUeSiCJxrk2yTyQ==
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5230.namprd12.prod.outlook.com (2603:10b6:5:399::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Mon, 26 Apr
 2021 15:39:29 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::a145:fd5b:8d6f:20e6]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::a145:fd5b:8d6f:20e6%2]) with mapi id 15.20.4065.027; Mon, 26 Apr 2021
 15:39:29 +0000
Subject: Re: [PATCH net 2/2] net: bridge: fix lockdep multicast_lock false
 positive splat
To:     Taehee Yoo <ap420073@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        roopa@nvidia.com, ast@kernel.org, andriin@fb.com,
        daniel@iogearbox.net, weiwan@google.com, cong.wang@bytedance.com,
        bjorn@kernel.org, bridge@lists.linux-foundation.org
References: <20210425155742.30057-1-ap420073@gmail.com>
 <20210425155742.30057-3-ap420073@gmail.com>
 <ed54816f-2591-d8a7-61d8-63b7f49852c1@nvidia.com>
 <20210426124806.4zqhtn4wewair4ua@gondor.apana.org.au>
 <1e8cda49-4bc3-6f0b-29f3-97848aab18f0@nvidia.com>
 <68b18d15-d472-3305-4f91-5e61f8b60488@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <a1c51f0a-314b-fecb-7ba7-cd10f3a53a53@nvidia.com>
Date:   Mon, 26 Apr 2021 18:39:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <68b18d15-d472-3305-4f91-5e61f8b60488@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0004.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::14) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.78] (213.179.129.39) by ZR0P278CA0004.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Mon, 26 Apr 2021 15:39:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd15c354-bc79-41af-3da4-08d908c97afb
X-MS-TrafficTypeDiagnostic: DM4PR12MB5230:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5230BD693761B6978CF1C6B2DF429@DM4PR12MB5230.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QF+BN7NU6tV6GwkyhLuuYBN6i3OeepC/wkZeuFtBYjSYeND+wosCRP27AU/MN9f7pPJGYqpUl0uHEuzy7FK38rrgsVuMYSgynzKSGiv3e5rxy/vrnqEPq12DyroxgHAi6kOGbR46IaDnZJIN8XJ7lqG7AZHhJdqjhXQTOp8Txrw9A5Qwa4j8ZLNMJ/7eiM9+dk9qWLdJt26zQomKS/SLo0pJ1LRZsQfL3EtUwe9Go2efZNQz67a9PHOpta75j4SHJ7bTEn7m9DAAHtm0aPYu7LCYqRG9BSLRbtD08pfpERweUiJpeTJg82TY2+G3JVqVgfmllQRYl4WXHyc3/9eamXw2x4S3hj/dXH1YzM+h2/PhmJ3ezlufaBk06DHdX7Pekke0XLaajk1AthHcO/JVTQEZSQR36wNl/5gzfYOQ3alcGlxd/h5OYNR51cdsDmlYMItTcutr/GtVmFJkx6BAi5nzAiohnnh8/MPOIsvSW3X3JcjCfQ1GuuzL2/xZydsTcSOPIrZlNeIHuRpgKqfBFgYOeLNlyyFhA05pbYv5uyG8yp/n2znxpQ2h13P36IwMVwBO/OCzLFKtwdFeuUF65vgNym7MClK8ZRax1umA34Gj1HrNGSUi1pIQ4HmXC8ZeRINP7rkiJLnB746yrWnYFYZGP/eRuiokPp7bCUaV2RluVWVMWWCtoBEBPQU65S0a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(5660300002)(316002)(186003)(16526019)(66556008)(66946007)(478600001)(8676002)(66476007)(26005)(4326008)(8936002)(36756003)(53546011)(956004)(2616005)(38100700002)(7416002)(83380400001)(110136005)(2906002)(6486002)(6666004)(31686004)(31696002)(16576012)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y1JBaHhDc1cwQXNtU2Zid09mdHdWTHV5T0VZVUhOWThibC9ybFB2YUFCTWV0?=
 =?utf-8?B?aXVPalAzVGwxODJ4NE5jNTBCVVd0ejRhc3ZiNlpHVDRCYWhHNDUrY1VDV2dw?=
 =?utf-8?B?eEwrSlBaMloxQUZFTEpwdTY0R1hhdy9MT1ZweE9iVkxpZnB5Uk5pckw0Uklv?=
 =?utf-8?B?Y2FaNHlJaXpUcFgvM0tJR2NOdFhnWmRaSVhuMklwOFM3RDc4elBTMFdsTnB1?=
 =?utf-8?B?UjhIYmxqTnlVN3BzWkpxRisvUUtnZ2NiLzAvdTNrUTFGNzdKLzlseW82aXFP?=
 =?utf-8?B?QkhOSXZ4c2xESDhESkdJb3dyVDJucG5VZUNweUw5QnRXK0pXeFNCcTVzMlFG?=
 =?utf-8?B?UHJPY0JLcWh5Uk9BRHZMVDBXMXVlWWMzUkREUngxcjRsUGxrU3NjZmphM0pY?=
 =?utf-8?B?RGNldy9hcS9xeCsyTWxwdDFNOVhQd0FRNndlZG85cHl4MG1Vck1CY0F6Vld4?=
 =?utf-8?B?bm1KYlJRcm93R0Z4Q3lZMFBuRkFEZFR2RHlEVE9uRktEcFdlNTNlZTZkUGtU?=
 =?utf-8?B?d0RNZ1gxVXNaeWFlVmpRaVg2b2NXMHVoczVhMzcwNkwvTTBhYUdXU3J3OWlC?=
 =?utf-8?B?bWFZT0V4akJDcktPUUZhQnZBdTFveXdZUWVqMG1EOXgydkRmbG5UUlBRQzlG?=
 =?utf-8?B?eFdGVmx3UHByanpwMGpzcjg1cS9hcW1FdVNQTmlkV3M4QUZDbmkxU3FHMGhR?=
 =?utf-8?B?MlV0SkJVL2FoVlU5U09MWjBGaG45amdZZWhPQ3JoaGkyaXlXUlpSNDZpcHY4?=
 =?utf-8?B?azV0VW1BQUQyNUJrakJ2WTFVTlZtejlrME50cWNSclhIamN1b21RTnZJbS9v?=
 =?utf-8?B?U09GY0U3TTdOUmhlZkNMdzNrSHY0ZUtIQVdDM1hxR2czS2ZZSWltSkxaVzNE?=
 =?utf-8?B?M1FuNnBGVnB5MHdrYnFZcE81VGh2dmlrazZXZW4rZGRUa2dKZUdLSzcvbS8z?=
 =?utf-8?B?bE84WEFDa01UYXJrRWxhbTRMSHpNYnNKK0NiZHp6dTlDU2pGYzhweWNTVFJ4?=
 =?utf-8?B?UXdEUFlWT3g0bHBBL3IzN0tET3BiYzZlRy90TURsMEtiY2dOR1l4cDVsVnA5?=
 =?utf-8?B?OE0yTzh2d1dLY1MwbGU0WHFDVzF0Mk1pZ3krcEdBTjM2VDd2aGxZTldQb2R1?=
 =?utf-8?B?aURkZEhDOWlZejRjMlBkWUtNenpRdUpNMnZSMUt5MjhzdUg1L29FRVJoQnVz?=
 =?utf-8?B?Y3NrbHVJcG8rNWFOSEZGeHpobkxQbjN4QXoxMnNDK1UweXgzaTFxUWRHdmw1?=
 =?utf-8?B?TCtYSGc5U3pxMG9LS2s4ZlhJcHR4cWRLL1JBTngvcCtxa1czUWo2aHFIRW1X?=
 =?utf-8?B?aDdoS2gwd2xnUXFLTGVJZGdVNnFaWktvVDNYV0haYldsMzBNcC8rQnhRQTk4?=
 =?utf-8?B?RkVMNmxLLzhmWFo0dFRTVURzVGFQUlUzdkhHODNjeGtLTWJjY3hmSTFtNkZB?=
 =?utf-8?B?QmpVL0VFT1R2bEhiRkZvcHFJVFFyUFpYbGdVSUhWak1pOVRNUXdaL3Q5cGpz?=
 =?utf-8?B?bzdsbTNpTGxwNDd3R1NscDhJaDIranBjQStUOHZzb3M2T015Z3p5cFVmZFAv?=
 =?utf-8?B?cWhwOXFvT2JNa2hrWkJEeWg4dGZxSEJ6K2lBME05TmRXRG5RMktjQ1RIYVND?=
 =?utf-8?B?YmFWQXQvMktvMDRxVkpOT1NpV1NCemUwWEp0UHJzc056Z2Q3eE9Wa0wzdDl5?=
 =?utf-8?B?OTJtN1l6c3dWWE1LNFpRK08yOUlvQUxzaU1mRlVlL0l2VHpXNlVzRWk0N2w0?=
 =?utf-8?Q?aGPynl/BAy3VJX3ZYCpZF4qKn0bam8p6hSEkiZd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd15c354-bc79-41af-3da4-08d908c97afb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 15:39:29.5704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZBHE4YhbdYwwP+13HDl58VzZVzPVU2Q/Oc0OixD9dg7bbiwnsszQSd5pIsbxoRHshUc9hQPc3CaF71X9sqOuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5230
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/04/2021 18:17, Taehee Yoo wrote:
> On 4/26/21 10:15 PM, Nikolay Aleksandrov wrote:
>> On 26/04/2021 15:48, Herbert Xu wrote:
> 
> Hi Nikolay and Herbert,
> Thank you for the reviews!
> 
>>> On Sun, Apr 25, 2021 at 07:45:27PM +0300, Nikolay Aleksandrov wrote:
>>>>
>>>> Ugh.. that's just very ugly. :) The setup you've described above is by all means invalid, but
>>>> possible unfortunately. The bridge already checks if it's being added as a port to another
>>>> bridge, but not through multiple levels of indirection. These locks are completely unrelated
>>>> as they're in very different contexts (different devices).
>>>
>>> Surely we should forbid this? Otherwise what's to stop someone
>>> from creating a loop?
>>>
>>> Cheers,
>>>
>>
>> Indeed that would be best, it's very easy to loop them.
>>
> 
> We can make very various interface graphs with master/slave interface types.
> So, if we need something to forbid it, I think it should be generic code, not only for the bridge module.

Forbidding bridge nesting would be the correct fix. I'm surprised this is the
only lock you've seen a splat about, I'd like to avoid littering the code with
these custom lock helpers when it's correct. Moreover stacking most interfaces
is fine even if it doesn't make any sense, but in this case (there probably are
others too) we have to forbid it because looping 2 bridges is obviously bad.

Cheers,
 Nik


