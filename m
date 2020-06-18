Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B204F1FFE4B
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731255AbgFRWqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:46:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47842 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730004AbgFRWqe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 18:46:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jm3Im-001BWM-87; Fri, 19 Jun 2020 00:46:32 +0200
Date:   Fri, 19 Jun 2020 00:46:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [Patch net] net: change addr_list_lock back to static key
Message-ID: <20200618224632.GE279339@lunn.ch>
References: <20200608215301.26772-1-xiyou.wangcong@gmail.com>
 <CA+h21hr_epEqWukZMQmZ2ecS9Y0yvX9mzR3g3OA39rg_96FfnQ@mail.gmail.com>
 <CAM_iQpW-5WpaSvSmJgoqEbcjtrjvaZY3ngKzVy2S-v81MdK4iQ@mail.gmail.com>
 <CAM_iQpUBuk1D4JYZtPQ_yodkLJwAyExvGG5vSOazed2QN7NESw@mail.gmail.com>
 <CA+h21hpjsth_1t1ZaBcTd1i3RPXZGqzSyegSSPS2Ns=uq5-HJw@mail.gmail.com>
 <20200618222959.GC279339@lunn.ch>
 <CA+h21hrZM8Dqi7AYPkKgsAm5-q=TxEdTaci=Tq35VfoOxt_5rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrZM8Dqi7AYPkKgsAm5-q=TxEdTaci=Tq35VfoOxt_5rw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Vladimir
> >
> > So you are suggesting this?
> >
> > > > +       ret = netdev_upper_dev_link(master, slave_dev, NULL);
> >
> >   Andrew
> 
> Yes, basically this:
> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 4c7f086a047b..6aff8cfc9cf1 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1807,6 +1807,13 @@ int dsa_slave_create(struct dsa_port *port)
>                            ret, slave_dev->name);
>                 goto out_phy;
>         }
> +       rtnl_lock();
> +       ret = netdev_upper_dev_link(master, slave_dev, NULL);
> +       rtnl_unlock();
> +       if (ret) {
> +               unregister_netdevice(slave_dev);
> +               goto out_phy;
> +       }
> 
>         return 0;
> 
> @@ -1826,12 +1833,14 @@ int dsa_slave_create(struct dsa_port *port)
> 
>  void dsa_slave_destroy(struct net_device *slave_dev)
>  {
> +       struct net_device *master = dsa_slave_to_master(slave_dev);
>         struct dsa_port *dp = dsa_slave_to_port(slave_dev);
>         struct dsa_slave_priv *p = netdev_priv(slave_dev);
> 
>         netif_carrier_off(slave_dev);
>         rtnl_lock();
>         phylink_disconnect_phy(dp->pl);
> +       netdev_upper_dev_unlink(master, slave_dev);
>         rtnl_unlock();
> 
>         dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
> 
> Do you see a problem with it?

I was initially not sure you could do this. But it looks like you can
have N : M relationships between uppers and lowers. I suppose it does
make sense. You can have multiple VLAN uppers to one base device. You
can have multiple lowers to one bond device, etc.

I wonder what 'side effects' there are for declaring this linkage. It
is not something i've looked into before, since we never used it. So i
don't see a problem with this, other than i don't know what problems
we might run into :-)

  Andrew

