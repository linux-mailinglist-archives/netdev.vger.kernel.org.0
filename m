Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB26D394052
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 11:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbhE1JwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 05:52:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234926AbhE1JwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 05:52:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622195435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D0G8oPu18pmYZ7LxFvhbJ/xm7MVeifSSkI767EQWIis=;
        b=RQJNvbbmiW/UjLmUcBcNoV8kvOeZ6VRKomZ6bPa0vYwR5irF3QSMquXbQ60gzX6tSbZv8W
        0DVe/of8XcheTaUkdMfclMaFN/X9luw37RAQtTfQ2tLGQwwb+xt6hwdWbDdAm0w8nj438i
        T9Aawnrq+Da3cr1X+MW8/yI0eMdnyVA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-PBmWRZf7OKOIWUecTbXRxA-1; Fri, 28 May 2021 05:50:31 -0400
X-MC-Unique: PBmWRZf7OKOIWUecTbXRxA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B321CFC98;
        Fri, 28 May 2021 09:50:28 +0000 (UTC)
Received: from carbon (unknown [10.36.110.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9142B6F125;
        Fri, 28 May 2021 09:50:04 +0000 (UTC)
Date:   Fri, 28 May 2021 11:50:03 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     brouer@redhat.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] xsk: support AF_PACKET
Message-ID: <20210528115003.37840424@carbon>
In-Reply-To: <1622192521.5931044-1-xuanzhuo@linux.alibaba.com>
References: <87im33grtt.fsf@toke.dk>
        <1622192521.5931044-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 17:02:01 +0800
Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:

> On Fri, 28 May 2021 10:55:58 +0200, Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
> > Xuan Zhuo <xuanzhuo@linux.alibaba.com> writes:
> > =20
> > > In xsk mode, users cannot use AF_PACKET(tcpdump) to observe the curre=
nt
> > > rx/tx data packets. This feature is very important in many cases. So
> > > this patch allows AF_PACKET to obtain xsk packages. =20
> >
> > You can use xdpdump to dump the packets from the XDP program before it
> > gets redirected into the XSK:
> > https://github.com/xdp-project/xdp-tools/tree/master/xdp-dump =20
>=20
> Wow, this is a good idea.

Yes, it is rather cool (credit to Eelco).  Notice the extra info you
can capture from 'exit', like XDP return codes, if_index, rx_queue.

The tool uses the perf ring-buffer to send/copy data to userspace.
This is actually surprisingly fast, but I still think AF_XDP will be
faster (but it usually 'steals' the packet).

Another (crazy?) idea is to extend this (and xdpdump), is to leverage
Hangbin's recent XDP_REDIRECT extension e624d4ed4aa8 ("xdp: Extend
xdp_redirect_map with broadcast support").  We now have a
xdp_redirect_map flag BPF_F_BROADCAST, what if we create a
BPF_F_CLONE_PASS flag?

The semantic meaning of BPF_F_CLONE_PASS flag is to copy/clone the
packet for the specified map target index (e.g AF_XDP map), but
afterwards it does like veth/cpumap and creates an SKB from the
xdp_frame (see __xdp_build_skb_from_frame()) and send to netstack.
(Feel free to kick me if this doesn't make any sense)

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

