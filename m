Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC156D160F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 05:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjCaDhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 23:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjCaDh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 23:37:29 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADBECA31
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 20:37:27 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id h11so10903861ild.11
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 20:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680233847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cv3DDt2YXYJQ3O9UOkTSWSu6E5S+HFfVIJXGhYVqsvI=;
        b=Rdr0rnrAvrry39V45LQiy/IDVMhDc9OpNDv/229Xz0jatqWTAaOwrrVZB3ToqZp6na
         P0mE1imfk5qziQiJLtADZDhAkdQJhThJQ+gEWDWNiAbwHYjsFDlSfa8H0ul1i+kBpmYc
         DsPbDrc++4hD7hiXKn/WSerQ12En4I12jLJxbyOg54DSrWCIrPO/BXgbwaAe2RT2U8HI
         EfKWau+c9IrgQ4pq3s+tCoYb6u6ilfZhniw6Ij0mS8cAMZ1b0viTygmbSZzWEzu8W3jT
         uk0esVXTFatq+tgFlgpaVKQEa2Ag7/xM8yMH+aub7L+m8ipgkV9PYEUGHWYUNI+iWD8h
         Dx/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680233847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cv3DDt2YXYJQ3O9UOkTSWSu6E5S+HFfVIJXGhYVqsvI=;
        b=Uam3z4Ipl3lmPgtCCg51IRe3UPLQge5tjLU5JQWVdhIREZsoJFO5wjImmvvcOA9BZj
         OSEqmaSvaFd5UK3STje7MQS1f/4qYQw6iIrWGI0yvHUO12J2LnR3r0VCFrubG8ukInoE
         pBFjC07C+9NFdEV6W6IVRwzVB7ELGgYE2hqthAePeAmemQdLcDpWYcBcvb+GV2yoUFXJ
         cNYaUb1c0j/7Ho9zy8m0uINGebLWIqBVUrz/xmCPTSVEv3W//5JZj3RjRNkfV39wvV2Q
         kCD70a+pMyyQ38IWtEvl6bo+RYvdl1/J3O8abj4R8VZvby3HyRTwQVreo+CH0CxmkzVi
         2Y6A==
X-Gm-Message-State: AAQBX9fM3Dm1myQFoZKgNyvn8j1qa0XF9SChZIQfQw6crnDSXBdMuAE1
        YkjH+5Dn45EpMPPqzD33zrahUTsQsb5uIOtoXxujUA==
X-Google-Smtp-Source: AKy350Ywl2FlBm/Gpjbo0uWLwjjTFHvPnUfpCyOxgIIGEFg+mIEj9+tCHAQPna+77WXYc34vIYV2Tn5FMISfhl7/n/M=
X-Received: by 2002:a05:6e02:e43:b0:323:24cc:6345 with SMTP id
 l3-20020a056e020e4300b0032324cc6345mr13042317ilk.2.1680233846707; Thu, 30 Mar
 2023 20:37:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230330192534.2307410-1-edumazet@google.com> <20230330130828.4aa7f911@kernel.org>
In-Reply-To: <20230330130828.4aa7f911@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 31 Mar 2023 05:37:15 +0200
Message-ID: <CANn89i+S0_qL_1Xy6J6Q9D1-vMFSCEUZDQh8f+8C9Q8e5n=rLQ@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: tsq: avoid using a tasklet if possible
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 10:08=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Thu, 30 Mar 2023 19:25:34 +0000 Eric Dumazet wrote:
> > Instead of always defer TCP Small Queue handling to a tasklet
> > we can try to lock the socket and immediately call tcp_tsq_handler()
> >
> > In my experiments on a 100Gbit NIC with FQ qdisc, number of times
> > tcp_tasklet_func() is fired per second goes from ~70,000 to ~1,000.
> >
> > This reduces number of ksoftirqd wakeups and thus extra cpu
> > costs and latencies.
>
> Oh, you posted already. LMK what you think about other locks,
> I reckon we should apply this patch... just maybe around -rc1
> to give ourselves plenty of time to find the broken drivers?

Agreed, this can wait.

I will post a v2 RFC with the additional logic, then I will audit
napi_consume_skb() callers.
(BTW this logic removes one indirect call to tcp_wfree())

Thanks

diff --git a/include/net/tcp.h b/include/net/tcp.h
index a0a91a988272710470cd20f22e02e49476513239..7efdda889b001fdd2cb941e40d1=
318a6b80b78bb
100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -339,6 +339,7 @@ int tcp_send_mss(struct sock *sk, int *size_goal,
int flags);
 void tcp_push(struct sock *sk, int flags, int mss_now, int nonagle,
              int size_goal);
 void tcp_release_cb(struct sock *sk);
+void __tcp_wfree(struct sk_buff *skb, bool trylock);
 void tcp_wfree(struct sk_buff *skb);
 void tcp_write_timer_handler(struct sock *sk);
 void tcp_delack_timer_handler(struct sock *sk);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 050a875d09c5535e0cb2e52c9c65f3febd0385d6..2b09c247721144696a937a928a7=
b8af7f1ad01db
100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1242,6 +1242,9 @@ void napi_skb_free_stolen_head(struct sk_buff *skb)
        napi_skb_cache_put(skb);
 }

+/*
+ * Note: callers must not lock the TX queue.
+ */
 void napi_consume_skb(struct sk_buff *skb, int budget)
 {
        /* Zero budget indicate non-NAPI context called us, like netpoll */
@@ -1260,6 +1263,10 @@ void napi_consume_skb(struct sk_buff *skb, int budge=
t)

        /* if SKB is a clone, don't handle this case */
        if (skb->fclone !=3D SKB_FCLONE_UNAVAILABLE) {
+               if (skb->destructor =3D=3D tcp_wfree) {
+                       __tcp_wfree(skb, true);
+                       skb->destructor =3D NULL;
+               }
                __kfree_skb(skb);
                return;
        }
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 470bb840bb6b6fb457f96d5c00fdfd11b414482f..63ff79f92a2d44c403bd5218508=
75839f18a0c20
100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1139,7 +1139,7 @@ void __init tcp_tasklet_init(void)
  * We can't xmit new skbs from this context, as we might already
  * hold qdisc lock.
  */
-void tcp_wfree(struct sk_buff *skb)
+void __tcp_wfree(struct sk_buff *skb, bool trylock)
 {
        struct sock *sk =3D skb->sk;
        struct tcp_sock *tp =3D tcp_sk(sk);
@@ -1171,7 +1171,7 @@ void tcp_wfree(struct sk_buff *skb)
        } while (!try_cmpxchg(&sk->sk_tsq_flags, &oval, nval));

        /* attempt to grab socket lock. */
-       if (spin_trylock_bh(&sk->sk_lock.slock)) {
+       if (trylock && spin_trylock_bh(&sk->sk_lock.slock)) {
                clear_bit(TSQ_QUEUED, &sk->sk_tsq_flags);
                tcp_tsq_handler_locked(sk);
                spin_unlock_bh(&sk->sk_lock.slock);
@@ -1190,6 +1190,11 @@ void tcp_wfree(struct sk_buff *skb)
        sk_free(sk);
 }

+void tcp_wfree(struct sk_buff *skb)
+{
+       __tcp_wfree(skb, false);
+}
+
 /* Note: Called under soft irq.
  * We can call TCP stack right away, unless socket is owned by user.
  */
