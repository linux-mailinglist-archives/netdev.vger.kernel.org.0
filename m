Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F863D9CC1
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 06:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhG2E2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 00:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233664AbhG2E2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 00:28:43 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1C1C061757;
        Wed, 28 Jul 2021 21:28:40 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j1so8416425pjv.3;
        Wed, 28 Jul 2021 21:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tW4DIBxR80i4BJo02U0SxUluh+ki4NFjLgvAshr0xxA=;
        b=l4ZOGC66Ljc1csQjbpoEwnSp1sFzgtXS3Q7rjGMrE40E69jSYsY7nVqM3kyc8M3haz
         wLso0RS7wRUStsSKxFjafxATDFQzY72LNDfunK21zfA3FTts1ObmZJr87CuF1j6rrmap
         4iL+U875tmUarppfdGaYq+IHqyvAoxuvzheMyG/mYWxGZzJUz66ge3ZsyNVH48ElmJXW
         +ABYYA4taxaa2yswqwlAB/HajNt/7SHEMoX3BRLHjmrmFx+URDHVTlJul57IbnFZCIIG
         eL2o58qpM0xUCYKns13y75YW2uig+XgY3Q44W/DjhpUyNOc3lN5SmsnF5TqDux2oPiwN
         bM1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tW4DIBxR80i4BJo02U0SxUluh+ki4NFjLgvAshr0xxA=;
        b=sdxU1w5Nz1ehp63o8ifWqRqdYAJjM8RRNxpZD/26baJlHHrX7MKqTjW1dt5km+Lvrp
         wwqWIr3222/QP87+YCXTn3DevKbRpjP/fxF2GVvsPSCUQn73wFAv7BihHnyAxOq28mK+
         4IpdAgT2340dcEp12bjmjkTwcI/ZMYQ1vHwwOpxI6MTe1ipjKQEBMf8FdiuZKUDRx2Q0
         kSxPwTqcEk/6y5utsKtjRIQcdGRjdfXq1KUK43mMjpG2c+r/y76hd0U7ew6xbQtSORYT
         pb+h9N9QKjx2jwFCV9m7u6nZqNifbngLDmd0e0JFKK0lrZbsI08BgH12a2CJEn2gli0K
         Y3ow==
X-Gm-Message-State: AOAM531kZAe2LbO1pa9q4RCPYHh6h8wKQ/0OZCfTDitYM0jbf5tbOIpX
        fIeOD3XWNLS2FeqK3WsZVwI=
X-Google-Smtp-Source: ABdhPJzJrK4273rjTXGt/mNhlac2/bk86XjPDCdBLZ7pWU6F2N22Wczrf2f17PGXudgdoSB7e7iQmg==
X-Received: by 2002:a17:903:2c2:b029:101:9c88:d928 with SMTP id s2-20020a17090302c2b02901019c88d928mr2848193plk.62.1627532920344;
        Wed, 28 Jul 2021 21:28:40 -0700 (PDT)
Received: from [192.168.1.237] ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id b6sm7813162pjl.17.2021.07.28.21.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 21:28:39 -0700 (PDT)
Subject: Re: [PATCH v4] Bluetooth: schedule SCO timeouts with delayed_work
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        skhan@linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
References: <20210728071721.411669-1-desmondcheongzx@gmail.com>
 <CABBYNZ+_mYB=r3B-f0Pu214ZmKVAM2EmpSFYQksTDbdm61Q4Bw@mail.gmail.com>
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Message-ID: <6c152b1f-fe15-6ea3-cb96-1d87f0f7dea7@gmail.com>
Date:   Thu, 29 Jul 2021 12:28:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CABBYNZ+_mYB=r3B-f0Pu214ZmKVAM2EmpSFYQksTDbdm61Q4Bw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

On 29/7/21 7:07 am, Luiz Augusto von Dentz wrote:
> Hi Desmond,
> 
> On Wed, Jul 28, 2021 at 12:17 AM Desmond Cheong Zhi Xi
> <desmondcheongzx@gmail.com> wrote:
>>
>> struct sock.sk_timer should be used as a sock cleanup timer. However,
>> SCO uses it to implement sock timeouts.
>>
>> This causes issues because struct sock.sk_timer's callback is run in
>> an IRQ context, and the timer callback function sco_sock_timeout takes
>> a spin lock on the socket. However, other functions such as
>> sco_conn_del, sco_conn_ready, rfcomm_connect_ind, and
>> bt_accept_enqueue also take the spin lock with interrupts enabled.
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
>> Link: https://syzkaller.appspot.com/bug?id=9089d89de0502e120f234ca0fc8a703f7368b31e [1]
>> Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
>> Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
>> ---
>>
>> Hi,
>>
>> As suggested, this patch addresses the inconsistent lock state while
>> avoiding having to deal with local_bh_disable.
>>
>> Now that sco_sock_timeout is no longer run in IRQ context, it might
>> be the case that bh_lock_sock is no longer needed to sync between
>> SOFTIRQ and user contexts, so we can switch to lock_sock.
>>
>> I'm not too certain about this, or if there's any benefit to using
>> lock_sock instead, so I've left that out of this patch.
>>
>> v3 -> v4:
>> - Switch to using delayed_work to schedule SCO sock timeouts instead
>> of using local_bh_disable. As suggested by Luiz Augusto von Dentz.
>>
>> v2 -> v3:
>> - Split SCO and RFCOMM code changes, as suggested by Luiz Augusto von
>> Dentz.
>> - Simplify local bh disabling in SCO by using local_bh_disable/enable
>> inside sco_chan_del since local_bh_disable/enable pairs are reentrant.
>>
>> v1 -> v2:
>> - Instead of pulling out the clean-up code out from sco_chan_del and
>> using it directly in sco_conn_del, disable local softirqs for relevant
>> sections.
>> - Disable local softirqs more thoroughly for instances of
>> bh_lock_sock/bh_lock_sock_nested in the bluetooth subsystem.
>> Specifically, the calls in af_bluetooth.c and rfcomm/sock.c are now made
>> with local softirqs disabled as well.
>>
>> Best wishes,
>> Desmond
>>
>>   net/bluetooth/sco.c | 39 ++++++++++++++++++++++++---------------
>>   1 file changed, 24 insertions(+), 15 deletions(-)
>>
>> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
>> index 3bd41563f118..b6dd16153d38 100644
>> --- a/net/bluetooth/sco.c
>> +++ b/net/bluetooth/sco.c
>> @@ -48,6 +48,8 @@ struct sco_conn {
>>          spinlock_t      lock;
>>          struct sock     *sk;
>>
>> +       struct delayed_work     sk_timer;
>> +
>>          unsigned int    mtu;
>>   };
>>
>> @@ -74,9 +76,11 @@ struct sco_pinfo {
>>   #define SCO_CONN_TIMEOUT       (HZ * 40)
>>   #define SCO_DISCONN_TIMEOUT    (HZ * 2)
>>
>> -static void sco_sock_timeout(struct timer_list *t)
>> +static void sco_sock_timeout(struct work_struct *work)
>>   {
>> -       struct sock *sk = from_timer(sk, t, sk_timer);
>> +       struct sco_conn *conn = container_of(work, struct sco_conn,
>> +                                            sk_timer.work);
>> +       struct sock *sk = conn->sk;
>>
>>          BT_DBG("sock %p state %d", sk, sk->sk_state);
>>
>> @@ -89,16 +93,18 @@ static void sco_sock_timeout(struct timer_list *t)
>>          sock_put(sk);
>>   }
>>
>> -static void sco_sock_set_timer(struct sock *sk, long timeout)
>> +static void sco_sock_set_timer(struct sock *sk, struct delayed_work *work,
>> +                              long timeout)
>>   {
>>          BT_DBG("sock %p state %d timeout %ld", sk, sk->sk_state, timeout);
>> -       sk_reset_timer(sk, &sk->sk_timer, jiffies + timeout);
>> +       cancel_delayed_work(work);
>> +       schedule_delayed_work(work, timeout);
> 
> I guess if you want to really guarantee cancel takes effect you must
> call cancel_delayed_work_sync
> 

Got it, thanks for catching that.

>>   }
>>
>> -static void sco_sock_clear_timer(struct sock *sk)
>> +static void sco_sock_clear_timer(struct sock *sk, struct delayed_work *work)
>>   {
>>          BT_DBG("sock %p state %d", sk, sk->sk_state);
>> -       sk_stop_timer(sk, &sk->sk_timer);
>> +       cancel_delayed_work(work);
>>   }
>>
>>   /* ---- SCO connections ---- */
>> @@ -174,7 +180,7 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
>>          if (sk) {
>>                  sock_hold(sk);
>>                  bh_lock_sock(sk);
>> -               sco_sock_clear_timer(sk);
>> +               sco_sock_clear_timer(sk, &conn->sk_timer);
>>                  sco_chan_del(sk, err);
>>                  bh_unlock_sock(sk);
>>                  sco_sock_kill(sk);
>> @@ -193,6 +199,8 @@ static void __sco_chan_add(struct sco_conn *conn, struct sock *sk,
>>          sco_pi(sk)->conn = conn;
>>          conn->sk = sk;
>>
>> +       INIT_DELAYED_WORK(&conn->sk_timer, sco_sock_timeout);
>> +
>>          if (parent)
>>                  bt_accept_enqueue(parent, sk, true);
>>   }
>> @@ -260,11 +268,11 @@ static int sco_connect(struct sock *sk)
>>                  goto done;
>>
>>          if (hcon->state == BT_CONNECTED) {
>> -               sco_sock_clear_timer(sk);
>> +               sco_sock_clear_timer(sk, &conn->sk_timer);
>>                  sk->sk_state = BT_CONNECTED;
>>          } else {
>>                  sk->sk_state = BT_CONNECT;
>> -               sco_sock_set_timer(sk, sk->sk_sndtimeo);
>> +               sco_sock_set_timer(sk, &conn->sk_timer, sk->sk_sndtimeo);
>>          }
>>
>>   done:
>> @@ -419,7 +427,8 @@ static void __sco_sock_close(struct sock *sk)
>>          case BT_CONFIG:
>>                  if (sco_pi(sk)->conn->hcon) {
>>                          sk->sk_state = BT_DISCONN;
>> -                       sco_sock_set_timer(sk, SCO_DISCONN_TIMEOUT);
>> +                       sco_sock_set_timer(sk, &sco_pi(sk)->conn->sk_timer,
>> +                                          SCO_DISCONN_TIMEOUT);
>>                          sco_conn_lock(sco_pi(sk)->conn);
>>                          hci_conn_drop(sco_pi(sk)->conn->hcon);
>>                          sco_pi(sk)->conn->hcon = NULL;
>> @@ -443,7 +452,8 @@ static void __sco_sock_close(struct sock *sk)
>>   /* Must be called on unlocked socket. */
>>   static void sco_sock_close(struct sock *sk)
>>   {
>> -       sco_sock_clear_timer(sk);
>> +       if (sco_pi(sk)->conn)
>> +               sco_sock_clear_timer(sk, &sco_pi(sk)->conn->sk_timer);
>>          lock_sock(sk);
>>          __sco_sock_close(sk);
>>          release_sock(sk);
>> @@ -500,8 +510,6 @@ static struct sock *sco_sock_alloc(struct net *net, struct socket *sock,
>>
>>          sco_pi(sk)->setting = BT_VOICE_CVSD_16BIT;
>>
>> -       timer_setup(&sk->sk_timer, sco_sock_timeout, 0);
>> -
>>          bt_sock_link(&sco_sk_list, sk);
>>          return sk;
>>   }
>> @@ -1036,7 +1044,8 @@ static int sco_sock_shutdown(struct socket *sock, int how)
>>
>>          if (!sk->sk_shutdown) {
>>                  sk->sk_shutdown = SHUTDOWN_MASK;
>> -               sco_sock_clear_timer(sk);
>> +               if (sco_pi(sk)->conn)
>> +                       sco_sock_clear_timer(sk, &sco_pi(sk)->conn->sk_timer);
> 
> It probably makes it simpler if we can have the check for
> sco_pi(sk)->conn inside sco_sock_{clear,set}_timer, that way we don't
> need to keep checking like in the code above.
> 

Makes sense, I'll make the change.

Re: testing, this patch passes some local tests I set up to trigger the 
lockdep warning, but I'll run the updated patch through Syzbot again to 
double-check.

Best wishes,
Desmond

>>                  __sco_sock_close(sk);
>>
>>                  if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
>> @@ -1083,7 +1092,7 @@ static void sco_conn_ready(struct sco_conn *conn)
>>          BT_DBG("conn %p", conn);
>>
>>          if (sk) {
>> -               sco_sock_clear_timer(sk);
>> +               sco_sock_clear_timer(sk, &conn->sk_timer);
>>                  bh_lock_sock(sk);
>>                  sk->sk_state = BT_CONNECTED;
>>                  sk->sk_state_change(sk);
>> --
>> 2.25.1
>>
> 
> 

