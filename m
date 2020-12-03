Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59D52CDFEC
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 21:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbgLCUrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 15:47:52 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:45739 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgLCUrv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 15:47:51 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc94ecc0001>; Fri, 04 Dec 2020 04:47:08 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 20:47:08 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 3 Dec 2020 20:47:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAPu2qmWtwsZzLqQdN67UsDtmCmOEKd55L4qSKxmjkVFDH18Pz/k9uhHLDlEpr2+4Qmi5aZWB7QYL55ZKvJKioL7BbwucIi1dp3dhi5KJvTVg2l/C7fCsWiqESrM24vPPH4f41Z7trFrqHzskFaeT3QAuAWhgzy3XmhSLdBEmIzJ1mwT9PUPnb6BrPT9l1men07yTS8Pl4xkvJ+3wCx2SUKQaPgS356vvNzxrlCABZbCdJesXOsHiq/s/bKItXz/ZJr5qG0F01ysTTLuBcbncs4zOEuJteegWLFMgE5tPW/vzdoPQIz2mp5kTlnE+ZU+bVZghr72dZZ1vQBlK3VVZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzc7tc2zewgI6SWogj6d3NxIJGvvB66309VQ8/Hva1k=;
 b=HfqtYcPBYN7xvb4BhQWno4a5rM+26EP7qXm6W1VqMXypK/yEGcRTzCDuIiNfK4nrLBChlE+xcTRxs057y8S62ncA+MWp6F2jLVjFM7G1zHKIFeN3tMWqZbzWjXrYNQ0fNgqdaeGCk6FEcVRTPKlGyUtp8Z9NF6nq1BMo3NNPAzVEEk/n+yqmbEy9YhJ/eMbFhjbc31/LzlDe6w9iIXgIzw5fowd1SOX/Pdfeu007LtTmfCMK7AU/hIqg6DDfrWBiNfpT7xn0LrwNyfop8IgquYdaT9u06W/1H0OzqF21ono+VhDSNQyciS9GHv9GG0+KsZDHztaMA4u94vqJxHiVgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: c0d3.blue; dkim=none (message not signed)
 header.d=none;c0d3.blue; dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) by
 DM5PR12MB1707.namprd12.prod.outlook.com (2603:10b6:3:108::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.20; Thu, 3 Dec 2020 20:47:05 +0000
Received: from DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a]) by DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a%6]) with mapi id 15.20.3632.017; Thu, 3 Dec 2020
 20:47:05 +0000
Subject: Re: [PATCH] bridge: Fix a deadlock when enabling multicast snooping
To:     Jakub Kicinski <kuba@kernel.org>,
        Joseph Huang <Joseph.Huang@garmin.com>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>
References: <20201201214047.128948-1-Joseph.Huang@garmin.com>
 <20201203102802.62bc86ba@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <bd84ca4c-c694-6fd2-81ef-08e9253c18a4@nvidia.com>
Date:   Thu, 3 Dec 2020 22:46:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <20201203102802.62bc86ba@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0020.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::7) To DM5PR12MB1356.namprd12.prod.outlook.com
 (2603:10b6:3:74::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.129] (213.179.129.39) by ZR0P278CA0020.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Thu, 3 Dec 2020 20:47:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5a3be81-db59-45b5-0534-08d897cc97f5
X-MS-TrafficTypeDiagnostic: DM5PR12MB1707:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB170701961678D3F00E2636EADFF20@DM5PR12MB1707.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 52FM/Jev4NnMk22j52Bn4nANSqiBMNn5XhcSrV0X8C1kVUtqL+/A/nR3NtIpRO1NTfh4D/CyEJifEjEigPRM1D4jTm3UrK+BNZV99pk2GftKsEaZbM9aJKFd9+yHc4AyeNTeeYSM9LsnTb3Vmg2UbeEI4EGgoe/zP+EMfAEJcX64/sLidE6K6SCZ2DIWSKBjUjrhz/dJy8E5LNFGk8rTeOUjBcMwQf/vAp6FpoxT6e/ClNHJroSaogw852W5eMBoFAN5OMgwEP7lL2OIgYub2obQzFLLzedGpZL2NLyNiv67Vbv863ZR476cjZqDtqSNzYMzsavXpJHM8GmAPXeWGkAPFF+uzQPH7kWUktVHbY2pu3HiPjPRnNlL6rTR8oj2MltMtnGpTfGmAiUe4Mr9ldzMZtIDoZEeMeV50k6QWSc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(66946007)(956004)(4326008)(6486002)(316002)(2906002)(8936002)(16576012)(36756003)(8676002)(66476007)(54906003)(478600001)(31696002)(66556008)(31686004)(5660300002)(2616005)(26005)(110136005)(83380400001)(53546011)(186003)(86362001)(16526019)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MDB4TDhzNGJ3TmdWalhwWWRub3p3SmlVRlBVazM0bGZESk9QbnlOODA2MlBX?=
 =?utf-8?B?Q1pJbG9Rb2hKR0tGenBmazRKYmFPeGJRNDZzU2hzRXUxOGpLVFZEY21ieU5N?=
 =?utf-8?B?VTg4c0VQeTlEeXBlSm9VY21aNWFYanpva0k0STQ5Nml6dE5vRlI5UXViNnpx?=
 =?utf-8?B?TmJOYkRVcUl0VUljSktxOWl5cU9uMVd4U3QxYjlISHFER2I2UFZqSTF1ZU1v?=
 =?utf-8?B?d09xVG9uVE4rcmNydHR6TlVIdnJPaG1EMlRWaGRPeUxHUUdNNFMrajUySzlZ?=
 =?utf-8?B?Q2RHeWtRTHFGemRjSlJya0dGbnZyUnpEWE13K1ZnaVc2Q3UwbFNsVzJQb0xj?=
 =?utf-8?B?RmkwbFVwYkZqM3BuVUdsRGY3elZyNWdqUVlEdUxOODJPVmZjMjNZbjZJS1dS?=
 =?utf-8?B?dmVHWDZ2TGdXcmFhQkFXSGR6c0FoMGxDQjJYWTZLSG9yYnJWbUxJeHpHblJF?=
 =?utf-8?B?aXAxNjhrNXI1UGZpQU9BTERuRGNVRWtzTlBhcmNvd2U0b0dCWjg0VVpsVkcw?=
 =?utf-8?B?QmZlNjFKSTBPVVZBTWVBVVIvbkVVSkNJTTRGMDhWbHU5Nnd4Nk5QVjlKWE9j?=
 =?utf-8?B?dTMyaTdjcnFWMkEySlNlMFVpN3BnSXpqb3NqTVY0aXJ4RG5pN2dlbWNsZnE0?=
 =?utf-8?B?cjlQc25VN2lnQjlpZzBZNEJnRlQ4UlR2UmZoQ1QwZXNVNERkT2dtc1pHTHNS?=
 =?utf-8?B?YlgrR1U3eTJWOGtkbTNzN29zdWJBRnlKU1AxZ1doZ0VTd2pEM29rZmR5WkNQ?=
 =?utf-8?B?NWlielVDMzFVOEpYcWZFMGRBVXB6VkhqY3ZFTlBFc2pqYk5FbmdxLzZWb0ZX?=
 =?utf-8?B?T0xlb285TjE4dWc4aEtWSDJqUDM1YU5tUXZYWGFqemFETjU0TWZyeG9SWVFU?=
 =?utf-8?B?cEQ5OTY0c1BUTFB6M0c2ZlQxUzVPOGoyRzA3aENUNG1EMFJITUtJVkJtWUtX?=
 =?utf-8?B?SFYzVUVhRmZzekxuZE9XY2ZiMlJJZUplMkNpZFJQcGpTcWpaYVhDYTJqSHJk?=
 =?utf-8?B?NERKbEFZMWVLK1U0U2owWCtuMGxwQ2J2Sld1M1cvQVdNRU5yRkdXejN4M1R5?=
 =?utf-8?B?QnhzN3pLNTd6V2lER2t3MXV3bnVmdVlMbVg2OHdiTk80cHcxT0tmbFYxc3BU?=
 =?utf-8?B?dHJiYkFzRWwrSVN3OUJpcWVaaU9CNDZ3SGgyU2xmWXpaUVhsM2RIeE45TC91?=
 =?utf-8?B?VjJYQW5iRFYzak9ZNjFJdk9Bb0hDbThwcTFIV3daRXhUZjhEamZFSjVERkMz?=
 =?utf-8?B?R1B2REpkK2xYRStmNlN0bnpIUlhZNk04bExzbXExSkhUUVNHTWVIcTlKNUU1?=
 =?utf-8?Q?BJ6+VoES7QStP+NDMxxJVs2U6rNxFjSSCJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f5a3be81-db59-45b5-0534-08d897cc97f5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 20:47:05.3444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XHHi/Cd4g821nPNrngAuZmBOj0cDW2dxoGCX8Oo11vAH02JMgLZnbDr3Ausmj35vFkCtCnrr4weAhI0BpKk/ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1707
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607028428; bh=bzc7tc2zewgI6SWogj6d3NxIJGvvB66309VQ8/Hva1k=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=D74LeTiQlmejx7WKTvtyVU9XzsQAp87BDlR2RsYehxAv3UzDtWSbki/nKqAds/+sm
         aj+lKAb1Kj+5U16QL/RZHaIKMuhXoPznZT5baBe2mfz9pNwzxsxavlYfATAP+BWpQv
         GjtIi+ffi6om1jJ/kQLJ9B4qJGGQRElM9t9idSpXS491xHeV35QR44bHsfltT+1Mkt
         XSfB7df6kCL47P3qcrFfdr1IXzsNCi5wQUyPS1RKl45vIjb+DLywjOj5ryvFw0nJyS
         joIvfmbg7+GYpojw718R/J4GerOfpodpyw0gYZoeEW2pxjCdrLwl7AfGTl1HgFmMU+
         B2F0fDUOwk9cQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/12/2020 20:28, Jakub Kicinski wrote:
> On Tue, 1 Dec 2020 16:40:47 -0500 Joseph Huang wrote:
>> When enabling multicast snooping, bridge module deadlocks on multicast_lock
>> if 1) IPv6 is enabled, and 2) there is an existing querier on the same L2
>> network.
>>
>> The deadlock was caused by the following sequence: While holding the lock,
>> br_multicast_open calls br_multicast_join_snoopers, which eventually causes
>> IP stack to (attempt to) send out a Listener Report (in igmp6_join_group).
>> Since the destination Ethernet address is a multicast address, br_dev_xmit
>> feeds the packet back to the bridge via br_multicast_rcv, which in turn
>> calls br_multicast_add_group, which then deadlocks on multicast_lock.
>>
>> The fix is to move the call br_multicast_join_snoopers outside of the
>> critical section. This works since br_multicast_join_snoopers only deals
>> with IP and does not modify any multicast data structures of the bridge,
>> so there's no need to hold the lock.
>>
>> Fixes: 4effd28c1245 ("bridge: join all-snoopers multicast address")
>>
>> Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
> 
> Nik, Linus - how does this one look?
> 

Hi,
Thanks, somehow I missed this one too. Need to check my email config. :)
I believe I see how it can happen, although it's not straight-forward to follow.
A selftest for this case would be great, and any traces (e.g. hung task) would
help a lot as well.
Correct me if I'm wrong but the sequence is something like:
br_multicast_join_snoopers -> ipv6_dev_mc_inc -> __ipv6_dev_mc_inc -> igmp6_group_added
-> MLDv1 (mode) igmp6_join_group() -> Again MLDv1 mode igmp6_join_group() -> igmp6_join_group
-> igmp6_send() on the bridge device -> br_dev_xmit and onto the bridge mcast processing code
which uses the multicast_lock spinlock. Right?

One question - shouldn't leaving have the same problem? I.e. br_multicast_toggle -> br_multicast_leave_snoopers
-> br_ip6_multicast_leave_snoopers -> ipv6_dev_mc_dec -> igmp6_group_dropped -> igmp6_leave_group ->
MLDv1 mode && last reporter -> igmp6_send() ?

I think it was saved by the fact that !br_opt_get(br, BROPT_MULTICAST_ENABLED) would be true and the
multicast lock won't be acquired in the br_dev_xmit path? If so, I'd appreciate a comment about that
because it's not really trivial to find out. :)

Anyhow, the patch is fine as-is too:
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Thanks,
 Nik

