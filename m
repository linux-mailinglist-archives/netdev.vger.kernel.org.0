Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4475B27EE12
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731045AbgI3P6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgI3P6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 11:58:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1D90206F7;
        Wed, 30 Sep 2020 15:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601481491;
        bh=KQeipt6mPgI6A1ThwNU+PmnjOYx6DXaxMq04pz+J8KE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VUmWFo/CM7m7RaPSjhz+uj2WG24lJHvfa/yfqpxbYCPVkqjega/RTaEa3Y1LSPDmJ
         ju2t4h+j9DdolNfP0Z+gXDoJAh35uNm3PSv3zbIf+57nVvm8tTrGtyJSfi8WE4bmLp
         uBcUtWJP3puJXuYd1el6gbgtiV2MLsUHoa5mc/LE=
Date:   Wed, 30 Sep 2020 08:58:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Wei Wang <weiwan@google.com>, Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>, Luigi Rizzo <lrizzo@google.com>
Subject: Re: [RFC PATCH net-next 0/6] implement kthread based napi poll
Message-ID: <20200930085809.58eee328@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <61d93b14c653a66ce70b7d72fc55c4c7b67e9fb6.camel@redhat.com>
References: <20200914172453.1833883-1-weiwan@google.com>
        <CANn89iJDM97U15Znrx4k4bOFKunQp7dwJ9mtPwvMmB4S+rSSbA@mail.gmail.com>
        <20200929121902.7ee1c700@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_BPT591fqFRqsM=k4urVXQ1sqL-31rMWjhvKQZm9-Lksg@mail.gmail.com>
        <20200929144847.05f3dcf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <61d93b14c653a66ce70b7d72fc55c4c7b67e9fb6.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 10:58:00 +0200 Paolo Abeni wrote:
> On Tue, 2020-09-29 at 14:48 -0700, Jakub Kicinski wrote:
> > On Tue, 29 Sep 2020 13:16:59 -0700 Wei Wang wrote:  
> > > On Tue, Sep 29, 2020 at 12:19 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> > > > On Mon, 28 Sep 2020 19:43:36 +0200 Eric Dumazet wrote:    
> > > > > Wei, this is a very nice work.
> > > > > 
> > > > > Please re-send it without the RFC tag, so that we can hopefully merge it ASAP.    
> > > > 
> > > > The problem is for the application I'm testing with this implementation
> > > > is significantly slower (in terms of RPS) than Felix's code:
> > > > 
> > > >               |        L  A  T  E  N  C  Y       |  App   |     C P U     |
> > > >        |  RPS |   AVG  |  P50  |   P99  |   P999 | Overld |  busy |  PSI  |
> > > > thread | 1.1% | -15.6% | -0.3% | -42.5% |  -8.1% | -83.4% | -2.3% | 60.6% |
> > > > work q | 4.3% | -13.1% |  0.1% | -44.4% |  -1.1% |   2.3% | -1.2% | 90.1% |
> > > > TAPI   | 4.4% | -17.1% | -1.4% | -43.8% | -11.0% | -60.2% | -2.3% | 46.7% |
> > > > 
> > > > thread is this code, "work q" is Felix's code, TAPI is my hacks.
> > > > 
> > > > The numbers are comparing performance to normal NAPI.
> > > > 
> > > > In all cases (but not the baseline) I configured timer-based polling
> > > > (defer_hard_irqs), with around 100us timeout. Without deferring hard
> > > > IRQs threaded NAPI is actually slower for this app. Also I'm not
> > > > modifying niceness, this again causes application performance
> > > > regression here.
> > > >    
> > > 
> > > If I remember correctly, Felix's workqueue code uses HIGHPRIO flag
> > > which by default uses -20 as the nice value for the workqueue threads.
> > > But the kthread implementation leaves nice level as 20 by default.
> > > This could be 1 difference.  
> > 
> > FWIW this is the data based on which I concluded the nice -20 actually
> > makes things worse here:
> > 
> >       threded: -1.50%
> >  threded p-20: -5.67%
> >      thr poll:  2.93%
> > thr poll p-20:  2.22%
> > 
> > Annoyingly relative performance change varies day to day and this test
> > was run a while back (over the weekend I was getting < 2% improvement
> > with this set).  
> 
> I'm assuming your application uses UDP as the transport protocol - raw
> IP or packet socket should behave in the same way. I observed similar
> behavior - that is unstable figures, and end-to-end tput decrease when
> network stack get more cycles (or become faster) - when the bottle-neck 
> was in user-space processing[1].
> 
> You can double check you are hitting the same scenario observing the
> UDP protocol stats (you should see higher drops figures with threaded
> and even more with threded p-20, compared to the other impls).
> 
> If you are hitting such scenario, you should be able to improve things
> setting nice-20 to the user-space process, increasing the UDP socket
> receive buffer size or enabling socket busy polling
> (/proc/sys/net/core/busy_poll, I mean). 

It's not UDP. The application has some logic to tell the load balancer
to back off whenever it feels like it's not processing requests fast enough
(App Overld in the table 2 emails back). That statistic is higher with p-20.
Application latency suffers, too.
