Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBAEC3FFDD1
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 12:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349028AbhICKFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 06:05:40 -0400
Received: from mail-sn1anam02on2088.outbound.protection.outlook.com ([40.107.96.88]:43919
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349012AbhICKFT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 06:05:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZApwfxF7342oSZHLgn022O0kfy9zsDZGmejbqLHyOi8JEpzXNIA2Ql+LmCOVjqddPz0L5aB4bVWW/Hh0helug+sLQMs+b//0ajPRF/2itRXKyLnwO7E7UJuBBZ9hs8eVQa1BcjNzBBmNp9aor7nrc1acfvKhkEoIshVf/mzyfbMS1E5hT8WMK144vAbc0N6+DbtyAwoc7igH3Lvy68LLWpXKzUu3s425cOcVRGIlu/S1AQBu/aF240ir+52bS1HEiB16jeIUEe14sCr74QqPdSaDtai49xFKB9+3CtlxrCuDlHAHUGBNhGb5AoI7plLrC3C55mzrAzD+wFRU001YYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=OB3hJWEopcX3jrwOqJ3eZxM/ybrrEZHeg5OVrHaLSSk=;
 b=BZHpzVgWPZpwpXjtjxkSF6eyyfj8zceIKXGYHJ0a7x37IYK2PsXOhbA07TVk3RheeYmtQnatlPHyFILOXE3d0aDkKhtZgIv0NzfKWU6WS/ZmbJM8TLumdslrU+LrMNftpMRy4V95uiLLSkKR0jdbSblJbw7BLxR3EYOtUzLPVjaiUR9MDxxtDp/CHRBwrH78ABP/Gkdn10jiSgznvSQzJ9HJhzUHPjnlQHQEZPClblM4Gki9oApXkKxFkeVrs24+q8gQ+h7z3C1sRzMvSyV3DJnCFMZIBJ2TLIMhPF9CPGD+6g+PZR9xOhJbbqIDGcUJP0Iw7zekoSf7+ByIWvy68g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OB3hJWEopcX3jrwOqJ3eZxM/ybrrEZHeg5OVrHaLSSk=;
 b=KsFpqQ2cOT+zRzCqM64VnecJoXh0poJSMXiOW/Y4jTGHaZR2ALQAgewsPQfgI0nYg1LCR3uzYqz2WrOq0NGefppNHxr+t4XznYmwKGt2NJIBulUo3NVVxYsIFQkzXezoGYShS4eZRIqzzRZcb+YEt0lBEd2rC47PlQgXMU5s9g1WWtDELZ/9oMOBmbrIon8OhQYCX6mYOGPhssVLuLjEiUKI4k5+1b4WtoDfc6wNhltfIHG+4q9cTU2nEWckV+UPhqbYaMeVt8l010wF5fWPAqt5V1KHPLJNshVCGxhzOqw/VhQm57Hv+2ZluNxdJ2Ig+gfNWPGvH9XZpzxkYsMh3g==
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5213.namprd12.prod.outlook.com (2603:10b6:5:394::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Fri, 3 Sep
 2021 10:04:18 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%7]) with mapi id 15.20.4478.020; Fri, 3 Sep 2021
 10:04:18 +0000
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in add_del_if
To:     syzbot <syzbot+24b98616278c31afc800@syzkaller.appspotmail.com>,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, roopa@nvidia.com,
        syzkaller-bugs@googlegroups.com
References: <0000000000007d0d1a05cb13924c@google.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <10b89a9f-443c-98d1-ca01-add5f6dd3355@nvidia.com>
Date:   Fri, 3 Sep 2021 13:04:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <0000000000007d0d1a05cb13924c@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0067.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::18) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.78] (213.179.129.39) by ZR0P278CA0067.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Fri, 3 Sep 2021 10:04:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b74f95e9-dd4d-4235-4259-08d96ec23170
X-MS-TrafficTypeDiagnostic: DM4PR12MB5213:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB521361A746124F09EF48B85FDFCF9@DM4PR12MB5213.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ULyVqNUZNssL6x3esneMrpjsOhMuLhR+Zf76Hi24NskjSwkLS7zr59Jq97q5af47VNp36Vl2CndvRgDjZMJyWgZ1xELc69L2wzlVqlN/Xx/SQ8nG8DT+7ND54BPbS3awiTfzsmwHNRHx3fczVJIt5NapSD0j/0xwD5dQbVINOKYPwccakJctmZLQpxXXA5IhhT7hbJvHgp6duxxsE9fp1FD0MrSlScinZySDeCy4u4R0I2ijl7xibZu/aUY5DyGHY+XQpnDiDD7dSxhqa9jxOhcqQM4HPlL8GsXepU3lk97igyrbwaChGahG6nr5qWsj9nIHXiMdXSK80/t11LtNypr6Kd86vO7XO5TDmjbHFUu4NpWrrQiwlT2iq7ILyBfUaq12hlb+9psgEWzjUV7ENQdHKvXUZFnYH7L11WM7CIbse9IZBMom6K4v/RVdCyiekanWUxT4lZSFK9Am7k/d6yR2uIAtHGQeLJxDt8o5bKcXkxUKW0DXOQsGSfC1My7M6Fyq6CSwTdNEh7uFsdCGLE043ICrs2b+waRkK22Kvs2vw69mz5J7HvAglaJkEjYAj2nQhZYPIRalsCb3XMAsH4SX60dT3y5VPaYw5jfqyvyXeimUe0a6gWoamuDMGSHWEYSgiX07CySCPIMD7i1VtkQIO2DjQnaMaa6AX0tb2bGnbJFCiLA0C/Nf7eslxPUFmUu+jJcz+0X3+40qjkDsuY1b+k2ctq/dPzPdoxjyfYZyS/HLPHFDC3Aa/ZUw8HkY4ZVs7le7JkPdPsGtVF1vOlNpAYyLcX93WPj7vPXTAssye6Z5cZuZoD+8N1KqIITaVZtdMXt3S1MMOQgbpkay+jxC2+feT1QhXOwP62TVLKKZLFaPiYzTzR/aqP/9hC7C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(5660300002)(2906002)(966005)(6486002)(83380400001)(36756003)(186003)(26005)(66476007)(508600001)(53546011)(66946007)(66556008)(8676002)(8936002)(31686004)(86362001)(6666004)(16576012)(316002)(2616005)(38100700002)(956004)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmdadHpRVU9yZDJBbGxydDB3bENONGhub3l5WjBIaCtwa2RmMEJqRUVmSWhl?=
 =?utf-8?B?VDhYM1RLZ2VDR1ljaU40QzZ3eGlwTWtPdzMvbFlhSzJxMkZLeE55ellFb2po?=
 =?utf-8?B?RFYwT29QVzF0eTBmWHFNNTZ3alVseEZXbVlUYm1MY3BJTnFTUm1YMnVpVk9V?=
 =?utf-8?B?YWJBK05QQUtOL2tyaWV5QTZCMURsMWp6Y0IvOWxNTVJCdGVFeXc5VUo2TDVq?=
 =?utf-8?B?aktaSWJvaUduTFNtaWROYmhISXBYUlFPYVIzV3h1ZTcyblhzS2lIYWZlVGs1?=
 =?utf-8?B?M1FmZ3JYU3U2TDlFVHlnYW92SkhjSUxPMVR2emVaaEV6T2g1SU1HbkhPcXhi?=
 =?utf-8?B?ejhFNm5BZ3JGM1VsdEhsemt4b1dHc3lpMG9hNTdOVG5ZOW96eGFpdXRqN3NX?=
 =?utf-8?B?RkttWTZydENQRGJaOUg5cUIvOWNjbFdibkl1c1k0VjJWUGFnK0V0U3BmVmts?=
 =?utf-8?B?WUhDSHlXQ1lEeWsra0lqWU5LYXpiRW9jOTB0bUtWWVBuYUQ0ZHpLVitWY0hR?=
 =?utf-8?B?MW9aNlRlRE1IL3BSUk5JSXJZL1VqVlZBT1YxalBOYWtscGJraXBieEJaWm5Y?=
 =?utf-8?B?QVZqRVVEbi95bUlNeGVZMU55MjFkL1RLL3NIMHI0cytQMXpudFhNUjV4bENu?=
 =?utf-8?B?akFzRHpMWURud0dPUHZVUmYzVUdEK0MyOEJSRXRGNFN3QjlYNEcremxZTU9M?=
 =?utf-8?B?dXdOZWtFNU41SU43cEdoSmdMZXJ0czM3eWlwQVRUSVdWNEhJMTNOL3JiZW9L?=
 =?utf-8?B?NDhrSTdvOUZmRlJ2R29CTWF5RFNqTmhzRUhwVjdaRVRxUnhPakx5TEUvYmxD?=
 =?utf-8?B?NlozaVhuV2MxcDBqY3pYeWhtN2t4Wk00cktwU2IrcWF2SU13TTFScFdDcjN0?=
 =?utf-8?B?NEFVN2pLcy94emFtd2pHUUNVbm1PRERpLzZYOWo3aHJaL1FMQXk3RDVKSktO?=
 =?utf-8?B?eFJYVFB1dytINGR6U0M4akZkRFl6ZmxtM04vUDZ0WWhJZlVEYWdkeU9VZGZP?=
 =?utf-8?B?QkR3cTljaVRpRXJobE5pTlhYYkxnN0RRQzY5U1hxV2pzNnErQWJlOGVkZHVK?=
 =?utf-8?B?U0dZblpnTmJ6Z09rN3dYTVcyQWR2T0JhcXVEV251OW9QUFBkWjFKK01lN000?=
 =?utf-8?B?SnVrZTZXcUVuYmd4VUZUZ2FzMmluRXV1MUg1NzFBaE8vcVJBSnlaa0g0cE10?=
 =?utf-8?B?NExHVzllYUFidUVWYWtqdzdISUlqMUdGRVlUYzJCbFZES1I1Nk9qb1RuMHAv?=
 =?utf-8?B?Mk9GK3ZxcnBoZ2FlVEFLWmlnb1ZHUUlwVFYxZ2pVUkhhck91VXVEQVI0WUc1?=
 =?utf-8?B?eUYyYWY4L2d4K3MxWjE4N1BHRDViL2JxcG1IOHNYcmplYlpmd3lhZk4xbkgz?=
 =?utf-8?B?ekVMVXdqU3hBN1Z4bHErakkxV2MvMS96SS9rK2wvWDlGblFneWRTVEQreTF1?=
 =?utf-8?B?RTRmTHhVTVJNQjdLaEVMQ1pTalZBWWVqQitTdnBRaFlObFZ4QnNhNmJkQlRR?=
 =?utf-8?B?MjlmL2s2TVNkQTBtOUU1Z0xTTGdkZHFFbmtqL0djeW9WN3FubFZzd3dLd0Fo?=
 =?utf-8?B?RVJmWjQ0djNHY2Y2ZVhEeDV4bllTaFdsQzQ5QldBQzBpb1o1UlkwMlZocVdO?=
 =?utf-8?B?S1dCYVJKRkZlWERmSFlZMlZyVnRzRUFDOVJTQWNzYnk0dEpRTHVPTEJKdGc5?=
 =?utf-8?B?R2tHeXZsYldwaEJuTmpCczFVUVRsT1M4QkRFNU5iaDBIbmZPVjdqM3dxc0hK?=
 =?utf-8?Q?4kpt0YpRyWZS7jPdc4NrgPmmOlYwS/nthz1Ncz3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74f95e9-dd4d-4235-4259-08d96ec23170
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 10:04:18.3091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BA22JgIy5r0wRBUeuwIsCP+/kcEkbKuVbNxP7YF6G4wj2bRrljmibQKDZyz8I89XZUKdnVuVeXmSCkY6RIyxHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5213
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/09/2021 12:03, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    3bdc70669eb2 Merge branch 'devlink-register'

That is an older commit, before my ioctl fixes. I think this issue has been
already fixed by my patch-set:
 commit d15040a33883
 Merge: 4167a960574f 9384eacd80f3
 Author: David S. Miller <davem@davemloft.net>
 Date:   Thu Aug 5 11:36:59 2021 +0100

    Merge branch 'bridge-ioctl-fixes'
    
    Nikolay Aleksandrov says:
    
    ====================
    net: bridge: fix recent ioctl changes
    
    These are three fixes for the recent bridge removal of ndo_do_ioctl
    done by commit ad2f99aedf8f ("net: bridge: move bridge ioctls out of
    .ndo_do_ioctl"). Patch 01 fixes a deadlock of the new bridge ioctl
    hook lock and rtnl by taking a netdev reference and always taking the
    bridge ioctl lock first then rtnl from within the bridge hook.
    Patch 02 fixes old_deviceless() bridge calls device name argument, and
    patch 03 checks in dev_ifsioc()'s SIOCBRADD/DELIF cases if the netdevice is
    actually a bridge before interpreting its private ptr as net_bridge.
    
    Patch 01 was tested by running old bridge-utils commands with lockdep
    enabled. Patch 02 was tested again by using bridge-utils and using the
    respective ioctl calls on a "up" bridge device. Patch 03 was tested by
    using the addif ioctl on a non-bridge device (e.g. loopback).


> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=147a8072300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=914a8107c0ffdc14
> dashboard link: https://syzkaller.appspot.com/bug?extid=24b98616278c31afc800
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13f4ccc9d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b054f4300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+24b98616278c31afc800@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in add_del_if+0x13a/0x140 net/bridge/br_ioctl.c:85
> Read of size 8 at addr ffff888019118c88 by task syz-executor790/8443
> 
[snip]
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git d15040a33883

