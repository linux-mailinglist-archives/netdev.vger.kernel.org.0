Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20B62A2702
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 10:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgKBJ3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 04:29:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54865 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727953AbgKBJ3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 04:29:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604309344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=szmDFA/jPNK60esMJjmzsnI1cluZsmFQq0H0E9bib68=;
        b=OKsoj6BgqXFd3OUa3zgPhg0u220NSUAPNpOZRi8zvs2LdD7DG18AO2qkf3EilggBe95SZn
        jEPtKqFvywm3RF4seJ9l75BK+L9fiaxkpKH3u3MTlD4F0i8LdmgIci7bMkIUUEg9DbhGKO
        TdpoRkRqw/GDWd2oumqqNieeLGPsyX0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-xBplgDImOayFtPklxT9mdA-1; Mon, 02 Nov 2020 04:29:00 -0500
X-MC-Unique: xBplgDImOayFtPklxT9mdA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95D7D802B76;
        Mon,  2 Nov 2020 09:28:58 +0000 (UTC)
Received: from carbon (unknown [10.36.110.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2941855785;
        Mon,  2 Nov 2020 09:28:51 +0000 (UTC)
Date:   Mon, 2 Nov 2020 10:28:50 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next V5 2/5] bpf: bpf_fib_lookup return MTU value as
 output when looked up
Message-ID: <20201102102850.1dc3124a@carbon>
In-Reply-To: <5f9c6c259dfe5_16d420817@john-XPS-13-9370.notmuch>
References: <160407661383.1525159.12855559773280533146.stgit@firesoul>
        <160407665728.1525159.18300199766779492971.stgit@firesoul>
        <5f9c6c259dfe5_16d420817@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 12:40:21 -0700
John Fastabend <john.fastabend@gmail.com> wrote:

> Jesper Dangaard Brouer wrote:
> > The BPF-helpers for FIB lookup (bpf_xdp_fib_lookup and bpf_skb_fib_lookup)
> > can perform MTU check and return BPF_FIB_LKUP_RET_FRAG_NEEDED.  The BPF-prog
> > don't know the MTU value that caused this rejection.
> > 
> > If the BPF-prog wants to implement PMTU (Path MTU Discovery) (rfc1191) it
> > need to know this MTU value for the ICMP packet.
> > 
> > Patch change lookup and result struct bpf_fib_lookup, to contain this MTU
> > value as output via a union with 'tot_len' as this is the value used for
> > the MTU lookup.
> > 
> > V5:
> >  - Fixed uninit value spotted by Dan Carpenter.
> >  - Name struct output member mtu_result
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  include/uapi/linux/bpf.h       |   11 +++++++++--
> >  net/core/filter.c              |   22 +++++++++++++++-------
> >  tools/include/uapi/linux/bpf.h |   11 +++++++++--
> >  3 files changed, 33 insertions(+), 11 deletions(-)
> > 
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index e6ceac3f7d62..01b2b17c645a 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2219,6 +2219,9 @@ union bpf_attr {
> >   *		* > 0 one of **BPF_FIB_LKUP_RET_** codes explaining why the
> >   *		  packet is not forwarded or needs assist from full stack
> >   *
> > + *		If lookup fails with BPF_FIB_LKUP_RET_FRAG_NEEDED, then the MTU
> > + *		was exceeded and result params->mtu contains the MTU.
> > + *  
> 
> Do we need to hide this behind a flag? It seems otherwise you might confuse
> users. I imagine on error we could reuse the params arg, but now we changed
> the tot_len value underneath them?

The principle behind this bpf_fib_lookup helper, is that params (struct
bpf_fib_lookup) is used for both input and output (results). Almost
every field is change after the lookup. (For performance reasons this
is kept at 64 bytes (cache-line))  Thus, users of this helper already
expect/knows the contents of params have changed.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


struct bpf_fib_lookup {
	/* input:  network family for lookup (AF_INET, AF_INET6)
	 * output: network family of egress nexthop
	 */
	__u8	family;

	/* set if lookup is to consider L4 data - e.g., FIB rules */
	__u8	l4_protocol;
	__be16	sport;
	__be16	dport;

	union {	/* used for MTU check */
		/* input to lookup */
		__u16	tot_len; /* total length of packet from network hdr */

		/* output: MTU value (if requested check_mtu) */
		__u16	mtu_result;
	};
	/* input: L3 device index for lookup
	 * output: device index from FIB lookup
	 */
	__u32	ifindex;

	union {
		/* inputs to lookup */
		__u8	tos;		/* AF_INET  */
		__be32	flowinfo;	/* AF_INET6, flow_label + priority */

		/* output: metric of fib result (IPv4/IPv6 only) */
		__u32	rt_metric;
	};

	union {
		__be32		ipv4_src;
		__u32		ipv6_src[4];  /* in6_addr; network order */
	};

	/* input to bpf_fib_lookup, ipv{4,6}_dst is destination address in
	 * network header. output: bpf_fib_lookup sets to gateway address
	 * if FIB lookup returns gateway route
	 */
	union {
		__be32		ipv4_dst;
		__u32		ipv6_dst[4];  /* in6_addr; network order */
	};

	/* output */
	__be16	h_vlan_proto;
	__be16	h_vlan_TCI;
	__u8	smac[6];     /* ETH_ALEN */
	__u8	dmac[6];     /* ETH_ALEN */
};

