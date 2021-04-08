Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B53358C13
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 20:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbhDHSVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 14:21:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232287AbhDHSVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 14:21:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617906058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pT8CvBydo1jfCeR1V2jxAI3YYezDelf8vI+96e7B6ik=;
        b=cDPGeD/E7U5pUiThY9vqXVEUAAXsULWk946P6CTO6T+nYQY5bq5KWWvZhZRsi0Y+ITQE7i
        9Ph375mtJTuWPkTM9iIaneQy5zvKgj9Pj6nkJilm3mVTE/GnbUaJM2hWMsoGOo+6RRAwDJ
        pp25Y0enKrvfaDWAcYal3zPlAs2yzhY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-UbNX9G3qNWaA-GMYYUqGtw-1; Thu, 08 Apr 2021 14:20:55 -0400
X-MC-Unique: UbNX9G3qNWaA-GMYYUqGtw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D7CB8030C4;
        Thu,  8 Apr 2021 18:20:53 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85D045D9DC;
        Thu,  8 Apr 2021 18:20:42 +0000 (UTC)
Date:   Thu, 8 Apr 2021 20:20:41 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Song Liu <song@kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, brouer@redhat.com
Subject: Re: [PATCH bpf-next] cpumap: bulk skb using netif_receive_skb_list
Message-ID: <20210408202041.720ec643@carbon>
In-Reply-To: <YG7Wi/vFK+XFBUcQ@lore-desk>
References: <e01b1a562c523f64049fa45da6c031b0749ca412.1617267115.git.lorenzo@kernel.org>
        <CAPhsuW4QTOgC+fDYRZnVwWtt3NTS9D+56mpP04Kh3tHrkD7G1A@mail.gmail.com>
        <YGX5j7RDQIXlh69L@lore-desk>
        <CAPhsuW7ih9ULA=aq0G7Ka+15KfSWgyuLXD_BxTUcRhn8++UNoQ@mail.gmail.com>
        <YG7Wi/vFK+XFBUcQ@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Apr 2021 12:10:19 +0200
Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> > On Thu, Apr 1, 2021 at 9:49 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:  
> > >  
> > > > On Thu, Apr 1, 2021 at 1:57 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:  
> > > > >  
> > >
> > > [...]
> > >  
> > > > > -                       /* Inject into network stack */
> > > > > -                       ret = netif_receive_skb_core(skb);
> > > > > -                       if (ret == NET_RX_DROP)
> > > > > -                               drops++;  
> > > >
> > > > I guess we stop tracking "drops" with this patch?
> > > >
> > > > Thanks,
> > > > Song  
> > >
> > > Hi Song,
> > >
> > > we do not report the packets dropped by the stack but we still count the drops
> > > in the cpumap. If you think they are really important I guess we can change
> > > return value of netif_receive_skb_list returning the dropped packets or
> > > similar. What do you think?  
> > 
> > I think we shouldn't silently change the behavior of the tracepoint below:
> > 
> > trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched, &stats);
> > 
> > Returning dropped packets from netif_receive_skb_list() sounds good to me.  
> 
> Hi Song,
> 
> I reviewed the netif_receive_skb_list() and I guess the code needed to count
> number of dropped frames is a bit intrusive and we need to add some checks
> in the hot path.
> Moreover the dropped frames are already accounted in the networking stack
> (e.g. mib counters for the ip traffic).
> Since drop counter is just exported in a tracepoint in cpu_map_kthread_run,
> I guess we can just not count dropped packets in the networking stack here
> and rely on the mib counters. What do you think?
> 
> @Jesper: since you added the original code, what do you think about it?

I'm actually fine with not counting the drops in the tracepoint.

As you say it is already accounted elsewere in MIB counters for the
network stack.  Which is actually better, as having this drop counter
in tracepoint have confused people before (when using xdp_redirect_cpu).
If they instead looked at the MIB counters, it should be easier to
understand why the drop happens.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

