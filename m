Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36DD89AD14
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 12:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391635AbfHWK11 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Aug 2019 06:27:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33610 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731002AbfHWK10 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 06:27:26 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3E38C3061423;
        Fri, 23 Aug 2019 10:27:25 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 456575D6B2;
        Fri, 23 Aug 2019 10:27:14 +0000 (UTC)
Date:   Fri, 23 Aug 2019 12:27:13 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        brouer@redhat.com, Anton Protopopov <aspsk2@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Yoel Caspersen <yoel@kviknet.dk>
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
Message-ID: <20190823122713.73450a4b@carbon>
In-Reply-To: <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
References: <20190820114706.18546-1-toke@redhat.com>
        <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 23 Aug 2019 10:27:25 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Aug 2019 13:30:09 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Tue, Aug 20, 2019 at 4:47 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >
> > iproute2 uses its own bpf loader to load eBPF programs, which has
> > evolved separately from libbpf. Since we are now standardising on
> > libbpf, this becomes a problem as iproute2 is slowly accumulating
> > feature incompatibilities with libbpf-based loaders. In particular,
> > iproute2 has its own (expanded) version of the map definition struct,
> > which makes it difficult to write programs that can be loaded with both
> > custom loaders and iproute2.
> >
> > This series seeks to address this by converting iproute2 to using libbpf
> > for all its bpf needs. This version is an early proof-of-concept RFC, to
> > get some feedback on whether people think this is the right direction.
> >
> > What this series does is the following:
> >
> > - Updates the libbpf map definition struct to match that of iproute2
> >   (patch 1).  
> 
> 
> Hi Toke,
> 
> Thanks for taking a stab at unifying libbpf and iproute2 loaders. I'm
> totally in support of making iproute2 use libbpf to load/initialize
> BPF programs. But I'm against adding iproute2-specific fields to
> libbpf's bpf_map_def definitions to support this.
> 
> I've proposed the plan of extending libbpf's supported features so
> that it can be used to load iproute2-style BPF programs earlier,
> please see discussions in [0] and [1]. I think instead of emulating
> iproute2 way of matching everything based on user-specified internal
> IDs, which doesn't provide good user experience and is quite easy to
> get wrong, we should support same scenarios with better declarative
> syntax and in a less error-prone way. I believe we can do that by
> relying on BTF more heavily (again, please check some of my proposals
> in [0], [1], and discussion with Daniel in those threads). It will
> feel more natural and be more straightforward to follow. It would be
> great if you can lend a hand in implementing pieces of that plan!
> 
> I'm currently on vacation, so my availability is very sparse, but I'd
> be happy to discuss this further, if need be.
> 
>   [0] https://lore.kernel.org/bpf/CAEf4BzbfdG2ub7gCi0OYqBrUoChVHWsmOntWAkJt47=FE+km+A@mail.gmail.com/
>   [1] https://www.spinics.net/lists/bpf/msg03976.html
> 
> > - Adds functionality to libbpf to support automatic pinning of maps when
> >   loading an eBPF program, while re-using pinned maps if they already
> >   exist (patches 2-3).

For production use-cases, libbpf really need an easier higher-level API
for re-using pinned maps, for establishing shared maps between
programs.  The existing libbpf API bpf_object__pin_maps() and
bpf_object__unpin_maps(), which don't re-use pinned maps, are not
really usable, because they pin/unpin ALL maps in the ELF file.

What users really need is an easy way to specify, on a per map basis,
what kind of pinning and reuse/sharing they want.  E.g. like iproute2
have, "global", "object-scope", and "no-pinning". ("ifindex-scope" would
be nice for XDP).
  Today users have to split/reimplement bpf_prog_load_xattr(), and
use/add bpf_map__reuse_fd().  Which is that I ended doing for
xdp-cpumap-tc[2] (used in production at ISP) resulting in 142 lines of
extra code[3] that should have been hidden inside libbpf.  And worse,
in this solution[4] the maps for reuse-pinning is specified in the code
by name.  Thus, they cannot use a generic loader.  That I why, I want
to mark the maps via a pinning member, like iproute2.

I really hope this moves in a practical direction, as I have the next
production request lined up (also from an ISP), and I hate to have to
advice them to choose the same route as [3].


[2] https://github.com/xdp-project/xdp-cpumap-tc/
[3] https://github.com/xdp-project/xdp-cpumap-tc/blob/master/src/xdp_iphash_to_cpu_user.c#L262-L403
[4] https://github.com/xdp-project/xdp-cpumap-tc/blob/master/src/xdp_iphash_to_cpu_user.c#L431-L441
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
