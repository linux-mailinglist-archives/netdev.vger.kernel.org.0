Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200BA53F368
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 03:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbiFGBfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 21:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiFGBfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 21:35:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE60ACEBB9;
        Mon,  6 Jun 2022 18:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:Cc:References:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=uvs0M6GZCnMQqhbbseu7CMsySA4rqJ9Pk7QxWvyatpo=; b=QBNaXf6yJy/ksOd3AANv0u/w+u
        G+QyiZxqtEFkc9F+uMkh0U64ChdcPGigyrC0tdyUU4qEyfKZ1W0PmEMNZWlBiLmNJYjjqkcLYuQ75
        /WB7LHOUavgM01stSsZEo8D0RLqumi5QrHSvs3WEwfh0SqUe8lfY0mMIGuEsiTMh1rPuPDed45Q8I
        6HlZhTQaK9NRZ8+FIAUSxGnIdiq23FEGQbMxu6nsPvZd53od1k5cy0uxlnjnpTuQ3hxaj7TKVmWDd
        VS6VZ5CYnkCUq/CtsHdXX3o2JJPcaVGSPWWlozI6TC3F95Zn4c1+uPUBw3MKw+AY/JwI0xrWN8eCg
        uUjC3opA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nyO80-00BDww-Va; Tue, 07 Jun 2022 01:35:29 +0000
Message-ID: <9e700705-fae6-503e-1f3c-f12f537f0ca1@infradead.org>
Date:   Mon, 6 Jun 2022 18:35:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [syzbot] BUG: "hc->tx_t_ipi == NUM" holds (exception!) at
 net/dccp/ccids/ccid3.c:LINE/ccid3_update_send_interval()
Content-Language: en-US
To:     syzbot <syzbot+94641ba6c1d768b1e35e@syzkaller.appspotmail.com>,
        davem@davemloft.net, dccp@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000006afc5805d53ca868@google.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Ian McDonald <ian.mcdonald@jandi.co.uk>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <0000000000006afc5805d53ca868@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 1/10/22 08:16, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    82192cb497f9 Merge branch 'ena-capabilities-field-and-cosm..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=12ec95c7b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=322a0a6462d9ff7d
> dashboard link: https://syzkaller.appspot.com/bug?extid=94641ba6c1d768b1e35e
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=100ea4e3b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13977b73b00000
> 
> Bisection is inconclusive: the issue happens on the oldest tested release.

Regarding commit 793734b587a6:
Author: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Date:   Mon Feb 27 12:29:44 2012 -0700

    dccp ccid-3: replace incorrect BUG_ON


Is this an algorithm (RFC) problem or a Linux implementation problem?

Could we round a calculated 0 (unbounded) t_ipi up to 1?

Or is just something "nasty" that the reproducer program is doing?


I ran the C reproducer for about 15 seconds and got 71 occurrences
of this
	DCCP_BUG_ON(hc->tx_t_ipi == 0);

> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13698c63b00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10e98c63b00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17698c63b00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+94641ba6c1d768b1e35e@syzkaller.appspotmail.com
> 
> BUG: "hc->tx_t_ipi == 0" holds (exception!) at net/dccp/ccids/ccid3.c:90/ccid3_update_send_interval()
> CPU: 0 PID: 29976 Comm: syz-executor890 Not tainted 5.16.0-rc8-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  ccid3_update_send_interval net/dccp/ccids/ccid3.c:90 [inline]
>  ccid3_update_send_interval.cold+0x87/0x93 net/dccp/ccids/ccid3.c:86
>  ccid3_hc_tx_update_s net/dccp/ccids/ccid3.c:169 [inline]
>  ccid3_hc_tx_packet_sent+0x12e/0x160 net/dccp/ccids/ccid3.c:353
>  ccid_hc_tx_packet_sent net/dccp/ccid.h:175 [inline]
>  dccp_xmit_packet+0x2f2/0x750 net/dccp/output.c:289
>  dccp_write_xmit+0x16d/0x1d0 net/dccp/output.c:366
>  dccp_sendmsg+0x922/0xc90 net/dccp/proto.c:783
>  inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:819
>  sock_sendmsg_nosec net/socket.c:705 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:725
>  ____sys_sendmsg+0x331/0x810 net/socket.c:2413
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
>  __sys_sendmmsg+0x195/0x470 net/socket.c:2553
>  __do_sys_sendmmsg net/socket.c:2582 [inline]
>  __se_sys_sendmmsg net/socket.c:2579 [inline]
>  __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2579
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f2cf5f36da9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f2cf5ee4308 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f2cf5f36da9
> RDX: 0000000000000001 RSI: 000000002000bf40 RDI: 0000000000000004
> RBP: 00007f2cf5fbf4c8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f2cf5fbf4c0
> R13: 00007f2cf5f8c5dc R14: 00007f2cf5ee4400 R15: 0000000000022000
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

thanks.

-- 
~Randy
