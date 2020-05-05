Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EC01C64A5
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 01:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgEEXy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 19:54:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26094 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728875AbgEEXy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 19:54:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588722895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XFLVObCVbkNmV/glRHr4G4c6esH+GbnK5NfayVzYrLs=;
        b=UIcUQjadZAlYy262uHReZq6NmJLjmEJFkj9Svq0ydZmHlBCNjLOYDrNtVQoLKH1e3kvOU6
        pEs4XpGek3t+3sJwr/LbG+akttlAhdLuD2ErIx2VVdb7oqPkq3Bz0I2ACmP5n1k5k3IpHR
        a5lf5FubwLlMctxu4LvagmL0Ynwjjms=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-S4tb_WlNN3Wf2zSrrKAg-Q-1; Tue, 05 May 2020 19:54:53 -0400
X-MC-Unique: S4tb_WlNN3Wf2zSrrKAg-Q-1
Received: by mail-wr1-f72.google.com with SMTP id e14so270816wrv.11
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 16:54:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XFLVObCVbkNmV/glRHr4G4c6esH+GbnK5NfayVzYrLs=;
        b=obnNq6J2C6UxumbKY+mBQksh/cBdnnvTbZtgGqKvRGylXjrPtyajYJvN1QQKozet3j
         FNcYZgEOFI7B+GJEnMsBELHz5NOl81PTSiXuR5Lvk265+NN7sro8P+jlLxQrXQaA235p
         Qf7lGn+ZYWF4HlGD3upDR/QIuRscp3vKhit7DGrSP76naU2BvPgLnMUWlRs9sqa9c4Gi
         xcl60kSyL4mf7C6Us525vB6v5yTecZNAZGJZtW+on9XUblk7v8AlTzwIFKqe4CAhwZbP
         mgdVW9k4iob2qIuZX9I35T9im2ZNxqh88pJYFObc16oGu5gp2vfzpCAZnHSnpMRo4zxe
         iDNQ==
X-Gm-Message-State: AGi0PuaGkI8RHxS/9qiblkJJwdUNWi2OwAW0JzUuhpxc9HaP9iM39MbD
        ucR0MfeXROMIF5nIEymDkjiHzwzChjNL9hJCfMj4vQjnEJ5x/MOxlReGenNxNXbxJUDbgDQWZXq
        VDisA3XspUmarggU6
X-Received: by 2002:a5d:5001:: with SMTP id e1mr6589094wrt.27.1588722892408;
        Tue, 05 May 2020 16:54:52 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ8Kge1DgfhYd03tIPWlJfw1O3/6Ny1kVdOSlqQLT+5GSs5EriAw8ZhJXRUQ/A8RM1OEpclgg==
X-Received: by 2002:a5d:5001:: with SMTP id e1mr6589081wrt.27.1588722892230;
        Tue, 05 May 2020 16:54:52 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id t2sm309277wmt.15.2020.05.05.16.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 16:54:51 -0700 (PDT)
Date:   Tue, 5 May 2020 19:54:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] Inconsistent lock state in virtnet poll
Message-ID: <20200505195159-mutt-send-email-mst@kernel.org>
References: <87lfm6oa7b.fsf@nanos.tec.linutronix.de>
 <20200505120352-mutt-send-email-mst@kernel.org>
 <87v9lanher.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9lanher.fsf@nanos.tec.linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 12:30:52AM +0200, Thomas Gleixner wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> > On Tue, May 05, 2020 at 02:08:56PM +0200, Thomas Gleixner wrote:
> >> 
> >> The following lockdep splat happens reproducibly on 5.7-rc4
> >
> >> ================================
> >> WARNING: inconsistent lock state
> >> 5.7.0-rc4+ #79 Not tainted
> >> --------------------------------
> >> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> >> ip/356 [HC0[0]:SC1[1]:HE1:SE0] takes:
> >> f3ee4cd8 (&syncp->seq#2){+.?.}-{0:0}, at: net_rx_action+0xfb/0x390
> >> {SOFTIRQ-ON-W} state was registered at:
> >>   lock_acquire+0x82/0x300
> >>   try_fill_recv+0x39f/0x590
> >
> > Weird. Where does try_fill_recv acquire any locks?
> 
>   u64_stats_update_begin(&rq->stats.syncp);
> 
> That's a 32bit kernel which uses a seqcount for this. sequence counts
> are "lock" constructs where you need to make sure that writers are
> serialized.
> 
> Actually the problem at hand is that try_fill_recv() is called from
> fully preemptible context initialy and then from softirq context.
> 
> Obviously that's for the open() path a non issue, but lockdep does not
> know about that. OTOH, there is other code which calls that from
> non-softirq context.

Well to be more specific, try_fill_recv is either called from napi,
or from preemptible contexts with napi disabled and rtnl lock taken.

Two try_fill_recv calls in parallel would cause ring corruption
and no end of mischief, we certainly don't want that even on 64 bit
kernels.


> The hack below made it shut up. It's obvioulsy not ideal, but at least
> it let me look at the actual problem I was chasing down :)
> 
> Thanks,
> 
>         tglx

I'll post a hack based on Eric's suggestion since that is at least
0-overhead on 64 bit. It would be nice if we could teach
lockdep that it's about napi...


> 8<-----------
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1243,9 +1243,11 @@ static bool try_fill_recv(struct virtnet
>  			break;
>  	} while (rq->vq->num_free);
>  	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)) {
> +		local_bh_disable();
>  		u64_stats_update_begin(&rq->stats.syncp);
>  		rq->stats.kicks++;
>  		u64_stats_update_end(&rq->stats.syncp);
> +		local_bh_enable();
>  	}
>  
>  	return !oom;

