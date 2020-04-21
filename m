Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B3B1B27CA
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 15:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbgDUN1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 09:27:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53860 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgDUN1h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 09:27:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BAwqzBbAoY3Q7WUm7rKW8PArz02f/a05BHX0yBvFBGA=; b=kjkGTa313jGFL7AFCrKIMMNFWv
        5pPSWqCkUvv4GsmN/1oLNjld29lXro0yTXjTVkY7Nv9wopJzKLRpWCGbsWY2vvnDM5Hy7QpYrchHq
        BeDbQTNYSP5urAw3xZKhC1psF5qKZKn0K9iRU2jHDATrM6i7Ab05ROCsE8N2rWtq3Egw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQsw0-0041o2-US; Tue, 21 Apr 2020 15:27:32 +0200
Date:   Tue, 21 Apr 2020 15:27:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>, mkl@pengutronix.de,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        David Jander <david@protonic.nl>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: dsa: sja1105: regression after patch: "net: dsa: configure the
 MTU for switch ports"
Message-ID: <20200421132732.GC937199@lunn.ch>
References: <20200421113324.vxh2lyasylf5kgkz@pengutronix.de>
 <CA+h21ho2YnUfzMja1Y7=B7Yrqk=WD6jm-OoKKzX4uS3WJiU5aw@mail.gmail.com>
 <20200421125828.jb44qzfzgd7sh436@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421125828.jb44qzfzgd7sh436@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The code which is causing problems seems to be this one:
> > 
> >     mtu_limit = min_t(int, master->max_mtu, dev->max_mtu);
> >     old_master_mtu = master->mtu;
> >     new_master_mtu = largest_mtu + cpu_dp->tag_ops->overhead;
> >     if (new_master_mtu > mtu_limit)
> >         return -ERANGE;
> > 
> > called from
> > 
> >     rtnl_lock();
> >     ret = dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
> >     rtnl_unlock();
> >     if (ret && ret != -EOPNOTSUPP) {
> >         dev_err(ds->dev, "error %d setting MTU on port %d\n",
> >             ret, port->index);
> >         goto out_free;
> >     }
> > 
> > Before this patch, it was silently failing, now it's preventing the
> > probing of the ports which I might agree with you is not better.
> > Andrew warned about this, and I guess that during probe, we should
> > warn but ignore any nonzero return code, not just EOPNOTSUPP. I'll
> > send a patch out shortly to correct this.
> > 
> > Out of curiosity, what DSA master port do you have? Does it not
> > support an MTU of 1504 bytes? Does MTU-sized traffic pass correctly
> > through your interface? (you can test with iperf3)
> 
> It is FEC@iMX6QP attached to the port 4 of the sja1105 switch.
> I'll try to make some tests tomorrow.

Ah, interesting. I've been testing recently on a Vybrid, so also
FEC. I had the warning, but it kept going.

I don't particularly like this warning in this case. We have hardware
which happy works, but is now issuing a warning on boot. I would
prefer if it warned when only trying to configure an MTU bigger than
the minimum needed for DSA, i.e. only the jumbo use case.

    Andrew
