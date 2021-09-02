Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985DE3FF7A2
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 01:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348537AbhIBXGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 19:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347943AbhIBXGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 19:06:52 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F19CC061575;
        Thu,  2 Sep 2021 16:05:53 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id b64so4072414qkg.0;
        Thu, 02 Sep 2021 16:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jEtVc/Y6Y90s3mCuRbL/bjjGKhGT7MI4nPKvE05RH60=;
        b=cZaLSM/kOMm+Ar2RPW+ZjTNASQk3hz6WXEtdIu2JGKGQim4GZ4iahSx3qF/cw3VXe/
         K7y/WpcIduoB+i3BB9WEs0ZVh8zGeckRNJak+U0U3oxq7V62+7sh4SGrnEC6w6v1k0bE
         gJ4h98ewuCPr1JOVJFAu7NNyHL/n5uO0eF7f6pUPmyUjiotyiEU9XaVEbSj721FpNw06
         maiMS40NTrCzIGjjRl4ANuF7nUkzh28bzwy0I8U//PuoyyGIY4h0uS/EKbxKYtNJw9Be
         Ll4L/8pJ5dWQ4bt2QssW5IOPrFCIlTAhR6dKE1CHOoDfllzzkQzUl6FdPH9vx6pHl4gS
         fylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jEtVc/Y6Y90s3mCuRbL/bjjGKhGT7MI4nPKvE05RH60=;
        b=QgLxtDi3wtrxtA80WnddZP63rjmwSwooayMiGKfs9mxmjHqV4z+35LGiHCq8y6Yh9x
         +ehrm9Wt/3J9diF1xP87qE8CMUDwUVhx0t9uouAgkSvQnNmD4DPcYzBwdo8xIP/GFSCH
         N3pP3sw/wb9YOM3kO465hPyg+/G3niWzQlIJxMW+rc8JJYjBoGJSfV7VzijTRdgk4FXY
         kMRORp2ol7y0FQhUt+Yy0xgHEdXcoEMNIFOIsMBx4el4hIMi9+6MZpw105fUSYgQJv5u
         Mr9xmC1oquK5rgQqcToXpgk7CR/y1NUXUz8qqi7XL9avhRN7IUcZtb4Yo/r5kXgqAmzK
         nG3w==
X-Gm-Message-State: AOAM530FFwsslcGL3d3bse2w8dz+Sm5o6OEiL+B8yG3IOBFX/sUfFSRd
        4oM4C0pyTc7JRsxF+J7aRkI=
X-Google-Smtp-Source: ABdhPJxVm36GU/6zFkBTHQ6Y3nFXHphkX4NgA2sTDHy11JnIH30oP2pmqM7dD+bud12ckxYxbVhE7g==
X-Received: by 2002:a37:e06:: with SMTP id 6mr569790qko.290.1630623952660;
        Thu, 02 Sep 2021 16:05:52 -0700 (PDT)
Received: from [192.168.4.142] (pool-72-82-21-11.prvdri.fios.verizon.net. [72.82.21.11])
        by smtp.gmail.com with ESMTPSA id x19sm2537341qkm.115.2021.09.02.16.05.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 16:05:52 -0700 (PDT)
Subject: Re: [PATCH v6 1/6] Bluetooth: schedule SCO timeouts with delayed_work
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
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
 <bad67d05-366b-bebe-cbdb-6555386497de@gmail.com>
 <94942257-927c-efbc-b3fd-44cc097ad71f@gmail.com>
 <fa269649-21eb-be76-e552-36a3aa4f3da4@gmail.com>
Message-ID: <e54b3c01-6804-4f0d-3e4b-eba49f881039@gmail.com>
Date:   Thu, 2 Sep 2021 19:05:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <fa269649-21eb-be76-e552-36a3aa4f3da4@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/21 6:53 pm, Desmond Cheong Zhi Xi wrote:
> On 2/9/21 5:41 pm, Eric Dumazet wrote:
>>
>>
>> On 9/2/21 12:32 PM, Desmond Cheong Zhi Xi wrote:
>>>
>>> Hi Eric,
>>>
>>> This actually seems to be a pre-existing error in sco_sock_connect 
>>> that we now hit in sco_sock_timeout.
>>>
>>> Any thoughts on the following patch to address the problem?
>>>
>>> Link: 
>>> https://lore.kernel.org/lkml/20210831065601.101185-1-desmondcheongzx@gmail.com/ 
>>>
>>
>>
>> syzbot is still working on finding a repro, this is obviously not 
>> trivial,
>> because this is a race window.
>>
>> I think this can happen even with a single SCO connection.
>>
>> This might be triggered more easily forcing a delay in sco_sock_timeout()
>>
>> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
>> index 
>> 98a88158651281c9f75c4e0371044251e976e7ef..71ebe0243fab106c676c308724fe3a3f92a62cbd 
>> 100644
>> --- a/net/bluetooth/sco.c
>> +++ b/net/bluetooth/sco.c
>> @@ -84,8 +84,14 @@ static void sco_sock_timeout(struct work_struct *work)
>>          sco_conn_lock(conn);
>>          sk = conn->sk;
>> -       if (sk)
>> +       if (sk) {
>> +               // lets pretend cpu has been busy (in interrupts) for 
>> 100ms
>> +               int i;
>> +               for (i=0;i<100000;i++)
>> +                       udelay(1);
>> +
>>                  sock_hold(sk);
>> +       }>          sco_conn_unlock(conn);
>>          if (!sk)
>>
>>
>> Stack trace tells us that sco_sock_timeout() is running after last 
>> reference
>> on socket has been released.
>>
>> __refcount_add include/linux/refcount.h:199 [inline]
>>   __refcount_inc include/linux/refcount.h:250 [inline]
>>   refcount_inc include/linux/refcount.h:267 [inline]
>>   sock_hold include/net/sock.h:702 [inline]
>>   sco_sock_timeout+0x216/0x290 net/bluetooth/sco.c:88
>>   process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
>>   worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
>>   kthread+0x3e5/0x4d0 kernel/kthread.c:319
>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>>
>> This is why I suggested to delay sock_put() to make sure this can not 
>> happen.
>>
>> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
>> index 
>> 98a88158651281c9f75c4e0371044251e976e7ef..bd0222e3f05a6bcb40cffe8405c9dfff98d7afde 
>> 100644
>> --- a/net/bluetooth/sco.c
>> +++ b/net/bluetooth/sco.c
>> @@ -195,10 +195,11 @@ static void sco_conn_del(struct hci_conn *hcon, 
>> int err)
>>                  sco_sock_clear_timer(sk);
>>                  sco_chan_del(sk, err);
>>                  release_sock(sk);
>> -               sock_put(sk);
>>                  /* Ensure no more work items will run before freeing 
>> conn. */
>>                  cancel_delayed_work_sync(&conn->timeout_work);
>> +
>> +               sock_put(sk);
>>          }
>>          hcon->sco_data = NULL;
>>
> 
> I see where you're going with this, but once sco_chan_del returns, any
> instance of sco_sock_timeout that hasn't yet called sock_hold will
> simply return, because conn->sk is NULL. Adding a delay to the
> sco_conn_lock critical section in sco_sock_timeout would not affect this
> because sco_chan_del clears conn->sk while holding onto the lock.
> 
> The main reason that cancel_delayed_work_sync is run there is to make
> sure that we don't have a UAF on the SCO connection itself after we free
> conn.
> 

Now that I think about this, the init and cleanup isn't quite right
either. The delayed work should be initialized when the connection is
allocated, and we should always cancel all work before freeing:

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index ea18e5b56343..bba5cdb4cb4a 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -133,6 +133,7 @@ static struct sco_conn *sco_conn_add(struct hci_conn *hcon)
  		return NULL;
  
  	spin_lock_init(&conn->lock);
+	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
  
  	hcon->sco_data = conn;
  	conn->hcon = hcon;
@@ -197,11 +198,11 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
  		sco_chan_del(sk, err);
  		release_sock(sk);
  		sock_put(sk);
-
-		/* Ensure no more work items will run before freeing conn. */
-		cancel_delayed_work_sync(&conn->timeout_work);
  	}
  
+	/* Ensure no more work items will run before freeing conn. */
+	cancel_delayed_work_sync(&conn->timeout_work);
+
  	hcon->sco_data = NULL;
  	kfree(conn);
  }
@@ -214,8 +215,6 @@ static void __sco_chan_add(struct sco_conn *conn, struct sock *sk,
  	sco_pi(sk)->conn = conn;
  	conn->sk = sk;
  
-	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
-
  	if (parent)
  		bt_accept_enqueue(parent, sk, true);
  }

> For a single SCO connection with well-formed channel, I think there
> can't be a race. Here's the reasoning:
> 
> - For the timeout to be scheduled, a socket must have a channel with a
> connection.
> 
> - When a channel between a socket and connection is established, the
> socket transitions from BT_OPEN to BT_CONNECTED, BT_CONNECT, or
> BT_CONNECT2.
> 
> - For a socket to be released, it has to be zapped. For sockets that
> have a state of BT_CONNECTED, BT_CONNECT, or BT_CONNECT2, they are
> zapped only when the channel is deleted.
> 
> - If the channel is deleted (which is protected by sco_conn_lock), then
> conn->sk is NULL, and sco_sock_timeout simply exits. If we had entered
> the critical section in sco_sock_timeout before the channel was deleted,
> then we increased the reference count on the socket, so it won't be
> freed until sco_sock_timeout is done.
> 
> Hence, sco_sock_timeout doesn't race with the release of a socket that
> has a well-formed channel with a connection.
> 
> But if multiple connections are allocated and overwritten in
> sco_sock_connect, then none of the above assumptions hold because the
> SCO connection can't be cleaned up (i.e. conn->sk cannot be set to NULL)
> when the associated socket is released. This scenario happens in the
> syzbot reproducer for the crash here:
> https://syzkaller.appspot.com/bug?id=bcc246d137428d00ed14b476c2068579515fe2bc 
> 
> 
> That aside, upon taking a closer look, I think there is indeed a race
> lurking in sco_conn_del, but it's not the one that syzbot is hitting.
> Our sock_hold simply comes too late, and by the time it's called we
> might have already have freed the socket.
> 
> So probably something like this needs to happen:
> 
> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> index fa25b07120c9..ea18e5b56343 100644
> --- a/net/bluetooth/sco.c
> +++ b/net/bluetooth/sco.c
> @@ -187,10 +187,11 @@ static void sco_conn_del(struct hci_conn *hcon, 
> int err)
>       /* Kill socket */
>       sco_conn_lock(conn);
>       sk = conn->sk;
> +    if (sk)
> +        sock_hold(sk);
>       sco_conn_unlock(conn);
> 
>       if (sk) {
> -        sock_hold(sk);
>           lock_sock(sk);
>           sco_sock_clear_timer(sk);
>           sco_chan_del(sk, err);

