Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C32E2EB64F
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbhAEXe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbhAEXe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 18:34:28 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F844C061796;
        Tue,  5 Jan 2021 15:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=zvdJKOFKPiv1O4Q5LnvczVzz6+RFlxSoufhrTRjaAwA=; b=EMkmZ7dL+lZzQLXEDFNgf1HrHF
        Qdyv6Ewo4KtBUM9L5AMAZNDxmdfMakzRv0+nDgbU8e6aAjWn9c+RoFEYczSKP46qv4tJNcFlNiZxH
        YczjbuD5Wvvy3rxLypuTCfM5/uUVOA45JKoXM22FmJ8A/sBrmgOme2vNj6wN/6vpnZuOQ5kT0v/f1
        C4X/5xYKF36z5gptyvUZYH6ptyeMC1wLeFh/1e2NaiZ+Udzqb/NfnlXDjG9jzWXD/ISougU5Y8CQV
        eBVSvQ7ajihvPZYIDbe8MkAcctkqk/hN6LsTCPwC/B/hokpYMy1thCCr6UKGe2S4YGo0WxiBfd+dY
        2tarG4jw==;
Received: from [2601:1c0:6280:3f0::64ea]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kwvpf-0000Dv-Cs; Tue, 05 Jan 2021 23:33:43 +0000
Subject: Re: UBSAN: shift-out-of-bounds in gred_change
To:     syzbot <syzbot+1819b70451246ed8cf57@syzkaller.appspotmail.com>,
        davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
References: <000000000000532e0205b7c90942@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <51eeefd9-2f75-a402-c480-cc464918d547@infradead.org>
Date:   Tue, 5 Jan 2021 15:33:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <000000000000532e0205b7c90942@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/31/20 1:09 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    3db1a3fa Merge tag 'staging-5.11-rc1' of git://git.kernel...
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=155708db500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2ae878fbf640b72b
> dashboard link: https://syzkaller.appspot.com/bug?extid=1819b70451246ed8cf57
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=176b78c0d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12993797500000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+1819b70451246ed8cf57@syzkaller.appspotmail.com

#syz fix: net: sched: prevent invalid Scell_log shift count

> IPVS: ftp: loaded support on port[0] = 21
> ================================================================================
> UBSAN: shift-out-of-bounds in ./include/net/red.h:252:22
> shift exponent 255 is too large for 32-bit type 'int'
> CPU: 0 PID: 8465 Comm: syz-executor194 Not tainted 5.10.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:120
>  ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
>  __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
>  red_set_parms include/net/red.h:252 [inline]
>  gred_change_vq net/sched/sch_gred.c:506 [inline]
>  gred_change.cold+0xce/0xe2 net/sched/sch_gred.c:702
>  qdisc_change net/sched/sch_api.c:1331 [inline]
>  tc_modify_qdisc+0xd4e/0x1a30 net/sched/sch_api.c:1633
>  rtnetlink_rcv_msg+0x493/0xb40 net/core/rtnetlink.c:5564
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
>  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
>  netlink_sendmsg+0x907/0xe10 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg+0xd3/0x130 net/socket.c:672
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2336
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2390
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2423
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x440e69
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 0b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fff634be6d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00000000004a2730 RCX: 0000000000440e69
> RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
> RBP: 00007fff634be6e0 R08: 0000000120080522 R09: 0000000120080522
> R10: 0000000120080522 R11: 0000000000000246 R12: 00000000004a2730
> R13: 0000000000402390 R14: 0000000000000000 R15: 0000000000000000
> ================================================================================


-- 
~Randy

