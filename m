Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605F936C127
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 10:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbhD0Ilj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 04:41:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229487AbhD0Ilh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 04:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619512854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b4TkbOMuqL6zaiNVyrR84OzccxAUhggkjTLXhZ+grko=;
        b=OcjpsErYOlcogL4sZj50oMtXpNmKjORQ6ojG+GdxI3250WjxY2h/E5xrc2P8a6yj612Rqj
        7+d2s08URN+nTl4lHn67BrABrqWhehL0cLO9g4NZGAfzxUpdkdfypQ3d6lXdnl1L7Is3L/
        dWdO5z/rPwSx5dGAz1pZLLkRGf4B998=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-AbM_TlEuOkOXVmDlbA7luw-1; Tue, 27 Apr 2021 04:40:52 -0400
X-MC-Unique: AbM_TlEuOkOXVmDlbA7luw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57F3C801B13;
        Tue, 27 Apr 2021 08:40:50 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C46E817C5F;
        Tue, 27 Apr 2021 08:40:35 +0000 (UTC)
Date:   Tue, 27 Apr 2021 10:40:34 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxh?= =?UTF-8?B?bmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFQ=?= =?UTF-8?B?w7ZwZWw=?= 
        <bjorn.topel@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        brouer@redhat.com
Subject: Re: [PATCHv10 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210427104034.0e62db4b@carbon>
In-Reply-To: <20210426114742.GU3465@Leo-laptop-t470s>
References: <20210423020019.2333192-1-liuhangbin@gmail.com>
        <20210423020019.2333192-3-liuhangbin@gmail.com>
        <20210426115350.501cef2a@carbon>
        <20210426114014.GT3465@Leo-laptop-t470s>
        <20210426114742.GU3465@Leo-laptop-t470s>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Apr 2021 19:47:42 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> On Mon, Apr 26, 2021 at 07:40:28PM +0800, Hangbin Liu wrote:
> > On Mon, Apr 26, 2021 at 11:53:50AM +0200, Jesper Dangaard Brouer wrote:  
> > > Decode: perf_trace_xdp_redirect_template+0xba
> > >  ./scripts/faddr2line vmlinux perf_trace_xdp_redirect_template+0xba
> > > perf_trace_xdp_redirect_template+0xba/0x130:
> > > perf_trace_xdp_redirect_template at include/trace/events/xdp.h:89 (discriminator 13)
> > > 
> > > less -N net/core/filter.c
> > >  [...]
> > >    3993         if (unlikely(err))
> > >    3994                 goto err;
> > >    3995   
> > > -> 3996         _trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index);  
> > 
> > Oh, the fwd in xdp xdp_redirect_map broadcast is NULL...
> > 
> > I will see how to fix it. Maybe assign the ingress interface to fwd?  
> 
> Er, sorry for the flood message. I just checked the trace point code, fwd
> in xdp trace event means to_ifindex. So we can't assign the ingress interface
> to fwd.
> 
> In xdp_redirect_map broadcast case, there is no specific to_ifindex.
> So how about just ignore it... e.g.

Yes, below code make sense, and I want to confirm that it solves the
crash (I tested it).  IMHO leaving ifindex=0 is okay, because  it is
not a valid ifindex, meaning a caller of the tracepoint can deduce
(together with the map types) that this must be a broadcast.

Thank you Hangbin for keep working on this patchset.  I know it have
been a long long road.  I truly appreciate your perseverance and
patience with this patchset.  With this crash fixed, I actually think we
are very close to having something we can merge.  With the unlikely()
I'm fine with the code itself.

I think we need to update the patch description, but I've asked Toke to
help with this. The performance measurements in the patch description
is not measuring what I expected, but something else.  To avoid redoing
a lot of testing, I think we can just describe what the test
'redirect_map-multi i40e->i40e' is doing, as broadcast feature is
filtering the ingress port 'i40e->i40e' test out same interface will
just drop the xdp_frame (after walking the devmap for empty ports).  Or
maybe it is not the same interface(?). In any-case this need to be more
clear.

I think it would be valuable to show (in the commit message) some tests
that demonstrates the overhead of packet cloning.  I expect the
overhead of page-alloc+memcpy is to be significant, but Lorenzo have a
number of ideas howto speed this up.  Maybe you can simply
broadcast-redirect into multiple veth devices that (XDP_DROP in
peer-dev) to demonstrate the effect and overhead of doing the cloning
process.


> diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
> index fcad3645a70b..1751da079330 100644
> --- a/include/trace/events/xdp.h
> +++ b/include/trace/events/xdp.h
> @@ -110,7 +110,8 @@ DECLARE_EVENT_CLASS(xdp_redirect_template,
>                 u32 ifindex = 0, map_index = index;
> 
>                 if (map_type == BPF_MAP_TYPE_DEVMAP || map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
> -                       ifindex = ((struct _bpf_dtab_netdev *)tgt)->dev->ifindex;
> +                       if (tgt)
> +                               ifindex = ((struct _bpf_dtab_netdev *)tgt)->dev->ifindex;
>                 } else if (map_type == BPF_MAP_TYPE_UNSPEC && map_id == INT_MAX) {
>                         ifindex = index;
>                         map_index = 0;
> 
> 
> Hangbin
> 



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

