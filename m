Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B8A6D08EB
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 16:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbjC3O6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 10:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbjC3O6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 10:58:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A82C640
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 07:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680188165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MsQjq4T0ikj5DDewAKRcWSFbq4or1fsotiPNscWvc+I=;
        b=TQ6h4BQsxsYcOXBbjDAdznELIYnH7mSY3DiTGatrclUC8p1pBLzM6HtwMEDuAGnxP6bwki
        Z5dXK1hYryNmWRkbT3e8pvvW8afm8xwaNkl45MVBSxcb9Y2ZeHSwFbQsdI3u/lm+HAksvC
        gn5LZYeDg8SVLUWNZ9wRQHyAYQJopco=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-O8LUIDNNNdi7YGuqtMqRQQ-1; Thu, 30 Mar 2023 10:56:04 -0400
X-MC-Unique: O8LUIDNNNdi7YGuqtMqRQQ-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-5aae34d87f7so12895546d6.0
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 07:56:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680188164;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MsQjq4T0ikj5DDewAKRcWSFbq4or1fsotiPNscWvc+I=;
        b=WZj6KCvv0YTf3D9wV41SVf5CSp6XlJl+3LfXNr/MdxHZL4Te2HXC4eDgtLENsWHklF
         qnkOc0I+dNHEawMUAsk4584nEJ1ye12CkwxHXIpzyT1Dqoo5eFB6GCCrCFI9FUImdQ5I
         wHMQ9Udr9x3x9iPO/Bhow7Y+z2o+hasMbYQddUs7LnOf5uTO8WZFUBMs9vy63RwrOs17
         2QCcj8p+PkLz5ywFgiU+7kNLo/TjLDKHwYcZzNhXOeawpfB+CG9Ww5kQyEZULNjea51I
         zYrDuTuoXMrpIffzRSCsWIw53kvbWJAB2Xn9l4Tq1AAh2rMgBm4u3OMCq7geAIUl5RoJ
         Sp0A==
X-Gm-Message-State: AAQBX9fNmyNghpaM89Sm5yuk6V33SxAzJnvHSaQ9N6p3bXwf87pYOS21
        HCyencXyYI2e0cKRpnz9GBQSr7dnwJZhdCxy+CtHki4i5/HFiN6NYbBJGlDtIdYOif8TAyyq2tC
        e7d22u3q/k+jjnXX7
X-Received: by 2002:a05:6214:d0c:b0:5df:a693:39e with SMTP id 12-20020a0562140d0c00b005dfa693039emr3183403qvh.5.1680188163929;
        Thu, 30 Mar 2023 07:56:03 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zo8sCMFX4jfW6F4L1DSOekci4F2aU/alZBqvCLCCyfqTIsDjBNjenzzMc7AD5LqyBz+uDqsg==
X-Received: by 2002:a05:6214:d0c:b0:5df:a693:39e with SMTP id 12-20020a0562140d0c00b005dfa693039emr3183379qvh.5.1680188163629;
        Thu, 30 Mar 2023 07:56:03 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-228-125.dyn.eolo.it. [146.241.228.125])
        by smtp.gmail.com with ESMTPSA id d140-20020a376892000000b007467a4d8691sm15667413qkc.47.2023.03.30.07.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:56:02 -0700 (PDT)
Message-ID: <c5b2f71718e6431ce4bc61ffde3ee16d7b5da260.camel@redhat.com>
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        willemb@google.com
Date:   Thu, 30 Mar 2023 16:56:00 +0200
In-Reply-To: <20230328175601.76574704@kernel.org>
References: <20230322233028.269410-1-kuba@kernel.org>
         <5060c11df10c66f56b5ca7ec2ec92333252b084b.camel@gmail.com>
         <20230323200932.7cf30af5@kernel.org>
         <CAKgT0Ufv5Te668Y_tszQfuH0g_Zsn=oErQ8gAfX6FwHRUm+H3A@mail.gmail.com>
         <20230324142820.61e4f0b6@kernel.org>
         <CAKgT0Ufoy2WM3=aMNOdq2PFYL8AH9QSs=QrP_Xx59uouTnKLJg@mail.gmail.com>
         <20230328175601.76574704@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 2023-03-28 at 17:56 -0700, Jakub Kicinski wrote:
> On Sun, 26 Mar 2023 14:23:07 -0700 Alexander Duyck wrote:
> > > > Except this isn't "stop", this is "maybe stop". =20
> > >=20
> > > So the return value from try_stop and maybe_stop would be different?
> > > try_stop needs to return 0 if it stopped - the same semantics as
> > > trylock(), AFAIR. Not that I love those semantics, but it's a fairly
> > > strong precedent. =20
> >=20
> > The problem is this isn't a lock. Ideally with this we aren't taking
> > the action. So if anything this functions in my mind more like the
> > inverse where if this does stop we have to abort more like trylock
> > failing.
>=20
> No.. for try_stop we are trying to stop.
>=20
> > This is why I mentioned that maybe this should be renamed. I view this
> > more as a check to verify we are good to proceed. In addition there is
> > the problem that there are 3 possible outcomes with maybe_stop versus
> > the two from try_stop.
>=20
> I'm open to other names :S
>=20
> > > > The thing is in order to make this work for the ixgbe patch you did=
n't
> > > > use the maybe_stop instead you went with the try_stop. If you repla=
ced
> > > > the ixgbe_maybe_stop_tx with your maybe stop would have to do
> > > > something such as the code above to make it work. That is what I am
> > > > getting at. From what I can tell the only real difference between
> > > > ixgbe_maybe_stop_tx and your maybe_stop is that you avoided having =
to
> > > > move the restart_queue stat increment out. =20
> > >=20
> > > I can convert ixgbe further, true, but I needed the try_stop, anyway,
> > > because bnxt does:
> > >=20
> > > if (/* need to stop */) {
> > >         if (xmit_more())
> > >                 flush_db_write();
> > >         netif_tx_queue_try_stop();
> > > }
> > >=20
> > > which seems reasonable. =20
> >=20
> > I wasn't saying we didn't need try_stop. However the logic here
> > doesn't care about the return value. In the ixgbe case we track the
> > queue restarts so we would want a 0 on success and a non-zero if we
> > have to increment the stat. I would be okay with the 0 (success) / -1
> > (queue restarted) in this case.
> >=20
> > > > The general thought is I would prefer to keep it so that 0 is the
> > > > default most likely case in both where the queue is enabled and is
> > > > still enabled. By moving the "take action" items into the 1/-1 valu=
es
> > > > then it becomes much easier to sort them out with 1 being a stat
> > > > increment and -1 being an indication to stop transmitting and prep =
for
> > > > watchdog hang if we don't clear this in the next watchdog period. =
=20
> > >=20
> > > Maybe worth taking a step back - the restart stat which ixgbe
> > > maintains made perfect sense when you pioneered this approach but
> > > I think we had a decade of use, and have kprobes now, so we don't
> > > really need to maintain a statistic for a condition with no impact
> > > to the user? New driver should not care 1 vs -1.. =20
> >=20
> > Actually the restart_queue stat is VERY useful for debugging. It tells
> > us we are seeing backlogs develop in the Tx queue. We track it any
> > time we wake up the queue, not just in the maybe_stop case.
> >=20
> > WIthout that we are then having to break out kprobes and the like
> > which we could only add after-the-fact which makes things much harder
> > to debug when issues occur. For example, a common case to use it is to
> > monitor it when we see a system with slow Tx connections. With that
> > stat we can tell if we are building a backlog in the qdisc or if it is
> > something else such as a limited amount of socket memory is limiting
> > the transmits.
>=20
> Oh, I missed that wake uses the same stat. Let me clarify - the
> stop/start counter is definitely useful. What I thought the restart
> counter is counting is just the race cases. I don't think the race
> cases are worth counting in any way.
>=20
> > > > The thought I had with the enum is to more easily connect the outco=
mes
> > > > with the sources. It would also help to prevent any confusion on wh=
at
> > > > is what. Having the two stop/wake functions return different values=
 is
> > > > a potential source for errors since 0/1 means different things in t=
he
> > > > different functions. Basically since we have 3 possible outcomes us=
ing
> > > > the enum would make it very clear what the mapping is between the t=
wo. =20
> > >=20
> > > IMO only two outcomes matter in practice (as mentioned above).
> > > I really like the ability to treat the return value as a bool, if onl=
y
> > > we had negative zero we would have a perfect compromise :( =20
> >=20
> > I think we are just thinking about two different things. I am focusing
> > on the "maybe" calls that have 3 outcomes whereas I think you are
> > mostly focused on the "try" calls. My thought is to treat it something
> > like the msix allocation calls where a negative indicates a failure
> > forcing us to stop since the ring is full, 0 is a success, and a value
> > indicates that there are resources but they are/were limited.
>=20
> I don't see a strong analogy to PCI resource allocation :(
>=20
> I prefer to keep the 0 vs non-0 distinction to indicate whether=20
> the action was performed.
>=20
> Paolo, Eric, any opinion? Other than the one likely vs unlikely
> flip -- is this good enough to merge for you?

As you know I'm usually horrible at name related choice, but you asked,
so...

I'm personally ok with the current naming, and AFAICS the coding style
guidelines suggest returning 0 when imperative functions complete
successfully.=C2=A0

I think we should apply the guidelines here, even if are talking about
macros.

That means netif_tx_queue_maybe_stop() and netif_tx_queue_try_stop()
should return 0 when the queue is actually stopped.

I'm personally fine with the current implementation.

Cheers,

Paolo

