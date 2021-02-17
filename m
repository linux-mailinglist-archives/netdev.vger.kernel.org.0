Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C688331E1B9
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 23:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhBQWBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 17:01:50 -0500
Received: from www62.your-server.de ([213.133.104.62]:42266 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhBQWBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 17:01:46 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lCUsY-0000ws-PK; Wed, 17 Feb 2021 23:01:02 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lCUsY-000Rpb-JQ; Wed, 17 Feb 2021 23:01:02 +0100
Subject: Re: [Patch bpf-next] bpf: clear per_cpu pointers in
 bpf_prog_clone_create()
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>
References: <20210217035844.53746-1-xiyou.wangcong@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c24360ab-f4b3-db61-4c83-9fb941520304@iogearbox.net>
Date:   Wed, 17 Feb 2021 23:01:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210217035844.53746-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26083/Wed Feb 17 13:11:33 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/21 4:58 AM, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Pretty much similar to commit 1336c662474e
> ("bpf: Clear per_cpu pointers during bpf_prog_realloc") we also need to
> clear these two percpu pointers in bpf_prog_clone_create(), otherwise
> would get a double free:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: 0000 [#1] SMP PTI
>   CPU: 13 PID: 8140 Comm: kworker/13:247 Kdump: loaded Tainted: G                W    OE
>   5.11.0-rc4.bm.1-amd64+ #1
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
>   test_bpf: #1 TXA
>   Workqueue: events bpf_prog_free_deferred
>   RIP: 0010:percpu_ref_get_many.constprop.97+0x42/0xf0
>   Code: [...]
>   RSP: 0018:ffffa6bce1f9bda0 EFLAGS: 00010002
>   RAX: 0000000000000001 RBX: 0000000000000000 RCX: 00000000021dfc7b
>   RDX: ffffffffae2eeb90 RSI: 867f92637e338da5 RDI: 0000000000000046
>   RBP: ffffa6bce1f9bda8 R08: 0000000000000000 R09: 0000000000000001
>   R10: 0000000000000046 R11: 0000000000000000 R12: 0000000000000280
>   R13: 0000000000000000 R14: 0000000000000000 R15: ffff9b5f3ffdedc0
>   FS:    0000000000000000(0000) GS:ffff9b5f2fb40000(0000) knlGS:0000000000000000
>   CS:    0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000000000000000 CR3: 000000027c36c002 CR4: 00000000003706e0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   Call Trace:
>     refill_obj_stock+0x5e/0xd0
>     free_percpu+0xee/0x550
>     __bpf_prog_free+0x4d/0x60
>     process_one_work+0x26a/0x590
>     worker_thread+0x3c/0x390
>     ? process_one_work+0x590/0x590
>     kthread+0x130/0x150
>     ? kthread_park+0x80/0x80
>     ret_from_fork+0x1f/0x30
> 
> This bug is 100% reproducible with test_kmod.sh.
> 
> Reported-by: Jiang Wang <jiang.wang@bytedance.com>
> Fixes: 700d4796ef59 ("bpf: Optimize program stats")
> Fixes: ca06f55b9002 ("bpf: Add per-program recursion prevention mechanism")
> Cc: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>   kernel/bpf/core.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 0ae015ad1e05..b0c11532e535 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1103,6 +1103,8 @@ static struct bpf_prog *bpf_prog_clone_create(struct bpf_prog *fp_other,
>   		 * this still needs to be adapted.
>   		 */
>   		memcpy(fp, fp_other, fp_other->pages * PAGE_SIZE);
> +		fp_other->stats = NULL;
> +		fp_other->active = NULL;
>   	}
>   
>   	return fp;
> 

This is not correct. I presume if you enable blinding and stats, then this will still
crash. The proper way to fix it is to NULL these pointers in bpf_prog_clone_free()
since the clone can be promoted as the actual prog and the prog ptr released instead.

Thanks,
Daniel
