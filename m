Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B732004F5
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 11:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730078AbgFSJYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 05:24:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27992 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725290AbgFSJYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 05:24:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592558678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hp3NeSoFfZ/4WVDuOSbV9gzqUH6WXiy9T/cVvrRY8zc=;
        b=dviCksral308P7q4akKwSy4ihLpOV3ow4uB1UdUyZ2dVWOrBFSxUV9v8AEFTNNMUP87S8O
        4JWXls52gBybKKGqnjqEAE4BUCyv2cKyo15Kw8jaPt1jKgqnxMCIibq1hdLd5VixSHS542
        S4idS1BdDV7EBRTnXeuIKX6dCicahWo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-kYIjQaWCNp2whwjo7PXgOA-1; Fri, 19 Jun 2020 05:24:33 -0400
X-MC-Unique: kYIjQaWCNp2whwjo7PXgOA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8B738035DE;
        Fri, 19 Jun 2020 09:24:31 +0000 (UTC)
Received: from ovpn-115-30.ams2.redhat.com (ovpn-115-30.ams2.redhat.com [10.36.115.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94B4D196F8;
        Fri, 19 Jun 2020 09:24:30 +0000 (UTC)
Message-ID: <ef10f10b8b339320f5fd8c26f8482b57cafe8194.camel@redhat.com>
Subject: Re: [RFC PATCH] net/sched: add indirect call wrapper hint.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Date:   Fri, 19 Jun 2020 11:24:29 +0200
In-Reply-To: <0240746c-1dd1-4822-261c-03ff13854db2@gmail.com>
References: <da175b76ca89e57876cf55d3d56aef126054d12c.1592501362.git.pabeni@redhat.com>
         <0240746c-1dd1-4822-261c-03ff13854db2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-06-18 at 12:00 -0700, Eric Dumazet wrote:
> 
> On 6/18/20 10:31 AM, Paolo Abeni wrote:
> > The sched layer can use several indirect calls per
> > packet, with not work-conservative qdisc being
> > more affected due to the lack of the BYPASS path.
> > 
> > This change tries to improve the situation using
> > the indirect call wrappers infrastructure for the
> > qdisc enqueue end dequeue indirect calls.
> > 
> > To cope with non-trivial scenarios, a compile-time know is
> > introduced, so that the qdisc used by ICW can be different
> > from the default one.
> > 
> > Tested with pktgen over qdisc, with CONFIG_HINT_FQ_CODEL=y:
> > 
> > qdisc		threads vanilla	patched delta
> > 		nr	Kpps	Kpps	%
> > pfifo_fast	1	3300	3700	12
> > pfifo_fast	2	3940	4070	3
> > fq_codel	1	3840	4110	7
> > fq_codel	2	1920	2260	17
> > fq		1	2230	2210	-1
> > fq		2	1530	1540	1
> 
> Hi Paolo
> 
> This test is a bit misleading, pktgen has a way to bypass the qdisc.

The above figures were collected using the 
pktgen_bench_xmit_mode_queue_xmit.sh script, which in turn uses
'xmit_mode queue_xmit': packets traverse the qdisc layer via the usual
dev_queue_xmit()

> Real numbers for more typical workloads would be more appealing,
> before we consider a quite invasive patch ?

I'll add figures for netperf UDP single threaded/many threads...

> What is the status of static_call infrastructure ?

... unless you prefer waiting for the above. AFAICS, that is under
discussion. v4 was posted in May[1] and collected quite a bit of
feedback.

> >  
> > +#ifndef CODEL_SCOPE
> > +#define CODEL_SCOPE static
> > +#endif
> 
> This looks additional burden, just remove the static attribute,
> if a function might be called directly.

Yep, that will slim down the patch a bit, I will do. 

Thanks for the feedback,

Paolo

[1] https://lwn.net/ml/linux-kernel/20200501202849.647891881@infradead.org/

