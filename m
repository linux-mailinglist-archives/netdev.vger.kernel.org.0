Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FB843CA93
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 15:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242134AbhJ0N3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 09:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237085AbhJ0N3H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 09:29:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BCAC610A0;
        Wed, 27 Oct 2021 13:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635341201;
        bh=IUQQE5uqrY0LN+MdX27htdQy7dpcxH5OrQycCL4o7rc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PInmyXL4SWfr+ZRa4Ej3o3j9t/EeZyue7QMwFX1pTAFvBLEEShWyQ2q7r3CljKVr7
         wjw7T/puCEPzMY94ObuSQFo1DA4oRxhDgXBbR38Bubq3nFRF6D9T6R8T3hYCKnAW8X
         NzQHyetDNx9Or6Fqh8omQYrGzeV/Z6DLPo3UONo3ZbowsMVtbDANIaw+QP96qDsBLK
         X0nlerKgBRYb8Gqv3uqHoRFUm4fsu0WC3UcRLUngEK4OWzQM8HuRz5LZr0ITqk6fQh
         gu6KCViczoY83oz/fzdIAaB/IrdWfT5BPbtQ/VTqLtIRm3GEl4K93+WP0ifL6sSTTW
         aOSZ2VJ+V3YYQ==
Date:   Wed, 27 Oct 2021 06:26:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next] net: virtio: use eth_hw_addr_set()
Message-ID: <20211027062640.5d32d7be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211027032113-mutt-send-email-mst@kernel.org>
References: <20211026175634.3198477-1-kuba@kernel.org>
        <20211027032113-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 03:23:17 -0400 Michael S. Tsirkin wrote:
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index c501b5974aee..b7f35aff8e82 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -3177,12 +3177,16 @@ static int virtnet_probe(struct virtio_device *vdev)
> >  	dev->max_mtu = MAX_MTU;
> >  
> >  	/* Configuration may specify what MAC to use.  Otherwise random. */
> > -	if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC))
> > +	if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
> > +		u8 addr[MAX_ADDR_LEN];
> > +
> >  		virtio_cread_bytes(vdev,
> >  				   offsetof(struct virtio_net_config, mac),
> > -				   dev->dev_addr, dev->addr_len);
> > -	else
> > +				   addr, dev->addr_len);  
> 
> Maybe BUG_ON(dev->addr_len > sizeof addr);
> 
> here just to make sure we don't overflow addr silently?

Since I need to post a v2 and we're talking... can I just use
eth_hw_addr_set() instead? AFAICT netdev is always allocated with 
alloc_etherdev_mq() and ->addr_len never changed. Plus there is 
a number of Ethernet address helpers used so ETH_ALEN is kind of 
already assumed.

> > +		dev_addr_set(dev, addr);
> > +	} else {
> >  		eth_hw_addr_random(dev);
> > +	}
> >  
> >  	/* Set up our device-specific information */
> >  	vi = netdev_priv(dev);
