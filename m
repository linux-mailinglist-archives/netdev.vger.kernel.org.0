Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766494DE0E5
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 19:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240064AbiCRSVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 14:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240019AbiCRSVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 14:21:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A3C2F24FC
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 11:20:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA96F61AE0
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 18:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097BFC340E8
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 18:19:59 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ihI3irvN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1647627598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4XoXqLC0n0gH9XFa0JScCai+nxfPEhHZbXpkWhLzX60=;
        b=ihI3irvNxGQ5OAE3j5XvLHEH5/ssIYJpxVJExABvxrctRr97Nbtg0mRgKmQtOXHlFjibq1
        ZD6/nj9GnjEd/N6iAghKyMK1zDhklBLsll0VH4JA7/A4gOwxtLDEerxFLOxVdbNo8mifnq
        Ak6G1Z/dnqSRXSa8NYSuZF//KgGubQ4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e309004d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Fri, 18 Mar 2022 18:19:58 +0000 (UTC)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2dbd97f9bfcso99453257b3.9
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 11:19:57 -0700 (PDT)
X-Gm-Message-State: AOAM5308tkSyObCwH4qf14ohio5BoaxAxfzGbROyXWrjvRD+01cdHs3D
        WrC9sLdisDxS8Y+a60orKY+G79yRxYMnRHK8TH0=
X-Google-Smtp-Source: ABdhPJzRXgGWInYLA12zbjZ+ajqZHZ1Xv9E1tv8RkqUVvFmiD5FPMmFbIFCMAiNqg5rsHUMpkCO8GYkjf/kMpvhsNr8=
X-Received: by 2002:a0d:c681:0:b0:2db:9ffe:1f00 with SMTP id
 i123-20020a0dc681000000b002db9ffe1f00mr13339276ywd.100.1647627596353; Fri, 18
 Mar 2022 11:19:56 -0700 (PDT)
MIME-Version: 1.0
References: <YitkzkjU5zng7jAM@linutronix.de> <YjPlAyly8FQhPJjT@zx2c4.com> <YjRlkBYBGEolfzd9@linutronix.de>
In-Reply-To: <YjRlkBYBGEolfzd9@linutronix.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 18 Mar 2022 12:19:45 -0600
X-Gmail-Original-Message-ID: <CAHmME9oHFzL6CYVh8nLGkNKOkMeWi2gmxs_f7S8PATWwc6uQsw@mail.gmail.com>
Message-ID: <CAHmME9oHFzL6CYVh8nLGkNKOkMeWi2gmxs_f7S8PATWwc6uQsw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Add lockdep asserts to ____napi_schedule().
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sebastian,

On Fri, Mar 18, 2022 at 4:57 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> > Hi Sebastian,
> Hi Jason,
>
> > I stumbled upon this commit when noticing a new failure in WireGuard's
> > test suite:
> =E2=80=A6
> > [    1.339289] WARNING: CPU: 0 PID: 11 at ../../../../../../../../net/c=
ore/dev.c:4268 __napi_schedule+0xa1/0x300
> =E2=80=A6
> > [    1.352417]  wg_packet_decrypt_worker+0x2ac/0x470
> =E2=80=A6
> > Sounds like wg_packet_decrypt_worker() might be doing something wrong? =
I
> > vaguely recall a thread where you started looking into some things ther=
e
> > that seemed non-optimal, but I didn't realize there were correctness
> > issues. If your patch is correct, and wg_packet_decrypt_worker() is
> > wrong, do you have a concrete idea of how we should approach fixing
> > wireguard? Or do you want to send a patch for that?
>
> In your case it is "okay" since that ptr_ring_consume_bh() will do BH
> disable/enable which forces the softirq to run. It is not obvious.

In that case, isn't the lockdep assertion you added wrong and should
be reverted? If correct code is hitting it, something seems wrong...

> What
> about the following:
>
> diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/rece=
ive.c
> index 7b8df406c7737..26ffa3afa542e 100644
> --- a/drivers/net/wireguard/receive.c
> +++ b/drivers/net/wireguard/receive.c
> @@ -502,15 +502,21 @@ void wg_packet_decrypt_worker(struct work_struct *w=
ork)
>         struct crypt_queue *queue =3D container_of(work, struct multicore=
_worker,
>                                                  work)->ptr;
>         struct sk_buff *skb;
> +       unsigned int packets =3D 0;
>
> -       while ((skb =3D ptr_ring_consume_bh(&queue->ring)) !=3D NULL) {
> +       local_bh_disable();
> +       while ((skb =3D ptr_ring_consume(&queue->ring)) !=3D NULL) {
>                 enum packet_state state =3D
>                         likely(decrypt_packet(skb, PACKET_CB(skb)->keypai=
r)) ?
>                                 PACKET_STATE_CRYPTED : PACKET_STATE_DEAD;
>                 wg_queue_enqueue_per_peer_rx(skb, state);
> -               if (need_resched())
> +               if (!(++packets % 4)) {
> +                       local_bh_enable();
>                         cond_resched();
> +                       local_bh_disable();
> +               }
>         }
> +       local_bh_enable();
>  }
>
>  static void wg_packet_consume_data(struct wg_device *wg, struct sk_buff =
*skb)
>
> It would decrypt 4 packets in a row and then after local_bh_enable() it
> would invoke wg_packet_rx_poll() (assuming since it is the only napi
> handler in wireguard) and after that it will attempt cond_resched() and
> then continue with the next batch.

I'm willing to consider batching and all sorts of heuristics in there,
though probably for 5.19 rather than 5.18. Indeed there's some
interesting optimization work to be done. But if you want to propose a
change like this, can you send some benchmarks with it, preferably
taken with something like flent so we can see if it negatively affects
latency?

Regards,
Jason
