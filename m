Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D965256F8
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 23:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358700AbiELVUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 17:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358701AbiELVUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 17:20:05 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B0E1D5033
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:20:04 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2f7ca2ce255so71091397b3.7
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/IBL4o/K3mi7O3S3vncGMcGF2ntCO5oHKAbwaK5FrhU=;
        b=hELtvxKSnPKMqfkxLXWz76N3K0+kWx1DjCEsVBJV7/WAEebNdg48uYU8qNN6aazczF
         IsPWtfxWGEzvPpv5JRFZ9BPsCIpnhUp8FPPalYzoK/eGrRg2110rs30xyMtta4yux9hj
         LieyKQA2OW2opwre4pB/XuQW47eQDxLZJiqUihu4ORAOgPAvMFNiiUEr4ASpEX3nhiKs
         onr0MhrvpSMd4vkTqFshMtqwBThqa8+2cDfywqcOn2owHlcS5F/BH5GIi+PRinhthEGd
         v0BPJfHih4FhWtjJ4fRiHmqGxcW/qyOHYl4YMSHz0W9XdYmlBENa78LBqdgweWUFW35K
         RFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/IBL4o/K3mi7O3S3vncGMcGF2ntCO5oHKAbwaK5FrhU=;
        b=rs2r6rRo5uADaPy1YqzXx0m60kU/vuV6tVZSCKpeq2PL6qNyifB2BmHJVTRmqqJkSS
         J6isXLdX+qMHqzzveWZ2F849Hzk4aJrH5wMPxwxKWTOsoExDuasXPhe/j9iRHJXs3bGS
         KzfvamK2hqPqz4JTvDapYzb7BBM7f01cNaoqB5bJLZVXYclTCYfG1UdmrtacUgE/zWma
         nI4Z3uVjuAGY2woE8tONSboZ6rgnv57u3N71e/ulS8AuCK0t7eo09MD9y/ou8CzaNdQQ
         rGKzDQUOorNXIK0KXPRwpRzGXFB6wWdrqZeK2oHxijsUUG7hACHVlVO39s9dLHMmjlR+
         XXQw==
X-Gm-Message-State: AOAM532+TcNGWje9nkzFvMhiCn7Heug/5GO4bFg+62Rjqco4bSNH72jX
        8aJZn96P6Mbtz5q5ilpqmvmfy2IF51gynJQxZZcfTQ==
X-Google-Smtp-Source: ABdhPJwzmScp1gkmaRv6Z/2UeYUR9CWL4fXMGCQz5h1SoR9lDHX9i34sDFrwGKr+ekzktV1L0icy+oYwcpSGoLiMGDg=
X-Received: by 2002:a81:a016:0:b0:2f7:cfa3:4dc3 with SMTP id
 x22-20020a81a016000000b002f7cfa34dc3mr2153337ywg.467.1652390402987; Thu, 12
 May 2022 14:20:02 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000005f1a8805ded719cc@google.com>
In-Reply-To: <0000000000005f1a8805ded719cc@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 12 May 2022 14:19:51 -0700
Message-ID: <CANn89i+XHh1An6fDA0CH1Fb2k_-G8_CCzEmXGKqB4tRAMH9s4w@mail.gmail.com>
Subject: Re: [syzbot] UBSAN: shift-out-of-bounds in tcf_pedit_init
To:     syzbot <syzbot+8ed8fc4c57e9dcf23ca6@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 2:18 PM syzbot
<syzbot+8ed8fc4c57e9dcf23ca6@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    810c2f0a3f86 mlxsw: Avoid warning during ip6gre device rem..
> git tree:       net
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1448a599f00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=331feb185f8828e0
> dashboard link: https://syzkaller.appspot.com/bug?extid=8ed8fc4c57e9dcf23ca6
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104e9749f00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15f913b9f00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8ed8fc4c57e9dcf23ca6@syzkaller.appspotmail.com
>
> netlink: 28 bytes leftover after parsing attributes in process `syz-executor151'.
> netlink: 28 bytes leftover after parsing attributes in process `syz-executor151'.
> ================================================================================
> UBSAN: shift-out-of-bounds in net/sched/act_pedit.c:238:43
> shift exponent 1400735974 is too large for 32-bit type 'unsigned int'
> CPU: 0 PID: 3606 Comm: syz-executor151 Not tainted 5.18.0-rc5-syzkaller-00165-g810c2f0a3f86 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  ubsan_epilogue+0xb/0x50 lib/ubsan.c:151
>  __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x187 lib/ubsan.c:322
>  tcf_pedit_init.cold+0x1a/0x1f net/sched/act_pedit.c:238
>  tcf_action_init_1+0x414/0x690 net/sched/act_api.c:1367
>  tcf_action_init+0x530/0x8d0 net/sched/act_api.c:1432
>  tcf_action_add+0xf9/0x480 net/sched/act_api.c:1956
>  tc_ctl_action+0x346/0x470 net/sched/act_api.c:2015
>  rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5993
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1921
>  sock_sendmsg_nosec net/socket.c:705 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:725
>  ____sys_sendmsg+0x6e2/0x800 net/socket.c:2413
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fe36e9e1b59
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffef796fe88 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe36e9e1b59
> RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003
> RBP: 00007fe36e9a5d00 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe36e9a5d90
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> ================================================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

As mentioned earlier, this came with

commit 8b796475fd7882663a870456466a4fb315cc1bd6
Author: Paolo Abeni <pabeni@redhat.com>
Date:   Tue May 10 16:57:34 2022 +0200

    net/sched: act_pedit: really ensure the skb is writable
