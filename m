Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A374855DE
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241481AbiAEP2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241463AbiAEP2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:28:42 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021A1C061245;
        Wed,  5 Jan 2022 07:28:42 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id z29so163448454edl.7;
        Wed, 05 Jan 2022 07:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=zdYBBqitcn4lE/SNNP4CgrCHxIY29UjU1zD3r0bjR+c=;
        b=fz9Vjlkm/t8j6d+Dp7aKgznxKeyrqiigsRtcj6k6HdCkhvB5T8pnJ83HULWQl5X/ca
         dB7xQowpf0AUu8057uaSkec6UIlPkaKi6OIutY+zfHpcWUXj8F64szsnfTasN8MAyg3F
         vuhaX0BMiGeGbK4KeC6/ozPUyYrouV4p60h1duYC0Xgx91WDlAD84fB99gGA50na4cD5
         P5TmGtxBo2HRS9Te31WWeoaBKfaCnkQ56kQVVDx06OWtfIqGidRzpTHZRaBwXb6ecspe
         MuNlC6YfDNZc1jfROLnorLKPy+b7FIA0bwO32YWKQMYLRXJ1PP4x+Z/fB3XLQIEsl2oC
         5cvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=zdYBBqitcn4lE/SNNP4CgrCHxIY29UjU1zD3r0bjR+c=;
        b=UWn3WmwASGVKNXN7Tr02TItpBnMjBlVKKYcsM0XuEGouNCfJmF9a4K3w2K9gxBnMhh
         KFWmvrXusUIjIj+CRsccmk+d+xbxCdMr/+OGaIlTCBXTLQ3Wqx+tja0vDOC8cMxSbduL
         o8sPy2NRSVkfFb2TE8aMfCEuyfiBKx3h7AFcFEXAfEUIWyfXSQB3T5YhpnkduafGE3Xg
         kEvfkUhaY/E6JJPGCZzzU+LmMAr/5gBWi4BqIUYbn7yj3PSjuzWXEc1avkphKdEKGTN0
         YtI69CR0F7Ci6uLjzzLRpQRJg/td0AbBivxhP8PRaCNtZAqtH4Ki+xoK9P6OiEHDnEFa
         EowA==
X-Gm-Message-State: AOAM5324REgtYwr3wvAXv3fV2B3zWAf6EsgwmxoiFdevEsUM3CP5AJo4
        DRju6b3Bz648qsCQnsxy6/dECcJWdobE92TSy4s=
X-Google-Smtp-Source: ABdhPJyZcwh3lBlPuEJCe8785wDQ/0nVYF9M3nYIqJTe/NzYFNE9W6qWSz7cwQJVFdXTgGT2nePZzp4ZFNeJDrGZvzo=
X-Received: by 2002:a17:907:7256:: with SMTP id ds22mr43216489ejc.556.1641396520459;
 Wed, 05 Jan 2022 07:28:40 -0800 (PST)
MIME-Version: 1.0
From:   "Sabri N. Ferreiro" <snferreiro1@gmail.com>
Date:   Wed, 5 Jan 2022 23:28:29 +0800
Message-ID: <CAKG+3NQu2qFNZFP7XFkt0gEKShjO2rMxo+1WTbejekdUeQLNwQ@mail.gmail.com>
Subject: BUG: unable to handle kernel NULL pointer dereference in iptable_nat_table_init
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     mosesfonscqf75@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

When using Syzkaller to fuzz the Linux kernel, it triggers the following crash.

HEAD commit: a7904a538933 Linux 5.16-rc6
git tree: upstream
console output:
https://docs.google.com/document/d/1hfN-JPPEtV8aGF9OvIboVVu7XYgUp-tp9G7DVXWNJ6k/view
kernel config: https://docs.google.com/document/d/1w94kqQ4ZSIE6BW-5WIhqp4_Zh7XTPH57L5OF2Xb6O6o/view

If you fix this issue, please add the following tag to the commit:
Reported-by:  Yuheng Shen <mosesfonscqf75@gmail.com>

Sorry for my lack of this crash reproducer, I hope the symbolic report
will help you.

audit: type=1400 audit(1641210298.987:9): avc:  denied  { module_load
} for  pid=2094 comm="modprobe"
path="/lib/modules/5.15.0-rc6/kernel/net/ipv4/netfilter/iptable_nat.ko"
dev="sda" ino=429877 scontext=system_u:system_r:kernel_t:s0
tcontext=system_u:object_r:unlabeled_t:s0 tclass=system permissive=1
BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 0 P4D 0
Oops: 0002 [#1] SMP KASAN NOPTI
CPU: 1 PID: 350 Comm: syz-executor.3 Not tainted 5.15.0-rc6 #10
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
RIP: 0010:iptable_nat_table_init+0xc9/0x150 [iptable_nat]
Code: 00 00 49 89 c7 31 db 4d 89 67 10 4c 89 fe 48 89 ef e8 8b 0e 06
f4 85 c0 75 30 83 c3 01 49 83 c7 28 83 fb 04 75 e1 48 8b 0c 24 <4c> 89
31 4c 89 ef 89 04 24 e8 49 7b 66 f2 8b 04 24 48 83 c4 08 5b
RSP: 0018:ffff8880039ef9a0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000000000
RDX: ffff888001daa180 RSI: 0000000000000000 RDI: ffff8880039ef8d0
RBP: ffff888025150000 R08: 0000000000000001 R09: ffff8880039ef8d7
R10: ffffed100073df1a R11: 0000000000000001 R12: ffff8880056f2000
R13: ffff888001bdb800 R14: ffff888004ac7700 R15: ffff888004ac77a0
FS:  0000555555766480(0000) GS:ffff88806d280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000004654004 CR4: 0000000000770ee0
PKRU: 55555554
Call Trace:
 xt_find_table_lock+0x2a3/0x450
root/fuzz/kernel/5.15/net/netfilter/x_tables.c:1259
 xt_request_find_table_lock+0x25/0xb0
root/fuzz/kernel/5.15/net/netfilter/x_tables.c:1284
 get_info+0x133/0x4b0 root/fuzz/kernel/5.15/net/ipv6/netfilter/ip6_tables.c:981
 do_ipt_get_ctl+0x12f/0x850
root/fuzz/kernel/5.15/net/ipv4/netfilter/ip_tables.c:1653
 nf_getsockopt+0x65/0xc0 root/fuzz/kernel/5.15/net/netfilter/nf_sockopt.c:116
 ip_getsockopt root/fuzz/kernel/5.15/net/ipv4/ip_sockglue.c:1777 [inline]
 ip_getsockopt+0x115/0x150 root/fuzz/kernel/5.15/net/ipv4/ip_sockglue.c:1756
 tcp_getsockopt+0x7e/0xc0 root/fuzz/kernel/5.15/net/ipv4/tcp.c:4254
 __sys_getsockopt+0x128/0x220 root/fuzz/kernel/5.15/net/socket.c:2220
 __do_sys_getsockopt root/fuzz/kernel/5.15/net/socket.c:2235 [inline]
 __se_sys_getsockopt root/fuzz/kernel/5.15/net/socket.c:2232 [inline]
 __x64_sys_getsockopt+0xba/0x150 root/fuzz/kernel/5.15/net/socket.c:2232
 do_syscall_x64 root/fuzz/kernel/5.15/arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x38/0x90 root/fuzz/kernel/5.15/arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f56ab2736de
Code: 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f
84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 37 00 00 00 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff93e04eb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f56ab2736de
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00007fff93e04eec R09: 0000000000000278
R10: 00007f56ab3662c8 R11: 0000000000000246 R12: 00007fff93e04eec
R13: 00007f56ab2e52b5 R14: 00007f56ab3662c8 R15: 00007f56ab3662c0
Modules linked in: iptable_nat
CR2: 0000000000000000
---[ end trace e420cba137499491 ]---
