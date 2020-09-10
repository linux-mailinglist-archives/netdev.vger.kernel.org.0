Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A026E264982
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgIJQRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:17:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726812AbgIJQOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:14:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599754454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I/JEit0Y+z2kGBXmX9yEDNU8+MRltzwiabbTAxnC+CA=;
        b=csqqsjyHFK5KBjAUXpZIQZW2OBGvgm7Lt2M6peHeooy6LWPAks4qNVAZKKiObpO37vx0ly
        oHzBEmWV6P5i7iFSU4GjvbBhQdqVjX1Vy4lwGb8mXo9iDqnXWUzhVSBxd/dl0DubE3GD23
        rIFUyhlW9JiQ6zFDOEbWziT4ErV5NW0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11--cWEqQ_IOYuJnqPkUh_cdA-1; Thu, 10 Sep 2020 12:14:08 -0400
X-MC-Unique: -cWEqQ_IOYuJnqPkUh_cdA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E63201007B00;
        Thu, 10 Sep 2020 16:14:06 +0000 (UTC)
Received: from ovpn-113-172.ams2.redhat.com (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A61205C221;
        Thu, 10 Sep 2020 16:14:05 +0000 (UTC)
Message-ID: <39a00c2183ef5bc349ce1195fdac53be2e26af6d.camel@redhat.com>
Subject: Re: [PATCH net-next] net: try to avoid unneeded backlog flush
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
Date:   Thu, 10 Sep 2020 18:14:04 +0200
In-Reply-To: <CANn89iLOJVjsmrefxRvzyiEejhKAstXTWzqiftYH=_hn=irp+g@mail.gmail.com>
References: <0d64ac9b321104d58270822c204845ccb31368f8.1599747321.git.pabeni@redhat.com>
         <CANn89iLOJVjsmrefxRvzyiEejhKAstXTWzqiftYH=_hn=irp+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 2020-09-10 at 16:36 +0200, Eric Dumazet wrote:
> On Thu, Sep 10, 2020 at 4:21 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > flush_all_backlogs() may cause deadlock on systems
> > running processes with FIFO scheduling policy.
> > 
> > The above is critical in -RT scenarios, where user-space
> > specifically ensure no network activity is scheduled on
> > the CPU running the mentioned FIFO process, but still get
> > stuck.
> > 
> > This commit tries to address the problem checking the
> > backlog status on the remote CPUs before scheduling the
> > flush operation. If the backlog is empty, we can skip it.
> 
> If it is not empty, the problem you want to fix is still there ?

Thank you for the very prompt feedback!

Yes, if the backlog is not empty (meaning the user space as failed to
configure the kernel correctly), device removal could still hang. 

The problem currently seen by the RT team is that they really ensure no
network activity is scheduled on the relevant CPU, but still see the
hang.

I think to to expose with a follow-up patch the backlog len for each
CPU - read-only via net-procfs - to the user-space.

> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  net/core/dev.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 46 insertions(+), 4 deletions(-)
> > 
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 152ad3b578de..fdef40bf4b88 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -5621,17 +5621,59 @@ static void flush_backlog(struct work_struct *work)
> >         local_bh_enable();
> >  }
> > 
> > +static bool flush_required(int cpu)
> > +{
> > +#if IS_ENABLED(CONFIG_RPS)
> > +       struct softnet_data *sd = &per_cpu(softnet_data, cpu);
> > +       bool do_flush;
> > +
> > +       local_irq_disable();
> > +       rps_lock(sd);
> > +
> > +       /* as insertion into process_queue happens with the rps lock held,
> > +        * process_queue access may race only with dequeue
> > +        */
> > +       do_flush = !skb_queue_empty(&sd->input_pkt_queue) ||
> > +                  !skb_queue_empty_lockless(&sd->process_queue);
> > +       rps_unlock(sd);
> > +       local_irq_enable();
> > +
> > +       return do_flush;
> > +#endif
> > +       /* without RPS we can't safely check input_pkt_queue: during a
> > +        * concurrent remote skb_queue_splice() we can detect as empty both
> > +        * input_pkt_queue and process_queue even if the latter could end-up
> > +        * containing a lot of packets.
> > +        */
> > +       return true;
> > +}
> > +
> >  static void flush_all_backlogs(void)
> >  {
> > +       static cpumask_t flush_cpus  = { CPU_BITS_NONE };
> >         unsigned int cpu;
> > 
> > +       /* since we are under rtnl lock protection we can use static data
> > +        * for the cpumask and avoid allocating on stack the possibly
> > +        * large mask
> > +        */
> > +       ASSERT_RTNL();
> > +
> 
> OK, but you only set bits in this bitmask.
> 
> You probably want to clear it here, not rely on one time CPU_BITS_NONE

Thanks! will do in v2. I'll also need to improve my local tests, as the
above should not have escaped them.

Cheers,

Paolo

