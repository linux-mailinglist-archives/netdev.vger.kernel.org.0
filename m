Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4B9481184
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 11:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239668AbhL2KKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 05:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhL2KKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 05:10:49 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBC6C061574;
        Wed, 29 Dec 2021 02:10:49 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id j83so42884294ybg.2;
        Wed, 29 Dec 2021 02:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=AyEywaOqGLatpJgB4Bh+S9CvbDg8E0HniHZw3IlLlac=;
        b=SjFMYETeYODo3CGF58DHuRvdguLo3L9Soix0u+1io0BnCRyJ05mDSFfRZp4gCjaGbZ
         c1ZYT1e23Fla2Q2kenChOgQd+BTP8T+v9pJePVs07Arn15H18BQZzQtkkPwTQ1EXCrBn
         rjESFlHOII/yZSnA5b+NnIODIpeN3ICPFTKQ7M25d68i38hSWqDQZ7gxa8SKVM1raQWN
         3AMSwwi0RZvJwCMb03gPl6jxJEfDCkzVyvyVSnY0rcYbZgd6RdGWjqwoEShAObndVoyg
         HCOT+4GBkat9C5aSXrb/riFfQKfeWmZqYUCg0Ok9PoQ1nqnZa4mTfUhJ2pDuyZIs18B6
         kC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=AyEywaOqGLatpJgB4Bh+S9CvbDg8E0HniHZw3IlLlac=;
        b=s3ztudBlfbUyHfXo/1EKugJaiIdqMPcul+8FNRc03VXZDK+bTqNtC2bqr1jl4mog2M
         +3rppA2WU0jxGvguxoRAcZrPjkjkEvaDlD1dX7z1uL1kNbjn9qUImMLrDskl9fJHPS9p
         uzf/aofMwQGRvB4CLiAURwnkQm7HXo16t960sIKQqCzNbAJESKSUAZBczCtDfX8n0onb
         O9ryWbeTfWlgsy7tJAVgsWZ5vNOfmmWCzN541XGCzb/YQAX94Rls99BN6ekeEzkllLLU
         hRbD2Q2JIixjeyFcShNyKEU8PQkFw8CPy42YXdr+qyhLkSI50HfanMys380m4gRg+rRi
         oFeQ==
X-Gm-Message-State: AOAM532YF1qdqh+VGMCDm1YIgydTGjEXnuposLNdqb6MffPyTblAo4S8
        G4nZVLRmf+7Fu6AboXfd45otzD8A13RA+3DN75wYq1wBH8yfmg==
X-Google-Smtp-Source: ABdhPJxHuk/iWTAk08aPEHGQRW4MonfmdqLgCaLU+XYK8/tQxHynJSwa+4VnsXFBJiLvwDNPFwDunLmCYZI+8bICmWY=
X-Received: by 2002:a25:5008:: with SMTP id e8mr1061830ybb.522.1640772648880;
 Wed, 29 Dec 2021 02:10:48 -0800 (PST)
MIME-Version: 1.0
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Wed, 29 Dec 2021 18:10:39 +0800
Message-ID: <CAFcO6XMpbL4OsWy1Pmsnvf8zut7wFXdvY_KofR-m0WK1Bgutpg@mail.gmail.com>
Subject: A slab-out-of-bounds Read bug in __htab_map_lookup_and_delete_batch
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, there is a slab-out-bounds Read bug in
__htab_map_lookup_and_delete_batch in kernel/bpf/hashtab.c
and I reproduce it in linux-5.16.rc7(upstream) and latest linux-5.15.11.

#carsh log
[  166.945208][ T6897]
==================================================================
[  166.947075][ T6897] BUG: KASAN: slab-out-of-bounds in _copy_to_user+0x87/0xb0
[  166.948612][ T6897] Read of size 49 at addr ffff88801913f800 by
task __htab_map_look/6897
[  166.950406][ T6897]
[  166.950890][ T6897] CPU: 1 PID: 6897 Comm: __htab_map_look Not
tainted 5.16.0-rc7+ #30
[  166.952521][ T6897] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.13.0-1ubuntu1 04/01/2014
[  166.954562][ T6897] Call Trace:
[  166.955268][ T6897]  <TASK>
[  166.955918][ T6897]  dump_stack_lvl+0x57/0x7d
[  166.956875][ T6897]  print_address_description.constprop.0.cold+0x93/0x347
[  166.958411][ T6897]  ? _copy_to_user+0x87/0xb0
[  166.959356][ T6897]  ? _copy_to_user+0x87/0xb0
[  166.960272][ T6897]  kasan_report.cold+0x83/0xdf
[  166.961196][ T6897]  ? _copy_to_user+0x87/0xb0
[  166.962053][ T6897]  kasan_check_range+0x13b/0x190
[  166.962978][ T6897]  _copy_to_user+0x87/0xb0
[  166.964340][ T6897]  __htab_map_lookup_and_delete_batch+0xdc2/0x1590
[  166.965619][ T6897]  ? htab_lru_map_update_elem+0xe70/0xe70
[  166.966732][ T6897]  bpf_map_do_batch+0x1fa/0x460
[  166.967619][ T6897]  __sys_bpf+0x99a/0x3860
[  166.968443][ T6897]  ? bpf_link_get_from_fd+0xd0/0xd0
[  166.969393][ T6897]  ? rcu_read_lock_sched_held+0x9c/0xd0
[  166.970425][ T6897]  ? lock_acquire+0x1ab/0x520
[  166.971284][ T6897]  ? find_held_lock+0x2d/0x110
[  166.972208][ T6897]  ? rcu_read_lock_sched_held+0x9c/0xd0
[  166.973139][ T6897]  ? rcu_read_lock_bh_held+0xb0/0xb0
[  166.974096][ T6897]  __x64_sys_bpf+0x70/0xb0
[  166.974903][ T6897]  ? syscall_enter_from_user_mode+0x21/0x70
[  166.976077][ T6897]  do_syscall_64+0x35/0xb0
[  166.976889][ T6897]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  166.978027][ T6897] RIP: 0033:0x450f0d


In hashtable, if the elements' keys have the same jhash() value, the
elements will be put into the same bucket.
By putting a lot of elements into a single bucket, the value of
bucket_size can be increased to overflow.
 but also we can increase bucket_cnt to out of bound Read.

the out of bound Read in  __htab_map_lookup_and_delete_batch code:
```
...
if (bucket_cnt && (copy_to_user(ukeys + total * key_size, keys,
key_size * bucket_cnt) ||
    copy_to_user(uvalues + total * value_size, values,
    value_size * bucket_cnt))) {
ret = -EFAULT;
goto after_loop;
}
...
```

Regards,
 butt3rflyh4ck.


--
Active Defense Lab of Venustech
