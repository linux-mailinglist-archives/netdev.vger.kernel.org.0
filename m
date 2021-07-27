Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2F33D6DDB
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 07:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbhG0FNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 01:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234905AbhG0FNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 01:13:33 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B49DC061757;
        Mon, 26 Jul 2021 22:13:33 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so3264135pjh.3;
        Mon, 26 Jul 2021 22:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ph2241rVhgFO1amFPzoGwsMLBS0Tz5IeCzxNLId1vXc=;
        b=gdwR086Hu7r35kWnQF0+ekLFEqIS1UkEZ2Rr+pk3kYNcMGN5XtBklkD1WVPXrfimUV
         y7OaLmDQe12utiZbLbdGGfbABbEPsV2M7J6BdH1yGIWvJHpJe+tEdQPzGVCT4rpxfJwO
         qQahkB0HQ6Gl/OIQPklTsFgkITtnssQZ4VcFmkWUG943Pa8jdmRxIQqL2nBRapLSglFj
         z6bbjwXs+2vIN8EuQ9t5h5oLF1ziRdNPDjuFa8AQyOQbNNvIN9rKpXSsd5z6+T1+jlXX
         FIfR4yMgCjT2XeWKPSOmTVymXGJUWHtEMQsaZyAD4qmFGkHvpeHK2ZpENUcwY8ZNyaMt
         743Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ph2241rVhgFO1amFPzoGwsMLBS0Tz5IeCzxNLId1vXc=;
        b=Tr+S2DC5ArPETIc8UcXIF9tiDctNMd/I8bWPQlwg2i+OFbO6XvVJWhbXKbisfS8WPd
         sxxFNlUU0jDkgY1cfuVY0ubJbeGdSXloBUlOpKe60+KrKAgQVSbfjG53T6qjf4m0uRJu
         XpLB1oWH+WuPnJTX2LEqBzlZK+DJV/cQzGYljhcF+UK0FUim58sEPPqAxRLJLtaVjyAP
         pVyhQwxovRAo4EEEXzZuE8g1KFjpfi3MRJcOSHo/8jkjG7Hwkw/u19qJtO0Q5Furi1zw
         +EU8jzZZwrNfe6inZYTI3QKvKW04X9z//vPVZwhetLIuPyrCv2pniOpa73dPGyxnhKJi
         Ppbg==
X-Gm-Message-State: AOAM530MaHpq5jhdK8OGw2GQB/hiOgTY9FF00xEKixZzJg38Lw6X0uZT
        lMAl845L5xA0ynVcy/WpWPs=
X-Google-Smtp-Source: ABdhPJxZEy2MtnZLGq/NKaVaId5yRY4DxMvwQhA3+PXJieyEq/OF3/hpSiN9OPRS9XlPmqd1CYGoUQ==
X-Received: by 2002:aa7:8642:0:b029:348:7bf1:efec with SMTP id a2-20020aa786420000b02903487bf1efecmr21187171pfo.49.1627362813117;
        Mon, 26 Jul 2021 22:13:33 -0700 (PDT)
Received: from [192.168.1.237] ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id 198sm1853800pfw.21.2021.07.26.22.13.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 22:13:32 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] Bluetooth: fix inconsistent lock state in SCO
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, matthieu.baerts@tessares.net,
        stefan@datenfreihafen.org,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        skhan@linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
References: <20210721093832.78081-1-desmondcheongzx@gmail.com>
 <20210721093832.78081-2-desmondcheongzx@gmail.com>
 <CABBYNZLus8GyPuTp4jmAeSEdsYTZ-4gK6OvGXqcABhci8tBOwA@mail.gmail.com>
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Message-ID: <764e18f7-ccf4-2010-87fc-feb1d3089098@gmail.com>
Date:   Tue, 27 Jul 2021 13:13:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CABBYNZLus8GyPuTp4jmAeSEdsYTZ-4gK6OvGXqcABhci8tBOwA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/7/21 8:30 am, Luiz Augusto von Dentz wrote:
> Hi Desmond,
> 
> On Wed, Jul 21, 2021 at 2:39 AM Desmond Cheong Zhi Xi
> <desmondcheongzx@gmail.com> wrote:
>>
>> Syzbot reported an inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} lock
>> usage in sco_conn_del and sco_sock_timeout that could lead to
>> deadlocks.
>>
>> This inconsistent lock state can also happen in sco_conn_ready,
>> rfcomm_connect_ind, and bt_accept_enqueue.
>>
>> The issue is that these functions take a spin lock on the socket with
>> interrupts enabled, but sco_sock_timeout takes the lock in an IRQ
>> context. This could lead to deadlocks:
>>
>>         CPU0
>>         ----
>>    lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>>    <Interrupt>
>>      lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
> 
> Having a second look at this, it does seem this is due to use of
> sk->sk_timer which apparently run its callback on IRQ context, so I
> wonder if wouldn't be a better idea to switch to a delayed_work to
> avoid having to deal with the likes of local_bh_disable, in fact it
> seems we have been misusing it since the documentation says it is for
> sock cleanup not for handling things like SNDTIMEO, we don't really
> use it for other socket types so I wonder when we start using
> delayed_work we forgot about sco.c.
> 

Hi Luiz,

That makes sense to me. I don't think there's a need for the timeout to 
be run in an IRQ context.

I'll prepare a patch for this, thanks for the suggestion.

>>   *** DEADLOCK ***
>>
>> We fix this by ensuring that local bh is disabled before calling
>> bh_lock_sock.
>>
>> After doing this, we additionally need to protect sco_conn_lock by
>> disabling local bh.
>>
>> This is necessary because sco_conn_del makes a call to sco_chan_del
>> while holding on to the sock lock, and sco_chan_del itself makes a
>> call to sco_conn_lock. If sco_conn_lock is held elsewhere with
>> interrupts enabled, there could still be a
>> slock-AF_BLUETOOTH-BTPROTO_SCO --> &conn->lock#2 lock inversion as
>> follows:
>>
>>          CPU0                    CPU1
>>          ----                    ----
>>     lock(&conn->lock#2);
>>                                  local_irq_disable();
>>                                  lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>>                                  lock(&conn->lock#2);
>>     <Interrupt>
>>       lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>>
>>    *** DEADLOCK ***
>>
>> Although sco_conn_del disables local bh before calling sco_chan_del,
>> we can still wrap the calls to sco_conn_lock in sco_chan_del, with
>> local_bh_disable/enable as this pair of functions are reentrant.
>>
>> Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
>> Tested-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
>> Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
>> ---
>>   net/bluetooth/sco.c | 21 +++++++++++++++++++++
>>   1 file changed, 21 insertions(+)
>>
>> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
>> index 3bd41563f118..34f3419c3330 100644
>> --- a/net/bluetooth/sco.c
>> +++ b/net/bluetooth/sco.c
>> @@ -140,10 +140,12 @@ static void sco_chan_del(struct sock *sk, int err)
>>          BT_DBG("sk %p, conn %p, err %d", sk, conn, err);
>>
>>          if (conn) {
>> +               local_bh_disable();
>>                  sco_conn_lock(conn);
>>                  conn->sk = NULL;
>>                  sco_pi(sk)->conn = NULL;
>>                  sco_conn_unlock(conn);
>> +               local_bh_enable();
>>
>>                  if (conn->hcon)
>>                          hci_conn_drop(conn->hcon);
>> @@ -167,16 +169,22 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
>>          BT_DBG("hcon %p conn %p, err %d", hcon, conn, err);
>>
>>          /* Kill socket */
>> +       local_bh_disable();
>>          sco_conn_lock(conn);
>>          sk = conn->sk;
>>          sco_conn_unlock(conn);
>> +       local_bh_enable();
>>
>>          if (sk) {
>>                  sock_hold(sk);
>> +
>> +               local_bh_disable();
>>                  bh_lock_sock(sk);
>>                  sco_sock_clear_timer(sk);
>>                  sco_chan_del(sk, err);
>>                  bh_unlock_sock(sk);
>> +               local_bh_enable();
>> +
>>                  sco_sock_kill(sk);
>>                  sock_put(sk);
>>          }
>> @@ -202,6 +210,7 @@ static int sco_chan_add(struct sco_conn *conn, struct sock *sk,
>>   {
>>          int err = 0;
>>
>> +       local_bh_disable();
>>          sco_conn_lock(conn);
>>          if (conn->sk)
>>                  err = -EBUSY;
>> @@ -209,6 +218,7 @@ static int sco_chan_add(struct sco_conn *conn, struct sock *sk,
>>                  __sco_chan_add(conn, sk, parent);
>>
>>          sco_conn_unlock(conn);
>> +       local_bh_enable();
>>          return err;
>>   }
>>
>> @@ -303,9 +313,11 @@ static void sco_recv_frame(struct sco_conn *conn, struct sk_buff *skb)
>>   {
>>          struct sock *sk;
>>
>> +       local_bh_disable();
>>          sco_conn_lock(conn);
>>          sk = conn->sk;
>>          sco_conn_unlock(conn);
>> +       local_bh_enable();
>>
>>          if (!sk)
>>                  goto drop;
>> @@ -420,10 +432,12 @@ static void __sco_sock_close(struct sock *sk)
>>                  if (sco_pi(sk)->conn->hcon) {
>>                          sk->sk_state = BT_DISCONN;
>>                          sco_sock_set_timer(sk, SCO_DISCONN_TIMEOUT);
>> +                       local_bh_disable();
>>                          sco_conn_lock(sco_pi(sk)->conn);
>>                          hci_conn_drop(sco_pi(sk)->conn->hcon);
>>                          sco_pi(sk)->conn->hcon = NULL;
>>                          sco_conn_unlock(sco_pi(sk)->conn);
>> +                       local_bh_enable();
>>                  } else
>>                          sco_chan_del(sk, ECONNRESET);
>>                  break;
>> @@ -1084,21 +1098,26 @@ static void sco_conn_ready(struct sco_conn *conn)
>>
>>          if (sk) {
>>                  sco_sock_clear_timer(sk);
>> +               local_bh_disable();
>>                  bh_lock_sock(sk);
>>                  sk->sk_state = BT_CONNECTED;
>>                  sk->sk_state_change(sk);
>>                  bh_unlock_sock(sk);
>> +               local_bh_enable();
>>          } else {
>> +               local_bh_disable();
>>                  sco_conn_lock(conn);
>>
>>                  if (!conn->hcon) {
>>                          sco_conn_unlock(conn);
>> +                       local_bh_enable();
>>                          return;
>>                  }
>>
>>                  parent = sco_get_sock_listen(&conn->hcon->src);
>>                  if (!parent) {
>>                          sco_conn_unlock(conn);
>> +                       local_bh_enable();
>>                          return;
>>                  }
>>
>> @@ -1109,6 +1128,7 @@ static void sco_conn_ready(struct sco_conn *conn)
>>                  if (!sk) {
>>                          bh_unlock_sock(parent);
>>                          sco_conn_unlock(conn);
>> +                       local_bh_enable();
>>                          return;
>>                  }
>>
>> @@ -1131,6 +1151,7 @@ static void sco_conn_ready(struct sco_conn *conn)
>>                  bh_unlock_sock(parent);
>>
>>                  sco_conn_unlock(conn);
>> +               local_bh_enable();
>>          }
>>   }
>>
>> --
>> 2.25.1
>>
> 
> 

