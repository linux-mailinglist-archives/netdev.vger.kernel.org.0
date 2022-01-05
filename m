Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1288485B93
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 23:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244885AbiAEWWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 17:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244876AbiAEWWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 17:22:49 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96026C061245;
        Wed,  5 Jan 2022 14:22:49 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id p14so628359plf.3;
        Wed, 05 Jan 2022 14:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z8MEE8fwjgVgbLK6khlQ/Jmm6sNUQLnV4pWBI8HU66w=;
        b=UbquMNcjMKVpQA+GgkvI1GrF2VCVcS9JfeYOuHWburjvREd0YWTvAySDHCeRSHXeb8
         PbIDVjO2WEfDaEDyIc5Y51ERhElb6OmF5zeRlNppqhA6n8GMT+bbrezcIx+ljdg5ftYx
         BA15MOVcwC50wQjB2tM67FyxcDjTcneIl3SuXQd1LRF84lFZLnCd4nm2dcgHjoAfbA61
         2PQhFPOAynd3UBFbQ1Rv4FCtxzsUW7FSbCkfbsty52BVTwt9iI+Lxwp6/vgmTaqQGEzi
         NDh0QCXVCjUuC9RabLwv3TJb/Tobck16VH76bdnh05dhSocq9SBHiXnjM+z3T5Sp2YJ5
         zjxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z8MEE8fwjgVgbLK6khlQ/Jmm6sNUQLnV4pWBI8HU66w=;
        b=Fe+ceH0PX6wFVlJdSnxBl6bLmSx0ViMby2qKM57nnLSGKuDuwot4PcSuZCDYdNiGiU
         bVm6WYSHzw9Sohog7D7Y7sa4e4L0mSIi7BgS/lCsNzB8C4WFJ3xnKvh+I47z2+3v6gCB
         M74zqgUfbo+51DISeHXitnZ0KaNNIFNtNM4tzjN0UiBUuscSuXcmL7pO75QQOh6DfSwm
         IuvZf4SSduktbHl3mcoYT3GxG4lNVNlkx3xSnCSB2B5wrZtzZwfVm9xeZzLFa9Stexor
         QlnF798nzstoCWZM+4TLGQDAAOm6NQVlGJnJkvTxTQshkYHUJBHi8CcsTCqdM8DO+viu
         sUMA==
X-Gm-Message-State: AOAM531gLl77wXp3vCxXdzJNo7GYDePT4aDD6LBQD1SVDyxL25hxX7C9
        o+y8L9w5LCMxGov5ixe4QAJsLXOu4VLveBExJAw=
X-Google-Smtp-Source: ABdhPJwT/9k15QN/rZrE7Mi42xiV2Tk8mQXj8K+nb1iTP+PCjPuHWpSbSj1F0aEiqQzBje/tjWfR+7R6UHhrmMX4Xlo=
X-Received: by 2002:a17:902:860c:b0:149:1017:25f0 with SMTP id
 f12-20020a170902860c00b00149101725f0mr55423702plo.116.1641421369064; Wed, 05
 Jan 2022 14:22:49 -0800 (PST)
MIME-Version: 1.0
References: <20220104013153.97906-1-kuniyu@amazon.co.jp> <20220104013153.97906-4-kuniyu@amazon.co.jp>
In-Reply-To: <20220104013153.97906-4-kuniyu@amazon.co.jp>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 5 Jan 2022 14:22:38 -0800
Message-ID: <CAADnVQLFSQk4TJAs3wz2uzyJYVzcprOF4sRV=j3-BQKzEMoz1w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/6] bpf: af_unix: Use batching algorithm in bpf
 unix iter.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 3, 2022 at 5:33 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> The commit 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock")
> introduces the batching algorithm to iterate TCP sockets with more
> consistency.
>
> This patch uses the same algorithm to iterate AF_UNIX sockets.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

There is something wrong in this patch:

./test_progs -t bpf_iter_setsockopt_unix
[   14.993474] bpf_testmod: loading out-of-tree module taints kernel.
[   15.068986]
[   15.069203] =====================================
[   15.069698] WARNING: bad unlock balance detected!
[   15.070187] 5.16.0-rc7-01992-g15d8ab86952d #3780 Tainted: G           O
[   15.070937] -------------------------------------
[   15.071441] test_progs/1438 is trying to release lock
(&unix_table_locks[i]) at:
[   15.072209] [<ffffffff831b7ae9>] unix_next_socket+0x169/0x460
[   15.072825] but there are no more locks to release!
[   15.073329]
[   15.073329] other info that might help us debug this:
[   15.074004] 1 lock held by test_progs/1438:
[   15.074441]  #0: ffff8881072c81c8 (&p->lock){+.+.}-{3:3}, at:
bpf_seq_read+0x61/0xfa0
[   15.075279]
[   15.075279] stack backtrace:
[   15.075744] CPU: 0 PID: 1438 Comm: test_progs Tainted: G
O      5.16.0-rc7-01992-g15d8ab86952d #3780
[   15.076792] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[   15.077986] Call Trace:
[   15.078250]  <TASK>
[   15.078476]  dump_stack_lvl+0x44/0x57
[   15.078873]  lock_release+0x48e/0x650
[   15.079262]  ? unix_next_socket+0x169/0x460
[   15.079712]  ? lock_downgrade+0x690/0x690
[   15.080131]  ? lock_downgrade+0x690/0x690
[   15.080559]  _raw_spin_unlock+0x17/0x40
[   15.080979]  unix_next_socket+0x169/0x460
[   15.081402]  ? bpf_iter_unix_seq_show+0x20b/0x270
[   15.081898]  bpf_iter_unix_batch+0xf7/0x580
[   15.082337]  ? trace_kmalloc_node+0x29/0xd0
[   15.082786]  bpf_seq_read+0x4a1/0xfa0
[   15.083176]  ? up_read+0x1a1/0x720
[   15.083538]  vfs_read+0x128/0x4e0
[   15.083902]  ksys_read+0xe7/0x1b0
[   15.084253]  ? vfs_write+0x8b0/0x8b0
[   15.084638]  do_syscall_64+0x34/0x80
[   15.085016]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   15.085545] RIP: 0033:0x7f2c4a5ad8b2
[   15.085931] Code: 97 20 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb
b6 0f 1f 80 00 00 00 00 f3 0f 1e fa 8b 05 96 db 20 00 85 c0 75 12 31
c0 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 41 54 49 89 d4 55
48 89
[   15.087875] RSP: 002b:00007fff4c8c24b8 EFLAGS: 00000246 ORIG_RAX:
0000000000000000
[   15.088658] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2c4a5ad8b2
[   15.089396] RDX: 0000000000000001 RSI: 00007fff4c8c24cb RDI: 000000000000000a
[   15.090132] RBP: 00007fff4c8c2550 R08: 0000000000000000 R09: 00007fff4c8c2397
[   15.090870] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000040d910
[   15.091618] R13: 00007fff4c8c2750 R14: 0000000000000000 R15: 0000000000000000
[   15.092403]  </TASK>


I've applied patches 1 and 2 to bpf-next.
