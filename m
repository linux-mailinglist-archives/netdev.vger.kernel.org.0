Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADA71C64A2
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 01:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgEEXtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 19:49:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52971 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728717AbgEEXtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 19:49:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588722552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UG7vYCK2n8vNTaJJBh9eDS3ck+miSuSAAzIYvH4kXUg=;
        b=KSejZ1PbHPbAraohMYQuqelaSqQOHCEuqtGilYX8ckaIi40AJofspFBiZa//lLpcWncCBQ
        iBlJVgLFvYT5fY7ZN/DISBtc0Ef4SudaIhwpdSRq1296Ll8+OHyhYC5rTLBrdCHx37jpVh
        fc5emB6+8ijMPO9e7yuC2jvo3w8DHv0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-oO4sI7pdNHmr_psiGQ-Dew-1; Tue, 05 May 2020 19:49:08 -0400
X-MC-Unique: oO4sI7pdNHmr_psiGQ-Dew-1
Received: by mail-wm1-f69.google.com with SMTP id u11so92354wmc.7
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 16:49:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UG7vYCK2n8vNTaJJBh9eDS3ck+miSuSAAzIYvH4kXUg=;
        b=TvsOSLm7n4qFr+kf7bYzQS3oIEy1zj9siLx4L8A9GCEa1b9SV6PFJeLUf2G3b16Cdu
         YZRYJSvuiJaq2sPv8g06XZ+bY/71hg6BQ5ZcnYG/AaPE8nwnZWw6QqdxmROnJELRq+Q0
         /wU+XeqUq6r2nC84Y/mxLlT4SMVlc47Kv9xxnAe39WqlGXO+LE+ves29gJyKCGko8j+L
         QK7FX4oYoLuOhShPsQZHOlkUD5b1ar77bdE+XBMDBK3jZvPTu4SddJVxIfJIKPn8l9QD
         6+8JAcINexJiiNwEfnGKiciFGbTLjihVHog0Lo4OavzqXhb6umf2DwuyH/En6DLg40be
         PKsQ==
X-Gm-Message-State: AGi0PubIFwnuVljrUwyeC21wr5+SAZ3i5MHArdGRhbNfNJ/+ioCnMnL8
        wa8GVKE+TDlK6GcVMi1O+aecA/XYX5DDykT3qtJS+/vgP+GEekkxehiVTyxt9v8fAlUua804tzr
        8kr5yOgGsIQXHjxdn
X-Received: by 2002:a1c:1b88:: with SMTP id b130mr1068929wmb.75.1588722547669;
        Tue, 05 May 2020 16:49:07 -0700 (PDT)
X-Google-Smtp-Source: APiQypLaHOZmk16dWoTpYztScgAnmfECe22JhEpgqFlPjSJJY/fgVY6imHEtT/Jf0EYcbHpDEeKPeg==
X-Received: by 2002:a1c:1b88:: with SMTP id b130mr1068919wmb.75.1588722547457;
        Tue, 05 May 2020 16:49:07 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id 77sm30243wrc.6.2020.05.05.16.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 16:49:06 -0700 (PDT)
Date:   Tue, 5 May 2020 19:49:04 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] Inconsistent lock state in virtnet poll
Message-ID: <20200505194320-mutt-send-email-mst@kernel.org>
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

I like this better I think.

Will send a patch now.

-- 
MST

