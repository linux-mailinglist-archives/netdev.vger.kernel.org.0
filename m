Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2E2104638
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 22:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfKTV5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 16:57:43 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33633 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfKTV5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 16:57:43 -0500
Received: by mail-pf1-f194.google.com with SMTP id c184so464585pfb.0
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 13:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W/h65e/DPMPUqDFXPqNUwZg+U+D50bRb24+GA0BMPGY=;
        b=t9YYLrBnWX61MiaC9DsVHv0nOcJlR0dXdY+HM9+yq+014T9Ja+hM/rfDJ6gK+oci0K
         Jvdoi8foekS8fGHMDBX6Dn7ORmoG5m4x4XGxdEZwnqminkO/jtcPptNzfcxfpsloVctL
         WhH4duy646BvssNZfALBCJYgYhP0+NOTW3bKnJxXj72O/YPH7zxT//KMER06WOlGJNoL
         +QL9LFI199wUL/9tHz+TepmAorYBqzO5Syhp2M0ZH4yMq6PnxweI5bt/7PWqiVdFvE3s
         yFxBWoEbTGD76LviSLMiMZF5xLXs3y7YxWu2RlkPO9cBOWlB6KhU1nqbL8mEsD16fl9n
         SVKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W/h65e/DPMPUqDFXPqNUwZg+U+D50bRb24+GA0BMPGY=;
        b=KfUChoS3tZJVqf32FnRWH3J6SBNElZEkTR9uXnW6R0qey9EV9CM55ty2rnDH0IFeWU
         Nz0sHnmeIRil4DIjSLIinB0dzYpJzonHxfZ0mEckQoPIi3uyNZvHLt28S6OqwulaLZ39
         xnGmDjOXmnfIQ2fza5kNQ1iug9n2vTstfxu7fGmcGOyCfHXh16InYa+9WdAJy1Xf//4x
         wg9K2JniYqxUXlMkUrnIm6M5xoSQddKJjuVSNLD6IF4/k17v68c2kEbcq4ps072L7xAl
         N9fdOVV47HafuZiPvf1sE813i3sWyBzgJp/h4xtvS4VpbuNh/Shlwy2W0de3+60I0bI5
         001w==
X-Gm-Message-State: APjAAAVD/gTBIJPZRsLKxoerCYHrRlwP0ZSmBCAw5OAOF6mDgCzk3buf
        MXfAA32xw0gFRoVGkRc8NUSe/qJF9P0V3/0d7/Rcad2OwT4=
X-Google-Smtp-Source: APXvYqxDAzzS4CIPX61BLOdjHgN21/KdZU/2JdX3F4WkPdj6+ZdM3Iq/JqL+Sj0vAKh1B8ScuIojG+fmq+SZu2leD+0=
X-Received: by 2002:a65:44ca:: with SMTP id g10mr5702431pgs.104.1574287062060;
 Wed, 20 Nov 2019 13:57:42 -0800 (PST)
MIME-Version: 1.0
References: <485b2235cb9c1dc53d7094969c131f05f2df5258.1574203001.git.dcaratti@redhat.com>
In-Reply-To: <485b2235cb9c1dc53d7094969c131f05f2df5258.1574203001.git.dcaratti@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 20 Nov 2019 13:57:31 -0800
Message-ID: <CAM_iQpXhULU2TLN9nVSoFU4pNoC_NGeC6f-3_=KFVPA3xpkV1Q@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: act_pedit: fix WARN() in the traffic path
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 2:48 PM Davide Caratti <dcaratti@redhat.com> wrote:
>
> when configuring act_pedit rules, the number of keys is validated only on
> addition of a new entry. This is not sufficient to avoid hitting a WARN()
> in the traffic path: for example, it is possible to replace a valid entry
> with a new one having 0 extended keys, thus causing splats in dmesg like:
>
>  pedit BUG: index 42
>  WARNING: CPU: 2 PID: 4054 at net/sched/act_pedit.c:410 tcf_pedit_act+0xc84/0x1200 [act_pedit]
>  [...]
>  RIP: 0010:tcf_pedit_act+0xc84/0x1200 [act_pedit]
>  Code: 89 fa 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e ac 00 00 00 48 8b 44 24 10 48 c7 c7 a0 c4 e4 c0 8b 70 18 e8 1c 30 95 ea <0f> 0b e9 a0 fa ff ff e8 00 03 f5 ea e9 14 f4 ff ff 48 89 58 40 e9
>  RSP: 0018:ffff888077c9f320 EFLAGS: 00010286
>  RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffac2983a2
>  RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff888053927bec
>  RBP: dffffc0000000000 R08: ffffed100a726209 R09: ffffed100a726209
>  R10: 0000000000000001 R11: ffffed100a726208 R12: ffff88804beea780
>  R13: ffff888079a77400 R14: ffff88804beea780 R15: ffff888027ab2000
>  FS:  00007fdeec9bd740(0000) GS:ffff888053900000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007ffdb3dfd000 CR3: 000000004adb4006 CR4: 00000000001606e0
>  Call Trace:
>   tcf_action_exec+0x105/0x3f0
>   tcf_classify+0xf2/0x410
>   __dev_queue_xmit+0xcbf/0x2ae0
>   ip_finish_output2+0x711/0x1fb0
>   ip_output+0x1bf/0x4b0
>   ip_send_skb+0x37/0xa0
>   raw_sendmsg+0x180c/0x2430
>   sock_sendmsg+0xdb/0x110
>   __sys_sendto+0x257/0x2b0
>   __x64_sys_sendto+0xdd/0x1b0
>   do_syscall_64+0xa5/0x4e0
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>  RIP: 0033:0x7fdeeb72e993
>  Code: 48 8b 0d e0 74 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 0d d6 2c 00 00 75 13 49 89 ca b8 2c 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 4b cc 00 00 48 89 04 24
>  RSP: 002b:00007ffdb3de8a18 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
>  RAX: ffffffffffffffda RBX: 000055c81972b700 RCX: 00007fdeeb72e993
>  RDX: 0000000000000040 RSI: 000055c81972b700 RDI: 0000000000000003
>  RBP: 00007ffdb3dea130 R08: 000055c819728510 R09: 0000000000000010
>  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000040
>  R13: 000055c81972b6c0 R14: 000055c81972969c R15: 0000000000000080
>
> Fix this moving the check on 'nkeys' earlier in tcf_pedit_init(), so that
> attempts to install rules having 0 keys are always rejected with -EINVAL.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks!
