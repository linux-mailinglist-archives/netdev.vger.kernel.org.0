Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89C23A284B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 11:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhFJJdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 05:33:47 -0400
Received: from mail-bn8nam11on2066.outbound.protection.outlook.com ([40.107.236.66]:65504
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229770AbhFJJdp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 05:33:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mza+1FRcljtaQDeKA5BnYBiVmnLz7QWoRu8tgGwQlQeU3/ZsBUs3v8gNivwhRt/c2GdKL6nF70hmyE63xNEg925Q6QSR2plUxf8rrFXK3crCklqluk2G4CGURzPW2Cz3sy0YEKM28p8mlhAxgP7rNWi52Gepr17ikXDkoxnFU6xCrzkc3u0yJ1f74B9eZdC1IATQdlT8Xl7Fwp1HbplOc74b5Hztxg12UYypmt6J3IXdL+yIdz/KFYiIAvZ7lstRnmOfK+NolLLNNpyFSzfP1BjV1Q7rZ+BGhqpBtG63aBO9HNuSBURNKIJR65+OV4ZFEudEquId4Q2KjBNEYhT7Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSGr5Jfuq+jXYPWobdeUrPObx2rjog8fZ5mq+/2a6tw=;
 b=BKR5jkOeHyQ97yaseOC9uFoDThdrzYDzRWgiA2BBh8LSEIpIey1GhBJz0CEWw3OHQkxfsPm6d0y+CyP0A6cVhDKs94UACnxeZ/GGclNPQSbGAYXGyTWWyD2pRWXlfQRfIZHAB7xzHKhcqUxyfwwa2OMKPJvKW9knpNNQz3TxhBMxH3CWthNiY7bmeG++egtFN0unPXwiWDy4Tnh31DFBxygNwCOe8CUqL20azFh7zEE4rVQWjvfIm36iQwHi4so5wwNxIViKZxB/IE/PbVp07CK6VYWopJzg/6WJkYWtC2th6IXQIIJBARm4A/3vn7FJGFaBT60qZV+9sVXtPOEO8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSGr5Jfuq+jXYPWobdeUrPObx2rjog8fZ5mq+/2a6tw=;
 b=Ysz53Zl/7xVg0LGkg504QUZpC0jXlXjAwNwadmxTfURbmmqRtO/ekflGd4dHGSVqgsOnEo/7GFKjPX9fNMfRNmUuNPwWIley9mEB+KNjKPlEnYvpuMLaMmKz0sRLTAUYz/E3BOv2GWWRGnrhyzKe2ocdcBF7L6XbGdXMoj8U2dFcrDaQW6ZN+f+6o6SYNah9opCbgTUhzWlSn9DhJai2UFt6cm+bB+CpSq+z381rtltFLizwQOln9/XhHFEW+yATGEGErPgSSYMKeZddEPGAEGkGCoZMQkdhkU/5b33kzuIDLDCuqxgz4VBMAdYgokdKiuR4UgF05ABOggcGq+r7nA==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5246.namprd12.prod.outlook.com (2603:10b6:5:399::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 10 Jun
 2021 09:31:48 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4195.030; Thu, 10 Jun 2021
 09:31:48 +0000
Subject: Re: [PATCH net-next 10/11] net: marvell: prestera: add storm control
 (rate limiter) implementation
To:     Ido Schimmel <idosch@idosch.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     jiri@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, roopa@nvidia.com
References: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
 <20210609151602.29004-11-oleksandr.mazur@plvision.eu>
 <YMEBcqqY5PopjRKq@shredder>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <b5c527a1-ce54-8679-e0f2-bc18e9351dd0@nvidia.com>
Date:   Thu, 10 Jun 2021 12:31:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <YMEBcqqY5PopjRKq@shredder>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0151.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::12) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.84] (213.179.129.39) by ZR0P278CA0151.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:41::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 09:31:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71db4b40-d3af-4f59-8e9b-08d92bf291d1
X-MS-TrafficTypeDiagnostic: DM4PR12MB5246:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB52467D9F4743A431DE47EC42DF359@DM4PR12MB5246.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +svx3HmgBrm0Zy9DXMNgJYfX+Uy3HE2USftfdFanTG65A7jtA67XxkTdq+SWDtqeMesxhiB7RpUWW6agubgISIRcLqlsuGs2MTOauHAWfA9aSHDTKDtUNgV756w18dnyHIcgGww8VNyTuPTMYNOespqJVbw8omJKa2zSbhZ6A+80+qvOo3NQHPiag7Yrh8Rk2k8WE/um1MGlTCA+29uxLuHhF+T2HzyGS55vGc0b+2aB4RdBsn5+ELkXpWbl6Y1ADvLoaI7j3QN52OjeqnHs214bkrj8Hcni47TuqVLTH/OIvcZQb0OfqSY1MOmk+AV1CbEeJGu02hh9ji+J1m0Ea3pxa/xeWrMpxt8mZvUKj76LFBfF4BBfz/PoIFSaXGCs2AfBWdNd1A5xC4gzLGK4CAGepcpQRbGSscHhcxj4NghqlIFxKA4mNQT11XL90WlusjrezRRGTZtWoA764i591YDorv8BC2wZKnVtuyVd5Hhpx0bib9oCed6d1OtNZUB+Gw+ICVoNFPLOj7mNPQpSy/iVz1fbt1ZKChcGlRwlQ9S3Zw+0h4h7apiDXHRmr5SMhMnUk1RppsgLxftD1vzP53NIS4Q9w9N3GgbPjsM36SK39peeh37rDO1VhkpRfTXf6I/r1E+M6o9s7dibFyq7vt0mj865vkWZoPbtlV9W0fmz/k6AamqL41UWB0j2Kz13
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(86362001)(36756003)(31696002)(26005)(83380400001)(186003)(316002)(16526019)(6666004)(956004)(5660300002)(16576012)(54906003)(2906002)(31686004)(38100700002)(478600001)(4326008)(66476007)(107886003)(8936002)(8676002)(66556008)(2616005)(6486002)(66946007)(53546011)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEY5QS9VOWJUMDkyUHJVWmtrSGMyQVlkWVNKS1FRZS9OOU5UMnpNR2IxSUkx?=
 =?utf-8?B?NnBaRFBYQ1VnMEhqOGtFRkxMSUNxMFFYRGJ1NSs0TjF3c3F4RWpuUk81d1RV?=
 =?utf-8?B?YUsxdzVwNVQzVGNxdnZyRUZsSkZORGpnMXJpckpRRmZxcTlDczJRek1YK0pv?=
 =?utf-8?B?ZzRMN1l1WTI2dTNYSkFSalNVSnFPcU1TOCswbkpRU1ZKN0Z3Si9yWDMycVMw?=
 =?utf-8?B?Y1FqNGd2WDF4OVp4THdiclMwR3NZR0hxZU0zZlRiNkgyblpNTlJZeTlNYnd3?=
 =?utf-8?B?RDFzWWszNWk3Z3hzVG42MW8wdmszVlZpaEZicHpuTEpucVYrWEFuWlZ2MTJH?=
 =?utf-8?B?YnRnSVArQVJFaDh4M3NtSTBhaW93ejZDRWhqaHl5UGp1VWRBRk5RYWcrc2ZG?=
 =?utf-8?B?MkhPM2FQTktraFErZ0dVNUZ1TjVnYWQ5NHo1MFlJZEJ5TmdqYWFNSHFMY0Nr?=
 =?utf-8?B?WktKQVpLY3RqQ1V5Wis0TmpJWUVzbFVyY0VuTlZueno0eDhTYVdkcjN5eEZV?=
 =?utf-8?B?SVpJRWhoYTZ1Yi8rNVVPYW1jNnVwVVdxZHRkTmpBRWY0Z3JuZ0RrTVU3UmR0?=
 =?utf-8?B?ampET3dCSzY3N0dtOFNTNHBHcU5lbmZBUUNRNkxRNnVvUXVTcTd5bEJ6SVYw?=
 =?utf-8?B?cVh2TmIzQXFuMWdhcjZzVzQxZy90aHhWcmJpZXU4UFVXeXNzNVVVTHhiT3NQ?=
 =?utf-8?B?MEdEVFM1STByQkhzaUVpRWxrQVNRUFNuSlV3ZUlDZ3JxQ2h1QWJyL05zc2N4?=
 =?utf-8?B?Z0E2OUI4c2JIMlVmUkg2R2EzbzB5KzQzUU1Kem5NM0ZJbTFaTjB2K2lhVHZz?=
 =?utf-8?B?SnJ6c3UyL0pzYVNmeE1va2FWU1owaTBxMlBmREtKcHFBWVhwOXBIUjZQdWxo?=
 =?utf-8?B?V042OWxMNkNlbmlaVEJQSXBobDVuNnlqNlFMNUlSamV0aytvUVhRWDdBZFJs?=
 =?utf-8?B?RFErNEtWaGtBSkszWlozL3BFUTczS1VhRCtDTVNMQlBsTC8vdXNqUU56RVgw?=
 =?utf-8?B?elpZVFd6Y1JNSGZWZkpBRERicG5rRDFFNERDNThacWJVVjBoNnRlQlZYMlJl?=
 =?utf-8?B?L09MS0QvUS9sZFV5blYrYnJuZnA4MU1lNStsR3JiOWlXRjM3aFdyblFuODNy?=
 =?utf-8?B?b0pMV1JKeUdwNEVOcjVqdEZHbDZFUzVHYi9rU0RZT09ENlBFWStWRWR2OCtQ?=
 =?utf-8?B?b3hXK2NRNzNsRzlTM2x2ZGhaNlBTQXkvL3hNVUtGMlpuTE1XMUpoc2hIa0Ny?=
 =?utf-8?B?anVxU0hoSVBOMmlzMXhmRkl3eEJvWk1nbENGQnJweGJYY05hQXpZcS91TjVr?=
 =?utf-8?B?WFYvRFAzNUNOUTdtZFFIMlFYU250RnRLOHBkSThNNlN5MWhVdVlZeU9mWkpK?=
 =?utf-8?B?NThVNFlMUjhwelRsbkVEL0dUWEpkT2MwdWlYRTZwMDdEY2Y3NWRpNzZ1d1M4?=
 =?utf-8?B?SCswS0FIM3JPTkcxK0JWdnQyYjBXRmRnMXMxSFBFMG9URVpUSDJNNUFEWjc4?=
 =?utf-8?B?d05Od2MwZmRrWGNuQzNZOEhoMnpVQWtwUjdRbmZKdU96dGppdUFIVE9sRmpR?=
 =?utf-8?B?TklkRGtEYTlSazZCdktzVk1WRlFBVnM3UmtCQU84dXozck1DQ0NSZlAxeWdZ?=
 =?utf-8?B?RUY4eFc4aTExV2dMMVNibWtwWDVBd3FCV2tGM21xQndwcmF6NWZEcGN6cjJW?=
 =?utf-8?B?UHhVS1V5UFlrTGNOR3dmam45cFdpUCtuSVdsWjl3ZWgrbEs0MTVUYmJ0TWtq?=
 =?utf-8?Q?QOSU891Ct8BKcQFLCLLKQ0RLZAKRr6vvYOz4gb3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71db4b40-d3af-4f59-8e9b-08d92bf291d1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 09:31:48.0375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R8b2wG9Ljx9Oh9qVs4P8xb+lmb/djV2xgixtUsjuCdG9CSkLHaMrXhXQdYY/2RWvNrgTfNTtQji7PmfXaMl7lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5246
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/06/2021 20:59, Ido Schimmel wrote:
> On Wed, Jun 09, 2021 at 06:16:00PM +0300, Oleksandr Mazur wrote:
>> Storm control (BUM) provides a mechanism to limit rate of ingress
>> port traffic (matched by type). Devlink port parameter API is used:
>> driver registers a set of per-port parameters that can be accessed to both
>> get/set per-port per-type rate limit.
>> Add new FW command - RATE_LIMIT_MODE_SET.
> 
> This should be properly modeled in the bridge driver and offloaded to
> capable drivers via switchdev. Modeling it as a driver-specific devlink
> parameter is wrong.
> 

Absolutely agree with Ido, there are many different ways to achieve it through
the bridge (e.g. generic bridge helpers to be used by bpf, directly by tc or new br tc hooks
to name a few). I'd personally be excited to see any of these implemented as they
could open the door for a lot other interesting use cases. Unfortunately I'm currently swamped
with per-vlan multicast support, after that depending on time availability I could look
into this unless someone beats me to it. :)

Cheers,
 Nik


