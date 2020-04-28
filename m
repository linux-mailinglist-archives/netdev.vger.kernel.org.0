Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6991BC55D
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 18:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgD1QiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 12:38:04 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29200 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728084AbgD1QiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 12:38:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588091883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ozj4jNK/nmOFfl5aXvTqsTanwcDs2Wmo5RotwE0KeQU=;
        b=Ob+nRozr7SLMgXtAv9nXaHRuYrf0rf0TQYCxTBUVXWxU5AdkmOLdFnB2QpzBWYy01qvpl2
        VDWxSyeKUqdyWu8dpcBDhUaZ48Pu9eD9Fouj8kU8nJVqa+Hz5Zi69rIfcOk1EEQnNLU2dG
        8KMj86l2FNylpV27Xz3pHTU1eea9n4E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-yzpD3nfiOUKoyeTT4x2NDw-1; Tue, 28 Apr 2020 12:37:58 -0400
X-MC-Unique: yzpD3nfiOUKoyeTT4x2NDw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3351835B42;
        Tue, 28 Apr 2020 16:37:55 +0000 (UTC)
Received: from carbon (unknown [10.40.208.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CE745D9E5;
        Tue, 28 Apr 2020 16:37:44 +0000 (UTC)
Date:   Tue, 28 Apr 2020 18:37:43 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com, brouer@redhat.com
Subject: Re: [PATCH net-next 29/33] xdp: allow bpf_xdp_adjust_tail() to grow
 packet size
Message-ID: <20200428183743.19dee96e@carbon>
In-Reply-To: <940b8c06-b71f-f6b1-4832-4abc58027589@iogearbox.net>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
        <158757178840.1370371.13037637865133257416.stgit@firesoul>
        <940b8c06-b71f-f6b1-4832-4abc58027589@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Apr 2020 21:01:14 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 4/22/20 6:09 PM, Jesper Dangaard Brouer wrote:
> > Finally, after all drivers have a frame size, allow BPF-helper
> > bpf_xdp_adjust_tail() to grow or extend packet size at frame tail.
> > 
> > Remember that helper/macro xdp_data_hard_end have reserved some
> > tailroom.  Thus, this helper makes sure that the BPF-prog don't have
> > access to this tailroom area.
> > 
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >   include/uapi/linux/bpf.h |    4 ++--
> >   net/core/filter.c        |   15 +++++++++++++--
> >   2 files changed, 15 insertions(+), 4 deletions(-)
> > 
[...]
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 7d6ceaa54d21..5e9c387f74eb 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3422,12 +3422,23 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
> >   
> >   BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
> >   {
> > +	void *data_hard_end = xdp_data_hard_end(xdp);
> >   	void *data_end = xdp->data_end + offset;
> >   
> > -	/* only shrinking is allowed for now. */
> > -	if (unlikely(offset >= 0))
> > +	/* Notice that xdp_data_hard_end have reserved some tailroom */
> > +	if (unlikely(data_end > data_hard_end))
> >   		return -EINVAL;
> >   
> > +	/* ALL drivers MUST init xdp->frame_sz, some chicken checks below */
> > +	if (unlikely(xdp->frame_sz < (xdp->data_end - xdp->data_hard_start))) {
> > +		WARN(1, "Too small xdp->frame_sz = %d\n", xdp->frame_sz);
> > +		return -EINVAL;
> > +	}

I will remove this "too small" check, as it is useless, given it will
already get caught by above check.


> > +	if (unlikely(xdp->frame_sz > PAGE_SIZE)) {
> > +		WARN(1, "Too BIG xdp->frame_sz = %d\n", xdp->frame_sz);
> > +		return -EINVAL;
> > +	}  
> 
> I don't think we can add the WARN()s here. If there is a bug in the
> driver in this area and someone deploys an XDP-based application
> (otherwise known to work well elsewhere) on top of this, then an
> attacker can basically remote DoS the machine with malicious packets
> that end up triggering these WARN()s over and over.

Good point.  I've changed this to WARN_ONCE(), but I'm still
considering to remove it completely...

> If you are worried that not all your driver changes are correct,
> maybe only add those that you were able to actually test yourself or
> that have been acked, and otherwise pre-init the frame_sz to a known
> invalid value so this helper would only allow shrinking for them in
> here (as today)?

Hmm... no, I really want to require ALL drivers to set a valid value,
because else we will have the "data_meta" feature situation, where a lot
of drivers still doesn't support this.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

