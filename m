Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0C23FF439
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347397AbhIBTda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347257AbhIBTd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 15:33:29 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A403C061575;
        Thu,  2 Sep 2021 12:32:30 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id ew6so1869488qvb.5;
        Thu, 02 Sep 2021 12:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aHE7zhQdsgMlH+QYp+lhq1R1P0X5X+hqgUKEq7BGKS4=;
        b=ZY0/brsioDgMyqZX/2nrccZCzAy3jjpWaMHMsxHA/v9M8bZDqF/r7muWlirT+gp7hd
         9AlSUBkDvObiuRydUBfnkCaJTuXyRTysPs9upUxcjfXxQQ1y6PKkntnn4rtLsH3fXh+W
         jANNYJio0IiiDjRRNxBCLa7wuyxrfQGfEamZXNCHzKZ/4iju/DhvWMXlWAOn8gZOKM/0
         iBF38O+35wDqKGP0Wy4YD7o+D60prPcrELMjaT5jZ90rgi/9oFbQLdjQQRYSzpnm0AE1
         w57VqnWwYgP/LuxMn7eQfb9rN7uiIt36vJpz06KgbO1Cpecrk6GYo5NW7SsY7amrojv+
         YgtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aHE7zhQdsgMlH+QYp+lhq1R1P0X5X+hqgUKEq7BGKS4=;
        b=eMOaSx1Sd3VHGFC7CkCQ2+NYyOu+PJk59ClzCTYMIVPx9iWNKNHHeQoJNesKD2Pm8y
         VtL3KRs2kclVwdlHanUqc442NukjeAlqe5E3mqtYutAgCoscP5y/6o7so8BdQjzrsCMc
         JZnK0g8qemLbAokXl9sWLmkOazeGbJ/4V2KJBurJjRqpWE2LFQbo1+iivDBNJQ0n1piE
         W53IwcNBMN+9ifRQkziILhYArYfv/jIWlXMGtnh+wBhslIJRDvnSVyc/IoLsYZHKBXTZ
         v9nSKL0pzZcz6vuTyb7CDQxoiGtfJLqrBacO5VEYKzEWn3lgIfvKtR1OhNDG5wrwPPK2
         rl2g==
X-Gm-Message-State: AOAM5305p4pEMXXFnQJkk2XQlaQGOYKkUb+Gd6z2Av78riXNcE6+usLY
        74W/BNJMWI0NuwUEU6bg57Y=
X-Google-Smtp-Source: ABdhPJxJ0LoTmr9L/ypJePJEoM5Crj9PywoaJjjt/idCHx20b4lcg6f5IS4bwA+SGlhimA2gxIJ7Kg==
X-Received: by 2002:a0c:c707:: with SMTP id w7mr4942176qvi.14.1630611148794;
        Thu, 02 Sep 2021 12:32:28 -0700 (PDT)
Received: from ?IPv6:2620:6e:6000:3100:dedd:4a4a:8e3e:2af5? ([2620:6e:6000:3100:dedd:4a4a:8e3e:2af5])
        by smtp.gmail.com with ESMTPSA id 207sm2217988qkh.45.2021.09.02.12.32.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 12:32:28 -0700 (PDT)
Subject: Re: [PATCH v6 1/6] Bluetooth: schedule SCO timeouts with delayed_work
To:     Eric Dumazet <eric.dumazet@gmail.com>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
References: <20210810041410.142035-1-desmondcheongzx@gmail.com>
 <20210810041410.142035-2-desmondcheongzx@gmail.com>
 <0b33a7fe-4da0-058c-cff3-16bb5cfe8f45@gmail.com>
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Message-ID: <bad67d05-366b-bebe-cbdb-6555386497de@gmail.com>
Date:   Thu, 2 Sep 2021 15:32:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0b33a7fe-4da0-058c-cff3-16bb5cfe8f45@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/21 3:17 pm, Eric Dumazet wrote:
> 
> 
> On 8/9/21 9:14 PM, Desmond Cheong Zhi Xi wrote:
>> struct sock.sk_timer should be used as a sock cleanup timer. However,
>> SCO uses it to implement sock timeouts.
>>
>> This causes issues because struct sock.sk_timer's callback is run in
>> an IRQ context, and the timer callback function sco_sock_timeout takes
>> a spin lock on the socket. However, other functions such as
>> sco_conn_del and sco_conn_ready take the spin lock with interrupts
>> enabled.
>>
>> This inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} lock usage could
>> lead to deadlocks as reported by Syzbot [1]:
>>         CPU0
>>         ----
>>    lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>>    <Interrupt>
>>      lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>>
>> To fix this, we use delayed work to implement SCO sock timouts
>> instead. This allows us to avoid taking the spin lock on the socket in
>> an IRQ context, and corrects the misuse of struct sock.sk_timer.
>>
>> As a note, cancel_delayed_work is used instead of
>> cancel_delayed_work_sync in sco_sock_set_timer and
>> sco_sock_clear_timer to avoid a deadlock. In the future, the call to
>> bh_lock_sock inside sco_sock_timeout should be changed to lock_sock to
>> synchronize with other functions using lock_sock. However, since
>> sco_sock_set_timer and sco_sock_clear_timer are sometimes called under
>> the locked socket (in sco_connect and __sco_sock_close),
>> cancel_delayed_work_sync might cause them to sleep until an
>> sco_sock_timeout that has started finishes running. But
>> sco_sock_timeout would also sleep until it can grab the lock_sock.
>>
>> Using cancel_delayed_work is fine because sco_sock_timeout does not
>> change from run to run, hence there is no functional difference
>> between:
>> 1. waiting for a timeout to finish running before scheduling another
>> timeout
>> 2. scheduling another timeout while a timeout is running.
>>
>> Link: https://syzkaller.appspot.com/bug?id=9089d89de0502e120f234ca0fc8a703f7368b31e [1]
>> Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
>> Tested-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
>> Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
>> ---
>>   net/bluetooth/sco.c | 35 +++++++++++++++++++++++++++++------
>>   1 file changed, 29 insertions(+), 6 deletions(-)
>>
>> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
>> index ffa2a77a3e4c..62e638f971a9 100644
>> --- a/net/bluetooth/sco.c
>> +++ b/net/bluetooth/sco.c
>> @@ -48,6 +48,8 @@ struct sco_conn {
>>   	spinlock_t	lock;
>>   	struct sock	*sk;
>>   
>> +	struct delayed_work	timeout_work;
>> +
>>   	unsigned int    mtu;
>>   };
>>   
>> @@ -74,9 +76,20 @@ struct sco_pinfo {
>>   #define SCO_CONN_TIMEOUT	(HZ * 40)
>>   #define SCO_DISCONN_TIMEOUT	(HZ * 2)
>>   
>> -static void sco_sock_timeout(struct timer_list *t)
>> +static void sco_sock_timeout(struct work_struct *work)
>>   {
>> -	struct sock *sk = from_timer(sk, t, sk_timer);
>> +	struct sco_conn *conn = container_of(work, struct sco_conn,
>> +					     timeout_work.work);
>> +	struct sock *sk;
>> +
>> +	sco_conn_lock(conn);
>> +	sk = conn->sk;
>> +	if (sk)
>> +		sock_hold(sk);
> 
> syzbot complains here that sk refcount can be zero at this time.
> 
> refcount_t: addition on 0; use-after-free.
> WARNING: CPU: 0 PID: 10451 at lib/refcount.c:25 refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
> Modules linked in:
> CPU: 0 PID: 10451 Comm: kworker/0:8 Not tainted 5.14.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events sco_sock_timeout
> RIP: 0010:refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
> Code: 09 31 ff 89 de e8 d7 c9 9e fd 84 db 0f 85 36 ff ff ff e8 8a c3 9e fd 48 c7 c7 20 8f e3 89 c6 05 e8 7f 81 09 01 e8 f0 98 16 05 <0f> 0b e9 17 ff ff ff e8 6b c3 9e fd 0f b6 1d cd 7f 81 09 31 ff 89
> RSP: 0018:ffffc9001766fce8 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88802cea3880 RSI: ffffffff815d87a5 RDI: fffff52002ecdf8f
> RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815d25de R11: 0000000000000000 R12: ffff88806d23ce08
> R13: ffff8880712c8080 R14: ffff88802edf4500 R15: ffff8880b9c51240
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f3748c20000 CR3: 0000000017644000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   __refcount_add include/linux/refcount.h:199 [inline]
>   __refcount_inc include/linux/refcount.h:250 [inline]
>   refcount_inc include/linux/refcount.h:267 [inline]
>   sock_hold include/net/sock.h:702 [inline]
>   sco_sock_timeout+0x216/0x290 net/bluetooth/sco.c:88
>   process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
>   worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
>   kthread+0x3e5/0x4d0 kernel/kthread.c:319
> 
> 
>> +	sco_conn_unlock(conn);
>> +
>> +	if (!sk)
>> +		return;
>>   
>>   	BT_DBG("sock %p state %d", sk, sk->sk_state);
>>   
>> @@ -91,14 +104,21 @@ static void sco_sock_timeout(struct timer_list *t)
>>   
>>   static void sco_sock_set_timer(struct sock *sk, long timeout)
>>   {
>> +	if (!sco_pi(sk)->conn)
>> +		return;
>> +
>>   	BT_DBG("sock %p state %d timeout %ld", sk, sk->sk_state, timeout);
>> -	sk_reset_timer(sk, &sk->sk_timer, jiffies + timeout);
>> +	cancel_delayed_work(&sco_pi(sk)->conn->timeout_work);
>> +	schedule_delayed_work(&sco_pi(sk)->conn->timeout_work, timeout);
> 
>>   }
>>   
>>   static void sco_sock_clear_timer(struct sock *sk)
>>   {
>> +	if (!sco_pi(sk)->conn)
>> +		return;
>> +
>>   	BT_DBG("sock %p state %d", sk, sk->sk_state);
>> -	sk_stop_timer(sk, &sk->sk_timer);
>> +	cancel_delayed_work(&sco_pi(sk)->conn->timeout_work);
> 
> 
>>   }
>>   
>>   /* ---- SCO connections ---- */
>> @@ -179,6 +199,9 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
>>   		bh_unlock_sock(sk);
>>   		sco_sock_kill(sk);
>>   		sock_put(sk);
>> +
>> +		/* Ensure no more work items will run before freeing conn. */
> 
> Maybe you should have done this cancel_delayed_work_sync() before the prior sock_put(sk) ?
> 
>> +		cancel_delayed_work_sync(&conn->timeout_work);
>>   	}
>>   
>>   	hcon->sco_data = NULL;
>> @@ -193,6 +216,8 @@ static void __sco_chan_add(struct sco_conn *conn, struct sock *sk,
>>   	sco_pi(sk)->conn = conn;
>>   	conn->sk = sk;
>>   
>> +	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
>> +
>>   	if (parent)
>>   		bt_accept_enqueue(parent, sk, true);
>>   }
>> @@ -500,8 +525,6 @@ static struct sock *sco_sock_alloc(struct net *net, struct socket *sock,
>>   
>>   	sco_pi(sk)->setting = BT_VOICE_CVSD_16BIT;
>>   
>> -	timer_setup(&sk->sk_timer, sco_sock_timeout, 0);
>> -
>>   	bt_sock_link(&sco_sk_list, sk);
>>   	return sk;
>>   }
>>

Hi Eric,

This actually seems to be a pre-existing error in sco_sock_connect that 
we now hit in sco_sock_timeout.

Any thoughts on the following patch to address the problem?

Link: 
https://lore.kernel.org/lkml/20210831065601.101185-1-desmondcheongzx@gmail.com/
