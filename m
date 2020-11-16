Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B132B52B0
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 21:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733060AbgKPUet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 15:34:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgKPUes (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 15:34:48 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E922D20782;
        Mon, 16 Nov 2020 20:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605558888;
        bh=2ruH7IpyyY7Zc5GxUUT8zaXzNlCfnxxKHpm5NRrSynw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kqPek+cSqfK3KuBCIHEq81ACpLJg6w6ZwX5PicuP8zzv48hPToHufq2oVBUBTBGcs
         uJsrzRpTTOC2eghu+tg4ebGCBOLMuOtSsc4lodEqCKrR+F+1rwT7GwX3cbc/1D+msG
         yynLOcc9kHbxz1jYTpOUnTlVOWBoZd2eCt5piUWQ=
Date:   Mon, 16 Nov 2020 12:34:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Mahesh Bandewar (=?UTF-8?B?4KSu4KS54KWH4KS2IOCkrOCkguCkoeClh+CktQ==?=
        =?UTF-8?B?4KS+4KSw?=) " <maheshb@google.com>,
        Ido Schimmel <idosch@idosch.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be
 controlled
Message-ID: <20201116123447.2be5a827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
        <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 12:02:48 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=
=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=
=A4=B0) wrote:
> > > diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
> > > index a1c77cc00416..76dc92ac65a2 100644
> > > --- a/drivers/net/loopback.c
> > > +++ b/drivers/net/loopback.c
> > > @@ -219,6 +219,13 @@ static __net_init int loopback_net_init(struct n=
et *net)
> > >
> > >       BUG_ON(dev->ifindex !=3D LOOPBACK_IFINDEX);
> > >       net->loopback_dev =3D dev;
> > > +
> > > +     if (sysctl_netdev_loopback_state) {
> > > +             /* Bring loopback device UP */
> > > +             rtnl_lock();
> > > +             dev_open(dev, NULL);
> > > +             rtnl_unlock();
> > > +     } =20
> >
> > The only concern I have here is that it breaks notification ordering.
> > Is there precedent for NETDEV_UP to be generated before all pernet ops =
=20
> > ->init was called? =20
> I'm not sure if any and didn't see any issues in our usage / tests.
> I'm not even sure anyone is watching/monitoring for lo status as such.

Ido, David, how does this sound to you?

I can't think of any particular case where bringing the device up (and
populating it's addresses) before per netns init is finished could be
problematic. But if this is going to make kernel coding harder the
minor convenience of the knob is probably not worth it.
