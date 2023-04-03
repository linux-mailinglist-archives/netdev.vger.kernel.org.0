Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A6B6D50FD
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbjDCSuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjDCSuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B6A1BF3;
        Mon,  3 Apr 2023 11:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE4F062806;
        Mon,  3 Apr 2023 18:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255DBC433EF;
        Mon,  3 Apr 2023 18:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680547812;
        bh=XyIFsnMZxWnK7w6s6mNWxOXQhoe1Bgkk/2iMTtIrKvo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N+v71NgeY83lcIXTV1LJMHlfuNrVn+i5s3WfnP36VwskcR3MtdWhkapzo9usd1vvK
         y81qnoe5mgwlLhsRF+mON+8ypqyZ8WbhwRMZRDX0n7GsglVW/Rm9TqCX9ZZYI+xb47
         JdScnjDrd4crZany4O9ydF7SGyW4EFOJ9VzIXOKGtKBS0mmpJ7HNiptISwrdy5OoE8
         TaHFSHiTA2JBZHKvdGG57/DehkFIocazMQ2ONT/oFoXOu+wPxp9cTHQrTfL16iK5up
         MWk/hdXfD+WUUQSA+bFX4qoauggjnmXv6KfaDpxrbdjR2ZJ2mL++FSmxVOx0wh+tRp
         OL8oAqGEJG12Q==
Date:   Mon, 3 Apr 2023 11:50:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix =?UTF-8?B?SMO8dHRuZXI=?= <felix.huettner@mail.schwarz>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luca Czesla <Luca.Czesla@mail.schwarz>
Subject: Re: [PATCH] net: openvswitch: fix race on port output
Message-ID: <20230403115011.0d93298c@kernel.org>
In-Reply-To: <DU0PR10MB52446CAE57724A0B878BAA66EA929@DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM>
References: <DU0PR10MB5244A38E7712028763169A93EA8F9@DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM>
        <20230331212514.7a9ee3d9@kernel.org>
        <DU0PR10MB52446CAE57724A0B878BAA66EA929@DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Apr 2023 11:18:46 +0000 Felix H=C3=BCttner wrote:
> On Sat, 1 Apr 2023 6:25:00 +0000 Jakub Kicinski wrote:
> > On Fri, 31 Mar 2023 06:25:13 +0000 Felix H=C3=BCttner wrote: =20
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 253584777101..6628323b7bea 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -3199,6 +3199,7 @@ static u16 skb_tx_hash(const struct net_device =
*dev,
> > >         }
> > >
> > >         if (skb_rx_queue_recorded(skb)) {
> > > +               BUG_ON(unlikely(qcount =3D=3D 0)); =20
> >
> > DEBUG_NET_WARN_ON()
> > =20
>=20
> However if this condition triggers we will be permanently stuck in the lo=
op below.
> From my understading this also means that future calls to `synchronize_ne=
t` will never finish (as the packet never finishes processing).
> So the user will quite probably need to restart his system.
> I find DEBUG_NET_WARN_ON_ONCE to offer too little visiblity as CONFIG_DEB=
UG_NET is not necessarily enabled per default.
> I as the user would see it as helpful to have this information available =
without additional config flags.
> I would propose to use WARN_ON_ONCE

skb_tx_hash() may get called a lot, we shouldn't slow it down on
production systems just to catch buggy drivers, IMO.
