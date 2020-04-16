Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BAC1AC205
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 15:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894790AbgDPNDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 09:03:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53064 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2894629AbgDPNC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 09:02:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587042177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l1CooQoBe2EOCTRwIhu5U2ak5zsiCPcmsvYRJMbBWGI=;
        b=c93Y02KeijZyapNA3Wsc5xh5wdmzPOTOJu6vVpb8SzEwntT3KBj6+b5nTEcGCAmiwsx/6M
        8X+yL6v+NcQGJ65ZMI34jQSEMwHfRJcsQLGFHN0SJfWM4JnBNnluHGhX1FSxBIM9lviQ+m
        7c8oq5hISfB7hanWB0qPB/4Q9QXNHRI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-k3coq_pMPbO30blari8scg-1; Thu, 16 Apr 2020 09:02:53 -0400
X-MC-Unique: k3coq_pMPbO30blari8scg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 752961005527;
        Thu, 16 Apr 2020 13:02:51 +0000 (UTC)
Received: from carbon (unknown [10.40.208.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AD4260C05;
        Thu, 16 Apr 2020 13:02:39 +0000 (UTC)
Date:   Thu, 16 Apr 2020 15:02:38 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "sameehj@amazon.com" <sameehj@amazon.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "borkmann@iogearbox.net" <borkmann@iogearbox.net>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "zorik@amazon.com" <zorik@amazon.com>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        brouer@redhat.com
Subject: Re: [PATCH RFC v2 01/33] xdp: add frame size to xdp_buff
Message-ID: <20200416150238.40560372@carbon>
In-Reply-To: <7fb99df47a9eae1fd0fc8dc85336f7df2c120744.camel@mellanox.com>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
        <158634663936.707275.3156718045905620430.stgit@firesoul>
        <7fb99df47a9eae1fd0fc8dc85336f7df2c120744.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Apr 2020 00:50:02 +0000
Saeed Mahameed <saeedm@mellanox.com> wrote:

> On Wed, 2020-04-08 at 13:50 +0200, Jesper Dangaard Brouer wrote:
> > XDP have evolved to support several frame sizes, but xdp_buff was not
> > updated with this information. The frame size (frame_sz) member of
> > xdp_buff is introduced to know the real size of the memory the frame
> > is
> > delivered in.
> > 
> > When introducing this also make it clear that some tailroom is
> > reserved/required when creating SKBs using build_skb().
> > 
> > It would also have been an option to introduce a pointer to
> > data_hard_end (with reserved offset). The advantage with frame_sz is
> > that (like rxq) drivers only need to setup/assign this value once per
> > NAPI cycle. Due to XDP-generic (and some drivers) it's not possible
> > to
> > store frame_sz inside xdp_rxq_info, because it's varies per packet as
> > it
> > can be based/depend on packet length.
> > 
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  include/net/xdp.h |   17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 40c6d3398458..99f4374f6214 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -6,6 +6,8 @@
> >  #ifndef __LINUX_NET_XDP_H__
> >  #define __LINUX_NET_XDP_H__
> >  
> > +#include <linux/skbuff.h> /* skb_shared_info */
> > +  
> 
> I think it is wrong to make xdp.h depend on skbuff.h
> we must keep xdp.h minimal and independent,

I agree, that it seems strange to have xdp.h include skbuff.h, and I'm
not happy with that approach myself, but the alternatives all looked
kind of ugly.

> the new macros should be defined in skbuff.h 

Moving #define xdp_data_hard_end(xdp) into skbuff.h also seems strange.


> >  /**
> >   * DOC: XDP RX-queue information
> >   *
> > @@ -70,8 +72,23 @@ struct xdp_buff {
> >  	void *data_hard_start;
> >  	unsigned long handle;
> >  	struct xdp_rxq_info *rxq;
> > +	u32 frame_sz; /* frame size to deduct data_hard_end/reserved
> > tailroom*/  
> 
> why u32 ? u16 should be more than enough.. 

Nope.  It need to be able to store PAGE_SIZE == 65536.

$ echo $((1<<12))
4096
$ echo $((1<<16))
65536

$ printf "0x%X\n" 65536
0x10000


> >  };
> >  
> > +/* Reserve memory area at end-of data area.
> > + *
> > + * This macro reserves tailroom in the XDP buffer by limiting the
> > + * XDP/BPF data access to data_hard_end.  Notice same area (and size)
> > + * is used for XDP_PASS, when constructing the SKB via build_skb().
> > + */
> > +#define xdp_data_hard_end(xdp)				\
> > +	((xdp)->data_hard_start + (xdp)->frame_sz -	\
> > +	 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
> > +  
> 
> this macro is not safe when unary operators are being used

The parentheses round (xdp) does make xdp_data_hard_end(&xdp) work
correctly. What other cases are you worried about?


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

