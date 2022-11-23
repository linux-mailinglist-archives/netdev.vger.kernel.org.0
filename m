Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43216634EEB
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbiKWE0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235664AbiKWEZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:25:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5605CE873A
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669177258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WIloXbDe6Xf5V7hRDZwNW8sxVxxV79aT2COzbooV/8o=;
        b=OqWgyb8R3fgVxtSZ0xkTSLDHmwy7iguirE/x0bp6QazIZQjgZfdnf6wefchq0jD0hYLoer
        jKEI/8X17ST/IlyMur8OiJ4N1b8V7Q81W6aIDZ+RlPCI6E+X1ccALn5n0LVKkP0Q0LxtVB
        li6rq52BRenQMj7L4UYjlUe1RBZSUkc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-284-ADytcOIlOIOy3eFV2rMVJg-1; Tue, 22 Nov 2022 23:20:57 -0500
X-MC-Unique: ADytcOIlOIOy3eFV2rMVJg-1
Received: by mail-pj1-f72.google.com with SMTP id z9-20020a17090ab10900b00218c5bdfd55so504239pjq.9
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:20:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WIloXbDe6Xf5V7hRDZwNW8sxVxxV79aT2COzbooV/8o=;
        b=DLJ58A/49r25XEAxUbLPh0Nu2eukHhPhKlq1Fyg0zpTzzPh/o+mhZPoUfkx3NbdpAT
         cvgKmL6kUbsQKsz12zkbwiizn3v/7CYkTwvjUhWjqMdZzoSQ10F+EAcjgukRbWn9DA9L
         ny3CYJGbZFuqu79EotK5BQOCd8PWyz95YbQ9QvLvlkdGiVk5fYHMod5ONlgnhXS6RPbc
         yGYInQMJ17klXbC6CYOQnRfddDj/weaNvDySc3/SNH9/zZxVV6QHXjpyCJqn6poaNVwf
         ++U8ANLEZFUvHyZQRd4ae6pyA6TeueZA1k6obHpYebz909t9PmWmRQpSzA/IO3hr6C72
         oEHQ==
X-Gm-Message-State: ANoB5pkahxuaVnDHwlr6bZkomO4WeEPCVcsXFt4LUoTirQNKmc2ANF+m
        m9nfdgvraDcUvNYXFMHJzqzKvDVilJtHu4jVTdZTgseMTx2iE+zMeWH0w85Vw6cpHrWhgAdEvbR
        y8QuyOkNGtMH6ZI+R
X-Received: by 2002:a17:90a:4b4d:b0:218:b2da:1091 with SMTP id o13-20020a17090a4b4d00b00218b2da1091mr13456788pjl.154.1669177255642;
        Tue, 22 Nov 2022 20:20:55 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7wOf2Zw6T2jczoJNsiubvwnOuZb/A3PpE3Jw9LSXqJcak1g13OXdGfx5velA/NGlNiwWppmQ==
X-Received: by 2002:a17:90a:4b4d:b0:218:b2da:1091 with SMTP id o13-20020a17090a4b4d00b00218b2da1091mr13456777pjl.154.1669177255314;
        Tue, 22 Nov 2022 20:20:55 -0800 (PST)
Received: from [10.72.12.114] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h3-20020a170902b94300b00183c6784704sm5516850pls.291.2022.11.22.20.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 20:20:54 -0800 (PST)
Message-ID: <88643033-45e1-3078-cb41-d7255ef874ad@redhat.com>
Date:   Wed, 23 Nov 2022 12:20:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH v2] net: tun: Fix use-after-free in tun_detach()
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Shigeru Yoshida <syoshida@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+106f9b687cd64ee70cd1@syzkaller.appspotmail.com
References: <20221120090213.922567-1-syoshida@redhat.com>
 <CANn89iLy3zBDN-y0JB_FJ9Mnmr5N0OguvHRfjVhyXELEpLREMw@mail.gmail.com>
 <20221123.031005.476714651315933198.syoshida@redhat.com>
 <CANn89iKQVvaHN+QXxmvk+Cm2vauHNcPRyh3ee_F=JH8coUQnnA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <CANn89iKQVvaHN+QXxmvk+Cm2vauHNcPRyh3ee_F=JH8coUQnnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/11/23 02:47, Eric Dumazet 写道:
> On Tue, Nov 22, 2022 at 10:10 AM Shigeru Yoshida <syoshida@redhat.com> wrote:
>> Hi Eric,
>>
>> On Mon, 21 Nov 2022 08:47:17 -0800, Eric Dumazet wrote:
>>> On Sun, Nov 20, 2022 at 1:02 AM Shigeru Yoshida <syoshida@redhat.com> wrote:
>>>> syzbot reported use-after-free in tun_detach() [1].  This causes call
>>>> trace like below:
>>>>
>>>> ==================================================================
>>>> BUG: KASAN: use-after-free in notifier_call_chain+0x1ee/0x200 kernel/notifier.c:75
>>>> Read of size 8 at addr ffff88807324e2a8 by task syz-executor.0/3673
>>>>
>>>> CPU: 0 PID: 3673 Comm: syz-executor.0 Not tainted 6.1.0-rc5-syzkaller-00044-gcc675d22e422 #0
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
>>>> Call Trace:
>>>>   <TASK>
>>>>   __dump_stack lib/dump_stack.c:88 [inline]
>>>>   dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>>>>   print_address_description mm/kasan/report.c:284 [inline]
>>>>   print_report+0x15e/0x461 mm/kasan/report.c:395
>>>>   kasan_report+0xbf/0x1f0 mm/kasan/report.c:495
>>>>   notifier_call_chain+0x1ee/0x200 kernel/notifier.c:75
>>>>   call_netdevice_notifiers_info+0x86/0x130 net/core/dev.c:1942
>>>>   call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
>>>>   call_netdevice_notifiers net/core/dev.c:1997 [inline]
>>>>   netdev_wait_allrefs_any net/core/dev.c:10237 [inline]
>>>>   netdev_run_todo+0xbc6/0x1100 net/core/dev.c:10351
>>>>   tun_detach drivers/net/tun.c:704 [inline]
>>>>   tun_chr_close+0xe4/0x190 drivers/net/tun.c:3467
>>>>   __fput+0x27c/0xa90 fs/file_table.c:320
>>>>   task_work_run+0x16f/0x270 kernel/task_work.c:179
>>>>   exit_task_work include/linux/task_work.h:38 [inline]
>>>>   do_exit+0xb3d/0x2a30 kernel/exit.c:820
>>>>   do_group_exit+0xd4/0x2a0 kernel/exit.c:950
>>>>   get_signal+0x21b1/0x2440 kernel/signal.c:2858
>>>>   arch_do_signal_or_restart+0x86/0x2300 arch/x86/kernel/signal.c:869
>>>>   exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
>>>>   exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
>>>>   __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
>>>>   syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
>>>>   do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>>>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>>
>>>> The cause of the issue is that sock_put() from __tun_detach() drops
>>>> last reference count for struct net, and then notifier_call_chain()
>>>> from netdev_state_change() accesses that struct net.
>>>>
>>>> This patch fixes the issue by calling sock_put() from tun_detach()
>>>> after all necessary accesses for the struct net has done.
>>>>
>>>> Fixes: 83c1f36f9880 ("tun: send netlink notification when the device is modified")
>>>> Reported-by: syzbot+106f9b687cd64ee70cd1@syzkaller.appspotmail.com
>>>> Link: https://syzkaller.appspot.com/bug?id=96eb7f1ce75ef933697f24eeab928c4a716edefe [1]
>>>> Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
>>>> ---
>>>> v2:
>>>> - Include symbolic stack trace
>>>> - Add Fixes and Reported-by tags
>>>> v1: https://lore.kernel.org/all/20221119075615.723290-1-syoshida@redhat.com/
>>>> ---
>>>>   drivers/net/tun.c | 6 +++++-
>>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>> index 7a3ab3427369..ce9fcf4c8ef4 100644
>>>> --- a/drivers/net/tun.c
>>>> +++ b/drivers/net/tun.c
>>>> @@ -686,7 +686,6 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
>>>>                  if (tun)
>>>>                          xdp_rxq_info_unreg(&tfile->xdp_rxq);
>>>>                  ptr_ring_cleanup(&tfile->tx_ring, tun_ptr_free);
>>>> -               sock_put(&tfile->sk);
>>>>          }
>>>>   }
>>>>
>>>> @@ -702,6 +701,11 @@ static void tun_detach(struct tun_file *tfile, bool clean)
>>>>          if (dev)
>>>>                  netdev_state_change(dev);
>>>>          rtnl_unlock();
>>>> +
>>>> +       if (clean) {
>>> Would you mind explaining (a comment would be nice) why this barrier is needed ?
>> I thought that tfile is accessed with rcu_lock(), so I put
>> synchronize_rcu() here.  Please let me know if I misunderstand the
>> concept of rcu (I'm losing my confidence...).
>>
> Addin Jason for comments.
>
> If an RCU grace period was needed before commit 83c1f36f9880 ("tun:
> send netlink notification when the device is modified"),
> would we need another patch ?


I think we don't need another synchronization here. __tun_detach() has 
already done the necessary synchronization when it tries to modify 
tun->tfiles array and tfile->tun.

Thanks


>
> Also sock_flag(sk, SOCK_RCU_FREE) would probably be better than adding
> a synchronize_rcu() (if again a grace period is needed)
>
>
>
>> Thanks,
>> Shigeru
>>
>>> Thanks.
>>>
>>>> +               synchronize_rcu();
>>>> +               sock_put(&tfile->sk);
>>>> +       }
>>>>   }
>>>>
>>>>   static void tun_detach_all(struct net_device *dev)
>>>> --
>>>> 2.38.1
>>>>

