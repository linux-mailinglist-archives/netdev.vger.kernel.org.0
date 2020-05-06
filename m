Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1117B1C6A18
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 09:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgEFHcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 03:32:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35651 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727067AbgEFHcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 03:32:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588750325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HP/mARJSFaRZB8Uw1gs0N8a3hG9u3MSy81dFgfdpRwU=;
        b=WRg2I0lTpiZbb4Bs9gWKIL9EasyMn4ZazOIuyp3wRJAkF0OI1XC7F2VbVZEToefBRxGMw4
        7izMeuDzPt0umfykYMn4gJf5U54srx1kIAFSmdyMifzQWzOLqfX/tXITiIKjjCnBptzChj
        4ZqG20U0KX+S3W84dDzJCzphI1m1OgU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-GiYhWrjTOBOunLsfCb0v7g-1; Wed, 06 May 2020 03:32:02 -0400
X-MC-Unique: GiYhWrjTOBOunLsfCb0v7g-1
Received: by mail-wr1-f70.google.com with SMTP id v17so861403wrq.8
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 00:32:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HP/mARJSFaRZB8Uw1gs0N8a3hG9u3MSy81dFgfdpRwU=;
        b=DG7ahF1vMrqd4V6nudXr7JX2mK0hy8YbwSIEnS+RPjdaPJNhS+IsJCQQHSfmL7iJYd
         X1KsjRYmJz0PuSTNgjjMsgimAHNs1hBaehTNrdthgi43KTPEO6l1Xm6w4kT48YNIBPGK
         /w9CXXmw0lA8GhNF/Mp6dYXxKpv2MbHEaQuWbkqvWFHGHKjEc17+XseACL1u/8PBEzDM
         njiY56xW1hih1vIIJbUvvQnTwbO4tNkuYV6qhtTMyE5egfil5efkayS4Vw2kU4tybKJA
         wK3qOLa2qWT5g3ko53oZiml+CLi4vVBBSyr3GULgWGMrtG7k0lFpIHY0za5jqkplCfqV
         dApQ==
X-Gm-Message-State: AGi0PuaLkvCxmxI9yMk2+exzach3yFWcMKlDaPqG0MODYgUtXbgYwONU
        xkrLJZJRaeaaBAoAJq12EI9ZC4ZU5cXKsulrqS5netnzBM7E8fhhGL0LK08TRfHdCSYKXddU366
        Ko2H0210u4J99xp7f
X-Received: by 2002:a05:6000:1048:: with SMTP id c8mr7269899wrx.1.1588750321274;
        Wed, 06 May 2020 00:32:01 -0700 (PDT)
X-Google-Smtp-Source: APiQypJEtAvDnoogiQvtnt2ssGvAjfh/VYKMVYUCDUyIfEO4lWsJL1Z/1uyrb/dUdfsIIdGyVt3a6Q==
X-Received: by 2002:a05:6000:1048:: with SMTP id c8mr7269878wrx.1.1588750321029;
        Wed, 06 May 2020 00:32:01 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id n25sm1691117wmk.9.2020.05.06.00.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 00:32:00 -0700 (PDT)
Date:   Wed, 6 May 2020 03:31:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] Inconsistent lock state in virtnet poll
Message-ID: <20200506032237-mutt-send-email-mst@kernel.org>
References: <87lfm6oa7b.fsf@nanos.tec.linutronix.de>
 <20200505120352-mutt-send-email-mst@kernel.org>
 <87v9lanher.fsf@nanos.tec.linutronix.de>
 <98c4d934-5a27-1cf7-119a-ce0c5a501864@gmail.com>
 <20200505204015-mutt-send-email-mst@kernel.org>
 <4ea7fb92-c4fb-1a31-d83b-483da2fb7a1a@gmail.com>
 <20200505212325-mutt-send-email-mst@kernel.org>
 <71b1b9dd-78e3-9694-2daa-5723355293d4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71b1b9dd-78e3-9694-2daa-5723355293d4@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 07:24:18PM -0700, Eric Dumazet wrote:
> 
> 
> On 5/5/20 6:25 PM, Michael S. Tsirkin wrote:
> > On Tue, May 05, 2020 at 06:19:09PM -0700, Eric Dumazet wrote:
> >>
> >>
> >> On 5/5/20 5:43 PM, Michael S. Tsirkin wrote:
> >>> On Tue, May 05, 2020 at 03:40:09PM -0700, Eric Dumazet wrote:
> >>>>
> >>>>
> >>>> On 5/5/20 3:30 PM, Thomas Gleixner wrote:
> >>>>> "Michael S. Tsirkin" <mst@redhat.com> writes:
> >>>>>> On Tue, May 05, 2020 at 02:08:56PM +0200, Thomas Gleixner wrote:
> >>>>>>>
> >>>>>>> The following lockdep splat happens reproducibly on 5.7-rc4
> >>>>>>
> >>>>>>> ================================
> >>>>>>> WARNING: inconsistent lock state
> >>>>>>> 5.7.0-rc4+ #79 Not tainted
> >>>>>>> --------------------------------
> >>>>>>> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> >>>>>>> ip/356 [HC0[0]:SC1[1]:HE1:SE0] takes:
> >>>>>>> f3ee4cd8 (&syncp->seq#2){+.?.}-{0:0}, at: net_rx_action+0xfb/0x390
> >>>>>>> {SOFTIRQ-ON-W} state was registered at:
> >>>>>>>   lock_acquire+0x82/0x300
> >>>>>>>   try_fill_recv+0x39f/0x590
> >>>>>>
> >>>>>> Weird. Where does try_fill_recv acquire any locks?
> >>>>>
> >>>>>   u64_stats_update_begin(&rq->stats.syncp);
> >>>>>
> >>>>> That's a 32bit kernel which uses a seqcount for this. sequence counts
> >>>>> are "lock" constructs where you need to make sure that writers are
> >>>>> serialized.
> >>>>>
> >>>>> Actually the problem at hand is that try_fill_recv() is called from
> >>>>> fully preemptible context initialy and then from softirq context.
> >>>>>
> >>>>> Obviously that's for the open() path a non issue, but lockdep does not
> >>>>> know about that. OTOH, there is other code which calls that from
> >>>>> non-softirq context.
> >>>>>
> >>>>> The hack below made it shut up. It's obvioulsy not ideal, but at least
> >>>>> it let me look at the actual problem I was chasing down :)
> >>>>>
> >>>>> Thanks,
> >>>>>
> >>>>>         tglx
> >>>>>
> >>>>> 8<-----------
> >>>>> --- a/drivers/net/virtio_net.c
> >>>>> +++ b/drivers/net/virtio_net.c
> >>>>> @@ -1243,9 +1243,11 @@ static bool try_fill_recv(struct virtnet
> >>>>>  			break;
> >>>>>  	} while (rq->vq->num_free);
> >>>>>  	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)) {
> >>>>> +		local_bh_disable();
> >>>>
> >>>> Or use u64_stats_update_begin_irqsave() whic is a NOP on 64bit kernels
> >>>
> >>> I applied this, but am still trying to think of something that
> >>> is 0 overhead for all configs.
> >>> Maybe we can select a lockdep class depending on whether napi
> >>> is enabled?
> >>
> >>
> >> Do you _really_ need 64bit counter for stats.kicks on 32bit kernels ?
> >>
> >> Adding 64bit counters just because we can might be overhead anyway.
> > 
> > Well 32 bit kernels don't fundamentally kick less than 64 bit ones,
> > and we kick more or less per packet, sometimes per batch,
> > people expect these to be in sync ..
> 
> Well, we left many counters in networking stack as 'unsigned long'
> and nobody complained yet of overflows on 32bit kernels.

Right.  For TX it is helpful that everything is maintained
atomically so we do need the seqlock machinery anyway:

        u64_stats_update_begin(&sq->stats.syncp);
        sq->stats.bytes += bytes;
        sq->stats.packets += packets;
        sq->stats.xdp_tx += n;
        sq->stats.xdp_tx_drops += drops;
        sq->stats.kicks += kicks;
        u64_stats_update_end(&sq->stats.syncp);

for RX kicks are currently updated separately.  Which I guess is more or
less a minor bug.

        if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
                if (!try_fill_recv(vi, rq, GFP_ATOMIC))
                        schedule_delayed_work(&vi->refill, 0);
        }

        u64_stats_update_begin(&rq->stats.syncp);
        for (i = 0; i < VIRTNET_RQ_STATS_LEN; i++) {
                size_t offset = virtnet_rq_stats_desc[i].offset;
                u64 *item;

                item = (u64 *)((u8 *)&rq->stats + offset);
                *item += *(u64 *)((u8 *)&stats + offset);
        }
        u64_stats_update_end(&rq->stats.syncp);

we should update kicks in virtnet_receive.

And as long as we do that there's no cost to 64 bit counters ...


> SNMP agents are used to the fact that counters do overflow.
> 
> Problems might happen if the overflows happen too fast, say every 10 seconds,
> but other than that, forcing 64bit counters for something which is not
> _required_ for the data path is adding pain.
> 
> I am mentioning this, because trying to add lockdep stuff and associated
> maintenance cost for 32bit kernels in 2020 makes little sense to me,
> considering I added include/linux/u64_stats_sync.h 10 years ago.
> 

Not sure what do you suggest here...


> 
> 
> 

