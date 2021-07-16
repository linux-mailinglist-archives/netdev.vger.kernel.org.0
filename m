Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F123CB90B
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 16:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240251AbhGPOv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 10:51:27 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:52033 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbhGPOv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 10:51:26 -0400
Received: from fsav111.sakura.ne.jp (fsav111.sakura.ne.jp [27.133.134.238])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 16GEmHqL067176;
        Fri, 16 Jul 2021 23:48:17 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav111.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav111.sakura.ne.jp);
 Fri, 16 Jul 2021 23:48:17 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav111.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 16GEmG17067172
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 16 Jul 2021 23:48:16 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH v3] Bluetooth: call lock_sock() outside of spinlock
 section
To:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        LinMa <linma@zju.edu.cn>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
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
 <2b0e515c-6381-bffe-7742-05148e1e2dcb@gmail.com>
 <4b955786-d233-8d3f-4445-2422c1daf754@gmail.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <e07c5bbf-115c-6ffa-8492-7b749b9d286b@i-love.sakura.ne.jp>
Date:   Fri, 16 Jul 2021 23:48:13 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <4b955786-d233-8d3f-4445-2422c1daf754@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/07/16 13:11, Desmond Cheong Zhi Xi wrote:
> On 16/7/21 11:47 am, Desmond Cheong Zhi Xi wrote:
>> Saw this and thought I'd offer my two cents.
>> BUG: sleeping function called from invalid context
>> This is the original problem that Tetsuo's patch was trying to fix.

Yes.

>> Under the hood of lock_sock, we call lock_sock_nested which might sleep
>> because of the mutex_acquire.

Both lock_sock() and lock_sock_nested() might sleep.

>> But we shouldn't sleep while holding the rw spinlock.

Right. In atomic context (e.g. inside interrupt handler, schedulable context
with interrupts or preemption disabled, schedulable context inside RCU read
critical section, schedulable context inside a spinlock section), we must not
call functions (e.g. waiting for a mutex, waiting for a semaphore, waiting for
a page fault) which are not atomic.

>> So we either have to acquire a spinlock instead of a mutex as was done before,

Regarding hci_sock_dev_event(HCI_DEV_UNREG) case, we can't use a spinlock.

Like LinMa explained, lock_sock() has to be used in order to serialize functions
(e.g. hci_sock_sendmsg()) which access hci_pi(sk)->hdev between lock_sock(sk) and
release_sock(sk). And like I explained, we can't defer resetting hci_pi(sk)->hdev
to NULL, for hci_sock_dev_event(HCI_DEV_UNREG) is responsible for resetting
hci_pi(sk)->hdev to NULL because the caller of hci_sock_dev_event(HCI_DEV_UNREG)
immediately destroys resources associated with this hdev.

>> or we need to move lock_sock out of the rw spinlock critical section as Tetsuo proposes.

Exactly. Since this is a regression introduced when fixing CVE-2021-3573, Linux
distributors are waiting for this patch so that they can apply the fix for CVE-2021-3573.
This patch should be sent to linux.git and stables as soon as possible. But due to little
attention on this patch, I'm already testing this patch in linux-next.git via my tree.
I'll drop when Bluetooth maintainers pick this patch up for linux-5.14-rcX. (Or should I
directly send to Linus?)

>>
> 
> My bad, was thinking more about the problem and noticed your poc was for hci_sock_sendmsg,
> not hci_sock_dev_event.

I didn't catch this part. Are you talking about a different poc?
As far as I'm aware, exp.c in POC.zip was for hci_sock_bound_ioctl(HCIUNBLOCKADDR).

hci_sock_bound_ioctl(HCIUNBLOCKADDR) (which is called between lock_sock() and release_sock())
calls copy_from_user() which might cause page fault, and userfaultfd mechanism allows an attacker
to slowdown page fault handling enough to hci_sock_dev_event(HCI_DEV_UNREG) to return without
waiting for hci_sock_bound_ioctl(HCIUNBLOCKADDR) to call release_sock(). This race window
results in UAF (doesn't it, LinMa?).

> In this case, it's not clear to me why the atomic context is being violated.

In atomic context (in hci_sock_dev_event(HCI_DEV_UNREG) case, between
read_lock(&hci_sk_list.lock) and read_unlock(&hci_sk_list.lock)), we must not call
lock_sock(sk) which might wait for hci_sock_bound_ioctl(HCIUNBLOCKADDR) to call release_sock().

> 
> Sorry for the noise.
> 
>>>
>>> The patch provided by Desmond adds the local_bh_disable() before the bh_lock_sock() so I also try that in
>>>
>>> --- a/net/bluetooth/hci_sock.c
>>> +++ b/net/bluetooth/hci_sock.c
>>> @@ -762,6 +762,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
>>>                  /* Detach sockets from device */
>>>                  read_lock(&hci_sk_list.lock);
>>>                  sk_for_each(sk, &hci_sk_list.head) {
>>> +                       local_bh_disable();
>>>                          bh_lock_sock_nested(sk);
>>>                          if (hci_pi(sk)->hdev == hdev) {
>>>                                  hci_pi(sk)->hdev = NULL;
>>> @@ -772,6 +773,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
>>>                                  hci_dev_put(hdev);
>>>                          }
>>>                          bh_unlock_sock(sk);
>>> +                       local_bh_enable();
>>>                  }
>>>                  read_unlock(&hci_sk_list.lock);
>>>          }
>>>
>>> But this is not useful, the UAF still occurs
>>>
>>
>> I might be very mistaken on this, but I believe the UAF still happens because
>> you can't really mix bh_lock_sock* and lock_sock* to protect the same things.

Right. https://www.kernel.org/doc/html/v5.13/kernel-hacking/locking.html

>> The former holds the spinlock &sk->sk_lock.slock and synchronizes between
>> user contexts and bottom halves,

serializes access to resources which might be accessed from atomic (i.e. non-schedulable) contexts

>> while the latter holds a mutex on &sk->sk_lock.dep_map to synchronize between
>> multiple users.

serializes access to resources which are accessed from only schedulable (i.e. non-atomic) contexts

>>
>> One option I can think of would be to switch instances of lock_sock to bh_lock_sock_nested
>> for users that might race (such as hci_sock_sendmsg, hci_sock_bound_ioctl, and others as
>> needed). But I'm not sure if that's quite what we want, plus we would need to ensure that
>> sleeping functions aren't called between the bh_lock/unlock.

We can't do it for hci_sock_dev_event(HCI_DEV_UNREG).

