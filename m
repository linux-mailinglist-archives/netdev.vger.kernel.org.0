Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE61E485D
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 12:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409218AbfJYKPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 06:15:03 -0400
Received: from mail.jv-coder.de ([5.9.79.73]:56566 "EHLO mail.jv-coder.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409192AbfJYKPD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 06:15:03 -0400
Received: from [10.61.40.7] (unknown [37.156.92.209])
        by mail.jv-coder.de (Postfix) with ESMTPSA id DE6049F64C;
        Fri, 25 Oct 2019 10:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jv-coder.de; s=dkim;
        t=1571998500; bh=l6SMEEglbngUE1u9wb5gv9AnEVw28sr8tAsIuis+AgI=;
        h=Subject:To:From:Message-ID:Date:MIME-Version;
        b=TNS2p7nFpVBUBCB6MB2bSg55s/ff4MNGPsg7LhgkkywahAYiodOzfRvAg/W4X61ze
         4HzRj30WOf6QBBvXX4BP1tgR8zu2NDmewiS+3y6FzdoPu0CmhDzeNRNGpGd5T79WjA
         uWJq9ufks7txNb5HM6jyYK0nIPTiE5TChr7vAkY4=
Subject: Re: [PATCH v2 1/1] xfrm : lock input tasklet skb queue
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Tom Rix <trix@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CACVy4SUkfn4642Vne=c1yuWhne=2cutPZQ5XeXz_QBz1g67CrA@mail.gmail.com>
 <20191024103134.GD13225@gauss3.secunet.de>
 <ad094bfc-ebb3-012b-275b-05fb5a8f86e5@jv-coder.de>
 <20191025094758.pchz4wupvo3qs6hy@linutronix.de>
From:   Joerg Vehlow <lkml@jv-coder.de>
Message-ID: <202da67b-95c7-3355-1abc-f67a40a554e9@jv-coder.de>
Date:   Fri, 25 Oct 2019 12:14:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191025094758.pchz4wupvo3qs6hy@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,HELO_MISC_IP,RDNS_NONE autolearn=no
        autolearn_force=no version=3.4.2
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.jv-coder.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that I look back at my mail, you are right, I did not say anything
about rt, my bad. But maybe you could add too the rt patches website, that
an RT tag has to be added.

@Tom Rix, will you resend the patch? You may also add the information,
that I found the bug running the ipsec_stress ltp tests. Generating any
ipsec traffic (maybe concurrent) should be sufficient.

Here is one of the oops logs I still have:

[  139.717259] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000518
[  139.717260] PGD 0 P4D 0
[  139.717262] Oops: 0000 [#1] PREEMPT SMP PTI
[  139.717273] CPU: 2 PID: 11987 Comm: netstress Not tainted 
4.19.59-rt24-preemt-rt #1
[  139.717274] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS rel-1.12.0-0-ga698c8995f-prebuilt.qemu.org 04/01/2014
[  139.717306] RIP: 0010:xfrm_trans_reinject+0x97/0xd0
[  139.717307] Code: 42 eb 45 83 6d b0 01 31 f6 48 8b 42 08 48 c7 42 08 
00 00 00 00 48 8b 0a 48 c7 02 00 00 00 00 48 89 41 08 48 89 08 48 8b 42 
10 <48> 8b b8 18 05 00 00 48 8b 42 40 e8 d9 e1 4b 00 48 8b 55 a0 48 39
[  139.717307] RSP: 0018:ffffc900007b37e8 EFLAGS: 00010246
[  139.717308] RAX: 0000000000000000 RBX: ffffc900007b37e8 RCX: 
ffff88807db206a8
[  139.717309] RDX: ffff88807db206a8 RSI: 0000000000000000 RDI: 
0000000000000000
[  139.717309] RBP: ffffc900007b3848 R08: 0000000000000001 R09: 
ffffc900007b35c8
[  139.717309] R10: ffffea0001dcfc00 R11: 00000000000890c4 R12: 
ffff88807db20680
[  139.717310] R13: 00000000000f4240 R14: 0000000000000000 R15: 
0000000000000000
[  139.717310] FS:  00007f4643034700(0000) GS:ffff88807db00000(0000) 
knlGS:0000000000000000
[  139.717311] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  139.717337] CR2: 0000000000000518 CR3: 00000000769c6000 CR4: 
00000000000006e0
[  139.717350] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  139.717350] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  139.717350] Call Trace:
[  139.717387]  tasklet_action_common.isra.18+0x6d/0xd0
[  139.717388]  tasklet_action+0x1d/0x20
[  139.717389]  do_current_softirqs+0x196/0x360
[  139.717390]  __local_bh_enable+0x51/0x60
[  139.717397]  ip_finish_output2+0x18b/0x3f0
[  139.717408]  ? task_rq_lock+0x53/0xe0
[  139.717415]  ip_finish_output+0xbe/0x1b0
[  139.717416]  ip_output+0x72/0x100
[  139.717422]  ? ipcomp_output+0x5e/0x280
[  139.717424]  xfrm_output_resume+0x4b5/0x540
[  139.717436]  ? refcount_dec_and_test_checked+0x11/0x20
[  139.717443]  ? kfree_skbmem+0x33/0x80
[  139.717444]  xfrm_output+0xd7/0x110
[  139.717451]  xfrm4_output_finish+0x2b/0x30
[  139.717452]  __xfrm4_output+0x3a/0x50
[  139.717453]  xfrm4_output+0x40/0xe0
[  139.717454]  ? xfrm_dst_check+0x174/0x250
[  139.717455]  ? xfrm4_output+0x40/0xe0
[  139.717456]  ? xfrm_dst_check+0x174/0x250
[  139.717457]  ip_local_out+0x3b/0x50
[  139.717458]  __ip_queue_xmit+0x16b/0x420
[  139.717464]  ip_queue_xmit+0x10/0x20
[  139.717466]  __tcp_transmit_skb+0x566/0xad0
[  139.717467]  tcp_write_xmit+0x3a4/0x1050
[  139.717468]  __tcp_push_pending_frames+0x35/0xe0
[  139.717469]  tcp_push+0xdb/0x100
[  139.717469]  tcp_sendmsg_locked+0x491/0xd70
[  139.717470]  tcp_sendmsg+0x2c/0x50
[  139.717476]  inet_sendmsg+0x3e/0xf0
[  139.717483]  sock_sendmsg+0x3e/0x50
[  139.717484]  __sys_sendto+0x114/0x1a0
[  139.717491]  ? __rt_mutex_unlock+0xe/0x10
[  139.717492]  ? _mutex_unlock+0xe/0x10
[  139.717500]  ? ksys_write+0xc5/0xe0
[  139.717501]  __x64_sys_sendto+0x28/0x30
[  139.717503]  do_syscall_64+0x4d/0x110
[  139.717504]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Am 25.10.2019 um 11:47 schrieb Sebastian Andrzej Siewior:
> On 2019-10-25 11:37:59 [+0200], Joerg Vehlow wrote:
>> Hi,
>>
>> I always expected this to be applied to the RT patches. That's why
>> I originally send my patch to to Sebastian, Thomas and Steven (I added
>> them again now. The website of the rt patches says patches for the
>> CONFIG_REEMPT_RT patchset should be send to lkml.
>>
>> I hope one of the rt patch maintainers will reply here.
> I've seen the first patch and it was not mentioned that it was RT
> related so I did not pay any attention to it.
> Please repost your v2, please add RT next to patch, please state the RT
> version and the actual problem and I take a look.
>
>> Jörg
> Sebastian

