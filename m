Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C6227E27
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 15:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbfEWN3m convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 May 2019 09:29:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65062 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729698AbfEWN3m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 09:29:42 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 09D0C30605EF;
        Thu, 23 May 2019 13:29:42 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FD2617A75;
        Thu, 23 May 2019 13:29:28 +0000 (UTC)
Date:   Thu, 23 May 2019 15:29:27 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH bpf-next 3/3] veth: Support bulk XDP_TX
Message-ID: <20190523152927.14bf7ed1@carbon>
In-Reply-To: <599302b2-96d2-b571-01ee-f4914acaf765@lab.ntt.co.jp>
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
        <1558609008-2590-4-git-send-email-makita.toshiaki@lab.ntt.co.jp>
        <87zhnd1kg9.fsf@toke.dk>
        <599302b2-96d2-b571-01ee-f4914acaf765@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 23 May 2019 13:29:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 20:35:50 +0900
Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> wrote:

> On 2019/05/23 20:25, Toke Høiland-Jørgensen wrote:
> > Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> writes:
> >   
> >> This improves XDP_TX performance by about 8%.
> >>
> >> Here are single core XDP_TX test results. CPU consumptions are taken
> >> from "perf report --no-child".
> >>
> >> - Before:
> >>
> >>   7.26 Mpps
> >>
> >>   _raw_spin_lock  7.83%
> >>   veth_xdp_xmit  12.23%
> >>
> >> - After:
> >>
> >>   7.84 Mpps
> >>
> >>   _raw_spin_lock  1.17%
> >>   veth_xdp_xmit   6.45%
> >>
> >> Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
> >> ---
> >>  drivers/net/veth.c | 26 +++++++++++++++++++++++++-
> >>  1 file changed, 25 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> >> index 52110e5..4edc75f 100644
> >> --- a/drivers/net/veth.c
> >> +++ b/drivers/net/veth.c
> >> @@ -442,6 +442,23 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
> >>  	return ret;
> >>  }
> >>  
> >> +static void veth_xdp_flush_bq(struct net_device *dev)
> >> +{
> >> +	struct xdp_tx_bulk_queue *bq = this_cpu_ptr(&xdp_tx_bq);
> >> +	int sent, i, err = 0;
> >> +
> >> +	sent = veth_xdp_xmit(dev, bq->count, bq->q, 0);  
> > 
> > Wait, veth_xdp_xmit() is just putting frames on a pointer ring. So
> > you're introducing an additional per-cpu bulk queue, only to avoid lock
> > contention around the existing pointer ring. But the pointer ring is
> > per-rq, so if you have lock contention, this means you must have
> > multiple CPUs servicing the same rq, no?  
> 
> Yes, it's possible. Not recommended though.
> 

I think the general per-cpu TX bulk queue is overkill.  There is a loop
over packets in veth_xdp_rcv(struct veth_rq *rq, budget, *status), and
the caller veth_poll() will call veth_xdp_flush(rq->dev).

Why can't you store this "temp" bulk array in struct veth_rq ?

You could even alloc/create it on the stack of veth_poll() and send it
along via a pointer to veth_xdp_rcv).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
