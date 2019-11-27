Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 418B010AF3E
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 13:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfK0MFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 07:05:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4086 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726383AbfK0MFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 07:05:21 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xARC2dSW172625
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 07:05:19 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2whcxp6uc1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 07:05:19 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <ubraun@linux.ibm.com>;
        Wed, 27 Nov 2019 12:05:17 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 27 Nov 2019 12:05:16 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xARC5FWv50790522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 12:05:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 301BC42045;
        Wed, 27 Nov 2019 12:05:15 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB1AA4203F;
        Wed, 27 Nov 2019 12:05:14 +0000 (GMT)
Received: from oc5311105230.ibm.com (unknown [9.152.224.131])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Nov 2019 12:05:14 +0000 (GMT)
Subject: Re: memory leak in new_inode_pseudo (2)
To:     Eric Biggers <ebiggers@kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+e682cca30bc101a4d9d9@syzkaller.appspotmail.com>
References: <000000000000111cbe058dc7754d@google.com>
 <000000000000ed664f058dc82773@google.com>
 <20191119051350.GK163020@sol.localdomain>
From:   Ursula Braun <ubraun@linux.ibm.com>
Date:   Wed, 27 Nov 2019 13:05:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191119051350.GK163020@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19112712-4275-0000-0000-0000038706D1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112712-4276-0000-0000-0000389A952A
Message-Id: <27dff6d8-b4f2-6940-355a-4bcb47464e71@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-27_02:2019-11-27,2019-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 impostorscore=0 suspectscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911270105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/19/19 6:13 AM, Eric Biggers wrote:
> Ursula and Karsten,
> 
> On Tue, Jul 16, 2019 at 01:28:06AM -0700, syzbot wrote:
>> syzbot has found a reproducer for the following crash on:
>>
>> HEAD commit:    be8454af Merge tag 'drm-next-2019-07-16' of git://anongit...
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=13d5f750600000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=d23a1a7bf85c5250
>> dashboard link: https://syzkaller.appspot.com/bug?extid=e682cca30bc101a4d9d9
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=155c5800600000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1738f800600000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+e682cca30bc101a4d9d9@syzkaller.appspotmail.com
>>
>> executing program
>> executing program
>> executing program
>> executing program
>> BUG: memory leak
>> unreferenced object 0xffff888128ea0980 (size 768):
>>   comm "syz-executor303", pid 7044, jiffies 4294943526 (age 13.490s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>   backtrace:
>>     [<000000005ba542b8>] kmemleak_alloc_recursive
>> include/linux/kmemleak.h:43 [inline]
>>     [<000000005ba542b8>] slab_post_alloc_hook mm/slab.h:522 [inline]
>>     [<000000005ba542b8>] slab_alloc mm/slab.c:3319 [inline]
>>     [<000000005ba542b8>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
>>     [<000000006532a1e9>] sock_alloc_inode+0x1c/0xa0 net/socket.c:238
>>     [<0000000014ddc967>] alloc_inode+0x2c/0xe0 fs/inode.c:227
>>     [<0000000056541455>] new_inode_pseudo+0x18/0x70 fs/inode.c:916
>>     [<000000003b5b5444>] sock_alloc+0x1c/0x90 net/socket.c:554
>>     [<00000000e623b353>] __sock_create+0x8f/0x250 net/socket.c:1378
>>     [<000000000e094708>] sock_create_kern+0x3b/0x50 net/socket.c:1483
>>     [<000000009fe4f64f>] smc_create+0xae/0x160 net/smc/af_smc.c:1975
>>     [<0000000056be84a7>] __sock_create+0x164/0x250 net/socket.c:1414
>>     [<000000005915e5fe>] sock_create net/socket.c:1465 [inline]
>>     [<000000005915e5fe>] __sys_socket+0x69/0x110 net/socket.c:1507
>>     [<00000000afa837b2>] __do_sys_socket net/socket.c:1516 [inline]
>>     [<00000000afa837b2>] __se_sys_socket net/socket.c:1514 [inline]
>>     [<00000000afa837b2>] __x64_sys_socket+0x1e/0x30 net/socket.c:1514
>>     [<00000000d0addad1>] do_syscall_64+0x76/0x1a0
>> arch/x86/entry/common.c:296
>>     [<000000004e8e7c22>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811faeeab8 (size 56):
>>   comm "syz-executor303", pid 7044, jiffies 4294943526 (age 13.490s)
>>   hex dump (first 32 bytes):
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>     00 0a ea 28 81 88 ff ff d0 ea ae 1f 81 88 ff ff  ...(............
>>   backtrace:
>>     [<000000005ba542b8>] kmemleak_alloc_recursive
>> include/linux/kmemleak.h:43 [inline]
>>     [<000000005ba542b8>] slab_post_alloc_hook mm/slab.h:522 [inline]
>>     [<000000005ba542b8>] slab_alloc mm/slab.c:3319 [inline]
>>     [<000000005ba542b8>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
>>     [<000000008ca63096>] kmem_cache_zalloc include/linux/slab.h:738 [inline]
>>     [<000000008ca63096>] lsm_inode_alloc security/security.c:522 [inline]
>>     [<000000008ca63096>] security_inode_alloc+0x33/0xb0
>> security/security.c:875
>>     [<00000000b335d930>] inode_init_always+0x108/0x200 fs/inode.c:169
>>     [<0000000015dcffb3>] alloc_inode+0x49/0xe0 fs/inode.c:234
>>     [<0000000056541455>] new_inode_pseudo+0x18/0x70 fs/inode.c:916
>>     [<000000003b5b5444>] sock_alloc+0x1c/0x90 net/socket.c:554
>>     [<00000000e623b353>] __sock_create+0x8f/0x250 net/socket.c:1378
>>     [<000000000e094708>] sock_create_kern+0x3b/0x50 net/socket.c:1483
>>     [<000000009fe4f64f>] smc_create+0xae/0x160 net/smc/af_smc.c:1975
>>     [<0000000056be84a7>] __sock_create+0x164/0x250 net/socket.c:1414
>>     [<000000005915e5fe>] sock_create net/socket.c:1465 [inline]
>>     [<000000005915e5fe>] __sys_socket+0x69/0x110 net/socket.c:1507
>>     [<00000000afa837b2>] __do_sys_socket net/socket.c:1516 [inline]
>>     [<00000000afa837b2>] __se_sys_socket net/socket.c:1514 [inline]
>>     [<00000000afa837b2>] __x64_sys_socket+0x1e/0x30 net/socket.c:1514
>>     [<00000000d0addad1>] do_syscall_64+0x76/0x1a0
>> arch/x86/entry/common.c:296
>>     [<000000004e8e7c22>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
> 
> Do you think this was fixed by:
> 
> 	commit 6d6dd528d5af05dc2d0c773951ed68d630a0c3f1
> 	Author: Ursula Braun <ubraun@linux.ibm.com>
> 	Date:   Tue Nov 12 16:03:41 2019 +0100
> 
> 	    net/smc: fix refcount non-blocking connect() -part 2
> 
> ?
> 

No, I don't think so. This patch changes the SMC connect() code, but I do not
see any connect() call in the syzbot C-reproducer.

Regards, Ursula

> Thanks!
> 
> - Eric
> 

