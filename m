Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423B625E587
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 06:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgIEEgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 00:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgIEEgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 00:36:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9540520E65;
        Sat,  5 Sep 2020 04:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599280584;
        bh=+aFBoeHCudO0pNTg+cLcvqXBEd6U5H7kOIhSWlzUzN4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aCp1FC7ns4LjzywFifTtqdN8gMlapuGNPqqnW9C9E++PI+rDsOAyMx0nTUOgosKlr
         Oamfis3EDDzlfaB1PscjYT+keUpZt4O2Ky0vxtDkWxTbIeUJyGQB5i0jBrKPzf6adz
         xdmxP4rxPCkJJZ59IM9wEoK4UMFk4kAQKFjvtJo4=
Date:   Fri, 4 Sep 2020 21:36:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Krzysztof Halasa <khc@pm.waw.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net v2] drivers/net/wan/hdlc_fr: Add needed_headroom for
 PVC devices
Message-ID: <20200904213621.05dd6462@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJht_ENKyfMm7wAxcVSThEG63oVe72FvMs-5VaLWemKvveY+dQ@mail.gmail.com>
References: <20200903000658.89944-1-xie.he.0141@gmail.com>
        <20200904151441.27c97d80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJht_EN+=WTuduvm43_Lq=XWL78AcF5q6Zoyg8S5fao_udL=+Q@mail.gmail.com>
        <CAJht_ENKyfMm7wAxcVSThEG63oVe72FvMs-5VaLWemKvveY+dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Sep 2020 18:57:27 -0700 Xie He wrote:
> On Fri, Sep 4, 2020 at 6:28 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > The HDLC device is not actually prepending any header when it is used
> > with this driver. When the PVC device has prepended its header and
> > handed over the skb to the HDLC device, the HDLC device just hands it
> > over to the hardware driver for transmission without prepending any
> > header.
> >
> > If we grep "header_ops" and "skb_push" in "hdlc.c" and "hdlc_fr.c", we
> > can see there is no "header_ops" implemented in these two files and
> > all "skb_push" happen in the PVC device in hdlc_fr.c.  
> 
> I want to provide a little more information about the flow after an
> HDLC device's ndo_start_xmit is called.
> 
> An HDLC hardware driver's ndo_start_xmit is required to point to
> hdlc_start_xmit in hdlc.c. When a HDLC device receives a call to its
> ndo_start_xmit, hdlc_start_xmit will check if the protocol driver has
> provided a xmit function. If it has provided this function,
> hdlc_start_xmit will call it to start transmission. If it has not,
> hdlc_start_xmit will directly call the hardware driver's function to
> start transmission. This driver (hdlc_fr) has not provided a xmit
> function in its hdlc_proto struct, so hdlc_start_xmit will directly
> call the hardware driver's function to transmit.
> 
> So no header will be prepended after ndo_start_xmit is called.
> 
> There would not be any header prepended before ndo_start_xmit is
> called, either, because there is no header_ops implemented in either
> hdlc.c or hdlc_fr.c.

Thank you for the detailed explanation.

> On Fri, Sep 4, 2020 at 6:28 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > Thank you for your email, Jakub!
> >
> > On Fri, Sep 4, 2020 at 3:14 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> > >
> > > Since this is a tunnel protocol on top of HDLC interfaces, and
> > > hdlc_setup_dev() sets dev->hard_header_len = 16; should we actually
> > > set the needed_headroom to 10 + 16 = 26? I'm not clear on where/if
> > > hdlc devices actually prepend 16 bytes of header, though.  
> >
> > The HDLC device is not actually prepending any header when it is used
> > with this driver. When the PVC device has prepended its header and
> > handed over the skb to the HDLC device, the HDLC device just hands it
> > over to the hardware driver for transmission without prepending any
> > header.
> >
> > If we grep "header_ops" and "skb_push" in "hdlc.c" and "hdlc_fr.c", we
> > can see there is no "header_ops" implemented in these two files and
> > all "skb_push" happen in the PVC device in hdlc_fr.c.
> >
> > For this reason, I have previously submitted a patch to change the
> > value of hard_header_len of the HDLC device from 16 to 0, because it
> > is not actually used.
> >
> > See:
> > 2b7bcd967a0f (drivers/net/wan/hdlc: Change the default of hard_header_len to 0)

Ah, sorry.. the tree I was looking at did not have this commit.

> > > > diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
> > > > index 9acad651ea1f..12b35404cd8e 100644
> > > > --- a/drivers/net/wan/hdlc_fr.c
> > > > +++ b/drivers/net/wan/hdlc_fr.c
> > > > @@ -1041,7 +1041,7 @@ static void pvc_setup(struct net_device *dev)
> > > >  {
> > > >       dev->type = ARPHRD_DLCI;
> > > >       dev->flags = IFF_POINTOPOINT;
> > > > -     dev->hard_header_len = 10;
> > > > +     dev->hard_header_len = 0;  
> > >
> > > Is there a need to set this to 0? Will it not be zero after allocation?  
> >
> > Oh. I understand your point. Theoretically we don't need to set it to
> > 0 because it already has the default value of 0. I'm setting it to 0
> > only because I want to tell future developers that this value is
> > intentionally set to 0, and it is not carelessly missed out.  

Sounds fair.

Applied to net, thank you!
