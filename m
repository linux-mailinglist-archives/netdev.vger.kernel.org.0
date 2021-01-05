Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7EA2EB575
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 23:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730855AbhAEWjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 17:39:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728893AbhAEWjy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 17:39:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E4E722D6E;
        Tue,  5 Jan 2021 22:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609886353;
        bh=pFezBDqFKZ7qO60emB27Effrm4QyjXMcAEfwl+2zMX8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lDqQ/z+oCQ5mnuV3jL9YuPn2SM7YIwPNDGcdmotiI5AjKCy1N2vkvyVjNenfDrqFu
         EvRQexdEKl5Kk54q2GSmdk2LwkbueOM4Zkn2BywYzedX3KVQKtF6BFpmOIun1Ks93V
         mehWQL5hpqAUqL7Juaiw3cohwn4pvnrN2b+bxS1vR43AtSWC9khLX9omqS7CgFyJ3n
         NHK0XFnu1kO3IQZbia2CqjY6YFRDeblpq+02sZLJcfuK59EN33ATG8R5lI/VS1TvUt
         CJDwE/rOSO6rnxTUzxirgq+Z5+wRIYfRo/Az4gmlmKekalAG8s7x2tKWA7QS5Uc7ts
         +DhZI9Ek7zuIg==
Date:   Tue, 5 Jan 2021 14:39:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        martin.varghese@nokia.com, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net v2] net: bareudp: add missing error handling for
 bareudp_link_config()
Message-ID: <20210105143912.34e71377@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpVMBjoSFH34cunM+e+E6Qu+eWVfoduo5LvyupRHq1OG1w@mail.gmail.com>
References: <20210105190725.1736246-1-kuba@kernel.org>
        <CAM_iQpVMBjoSFH34cunM+e+E6Qu+eWVfoduo5LvyupRHq1OG1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jan 2021 12:38:54 -0800 Cong Wang wrote:
> On Tue, Jan 5, 2021 at 11:07 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > +static void bareudp_dellink(struct net_device *dev, struct list_head *head)
> > +{
> > +       struct bareudp_dev *bareudp = netdev_priv(dev);
> > +
> > +       list_del(&bareudp->next);
> > +       unregister_netdevice_queue(dev, head);
> > +}
> > +
> >  static int bareudp_newlink(struct net *net, struct net_device *dev,
> >                            struct nlattr *tb[], struct nlattr *data[],
> >                            struct netlink_ext_ack *extack)
> >  {
> >         struct bareudp_conf conf;
> > +       LIST_HEAD(list_kill);
> >         int err;
> >
> >         err = bareudp2info(data, &conf, extack);
> > @@ -662,17 +671,14 @@ static int bareudp_newlink(struct net *net, struct net_device *dev,
> >
> >         err = bareudp_link_config(dev, tb);
> >         if (err)
> > -               return err;
> > +               goto err_unconfig;
> >
> >         return 0;
> > -}
> > -
> > -static void bareudp_dellink(struct net_device *dev, struct list_head *head)
> > -{
> > -       struct bareudp_dev *bareudp = netdev_priv(dev);
> >
> > -       list_del(&bareudp->next);
> > -       unregister_netdevice_queue(dev, head);
> > +err_unconfig:
> > +       bareudp_dellink(dev, &list_kill);
> > +       unregister_netdevice_many(&list_kill);  
> 
> Why do we need unregister_netdevice_many() here? I think
> bareudp_dellink(dev, NULL) is sufficient as we always have
> one instance to unregister?
> 
> (For the same reason, bareudp_dev_create() does not need it
> either.)

Ack, I'm following how bareudp_dev_create() is written. 

I can follow up in net-next and change both, sounds good?
