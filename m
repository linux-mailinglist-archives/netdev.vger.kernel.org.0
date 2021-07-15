Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD4C3C95DD
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 04:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbhGOCYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 22:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbhGOCYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 22:24:41 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00122C06175F;
        Wed, 14 Jul 2021 19:21:48 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id y17so4437468pgf.12;
        Wed, 14 Jul 2021 19:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xk+bzsUUhRfnteb4np5wfFEQnczuTEkubtOo+6KG5f4=;
        b=uYskKqEKC8XeGxw/m7v84jSQx3EE7S8LAGhN8uMoRZB3tprwcfikayRiOO7r98jTO2
         FB3YSj9kJjb/IjQ4W2Ukd97zdzhUfVZ0AZjITvfMcSupgUmhcT/kdUd91wQjMIB0lIYq
         U2zm8XnDRIk/e8X8WV1xVA14z+JftfxgoS/hSHCHySVK++6Or82EmORMnS4ETtiGK8C6
         Ee8gWQO7HSfP+o1ydoi5pFZS+LBqQEnDb9+a5P24TbfEC4jW+aCGR5+ZvGBraoKdDl4U
         PVo3n6tjoSsSM1krrraIj4WQuSQUmUWlfbML3yDR7QVmXmSLfxKzCqvtEmA7kWxRNOVv
         ER2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xk+bzsUUhRfnteb4np5wfFEQnczuTEkubtOo+6KG5f4=;
        b=VEDi5yqLxJbKheCdAzESS8VUCEJWnuZGWtFqluwUI6zIkUH/iiw6IQYiBV9JClCcej
         I0ciCRYAnsg+At7XlVcXy3Wky6bFXYr5DdLcN3CQS9sYzzbGiFhIubH0XhHnjHJO8VMB
         ff7w6MjAoM4A3QcIstr+HDYVGVcFxnU6bVNH5tgIjyLWJVZOxfx3xlScZAAqX6I5nLRX
         eFy9dSl2gFM+ltY3I0PSuG9uZ1gnt8x+QmAJSaddkB1IaX783U7Q/qwksMQUcPU+r28R
         Ad8QSZAWpVvS4pIWXh4T/hup9nAZuktSNVyC2KC76C+aYqyGQj4ASjBFUF8Y+6zsIGAy
         0yEQ==
X-Gm-Message-State: AOAM5326RSnJdiYxnv7Bie3bruarZKB+CkAXKYlSoapXhlgAsnnu1SZR
        kxQWLlCiTemJ0LnPbM1E2QA=
X-Google-Smtp-Source: ABdhPJwVicxeM6sLiW5I62juancSEsjb5cqhbqovYu8hHGmPkcGQDMQtm2t7s5tZ15wmKmjv7YeIrg==
X-Received: by 2002:a63:4a43:: with SMTP id j3mr1424942pgl.367.1626315708299;
        Wed, 14 Jul 2021 19:21:48 -0700 (PDT)
Received: from [192.168.1.237] ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id 20sm4288470pfi.170.2021.07.14.19.21.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jul 2021 19:21:47 -0700 (PDT)
Subject: Re: [PATCH v2] Bluetooth: fix inconsistent lock state in sco
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stefan@datenfreihafen.org,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        skhan@linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
References: <20210713162838.693266-1-desmondcheongzx@gmail.com>
 <CABBYNZLBfH+0=yhgcAK4XzizUKqpmAxjyxGpBACiFZpPsr0CEQ@mail.gmail.com>
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Message-ID: <a4e8c316-69d5-0a6f-5480-bfe077d9d032@gmail.com>
Date:   Thu, 15 Jul 2021 10:21:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CABBYNZLBfH+0=yhgcAK4XzizUKqpmAxjyxGpBACiFZpPsr0CEQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/7/21 3:12 am, Luiz Augusto von Dentz wrote:
> Hi Desmond,
> 
> On Tue, Jul 13, 2021 at 9:29 AM Desmond Cheong Zhi Xi
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
>>
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
>> As sco_conn_del now disables local bh before calling sco_chan_del,
>> instead of disabling local bh for the calls to sco_conn_lock in
>> sco_chan_del, we instead wrap other calls to sco_chan_del with
>> local_bh_disable/enable.
>>
>> Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
>> Tested-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
>> Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
>> ---
>>
>> Hi,
>>
>> The previous version of this patch was a bit of a mess, so I made the
>> following changes.
>>
>> v1 -> v2:
>> - Instead of pulling out the clean-up code out from sco_chan_del and
>> using it directly in sco_conn_del, disable local irqs for relevant
>> sections.
>> - Disable local irqs more thoroughly for instances of
>> bh_lock_sock/bh_lock_sock_nested in the bluetooth subsystem.
>> Specifically, the calls in af_bluetooth.c and rfcomm/sock.c are now made
>> with local irqs disabled as well.
>>
>> Best wishes,
>> Desmond
>>
>>   net/bluetooth/rfcomm/sock.c |  2 ++
>>   net/bluetooth/sco.c         | 26 +++++++++++++++++++++++++-
>>   2 files changed, 27 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
>> index ae6f80730561..d8734abb2df4 100644
>> --- a/net/bluetooth/rfcomm/sock.c
>> +++ b/net/bluetooth/rfcomm/sock.c
>> @@ -974,6 +974,7 @@ int rfcomm_connect_ind(struct rfcomm_session *s, u8 channel, struct rfcomm_dlc *
>>          if (!parent)
>>                  return 0;
>>
>> +       local_bh_disable();
>>          bh_lock_sock(parent);
>>
>>          /* Check for backlog size */
>> @@ -1002,6 +1003,7 @@ int rfcomm_connect_ind(struct rfcomm_session *s, u8 channel, struct rfcomm_dlc *
>>
>>   done:
>>          bh_unlock_sock(parent);
>> +       local_bh_enable();
> 
> Looks like you are touching RFCOMM as well, perhaps you should have it
> split, also how about other sockets like L2CAP and HCI are they
> affected? There seems to be a lot of problem with the likes of
> bh_lock_sock I wonder if going with local_bh_disable is overall a
> better way to handle.
> 

Thanks for the feedback, Luiz. I'll separate the SCO and RFCOMM code 
changes.

I believe other sockets should be fine. From what I see, they use 
lock_sock, which acquires the spin lock via spin_lock_bh under the hood. 
So only code that uses bh_lock_sock/bh_lock_sock_nested are affected.

Also I'm not sure what you meant by going with local_bh_disable? I'm 
probably missing context about Bluetooth protocols, but I think the spin 
locks still have their place to protect concurrent accesses and to make 
it clear about what's being protected.

>>          if (test_bit(BT_SK_DEFER_SETUP, &bt_sk(parent)->flags))
>>                  parent->sk_state_change(parent);
>> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
>> index 3bd41563f118..2548b8f81473 100644
>> --- a/net/bluetooth/sco.c
>> +++ b/net/bluetooth/sco.c
>> @@ -167,16 +167,22 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
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
>> @@ -202,6 +208,7 @@ static int sco_chan_add(struct sco_conn *conn, struct sock *sk,
>>   {
>>          int err = 0;
>>
>> +       local_bh_disable();
>>          sco_conn_lock(conn);
>>          if (conn->sk)
>>                  err = -EBUSY;
>> @@ -209,6 +216,7 @@ static int sco_chan_add(struct sco_conn *conn, struct sock *sk,
>>                  __sco_chan_add(conn, sk, parent);
>>
>>          sco_conn_unlock(conn);
>> +       local_bh_enable();
>>          return err;
>>   }
>>
>> @@ -303,9 +311,11 @@ static void sco_recv_frame(struct sco_conn *conn, struct sk_buff *skb)
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
>> @@ -420,18 +430,25 @@ static void __sco_sock_close(struct sock *sk)
>>                  if (sco_pi(sk)->conn->hcon) {
>>                          sk->sk_state = BT_DISCONN;
>>                          sco_sock_set_timer(sk, SCO_DISCONN_TIMEOUT);
>> +                       local_bh_disable();
>>                          sco_conn_lock(sco_pi(sk)->conn);
>>                          hci_conn_drop(sco_pi(sk)->conn->hcon);
>>                          sco_pi(sk)->conn->hcon = NULL;
>>                          sco_conn_unlock(sco_pi(sk)->conn);
>> -               } else
>> +                       local_bh_enable();
>> +               } else {
>> +                       local_bh_disable();
>>                          sco_chan_del(sk, ECONNRESET);
>> +                       local_bh_enable();
>> +               }
>>                  break;
>>
>>          case BT_CONNECT2:
>>          case BT_CONNECT:
>>          case BT_DISCONN:
>> +               local_bh_disable();
>>                  sco_chan_del(sk, ECONNRESET);
>> +               local_bh_enable();
>>                  break;
>>
>>          default:
>> @@ -1084,21 +1101,26 @@ static void sco_conn_ready(struct sco_conn *conn)
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
>> @@ -1109,6 +1131,7 @@ static void sco_conn_ready(struct sco_conn *conn)
>>                  if (!sk) {
>>                          bh_unlock_sock(parent);
>>                          sco_conn_unlock(conn);
>> +                       local_bh_enable();
>>                          return;
>>                  }
>>
>> @@ -1131,6 +1154,7 @@ static void sco_conn_ready(struct sco_conn *conn)
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

