Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA19366F55
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243564AbhDUPkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:40:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238880AbhDUPkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 11:40:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619019580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bVNum44dAUpgnvC+nvXv78yCMxeDErB6G4dWdidL3ZY=;
        b=WAlgfhwXKvJnl8OM5/VaLTFjVQydnXsTRsB/NjTN8+qFXxs7pT1UPUG1MIxSwdfpYVlaWb
        XPTIAoOKXY9cHZWpitGo8N5PuulHARjhE0FFi+ycKvNM72rlPOwnbF7z5+ZYvCUnDBY5Ml
        WLOIYAwbDWozQOb7t2pcOS5P2aiZONY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-0DfOuL98OdOOIP3D4PeMdA-1; Wed, 21 Apr 2021 11:39:37 -0400
X-MC-Unique: 0DfOuL98OdOOIP3D4PeMdA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC88B1008064;
        Wed, 21 Apr 2021 15:39:34 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F306B19726;
        Wed, 21 Apr 2021 15:39:22 +0000 (UTC)
Date:   Wed, 21 Apr 2021 17:39:21 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        sameehj@amazon.com, John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>, brouer@redhat.com
Subject: Re: [PATCH v8 bpf-next 00/14] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20210421173921.23fef6a7@carbon>
In-Reply-To: <CAJ8uoz3ROiPn+-bh7OjFOjXjXK9xGhU5cxWoFPM9JoYeh=zw=g@mail.gmail.com>
References: <cover.1617885385.git.lorenzo@kernel.org>
        <CAJ8uoz1MOYLzyy7xXq_fmpKDEakxSomzfM76Szjr5gWsqHc9jQ@mail.gmail.com>
        <20210418181801.17166935@carbon>
        <CAJ8uoz0m8AAJFddn2LjehXtdeGS0gat7dwOLA_-_ZeOVYjBdxw@mail.gmail.com>
        <YH0pdXXsZ7IELBn3@lore-desk>
        <CAJ8uoz101VZiwuvM-bs4UdW+kFT5xjgdgUwPWHZn4ABEOkyQ-w@mail.gmail.com>
        <20210421144747.33c5f51f@carbon>
        <CAJ8uoz3ROiPn+-bh7OjFOjXjXK9xGhU5cxWoFPM9JoYeh=zw=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Apr 2021 16:12:32 +0200
Magnus Karlsson <magnus.karlsson@gmail.com> wrote:

> On Wed, Apr 21, 2021 at 2:48 PM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > On Tue, 20 Apr 2021 15:49:44 +0200
> > Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> >  
> > > On Mon, Apr 19, 2021 at 8:56 AM Lorenzo Bianconi
> > > <lorenzo.bianconi@redhat.com> wrote:  
> > > >  
> > > > > On Sun, Apr 18, 2021 at 6:18 PM Jesper Dangaard Brouer
> > > > > <brouer@redhat.com> wrote:  
> > > > > >
> > > > > > On Fri, 16 Apr 2021 16:27:18 +0200
> > > > > > Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > > > > >  
> > > > > > > On Thu, Apr 8, 2021 at 2:51 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:  
> > > > > > > >
> > > > > > > > This series introduce XDP multi-buffer support. The mvneta driver is
> > > > > > > > the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> > > > > > > > please focus on how these new types of xdp_{buff,frame} packets
> > > > > > > > traverse the different layers and the layout design. It is on purpose
> > > > > > > > that BPF-helpers are kept simple, as we don't want to expose the
> > > > > > > > internal layout to allow later changes.
> > > > > > > >
> > > > > > > > For now, to keep the design simple and to maintain performance, the XDP
> > > > > > > > BPF-prog (still) only have access to the first-buffer. It is left for
> > > > > > > > later (another patchset) to add payload access across multiple buffers.
> > > > > > > > This patchset should still allow for these future extensions. The goal
> > > > > > > > is to lift the XDP MTU restriction that comes with XDP, but maintain
> > > > > > > > same performance as before.  
> > > > > > [...]  
> > > > > > > >
> > > > > > > > [0] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k-mtu-and-rx-zerocopy
> > > > > > > > [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
> > > > > > > > [2] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-support-to-a-NIC-driver (XDPmulti-buffers section)  
> > > > > > >
> > > > > > > Took your patches for a test run with the AF_XDP sample xdpsock on an
> > > > > > > i40e card and the throughput degradation is between 2 to 6% depending
> > > > > > > on the setup and microbenchmark within xdpsock that is executed. And
> > > > > > > this is without sending any multi frame packets. Just single frame
> > > > > > > ones. Tirtha made changes to the i40e driver to support this new
> > > > > > > interface so that is being included in the measurements.  
> > > > > >
> > > > > > Could you please share Tirtha's i40e support patch with me?  
> > > > >
> > > > > We will post them on the list as an RFC. Tirtha also added AF_XDP
> > > > > multi-frame support on top of Lorenzo's patches so we will send that
> > > > > one out as well. Will also rerun my experiments, properly document
> > > > > them and send out just to be sure that I did not make any mistake.  
> > > >
> > > > ack, very cool, thx  
> > >
> > > I have now run a new set of experiments on a Cascade Lake server at
> > > 2.1 GHz with turbo boost disabled. Two NICs: i40e and ice. The
> > > baseline is commit 5c507329000e ("libbpf: Clarify flags in ringbuf
> > > helpers") and Lorenzo's and Eelco's path set is their v8. First some
> > > runs with xdpsock (i.e. AF_XDP) in both 2-core mode (app on one core
> > > and the driver on another) and 1-core mode using busy_poll.
> > >
> > > xdpsock rxdrop throughput change with the multi-buffer patches without
> > > any driver changes:
> > > 1-core i40e: -0.5 to 0%   2-cores i40e: -0.5%
> > > 1-core ice: -2%   2-cores ice: -1 to -0.5%
> > >
> > > xdp_rxq_info -a XDP_DROP
> > > i40e: -4%   ice: +8%
> > >
> > > xdp_rxq_info -a XDP_TX
> > > i40e: -10%   ice: +9%
> > >
> > > The XDP results with xdp_rxq_info are just weird! I reran them three
> > > times, rebuilt and rebooted in between and I always get the same
> > > results. And I also checked that I am running on the correct NUMA node
> > > and so on. But I have a hard time believing them. Nearly +10% and -10%
> > > difference. Too much in my book. Jesper, could you please run the same
> > > and see what you get?  
> >
> > We of-cause have to find the root-cause of the +-10%, but let me drill
> > into what the 10% represent time/cycle wise.  Using a percentage
> > difference is usually a really good idea as it implies a comparative
> > measure (something I always request people to do, as a single
> > performance number means nothing by itself).
> >
> > For a zoom-in-benchmarks like these where the amount of code executed
> > is very small, the effect of removing or adding code can effect the
> > measurement a lot.
> >
> > I can only do the tests for i40e, as I don't have ice hardware (but
> > Intel is working on fixing that ;-)).
> >
> >  xdp_rxq_info -a XDP_DROP
> >   i40e: 33,417,775 pps  
> 
> Here I only get around 21 Mpps
> 
> >  CPU is 100% used, so we can calculate nanosec used per packet:
> >   29.92 nanosec (1/33417775*10^9)
> >   2.1 GHz CPU =  approx 63 CPU-cycles
> >
> >  You lost -4% performance in this case.  This correspond to:
> >   -1.2 nanosec (29.92*0.04) slower
> >   (This could be cost of single func call overhead = 1.3 ns)
> >
> > My measurement for XDP_TX:
> >
> >  xdp_rxq_info -a XDP_TX
> >   28,278,722 pps
> >   35.36 ns (1/28278722*10^9)  
> 
> And here, much lower at around 8 Mpps. But I do see correct packets
> coming back on the cable for i40e but not for ice! There is likely a
> bug there in the XDP_TX logic for ice. Might explain the weird results
> I am getting. Will investigate.
> 
> But why do I get only a fraction of your performance? XDP_TX touches
> the packet so I would expect it to be far less than what you get, but
> more than I get. 

I clearly have a bug in the i40e driver.  As I wrote later, I don't see
any packets transmitted for XDP_TX.  Hmm, I using Mel Gorman's tree,
which doesn't contain the i40e/ice/ixgbe bug we fixed earlier.

The call to xdp_convert_buff_to_frame() fails, but (see below) that
error is simply converted to I40E_XDP_CONSUMED.  Thus, not even the
'trace_xdp_exception' will be able to troubleshoot this.  You/Intel
should consider making XDP_TX errors detectable (this will also happen
if TX ring don't have room).

 int i40e_xmit_xdp_tx_ring(struct xdp_buff *xdp, struct i40e_ring *xdp_ring)
 {
	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);

	if (unlikely(!xdpf))
		return I40E_XDP_CONSUMED;

	return i40e_xmit_xdp_ring(xdpf, xdp_ring);
 }


> What CPU core do you run on? 

Intel(R) Xeon(R) CPU E5-1650 v4 @ 3.60GHz

> It actually looks like
> your packet data gets prefetched successfully. If it had not, you
> would have gotten an access to LLC which is much more expensive than
> the drop you are seeing. If I run on the wrong NUMA node, I get 4
> Mpps, so it is not that.
> 
> One interesting thing is that I get better results using the zero-copy
> path in the driver. I start xdp_rxq_drop then tie an AF_XDP socket to
> the queue id the XDP program gets its traffic from. The AF_XDP program
> will get no traffic in this case, but it will force the driver to use
> the zero-copy path for its XDP processing. In this case I get this:
> 
> -0.5% for XDP_DROP and +-0% for XDP_TX for i40e.
> 
> >  You lost -10% performance in this case:
> >   -3.54 nanosec (35.36*0.10) slower
> >
> > In XDP context 3.54 nanosec is a lot, as you can see it is 10% in this
> > zoom-in benchmark.  We have to look at the details.
> >
> > One detail/issue with i40e doing XDP_TX, is that I cannot verify that
> > packets are actually transmitted... not via exception tracepoint, not
> > via netstats, not via ethtool_stats.pl.  Maybe all the packets are
> > getting (silently) drop in my tests...!?!
> >
> >  
> > > The xdpsock numbers are more in the ballpark of
> > > what I would expect.
> > >
> > > Tirtha and I found some optimizations in the i40e
> > > multi-frame/multi-buffer support that we have implemented. Will test
> > > those next, post the results and share the code.
> > >  
> > > > >
> > > > > Just note that I would really like for the multi-frame support to get
> > > > > in. I have lost count on how many people that have asked for it to be
> > > > > added to XDP and AF_XDP. So please check our implementation and
> > > > > improve it so we can get the overhead down to where we want it to be.  
> > > >
> > > > sure, I will do.
> > > >
> > > > Regards,
> > > > Lorenzo
> > > >  
> > > > >
> > > > > Thanks: Magnus
> > > > >  
> > > > > > I would like to reproduce these results in my testlab, in-order to
> > > > > > figure out where the throughput degradation comes from.
> > > > > >  
> > > > > > > What performance do you see with the mvneta card? How much are we
> > > > > > > willing to pay for this feature when it is not being used or can we in
> > > > > > > some way selectively turn it on only when needed?  
> > > > > >
> > > > > > Well, as Daniel says performance wise we require close to /zero/
> > > > > > additional overhead, especially as you state this happens when sending
> > > > > > a single frame, which is a base case that we must not slowdown.
> > > > > >
> > > > > > --
> > > > > > Best regards,
> > > > > >   Jesper Dangaard Brouer  
> >
> > --
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer
> >
> >
> > Running XDP on dev:i40e2 (ifindex:6) action:XDP_DROP options:read
> > XDP stats       CPU     pps         issue-pps
> > XDP-RX CPU      2       33,417,775  0
> > XDP-RX CPU      total   33,417,775
> >
> > RXQ stats       RXQ:CPU pps         issue-pps
> > rx_queue_index    2:2   33,417,775  0
> > rx_queue_index    2:sum 33,417,775
> >
> >
> > Running XDP on dev:i40e2 (ifindex:6) action:XDP_TX options:swapmac
> > XDP stats       CPU     pps         issue-pps
> > XDP-RX CPU      2       28,278,722  0
> > XDP-RX CPU      total   28,278,722
> >
> > RXQ stats       RXQ:CPU pps         issue-pps
> > rx_queue_index    2:2   28,278,726  0
> > rx_queue_index    2:sum 28,278,726
> >
> >
> >  
> 



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

