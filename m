Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8524546E1E
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349081AbiFJUPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347418AbiFJUPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:15:47 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E72238794
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 13:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654892145; x=1686428145;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=iQzfwRn8ihzyIyu9uzf/+L0VNvsamcf3mtNZoFb+g7s=;
  b=Bp0Gl/K9pn7t+b1BxC2Sx1rJfrBlvq57a64ouRel+BNXGhugfBmM8kEf
   1FBp31U+P1BUUJXPUu1ZemD0lYIueDM17Vg2S+qDXqMoceFx+JaoaBsY+
   CI5X1bwFzYZVQ/medXFdgyQBkpvQuujyCkf+CjAfcWy1n7R1QGitOok8K
   PjuKn9jx9QTdQ1Lc87mo2tH+l6HEYzyzUR/OtQHsTSRThZLnUy4R2c5a4
   zbgdlmiPwN7oMawDVWcgaqR4SU/zuBps3HWEs2dJa9mTlvBtCNNvQzLTB
   JQxhgX62Z/cJYSzKNnjtWQiqw0krPsasB1/cRWe+Rh/nRCLFIohbCshcP
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="276516862"
X-IronPort-AV: E=Sophos;i="5.91,291,1647327600"; 
   d="scan'208";a="276516862"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 13:15:45 -0700
X-IronPort-AV: E=Sophos;i="5.91,291,1647327600"; 
   d="scan'208";a="909095167"
Received: from efbarbud-mobl1.amr.corp.intel.com (HELO csouzax-mobl2.amr.corp.intel.com) ([10.212.104.59])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 13:15:44 -0700
Date:   Fri, 10 Jun 2022 13:15:44 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>
cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 0/2] Update bhash2 when socket's rcv saddr
 changes
In-Reply-To: <CAJnrk1Y1ZEsAyCv_gBCYvSdRqkzOQCC3cf8M7r8uxOHVVup-zw@mail.gmail.com>
Message-ID: <23d8e9f4-016-7de1-9737-12c3146872ca@linux.intel.com>
References: <20220602165101.3188482-1-joannelkoong@gmail.com> <4bae9df4-42c1-85c3-d350-119a151d29@linux.intel.com> <CAJnrk1buk-hK3nwyPz+o+wZLDdZTPpBSNniY3sJtgXZtJXOROQ@mail.gmail.com> <CAJnrk1bF=TD2b+RaYqH10i6LXkzbzsVHmM=-wR7S2_bHGxMuNw@mail.gmail.com>
 <e14e34b-2a1c-18b2-7c25-5ad72c5fc8@linux.intel.com> <CAJnrk1banJ13wqeAa9nqU1vdgFuizvU+fp6svwXRh5=XVS3c+g@mail.gmail.com> <CAJnrk1bcVzLf2pKSV8r2JL6f-co+OYR3z8gtSt7uyLkoiGAPpA@mail.gmail.com> <7df42be8-7170-d649-cf22-6bf176ffcd33@linux.intel.com>
 <CAJnrk1Y1ZEsAyCv_gBCYvSdRqkzOQCC3cf8M7r8uxOHVVup-zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jun 2022, Joanne Koong wrote:

> On Thu, Jun 9, 2022 at 5:37 PM Mat Martineau
> <mathew.j.martineau@linux.intel.com> wrote:
>>
>> On Thu, 9 Jun 2022, Joanne Koong wrote:
>>
>>> On Wed, Jun 8, 2022 at 1:27 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>>>>
>>>> On Tue, Jun 7, 2022 at 10:33 AM Mat Martineau
>>>> <mathew.j.martineau@linux.intel.com> wrote:
>>>>>
>>>>> On Mon, 6 Jun 2022, Joanne Koong wrote:
>>>>>
>>>>>> On Fri, Jun 3, 2022 at 5:38 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>>>>>>>
>>>>>>> On Fri, Jun 3, 2022 at 11:55 AM Mat Martineau
>>>>>>> <mathew.j.martineau@linux.intel.com> wrote:
>>>>>>>>
>>>>>>>> On Thu, 2 Jun 2022, Joanne Koong wrote:
>>>>>>>>
>>>>>>>>> As syzbot noted [1], there is an inconsistency in the bhash2 table in the
>>>>>>>>> case where a socket's rcv saddr changes after it is binded. (For more
>>>>>>>>> details, please see the commit message of the first patch)
>>>>>>>>>
>>>>>>>>> This patchset fixes that and adds a test that triggers the case where the
>>>>>>>>> sk's rcv saddr changes. The subsequent listen() call should succeed.
>>>>>>>>>
>>>>>>>>> [1] https://lore.kernel.org/netdev/0000000000003f33bc05dfaf44fe@google.com/
>>>>>>>>>
>>>>>>>>> --
>>>>>>>>> v1 -> v2:
>>>>>>>>> v1: https://lore.kernel.org/netdev/20220601201434.1710931-1-joannekoong@fb.com/
>>>>>>>>> * Mark __inet_bhash2_update_saddr as static
>>>>>>>>>
>>>>>>>>> Joanne Koong (2):
>>>>>>>>>  net: Update bhash2 when socket's rcv saddr changes
>>>>>>>>>  selftests/net: Add sk_bind_sendto_listen test
>>>>>>>>>
>>>>>>>>
>>>>>>>> Hi Joanne -
>>>>>>>>
>>>>>>>> I've been running my own syzkaller instance with v1 of this fix for a
>>>>>>>> couple of days. Before this patch, syzkaller would trigger the
>>>>>>>> inet_csk_get_port warning a couple of times per hour. After this patch it
>>>>>>>> took two days to show the warning:
>>>>>>>>
>>>>>>>> ------------[ cut here ]------------
>>>>>>>>
>>>>>>>> WARNING: CPU: 0 PID: 9430 at net/ipv4/inet_connection_sock.c:525
>>>>>>>> inet_csk_get_port+0x938/0xe80 net/ipv4/inet_connection_sock.c:525
>>>>>>>> Modules linked in:
>>>>>>>> CPU: 0 PID: 9430 Comm: syz-executor.5 Not tainted 5.18.0-05016-g433fde5b4119 #3
>>>>>>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
>>>>>>>> RIP: 0010:inet_csk_get_port+0x938/0xe80 net/ipv4/inet_connection_sock.c:525
>>>>>>>> Code: ff 48 89 84 24 b0 00 00 00 48 85 c0 0f 84 6a 01 00 00 e8 2b 0f db fd 48 8b 6c 24 70 c6 04 24 01 e9 fb fb ff ff e8 18 0f db fd <0f> 0b e9 70 f9 ff ff e8 0c 0f db fd 0f 0b e9 28 f9 ff ff e8 00 0f
>>>>>>>> RSP: 0018:ffffc90000b5fbc0 EFLAGS: 00010212
>>>>>>>> RAX: 00000000000000e7 RBX: ffff88803c410040 RCX: ffffc9000e419000
>>>>>>>> RDX: 0000000000040000 RSI: ffffffff836f47e8 RDI: ffff88803c4106e0
>>>>>>>> RBP: ffff88810b773840 R08: 0000000000000001 R09: 0000000000000001
>>>>>>>> R10: fffffbfff0f64303 R11: 0000000000000001 R12: 0000000000000000
>>>>>>>> R13: ffff88810605e2f0 R14: ffffffff88606040 R15: 000000000000c1ff
>>>>>>>> FS:  00007fada4d03640(0000) GS:ffff88811ac00000(0000) knlGS:0000000000000000
>>>>>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>>>>> CR2: 0000001b32e24000 CR3: 00000001016de001 CR4: 0000000000770ef0
>>>>>>>> PKRU: 55555554
>>>>>>>> Call Trace:
>>>>>>>>   <TASK>
>>>>>>>>   inet_csk_listen_start+0x143/0x3d0 net/ipv4/inet_connection_sock.c:1178
>>>>>>>>   inet_listen+0x22f/0x650 net/ipv4/af_inet.c:228
>>>>>>>>   mptcp_listen+0x205/0x440 net/mptcp/protocol.c:3564
>>>>>>>>   __sys_listen+0x189/0x260 net/socket.c:1810
>>>>>>>>   __do_sys_listen net/socket.c:1819 [inline]
>>>>>>>>   __se_sys_listen net/socket.c:1817 [inline]
>>>>>>>>   __x64_sys_listen+0x54/0x80 net/socket.c:1817
>>>>>>>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>>>>>   do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
>>>>>>>>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>>>>>>> RIP: 0033:0x7fada558f92d
>>>>>>>> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
>>>>>>>> RSP: 002b:00007fada4d03028 EFLAGS: 00000246 ORIG_RAX: 0000000000000032
>>>>>>>> RAX: ffffffffffffffda RBX: 00007fada56aff60 RCX: 00007fada558f92d
>>>>>>>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
>>>>>>>> RBP: 00007fada56000a0 R08: 0000000000000000 R09: 0000000000000000
>>>>>>>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>>>>>>>> R13: 000000000000000b R14: 00007fada56aff60 R15: 00007fada4ce3000
>>>>>>>>   </TASK>
>>>>>>>> irq event stamp: 2078
>>>>>>>> hardirqs last  enabled at (2092): [<ffffffff812f1be3>] __up_console_sem+0xb3/0xd0 kernel/printk/printk.c:291
>>>>>>>> hardirqs last disabled at (2103): [<ffffffff812f1bc8>] __up_console_sem+0x98/0xd0 kernel/printk/printk.c:289
>>>>>>>> softirqs last  enabled at (1498): [<ffffffff83807dd4>] lock_sock include/net/sock.h:1691 [inline]
>>>>>>>> softirqs last  enabled at (1498): [<ffffffff83807dd4>] inet_listen+0x94/0x650 net/ipv4/af_inet.c:199
>>>>>>>> softirqs last disabled at (1500): [<ffffffff836f425c>] spin_lock_bh include/linux/spinlock.h:354 [inline]
>>>>>>>> softirqs last disabled at (1500): [<ffffffff836f425c>] inet_csk_get_port+0x3ac/0xe80 net/ipv4/inet_connection_sock.c:483
>>>>>>>> ---[ end trace 0000000000000000 ]---
>>>>>>>>
>>>>>>>>
>>>>>>>> In the full log file it does look like syskaller is doing something
>>>>>>>> strange since it's calling bind, connect, and listen on the same socket:
>>>>>>>>
>>>>>>>> r4 = socket$inet_mptcp(0x2, 0x1, 0x106)
>>>>>>>> bind$inet(r4, &(0x7f0000000000)={0x2, 0x4e23, @empty}, 0x10)
>>>>>>>> connect$inet(r4, &(0x7f0000000040)={0x2, 0x0, @local}, 0x10)
>>>>>>>> listen(r4, 0x0)
>>>>>>>>
>>>>>>>> ...but it is a fuzz tester after all.
>>>>>>>>
>>>>>>>> I've uploaded the full syzkaller logs to this GitHub issue:
>>>>>>>>
>>>>>>>> https://github.com/multipath-tcp/mptcp_net-next/issues/279
>>>>>>>>
>>>>>>>>
>>>>>>>> Not sure yet if this is MPTCP-related. I don't think MPTCP
>>>>>>>> changes anything with the subflow TCP socket bind hashes.
>>>>>>>>
>>>>>>> Hi Mat,
>>>>>>>
>>>>>>> Thanks for bringing this up and for uploading the logs. I will look into this.
>>>>>>>>
>>>>>> Hi Mat,
>>>>>>
>>>>>> I am still trying to configure my local environment for mptcp to repro
>>>>>> + test the fix to verify that it is correct. I think the fix is to add
>>>>>> "inet_bhash2_update_saddr(msk);" to the end of the
>>>>>> "mptcp_copy_inaddrs" function in net/mptcp/protocol.c.  Would you be
>>>>>> able to run an instance on your local syzkaller environment with this
>>>>>> line added to see if that fixes the warning?
>>>>>
>>>>> Hi Joanne -
>>>>>
>>>>> I also investigated that function when trying to figure out why this
>>>>> warning might be happening in MPTCP.
>>>>>
>>>>> In MPTCP, the userspace-facing MPTCP socket (msk) doesn't directly bind or
>>>>> connect. The msk creates and manages TCP subflow sockets (ssk in
>>>>> mptcp_copy_inaddrs()), and passes through bind and connect calls to the
>>>>> subflows. The msk depends on the subflow to do the hash updates, since
>>>>> those subflow sockets are the ones interacting with the inet layer.
>>>>>
>>>>> mptcp_copy_inaddrs() copies the already-hashed addresses and ports from
>>>>> the ssk to the msk, and we only want the ssk in the hash table.
>>>>>
>>>> I see, thanks for the explanation, Mat! I will keep investigating.\
>>>
>>> Are you able to repro this warning locally, Mat?
>>>
>>
>> This message made it to my inbox after hitting 'send' on my last reply to
>> this thread!
>>
>> As I said there, I haven't seen syzkaller trigger this again. It only
>> happened one time after applying the fix, and not at all in the last week
>> running syzkaller (nearly) continuously.
>>
>>> I have a test program that calls:
>>> struct addrinfo hints = {
>>>          .ai_protocol = IPPROTO_TCP,
>>>          .ai_socktype = SOCK_STREAM,
>>>         .ai_family = AF_INET,
>>> };
>>> getaddrinfo("127.0.0.1", "15432", &hints, &addr);
>>> socket(AF_INET, SOCK_STREAM, IPPROTO_MPTCP);
>>> bind(sock_fd, addr->ai_addr, addr->ai_addrlen)
>>> connect(sock_fd, &zeroed_sockaddr, sizeof(zeroed_sockaddr));
>>> listen(sock_fd, 0);
>>>
>>> but I'm unable to trigger this warning in my local environment.
>>>
>>> I'm not understanding how this warning can get triggered
>>> non-deterministically when the socket resides only within the program.
>>> The only theory that makes sense to me is that the subflow sockets'
>>> saddr changes somewhere after it has been binded, but then wouldn't
>>> that trigger this warning deterministically?
>>
>> I agree, if the MPTCP code was modifying the subflow saddr this would
>> trigger more consistently. But as far as I can tell, MPTCP isn't
>> changing those values.
>>
>>>
>>> How often are you seeing this warning show up in the mptcp syzkaller?
>>> Is there a way to run a local patch on the mptcp syzkaller (eg like a
>>> patch that prints out extraneous debugging information about
>>> icsk_bind2_hash address, tb2 address, and the socket's saddr changes)
>>> - if so, how can I do this?
>>>
>>
>> Since the warning has not repeated in the last week, I'm wondering if
>> maybe the fuzz tester happened across the locking issue that Paolo noted?
>> The lack of determinism makes me suspect some kind of concurrency issue.
>>
>> I'm running syzkaller on a large-ish datacenter VM with a kernel I
>> compiled, so I can add any patches myself and run with those. Setup for
>> syzkaller as I've been using it with MPTCP is documented here:
>> https://github.com/multipath-tcp/mptcp_net-next/wiki/Testing#syzkaller
>>
>> If you have a patch with some extra debug output that you can point me to,
>> I can apply that to the kernel I'm running.
>>
>
> Awesome, I'm glad to hear that the warning is not constantly
> happening. I am tidying up the bhash2 locks patch and will submit that
> soon. If this warning still shows up after that patch, then I will
> send you a local patch with extra debug output to run on top of the
> mptcp syzkaller.
>

As luck would have it, the warning occurred again today (but not on a 
MPTCP socket):

------------[ cut here ]------------
WARNING: CPU: 0 PID: 14437 at net/ipv4/inet_connection_sock.c:525 inet_csk_get_port+0x938/0xe80 net/ipv4/inet_connection_sock.c:525
Modules linked in:
CPU: 0 PID: 14437 Comm: syz-executor.5 Not tainted 5.18.0-12154-gb63ea817dc3d #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
RIP: 0010:inet_csk_get_port+0x938/0xe80 net/ipv4/inet_connection_sock.c:525
Code: ff 48 89 84 24 b0 00 00 00 48 85 c0 0f 84 6a 01 00 00 e8 cb bd da fd 48 8b 6c 24 70 c6 04 24 01 e9 fb fb ff ff e8 b8 bd da fd <0f> 0b e9 70 f9 ff ff e8 ac bd da fd 0f 0b e9 28 f9 ff ff e8 a0 bd
RSP: 0018:ffffc90010d47c50 EFLAGS: 00010212
RAX: 000000000000007b RBX: ffff888028c25600 RCX: ffffc90003ad9000
RDX: 0000000000040000 RSI: ffffffff836ffa48 RDI: ffff888028c25ca0
RBP: ffff888038d6a040 R08: 0000000000000001 R09: 0000000000000001
R10: fffffbfff0f6490b R11: 0000000000000001 R12: 0000000000000000
R13: ffff888106074670 R14: ffffffff88608f40 R15: 0000000000000000
FS:  00007f6200b61640(0000) GS:ffff88811ac00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020003700 CR3: 0000000038d50004 CR4: 0000000000770ef0
PKRU: 55555554
Call Trace:
  <TASK>
  inet_csk_listen_start+0x143/0x3d0 net/ipv4/inet_connection_sock.c:1178
  inet_listen+0x22f/0x650 net/ipv4/af_inet.c:228
  __sys_listen+0x189/0x260 net/socket.c:1810
  __do_sys_listen net/socket.c:1819 [inline]
  __se_sys_listen net/socket.c:1817 [inline]
  __x64_sys_listen+0x54/0x80 net/socket.c:1817
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f62013ed92d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6200b61028 EFLAGS: 00000246 ORIG_RAX: 0000000000000032
RAX: ffffffffffffffda RBX: 00007f620150df60 RCX: 00007f62013ed92d
RDX: 0000000000000000 RSI: 00000000fffffffd RDI: 0000000000000004
RBP: 00007f620145e0a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 00007f620150df60 R15: 00007f6200b41000
  </TASK>
irq event stamp: 2750
hardirqs last  enabled at (2762): [<ffffffff812f3813>] __up_console_sem+0xb3/0xd0 kernel/printk/printk.c:291
hardirqs last disabled at (2773): [<ffffffff812f37f8>] __up_console_sem+0x98/0xd0 kernel/printk/printk.c:289
softirqs last  enabled at (2198): [<ffffffff83812ff4>] lock_sock include/net/sock.h:1691 [inline]
softirqs last  enabled at (2198): [<ffffffff83812ff4>] inet_listen+0x94/0x650 net/ipv4/af_inet.c:199
softirqs last disabled at (2200): [<ffffffff836ff4bc>] spin_lock_bh include/linux/spinlock.h:354 [inline]
softirqs last disabled at (2200): [<ffffffff836ff4bc>] inet_csk_get_port+0x3ac/0xe80 net/ipv4/inet_connection_sock.c:483
---[ end trace 0000000000000000 ]---


It looks like it triggered with this from the full syzkaller log:

"""
16:42:38 executing program 5:
r0 = socket$inet_mptcp(0x2, 0x1, 0x106)
r1 = dup3(r0, 0xffffffffffffffff, 0x80000)
bind$inet(r1, &(0x7f00000001c0)={0x2, 0x4e23, @empty}, 0x10)
bind$inet(r0, &(0x7f0000000000)={0x2, 0x4e21, @broadcast}, 0x10)
connect$inet(r0, &(0x7f0000000800)={0x2, 0x4e21, @local}, 0x10)
r2 = socket$inet_tcp(0x2, 0x1, 0x0)
ioctl$F2FS_IOC_MOVE_RANGE(r2, 0xc020f509, &(0x7f0000000200)={<r3=>r2, 0x4, 0xeea5, 0x9bf})
ioctl$sock_SIOCSIFVLAN_GET_VLAN_VID_CMD(r3, 0x8983, &(0x7f0000000140))
ioctl$sock_SIOCGIFVLAN_GET_VLAN_REALDEV_NAME_CMD(r0, 0x8982, &(0x7f0000000180)={0x8, 'veth1_to_bridge\x00', {'syzkaller0\x00'}})
bind$inet(r2, &(0x7f0000000000)={0x2, 0x4e22, @empty}, 0x10)
connect$inet(r2, &(0x7f0000000040)={0x2, 0x4e23, @local}, 0x10)
setsockopt$SO_TIMESTAMPING(r1, 0x1, 0x41, &(0x7f0000000240)=0x10, 0x4)
sendmmsg$inet(r2, &(0x7f00000000c0)=[{{&(0x7f0000000080)={0x2, 0x0, @empty}, 0x10, &(0x7f00000006c0)=[{&(0x7f0000000380)="01", 0x1}, {0x0}, {&(0x7f0000000600)}], 0x3}}, {{0x0, 0x0, 0x0}}], 0x2, 0x4080)
bind$inet(0xffffffffffffffff, &(0x7f0000000000)={0x2, 0x4e22, @empty}, 0x10)
connect$inet(0xffffffffffffffff, &(0x7f0000000040)={0x2, 0x4e22, @empty}, 0x10)
sendmmsg$inet(0xffffffffffffffff, &(0x7f0000003700)=[{{&(0x7f0000000340)={0x2, 0x0, @initdev={0xac, 0x1e, 0x0, 0x0}}, 0x10, &(0x7f00000006c0)=[{&(0x7f0000000380)="01", 0x7ffff000}, {0x0}, {&(0x7f0000000600)}], 0x3}}, {{0x0, 0x0, 0x0}}], 0x2, 0x4080)
recvfrom(0xffffffffffffffff, 0x0, 0x0, 0x0, 0x0, 0x0)
setsockopt$inet_tcp_TCP_MD5SIG(0xffffffffffffffff, 0x6, 0xe, &(0x7f0000000280)={@in={{0x2, 0x4e20, @multicast2}}, 0x0, 0x0, 0x18, 0x0, "ead8cdf27d67e3a674fe37c3ad427a4abf5a4925fe88866d975cdf4c5630aacf9cb63d3a96005215ef90dada225dc104e2842170476791560ebc77065d4fc5b3f42dbb9490dfef773dde3e5867e96fdf"}, 0xd8)
recvfrom(r2, 0x0, 0x0, 0x0, 0x0, 0x0)
listen(r2, 0xfffffffd)
"""

So there was some concurrent MPTCP activity but the stack trace is for the 
'r2' TCP socket.

I'll watch for the locking patch. Thanks!

--
Mat Martineau
Intel
