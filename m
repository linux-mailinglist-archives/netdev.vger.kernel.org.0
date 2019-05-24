Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C8F29525
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390034AbfEXJxO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 May 2019 05:53:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389582AbfEXJxO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 05:53:14 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7F3D664458;
        Fri, 24 May 2019 09:53:13 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8E085C239;
        Fri, 24 May 2019 09:53:02 +0000 (UTC)
Date:   Fri, 24 May 2019 11:53:01 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Toke =?UTF-8?B?SMO4?= =?UTF-8?B?aWxhbmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH bpf-next 3/3] veth: Support bulk XDP_TX
Message-ID: <20190524115301.7626ed44@carbon>
In-Reply-To: <c902c0f4-947b-ba9e-7baa-628ba87a8f01@gmail.com>
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
        <1558609008-2590-4-git-send-email-makita.toshiaki@lab.ntt.co.jp>
        <87zhnd1kg9.fsf@toke.dk>
        <599302b2-96d2-b571-01ee-f4914acaf765@lab.ntt.co.jp>
        <20190523152927.14bf7ed1@carbon>
        <c902c0f4-947b-ba9e-7baa-628ba87a8f01@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 24 May 2019 09:53:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 22:51:34 +0900
Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:

> On 19/05/23 (木) 22:29:27, Jesper Dangaard Brouer wrote:
> > On Thu, 23 May 2019 20:35:50 +0900
> > Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> wrote:
> >   
> >> On 2019/05/23 20:25, Toke Høiland-Jørgensen wrote:  
> >>> Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> writes:
> >>>      
> >>>> This improves XDP_TX performance by about 8%.
> >>>>
> >>>> Here are single core XDP_TX test results. CPU consumptions are taken
> >>>> from "perf report --no-child".
> >>>>
> >>>> - Before:
> >>>>
> >>>>    7.26 Mpps
> >>>>
> >>>>    _raw_spin_lock  7.83%
> >>>>    veth_xdp_xmit  12.23%
> >>>>
> >>>> - After:
> >>>>
> >>>>    7.84 Mpps
> >>>>
> >>>>    _raw_spin_lock  1.17%
> >>>>    veth_xdp_xmit   6.45%
> >>>>
> >>>> Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
> >>>> ---
> >>>>   drivers/net/veth.c | 26 +++++++++++++++++++++++++-
> >>>>   1 file changed, 25 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> >>>> index 52110e5..4edc75f 100644
> >>>> --- a/drivers/net/veth.c
> >>>> +++ b/drivers/net/veth.c
> >>>> @@ -442,6 +442,23 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
> >>>>   	return ret;
> >>>>   }
> >>>>   
> >>>> +static void veth_xdp_flush_bq(struct net_device *dev)
> >>>> +{
> >>>> +	struct xdp_tx_bulk_queue *bq = this_cpu_ptr(&xdp_tx_bq);
> >>>> +	int sent, i, err = 0;
> >>>> +
> >>>> +	sent = veth_xdp_xmit(dev, bq->count, bq->q, 0);  
> >>>
> >>> Wait, veth_xdp_xmit() is just putting frames on a pointer ring. So
> >>> you're introducing an additional per-cpu bulk queue, only to avoid lock
> >>> contention around the existing pointer ring. But the pointer ring is
> >>> per-rq, so if you have lock contention, this means you must have
> >>> multiple CPUs servicing the same rq, no?  
> >>
> >> Yes, it's possible. Not recommended though.
> >>  
> > 
> > I think the general per-cpu TX bulk queue is overkill.  There is a loop
> > over packets in veth_xdp_rcv(struct veth_rq *rq, budget, *status), and
> > the caller veth_poll() will call veth_xdp_flush(rq->dev).
> > 
> > Why can't you store this "temp" bulk array in struct veth_rq ?  
> 
> Of course I can. But I thought tun has the same problem and we can 
> decrease memory footprint by sharing the same storage between devices.
> Or if other devices want to reduce queues so that we can use XDP on 
> many-cpu servers and introduce locks, we can use this storage for
> that case as well.
> 
> Still do you prefer veth-specific solution?

Yes.  Another reason is that with this shared/general per-cpu TX bulk
queue, I can easily see bugs resulting in xdp_frames getting
transmitted on a completely other NIC, which will be hard to debug for
people.

> > 
> > You could even alloc/create it on the stack of veth_poll() and send
> > it along via a pointer to veth_xdp_rcv).

IHMO it would be cleaner code wise to place the "temp" bulk array in
struct veth_rq.  But if you worry about performance and want a hot
cacheline for this, then you could just use the call-stack for
veth_poll(), as I described.  It should not be too ugly code wise to do
this I think.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
