Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9B61D7461
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 11:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgERJwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 05:52:55 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54849 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726127AbgERJwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 05:52:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589795573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z/KzCBRewI4UZYEC+oRjclZB5UNKfBBMXVCdilN1Dgc=;
        b=H3+H3uU6Rj7O5NonH7HqDz2pz7CUXBFy6RRy8RCj4/1xNTu5YfZQl/1iN3l42MJsPGsPhG
        70Q9fVIXk3JLQ7eLXNTy/VKGFDVIeYLTuYLJEcT+TE7ix6MG/67C01Ge63XiNPeAR5imIO
        Z5axvG3fWQU8RsvBZeQnQvwlaOSJoEE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-PGwIsSC6OhWyIhv8YPFc0w-1; Mon, 18 May 2020 05:52:49 -0400
X-MC-Unique: PGwIsSC6OhWyIhv8YPFc0w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 071D6100A614;
        Mon, 18 May 2020 09:52:47 +0000 (UTC)
Received: from carbon (unknown [10.40.208.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0527A5D9DC;
        Mon, 18 May 2020 09:52:35 +0000 (UTC)
Date:   Mon, 18 May 2020 11:52:34 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     sameehj@amazon.com, Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Andrii Nakryiko <andriin@fb.com>, brouer@redhat.com
Subject: Re: unstable xdp tests. Was: [PATCH net-next v4 31/33] bpf: add
 xdp.frame_sz in bpf_prog_test_run_xdp().
Message-ID: <20200518115234.3b6925de@carbon>
In-Reply-To: <CAADnVQLtJotzY==OfOHmA-KdTb6bF7uqKVYGhnPj-oyzSZ8C_g@mail.gmail.com>
References: <158945314698.97035.5286827951225578467.stgit@firesoul>
        <158945349549.97035.15316291762482444006.stgit@firesoul>
        <CAADnVQLtJotzY==OfOHmA-KdTb6bF7uqKVYGhnPj-oyzSZ8C_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 May 2020 21:02:01 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, May 14, 2020 at 3:51 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > Update the memory requirements, when adding xdp.frame_sz in BPF test_run
> > function bpf_prog_test_run_xdp() which e.g. is used by XDP selftests.
> >
> > Specifically add the expected reserved tailroom, but also allocated a
> > larger memory area to reflect that XDP frames usually comes in this
> > format. Limit the provided packet data size to 4096 minus headroom +
> > tailroom, as this also reflect a common 3520 bytes MTU limit with XDP.
> >
> > Note that bpf_test_init already use a memory allocation method that clears
> > memory.  Thus, this already guards against leaking uninit kernel memory.
> >
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  net/bpf/test_run.c |   16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > index 29dbdd4c29f6..30ba7d38941d 100644
> > --- a/net/bpf/test_run.c
> > +++ b/net/bpf/test_run.c
> > @@ -470,25 +470,34 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
> >  int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
> >                           union bpf_attr __user *uattr)
> >  {
> > +       u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > +       u32 headroom = XDP_PACKET_HEADROOM;
> >         u32 size = kattr->test.data_size_in;
> >         u32 repeat = kattr->test.repeat;
> >         struct netdev_rx_queue *rxqueue;
> >         struct xdp_buff xdp = {};
> >         u32 retval, duration;
> > +       u32 max_data_sz;
> >         void *data;
> >         int ret;
> >
> >         if (kattr->test.ctx_in || kattr->test.ctx_out)
> >                 return -EINVAL;
> >
> > -       data = bpf_test_init(kattr, size, XDP_PACKET_HEADROOM + NET_IP_ALIGN, 0);
> > +       /* XDP have extra tailroom as (most) drivers use full page */
> > +       max_data_sz = 4096 - headroom - tailroom;
> > +       if (size > max_data_sz)
> > +               return -EINVAL;
> > +
> > +       data = bpf_test_init(kattr, max_data_sz, headroom, tailroom);  
> 
> Hi Jesper,
> 
> above is buggy.
> max_data_sz is way more than what user space has.
> That causes xdp unit tests to fail sporadically with EFAULT.
> Like:
> ./test_progs -t xdp_perf
> test_xdp_perf:FAIL:xdp-perf err -1 errno 14 retval 0 size 0
> #89 xdp_perf:FAIL
> 
> For that test max_data_sz will be 3520 while user space prepared only 128 bytes
> and copy_from_user will fault.
 
I'm looking into this... BUT

... I'm getting unrelated compile errors for selftests/bpf in
bpf-next tree (HEAD 96586dd9268d2).

The compile error, see below signature, happens in ./progs/bpf_iter_ipv6_route.c
(tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c).

Related to commit:
 7c128a6bbd4f ("tools/bpf: selftests: Add iterator programs for ipv6_route and netlink") (Author: Yonghong Song)

-
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


$ make 
  CLNG-LLC [test_maps] bpf_iter_ipv6_route.o
progs/bpf_iter_ipv6_route.c:18:28: warning: declaration of 'struct bpf_iter__ipv6_route' will not be visible outside of this function [-Wvisibility]
int dump_ipv6_route(struct bpf_iter__ipv6_route *ctx)
                           ^
progs/bpf_iter_ipv6_route.c:20:28: error: incomplete definition of type 'struct bpf_iter__ipv6_route'
        struct seq_file *seq = ctx->meta->seq;
                               ~~~^
progs/bpf_iter_ipv6_route.c:18:28: note: forward declaration of 'struct bpf_iter__ipv6_route'
int dump_ipv6_route(struct bpf_iter__ipv6_route *ctx)
                           ^
progs/bpf_iter_ipv6_route.c:21:28: error: incomplete definition of type 'struct bpf_iter__ipv6_route'
        struct fib6_info *rt = ctx->rt;
                               ~~~^
progs/bpf_iter_ipv6_route.c:18:28: note: forward declaration of 'struct bpf_iter__ipv6_route'
int dump_ipv6_route(struct bpf_iter__ipv6_route *ctx)
                           ^
1 warning and 2 errors generated.
llc: error: llc: <stdin>:1:1: error: expected top-level entity
BPF obj compilation failed
^
make: *** [Makefile:365: /home/jbrouer/git/kernel/bpf-next/tools/testing/selftests/bpf/bpf_iter_ipv6_route.o] Error 1

