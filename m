Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0DB25DECB
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 18:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgIDQAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 12:00:08 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33061 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726127AbgIDQAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 12:00:06 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-WSNdJ09yOkq21Tr6bOjGrA-1; Fri, 04 Sep 2020 12:00:01 -0400
X-MC-Unique: WSNdJ09yOkq21Tr6bOjGrA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA5DF18A2257;
        Fri,  4 Sep 2020 15:59:58 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBB005D9CC;
        Fri,  4 Sep 2020 15:59:47 +0000 (UTC)
Date:   Fri, 4 Sep 2020 17:59:46 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org, john.fastabend@gmail.com,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        David Ahern <dsahern@kernel.org>, brouer@redhat.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH v2 net-next 1/9] xdp: introduce mb in xdp_buff/xdp_frame
Message-ID: <20200904175946.6be0f565@carbon>
In-Reply-To: <1c3e478c-5000-1726-6ce9-9b0a3ccfe1e5@gmail.com>
References: <cover.1599165031.git.lorenzo@kernel.org>
        <1e8e82f72e46264b7a7a1ac704d24e163ebed100.1599165031.git.lorenzo@kernel.org>
        <20200904010705.jm6dnuyj3oq4cpjd@ast-mbp.dhcp.thefacebook.com>
        <20200904091939.069592e4@carbon>
        <1c3e478c-5000-1726-6ce9-9b0a3ccfe1e5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Sep 2020 09:15:04 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 9/4/20 1:19 AM, Jesper Dangaard Brouer wrote:
> > On Thu, 3 Sep 2020 18:07:05 -0700
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >   
> >> On Thu, Sep 03, 2020 at 10:58:45PM +0200, Lorenzo Bianconi wrote:  
> >>> Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer to specify
> >>> if shared_info area has been properly initialized for non-linear
> >>> xdp buffers
> >>>
> >>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >>> ---
> >>>  include/net/xdp.h | 8 ++++++--
> >>>  net/core/xdp.c    | 1 +
> >>>  2 files changed, 7 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/include/net/xdp.h b/include/net/xdp.h
> >>> index 3814fb631d52..42f439f9fcda 100644
> >>> --- a/include/net/xdp.h
> >>> +++ b/include/net/xdp.h
> >>> @@ -72,7 +72,8 @@ struct xdp_buff {
> >>>  	void *data_hard_start;
> >>>  	struct xdp_rxq_info *rxq;
> >>>  	struct xdp_txq_info *txq;
> >>> -	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
> >>> +	u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved tailroom*/
> >>> +	u32 mb:1; /* xdp non-linear buffer */
> >>>  };
> >>>  
> >>>  /* Reserve memory area at end-of data area.
> >>> @@ -96,7 +97,8 @@ struct xdp_frame {
> >>>  	u16 len;
> >>>  	u16 headroom;
> >>>  	u32 metasize:8;
> >>> -	u32 frame_sz:24;
> >>> +	u32 frame_sz:23;
> >>> +	u32 mb:1; /* xdp non-linear frame */    
> >>
> >> Hmm. Last time I checked compilers were generating ugly code with bitfields.
> >> Not performant and not efficient.
> >> frame_sz is used in the fast path.
> >> I suspect the first hunk alone will cause performance degradation.
> >> Could you use normal u8 or u32 flag field?  
> > 
> > For struct xdp_buff sure we can do this.  For struct xdp_frame, I'm not
> > sure, as it is a state compressed version of xdp_buff + extra
> > information.  The xdp_frame have been called skb-light, and I know
> > people (e.g Ahern) wants to add more info to this, vlan, RX-hash, csum,
> > and we must keep this to 1-cache-line, for performance reasons.
> > 
> > You do make a good point, that these bit-fields might hurt performance
> > more.  I guess, we need to test this.  As I constantly worry that we
> > will slowly kill XDP performance with a 1000 paper-cuts.
> >   
> 
> That struct is tight on space, and we have to be very smart about
> additions. 

I fully agree.

> dev_rx for example seems like it could just be the netdev
> index rather than a pointer or perhaps can be removed completely. I
> believe it is only used for 1 use case (redirects to CPUMAP); maybe that
> code can be refactored to handle the dev outside of xdp_frame.

The dev_rx is needed when creating an SKB from a xdp_frame (basically
skb->dev = rx_dev). Yes, that is done in cpumap, but I want to
generalize this.  The veth also creates SKBs from xdp_frame, but use
itself as skb->dev.

And yes, we could save some space storing the index instead, and trade
space for cycles in a lookup.

 
> xdp_mem_info is 2 u32's; the type in that struct really could be a u8.

Yes, I have floated a patch that did this earlier, but it was never
merged, as it was part of storing the xdp_mem_info in the SKB to create
a return path for page_pool pages.

> In this case it means removing struct in favor of 2 elements to reclaim
> the space, but as we reach the 64B limit this is a place to change.
> e.g., make it a single u32 with the id only 24 bits though the
> rhashtable key can stay u32 but now with the combined type + id.
> 
> As for frame_sz, why does it need to be larger than a u16?

Because PAGE_SIZE can be 64KiB on some archs.

> If it really needs to be larger than u16, there are several examples of
> using a bit (or bits) in the data path. dst metrics for examples uses
> lowest 4 bits of the dst pointer as a bitfield. It does so using a mask
> with accessors vs a bitfield. Perhaps that is the way to go here.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

perl -e 'my $a=65536; printf("%d b%b 0x%X\n", $a, $a, $a)'
65536 b10000000000000000 0x10000

