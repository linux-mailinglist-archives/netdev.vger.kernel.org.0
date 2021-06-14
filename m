Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1653A6FCB
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbhFNUHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232975AbhFNUHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 16:07:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 666ED61166;
        Mon, 14 Jun 2021 20:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623701131;
        bh=hw3pXp8L6nXoLCiB1hwrUS/AhM4YDNuHD7qDIxPdZ14=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YvtHBIb1o/4XJ4OW2EUpNu3eyJ0Ato59yPaEIqYHnML6J5waEoStqGfrW7QpC3rn9
         58JYa3QLSjBHrCD4UzoRrp1lDC24vXrwFM8SInCmD0/nVvEBj7gXwquHyny+s5NLHC
         0k+x9uzuiIofut6gf995W7KhBdHjZM+fbFjg9M61/RWKPNdM53QovSFIr/s1DB5/PO
         Ye3v1Fi9oiLNyd9iRHR/xZdsWWXbtU5Z4H7CnPDtjHaIpw+QkDauwHoNCu94+k3HD/
         6+g7U4Q+4+/gLMCbA3HGKPcKFLIxp066oyyUBJvIFYSovb2rwjhloDStxYxl2nDkJb
         x3QxZwdUlpdYw==
Date:   Mon, 14 Jun 2021 13:05:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Kristian Evensen <kristian.evensen@gmail.com>
Cc:     netdev@vger.kernel.org, subashab@codeaurora.org
Subject: Re: [PATCH net] qmi_wwan: Clone the skb when in pass-through mode
Message-ID: <20210614130530.7a422f27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8735tky064.fsf@miraculix.mork.no>
References: <20210614141849.3587683-1-kristian.evensen@gmail.com>
        <8735tky064.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Jun 2021 16:45:55 +0200 Bj=C3=B8rn Mork wrote:
> Kristian Evensen <kristian.evensen@gmail.com> writes:
>=20
> > The skb that we pass to the rmnet driver is owned by usbnet and is freed
> > soon after the rx_fixup() callback is called (in usbnet_bh()).  There is
> > no guarantee that rmnet is done handling the skb before it is freed. We
> > should clone the skb before we call netif_rx() to prevent use-after-free
> > and misc. kernel oops.
> >
> > Fixes: 59e139cf0b32 ("net: qmi_wwan: Add pass through mode")
> >
> > Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
> > ---
> >  drivers/net/usb/qmi_wwan.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> > index db8d3a4f2678..5ac307eb0bfd 100644
> > --- a/drivers/net/usb/qmi_wwan.c
> > +++ b/drivers/net/usb/qmi_wwan.c
> > @@ -620,6 +620,10 @@ static int qmi_wwan_rx_fixup(struct usbnet *dev, s=
truct sk_buff *skb)
> >  		return qmimux_rx_fixup(dev, skb);
> > =20
> >  	if (info->flags & QMI_WWAN_FLAG_PASS_THROUGH) {
> > +		skb =3D skb_clone(skb, GFP_ATOMIC);
> > +		if (!skb)
> > +			return 0;
> > +
> >  		skb->protocol =3D htons(ETH_P_MAP);
> >  		return (netif_rx(skb) =3D=3D NET_RX_SUCCESS);
> >  	} =20
>=20
> Thanks for pointing this out.  But it still looks strange to me.  Why do
> we call netif_rx(skb) here instead of just returning 1 and leave that
> for usbnet_skb_return()?  With cloning we end up doing eth_type_trans()
> on the duplicate - is that wise?

Agreed on the cloning being a strange solution. Kristian, were you able
to reproduce the problem on upstream kernels?

It does look pretty strange that qmimux_rx_fixup() copies out all
packets and receives them, and then let's usbnet to process the
multi-frame skb without even fulling off the qmimux_hdr. I'm probably
missing something.. otherwise sth like FLAG_MULTI_PACKET may be in
order?
