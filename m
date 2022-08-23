Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A821059EF46
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 00:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbiHWWbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 18:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbiHWWbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 18:31:00 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA23140FA;
        Tue, 23 Aug 2022 15:30:31 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oQcOr-0006Bb-J0; Wed, 24 Aug 2022 00:29:33 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oQcOr-0003hJ-0x; Wed, 24 Aug 2022 00:29:33 +0200
Subject: Re: [PATCH bpf-next 0/3] A couple of small refactorings of BPF
 program call sites
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20220818165906.64450-1-toke@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3201a036-f5f8-5abe-adb3-ba70eaf21e44@iogearbox.net>
Date:   Wed, 24 Aug 2022 00:29:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220818165906.64450-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26636/Tue Aug 23 09:52:45 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/22 6:59 PM, Toke Høiland-Jørgensen wrote:
> Stanislav suggested[0] that these small refactorings could be split out from the
> XDP queueing RFC series and merged separately. The first change is a small
> repacking of struct softnet_data, the others change the BPF call sites to
> support full 64-bit values as arguments to bpf_redirect_map() and as the return
> value of a BPF program, relying on the fact that BPF registers are always 64-bit
> wide to maintain backwards compatibility.
> 
> Please see the individual patches for details.
> 
> [0] https://lore.kernel.org/r/CAKH8qBtdnku7StcQ-SamadvAF==DRuLLZO94yOR1WJ9Bg=uX1w@mail.gmail.com
> 
> Kumar Kartikeya Dwivedi (1):
>    bpf: Use 64-bit return value for bpf_prog_run
> 
> Toke Høiland-Jørgensen (2):
>    dev: Move received_rps counter next to RPS members in softnet data
>    bpf: Expand map key argument of bpf_redirect_map to u64

Looks like this series throws NULL pointer derefs in the CI. I just reran it and
same result whereas various other bpf-next targeted patches CI seems green and w/o
below panic ... perhaps an issue in last patch; please investigate.

https://github.com/kernel-patches/bpf/runs/7982907380?check_suite_focus=true

   [...]
   #231     verif_scale_strobemeta:OK
   #232     verif_scale_strobemeta_bpf_loop:OK
   #233     verif_scale_strobemeta_nounroll1:OK
   #234     verif_scale_strobemeta_nounroll2:OK
   #235     verif_scale_strobemeta_subprogs:OK
   #236     verif_scale_sysctl_loop1:OK
   #237     verif_scale_sysctl_loop2:OK
   #238     verif_scale_xdp_loop:OK
   #239     verif_stats:OK
   #240     verif_twfw:OK
   [  828.755223] BUG: kernel NULL pointer dereference, address: 0000000000000000
   [  828.755223] #PF: supervisor instruction fetch in kernel mode
   [  828.755223] #PF: error_code(0x0010) - not-present page
   [  828.755223] PGD 0 P4D 0
   [  828.755223] Oops: 0010 [#1] PREEMPT SMP NOPTI
   [  828.755223] CPU: 4 PID: 0 Comm: swapper/4 Tainted: G           OE      5.19.0-g3141b1878b85 #1
   [  828.755223] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
   [  828.755223] RIP: 0010:0x0
   [  828.755223] Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
   [  828.755223] RSP: 0018:ffffbccd400b3ea8 EFLAGS: 00000046
   [  828.755223] RAX: 0000000000000002 RBX: ffff9e79f9d1efc0 RCX: 000000000000000a
   [  828.755223] RDX: 0000000000000000 RSI: 000000d2fe34b800 RDI: ffff9e79f9d1efc0
   [  828.755223] RBP: 000000d2fe34b800 R08: 0000000000000000 R09: 0000000000000000
   [  828.755223] R10: 00000000000f4240 R11: ffffffffb5062510 R12: 0000000000000015
   [  828.755223] R13: 7fffffffffffffff R14: 0000000000000004 R15: 000000d2fe34b800
   [  828.767338] FS:  0000000000000000(0000) GS:ffff9e79f9d00000(0000) knlGS:0000000000000000
   [  828.767338] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   [  828.767338] CR2: ffffffffffffffd6 CR3: 0000000100970000 CR4: 00000000000006e0
   [  828.767338] Call Trace:
   [  828.767338]  <TASK>
   [  828.767338]  tick_nohz_idle_stop_tick+0x1da/0x380
   [  828.767338]  do_idle+0xe6/0x280
   [  828.767338]  cpu_startup_entry+0x19/0x20
   [  828.767338]  start_secondary+0x8f/0x90
   [  828.767338]  secondary_startup_64_no_verify+0xe1/0xeb
   [  828.767338]  </TASK>
   [  828.767338] Modules linked in: bpf_testmod(OE) [last unloaded: bpf_testmod(OE)]
   [  828.767338] CR2: 0000000000000000
   [  828.767338] ---[ end trace 0000000000000000 ]---
   [  828.758172] BUG: kernel NULL pointer dereference, address: 0000000000000000
   [  828.758172] #PF: supervisor instruction fetch in kernel mode
   [  828.758172] #PF: error_code(0x0010) - not-present page
   [  828.758172] PGD 0 P4D 0
   [  828.767338] RIP: 0010:0x0
   [  828.758172] Oops: 0010 [#2] PREEMPT SMP NOPTI
   [  828.758172] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G      D    OE      5.19.0-g3141b1878b85 #1
   [  828.758172] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
   [  828.767338] Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
   [  828.767338] RSP: 0018:ffffbccd400b3ea8 EFLAGS: 00000046
   [  828.758172] RIP: 0010:0x0
   [  828.767338]
   [  828.758172] Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
   [  828.767338] RAX: 0000000000000002 RBX: ffff9e79f9d1efc0 RCX: 000000000000000a
   [  828.767338] RDX: 0000000000000000 RSI: 000000d2fe34b800 RDI: ffff9e79f9d1efc0
   [  828.767338] RBP: 000000d2fe34b800 R08: 0000000000000000 R09: 0000000000000000
   [  828.758172] RSP: 0018:ffffbccd400cbea0 EFLAGS: 00000046
   [  828.767338] R10: 00000000000f4240 R11: ffffffffb5062510 R12: 0000000000000015
   [  828.767338] R13: 7fffffffffffffff R14: 0000000000000004 R15: 000000d2fe34b800
   [  828.758172]
   [  828.758172] RAX: 0000000000000005 RBX: ffff9e79f9ddefc0 RCX: 000000000000000a
   [  828.758172] RDX: 0000000000000000 RSI: 000000c0f6c7a580 RDI: ffff9e79f9ddefc0
   [  828.767338] FS:  0000000000000000(0000) GS:ffff9e79f9d00000(0000) knlGS:0000000000000000
   [  828.758172] RBP: 0000000000000013 R08: 7fffffffffffffff R09: 000000c0f6b86340
   [  828.767338] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   [  828.758172] R10: 00000000000f4240 R11: ffffffffb5062510 R12: 0000000000000000
   [  828.758172] R13: 0000000000000000 R14: 000000c0f6bc6d28 R15: 0000000000000000
   [  828.758172] FS:  0000000000000000(0000) GS:ffff9e79f9dc0000(0000) knlGS:0000000000000000
   [  828.767338] CR2: ffffffffffffffd6 CR3: 0000000100970000 CR4: 00000000000006e0
   [  828.758172] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   [  828.767338] Kernel panic - not syncing: Fatal exception
   [  828.758172] CR2: ffffffffffffffd6 CR3: 000000009a836000 CR4: 00000000000006e0
   [  828.758172] Call Trace:
   [  828.758172]  <TASK>
   [  828.758172]  tick_nohz_restart_sched_tick+0x6b/0x90
   [  828.758172]  tick_nohz_idle_exit+0xfc/0x150
   [  828.758172]  do_idle+0x23c/0x280
   [  828.758172]  cpu_startup_entry+0x19/0x20
   [  828.758172]  start_secondary+0x8f/0x90
   [  828.758172]  secondary_startup_64_no_verify+0xe1/0xeb
   [  828.758172]  </TASK>
   [...]
