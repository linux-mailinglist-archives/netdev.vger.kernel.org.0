Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32708322611
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 07:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhBWGwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 01:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbhBWGwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 01:52:39 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3E7C06174A
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 22:51:58 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lERXx-0002JM-FV; Tue, 23 Feb 2021 07:51:49 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lERXw-00045Y-Ga; Tue, 23 Feb 2021 07:51:48 +0100
Date:   Tue, 23 Feb 2021 07:51:48 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mkl@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>,
        syzbot+5138c4dd15a0401bec7b@syzkaller.appspotmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] net: introduce CAN specific pointer in the struct
 net_device
Message-ID: <20210223065148.kof3e4ktxawrgykn@pengutronix.de>
References: <20210222150251.12911-1-o.rempel@pengutronix.de>
 <20210222173012.39e82e8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210222173012.39e82e8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:57:04 up 82 days, 20:03, 38 users,  load average: 0.01, 0.04,
 0.04
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, Feb 22, 2021 at 05:30:12PM -0800, Jakub Kicinski wrote:
> On Mon, 22 Feb 2021 16:02:51 +0100 Oleksij Rempel wrote:
> > Since 20dd3850bcf8 ("can: Speed up CAN frame receiption by using
> > ml_priv") the CAN framework uses per device specific data in the AF_CAN
> > protocol. For this purpose the struct net_device->ml_priv is used. Later
> > the ml_priv usage in CAN was extended for other users, one of them being
> > CAN_J1939.
> > 
> > Later in the kernel ml_priv was converted to an union, used by other
> > drivers. E.g. the tun driver started storing it's stats pointer.
> > 
> > Since tun devices can claim to be a CAN device, CAN specific protocols
> > will wrongly interpret this pointer, which will cause system crashes.
> > Mostly this issue is visible in the CAN_J1939 stack.
> > 
> > To fix this issue, we request a dedicated CAN pointer within the
> > net_device struct.
> > 
> > Reported-by: syzbot+5138c4dd15a0401bec7b@syzkaller.appspotmail.com
> > Fixes: 20dd3850bcf8 ("can: Speed up CAN frame receiption by using ml_priv")
> > Fixes: ffd956eef69b ("can: introduce CAN midlayer private and allocate it automatically")
> > Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> > Fixes: 497a5757ce4e ("tun: switch to net core provided statistics counters")
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index ddf4cfc12615..6e25c6f0f190 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -1584,6 +1584,16 @@ enum netdev_priv_flags {
> >  #define IFF_L3MDEV_RX_HANDLER		IFF_L3MDEV_RX_HANDLER
> >  #define IFF_LIVE_RENAME_OK		IFF_LIVE_RENAME_OK
> >  
> > +/**
> > + * enum netdev_ml_priv_type - &struct net_device ml_priv_type
> > + *
> > + * This enum specifies the type of the struct net_device::ml_priv pointer.
> > + */
> 
> kdoc (scripts/kernel-doc -none include/linux/netdevice.h) is not happy
> about the fact enum values are not defined. Perhaps they will be
> sufficiently self-explanatory to not bother documenting?
> 
> Maybe just:
> 
> /* Specifies the type of the struct net_device::ml_priv pointer */
> 
> ?

sounds good, done.

> > +enum netdev_ml_priv_type {
> > +	ML_PRIV_NONE,
> > +	ML_PRIV_CAN,
> > +};
> > +
> >  /**
> >   *	struct net_device - The DEVICE structure.
> >   *
> > @@ -1779,6 +1789,7 @@ enum netdev_priv_flags {
> >   * 	@nd_net:		Network namespace this network device is inside
> >   *
> >   * 	@ml_priv:	Mid-layer private
> > +	@ml_priv_type:  Mid-layer private type
> 
> missing '*' at the start of the line

done

> >   * 	@lstats:	Loopback statistics
> >   * 	@tstats:	Tunnel statistics
> >   * 	@dstats:	Dummy statistics
> > @@ -2094,8 +2105,10 @@ struct net_device {
> >  	possible_net_t			nd_net;
> >  
> >  	/* mid-layer private */
> > +	void				*ml_priv;
> > +	enum netdev_ml_priv_type	ml_priv_type;
> > +
> >  	union {
> > -		void					*ml_priv;
> >  		struct pcpu_lstats __percpu		*lstats;
> >  		struct pcpu_sw_netstats __percpu	*tstats;
> >  		struct pcpu_dstats __percpu		*dstats;
> > @@ -2286,6 +2299,29 @@ static inline void netdev_reset_rx_headroom(struct net_device *dev)
> >  	netdev_set_rx_headroom(dev, -1);
> >  }
> >  
> > +static inline void *netdev_get_ml_priv(struct net_device *dev,
> > +				       enum netdev_ml_priv_type type)
> > +{
> > +	if (dev->ml_priv_type != type)
> > +		return NULL;
> > +
> > +	return dev->ml_priv;
> > +}
> > +
> > +static inline void netdev_set_ml_priv(struct net_device *dev,
> > +				      void *ml_priv,
> > +				      enum netdev_ml_priv_type type)
> > +{
> > +	WARN_ONCE(dev->ml_priv_type && dev->ml_priv_type != type,
> > +		  "Overwriting already set ml_priv_type (%u) with different ml_priv_type (%u)!\n",
> > +		  dev->ml_priv_type, type);
> > +	WARN_ONCE(!dev->ml_priv_type && dev->ml_priv,
> > +		  "Overwriting already set ml_priv and ml_priv_type is ML_PRIV_NONE!\n");
> 
> nit: do we need the _ONCE() this helper should be used on control path
>      and relatively rarely, no?

I have no strong opinion right now. Changed to WARN()

> > +	dev->ml_priv = ml_priv;
> > +	dev->ml_priv_type = type;
> > +}
> > +
> >  /*
> >   * Net namespace inlines
> >   */
> 
> > @@ -454,6 +455,7 @@ static int j1939_sk_bind(struct socket *sock, struct sockaddr *uaddr, int len)
> >  		j1939_local_ecu_put(priv, jsk->addr.src_name, jsk->addr.sa);
> >  	} else {
> >  		struct net_device *ndev;
> > +		struct can_ml_priv *can_ml;
> 
> nit: rev xmas treei

done

> 
> >  
> >  		ndev = dev_get_by_index(net, addr->can_ifindex);
> >  		if (!ndev) {
> 

Thank you,
Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
