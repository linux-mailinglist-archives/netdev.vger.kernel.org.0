Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC831C6578
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 03:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgEFBZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 21:25:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46907 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728609AbgEFBZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 21:25:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588728351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=salWLcTCFQSdinV1WS2cAX975nD5l1MSiQYd88R2EQs=;
        b=aLBhHXUSmdgv/l/xTOsprZ9KO2W+rJcocA+8klkbyLoshkNTmpXrkGp9caDQz4N7h7riEh
        j5rKxh/wjp6aa8bKhQfjMZ59at8Z16sfzKVchy2DtZRzUezLeg1VjoRUGbvW1iWOhYCQKH
        rs/qpCmINXdkIE2GwmmaLbIeXtbEMwc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-ZbUYmPvLML2HXF4fZ4nu4A-1; Tue, 05 May 2020 21:25:49 -0400
X-MC-Unique: ZbUYmPvLML2HXF4fZ4nu4A-1
Received: by mail-wr1-f71.google.com with SMTP id g7so383414wrw.18
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 18:25:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=salWLcTCFQSdinV1WS2cAX975nD5l1MSiQYd88R2EQs=;
        b=ujLvRgBFCOdFnZ4tZ+Z1GFjbZYsdGttICnhdJQrJFHUVdECHFHOsK6AlA3FkZbFp4g
         /7tKX/dE1UjQ6ZrugXodNu4TOSLscI1PnCNF/CvBwmItI3bWpxk1F2kXWpiD2m6vfDSG
         UdlCqHev9ssDv9/pxrk4Iy1yGLTNw3lNI6DQQ2GWinT/fsXXc57RxY3stf+NFLG/+485
         CZGZ6y7KS7ucVIfKv1CynwKquqCXYiPnj8ieWR2xISoae5NQw40jNzPLowSb0V2oVf7Z
         3TEQEbUGi8PME3kzi0JdEpI/UcBzlKjN9KWM3JFOAXgIlopQl17LEf8Q7U6B/LjtC2F1
         Qe1g==
X-Gm-Message-State: AGi0PubifqCvUGq3V1Fw0jUJ49qF3NGfTvm9y3luB/MDlRtB52fns2Cf
        xw5Jy6vle8aohzvE0TgVm7hmLNSWYwmU+S/O/SwFriPFvTTTK8PTe9KgtqL8lu+wUXSgXCU1vS3
        mlhDP1pkkNf8RydDC
X-Received: by 2002:adf:ea44:: with SMTP id j4mr7236128wrn.38.1588728348522;
        Tue, 05 May 2020 18:25:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypJbljK98TfYDJ3DRHBfijjaciSi1fRGOwIMo3P1sbmyqGK+14qEWcV/E2LUJo+A8aEdqXruOA==
X-Received: by 2002:adf:ea44:: with SMTP id j4mr7236113wrn.38.1588728348245;
        Tue, 05 May 2020 18:25:48 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id n6sm100160wrs.81.2020.05.05.18.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 18:25:47 -0700 (PDT)
Date:   Tue, 5 May 2020 21:25:45 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] Inconsistent lock state in virtnet poll
Message-ID: <20200505212325-mutt-send-email-mst@kernel.org>
References: <87lfm6oa7b.fsf@nanos.tec.linutronix.de>
 <20200505120352-mutt-send-email-mst@kernel.org>
 <87v9lanher.fsf@nanos.tec.linutronix.de>
 <98c4d934-5a27-1cf7-119a-ce0c5a501864@gmail.com>
 <20200505204015-mutt-send-email-mst@kernel.org>
 <4ea7fb92-c4fb-1a31-d83b-483da2fb7a1a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ea7fb92-c4fb-1a31-d83b-483da2fb7a1a@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 06:19:09PM -0700, Eric Dumazet wrote:
> 
> 
> On 5/5/20 5:43 PM, Michael S. Tsirkin wrote:
> > On Tue, May 05, 2020 at 03:40:09PM -0700, Eric Dumazet wrote:
> >>
> >>
> >> On 5/5/20 3:30 PM, Thomas Gleixner wrote:
> >>> "Michael S. Tsirkin" <mst@redhat.com> writes:
> >>>> On Tue, May 05, 2020 at 02:08:56PM +0200, Thomas Gleixner wrote:
> >>>>>
> >>>>> The following lockdep splat happens reproducibly on 5.7-rc4
> >>>>
> >>>>> ================================
> >>>>> WARNING: inconsistent lock state
> >>>>> 5.7.0-rc4+ #79 Not tainted
> >>>>> --------------------------------
> >>>>> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> >>>>> ip/356 [HC0[0]:SC1[1]:HE1:SE0] takes:
> >>>>> f3ee4cd8 (&syncp->seq#2){+.?.}-{0:0}, at: net_rx_action+0xfb/0x390
> >>>>> {SOFTIRQ-ON-W} state was registered at:
> >>>>>   lock_acquire+0x82/0x300
> >>>>>   try_fill_recv+0x39f/0x590
> >>>>
> >>>> Weird. Where does try_fill_recv acquire any locks?
> >>>
> >>>   u64_stats_update_begin(&rq->stats.syncp);
> >>>
> >>> That's a 32bit kernel which uses a seqcount for this. sequence counts
> >>> are "lock" constructs where you need to make sure that writers are
> >>> serialized.
> >>>
> >>> Actually the problem at hand is that try_fill_recv() is called from
> >>> fully preemptible context initialy and then from softirq context.
> >>>
> >>> Obviously that's for the open() path a non issue, but lockdep does not
> >>> know about that. OTOH, there is other code which calls that from
> >>> non-softirq context.
> >>>
> >>> The hack below made it shut up. It's obvioulsy not ideal, but at least
> >>> it let me look at the actual problem I was chasing down :)
> >>>
> >>> Thanks,
> >>>
> >>>         tglx
> >>>
> >>> 8<-----------
> >>> --- a/drivers/net/virtio_net.c
> >>> +++ b/drivers/net/virtio_net.c
> >>> @@ -1243,9 +1243,11 @@ static bool try_fill_recv(struct virtnet
> >>>  			break;
> >>>  	} while (rq->vq->num_free);
> >>>  	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)) {
> >>> +		local_bh_disable();
> >>
> >> Or use u64_stats_update_begin_irqsave() whic is a NOP on 64bit kernels
> > 
> > I applied this, but am still trying to think of something that
> > is 0 overhead for all configs.
> > Maybe we can select a lockdep class depending on whether napi
> > is enabled?
> 
> 
> Do you _really_ need 64bit counter for stats.kicks on 32bit kernels ?
> 
> Adding 64bit counters just because we can might be overhead anyway.

Well 32 bit kernels don't fundamentally kick less than 64 bit ones,
and we kick more or less per packet, sometimes per batch,
people expect these to be in sync ..

> > 
> > 
> >>>  		u64_stats_update_begin(&rq->stats.syncp);
> >>>  		rq->stats.kicks++;
> >>>  		u64_stats_update_end(&rq->stats.syncp);
> >>> +		local_bh_enable();
> >>>  	}
> >>>  
> >>>  	return !oom;
> >>>
> > 

