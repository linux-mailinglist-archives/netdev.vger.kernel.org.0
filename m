Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2523FF76E
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 00:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348950AbhIBWz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 18:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348697AbhIBWyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 18:54:55 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213B4C061575;
        Thu,  2 Sep 2021 15:53:56 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id 4so2171960qvp.3;
        Thu, 02 Sep 2021 15:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OzpYK8dvsIlm/S8gJHWT+Oy8oCpnYbMnDX+i/m5SSTs=;
        b=bQsf4oPtcPEYtYW7ZnoUgMDLuJQdxMtbDg+2hVBPPA8B+SDgbl7yHNhCOARBU3/VuO
         95jxFnGaKyu37iRHNOiXcsALAVrJbcl923U806rgq63sigTWoMHYV2g4EMFzyiah4yrt
         GwvmGhD0OojznsPNEOiEKvs4lWiwBg2KBIGlfgSCmwU9u7mFWdG2bon2nT2IpHTJC7hx
         kVmYm8grMBNhxowgcIM5OlgIZw9c7c15E+hoEJEu0kRYFz3zBjFo1pCK3aYce0XTyX+T
         W2d1DECpj60DqYOmQve18Q1cJDIWwd0X7+fuCSHzUHy6/YfPu0Amxnbfr2IC/adbg0yV
         cNFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OzpYK8dvsIlm/S8gJHWT+Oy8oCpnYbMnDX+i/m5SSTs=;
        b=nhv6oDa1MnrcQduxipBxy4wyVx41dS4bZV4wV1Q2rJCOCO6BR3TsydxG60i0mItu1/
         Eu1gcpom0DDsxOm7XrHLCEXO1WWzEg/aa73rTL9SeCkqYBrK2bcAbbPlh4vCwvq9lOG1
         8u2lbNAS+gzTCmKgDhW90Pw4exmYeQ7fqUZPfcc23nZe1qABLX2e0wwvF4UrNdNPZWJB
         OZeE4O+VHL08220/0G4oT7HqMwWUEPN6QWa513/CeRkWOvuiZyZ7PZ5AZkubM0F3n5B9
         0YAn5cdox1pMq4GYGj/9PL559QzsM7HWWK9A+imT5hvIhzVFDmLqV4jNi3yVMX8MSM95
         o2Aw==
X-Gm-Message-State: AOAM531S7DOrn+DLyjpKj5yctoFWoYb6gRTHrae6D2KnI2KlQIZNIYAX
        UBKgusqTVTa2i6c+S89yKbKxmMIk9foMnoRo
X-Google-Smtp-Source: ABdhPJyg5pvO80hmei1LQvFpHKLM/sURl80NK6h0B8+ffkuxqd34KT8RNR5rdg3dNqfaRjmvRXMCgQ==
X-Received: by 2002:a05:6214:14f2:: with SMTP id k18mr618747qvw.19.1630623235206;
        Thu, 02 Sep 2021 15:53:55 -0700 (PDT)
Received: from [192.168.4.142] (pool-72-82-21-11.prvdri.fios.verizon.net. [72.82.21.11])
        by smtp.gmail.com with ESMTPSA id r140sm2577993qke.15.2021.09.02.15.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 15:53:54 -0700 (PDT)
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
 <bad67d05-366b-bebe-cbdb-6555386497de@gmail.com>
 <94942257-927c-efbc-b3fd-44cc097ad71f@gmail.com>
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Message-ID: <fa269649-21eb-be76-e552-36a3aa4f3da4@gmail.com>
Date:   Thu, 2 Sep 2021 18:53:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <94942257-927c-efbc-b3fd-44cc097ad71f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/21 5:41 pm, Eric Dumazet wrote:
> 
> 
> On 9/2/21 12:32 PM, Desmond Cheong Zhi Xi wrote:
>>
>> Hi Eric,
>>
>> This actually seems to be a pre-existing error in sco_sock_connect that we now hit in sco_sock_timeout.
>>
>> Any thoughts on the following patch to address the problem?
>>
>> Link: https://lore.kernel.org/lkml/20210831065601.101185-1-desmondcheongzx@gmail.com/
> 
> 
> syzbot is still working on finding a repro, this is obviously not trivial,
> because this is a race window.
> 
> I think this can happen even with a single SCO connection.
> 
> This might be triggered more easily forcing a delay in sco_sock_timeout()
> 
> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> index 98a88158651281c9f75c4e0371044251e976e7ef..71ebe0243fab106c676c308724fe3a3f92a62cbd 100644
> --- a/net/bluetooth/sco.c
> +++ b/net/bluetooth/sco.c
> @@ -84,8 +84,14 @@ static void sco_sock_timeout(struct work_struct *work)
>   
>          sco_conn_lock(conn);
>          sk = conn->sk;
> -       if (sk)
> +       if (sk) {
> +               // lets pretend cpu has been busy (in interrupts) for 100ms
> +               int i;
> +               for (i=0;i<100000;i++)
> +                       udelay(1);
> +
>                  sock_hold(sk);
> +       }>          sco_conn_unlock(conn);
>   
>          if (!sk)
> 
> 
> Stack trace tells us that sco_sock_timeout() is running after last reference
> on socket has been released.
> 
> __refcount_add include/linux/refcount.h:199 [inline]
>   __refcount_inc include/linux/refcount.h:250 [inline]
>   refcount_inc include/linux/refcount.h:267 [inline]
>   sock_hold include/net/sock.h:702 [inline]
>   sco_sock_timeout+0x216/0x290 net/bluetooth/sco.c:88
>   process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
>   worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
>   kthread+0x3e5/0x4d0 kernel/kthread.c:319
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
> This is why I suggested to delay sock_put() to make sure this can not happen.
> 
> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> index 98a88158651281c9f75c4e0371044251e976e7ef..bd0222e3f05a6bcb40cffe8405c9dfff98d7afde 100644
> --- a/net/bluetooth/sco.c
> +++ b/net/bluetooth/sco.c
> @@ -195,10 +195,11 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
>                  sco_sock_clear_timer(sk);
>                  sco_chan_del(sk, err);
>                  release_sock(sk);
> -               sock_put(sk);
>   
>                  /* Ensure no more work items will run before freeing conn. */
>                  cancel_delayed_work_sync(&conn->timeout_work);
> +
> +               sock_put(sk);
>          }
>   
>          hcon->sco_data = NULL;
> 

I see where you're going with this, but once sco_chan_del returns, any
instance of sco_sock_timeout that hasn't yet called sock_hold will
simply return, because conn->sk is NULL. Adding a delay to the
sco_conn_lock critical section in sco_sock_timeout would not affect this
because sco_chan_del clears conn->sk while holding onto the lock.

The main reason that cancel_delayed_work_sync is run there is to make
sure that we don't have a UAF on the SCO connection itself after we free
conn.

For a single SCO connection with well-formed channel, I think there
can't be a race. Here's the reasoning:

- For the timeout to be scheduled, a socket must have a channel with a
connection.

- When a channel between a socket and connection is established, the
socket transitions from BT_OPEN to BT_CONNECTED, BT_CONNECT, or
BT_CONNECT2.

- For a socket to be released, it has to be zapped. For sockets that
have a state of BT_CONNECTED, BT_CONNECT, or BT_CONNECT2, they are
zapped only when the channel is deleted.

- If the channel is deleted (which is protected by sco_conn_lock), then
conn->sk is NULL, and sco_sock_timeout simply exits. If we had entered
the critical section in sco_sock_timeout before the channel was deleted,
then we increased the reference count on the socket, so it won't be
freed until sco_sock_timeout is done.

Hence, sco_sock_timeout doesn't race with the release of a socket that
has a well-formed channel with a connection.

But if multiple connections are allocated and overwritten in
sco_sock_connect, then none of the above assumptions hold because the
SCO connection can't be cleaned up (i.e. conn->sk cannot be set to NULL)
when the associated socket is released. This scenario happens in the
syzbot reproducer for the crash here:
https://syzkaller.appspot.com/bug?id=bcc246d137428d00ed14b476c2068579515fe2bc

That aside, upon taking a closer look, I think there is indeed a race
lurking in sco_conn_del, but it's not the one that syzbot is hitting.
Our sock_hold simply comes too late, and by the time it's called we
might have already have freed the socket.

So probably something like this needs to happen:

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index fa25b07120c9..ea18e5b56343 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -187,10 +187,11 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
  	/* Kill socket */
  	sco_conn_lock(conn);
  	sk = conn->sk;
+	if (sk)
+		sock_hold(sk);
  	sco_conn_unlock(conn);
  
  	if (sk) {
-		sock_hold(sk);
  		lock_sock(sk);
  		sco_sock_clear_timer(sk);
  		sco_chan_del(sk, err);
