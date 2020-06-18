Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815B61FFE2E
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbgFRWaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:30:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47798 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728950AbgFRWaB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 18:30:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jm32l-001BLh-DA; Fri, 19 Jun 2020 00:29:59 +0200
Date:   Fri, 19 Jun 2020 00:29:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [Patch net] net: change addr_list_lock back to static key
Message-ID: <20200618222959.GC279339@lunn.ch>
References: <20200608215301.26772-1-xiyou.wangcong@gmail.com>
 <CA+h21hr_epEqWukZMQmZ2ecS9Y0yvX9mzR3g3OA39rg_96FfnQ@mail.gmail.com>
 <CAM_iQpW-5WpaSvSmJgoqEbcjtrjvaZY3ngKzVy2S-v81MdK4iQ@mail.gmail.com>
 <CAM_iQpUBuk1D4JYZtPQ_yodkLJwAyExvGG5vSOazed2QN7NESw@mail.gmail.com>
 <CA+h21hpjsth_1t1ZaBcTd1i3RPXZGqzSyegSSPS2Ns=uq5-HJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpjsth_1t1ZaBcTd1i3RPXZGqzSyegSSPS2Ns=uq5-HJw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 11:33:44PM +0300, Vladimir Oltean wrote:
> On Thu, 18 Jun 2020 at 23:06, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Thu, Jun 18, 2020 at 12:56 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Thu, Jun 18, 2020 at 12:40 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > >
> > > > It's me with the stacked DSA devices again:
> > >
> > > It looks like DSA never uses netdev API to link master
> > > device with slave devices? If so, their dev->lower_level
> > > are always 1, therefore triggers this warning.
> > >
> > > I think it should call one of these netdev_upper_dev_link()
> > > API's when creating a slave device.
> > >
> >
> > I don't know whether DSA is too special to use the API, but
> > something like this should work:
> >
> > diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> > index 4c7f086a047b..f7a2a281e7f0 100644
> > --- a/net/dsa/slave.c
> > +++ b/net/dsa/slave.c
> > @@ -1807,6 +1807,11 @@ int dsa_slave_create(struct dsa_port *port)
> >                            ret, slave_dev->name);
> >                 goto out_phy;
> >         }
> > +       ret = netdev_upper_dev_link(slave_dev, master, NULL);
> > +       if (ret) {
> > +               unregister_netdevice(slave_dev);
> > +               goto out_phy;
> > +       }
> >
> >         return 0;
> >
> > @@ -1832,6 +1837,7 @@ void dsa_slave_destroy(struct net_device *slave_dev)
> >         netif_carrier_off(slave_dev);
> >         rtnl_lock();
> >         phylink_disconnect_phy(dp->pl);
> > +       netdev_upper_dev_unlink(slave_dev, dp->master);
> >         rtnl_unlock();
> >
> >         dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
> 
> Thanks. This is a good approximation of what needed to be done:
> - netdev_upper_dev_link needs to be under rtnl,
> - "dp->master" should be "dsa_slave_to_master(slave_dev)" since it's
> actually a union if you look at struct dsa_port).

> - And, most importantly, I think the hierarchy should be reversed: a
> (virtual) DSA switch port net device (slave) should be an upper of the
> (real) DSA master (the host port). Think of it like this: a DSA switch
> is a sort of port multiplier for a host port, based on a frame header.
> But, it works!

Hi Vladimir

So you are suggesting this?

> > +       ret = netdev_upper_dev_link(master, slave_dev, NULL);

  Andrew
