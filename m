Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A670A3E5816
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 12:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239780AbhHJKQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 06:16:38 -0400
Received: from mail-bn1nam07on2089.outbound.protection.outlook.com ([40.107.212.89]:17893
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237928AbhHJKQg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 06:16:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTbVlp6p8Arwgv8x+M3Bi3vuHbRQH3i1ZWcdceYxzl3zksxIKGafKqiO6nOY1mpbqKyf8yVSCMefRMOJiWELbqdBuymbojtGARt3ByGyIV/YLgVv8sE/u0+BtvJUC2AJ/oN9ymFTvqjL+3gLD7kL74zMkuHVrwBESo1Tqf4XiDBLNIN2P9syW1Y/TDrg4tvB7cUBTqj+FSr2DnRM82s9cHjufL9nLOzqzjf7E3L/WKaUipfwYcYVeOV5DPy0EuRbOXIRxCcbZIYCv3kMjJiISpQPUfBrP1/Pt0v1058PLjKw8w/e9bgHoamr8l6bfD3I9LFNfTy8kNjidUWXkAScvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m7kvnCIA8Q8CgdEoOu+s5wkPoNsO/hKQY1wjXm85SX4=;
 b=OsrXY1Xwp4Mg0aEfPLHh21gPm5IkCsZE4EyE9nyRErY9q9a4KmlhjUViYkKtdzl15qiRR4opI9gN+/xWX6oONvj9cCN+74sX6HPdIPhxXwhnKynI3edBDUNLP+qFthQx0HPKxy+1A2Yi9MgeCuZdQLm8oDQqHcd+kcsD3TYSTxKo2/zlOaT2M0GVl51ZQFsLlUk37Hnf+Y6/+/Aba9dhf0Hj1Hf9mnBhFUaZG+p+haQsIssM38brI4IZhzjaTsT0ryynPQoyZMI8mGBItFDn+msnnJGgK3L1mJ7d5yy8bPiY9xAQsGPvOtMgZHX7GNIeJ8MqfgMp6cXbpM1TEHDXRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m7kvnCIA8Q8CgdEoOu+s5wkPoNsO/hKQY1wjXm85SX4=;
 b=aY9bI+99eGtfT2nh5kRtUyLtNqGnRY1IQowjE2kCeV/OEpQ6lXE+QXDUnb7BbU0RHOeCoDoOKrviw9Aug8BeyHt5phY+bdFV6lWR9faxYyO9psguXPGemNqoJjokKPPVlnEjyt8jM44OQtDF0v4VjRYGUCyeJfcGO1MLE86mFOTVT3yYYInGAJq91QrkF3G4klBEWZQYyBImvPmjGtxuvPstwaLvqB7gMaIC/bCdXtz7z6DTkx8Lz+uqDlwVGFTsXeW/yZH897I2KQfbQJ4qKS8894vZUdh5EifZ6VgCwfozKy6ndHKRt5UZw2NLX79HtjXpP1O0+utBRh6GxHsKYQ==
Authentication-Results: syzkaller.appspotmail.com; dkim=none (message not
 signed) header.d=none;syzkaller.appspotmail.com; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5461.namprd12.prod.outlook.com (2603:10b6:8:3a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Tue, 10 Aug
 2021 10:16:13 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 10:16:13 +0000
Subject: Re: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when
 adding an extern_learn FDB entry
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com" 
        <syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com>
References: <20210801231730.7493-1-vladimir.oltean@nxp.com>
 <YREcqAdU+6IpT0+w@shredder> <20210809160521.audhnv7o2tugwtmp@skbuf>
 <YRIgynudgTsOpe5q@shredder> <20210810100928.uk7dfstrnts2may4@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <c6d91ec7-6081-85d0-9bc8-569838d8f9a4@nvidia.com>
Date:   Tue, 10 Aug 2021 13:15:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210810100928.uk7dfstrnts2may4@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0030.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::17) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.235] (213.179.129.39) by ZR0P278CA0030.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Tue, 10 Aug 2021 10:16:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21259bae-f338-4dff-5e6b-08d95be7e1b5
X-MS-TrafficTypeDiagnostic: DM8PR12MB5461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB5461B68EEB737FB40576A9C4DFF79@DM8PR12MB5461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O9H6rttG/WQKfNAWqDSTnWrDtoHVlbY7509CK+aEyKYxuSKerO4tU7TYZHWuq3YtCdbOaLq8SkDTHav/uxoVk0ZB80h66poMo4ehxc9jtovorGy3HM4/o5ylNkerb1dbNYSfEYU8TjbovlTXxq/+ADJVdax6NRUdozsX4x0oRHk4Ct3ov1Mht2fr0LQqina2X48OvNjpML7UFxu/d/xoO2spZC915keNhucF6VYsTypbkmB0jicvohkgMqLl3Ip0sFSOUYwo1NTblrOhWNXTV86vNpDLvAIg7Jb4y20TxUdDdcH0lrW5ccAk/lyKKCtn0wEaRtDM5HDuyHmxoo4y6n7kGqzKbK5OL44SAsMd84Hc4Whx4DULoEtVQC9qh0NRBKXkujqN93n8rw/M3kdxevO9x4tuu1lLptJvAQauO8FPzeJcAcsC16eZ36i8sQXHf4MZQazhVBoFQrpwE5EowR+SFUg0qhacOSll6EnbqBN4SypUKC6rcWrkUPZ/dZHdvAjrGWaGhHhOQr6jM3bC2/lhkwmW8MP7ocISfaYxertDATQ1Mj3d9XY7+NxgF1Y0J3nClLKPHaHxVr5JXhrRFW7xpi0qAypdmz1musG3DblSDJVEjSbhyc4ZbQLZTOBmSKYzF+4f151gwbMV14U8GlkLw7fuJBFs9JBb3nRn40XsWBCzGlxgm/Nb5ZWxqhsN9Z7dFet8JBVs9jf/3UsoBPlIi+x1zjHeJOsh1r9PWLA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(66946007)(26005)(508600001)(4326008)(15650500001)(5660300002)(8936002)(6486002)(2616005)(53546011)(54906003)(86362001)(956004)(2906002)(31696002)(38100700002)(8676002)(316002)(6666004)(36756003)(186003)(110136005)(16576012)(31686004)(66476007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTdvZzlJM0E3UFQrTG1LRS9WdS84WW1jQklabkR1d1lVTVREVzF0OTMwWnpo?=
 =?utf-8?B?d052Y0wxVmxuWE9vMktYMG4xck55aDUyQkMzN25tYWVXellmYzdWNFJuVDZ5?=
 =?utf-8?B?bUVrbFlvNSs3cS9tcmY0WGhJUUdmcTFqM283bXY4R0tQVEZhK0pMTTdrYy9w?=
 =?utf-8?B?RGNQZG5BdDZNR0hqNkRmVmdDOEtiblZoRzFVQ0VvbVRHR0NtZGJkcVhYNEk3?=
 =?utf-8?B?OWJWbVNObndqMTk1OStIdTlBcHE0Sm1Lekw1MExwQlJncUhNanNBSjZtcjd4?=
 =?utf-8?B?eVlwSTJDbG9zOHVjUE1sSGhaVm1CNTVtRWdyVUh1d3VodEN6elIzTVJWYldp?=
 =?utf-8?B?QUFoR2tmTE5HRVUvdTFYSkFaK0tDcDhPVXFhS2JFbkxlb2pRVitmcXlncDNM?=
 =?utf-8?B?b2pCaE5OTHVzSjNMcVRQWk1TMFJyS3hXVTFOL0ZPQXlSYnlWVGYwRDlNUGdZ?=
 =?utf-8?B?ejFTRHlDWmhvTExGRTVGRmhMRjExS3pMd0UvdGZ3cFZmQjd0dEFNUDdxU1Qw?=
 =?utf-8?B?K0pLWHMyWXFTemhONzhRRFZxdWZxT3NOYVNDMTdXaVViOHU4Y2UwVXNINUU5?=
 =?utf-8?B?SGpWa1BaZzBsL3FObERRMVdITlhqYzEvTGVJbVd4dHk4QkdLaW9sQ0JObk4y?=
 =?utf-8?B?TFRTK3FJQU9FN05kcTB1Zy82N0VPOUdQOTRKQWtHdTRhL3N5MTRDdVFJMEZz?=
 =?utf-8?B?RW91UlNxcmVKQmhYUE1nVk1VQUlXa2dHOGlXVStmQ21hNlMwL3pRMUFpWldu?=
 =?utf-8?B?ZEgyL2UxV04xd1k1NHJIWk1Vell4cUVHZVgxYVdneXBUeDRTT0xMelJRVHpS?=
 =?utf-8?B?UVpBR0NPZC83MldEalNRVjRSdVNaNitTQ0piQ1FZcFg2clNOczQ0S2ozWWRr?=
 =?utf-8?B?WDNOaEVrY3k3bXFaeWVYNzZMRXpQZUJWemRSUjMrQ1RoREgyN1JTL1lJbmxw?=
 =?utf-8?B?NDZBanVlQjAyVktSQWRLcHdsUWduaEpFRm5ObzZCekNLeDNBbVlGWGt6RHc2?=
 =?utf-8?B?Q3krcUxEamo4enFmVHp4cmhqVlhBMG5Ld0kvdFRVN1dPYWJxMFYyOExoNXYw?=
 =?utf-8?B?OGNkSVhZNmtrVTNxd3R6Uy9lb0gxNkwyek91TFR5S0Zsc1VzcnFiTlRKQ0NS?=
 =?utf-8?B?MkJmY2tSZHkrSGRwSXMwQkw0MFdyd3EzTzhhMDdOckxZeWxNOGVGYUEvMFlj?=
 =?utf-8?B?bTdBTFVLdEpycHVXVFFxdzFUTjJwN1pwbExhaEJIMXM4K01QVWpmUG40ajU2?=
 =?utf-8?B?S2xaemRMN0JWdjhtMUlTbWNzWHNYdER3RFF0MWZRSHVpeS9HZTJ3Z3JNTXp0?=
 =?utf-8?B?Q2FDbGdhVUIybkFHOVErVUxZZGhkaHJ5ZXNGWk1Sem5Zd3o1YlNlL05vaGN4?=
 =?utf-8?B?V1prODBFbTY4NkpSRThwNkdRR1dodWUwdWZ4YW8yWVNNc3VuWVpBNzl0VVFB?=
 =?utf-8?B?VUVQSWp6SHRyTmtoS2JsNlJXUzRQeU5acmRrSkVIZmZYamlqMHlWd3lSKzdO?=
 =?utf-8?B?aWt1WW1vOG4rUXRmcWtjamVBc0VNdzZrK0hrc1owUVgxVHJJK3lLaFVBNE9H?=
 =?utf-8?B?L01GRFBVRDZVQ3V1REMwY2hWTGUrZnNKeGcrbWRxSDF3cW5LTGhEcDhzdGdE?=
 =?utf-8?B?OGJIV1JuWWRCS0dIbFFKdDd3Vm9PSGR3OHIyeC9BcGFaeWs0OGkxMFNvRmQ0?=
 =?utf-8?B?RDNIUnRuRVp5b1dlQzZ2d2FLdkFqMTc3Vks4NU9yWG5EM2FUeHJST1l1dzJh?=
 =?utf-8?Q?CAEYZ521SHBzDlcxJCbMmFfA2H6k+qJoLAs8gTU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21259bae-f338-4dff-5e6b-08d95be7e1b5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 10:16:13.4348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9btijrAd0WpKlGCKn5afqmKI+IKsDnb1z77t8zdLq+0dvqFZgD7GeYo/Tu5yGgjmd2wssJq2Z3iZdZK0DkldHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5461
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/08/2021 13:09, Vladimir Oltean wrote:
> On Tue, Aug 10, 2021 at 09:46:34AM +0300, Ido Schimmel wrote:
>> On Mon, Aug 09, 2021 at 04:05:22PM +0000, Vladimir Oltean wrote:
>>> On Mon, Aug 09, 2021 at 03:16:40PM +0300, Ido Schimmel wrote:
>>>> I have at least once selftest where I forgot the 'static' keyword:
>>>>
>>>> bridge fdb add de:ad:be:ef:13:37 dev $swp1 master extern_learn vlan 1
>>>>
>>>> This patch breaks the test when run against both the kernel and hardware
>>>> data paths. I don't mind patching these tests, but we might get more
>>>> reports in the future.
>>>
>>> Is it the 'static' keyword that you forgot, or 'dynamic'? The
>>> tools/testing/selftests/net/forwarding/bridge_vlan_aware.sh selftest
>>> looks to me like it's testing the behavior of an FDB entry which should
>>> roam, and which without the extern_learn flag would be ageable.
>>
>> static - no aging, no roaming
>> dynamic - aging, roaming
>> extern_learn - no aging, roaming
>>
>> So these combinations do not make any sense and the kernel will ignore
>> static/dynamic when extern_learn is specified. It's needed to work
>> around iproute2 behavior of "assume permanent"
> 
> Since NTF_EXT_LEARNED is part of ndm->ndm_flags and NUD_REACHABLE/NUD_NOARP
> are part of ndm->ndm_state, it is not at all clear to me that 'extern_learn'
> belongs to the same class of bridge neighbor attributes as 'static'/'dynamic',
> and that it is invalid to have the full degree of freedom. If it isn't,
> shouldn't the kernel validate that, instead of just ignoring the ndm->ndm_state?
> If it's too late to validate, shouldn't we at least document somewhere
> that the ndm_state is ignored in the presence of ndm_flags & NTF_EXT_LEARNED?
> It is user API after all, easter eggs like this aren't very enjoyable.
> 

It's too late unfortunately, ignoring other flags in that case has been the standard
behaviour for a long time (it has never made sense to specify flags for extern_learn
entries). I'll send a separate patch that adds a comment to document it or if you have
another thing in mind feel free to send a patch.

Thanks,
 Nik

