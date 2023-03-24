Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2466C877A
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 22:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbjCXV2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 17:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbjCXV2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 17:28:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34390199D7
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 14:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C337862C87
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 21:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD002C433EF;
        Fri, 24 Mar 2023 21:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679693302;
        bh=S8KiTmOusUO32ZC4SQLVHDRPy5Lqng7QsiUwOFt+63k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eZl09do7ujwtEaSU47s+YoK3EPVwwasUeaS08lly2MTk71VW9R5edsmzhWF1VJqjG
         yL/E4H3j3tnaOql9I9v/JyRi/KYd7riRVcwVXhx6CarZQu9124Ao814HChxBJfDg9p
         VZx1b2BL9pi75ONdnkX/iBIxzd0ebz+PyCTOxl+8aLW4cUhSSfmM1ddTJeqE6Lc92H
         gtSpa1neYWh+pMd29G4GDqnBXFe/JhLfJ6AARef0kS4NOmerFtAce3d/dTFmmrTNaY
         7v0MDkPTNL/2AKtpaBgIpt8uxLPUt/ONu29vu+SacBg22vRXBNxskxQVpXzYNdMOjj
         segdQxTyiyCAg==
Date:   Fri, 24 Mar 2023 14:28:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, willemb@google.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230324142820.61e4f0b6@kernel.org>
In-Reply-To: <CAKgT0Ufv5Te668Y_tszQfuH0g_Zsn=oErQ8gAfX6FwHRUm+H3A@mail.gmail.com>
References: <20230322233028.269410-1-kuba@kernel.org>
        <5060c11df10c66f56b5ca7ec2ec92333252b084b.camel@gmail.com>
        <20230323200932.7cf30af5@kernel.org>
        <CAKgT0Ufv5Te668Y_tszQfuH0g_Zsn=oErQ8gAfX6FwHRUm+H3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 08:45:23 -0700 Alexander Duyck wrote:
> On Thu, Mar 23, 2023 at 8:09=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> =
wrote:
> > > We may want to change the values here. The most likely case is "left
> > > enabled" with that being the case we probably want to make that the 0
> > > case. I would then probably make 1 the re-enabled case and -1 the
> > > stopped case. =20
> >
> > I chose the return values this way because the important information is
> > whether the queue was in fact stopped (in case the macro is used at the
> > start of .xmit as a safety check). If stopped is zero caller can check
> > !ret vs !!ret.
> >
> > Seems pretty normal for the kernel function called stop() to return 0
> > if it did stop. =20
>=20
> Except this isn't "stop", this is "maybe stop".

So the return value from try_stop and maybe_stop would be different?
try_stop needs to return 0 if it stopped - the same semantics as
trylock(), AFAIR. Not that I love those semantics, but it's a fairly
strong precedent.

> Maybe we should just
> do away with the stop/wake messaging and go with something such as a
> RTS/CTS type setup. Basically this function is acting as a RTS to
> verify that we have room on the ring to place the frame. If we don't
> we are stopped. The "wake" function is on what is essentially the
> receiving end on the other side of the hardware after it has DMAed the
> frames and is providing the CTS signal back.

I'm definitely open to different naming but wouldn't calling RTS _after_
send be even more confusing than maybe_stop?

> > > With that the decision tree becomes more straightforward as we would =
do
> > > something like:
> > >       if (result) {
> > >               if (result < 0)
> > >                       Increment stopped stat
> > >                       return
> > >               else
> > >                       Increment restarted stat
> > >       } =20
> >
> > Do you see a driver where it matters? ixgbe and co. use
> > netif_tx_queue_try_stop() and again they just test stopped vs not stopp=
ed. =20
>=20
> The thing is in order to make this work for the ixgbe patch you didn't
> use the maybe_stop instead you went with the try_stop. If you replaced
> the ixgbe_maybe_stop_tx with your maybe stop would have to do
> something such as the code above to make it work. That is what I am
> getting at. From what I can tell the only real difference between
> ixgbe_maybe_stop_tx and your maybe_stop is that you avoided having to
> move the restart_queue stat increment out.

I can convert ixgbe further, true, but I needed the try_stop, anyway,
because bnxt does:

if (/* need to stop */) {
	if (xmit_more())
		flush_db_write();
	netif_tx_queue_try_stop();
}

which seems reasonable.

> The general thought is I would prefer to keep it so that 0 is the
> default most likely case in both where the queue is enabled and is
> still enabled. By moving the "take action" items into the 1/-1 values
> then it becomes much easier to sort them out with 1 being a stat
> increment and -1 being an indication to stop transmitting and prep for
> watchdog hang if we don't clear this in the next watchdog period.

Maybe worth taking a step back - the restart stat which ixgbe
maintains made perfect sense when you pioneered this approach but
I think we had a decade of use, and have kprobes now, so we don't
really need to maintain a statistic for a condition with no impact=20
to the user? New driver should not care 1 vs -1..

> Also in general it makes it easier to understand if these all work
> with the same logic.
>=20
> > > In addition for readability we may want consider adding an enum simli=
ar
> > > to the netdev_tx enum as then we have the return types locked and
> > > usable should we want to specifically pick out one. =20
> >
> > Hm, I thought people generally dislike the netdev_tx enum.
> > Maybe it's just me. =20
>=20
> The thought I had with the enum is to more easily connect the outcomes
> with the sources. It would also help to prevent any confusion on what
> is what. Having the two stop/wake functions return different values is
> a potential source for errors since 0/1 means different things in the
> different functions. Basically since we have 3 possible outcomes using
> the enum would make it very clear what the mapping is between the two.

IMO only two outcomes matter in practice (as mentioned above).
I really like the ability to treat the return value as a bool, if only
we had negative zero we would have a perfect compromise :(
