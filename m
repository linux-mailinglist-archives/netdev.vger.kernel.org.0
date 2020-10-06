Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE6A284726
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 09:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgJFHaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 03:30:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59716 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726769AbgJFHaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 03:30:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601969433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kFgbWUxLO3HjEne5ObZQxZp4HFI6IlgnTKpMl2lgCeQ=;
        b=Y54jWPMTX+HQ0oshlMaXW2ippj9MGzRrWB2KDRkez6EYM5xfHLEoh3otr7BUQgvjjIsiFz
        Qqd3+/XnxxNDUvISpQOxb323k3bIc7TcQd1Jlrw+V17V/lBTcCqXJXv3I1KSybjNISVfsH
        qQsSaf6yNlBBXwktZOzlV4zUfNmvl6g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-6_or9DhLMlu5tzwliT_lAQ-1; Tue, 06 Oct 2020 03:30:30 -0400
X-MC-Unique: 6_or9DhLMlu5tzwliT_lAQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1C461015CA1;
        Tue,  6 Oct 2020 07:30:28 +0000 (UTC)
Received: from carbon (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 490CE19C4F;
        Tue,  6 Oct 2020 07:30:13 +0000 (UTC)
Date:   Tue, 6 Oct 2020 09:30:11 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        shayagr@amazon.com, sameehj@amazon.com, dsahern@kernel.org,
        Eelco Chaudron <echaudro@redhat.com>, brouer@redhat.com,
        Tirthendu Sarkar <tirtha@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [PATCH v4 bpf-next 00/13] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20201006093011.36375745@carbon>
In-Reply-To: <5f7bf2b0bf899_4f19a2083f@john-XPS-13-9370.notmuch>
References: <cover.1601648734.git.lorenzo@kernel.org>
        <5f77467dbc1_38b0208ef@john-XPS-13-9370.notmuch>
        <20201002160623.GA40027@lore-desk>
        <5f776c14d69b3_a6402087e@john-XPS-13-9370.notmuch>
        <20201005115247.72429157@carbon>
        <5f7b8e7a5ebfc_4f19a208ba@john-XPS-13-9370.notmuch>
        <20201005222454.GB3501@localhost.localdomain>
        <5f7bf2b0bf899_4f19a2083f@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 05 Oct 2020 21:29:36 -0700
John Fastabend <john.fastabend@gmail.com> wrote:

> Lorenzo Bianconi wrote:
> > [...]
> >   
> > > 
> > > In general I see no reason to populate these fields before the XDP
> > > program runs. Someone needs to convince me why having frags info before
> > > program runs is useful. In general headers should be preserved and first
> > > frag already included in the data pointers. If users start parsing further
> > > they might need it, but this series doesn't provide a way to do that
> > > so IMO without those helpers its a bit difficult to debate.  
> > 
> > We need to populate the skb_shared_info before running the xdp program in order to
> > allow the ebpf sanbox to access this data. If we restrict the access to the first
> > buffer only I guess we can avoid to do that but I think there is a value allowing
> > the xdp program to access this data.  
> 
> I agree. We could also only populate the fields if the program accesses
> the fields.

Notice, a driver will not initialize/use the shared_info area unless
there are more segments.  And (we have already established) the xdp->mb
bit is guarding BPF-prog from accessing shared_info area. 

> > A possible optimization can be access the shared_info only once before running
> > the ebpf program constructing the shared_info using a struct allocated on the
> > stack.  
> 
> Seems interesting, might be a good idea.

It *might* be a good idea ("alloc" shared_info on stack), but we should
benchmark this.  The prefetch trick might be fast enough.  But also
keep in mind the performance target, as with large size frames the
packet-per-sec we need to handle dramatically drop.


The TSO statement, I meant LRO (Large Receive Offload), but I want the
ability to XDP-redirect this frame out another netdev as TSO.  This
does means that we need more than 3 pages (2 frags slots) to store LRO
frames.  Thus, if we store this shared_info on the stack it might need
to be larger than we like.



> > Moreover we can define a "xdp_shared_info" struct to alias the skb_shared_info
> > one in order to have most on frags elements in the first "shared_info" cache line.
> >   
> > > 
> > > Specifically for XDP_TX case we can just flip the descriptors from RX
> > > ring to TX ring and keep moving along. This is going to be ideal on
> > > 40/100Gbps nics.

I think both approaches will still allow to do these page-flips.

> > > I'm not arguing that its likely possible to put some prefetch logic
> > > in there and keep the pipe full, but I would need to see that on
> > > a 100gbps nic to be convinced the details here are going to work. Or
> > > at minimum a 40gbps nic.

I'm looking forward to see how this performs on faster NICs.  Once we
have a high-speed NIC driver with this I can also start doing testing
in my testlab.


> > [...]
> >   
> > > Not against it, but these things are a bit tricky. Couple things I still
> > > want to see/understand
> > > 
> > >  - Lets see a 40gbps use a prefetch and verify it works in practice
> > >  - Explain why we can't just do this after XDP program runs  
> > 
> > how can we allow the ebpf program to access paged data if we do not do that?  
> 
> I don't see an easy way, but also this series doesn't have the data
> access support.

Eelco (Cc'ed) are working on patches that allow access to data in these
fragments, so far internal patches, which (sorry to mention) got
shutdown in internal review.


> Its hard to tell until we get at least a 40gbps nic if my concern about
> performance is real or not. Prefetching smartly could resolve some of the
> issue I guess.
> 
> If the Intel folks are working on it I think waiting would be great. Otherwise
> at minimum drop the helpers and be prepared to revert things if needed.

I do think it makes sense to drop the helpers for now, and focus on how
this new multi-buffer frame type is handled in the existing code, and do
some benchmarking on higher speed NIC, before the BPF-helper start to
lockdown/restrict what we can change/revert as they define UAPI.

E.g. existing code that need to handle this is existing helper
bpf_xdp_adjust_tail, which is something I have broad up before and even
described in[1].  Lets make sure existing code works with proposed
design, before introducing new helpers (and this makes it easier to
revert).

[1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org#xdp-tail-adjust
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

