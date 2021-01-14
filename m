Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBFA2F6389
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbhANOyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:54:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55240 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726236AbhANOyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 09:54:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610635965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hsIohmEQeJszq1jgbSf64ncayWX6iJlFCFcEXl8xGas=;
        b=V838G72eZK61XQgUWZSv/daxsHsD3FuzMvAeUxTrjIj6bENx7X/uUCkKYQ+w1F1+HYfUZA
        yvRZTbXTUaJg2rRcxxYP6+JIEpJxJMA4ZZmazbRx6jtYU7UzVlsUtSiRlZyWwsCvgGr10h
        bGy7Ig7gCMR9jdxoC6aJzZYvRdlsOyI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-0qM94kpdNo28mpLCWyKb4Q-1; Thu, 14 Jan 2021 09:52:41 -0500
X-MC-Unique: 0qM94kpdNo28mpLCWyKb4Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98954100A5EF;
        Thu, 14 Jan 2021 14:52:39 +0000 (UTC)
Received: from carbon (unknown [10.36.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F98A74ABF;
        Thu, 14 Jan 2021 14:52:28 +0000 (UTC)
Date:   Thu, 14 Jan 2021 15:52:28 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V11 4/7] bpf: add BPF-helper for MTU checking
Message-ID: <20210114155228.128457c7@carbon>
In-Reply-To: <CAEf4Bzb0Z+qeuDTtfz6Ae3ab5hz_iG0vt8ALiry2zYWkgRh2Fw@mail.gmail.com>
References: <161047346644.4003084.2653117664787086168.stgit@firesoul>
        <161047352084.4003084.16468571234023057969.stgit@firesoul>
        <CAEf4Bzb0Z+qeuDTtfz6Ae3ab5hz_iG0vt8ALiry2zYWkgRh2Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 11:23:33 -0800
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Tue, Jan 12, 2021 at 9:49 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > This BPF-helper bpf_check_mtu() works for both XDP and TC-BPF programs.
> >
> > The SKB object is complex and the skb->len value (accessible from
> > BPF-prog) also include the length of any extra GRO/GSO segments, but
> > without taking into account that these GRO/GSO segments get added
> > transport (L4) and network (L3) headers before being transmitted. Thus,
> > this BPF-helper is created such that the BPF-programmer don't need to
> > handle these details in the BPF-prog.
> >
> > The API is designed to help the BPF-programmer, that want to do packet
> > context size changes, which involves other helpers. These other helpers
> > usually does a delta size adjustment. This helper also support a delta
> > size (len_diff), which allow BPF-programmer to reuse arguments needed by
> > these other helpers, and perform the MTU check prior to doing any actual
> > size adjustment of the packet context.
> >
> > It is on purpose, that we allow the len adjustment to become a negative
> > result, that will pass the MTU check. This might seem weird, but it's not
> > this helpers responsibility to "catch" wrong len_diff adjustments. Other
> > helpers will take care of these checks, if BPF-programmer chooses to do
> > actual size adjustment.
> >
> > V9:
> > - Use dev->hard_header_len (instead of ETH_HLEN)
> > - Annotate with unlikely req from Daniel
> > - Fix logic error using skb_gso_validate_network_len from Daniel
> >
> > V6:
> > - Took John's advice and dropped BPF_MTU_CHK_RELAX
> > - Returned MTU is kept at L3-level (like fib_lookup)
> >
> > V4: Lot of changes
> >  - ifindex 0 now use current netdev for MTU lookup
> >  - rename helper from bpf_mtu_check to bpf_check_mtu
> >  - fix bug for GSO pkt length (as skb->len is total len)
> >  - remove __bpf_len_adj_positive, simply allow negative len adj
> >
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  include/uapi/linux/bpf.h       |   67 ++++++++++++++++++++++
> >  net/core/filter.c              |  122 ++++++++++++++++++++++++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h |   67 ++++++++++++++++++++++
> >  3 files changed, 256 insertions(+)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 649586d656b6..fa2e99351758 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3833,6 +3833,61 @@ union bpf_attr {
> >   *     Return
> >   *             A pointer to a struct socket on success or NULL if the file is
> >   *             not a socket.
> > + *
> > + * int bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)  
> 
> should return long, same as most other helpers

Is it enough to change it here?
(as this will be used for generating the helpers header file,
via ./scripts/bpf_helpers_doc.py --header)

Or do I also need to change bpf_func_proto.ret_type ?

> > + *     Description
> > + *             Check ctx packet size against MTU of net device (based on
> > + *             *ifindex*).  This helper will likely be used in combination with
> > + *             helpers that adjust/change the packet size.  The argument
> > + *             *len_diff* can be used for querying with a planned size
> > + *             change. This allows to check MTU prior to changing packet ctx.
> > + *  
> 
> [...]
> 



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

