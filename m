Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48F3C5B09F2
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiIGQSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiIGQSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:18:47 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C053A0314
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 09:18:45 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id r141so11895921iod.4
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 09:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=3zNN3wcgN+vd2wpUDCMnqQdDRuWeI+hRUZA1kdW/gBw=;
        b=s0yX+1Tsw+LGKp/WuH2QNVA6JtpdWfgnp9Uv9TymdUg3eW6kR5/FzIEuoPu5nQqteo
         w1kMgFQCG2O8ecgqQAEr7t1EsDpVGp2NzdD8btlZStwFyOSIDGMGy7tLEAGxnkenlWtR
         iOryB9grGozUoWHC8y64+2QMmDxLcb85zFbjBN5bsFfo6+N7Tnwsol5N6TdWXm3MfTNk
         X2roSYWVOvaBCQfT3bAWemt9UpSTzGFTAvxce+5EdHyzvJALBBOZ0PsFY50SfpISGrKw
         FQxa+c0r9N5De2B994r220T/VGxDcdpux7x5pc6svCDXkMsoxZqm2ApGffdpT2SXse2U
         +UQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=3zNN3wcgN+vd2wpUDCMnqQdDRuWeI+hRUZA1kdW/gBw=;
        b=IR3mGAI49OnPmf6YAVg9b4Sf4167+ZkCHKQcuTEINztajUxZ0/VIntriYXcxGReCwI
         HA/YEAbkLON0LfpmCP6JbQbphBI+DVxaROsLgugJSUbwyvjsI9Il6u1EymnJFRz+m/mA
         7HNWnJ71q/NUPU3wAVqGToQnAfDN60nob5oO6PnS9NKYABw9qbdKCSE86yWQml7ffWWH
         OrqjnEYh0q3vHqjI73/+CKA/ywTANfxWQeMlOy2RNgm64O23/QwWrr4kq/1LXmfxIHQ9
         mGCuKkajltzrwK3OTRhfaSLjcwhF4EFKplqnPGbX0UQTaWfuGtWNE3fO7Ek0XtrZI3u5
         q0Qw==
X-Gm-Message-State: ACgBeo0o/L/K+FCfXbGC50aWCreq7ut4HMin3wcs1dALgRVN/uFtnnWI
        55M5YkQzkJdupL4pkYZUmZdHhAqif5XGs4hfTlqdzA==
X-Google-Smtp-Source: AA6agR5Ped6k79ynll8L86xxWr9/kOoRwDvPtAc2Cm+IZifGBnCuZO+iMYna3+YXEkXm+lBYb6r8nh6o3dnRJIZO1cg=
X-Received: by 2002:a05:6638:2042:b0:346:e51a:da4e with SMTP id
 t2-20020a056638204200b00346e51ada4emr2539678jaj.164.1662567524331; Wed, 07
 Sep 2022 09:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220907101204.255213-1-luwei32@huawei.com>
In-Reply-To: <20220907101204.255213-1-luwei32@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Sep 2022 09:18:33 -0700
Message-ID: <CANn89i+eMg-fg8VicJn5LqXx-EwJ3WQuswQEPwRNSadxP_w35Q@mail.gmail.com>
Subject: Re: [PATCH net] ipvlan: Fix out-of-bound bugs caused by unset skb->mac_header
To:     Lu Wei <luwei32@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, vulab@iscas.ac.cn,
        Mahesh Bandewar <maheshb@google.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 7, 2022 at 3:09 AM Lu Wei <luwei32@huawei.com> wrote:
>
> If an AF_PACKET socket is used to send packets through ipvlan and the
> default xmit function of the AF_PACKET socket is changed from
> dev_queue_xmit() to packet_direct_xmit() via setsockopt() with the option
> name of PACKET_QDISC_BYPASS, the skb->mac_header may not be reset and
> remains as the initial value of 65535, this may trigger slab-out-of-bounds
> bugs as following:
>
> =================================================================
> UG: KASAN: slab-out-of-bounds in ipvlan_xmit_mode_l2+0xdb/0x330 [ipvlan]

>
> Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---

This was on my TODO list, I had a similar KASAN report, after my
recent addition in skb_mac_header()

DEBUG_NET_WARN_ON_ONCE(!skb_mac_header_was_set(skb));

Reviewed-by: Eric Dumazet <edumazet@google.com>

WARNING: CPU: 1 PID: 14752 at include/linux/skbuff.h:2821
skb_mac_header include/linux/skbuff.h:2821 [inline]
WARNING: CPU: 1 PID: 14752 at include/linux/skbuff.h:2821 eth_hdr
include/linux/if_ether.h:24 [inline]
WARNING: CPU: 1 PID: 14752 at include/linux/skbuff.h:2821
ipvlan_xmit_mode_l2 drivers/net/ipvlan/ipvlan_core.c:592 [inline]
WARNING: CPU: 1 PID: 14752 at include/linux/skbuff.h:2821
ipvlan_queue_xmit+0xcba/0x19d0 drivers/net/ipvlan/ipvlan_core.c:644
Modules linked in:
CPU: 1 PID: 14752 Comm: syz-executor.4 Not tainted 6.0.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 07/22/2022
RIP: 0010:skb_mac_header include/linux/skbuff.h:2821 [inline]
RIP: 0010:eth_hdr include/linux/if_ether.h:24 [inline]
RIP: 0010:ipvlan_xmit_mode_l2 drivers/net/ipvlan/ipvlan_core.c:592 [inline]
RIP: 0010:ipvlan_queue_xmit+0xcba/0x19d0 drivers/net/ipvlan/ipvlan_core.c:644
Code: 41 0f b7 d6 48 c7 c6 40 c7 75 8a 48 c7 c7 c0 c4 75 8a c6 05 7d
52 d9 08 01 e8 df 0d 4a 04 0f 0b e9 e5 f7 ff ff e8 66 cb 8b fc <0f> 0b
e9 ac f8 ff ff e8 6a 35 d8 fc e9 ed f4 ff ff e8 70 35 d8 fc
RSP: 0018:ffffc900069b7808 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8880456ea000 RCX: 0000000000000000
RDX: ffff8880214c5880 RSI: ffffffff84f03eca RDI: 0000000000000003
RBP: ffffc900069b79b8 R08: 0000000000000003 R09: 000000000000ffff
R10: 000000000000ffff R11: 0000000000000000 R12: ffff888075d62140
R13: 1ffff92000d36f06 R14: 000000000000ffff R15: ffff8880456eaca0
FS: 00007f2302712700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f23005fe718 CR3: 000000001f461000 CR4: 00000000003506e0
Call Trace:
<TASK>
ipvlan_start_xmit+0x45/0x150 drivers/net/ipvlan/ipvlan_main.c:220
__netdev_start_xmit include/linux/netdevice.h:4819 [inline]
netdev_start_xmit include/linux/netdevice.h:4833 [inline]
__dev_direct_xmit+0x500/0x720 net/core/dev.c:4312
dev_direct_xmit include/linux/netdevice.h:3021 [inline]
packet_direct_xmit+0x1b3/0x2c0 net/packet/af_packet.c:282
packet_snd net/packet/af_packet.c:3073 [inline]
packet_sendmsg+0x3354/0x5500 net/packet/af_packet.c:3104
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg+0xcf/0x120 net/socket.c:734
__sys_sendto+0x236/0x340 net/socket.c:2117
__do_sys_sendto net/socket.c:2129 [inline]
__se_sys_sendto net/socket.c:2125 [inline]
__x64_sys_sendto+0xdd/0x1b0 net/socket.c:2125
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f2301689279
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2302712168 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f230179c120 RCX: 00007f2301689279
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007f23016e3189 R08: 00000000200000c0 R09: 0000000000000014
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2301ccfb1f R14: 00007f2302712300 R15: 0000000000022000
</TASK>
