Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E518539427D
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbhE1MZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:25:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236728AbhE1MZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:25:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622204623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S2dmXzZLjX1N5a0eBwgNtO+olWwEU/9+ycoh3JKiqDI=;
        b=KbFMBs350bsayZ4JS7Fi50UcH7bbkMzv88QXIPnavBH7zL1KggT+iCH7SMkVYy+FsUSum/
        WfT/TCBtviskVxTW5wiJ27zLVIX03ki/kCECuLCt7BFLIRlsi5OOcvV66XJVVk+hiR6TNq
        ckMYBmkkPPJgrbtISEESk4yCxBxPhEM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-Iv_UL6c5N6mBLSWr3deSBQ-1; Fri, 28 May 2021 08:23:40 -0400
X-MC-Unique: Iv_UL6c5N6mBLSWr3deSBQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 552AA180FD66;
        Fri, 28 May 2021 12:23:36 +0000 (UTC)
Received: from carbon (unknown [10.36.110.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C790C5C22A;
        Fri, 28 May 2021 12:23:19 +0000 (UTC)
Date:   Fri, 28 May 2021 14:23:18 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4?= =?UTF-8?B?cmdlbnNlbg==?= 
        <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xie He <xie.he.0141@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        John Ogness <john.ogness@linutronix.de>,
        Wang Hai <wanghai38@huawei.com>,
        Tanner Love <tannerlove@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, brouer@redhat.com
Subject: Re: [PATCH bpf-next] xsk: support AF_PACKET
Message-ID: <20210528142318.6d7d4817@carbon>
In-Reply-To: <f90b1066-a962-ba38-a5b5-ac59a13d4dd1@iogearbox.net>
References: <87im33grtt.fsf@toke.dk>
        <1622192521.5931044-1-xuanzhuo@linux.alibaba.com>
        <20210528115003.37840424@carbon>
        <CAJ8uoz2bhfsk4XX--cNB-gKczx0jZENB5kdthoWkuyxcOHQfjg@mail.gmail.com>
        <f90b1066-a962-ba38-a5b5-ac59a13d4dd1@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 12:22:40 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 5/28/21 12:00 PM, Magnus Karlsson wrote:
> > On Fri, May 28, 2021 at 11:52 AM Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote: =20
> >> On Fri, 28 May 2021 17:02:01 +0800
> >> Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote: =20
> >>> On Fri, 28 May 2021 10:55:58 +0200, Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@redhat.com> wrote: =20
> >>>> Xuan Zhuo <xuanzhuo@linux.alibaba.com> writes:
> >>>> =20
> >>>>> In xsk mode, users cannot use AF_PACKET(tcpdump) to observe the cur=
rent
> >>>>> rx/tx data packets. This feature is very important in many cases. So
> >>>>> this patch allows AF_PACKET to obtain xsk packages. =20
> >>>>
> >>>> You can use xdpdump to dump the packets from the XDP program before =
it
> >>>> gets redirected into the XSK:
> >>>> https://github.com/xdp-project/xdp-tools/tree/master/xdp-dump =20
> >>>
> >>> Wow, this is a good idea. =20
> >>
> >> Yes, it is rather cool (credit to Eelco).  Notice the extra info you
> >> can capture from 'exit', like XDP return codes, if_index, rx_queue.
> >>
> >> The tool uses the perf ring-buffer to send/copy data to userspace.
> >> This is actually surprisingly fast, but I still think AF_XDP will be
> >> faster (but it usually 'steals' the packet).
> >>
> >> Another (crazy?) idea is to extend this (and xdpdump), is to leverage
> >> Hangbin's recent XDP_REDIRECT extension e624d4ed4aa8 ("xdp: Extend
> >> xdp_redirect_map with broadcast support").  We now have a
> >> xdp_redirect_map flag BPF_F_BROADCAST, what if we create a
> >> BPF_F_CLONE_PASS flag?
> >>
> >> The semantic meaning of BPF_F_CLONE_PASS flag is to copy/clone the
> >> packet for the specified map target index (e.g AF_XDP map), but
> >> afterwards it does like veth/cpumap and creates an SKB from the
> >> xdp_frame (see __xdp_build_skb_from_frame()) and send to netstack.
> >> (Feel free to kick me if this doesn't make any sense) =20
> >=20
> > This would be a smooth way to implement clone support for AF_XDP. If
> > we had this and someone added AF_XDP support to libpcap, we could both
> > capture AF_XDP traffic with tcpdump (using this clone functionality in
> > the XDP program) and speed up tcpdump for dumping traffic destined for
> > regular sockets. Would that solve your use case Xuan? Note that I have
> > not looked into the BPF_F_CLONE_PASS code, so do not know at this
> > point what it would take to support this for XSKMAPs. =20

There is no spoon... the BPF_F_CLONE_PASS code is an idea.

>=20
> Recently also ended up with something similar for our XDP LB to record pc=
aps [0] ;)
> My question is.. tcpdump doesn't really care where the packet data comes =
from,
> so why not extending libpcap's Linux-related internals to either capture =
from
> perf RB or BPF ringbuf=20

Just want to first mention, that I do like adding a perf ring-buffer
(BPF ringbuf) interface to AF_PACKET.  But this is basically what
xdpdump already does.  The cool thing is that it is super flexible for
adding extra info like xdpdump does with XDP-return codes.


> rather than AF_PACKET sockets? Cloning is slow, and if
> you need to end up creating an skb which is then cloned once again inside=
 AF_PACKET
> it's even worse. Just relying and reading out, say, perf RB you don't nee=
d any
> clones at all.

Well, this is exactly what we avoid with my idea of BPF_F_CLONE_PASS
when combined with AF_XDP.=20

I should explain this idea better.  The trick is that AF_XDP have
preallocated all the packets it will every use (at setup time).   Thus,
the AF_XDP copy-mode does no allocations, which is why it is fast
(of-cause ZC mode is faster, but copy-mode AF_XDP is also VERY fast!).

(Details and step with AF_XDP code notes:)
When the xdp_do_redirect happens with ri->flags BPF_F_CLONE_PASS, then
the map specific enqueue (e.g. __xsk_map_redirect), will do a copy of
the xdp_buff (AF_XDP calls xsk_copy_xdp()) and for AF_XDP we don't need
to do a (real) allocation.  Instead of freeing the xdp_buff in xsk_rcv()
(see call to xdp_return_buff()) then we do the xdp_frame to SKB work.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

