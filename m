Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424046CD52A
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbjC2It0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjC2ItT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:49:19 -0400
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5FE40E3;
        Wed, 29 Mar 2023 01:48:35 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id w9so60278949edc.3;
        Wed, 29 Mar 2023 01:48:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680079714; x=1682671714;
        h=content-transfer-encoding:in-reply-to:subject:from:references:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SDm8xQ8YMwosjStQbaWPeTTcMi1YkbPlJWLg16UcHC0=;
        b=stWZ4IIMHUXZOC9FN18APhM4IQzcPLwSQmkPl4f9Xq+yNATKFJ9Es3kn0uBpp7AwKz
         mWO5VylffQHjR2c5sKCdP/ae4EZVPxglKaaqR/lOR4zQZWEOX5Kio7+PJfbp8He5Uw6j
         TTPbAUWELrM2ynvC0nRx0aVaQDIMdv7WFA2Dcsi3HXDx+9IDmFVzWSWc1bhAKmAEk2ba
         mXnJqHjOllClVry5VdvV8kPpCJM6sK/AtQAY3QUdTz/+WyYH6vYgVd1SHig9AQFYKxpr
         lxGtHPwzoYb3elOddmbI8W1XbSLn6WZrRZCfzq/0JXUDQwYp8LbQT3G4JJBirZBhbBX9
         qiGg==
X-Gm-Message-State: AAQBX9cMDrzR1U/+l+i+TJXQsdRK1PRKpCkU75Yq/0pAqcitri4E/2GK
        jjbMVkGlMmB5CrLScpqaAc8=
X-Google-Smtp-Source: AKy350Y6+mkDmDiT+UUbBaudRPpfXcWsDbLatbNp9joAXGhqiBHUXsSdjjg5QbRTBEvWVWlVt4a8Xw==
X-Received: by 2002:aa7:cb9a:0:b0:4f9:f45e:c8b3 with SMTP id r26-20020aa7cb9a000000b004f9f45ec8b3mr20012230edt.27.1680079714120;
        Wed, 29 Mar 2023 01:48:34 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:49? ([2a0b:e7c0:0:107::aaaa:49])
        by smtp.gmail.com with ESMTPSA id r12-20020a50c00c000000b00501d2f10d19sm12270461edb.20.2023.03.29.01.48.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 01:48:33 -0700 (PDT)
Message-ID: <80235479-e410-845b-2e78-75f6a234b740@kernel.org>
Date:   Wed, 29 Mar 2023 10:48:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     "Dae R. Jeong" <threeearcat@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        duoming@zju.edu.cn, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <ZB6uWm6MbpX+NmE/@dragonet>
From:   Jiri Slaby <jirislaby@kernel.org>
Subject: Re: KASAN: use-after-free Read in slip_ioctl
In-Reply-To: <ZB6uWm6MbpX+NmE/@dragonet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 25. 03. 23, 9:18, Dae R. Jeong wrote:
> We observed a use-after-free in slip_ioctl as attached at the end.
> 
> Although I'm not sure that our analysis is correct, it seems that the
> concurrent execution of slip_ioctl() and slip_close() causes the issue
> as follows.
> 
> CPU1                            CPU2
> slip_ioctl                      slip_close (via slip_hangup)
> -----                           -----
> // Read a non-null value
> sl = tty->disc_data;
>                                  // Nullify tty->disc_data and then
>                                  // unregister sl->dev
>                                  rcu_assign_pointer(tty->disc_data, NULL);
>                                  unregister_netdev(sl->dev);
> // sl is freed in unregister_netdev()
> if (!sl || sl->magic != SLIP_MAGIC)
>      return -EINVAL;
> 
> I suspect that the two functions can be executed concurrently as I
> don't see a locking mechanism to prevent this in tty_ioctl(), and that
> sl is freed in unregister_netdev() as explained in the callstack. But
> still we need to look into this further.
> 
> 
> Best regards,
> Dae R. Jeong
> 
> 
> ==================================================================
> BUG: KASAN: use-after-free in slip_ioctl+0x6db/0x7d0 drivers/net/slip/slip.c:1083
> Read of size 4 at addr ffff88804b856c80 by task syz-executor.0/9106
> 
> CPU: 2 PID: 9106 Comm: syz-executor.0 Not tainted 6.0.0-rc7-00166-gf09dbf1cf0d5 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0x1cf/0x2b7 lib/dump_stack.c:106
>   print_address_description+0x21/0x470 mm/kasan/report.c:317
>   print_report+0x108/0x1f0 mm/kasan/report.c:433
>   kasan_report+0xe5/0x110 mm/kasan/report.c:495
>   slip_ioctl+0x6db/0x7d0 drivers/net/slip/slip.c:1083
>   tty_ioctl+0x11e9/0x1a20 drivers/tty/tty_io.c:2787
>   vfs_ioctl fs/ioctl.c:51 [inline]
>   __do_sys_ioctl fs/ioctl.c:870 [inline]
>   __se_sys_ioctl+0x110/0x180 fs/ioctl.c:856
>   do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>   do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x478d29
> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fbbbdfb8be8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000781408 RCX: 0000000000478d29
> RDX: 0000000020000040 RSI: 00000000402c542c RDI: 0000000000000003
> RBP: 00000000f477909a R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000781580
> r13: 0000000000781414 R14: 0000000000781408 R15: 00007ffcfdc4f040
>   </TASK>
> 
> Allocated by task 9103:
...
>   kvzalloc include/linux/slab.h:758 [inline]
>   alloc_netdev_mqs+0x86/0x1240 net/core/dev.c:10603
>   sl_alloc drivers/net/slip/slip.c:756 [inline]
>   slip_open+0x489/0x1240 drivers/net/slip/slip.c:817
>   tty_ldisc_open+0xb4/0x120 drivers/tty/tty_ldisc.c:433
>   tty_set_ldisc+0x366/0x860 drivers/tty/tty_ldisc.c:558
>   tiocsetd drivers/tty/tty_io.c:2433 [inline]
>   tty_ioctl+0x168f/0x1a20 drivers/tty/tty_io.c:2714
>   vfs_ioctl fs/ioctl.c:51 [inline]
...
> 
> Freed by task 9105:
...
>   kfree+0x108/0x460 mm/slub.c:4567
>   device_release+0x189/0x220
>   kobject_cleanup+0x24f/0x360 lib/kobject.c:673
>   netdev_run_todo+0x14ac/0x15a0 net/core/dev.c:10385
>   unregister_netdev+0x1e9/0x270 net/core/dev.c:10922
>   tty_ldisc_hangup+0x224/0x750 drivers/tty/tty_ldisc.c:700

The question is whether the slip (and at least both ppps too) ldisc 
should free resources in hangup(). This should be IMO done only in 
close(). ndcmddcmmms -- sorry, my cat literally stepped in and had to 
express her opinion too.

As calling hangup() does not guarantee anything from the ldisc/tty POV. 
While after/during close(), other ldisc ops must not be invoked/running.

>   __tty_hangup+0x5b4/0x870 drivers/tty/tty_io.c:637
>   tty_vhangup drivers/tty/tty_io.c:707 [inline]
>   tty_ioctl+0xa7f/0x1a20 drivers/tty/tty_io.c:2718
>   vfs_ioctl fs/ioctl.c:51 [inline]


thanks,
-- 
js
suse labs

