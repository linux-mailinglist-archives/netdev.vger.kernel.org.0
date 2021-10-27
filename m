Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6522D43CAA7
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 15:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235757AbhJ0NbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 09:31:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233685AbhJ0NbL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 09:31:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3190D60EFF;
        Wed, 27 Oct 2021 13:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635341326;
        bh=9GbPLrURGKA30Cu1Nrz1KLOxmwtKQIFayRiSs3DpaJQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tQRuFqmfoIhxevPCAnSe1btGcgSUkS4YMfz8QR12Kp8DuKBWN2oA601lceDzlv/jF
         3H9J88ay43sbDnf2KQHCtRrJqWBmy/kchsFmKxtgc59PDZ9+4p4Ffs+pc5cd1iUtNi
         gU7/AMziIdncpe9HmYMYdJSFLkhcnyIO9+oEjmV2wk2/33s33z0Bzp2KaPguiYuDC2
         X0zfzBsWhpcSDuidbeLurLLpX7u+4wZEAVnyH/sELKN1Ovi1oVQRH9PWXd0dpbFgtb
         6yMpK0TgmyjP0xHJqNSlBYt2LulzWNASkzKM4rC1sr+bmBqh6stuG3ELApsHrnYKRh
         UN/jEfgHMFBpA==
Date:   Wed, 27 Oct 2021 06:28:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH net-next] net: virtio: use eth_hw_addr_set()
Message-ID: <20211027062845.66a3290f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACGkMEu6ZnyJF2nKS-GURc2Fz8BqUY6OGFEa71fNKPfGA0Wp7g@mail.gmail.com>
References: <20211026175634.3198477-1-kuba@kernel.org>
 <CACGkMEu6ZnyJF2nKS-GURc2Fz8BqUY6OGFEa71fNKPfGA0Wp7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 10:45:18 +0800 Jason Wang wrote:
> On Wed, Oct 27, 2021 at 1:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> > of VLANs...") introduced a rbtree for faster Ethernet address look
> > up. To maintain netdev->dev_addr in this tree we need to make all
> > the writes to it go through appropriate helpers.  
> 
> I think the title should be "net: virtio: use eth_hw_addr_set()"

Sorry about that, will fix.

> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index c501b5974aee..b7f35aff8e82 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -3177,12 +3177,16 @@ static int virtnet_probe(struct virtio_device *vdev)
> >         dev->max_mtu = MAX_MTU;
> >
> >         /* Configuration may specify what MAC to use.  Otherwise random. */
> > -       if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC))
> > +       if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
> > +               u8 addr[MAX_ADDR_LEN];
> > +
> >                 virtio_cread_bytes(vdev,
> >                                    offsetof(struct virtio_net_config, mac),
> > -                                  dev->dev_addr, dev->addr_len);
> > -       else
> > +                                  addr, dev->addr_len);
> > +               dev_addr_set(dev, addr);
> > +       } else {
> >                 eth_hw_addr_random(dev);
> > +       }  
> 
> Do we need to change virtnet_set_mac_address() as well?

It uses eth_commit_mac_addr_change() which DTRT internally.
