Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7816D15B5
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 04:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjCaClh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 22:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCaClg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 22:41:36 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3505ECDD1
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 19:41:35 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id k17so9184335iob.1
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 19:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680230494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wBugf6YzodknGpxz11pNL11NOlfzplM7dk4+DFK9t9U=;
        b=AGCZ5OeDKqVCc50sprnY5R+vS74CQsHvAEkRpz3zDBOAaAFEKn3n6UMao6Jb5vFW8x
         alxVh9Y8STTWzUEeIzEpBa4RDCpbwUPBMfk7e9TqtPlo6/D0Xl42BW4/VkvRuo7mJai5
         u2jG9+cNO7udkcNm8Jlwr/7lbOyvnpDtvAQmXmsjK52g+APLDDTj8U4nimIPtg19HwJN
         FMpJ+fY5naVDOsjqK1Rley/maVqeGifTp56TON3z7SL0B5N38hyQ07FJZndbKfF6yTn+
         4GolwsNBDL82CCuqh7ooD4C1OekDyzvu7Jlu4lPE929H4OkPcLo10Ik7KqxAebgQYXcC
         dvkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680230494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wBugf6YzodknGpxz11pNL11NOlfzplM7dk4+DFK9t9U=;
        b=rvveG53PRMwYFrWqLm7q2hL0PwbS5KM7MoDzvp3SimmhpVb5/7HN+2yHBWJHoijdhn
         Yowe1EwdU+sNxmc32XL73+8tKHls2WWBx5pkx7MWN1yAzwHKDhIv+dgXXg/bJmj/bu1g
         bvBKvgNAVukI4OBQbafUrLTxLEkymzVPbvZY3uRPeN39mhuBDf+V2mRLB8Y1o7RMtdQg
         75Ai6pPrfzkxvZ+7k43Q94SEQfNhEB5Ooy9Qj2WalFUARJi5Om+a4n8ULWAFpkHKAzC1
         BG45DpPas2u1eD+Y9uMzFUv7psewoviGIj7G2dkSEyd828EzeDgPVsxZBUOgGCaNzADU
         cl2g==
X-Gm-Message-State: AO0yUKXnoOrAGUxZeqhWNSYo7Z/oqFi835Qzza7l1zwVMfypsz2Xymee
        IE9xe8n7l3JQNsFhp9A5PS0cIAEQJpFGAIFA7Vl6gA==
X-Google-Smtp-Source: AK7set/beVMLGzHqHEIOfVyVaXLBQRomxX8Qk8QrrRFUnDsZjWxpJxMiz3bBVtD+/LqbW/JO1u1Hxfi5skcVz0m+Rlg=
X-Received: by 2002:a02:a189:0:b0:3c5:14cb:a83a with SMTP id
 n9-20020a02a189000000b003c514cba83amr10007515jah.2.1680230494378; Thu, 30 Mar
 2023 19:41:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230331022144.2998493-1-kuba@kernel.org>
In-Reply-To: <20230331022144.2998493-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 31 Mar 2023 04:41:23 +0200
Message-ID: <CANn89iL99-uzrktK=hKLrmoWhhqCnH5rNUC9K4W9cOs+CQrbdA@mail.gmail.com>
Subject: Re: [PATCH net] net: don't let netpoll invoke NAPI if in xmit context
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        Roman Gushchin <roman.gushchin@linux.dev>, leitao@debian.org,
        shemminger@linux.foundation.org
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

On Fri, Mar 31, 2023 at 4:23=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> Commit 0db3dc73f7a3 ("[NETPOLL]: tx lock deadlock fix") narrowed
> down the region under netif_tx_trylock() inside netpoll_send_skb().
> (At that point in time netif_tx_trylock() would lock all queues of
> the device.) Taking the tx lock was problematic because driver's
> cleanup method may take the same lock. So the change made us hold
> the xmit lock only around xmit, and expected the driver to take
> care of locking within ->ndo_poll_controller().
>
> Unfortunately this only works if netpoll isn't itself called with
> the xmit lock already held. Netpoll code is careful and uses
> trylock(). The drivers, however, may be using plain lock().
> Printing while holding the xmit lock is going to result in rare
> deadlocks.
>
> Luckily we record the xmit lock owners, so we can scan all the queues,
> the same way we scan NAPI owners. If any of the xmit locks is held
> by the local CPU we better not attempt any polling.
>
> It would be nice if we could narrow down the check to only the NAPIs
> and the queue we're trying to use. I don't see a way to do that now.
>
> Reported-by: Roman Gushchin <roman.gushchin@linux.dev>
> Fixes: 0db3dc73f7a3 ("[NETPOLL]: tx lock deadlock fix")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: leitao@debian.org
> CC: shemminger@linux.foundation.org
> ---
>  net/core/netpoll.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/netpoll.c b/net/core/netpoll.c
> index a089b704b986..e6a739b1afa9 100644
> --- a/net/core/netpoll.c
> +++ b/net/core/netpoll.c
> @@ -137,6 +137,20 @@ static void queue_process(struct work_struct *work)
>         }
>  }
>
> +static int netif_local_xmit_active(struct net_device *dev)
> +{
> +       int i;
> +
> +       for (i =3D 0; i < dev->num_tx_queues; i++) {
> +               struct netdev_queue *txq =3D netdev_get_tx_queue(dev, i);
> +
> +               if (READ_ONCE(txq->xmit_lock_owner) =3D=3D smp_processor_=
id())
> +                       return 1;
> +       }
> +

Resend in plain text mode for the list, sorry for duplicate

Note that we update WRITE_ONCE(txq->xmit_lock_owner, cpu) _after_
spin_lock(&txq->_xmit_lock);

So there is a tiny window I think, for missing that we got the
spinlock, but I do not see how to avoid it without excessive cost.


> +       return 0;
> +}
> +
>  static void poll_one_napi(struct napi_struct *napi)
>  {
>         int work;
> @@ -183,7 +197,10 @@ void netpoll_poll_dev(struct net_device *dev)
>         if (!ni || down_trylock(&ni->dev_lock))
>                 return;
>
> -       if (!netif_running(dev)) {
> +       /* Some drivers will take the same locks in poll and xmit,
> +        * we can't poll if local CPU is already in xmit.
> +        */
> +       if (!netif_running(dev) || netif_local_xmit_active(dev)) {
>                 up(&ni->dev_lock);
>                 return;
>         }
> --
> 2.39.2
>
