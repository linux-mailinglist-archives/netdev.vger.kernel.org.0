Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428161550C7
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 03:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgBGCux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 21:50:53 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:45048 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgBGCux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 21:50:53 -0500
Received: by mail-yb1-f195.google.com with SMTP id f21so539071ybg.11
        for <netdev@vger.kernel.org>; Thu, 06 Feb 2020 18:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N2/eEddJboKlMpWv2Is9YXJEKE2PZFszlgqn0u17YU0=;
        b=LVhLlCdRJBhCeYshGu5vhGXQ4HgD9IdBlsVDWa7m02DajeYSwc2xBPtfokh0SUrjg4
         Hkts1odemrOrWyDxvUEwzHucDofd1XKBZJQDyFWYZwvisy/CWe2Fr4ezVT1+eINvGpks
         DVAVxcphdicHP8Rkgr9Nd2NBV+l7cLJX46NEr2hQUwSaHjUClg1PU1ezdeRQcgfM6WJ4
         CNypeVngUe7qbouKomavdPRf1441OQ/XZqhITFd7qnHj9EBFc5UDj+5dV7VBYxnrXGSg
         WXF/JhoSk/SrJweg55M/AugdU7aJJNBlLBGNDdnD48ajtHYZmS47OSXOAFcyrCFK6ZzG
         wAzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N2/eEddJboKlMpWv2Is9YXJEKE2PZFszlgqn0u17YU0=;
        b=WqC25JyL7hjKwKKeZ+w5OZP2hAFx9FiQ8vCMdsu5+mPPFMcC+iDDAjtqYqrR6QO2KD
         Cbg07ToxvEfq5gNcuaTaL4CrXA4gZUyo/lB70/ffviNsvapEhn4AstiO4oCLwDx1V2vr
         uxAO5UzQYP4ZSg4rXMfsytAkfFLxcyz6RX6Sh6a/bO2roIwKBOoTlwxOOVFyOaa9BFL8
         xwDnj8z615UNNZRLhXiluZdWgDte5nhpXP90B4sidH/M9E9qX71BaNyJtcS1Y4PgdvK9
         9JS0iNmSrZ7JdE/cBS9DleH5M7k+gtMju+za/34vA/GuyQfhpD0SMYVotB/8r7KQ0YMa
         VggA==
X-Gm-Message-State: APjAAAX68IXaYawVF1y3YIbF1WuB039MifLp28aIpDzgl8zG0pA38aeN
        RFySlrLypO4uZVHyNw5ImC54LE9ZW0sRhzx58SbbIg==
X-Google-Smtp-Source: APXvYqwT00OocyPpK6xpxGZQiYjk/TEuCpmnfERvJSnT0F/We72/JQCHPhm9EjAJgCY4ysPzd8aU0Uvd96+BR1rVtps=
X-Received: by 2002:a25:1c45:: with SMTP id c66mr2433763ybc.101.1581043852009;
 Thu, 06 Feb 2020 18:50:52 -0800 (PST)
MIME-Version: 1.0
References: <20200205165544.242623-1-edumazet@google.com> <20200206.141300.1752448469848126511.davem@davemloft.net>
 <CANn89iLR8jR4L3ANiSBxuLoLFuUA5+SbJ06L3cW5-99i9=_yZQ@mail.gmail.com>
In-Reply-To: <CANn89iLR8jR4L3ANiSBxuLoLFuUA5+SbJ06L3cW5-99i9=_yZQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 6 Feb 2020 18:50:40 -0800
Message-ID: <CANn89iLb-OcdVCV+qNH7BEUjw3KtEPhhOM_XUyyJaWbhA5=dQw@mail.gmail.com>
Subject: Re: [PATCH net] ipv6/addrconf: fix potential NULL deref in inet6_set_link_af()
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>, maximmi@mellanox.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 6, 2020 at 7:18 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Feb 6, 2020 at 5:13 AM David Miller <davem@davemloft.net> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> > Date: Wed,  5 Feb 2020 08:55:44 -0800
> >
> > > __in6_dev_get(dev) called from inet6_set_link_af() can return NULL.
> > >
> > > The needed check has been recently removed, let's add it back.
> >
> > I am having trouble understanding this one.
> >
> > When we have a do_setlink operation the flow is that we first validate
> > the AFs and then invoke setlink operations after that validation.
> >
> > do_setlink() {
> >  ..
> >         err = validate_linkmsg(dev, tb);
> >         if (err < 0)
> >                 return err;
> >  ..
> >         if (tb[IFLA_AF_SPEC]) {
> >  ...
> >                         err = af_ops->set_link_af(dev, af);
> >                         if (err < 0) {
> >                                 rcu_read_unlock();
> >                                 goto errout;
> >                         }
> >
> > By definition, we only get to ->set_link_af() if there is an
> > IFLA_AF_SPEC nested attribute and if we look at the validation
> > performed by validate_linkmsg() it goes:
> >
> >         if (tb[IFLA_AF_SPEC]) {
> >  ...
> >                         if (af_ops->validate_link_af) {
> >                                 err = af_ops->validate_link_af(dev, af);
> >  ...
> >
> > And validate_link_af in net/ipv6/addrconf.c clearly does the
> > following:
> >
> > static int inet6_validate_link_af(const struct net_device *dev,
> >                                   const struct nlattr *nla)
> >  ...
> >         if (dev) {
> >                 idev = __in6_dev_get(dev);
> >                 if (!idev)
> >                         return -EAFNOSUPPORT;
> >         }
> >  ...
> >
> > It checks the idev and makes sure it is not-NULL.
> >
> > I therefore cannot find a path by which we arrive at inet6_set_link_af
> > with a NULL idev.  The above validation code should trap it.
> >
> > Please explain.
> >
>
> I can give a repro if that helps.
>
> (I have to run, I might have more time later)
>


If I understood the repro well enough, it seems it sets the device MTU
to 1023, thus IPV6 is automatically disabled. (as mtu < 1280)

do_setlink()
...
err = validate_linkmsg(dev, tb); /* OK at this point */
...
if (tb[IFLA_MTU]) {
    err = dev_set_mtu_ext(dev, nla_get_u32(tb[IFLA_MTU]), extack);
    if (err < 0)
          goto errout;
    status |= DO_SETLINK_MODIFIED;
}
if (tb[IFLA_AF_SPEC]) {
   ...
   err = af_ops->set_link_af(dev, af);
   ->inet6_set_link_af() // CRASH because idev is NULL


Please note that IPv4 is immune to the bug since inet_set_link_af() does :

struct in_device *in_dev = __in_dev_get_rcu(dev);
if (!in_dev)
    return -EAFNOSUPPORT;
