Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932A72833A5
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 11:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgJEJxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 05:53:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25162 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725887AbgJEJxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 05:53:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601891581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V9Nec+YykbrmtrrSug4z328cCcm80LO+iMyeCo1L8VA=;
        b=hXfqOfA42hcawQhOsu1cuZ6XzspTRiSuHqrXNHS6/KOC6Tso/kSVrL7y6Sw8bJ8DuabYd/
        NcNiMYHIQrMMVsoaGr7tjTRRCUh5jplUrsMyeG8gpwx+mboDJUA8bBjOjTfFE8FTzfVj96
        qFk9stp8uq2evruzM6QvCbThhwy+YDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-E00guPkiPwO8P1ETtkhh3Q-1; Mon, 05 Oct 2020 05:52:59 -0400
X-MC-Unique: E00guPkiPwO8P1ETtkhh3Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80172100A246;
        Mon,  5 Oct 2020 09:52:57 +0000 (UTC)
Received: from carbon (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F96278814;
        Mon,  5 Oct 2020 09:52:48 +0000 (UTC)
Date:   Mon, 5 Oct 2020 11:52:47 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, dsahern@kernel.org, echaudro@redhat.com,
        brouer@redhat.com
Subject: Re: [PATCH v4 bpf-next 00/13] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20201005115247.72429157@carbon>
In-Reply-To: <5f776c14d69b3_a6402087e@john-XPS-13-9370.notmuch>
References: <cover.1601648734.git.lorenzo@kernel.org>
        <5f77467dbc1_38b0208ef@john-XPS-13-9370.notmuch>
        <20201002160623.GA40027@lore-desk>
        <5f776c14d69b3_a6402087e@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 02 Oct 2020 11:06:12 -0700
John Fastabend <john.fastabend@gmail.com> wrote:

> Lorenzo Bianconi wrote:
> > > Lorenzo Bianconi wrote:  
> > > > This series introduce XDP multi-buffer support. The mvneta driver is
> > > > the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> > > > please focus on how these new types of xdp_{buff,frame} packets
> > > > traverse the different layers and the layout design. It is on purpose
> > > > that BPF-helpers are kept simple, as we don't want to expose the
> > > > internal layout to allow later changes.
> > > > 
> > > > For now, to keep the design simple and to maintain performance, the XDP
> > > > BPF-prog (still) only have access to the first-buffer. It is left for
> > > > later (another patchset) to add payload access across multiple buffers.
> > > > This patchset should still allow for these future extensions. The goal
> > > > is to lift the XDP MTU restriction that comes with XDP, but maintain
> > > > same performance as before.
> > > > 
> > > > The main idea for the new multi-buffer layout is to reuse the same
> > > > layout used for non-linear SKB. This rely on the "skb_shared_info"
> > > > struct at the end of the first buffer to link together subsequent
> > > > buffers. Keeping the layout compatible with SKBs is also done to ease
> > > > and speedup creating an SKB from an xdp_{buff,frame}. Converting
> > > > xdp_frame to SKB and deliver it to the network stack is shown in cpumap
> > > > code (patch 13/13).  
> > > 
> > > Using the end of the buffer for the skb_shared_info struct is going to
> > > become driver API so unwinding it if it proves to be a performance issue
> > > is going to be ugly. So same question as before, for the use case where
> > > we receive packet and do XDP_TX with it how do we avoid cache miss
> > > overhead? This is not just a hypothetical use case, the Facebook
> > > load balancer is doing this as well as Cilium and allowing this with
> > > multi-buffer packets >1500B would be useful.
> > > 
> > > Can we write the skb_shared_info lazily? It should only be needed once
> > > we know the packet is going up the stack to some place that needs the
> > > info. Which we could learn from the return code of the XDP program.  
> > 
> > Hi John,  
> 
> Hi, I'll try to join the two threads this one and the one on helpers here
> so we don't get too fragmented.
> 
> > 
> > I agree, I think for XDP_TX use-case it is not strictly necessary to fill the
> > skb_hared_info. The driver can just keep this info on the stack and use it
> > inserting the packet back to the DMA ring.
> > For mvneta I implemented it in this way to keep the code aligned with ndo_xdp_xmit
> > path since it is a low-end device. I guess we are not introducing any API constraint
> > for XDP_TX. A high-end device can implement multi-buff for XDP_TX in a different way
> > in order to avoid the cache miss.  
> 
> Agree it would be an implementation detail for XDP_TX except the two
> helpers added in this series currently require it to be there.

That is a good point.  If you look at the details, the helpers use
xdp_buff->mb bit to guard against accessing the "shared_info"
cacheline. Thus, for the normal single frame case XDP_TX should not see
a slowdown.  Do we really need to optimize XDP_TX multi-frame case(?)


> > 
> > We need to fill the skb_shared info only when we want to pass the frame to the
> > network stack (build_skb() can directly reuse skb_shared_info->frags[]) or for
> > XDP_REDIRECT use-case.  
> 
> It might be good to think about the XDP_REDIRECT case as well then. If the
> frags list fit in the metadata/xdp_frame would we expect better
> performance?

I don't like to use space in xdp_frame for this. (1) We (Ahern and I)
are planning to use the space in xdp_frame for RX-csum + RX-hash +vlan,
which will be more common (e.g. all packets will have HW RX+csum).  (2)
I consider XDP multi-buffer the exception case, that will not be used
in most cases, so why reserve space for that in this cache-line.

IMHO we CANNOT allow any slowdown for existing XDP use-cases, but IMHO
XDP multi-buffer use-cases are allowed to run "slower".


> Looking at skb_shared_info{} that is a rather large structure with many

A cache-line detail about skb_shared_info: The first frags[0] member is
in the first cache-line.  Meaning that it is still fast to have xdp
frames with 1 extra buffer.

> fields that look unnecessary for XDP_REDIRECT case and only needed when
> passing to the stack. 

Yes, I think we can use first cache-line of skb_shared_info more
optimally (via defining a xdp_shared_info struct). But I still want us
to use this specific cache-line.  Let me explain why below. (Avoiding
cache-line misses is all about the details, so I hope you can follow).

Hopefully most driver developers understand/knows this.  In the RX-loop
the current RX-descriptor have a status that indicate there are more
frame, usually expressed as non-EOP (End-Of-Packet).  Thus, a driver
can start a prefetchw of this shared_info cache-line, prior to
processing the RX-desc that describe the multi-buffer.
 (Remember this shared_info is constructed prior to calling XDP and any
XDP_TX action, thus the XDP prog should not see a cache-line miss when
using the BPF-helper to read shared_info area).


> Fundamentally, a frag just needs
> 
>  struct bio_vec {
>      struct page *bv_page;     // 8B
>      unsigned int bv_len;      // 4B
>      unsigned int bv_offset;   // 4B
>  } // 16B
> 
> With header split + data we only need a single frag so we could use just
> 16B. And worse case jumbo frame + header split seems 3 entries would be
> enough giving 48B (header plus 3 4k pages). 

For jumbo-frame 9000 MTU 2 entries might be enough, as we also have
room in the first buffer (((9000-(4096-256-320))/4096 = 1.33789).

The problem is that we need to support TSO (TCP Segmentation Offload)
use-case, which can have more frames. Thus, 3 entries will not be
enough.

> Could we just stick this in the metadata and make it read only? Then
> programs that care can read it and get all the info they need without
> helpers.

I don't see how that is possible. (1) the metadata area is only 32
bytes, (2) when freeing an xdp_frame the kernel need to know the layout
as these points will be free'ed.

> I would expect performance to be better in the XDP_TX and
> XDP_REDIRECT cases. And copying an extra worse case 48B in passing to
> the stack I guess is not measurable given all the work needed in that
> path.

I do agree, that when passing to netstack we can do a transformation
from xdp_shared_info to skb_shared_info with a fairly small cost.  (The
TSO case would require more copying).

Notice that allocating an SKB, will always clear the first 32 bytes of
skb_shared_info.  If the XDP driver-code path have done the prefetch
as described above, then we should see a speedup for netstack delivery.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

