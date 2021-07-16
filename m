Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771683CB13C
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 05:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbhGPDuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 23:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhGPDui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 23:50:38 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C466C06175F;
        Thu, 15 Jul 2021 20:47:44 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id o201so7748745pfd.1;
        Thu, 15 Jul 2021 20:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k/7BkxWCSPSk9lJGhPVLfgThb8V11x+Yb5r3mtBecUg=;
        b=MFtMqgd4Uikjlm2oixl+auIvrnMRO+I649Gjjb4G1NnegtmOd1KHi+hAHIoO+D/PeN
         xsQ0yUHvmsNbc43WgRnFyXpa2G3UTQyOYr00KZqJBEbm63o8+k/8FJRlfqQZls3zAFJK
         JwqT04kUbdHcw/NLU9mVsCPkzPDSMtzFDBOXMisCZeOYBphJLjbRAxPYm/EdbnBah5cE
         Nfdv7A0CUz8wHtl2FLdumlY8HkoXAqYSH39c1dE2w2PmYbzTFt4v3t3z+lMvyhZ9RP1j
         1InUblrRbzwH7W+Q9ihOSRUNWw3szxQd1QM1+T5RthMCtue5Q63bplj8mvZo0cfg7OVg
         i8/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k/7BkxWCSPSk9lJGhPVLfgThb8V11x+Yb5r3mtBecUg=;
        b=frqijMf94FCqlccw86of9xzzaoqBImX1pj/1CGDorwj7yPpekezsV8mV/tfSApX08h
         nAGuwOLM/4yonOcZplAK5S0FUcygziyFCN9v3+hI+pl1yRS9ib9Acq8szNMva/f1xIo1
         T3MPp3pIyAJ3bc+zCSn/3k13OkRcmwPqYbMv/VoY1AOI/r9oCFSuO+mr7ThN8ZFt5DPz
         tdNTxdtLEBmr/In2R6gHw3OfsHVxjtT611tZ/NRwMBPl53aYgPtAu+/V2ymbJGATXpIn
         w4/8CY3OPNDe0x0N3mvjEC2YfyAsg9Sw61h5WrveCIJzgibCQx5BCQqbZqt45b3kjozz
         PnMQ==
X-Gm-Message-State: AOAM532ul2tTRCvkIpIlSSjwuYyRWxo0yJJbh/bxkNJ2eKjLWi2VQEYQ
        me+7yFwe44Si25sCejiFCGcARd/6VaLn3EUrKSE=
X-Google-Smtp-Source: ABdhPJwg7AHTeCRCX2WT2bJwCUEz/bOhWSBYA4rSK1N9DpqhgppCJVtNpADBA4DGJKaZ8DmIPrOeXA==
X-Received: by 2002:a62:6c4:0:b029:324:8262:b3aa with SMTP id 187-20020a6206c40000b02903248262b3aamr8000608pfg.25.1626407263751;
        Thu, 15 Jul 2021 20:47:43 -0700 (PDT)
Received: from [192.168.1.237] ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id c10sm7947756pfo.129.2021.07.15.20.47.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jul 2021 20:47:43 -0700 (PDT)
Subject: Re: [PATCH v3] Bluetooth: call lock_sock() outside of spinlock
 section
To:     LinMa <linma@zju.edu.cn>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
References: <20210627131134.5434-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <9deece33-5d7f-9dcb-9aaa-94c60d28fc9a@i-love.sakura.ne.jp>
 <48d66166-4d39-4fe2-3392-7e0c84b9bdb3@i-love.sakura.ne.jp>
 <CABBYNZJKWktRo1pCMdafAZ22sE2ZbZeMuFOO+tHUxOtEtTDTeA@mail.gmail.com>
 <674e6b1c.4780d.17aa81ee04c.Coremail.linma@zju.edu.cn>
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Message-ID: <2b0e515c-6381-bffe-7742-05148e1e2dcb@gmail.com>
Date:   Fri, 16 Jul 2021 11:47:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <674e6b1c.4780d.17aa81ee04c.Coremail.linma@zju.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/7/21 11:03 am, LinMa wrote:
> Hi there,
> 
> I'm just exhilarated to see there have been some new ideas to fix this.
> 
>>
>> How about we revert back to use bh_lock_sock_nested but use
>> local_bh_disable like the following patch:
>>
>> https://patchwork.kernel.org/project/bluetooth/patch/20210713162838.693266-1-desmondcheongzx@gmail.com/
>>
> 
> I have checked that patch and learn about some `local_bh_disable/enable` usage.
> To the best of my knowledge, the local_bh_disable() function can be used to disable the processing of bottom halves (softirqs).
> Or in another word, if process context function, hci_sock_sendmsg() for example, can mask the BH (hci_dev_do_close()?). It doesn't need to worry about the UAF.
> 
> However, after doing some experiments, I failed :(
> For instance, I try to do following patch:
> 
> --- a/net/bluetooth/hci_sock.c
> +++ b/net/bluetooth/hci_sock.c
> @@ -1720,6 +1720,7 @@ static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg,
>                  return -EINVAL;
> 
>          lock_sock(sk);
> +       local_bh_disable();
> 
>          switch (hci_pi(sk)->channel) {
>          case HCI_CHANNEL_RAW:
> @@ -1832,7 +1833,9 @@ static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg,
>          err = len;
> 
>   done:
> +       local_bh_enable();
>          release_sock(sk);
> +
>          return err;
> 
> But the POC code shows error message like below:
> 
> [   18.169155] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:197
> [   18.170181] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 120, name: exp
> [   18.170987] 1 lock held by exp/120:
> [   18.171384]  #0: ffff888011dd5120 (sk_lock-AF_BLUETOOTH-BTPROTO_HCI){+.+.}-{0:0}, at: hci_sock_sendmsg+0x11e/0x26c0
> [   18.172300] CPU: 0 PID: 120 Comm: exp Not tainted 5.11.11+ #44
> [   18.172921] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> ...

Hi,

Saw this and thought I'd offer my two cents.

This is the original problem that Tetsuo's patch was trying to fix. 
Under the hood of lock_sock, we call lock_sock_nested which might sleep 
because of the mutex_acquire. But we shouldn't sleep while holding the 
rw spinlock. So we either have to acquire a spinlock instead of a mutex 
as was done before, or we need to move lock_sock out of the rw spinlock 
critical section as Tetsuo proposes.

> 
> The patch provided by Desmond adds the local_bh_disable() before the bh_lock_sock() so I also try that in
> 
> --- a/net/bluetooth/hci_sock.c
> +++ b/net/bluetooth/hci_sock.c
> @@ -762,6 +762,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
>                  /* Detach sockets from device */
>                  read_lock(&hci_sk_list.lock);
>                  sk_for_each(sk, &hci_sk_list.head) {
> +                       local_bh_disable();
>                          bh_lock_sock_nested(sk);
>                          if (hci_pi(sk)->hdev == hdev) {
>                                  hci_pi(sk)->hdev = NULL;
> @@ -772,6 +773,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
>                                  hci_dev_put(hdev);
>                          }
>                          bh_unlock_sock(sk);
> +                       local_bh_enable();
>                  }
>                  read_unlock(&hci_sk_list.lock);
>          }
> 
> But this is not useful, the UAF still occurs
> 

I might be very mistaken on this, but I believe the UAF still happens 
because you can't really mix bh_lock_sock* and lock_sock* to protect the 
same things. The former holds the spinlock &sk->sk_lock.slock and 
synchronizes between user contexts and bottom halves, while the latter 
holds a mutex on &sk->sk_lock.dep_map to synchronize between multiple users.

One option I can think of would be to switch instances of lock_sock to 
bh_lock_sock_nested for users that might race (such as hci_sock_sendmsg, 
hci_sock_bound_ioctl, and others as needed). But I'm not sure if that's 
quite what we want, plus we would need to ensure that sleeping functions 
aren't called between the bh_lock/unlock.

Best wishes,
Desmond

> [   13.862117] ==================================================================
> [   13.863064] BUG: KASAN: use-after-free in __lock_acquire+0xe5/0x2ca0
> [   13.863852] Read of size 8 at addr ffff888011d9aeb0 by task exp/119
> [   13.864620]
> [   13.864818] CPU: 0 PID: 119 Comm: exp Not tainted 5.11.11+ #45
> [   13.865543] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> [   13.866634] Call Trace:
> [   13.866947]  dump_stack+0x183/0x22e
> [   13.867389]  ? show_regs_print_info+0x12/0x12
> [   13.867927]  ? log_buf_vmcoreinfo_setup+0x45d/0x45d
> [   13.868503]  ? _raw_spin_lock_irqsave+0xbd/0x100
> [   13.869244]  print_address_description+0x7b/0x3a0
> [   13.869828]  __kasan_report+0x14e/0x200
> [   13.870288]  ? __lock_acquire+0xe5/0x2ca0
> [   13.870768]  kasan_report+0x47/0x60
> [   13.871189]  __lock_acquire+0xe5/0x2ca0
> [   13.871647]  ? lock_acquire+0x168/0x6a0
> [   13.872107]  ? trace_lock_release+0x5c/0x120
> [   13.872615]  ? do_user_addr_fault+0x9c2/0xdb0
> [   13.873135]  ? trace_lock_acquire+0x150/0x150
> [   13.873661]  ? rcu_read_lock_sched_held+0x87/0x110
> [   13.874232]  ? perf_trace_rcu_barrier+0x360/0x360
> [   13.874790]  ? avc_has_perm_noaudit+0x442/0x4c0
> [   13.875332]  lock_acquire+0x168/0x6a0
> [   13.875772]  ? skb_queue_tail+0x32/0x120
> [   13.876240]  ? do_kern_addr_fault+0x230/0x230
> [   13.876756]  ? read_lock_is_recursive+0x10/0x10
> [   13.877300]  ? exc_page_fault+0xf3/0x1b0
> [   13.877770]  ? cred_has_capability+0x191/0x3f0
> [   13.878290]  ? cred_has_capability+0x2a1/0x3f0
> [   13.878816]  ? rcu_lock_release+0x20/0x20
> [   13.879295]  _raw_spin_lock_irqsave+0xb1/0x100
> [   13.879821]  ? skb_queue_tail+0x32/0x120
> [   13.880287]  ? _raw_spin_lock+0x40/0x40
> [   13.880745]  skb_queue_tail+0x32/0x120
> [   13.881194]  hci_sock_sendmsg+0x1545/0x26b0
> 
>  From my point of view, adding the local_bh_disable() cannot prevent current hci_sock_dev_event() to set and decrease the ref-count. It's not quite similar with the cases that Desmond discussed.
> (Or maybe just I don't know how to use this).
>  > I recently tried to find some similar cases (and I did, reported to 
security already but get no reply) and figure out how others are fixed.
> Some guideline tells me that (http://books.gigatux.nl/mirror/kerneldevelopment/0672327201/ch07lev1sec6.html)
> 
> "If process context code and a bottom half share data, you need to disable bottom-half processing and obtain a lock before accessing the data. Doing both ensures local and SMP protection and prevents a deadlock."
> 
> Assuming hci_sock_sendmsg()/hci_sock_bound_ioctl() are the process contexts while the hci_sock_dev_event(), not sure, is the BH context. The fact is that the hci_sock_dev_event() should wait for the process contexts. Hence, I think Tetsuo is on the right way.
> 
> Regards
> Lock-Noob LinMa
> 
> 
> 

