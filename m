Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A30827E467
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 10:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgI3I6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 04:58:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30382 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728126AbgI3I6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 04:58:16 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601456295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8veHAtQvucCfMDjWJoAmGiM58JK9MUQkaXnUh17fWog=;
        b=IZ8/xaw1wU4PLHBrQ24Y8WhZZlagTTTf0J4RMNY+ra7SAzI7z0sOTQEBzqRM3ssuedBByc
        CsXRQ+fIE1L/oIR1XOdeN8DZFPFzcSnzES6QXlg6m1p53GSuKFSemQI5xvMFBTAprbPud/
        ECuhRzbZpzaqeLVLmacqHHv+LWXl1ak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-CsCwBwTAOfanFyG287MiNg-1; Wed, 30 Sep 2020 04:58:10 -0400
X-MC-Unique: CsCwBwTAOfanFyG287MiNg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C11821074651;
        Wed, 30 Sep 2020 08:58:08 +0000 (UTC)
Received: from ovpn-115-48.ams2.redhat.com (ovpn-115-48.ams2.redhat.com [10.36.115.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E9015D9D2;
        Wed, 30 Sep 2020 08:58:04 +0000 (UTC)
Message-ID: <61d93b14c653a66ce70b7d72fc55c4c7b67e9fb6.camel@redhat.com>
Subject: Re: [RFC PATCH net-next 0/6] implement kthread based napi poll
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>, Luigi Rizzo <lrizzo@google.com>
Date:   Wed, 30 Sep 2020 10:58:00 +0200
In-Reply-To: <20200929144847.05f3dcf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200914172453.1833883-1-weiwan@google.com>
         <CANn89iJDM97U15Znrx4k4bOFKunQp7dwJ9mtPwvMmB4S+rSSbA@mail.gmail.com>
         <20200929121902.7ee1c700@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <CAEA6p_BPT591fqFRqsM=k4urVXQ1sqL-31rMWjhvKQZm9-Lksg@mail.gmail.com>
         <20200929144847.05f3dcf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-09-29 at 14:48 -0700, Jakub Kicinski wrote:
> On Tue, 29 Sep 2020 13:16:59 -0700 Wei Wang wrote:
> > On Tue, Sep 29, 2020 at 12:19 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Mon, 28 Sep 2020 19:43:36 +0200 Eric Dumazet wrote:  
> > > > Wei, this is a very nice work.
> > > > 
> > > > Please re-send it without the RFC tag, so that we can hopefully merge it ASAP.  
> > > 
> > > The problem is for the application I'm testing with this implementation
> > > is significantly slower (in terms of RPS) than Felix's code:
> > > 
> > >               |        L  A  T  E  N  C  Y       |  App   |     C P U     |
> > >        |  RPS |   AVG  |  P50  |   P99  |   P999 | Overld |  busy |  PSI  |
> > > thread | 1.1% | -15.6% | -0.3% | -42.5% |  -8.1% | -83.4% | -2.3% | 60.6% |
> > > work q | 4.3% | -13.1% |  0.1% | -44.4% |  -1.1% |   2.3% | -1.2% | 90.1% |
> > > TAPI   | 4.4% | -17.1% | -1.4% | -43.8% | -11.0% | -60.2% | -2.3% | 46.7% |
> > > 
> > > thread is this code, "work q" is Felix's code, TAPI is my hacks.
> > > 
> > > The numbers are comparing performance to normal NAPI.
> > > 
> > > In all cases (but not the baseline) I configured timer-based polling
> > > (defer_hard_irqs), with around 100us timeout. Without deferring hard
> > > IRQs threaded NAPI is actually slower for this app. Also I'm not
> > > modifying niceness, this again causes application performance
> > > regression here.
> > >  
> > 
> > If I remember correctly, Felix's workqueue code uses HIGHPRIO flag
> > which by default uses -20 as the nice value for the workqueue threads.
> > But the kthread implementation leaves nice level as 20 by default.
> > This could be 1 difference.
> 
> FWIW this is the data based on which I concluded the nice -20 actually
> makes things worse here:
> 
>       threded: -1.50%
>  threded p-20: -5.67%
>      thr poll:  2.93%
> thr poll p-20:  2.22%
> 
> Annoyingly relative performance change varies day to day and this test
> was run a while back (over the weekend I was getting < 2% improvement
> with this set).

I'm assuming your application uses UDP as the transport protocol - raw
IP or packet socket should behave in the same way. I observed similar
behavior - that is unstable figures, and end-to-end tput decrease when
network stack get more cycles (or become faster) - when the bottle-neck 
was in user-space processing[1].

You can double check you are hitting the same scenario observing the
UDP protocol stats (you should see higher drops figures with threaded
and even more with threded p-20, compared to the other impls).

If you are hitting such scenario, you should be able to improve things
setting nice-20 to the user-space process, increasing the UDP socket
receive buffer size or enabling socket busy polling
(/proc/sys/net/core/busy_poll, I mean). 

Cheers,

Paolo

[1] Perhaps that is obvious to you, but I personally was confused the
first time I observed this fact. There is a nice paper from Luigi Rizzo
explaining why that happen:
http://www.iet.unipi.it/~a007834/papers/2016-ancs-cvt.pdf

