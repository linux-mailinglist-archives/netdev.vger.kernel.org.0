Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C13F4A696E
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbiBBA5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:57:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55294 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiBBA5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:57:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03D3AB82FE3;
        Wed,  2 Feb 2022 00:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0ADC340E9;
        Wed,  2 Feb 2022 00:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643763451;
        bh=98nNxIicM+eGuu2qldo7Nd5//SGeL28ZWSKsTcZhXvg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rrb7mWmgANB3YX7E0kRwUuTkiTUHTOibbHQW75C/iE427FdDW0TIl9W0vZe0yTAl/
         l6OehIROUaAMRSb5qXriC4+CE8vL+eFgUxyYMutR/zE4O74GlkVXiFTjLt0yq/O0f2
         p2YRXN+WVg5QVOB16Zc+fdZMOSdh+PreyFzTKi5vRZnCRfdVhEyAdAgeha5yFpcsKQ
         IVfwd9QsLPi/vLAc9/HcgHoC4IKZQNslnq8pJGdbqpjrPyBLnDwK9tMA5IZkOPRJCx
         RBkGe6h1WJyGRioMz8Gdj7GVNDpRDdhpmgbEE1dbJAcVj/ZuG2MldWTLz6OZ17esSe
         tgjiAVi9/0LOQ==
Date:   Tue, 1 Feb 2022 16:57:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jann Horn <jannh@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>
Subject: Re: [BUG] net_device UAF: linkwatch_fire_event() calls dev_hold()
 after netdev_wait_allrefs() is done
Message-ID: <20220201165730.1adb7e66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAG48ez0sa2+eEAnS3UMLmLbDRfM6iC4K3vRcUdA9LpDbSJF0XA@mail.gmail.com>
References: <CAG48ez0MHBbENX5gCdHAUXZ7h7s20LnepBF-pa5M=7Bi-jZrEA@mail.gmail.com>
        <20220127181930.355c8c82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAG48ez0sa2+eEAnS3UMLmLbDRfM6iC4K3vRcUdA9LpDbSJF0XA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Feb 2022 23:46:16 +0100 Jann Horn wrote:
> On Fri, Jan 28, 2022 at 3:19 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > Interesting..
> >
> > I don't know what link_reset does, but since it turns the carrier on it
> > seems like something that should be flushed/canceled when the device
> > goes down. unregister brings the device down under rtnl_lock.
> >
> > On Fri, 28 Jan 2022 02:51:24 +0100 Jann Horn wrote:  
> > > Is the bug that usbnet_disconnect() should be stopping &dev->kevent
> > > before calling unregister_netdev()?  
> >
> > I'd say not this one, I think the generally agreed on semantics are that
> > the netdev is under users control between register and unregister, we
> > should not cripple it before unregister.
> >  
> > > Or is the bug that ax88179_link_reset() doesn't take some kind of lock
> > > and re-check that the netdev is still alive?  
> >
> > That'd not be an uncommon way to fix this.. taking rtnl_lock, not even
> > a driver lock in similar.  
> 
> Ah, I found a comment with a bit of explanation on how this is
> supposed to work... usbnet_stop() explains:
> 
>     /* deferred work (task, timer, softirq) must also stop.
>      * can't flush_scheduled_work() until we drop rtnl (later),
>      * else workers could deadlock; so make workers a NOP.
>      */
> 
> And usbnet_stop() is ->ndo_stop(), which indeed runs under RTNL.
> 
> I wonder what the work items can do that'd conflict with RTNL... or is
> the comment just talking about potential issues if a bunch of *other*
> work items need RTNL and clog up the system_wq so that
> flush_scheduled_work() blocks forever?

Good question. Nothing that would explicitly take rtnl_lock jumps out
in the usbnet code or the link_reset handler. The code is ancient, too:

/* work that cannot be done in interrupt context uses keventd.
 *
 * NOTE:  with 2.5 we could do more of this using completion callbacks,

:)

> If it's the latter case, I guess we could instead do cancel_work_sync() and
> then maybe re-run the work function's handler one more time
> synchronously?

cancel_sync() sounds good, lan78xx.c does that plus clearing the event
bits. I don't think you need to call the link_reset handler manually,
the stop function should shut down the link, anyway.
