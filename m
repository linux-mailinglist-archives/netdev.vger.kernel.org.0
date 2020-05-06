Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE4D1C652E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 02:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbgEFAnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 20:43:23 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55804 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728356AbgEFAnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 20:43:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588725801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0fdnDFy7JXKrDof7rLqiJHkfMcFXjY3PBjGWo8UaFIM=;
        b=APpB06Hcs4IgtcEdFaadgZArcfPfPvCUNtPZgRekk9KxjpFWS7G5LJMZzBNwMiqaAqoa+A
        dq0QiHwWYrZFduhfOMXgL9QMidP49+sJweOO+393tyDtEcAGYhH6XIPx+6Hwm56nlVDTT1
        kRF+/NxwzAm1sXf0WT6Sq4hh09qhj2A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-0rBCRHTLMQ-dDK1miALIVw-1; Tue, 05 May 2020 20:43:20 -0400
X-MC-Unique: 0rBCRHTLMQ-dDK1miALIVw-1
Received: by mail-wr1-f70.google.com with SMTP id g7so329093wrw.18
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 17:43:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0fdnDFy7JXKrDof7rLqiJHkfMcFXjY3PBjGWo8UaFIM=;
        b=qoPoMdmR5R//uGKE0ZraJwOIex76KhZ216O2n9QxADflge42YvE8hR6H+jGme2hvmF
         6QGGZwpySGRFz3AnuJRrSm8FanZ2YWZXR/ARojnw30D8+JkCRDL+nlA/+dQWOE+CGmYH
         jgn8hEjl9kObv5ZAQ47+aKjMylt5PvKqI8/0iAYy8Z1elXVrGp3RMeHL5sro4NjfdvVM
         iHGz6IplUivNPqLJT/6tklr/GIma8WZ6zP00gMYwls8UsTGHRJhZc1glFNl2zr5B4+wp
         jvq4qz7UKF7bD/uxEaQXxj7qI0WTJeg79+PJDNoJSZxx51PobJVxZm85n+McgwY5Ric4
         tyxw==
X-Gm-Message-State: AGi0Pubn253BavTiKOdLpc4ua24G0AJi/a2cBTchIjPyxFoWG1Rac2U1
        exHO+Xb5RtO0gLAdCVqst6E2FKSAl95FOSHLXepPq3dg9fzwr3+HJ6X2fKonGQRFA2g+rlS+SkI
        FIfquRZ+389/g9DJm
X-Received: by 2002:a7b:c0d5:: with SMTP id s21mr1251169wmh.107.1588725798918;
        Tue, 05 May 2020 17:43:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypJaz0SjkvK+GXqyRV6i4tCq7Elvx3MjY6FoMKFgbh08KMC+kj6zoR1wCkAwGnXCLBBbRYwHgw==
X-Received: by 2002:a7b:c0d5:: with SMTP id s21mr1251149wmh.107.1588725798684;
        Tue, 05 May 2020 17:43:18 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id 185sm491014wmc.32.2020.05.05.17.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 17:43:18 -0700 (PDT)
Date:   Tue, 5 May 2020 20:43:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] Inconsistent lock state in virtnet poll
Message-ID: <20200505204015-mutt-send-email-mst@kernel.org>
References: <87lfm6oa7b.fsf@nanos.tec.linutronix.de>
 <20200505120352-mutt-send-email-mst@kernel.org>
 <87v9lanher.fsf@nanos.tec.linutronix.de>
 <98c4d934-5a27-1cf7-119a-ce0c5a501864@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98c4d934-5a27-1cf7-119a-ce0c5a501864@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 03:40:09PM -0700, Eric Dumazet wrote:
> 
> 
> On 5/5/20 3:30 PM, Thomas Gleixner wrote:
> > "Michael S. Tsirkin" <mst@redhat.com> writes:
> >> On Tue, May 05, 2020 at 02:08:56PM +0200, Thomas Gleixner wrote:
> >>>
> >>> The following lockdep splat happens reproducibly on 5.7-rc4
> >>
> >>> ================================
> >>> WARNING: inconsistent lock state
> >>> 5.7.0-rc4+ #79 Not tainted
> >>> --------------------------------
> >>> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> >>> ip/356 [HC0[0]:SC1[1]:HE1:SE0] takes:
> >>> f3ee4cd8 (&syncp->seq#2){+.?.}-{0:0}, at: net_rx_action+0xfb/0x390
> >>> {SOFTIRQ-ON-W} state was registered at:
> >>>   lock_acquire+0x82/0x300
> >>>   try_fill_recv+0x39f/0x590
> >>
> >> Weird. Where does try_fill_recv acquire any locks?
> > 
> >   u64_stats_update_begin(&rq->stats.syncp);
> > 
> > That's a 32bit kernel which uses a seqcount for this. sequence counts
> > are "lock" constructs where you need to make sure that writers are
> > serialized.
> > 
> > Actually the problem at hand is that try_fill_recv() is called from
> > fully preemptible context initialy and then from softirq context.
> > 
> > Obviously that's for the open() path a non issue, but lockdep does not
> > know about that. OTOH, there is other code which calls that from
> > non-softirq context.
> > 
> > The hack below made it shut up. It's obvioulsy not ideal, but at least
> > it let me look at the actual problem I was chasing down :)
> > 
> > Thanks,
> > 
> >         tglx
> > 
> > 8<-----------
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1243,9 +1243,11 @@ static bool try_fill_recv(struct virtnet
> >  			break;
> >  	} while (rq->vq->num_free);
> >  	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)) {
> > +		local_bh_disable();
> 
> Or use u64_stats_update_begin_irqsave() whic is a NOP on 64bit kernels

I applied this, but am still trying to think of something that
is 0 overhead for all configs.
Maybe we can select a lockdep class depending on whether napi
is enabled?


> >  		u64_stats_update_begin(&rq->stats.syncp);
> >  		rq->stats.kicks++;
> >  		u64_stats_update_end(&rq->stats.syncp);
> > +		local_bh_enable();
> >  	}
> >  
> >  	return !oom;
> > 

