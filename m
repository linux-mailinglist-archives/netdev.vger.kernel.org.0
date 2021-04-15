Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB02360EDE
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 17:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhDOPXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 11:23:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233955AbhDOPW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 11:22:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618500122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MZm3sT+wl0tySXaGHL4vidpYauK3I6jNjHgWrk7zB9I=;
        b=TFF05OKpCXFU8A+YiW0B8mV/8qxMwrcSMLuL8JjWvwqZjGcmWhMnkBwdAOPxZ+XqKlXRg3
        Zu5RFyqLF0mcg7AmvdcImmfvlBSfAIwFPAemro893zAkiHJ3oZyFN4s4F6QbErBsZyMPsh
        o2Ft2GZx0XJjHL3Gvw3FuOUGXNBgQvI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-9RQ-p9OiM5eHucmGpBfPVw-1; Thu, 15 Apr 2021 11:22:00 -0400
X-MC-Unique: 9RQ-p9OiM5eHucmGpBfPVw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE57D79EC2;
        Thu, 15 Apr 2021 15:21:58 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A00A76064B;
        Thu, 15 Apr 2021 15:21:50 +0000 (UTC)
Date:   Thu, 15 Apr 2021 17:21:48 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        song@kernel.org, brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next] cpumap: bulk skb using
 netif_receive_skb_list
Message-ID: <20210415172148.4f1e2440@carbon>
In-Reply-To: <252403c5-d3a7-03fb-24c3-0f328f8f8c70@iogearbox.net>
References: <bb627106428ea3223610f5623142c24270f0e14e.1618330734.git.lorenzo@kernel.org>
        <252403c5-d3a7-03fb-24c3-0f328f8f8c70@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 17:05:36 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 4/13/21 6:22 PM, Lorenzo Bianconi wrote:
> > Rely on netif_receive_skb_list routine to send skbs converted from
> > xdp_frames in cpu_map_kthread_run in order to improve i-cache usage.
> > The proposed patch has been tested running xdp_redirect_cpu bpf sample
> > available in the kernel tree that is used to redirect UDP frames from
> > ixgbe driver to a cpumap entry and then to the networking stack.
> > UDP frames are generated using pkt_gen.
> > 
> > $xdp_redirect_cpu  --cpu <cpu> --progname xdp_cpu_map0 --dev <eth>
> > 
> > bpf-next: ~2.2Mpps
> > bpf-next + cpumap skb-list: ~3.15Mpps
> > 
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> > Changes since v1:
> > - fixed comment
> > - rebased on top of bpf-next tree
> > ---
> >   kernel/bpf/cpumap.c | 11 +++++------
> >   1 file changed, 5 insertions(+), 6 deletions(-)
> > 
> > diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> > index 0cf2791d5099..d89551a508b2 100644
> > --- a/kernel/bpf/cpumap.c
> > +++ b/kernel/bpf/cpumap.c
> > @@ -27,7 +27,7 @@
> >   #include <linux/capability.h>
> >   #include <trace/events/xdp.h>
> >   
> > -#include <linux/netdevice.h>   /* netif_receive_skb_core */
> > +#include <linux/netdevice.h>   /* netif_receive_skb_list */
> >   #include <linux/etherdevice.h> /* eth_type_trans */
> >   
> >   /* General idea: XDP packets getting XDP redirected to another CPU,
> > @@ -257,6 +257,7 @@ static int cpu_map_kthread_run(void *data)
> >   		void *frames[CPUMAP_BATCH];
> >   		void *skbs[CPUMAP_BATCH];
> >   		int i, n, m, nframes;
> > +		LIST_HEAD(list);
> >   
> >   		/* Release CPU reschedule checks */
> >   		if (__ptr_ring_empty(rcpu->queue)) {
> > @@ -305,7 +306,6 @@ static int cpu_map_kthread_run(void *data)
> >   		for (i = 0; i < nframes; i++) {
> >   			struct xdp_frame *xdpf = frames[i];
> >   			struct sk_buff *skb = skbs[i];
> > -			int ret;
> >   
> >   			skb = __xdp_build_skb_from_frame(xdpf, skb,
> >   							 xdpf->dev_rx);
> > @@ -314,11 +314,10 @@ static int cpu_map_kthread_run(void *data)
> >   				continue;
> >   			}
> >   
> > -			/* Inject into network stack */
> > -			ret = netif_receive_skb_core(skb);
> > -			if (ret == NET_RX_DROP)
> > -				drops++;
> > +			list_add_tail(&skb->list, &list);
> >   		}
> > +		netif_receive_skb_list(&list);
> > +
> >   		/* Feedback loop via tracepoint */
> >   		trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched, &stats);  
> 
> Given we stop counting drops with the netif_receive_skb_list(), we should then
> also remove drops from trace_xdp_cpumap_kthread(), imho, as otherwise it is rather
> misleading (as in: drops actually happening, but 0 are shown from the tracepoint).
> Given they are not considered stable API, I would just remove those to make it clear
> to users that they cannot rely on this counter anymore anyway.

After Lorenzo's change, the 'drops' still count if kmem_cache_alloc_bulk
cannot alloc SKBs.  I guess that will not occur very often.  But how
can people/users debug such a case?  Maybe the MM-layer can tell us?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

