Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA01216E96
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 16:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgGGOSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 10:18:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21280 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727962AbgGGOSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 10:18:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594131523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h8kfVniZWiVVu/oKiOpIxaI4NJX/9MflF7cI1fe2hxw=;
        b=NpeMuGoRP6aLiy1+BOlRzUK0Ncq9CDbeHEYatvub7I1KS+TrzlNKKYnsHNiljSFpXKHoq/
        waRGQCME5N/B77w5yZNYjkWS6WJ2v7FIQ3EarM6ukdKVsyVGi5UiQ5FJDHwv+GJu1uSEah
        rgM1MQeMaICfoYbQefaNOmb39Y5oJWM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-06ZZwhG3MNuqPzddtPf18Q-1; Tue, 07 Jul 2020 10:18:41 -0400
X-MC-Unique: 06ZZwhG3MNuqPzddtPf18Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB4F8461;
        Tue,  7 Jul 2020 14:18:39 +0000 (UTC)
Received: from ovpn-114-17.ams2.redhat.com (ovpn-114-17.ams2.redhat.com [10.36.114.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97F035BAC3;
        Tue,  7 Jul 2020 14:18:37 +0000 (UTC)
Message-ID: <e54b0fe2ab12f6d078cdc6540f03478c32fe5735.camel@redhat.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
From:   Paolo Abeni <pabeni@redhat.com>
To:     Josh Hunt <johunt@akamai.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Date:   Tue, 07 Jul 2020 16:18:36 +0200
In-Reply-To: <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
         <20200623134259.8197-1-mzhivich@akamai.com>
         <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
         <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
         <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
         <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com>
         <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
         <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-07-02 at 11:08 -0700, Josh Hunt wrote:
> On 7/2/20 2:45 AM, Paolo Abeni wrote:
> > Hi all,
> > 
> > On Thu, 2020-07-02 at 08:14 +0200, Jonas Bonn wrote:
> > > Hi Cong,
> > > 
> > > On 01/07/2020 21:58, Cong Wang wrote:
> > > > On Wed, Jul 1, 2020 at 9:05 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > On Tue, Jun 30, 2020 at 2:08 PM Josh Hunt <johunt@akamai.com> wrote:
> > > > > > Do either of you know if there's been any development on a fix for this
> > > > > > issue? If not we can propose something.
> > > > > 
> > > > > If you have a reproducer, I can look into this.
> > > > 
> > > > Does the attached patch fix this bug completely?
> > > 
> > > It's easier to comment if you inline the patch, but after taking a quick
> > > look it seems too simplistic.
> > > 
> > > i)  Are you sure you haven't got the return values on qdisc_run reversed?
> > 
> > qdisc_run() returns true if it was able to acquire the seq lock. We
> > need to take special action in the opposite case, so Cong's patch LGTM
> > from a functional PoV.
> > 
> > > ii) There's a "bypass" path that skips the enqueue/dequeue operation if
> > > the queue is empty; that needs a similar treatment:  after releasing
> > > seqlock it needs to ensure that another packet hasn't been enqueued
> > > since it last checked.
> > 
> > That has been reverted with
> > commit 379349e9bc3b42b8b2f8f7a03f64a97623fff323
> > 
> > ---
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 90b59fc50dc9..c7e48356132a 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -3744,7 +3744,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
> > > 
> > >   	if (q->flags & TCQ_F_NOLOCK) {
> > >   		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
> > > -		qdisc_run(q);
> > > +		if (!qdisc_run(q) && rc == NET_XMIT_SUCCESS)
> > > +			__netif_schedule(q);
> > 
> > I fear the __netif_schedule() call may cause performance regression to
> > the point of making a revert of TCQ_F_NOLOCK preferable. I'll try to
> > collect some data.
> 
> Initial results with Cong's patch look promising, so far no stalls. We 
> will let it run over the long weekend and report back on Tuesday.
> 
> Paolo - I have concerns about possible performance regression with the 
> change as well. If you can gather some data that would be great. 

I finally had the time to run some performance tests vs the above with
mixed results.

Using several netperf threadsover a single pfifo_fast queue with small
UDP packets, perf differences vs vanilla are just above noise range (1-
1,5%)

Using pktgen in 'queue_xmit' mode on a dummy device (this should
maximise the pkt-rate and thus the contention) I see:

pktgen threads	vanilla		patched		delta
nr		kpps		kpps		%

1		3240		3240		0
2		3910		2710		-30.5
4		5140		4920		-4

A relevant source of the measured overhead is due to the contention on
q->state in __netif_schedule, so the following helps a bit:

---
diff --git a/net/core/dev.c b/net/core/dev.c
index b8e8286a0a34..3cad6e086fac 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3750,7 +3750,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 
        if (q->flags & TCQ_F_NOLOCK) {
                rc = q->enqueue(skb, q, NULL, &to_free) & NET_XMIT_MASK;
-               if (!qdisc_run(q) && rc == NET_XMIT_SUCCESS)
+               if (!qdisc_run(q) && rc == NET_XMIT_SUCCESS &&
+                   !test_bit(__QDISC_STATE_SCHED, &q->state))
                        __netif_schedule(q);
 
                if (unlikely(to_free))
---

With the above incremental patch applied I see:
pktgen threads	vanilla		patched[II]	delta
nr		kpps		kpps		%
1		3240		3240		0
2		3910		2830		-27%
4		5140		5140		0

So the regression with 2 pktgen threads is still relevant. 'perf' shows
relevant time spent into net_tx_action() and __netif_schedule().

Cheers,

Paolo.

