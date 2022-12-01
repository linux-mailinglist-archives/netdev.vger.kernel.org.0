Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5628963EF6B
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 12:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiLAL0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 06:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLAL0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 06:26:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197432C4
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 03:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669893917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ep72vLxE58Hj5NSOsGJz6rENtgNcndE3NkTvnuzGDE=;
        b=XXG27M97nfNa1GngjvGKkd81KMVWup0RjHPdAeaFr6H7ORAEGqNLqPbVf4mnSyg9zAEFlk
        MnD5IFaMDNQ66N3NG3Qmic6IRa1+5tW1oOMR5vEy8Jx0AS7tQshiglLBm6Ls1hMx6NjRgJ
        Vj7iibC2yQ+/QM2zNRi2g9n+x17a+w4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-250-91ACEaKuM5GhqhpICzuPbA-1; Thu, 01 Dec 2022 06:25:16 -0500
X-MC-Unique: 91ACEaKuM5GhqhpICzuPbA-1
Received: by mail-wm1-f71.google.com with SMTP id h9-20020a1c2109000000b003cfd37aec58so727204wmh.1
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 03:25:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7ep72vLxE58Hj5NSOsGJz6rENtgNcndE3NkTvnuzGDE=;
        b=n8dolFKrZZPMSn/fbhOHFgbFiNycY4b6yegkuzoOav6NrNhJu0WLVHaAnnM58DQCcw
         wbLedgxhg/q2oEuInwmYfiXD1JZzMRREU5Cd7GQkdiXOFE5V9FLEOmzuWfaN/Har78oo
         IhRotGc8kHbnzS1WswwfK+UXO/Ny2Ym8tJa23vgEBZ8/JsRFcBfHXu4UL232FT3B3Hzg
         L8rGA+LvZI+jVkiguS5drawLcIQtfrHHJ1C7PEkTj6xQXCyC7Vd26/NtEgpnnjTDaLpk
         Yq7+6kSxWzKLmOMDGwkw6hdm+nBr6tumHUrrK+/dBC7pXzzx0HE1bX4wI21aDMZwFnB2
         zlYg==
X-Gm-Message-State: ANoB5pnDYns/bPZmOFoIXL4RLzQe60gn4fnGrDm8CargIlGG0XqYbZGI
        cMYtDwH4nOtQoNainUdeOJMHwOfsT7Diz6X26CO9iqf1LCcdAAbu+kjsg0UOkvRKnmLtRJk/1JO
        WSZONxGD2MUKWG+eK
X-Received: by 2002:a5d:4a8c:0:b0:242:165e:7a79 with SMTP id o12-20020a5d4a8c000000b00242165e7a79mr12148263wrq.343.1669893914871;
        Thu, 01 Dec 2022 03:25:14 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7T6oAcCAjM/6a6zgzwAS5bkUYUQkeATl7F2kjZacgCrgATu3VUsNvuAWXyhxxd1feg1XyRFw==
X-Received: by 2002:a5d:4a8c:0:b0:242:165e:7a79 with SMTP id o12-20020a5d4a8c000000b00242165e7a79mr12148245wrq.343.1669893914608;
        Thu, 01 Dec 2022 03:25:14 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id i1-20020a05600c354100b003b4868eb71bsm9730088wmq.25.2022.12.01.03.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 03:25:14 -0800 (PST)
Message-ID: <188f255ca50e0e7a46e0fd139982e6ee3652bd7f.camel@redhat.com>
Subject: Re: [PATCH] nfc: llcp: Fix race in handling llcp_devices
From:   Paolo Abeni <pabeni@redhat.com>
To:     Wang ShaoBo <bobo.shaobowang@huawei.com>
Cc:     liwei391@huawei.com, sameo@linux.intel.com, kuba@kernel.org,
        davem@davemloft.net, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 01 Dec 2022 12:25:13 +0100
In-Reply-To: <20221129094436.3975668-1-bobo.shaobowang@huawei.com>
References: <20221129094436.3975668-1-bobo.shaobowang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-11-29 at 17:44 +0800, Wang ShaoBo wrote:
> There are multiple path operate llcp_devices list without protection:
> 
>          CPU0                        CPU1
> 
> nfc_unregister_device()        nfc_register_device()
>  nfc_llcp_unregister_device()    nfc_llcp_register_device() //no lock
>     ...                            list_add(local->list, llcp_devices)
>     local_release()
>       list_del(local->list)
> 
>         CPU2
> ...
>  nfc_llcp_find_local()
>    list_for_each_entry(,&llcp_devices,)
> 
> So reach race condition if two of the three occur simultaneously like
> following crash report, although there is no reproduction script in
> syzbot currently, our artificially constructed use cases can also
> reproduce it:
> 
> list_del corruption. prev->next should be ffff888060ce7000, but was ffff88802a0ad000. (prev=ffffffff8e536240)
> ------------[ cut here ]------------
> kernel BUG at lib/list_debug.c:59!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 16622 Comm: syz-executor.5 Not tainted 6.1.0-rc6-next-20221125-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> RIP: 0010:__list_del_entry_valid.cold+0x12/0x72 lib/list_debug.c:59
> Code: f0 ff 0f 0b 48 89 f1 48 c7 c7 60 96 a6 8a 4c 89 e6 e8 4b 29 f0 ff 0f 0b 4c 89 e1 48 89 ee 48 c7 c7 c0 98 a6 8a e8 37 29 f0 ff <0f> 0b 48 89 ee 48 c7 c7 a0 97 a6 8a e8 26 29 f0 ff 0f 0b 4c 89 e2
> RSP: 0018:ffffc900151afd58 EFLAGS: 00010282
> RAX: 000000000000006d RBX: 0000000000000001 RCX: 0000000000000000
> RDX: ffff88801e7eba80 RSI: ffffffff8166001c RDI: fffff52002a35f9d
> RBP: ffff888060ce7000 R08: 000000000000006d R09: 0000000000000000
> R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff8e536240
> R13: ffff88801f3f3000 R14: ffff888060ce1000 R15: ffff888079d855f0
> FS:  0000555556f57400(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f095d5ad988 CR3: 000000002155a000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  __list_del_entry include/linux/list.h:134 [inline]
>  list_del include/linux/list.h:148 [inline]
>  local_release net/nfc/llcp_core.c:171 [inline]
>  kref_put include/linux/kref.h:65 [inline]
>  nfc_llcp_local_put net/nfc/llcp_core.c:181 [inline]
>  nfc_llcp_local_put net/nfc/llcp_core.c:176 [inline]
>  nfc_llcp_unregister_device+0xb8/0x260 net/nfc/llcp_core.c:1619
>  nfc_unregister_device+0x196/0x330 net/nfc/core.c:1179
>  virtual_ncidev_close+0x52/0xb0 drivers/nfc/virtual_ncidev.c:163
>  __fput+0x27c/0xa90 fs/file_table.c:320
>  task_work_run+0x16f/0x270 kernel/task_work.c:179
>  resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>  exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
>  syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
>  do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> This patch add specific mutex lock llcp_devices_list_lock to ensure
> handling llcp_devices list safety.

Why a mutex instead of a spinlock? all the critical sections are very
small (both code and time-wise), while the list of callers reaching
that code is quite large making hard to check each of them is really in
process context.

Please switch to a spinlock instead.

Cheers,

Paolo

