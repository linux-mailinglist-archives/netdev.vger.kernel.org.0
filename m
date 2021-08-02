Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A123DD1FA
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbhHBIaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:30:00 -0400
Received: from mail-dm6nam10on2049.outbound.protection.outlook.com ([40.107.93.49]:21985
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229917AbhHBIaA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 04:30:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8xe8ft39ePiTIhvBGkg2a/TBEtBrAdKW8sBGcwn3D1ABEC12yRSLBGUrAkxJ2K/xN3WHwGeo64yyB87vYaG4HpGL2ioKXPxQ1KId8yDG6/9AM5yDeBzZKPdVOIipo9fkSm4czS3g+ICs7GCJl4CGRGMs+vvcpJSFp2peU631VvaYiAQCpn7Oq474wRu5FQPp9KZaD70rhjprEu7XBBCgTB/+MJ8HSx+ISnO8mb80rDoBnyWwwS7JZwBKDZi1bvlCrhG2K+tklyRTHAWpyaH8m5wKLWRBXJB8l579DfcVTaMp5HueeXKYh69lE1LlEiR/b17uVxlN+1pWCmRqsTtOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0D7EEoIpvWez6rGeEQPwL2CrNZi1/ox8oUp8X4UiU14=;
 b=TT6SeoCcSdC5I8iH0Zf9rOPuvArAPq7eC6yhyPMrjR92bLUP38mEaUzM9h5pLvyHEJ+SyoX6f7KGj8ySFd7cj4GD8AC0wCmYfp/eHaEJTR/1iFa9V/euIqyvxXgqp+RiVkjN+rqKtwcyph7uwpbRGxVY3ZnYYyRa0RS717ynU1NShGyycOws5/u1R8oW980XQDOSSX7quPyL8BuW8yCk2O0RUkQiuIkCKalM6QCGYqHQFQ6hB+Do83fygBdXq+l6l0TutrBekjnN5dHDCtAbLHQMuR52CZ9NcDEfP36eW91ueNtVdzwfG5BV5eq900ourXZx2kvyx8c8hnGyWmu1Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0D7EEoIpvWez6rGeEQPwL2CrNZi1/ox8oUp8X4UiU14=;
 b=dSdQ8T0BewUU/6DlF/bbZ5wk0xxQMqFvdOSCNlYSUYAEmpJQUaiKY6K6zLGEdT7wVmQ69qv+IO1vLhNk9FzHI8akitxBTsDh7+Pp4Uos1NpraI0xyagXroNkCDpuzVoHcYDwcKHcy4x5AgmWDPHAX1umkpAS6cifPwLJjj32YnDBr137lf2bljZbqW/g/IzmN57c95l7aCcqpbA/OkpQHnx0LPRaWOdPthV9lGdT+lMM9AX58xoK+ebJbN8nM2yPjidbSmU3qz6/4ajXvj0iYLlTl/X0wjvfezd91ifv00xNcVxwcNOl5HA3+/uCDMqSOGSOp35Rpus7XjXrBzxcTA==
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5037.namprd12.prod.outlook.com (2603:10b6:5:388::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Mon, 2 Aug
 2021 08:29:49 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%5]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 08:29:49 +0000
Subject: Re: [syzbot] possible deadlock in br_ioctl_call
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+34fe5894623c4ab1b379@syzkaller.appspotmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, bridge@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <00000000000014105005c87cffdc@google.com>
 <20210801131406.1750-1-hdanton@sina.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <6f05c1a9-801a-6174-048a-90688a23941d@nvidia.com>
Date:   Mon, 2 Aug 2021 11:29:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210801131406.1750-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0002.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::12) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.206] (213.179.129.39) by ZR0P278CA0002.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Mon, 2 Aug 2021 08:29:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 127b9ace-77b9-4a25-2ecd-08d9558fb189
X-MS-TrafficTypeDiagnostic: DM4PR12MB5037:
X-Microsoft-Antispam-PRVS: <DM4PR12MB50373D8EC96A5569BD1997B9DFEF9@DM4PR12MB5037.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IsEXXWc4C9JqDVvkbVHiHJQ7D5XTQArHLzIPoLk8w6mR8M2O7ztnxWQCoW/HMdmpyw00DzWydabDwWjKMTkHjtEuNeDCEJWsx4v5qSU0BNQGRzuFpebF/hkn8oXA3XcYQ+7SaFsItRLklSYG/GT1YNkCDBxhROzPT/oj41XyBSnyeCC5t8Z02J+qfvbCZ7fx06TEow9F6ebsNpGIjkyLCZ5Y25q1WFfrBsDtp3L3dLPEacgnmDO4ybyx6vhHqk6DHEn+98xFvqhuSHq/UvaYfXUqTR1m8VrHrxuVXjxcI4RSRs793FgGwoChoS2mFvVliHW5rXjVtVm2WeeOY80l+9Kdk8D/kJrWUY1Xgyr8Q7/5aChGRA55MRgw46BNyFVY9lblX3ZyK98yFsi2enMfwT/VZRLQj6Nk1DIRIY03x0HHeKjDiLmQ0ERj/eUMiE1Gf7Y+M2RHiuzxiwE97kB68Hkz8Xrra80e7+WMgTz5rVdkAE8MBYGmrpxNBQWUxYY6OeD4Kvp/6D/tf76SPdkqiGfh0/PDDi1ZUTR+7RAM3iQS1M/BtXMn/4/qCKAsav9UByE+BPyuFCEqJcZJmzSfPuIgy5hy2ekvMNrCZRYHtFlVHGC8tnyIvpJpO9DtTtzzUwNt1GFoB7cc3C8kDmTNgve/l/LIvcmoNsGlKHuN5BUAv0cLWnDJ+EHh4xeqWj4dWkohIjrXbT3n0wfycTXsDdKDZ8IxNlr72QiK+iQV57q3vH9pJFYF32fv06Tue9JwGj1ZGS7KeCEo4pCELwRT7dEqnbpJy1lUsDxy+ABqCn8H6XkAs1bAN2SRGDtMxs+XNKXoT/AFu72m/CGi4QUjKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(36756003)(38100700002)(53546011)(66946007)(66556008)(4326008)(66476007)(6666004)(31696002)(26005)(6486002)(83380400001)(186003)(2616005)(86362001)(966005)(31686004)(110136005)(478600001)(5660300002)(8676002)(956004)(8936002)(16576012)(316002)(2906002)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmU5bkR4NDR2elMyc1c3N2U2aXBpdUFHY0tOZm1oNUdHc3pXTHo5Z0w5ZlNj?=
 =?utf-8?B?ZFJROUNCMTJNSXp4dHM5ZVNZbnQ3RVd2aUl2YlJyUE1DK012ZVpCeG00ZlNs?=
 =?utf-8?B?ZXdYU1FLY0RGcWZHVHllekxsOHN0V1hrK3JLWExycDRSZGFjOURqRElta3pp?=
 =?utf-8?B?cUJORGowRlpJUHR6N3VhbElNWXVScXNvUGw2cWxrSjJ2TjkrTFpqOXRFdmcw?=
 =?utf-8?B?QlVvVWlJaEtGUnJPNXNmOGIzZnc4UXUzd3BnWVVHWVNSem1xSzY4L1VsTWla?=
 =?utf-8?B?L00zc01PMXozWXJadG9YV2pYOG1YZlc0bzh1NE1XclBpVU0xenV5VzBxZkNM?=
 =?utf-8?B?azhjc1FnMkFYV1RNUzFWeW1Uc1ZhVlVjMGN2bTNOa0theTA0cmpnNFlQbWlO?=
 =?utf-8?B?MG1CV0FIU2lxUEdsSG9qZ0tLandrUGJkZDBsZEliUXZySXNSclJoT3ozUzhZ?=
 =?utf-8?B?ZElvTjZTcm5PeGNoRDZDOEhPZ0NKWkJ5aTVWdVI0YmxIYTE2eDFuVmhxRkU5?=
 =?utf-8?B?V1gvQk9XTDNlVjFkYkM4cTdxQWhMZjhFTXNWYlJBNlY1bU1MVnVWOExmQTd2?=
 =?utf-8?B?YzBpM3pkcmgvTmxubkpGNCs4Q3gyVm5VOXYyb21jTkk1L28wV294eERmZFZC?=
 =?utf-8?B?enovaDJwc2JlRkZzTFJaT1Z3aG9UQjBmc1d6VjFRN0NQNnQ3TUVCL01wMTFr?=
 =?utf-8?B?anRrQW9IOTkyRmxBc2RLRVhQM1N3cTEvczYvQmF0VTBSTURIWGg0RGpia2t3?=
 =?utf-8?B?aDNOcmhlMmNWSDdUTW12MDlVVGtBY2dTbytjTjJwUGszL3ZGaDlaem1iZ1VL?=
 =?utf-8?B?eDZEaWo4ZWJ2OVFpb3JjdEI0MVh4R0ZrSmZxZlZqN0luRWVwNGJKKzBwOEVk?=
 =?utf-8?B?UzJ6QlRLWXZnSk92MWZkT0s0U1pBTlorZUVyZ2VFU2N3K0I0Rkg5cXdhdXVm?=
 =?utf-8?B?TCs5WGFTMjc4Z1pLOUxZN0JwMG85UCs4MThVTUNrRXMxSXR4VGFiMnFHZ2Iw?=
 =?utf-8?B?RG5MNEpwTHR2aGFWcWpSc0h1ZG0welV6Tk9LcmVqN0p0V3YrNFNWWndqU3NO?=
 =?utf-8?B?NDA0Zk1XSTNPZjFyV2M1c0NWSFI1bGdlRGxyTGV5Tm1ySlUraS9OZ0cwbHFh?=
 =?utf-8?B?Qmd2M3FUSGJFdDNXV0Z2clUyTDVkTkFudGh3YndMbmhDaTlOMlpmOWNSdC8z?=
 =?utf-8?B?Uy9ZYmIxNGNhU2ljREhESURuWnNXU0hVSmcxWVBaeSswYU1mUFBsMUVHSFhp?=
 =?utf-8?B?WWRZeWJHSWlTL2lQNitYYkI0VEhCRlBZdklQR3FnQTNaSlVoYkN2VmdYeExT?=
 =?utf-8?B?bm1mMHNZb0t2bHR1TUlYcWU4TTh2eXNJbVVCM2pLMTRoUnRDTGQ2M1Q4Rzgx?=
 =?utf-8?B?RTQvbFRVaVhZYzY5dG90K2oyOGNETFJTUHFQTWZnZUFzbnBtVENXYWZKQWZk?=
 =?utf-8?B?WUw5ZWowNnRZbElvYUJzVjNLNmJhdkFQNXJHeTV2ZVVXWUEwUitIVzRkWG56?=
 =?utf-8?B?enh2M3F4dzNYQVd6dFUwbGFVSWQvL1JxaWZEQVRBaC9Qa3A2VW5GS1c1bEtP?=
 =?utf-8?B?ZzdzK2s5cmo3M0dLNEZ6NXRxK1VHbzBzTEV0T2RnU3ozZW1LUXNsczRyUHI4?=
 =?utf-8?B?MmJheVFucnZSR1FyL0Y3RWFJRFRlLzhRcVlUQytSK1AydWpmeloxRE5YeUsx?=
 =?utf-8?B?ZHFya2NyOWJ3UGI4ZWN6dnFqbFp5SExveDY3VndIVEdMNzFtUWlHUEc2QVN4?=
 =?utf-8?Q?czEhj4SVDoRpq7bA1MynMeHh97MqnUEf9Q8JNzn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 127b9ace-77b9-4a25-2ecd-08d9558fb189
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 08:29:49.8152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qNik8PD6gD5lXFy8iOcNa3DLS7rvO43mFBPBnd+ONwRKQIqCmIHeboUbmfLW7hUXn08i102G8+Ieq0WvEMc1+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5037
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/08/2021 16:14, Hillf Danton wrote:
> On Sun, 01 Aug 2021 03:34:24 -0700
>> syzbot found the following issue on:
>>
>> HEAD commit:    3bdc70669eb2 Merge branch 'devlink-register'
>> git tree:       net-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=11ee370a300000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=914a8107c0ffdc14
>> dashboard link: https://syzkaller.appspot.com/bug?extid=34fe5894623c4ab1b379
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114398c6300000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d6d61a300000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+34fe5894623c4ab1b379@syzkaller.appspotmail.com
>>
>> netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
>> netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
>> netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
>> ======================================================
>> WARNING: possible circular locking dependency detected
>> 5.14.0-rc2-syzkaller #0 Not tainted
>> ------------------------------------------------------
>> syz-executor772/8460 is trying to acquire lock:
>> ffffffff8d0a9608 (br_ioctl_mutex){+.+.}-{3:3}, at: br_ioctl_call+0x3b/0xa0 net/socket.c:1089
>>
>> but task is already holding lock:
>> ffffffff8d0cb568 (rtnl_mutex){+.+.}-{3:3}, at: dev_ioctl+0x1a7/0xee0 net/core/dev_ioctl.c:579
>>
>> which lock already depends on the new lock.
>>
>>
>> the existing dependency chain (in reverse order) is:
>>
>> -> #1 (rtnl_mutex){+.+.}-{3:3}:
>>        __mutex_lock_common kernel/locking/mutex.c:959 [inline]
>>        __mutex_lock+0x12a/0x10a0 kernel/locking/mutex.c:1104
>>        register_netdev+0x11/0x50 net/core/dev.c:10474
>>        br_add_bridge+0x97/0xf0 net/bridge/br_if.c:459
>>        br_ioctl_stub+0x750/0x7f0 net/bridge/br_ioctl.c:390
>>        br_ioctl_call+0x5e/0xa0 net/socket.c:1091
>>        sock_ioctl+0x30c/0x640 net/socket.c:1185
>>        vfs_ioctl fs/ioctl.c:51 [inline]
>>        __do_sys_ioctl fs/ioctl.c:1069 [inline]
>>        __se_sys_ioctl fs/ioctl.c:1055 [inline]
>>        __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
>>        do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>        do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>        entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> -> #0 (br_ioctl_mutex){+.+.}-{3:3}:
>>        check_prev_add kernel/locking/lockdep.c:3051 [inline]
>>        check_prevs_add kernel/locking/lockdep.c:3174 [inline]
>>        validate_chain kernel/locking/lockdep.c:3789 [inline]
>>        __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
>>        lock_acquire kernel/locking/lockdep.c:5625 [inline]
>>        lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
>>        __mutex_lock_common kernel/locking/mutex.c:959 [inline]
>>        __mutex_lock+0x12a/0x10a0 kernel/locking/mutex.c:1104
>>        br_ioctl_call+0x3b/0xa0 net/socket.c:1089
>>        dev_ifsioc+0xc1f/0xf60 net/core/dev_ioctl.c:382
>>        dev_ioctl+0x1b9/0xee0 net/core/dev_ioctl.c:580
>>        sock_do_ioctl+0x18b/0x210 net/socket.c:1128
>>        sock_ioctl+0x2f1/0x640 net/socket.c:1231
>>        vfs_ioctl fs/ioctl.c:51 [inline]
>>        __do_sys_ioctl fs/ioctl.c:1069 [inline]
>>        __se_sys_ioctl fs/ioctl.c:1055 [inline]
>>        __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
>>        do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>        do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>        entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> other info that might help us debug this:
>>
>>  Possible unsafe locking scenario:
>>
>>        CPU0                    CPU1
>>        ----                    ----
>>   lock(rtnl_mutex);
>>                                lock(br_ioctl_mutex);
>>                                lock(rtnl_mutex);
>>   lock(br_ioctl_mutex);
>>
>>  *** DEADLOCK ***
> 
> Fix it by doing bridge ioctl outside rtnl lock after checking netdev present
> and bumping up its reference. Recheck netdev state (or take rtnl lock) after
> acquiring br_ioctl_mutex with a stable netdev.
> 
> Now only for thoughts.
> 
> +++ x/net/core/dev_ioctl.c
> @@ -379,7 +379,12 @@ static int dev_ifsioc(struct net *net, s
>  	case SIOCBRDELIF:
>  		if (!netif_device_present(dev))
>  			return -ENODEV;
> -		return br_ioctl_call(net, netdev_priv(dev), cmd, ifr, NULL);
> +		dev_hold(dev);
> +		rtnl_unlock();
> +		err = br_ioctl_call(net, netdev_priv(dev), cmd, ifr, NULL);
> +		dev_put(dev);
> +		rtnl_lock();
> +		return err;
>  
>  	case SIOCSHWTSTAMP:
>  		err = net_hwtstamp_validate(ifr);
> 

Thanks, but it will need more work, the bridge ioctl calls were divided in two parts
before: one was deviceless called by sock_ioctl and didn't expect rtnl to be held, the other was
with a device called by dev_ifsioc() and expected rtnl to be held.
Then ad2f99aedf8f ("net: bridge: move bridge ioctls out of .ndo_do_ioctl")
united them in a single ioctl stub, but didn't take care of the locking expectations.
For sock_ioctl now we acquire  (1) br_ioctl_mutex, (2) rtnl and for dev_ifsioc we
acquire (1) rtnl, (2) br_ioctl_mutex as the lockdep warning has demonstrated.

That fix above can work if rtnl gets reacquired by the ioctl in the proper switch cases.
To avoid playing even more locking games it'd probably be best to always acquire and
release rtnl by the bridge ioctl which will need a bit more work.

Arnd, should I take care of it?

Cheers,
 Nik
