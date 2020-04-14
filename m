Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765691A7B20
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 14:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502171AbgDNMr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 08:47:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27156 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728963AbgDNMrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 08:47:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586868420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A+nH0t8V7cHfq6JAuXH0DGqngzCk5JxjFUG03j3kMOo=;
        b=aYagiKFsccgEiUmpnesjw36xSYC58qolEx0C+6msS3nl1OAB8GwoP+KlFlspHSGfZGvJGZ
        Dk/kBaRNqkGMuAJ5T4yJ45VCTwRxOEk/WabJ1yeE/NxyuX4WUFzXSohz/J+sfb9TDCF1KQ
        hENzy59AQYfIyqLoQx7DYIwy59hnlEs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-sUzUj0mKMti50Ws-J2VG_w-1; Tue, 14 Apr 2020 08:46:51 -0400
X-MC-Unique: sUzUj0mKMti50Ws-J2VG_w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 762B5800D53;
        Tue, 14 Apr 2020 12:46:49 +0000 (UTC)
Received: from carbon (unknown [10.40.208.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DD5060BE2;
        Tue, 14 Apr 2020 12:46:38 +0000 (UTC)
Date:   Tue, 14 Apr 2020 14:46:37 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "toke@redhat.com" <toke@redhat.com>,
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
        brouer@redhat.com, Steffen Klassert <steffen.klassert@secunet.com>,
        Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH RFC v2 29/33] xdp: allow bpf_xdp_adjust_tail() to grow
 packet size
Message-ID: <20200414144637.0dafdda5@carbon>
In-Reply-To: <ed0ce4d76e77b23aa3edcd821d5a4867e8bb27b1.camel@mellanox.com>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
        <158634678170.707275.10720666808605360076.stgit@firesoul>
        <ed0ce4d76e77b23aa3edcd821d5a4867e8bb27b1.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Apr 2020 03:31:14 +0000
Saeed Mahameed <saeedm@mellanox.com> wrote:

> On Wed, 2020-04-08 at 13:53 +0200, Jesper Dangaard Brouer wrote:
> > Finally, after all drivers have a frame size, allow BPF-helper
> > bpf_xdp_adjust_tail() to grow or extend packet size at frame tail.
> >   
> 
> can you provide a list of usecases for why tail extension is necessary
> ?

Use-cases:
(1) IPsec / XFRM needs a tail extend[1][2].
(2) DNS-cache replies in XDP.
(3) HA-proxy ALOHA would need it to convert to XDP.
 
> and what do you have in mind as immediate use of bpf_xdp_adjust_tail()
> ? 

I guess Steffen Klassert's ipsec use-case(1) it the most immediate.

[1] http://vger.kernel.org/netconf2019_files/xfrm_xdp.pdf
[2] http://vger.kernel.org/netconf2019.html

> both cover letter and commit messages didn't list any actual use case..

Sorry about that.

> > Remember that helper/macro xdp_data_hard_end have reserved some
> > tailroom.  Thus, this helper makes sure that the BPF-prog don't have
> > access to this tailroom area.
> > 
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  include/uapi/linux/bpf.h |    4 ++--
> >  net/core/filter.c        |   18 ++++++++++++++++--
> >  2 files changed, 18 insertions(+), 4 deletions(-)
> > 
[... cut ...]
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 7628b947dbc3..4d58a147eed0 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3422,12 +3422,26 @@ static const struct bpf_func_proto
> > bpf_xdp_adjust_head_proto = {
> >  
> >  BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
> >  {
> > +	void *data_hard_end = xdp_data_hard_end(xdp);
> >  	void *data_end = xdp->data_end + offset;
> >  
> > -	/* only shrinking is allowed for now. */
> > -	if (unlikely(offset >= 0))
> > +	/* Notice that xdp_data_hard_end have reserved some tailroom */
> > +	if (unlikely(data_end > data_hard_end))
> >  		return -EINVAL;
> >    
> 
> i don't know if i like this approach for couple of reasons.
> 
> 1. drivers will provide arbitrary frames_sz, which is normally larger
> than mtu, and could be a full page size, for XDP_TX action this can be
> problematic if xdp progs will allow oversized packets to get caught at
> the driver level..

We already check if MTU is exceeded for a specific device when we
redirect into this, see helper xdp_ok_fwd_dev().  For the XDP_TX case,
I guess some drivers bypass that check, which should be fixed. The
XDP_TX case is IMHO a place where we allow drivers do special
optimizations, thus drivers can choose to do something faster than
calling generic helper xdp_ok_fwd_dev().  
  
> 
> 2. xdp_data_hard_end(xdp) has a hardcoded assumption of the skb shinfo
> and it introduces a reverse dependency between xdp buff and skbuff 
> 
(I'll address this in another mail)

> both of the above can be solved if the drivers provided the max
> allowed frame size, already accounting for mtu and shinfo when setting
> xdp_buff.frame_sz at the driver level.

It seems we look at the problem from two different angles.  You have
the drivers perspective, while I have the network stacks perspective
(the XDP_PASS case).  The mlx5 driver treats XDP as a special case, by
hiding or confining xdp_buff to functions fairly deep in the
call-stack.  My goal is different (moving SKB out of drivers), I see
the xdp_buff/xdp_frame as the main packet object in the drivers, that
gets send up the network stack (after converting to xdp_frame) and
converted into SKB in core-code (yes, there is a long road-ahead). The
larger tailroom can be used by netstack in SKB-coalesce.

The next step is making xdp_buff (and xdp_frame) multi-buffer aware.
This is why I reserve room for skb_shared_info.  I have considered
reducing the size of xdp_buff.frame_sz, with sizeof(skb_shared_info),
but it got kind of ugly having this in each drivers.

I also considered having drivers setup a direct pointer to
{skb,xdp}_shared_info section in xdp_buff, because will make it more
flexible (for what I imagined Alexander Duyck want).  (But we can still
do/change that later, once we start work in multi-buffer code)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

