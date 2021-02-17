Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1039031E2F6
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 00:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhBQXOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 18:14:41 -0500
Received: from www62.your-server.de ([213.133.104.62]:34654 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhBQXOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 18:14:40 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lCW17-0007mH-65; Thu, 18 Feb 2021 00:13:57 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lCW16-000QzQ-VM; Thu, 18 Feb 2021 00:13:57 +0100
Subject: Re: [Patch bpf-next] bpf: clear per_cpu pointers in
 bpf_prog_clone_create()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>
References: <20210217035844.53746-1-xiyou.wangcong@gmail.com>
 <c24360ab-f4b3-db61-4c83-9fb941520304@iogearbox.net>
 <CAM_iQpX1GLG5SW7z5GRTntXTj0-Zvh84BKaOV_5r1akx9rGEOg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <585ce6bc-b95b-28b1-14a5-3cfdce76e1e7@iogearbox.net>
Date:   Thu, 18 Feb 2021 00:13:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAM_iQpX1GLG5SW7z5GRTntXTj0-Zvh84BKaOV_5r1akx9rGEOg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26083/Wed Feb 17 13:11:33 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/21 11:46 PM, Cong Wang wrote:
> On Wed, Feb 17, 2021 at 2:01 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 2/17/21 4:58 AM, Cong Wang wrote:
>>> From: Cong Wang <cong.wang@bytedance.com>
>>>
>>> Pretty much similar to commit 1336c662474e
>>> ("bpf: Clear per_cpu pointers during bpf_prog_realloc") we also need to
>>> clear these two percpu pointers in bpf_prog_clone_create(), otherwise
>>> would get a double free:
>>>
>>>    BUG: kernel NULL pointer dereference, address: 0000000000000000
>>>    #PF: supervisor read access in kernel mode
>>>    #PF: error_code(0x0000) - not-present page
>>>    PGD 0 P4D 0
>>>    Oops: 0000 [#1] SMP PTI
>>>    CPU: 13 PID: 8140 Comm: kworker/13:247 Kdump: loaded Tainted: G         W   OE
>>>   5.11.0-rc4.bm.1-amd64+ #1
>>>    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
>>>    test_bpf: #1 TXA
>>>    Workqueue: events bpf_prog_free_deferred
>>>    RIP: 0010:percpu_ref_get_many.constprop.97+0x42/0xf0
>>>    Code: [...]
>>>    RSP: 0018:ffffa6bce1f9bda0 EFLAGS: 00010002
>>>    RAX: 0000000000000001 RBX: 0000000000000000 RCX: 00000000021dfc7b
>>>    RDX: ffffffffae2eeb90 RSI: 867f92637e338da5 RDI: 0000000000000046
>>>    RBP: ffffa6bce1f9bda8 R08: 0000000000000000 R09: 0000000000000001
>>>    R10: 0000000000000046 R11: 0000000000000000 R12: 0000000000000280
>>>    R13: 0000000000000000 R14: 0000000000000000 R15: ffff9b5f3ffdedc0
>>>    FS:   0000000000000000(0000) GS:ffff9b5f2fb40000(0000) knlGS:0000000000000000
>>>    CS:   0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>    CR2: 0000000000000000 CR3: 000000027c36c002 CR4: 00000000003706e0
>>>    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>    Call Trace:
>>>    refill_obj_stock+0x5e/0xd0
>>>    free_percpu+0xee/0x550
>>>    __bpf_prog_free+0x4d/0x60
>>>    process_one_work+0x26a/0x590
>>>    worker_thread+0x3c/0x390
>>>    ? process_one_work+0x590/0x590
>>>    kthread+0x130/0x150
>>>    ? kthread_park+0x80/0x80
>>>    ret_from_fork+0x1f/0x30
>>>
>>> This bug is 100% reproducible with test_kmod.sh.
>>>
>>> Reported-by: Jiang Wang <jiang.wang@bytedance.com>
>>> Fixes: 700d4796ef59 ("bpf: Optimize program stats")
>>> Fixes: ca06f55b9002 ("bpf: Add per-program recursion prevention mechanism")
>>> Cc: Alexei Starovoitov <ast@kernel.org>
>>> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
>>> ---
>>>    kernel/bpf/core.c | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>>> index 0ae015ad1e05..b0c11532e535 100644
>>> --- a/kernel/bpf/core.c
>>> +++ b/kernel/bpf/core.c
>>> @@ -1103,6 +1103,8 @@ static struct bpf_prog *bpf_prog_clone_create(struct bpf_prog *fp_other,
>>>                 * this still needs to be adapted.
>>>                 */
>>>                memcpy(fp, fp_other, fp_other->pages * PAGE_SIZE);
>>> +             fp_other->stats = NULL;
>>> +             fp_other->active = NULL;
>>>        }
>>>
>>>        return fp;
>>
>> This is not correct. I presume if you enable blinding and stats, then this will still
> 
> Well, at least I ran all BPF selftests and found no crash. (Before my patch, the
> crash happened 100%.)
> 
>> crash. The proper way to fix it is to NULL these pointers in bpf_prog_clone_free()
>> since the clone can be promoted as the actual prog and the prog ptr released instead.
> 
> Not sure if I understand your point, but what I cleared is fp_other,
> which is the original, not the clone. And of course, the original would
> be overriden:
> 
>          tmp = bpf_jit_blind_constants(prog);
>          if (IS_ERR(tmp))
>                  return orig_prog;
>          if (tmp != prog) {
>                  tmp_blinded = true;
>                  prog = tmp;  // <=== HERE
>          }
> 
> I think this is precisely why the crash does not happen after my patch.
> 
> However, it does seem to me patching bpf_prog_clone_free() is better,
> as there would be no assumption on using the original. All I want to
> say here is that both ways could fix the crash, which one is better is
> arguable.

The problem is that at the time of bpf_prog_clone_create() we don't know whether
the original prog or the clone will be used eventually. If the original (fp_other)
will in-fact be used, then stats/active there is NULL. And if the bpf_stats_enabled_key
static key is active, then __BPF_PROG_RUN() will just try to update stats and trigger
a NULL ptr deref, but it won't if done in bpf_prog_clone_free(). So the latter really
is necessary.

Thanks,
Daniel
