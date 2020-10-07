Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5BE2859B6
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 09:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgJGHmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 03:42:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727647AbgJGHmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 03:42:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602056563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D2uOqjniwFaaYQqdEXCT7Pau+AwQieo07AtY7kWhwzg=;
        b=hM3A0Bsz1Dhbk4D4FQbNMCDMV73AMZVgMquo1pbNpTBJgnkmJURoCthHAsu20q9jJ+gLUh
        W+SqVHV0YucqxqtmH/trExXNTjK54n/tqDzzVPwrfTH9wHQP10kyZbveTpUpBLkUQ6/hiQ
        iYiBZaesrpwNFJ4F16o2m4/DmK9h11o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-qYv0bEllMfGrKYoSxrdbIw-1; Wed, 07 Oct 2020 03:42:40 -0400
X-MC-Unique: qYv0bEllMfGrKYoSxrdbIw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9227101FFA8;
        Wed,  7 Oct 2020 07:42:37 +0000 (UTC)
Received: from carbon (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1DFA5576D;
        Wed,  7 Oct 2020 07:42:30 +0000 (UTC)
Date:   Wed, 7 Oct 2020 09:42:28 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>
Cc:     bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, brouer@redhat.com,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH bpf-next V1 2/6] bpf: bpf_fib_lookup return MTU value as
 output when looked up
Message-ID: <20201007094228.5919998b@carbon>
In-Reply-To: <CANP3RGfeh=a=h2C4voLtfWtvKG7ezaPb7y6r0W1eOjA2ZoNHaw@mail.gmail.com>
References: <160200013701.719143.12665708317930272219.stgit@firesoul>
        <160200017655.719143.17344942455389603664.stgit@firesoul>
        <CANP3RGfeh=a=h2C4voLtfWtvKG7ezaPb7y6r0W1eOjA2ZoNHaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Oct 2020 18:34:50 -0700
Maciej =C5=BBenczykowski <maze@google.com> wrote:

> On Tue, Oct 6, 2020 at 9:03 AM Jesper Dangaard Brouer <brouer@redhat.com>=
 wrote:
> >
> > The BPF-helpers for FIB lookup (bpf_xdp_fib_lookup and bpf_skb_fib_look=
up)
> > can perform MTU check and return BPF_FIB_LKUP_RET_FRAG_NEEDED.  The BPF=
-prog
> > don't know the MTU value that caused this rejection.
> >
> > If the BPF-prog wants to implement PMTU (Path MTU Discovery) (rfc1191) =
it
> > need to know this MTU value for the ICMP packet.
> >
> > Patch change lookup and result struct bpf_fib_lookup, to contain this M=
TU
> > value as output via a union with 'tot_len' as this is the value used for
> > the MTU lookup.
> >
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  include/uapi/linux/bpf.h |   11 +++++++++--
> >  net/core/filter.c        |   17 ++++++++++++-----
> >  2 files changed, 21 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index c446394135be..50ce65e37b16 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
[...]
> > @@ -4844,9 +4847,13 @@ struct bpf_fib_lookup {
> >         __be16  sport;
> >         __be16  dport;
> >
> > -       /* total length of packet from network header - used for MTU ch=
eck */
> > -       __u16   tot_len;
> > +       union { /* used for MTU check */
> > +               /* input to lookup */
> > +               __u16   tot_len; /* total length of packet from network=
 hdr */
> >
> > +               /* output: MTU value (if requested check_mtu) */
> > +               __u16   mtu;
> > +       };
> >         /* input: L3 device index for lookup
> >          * output: device index from FIB lookup
> >          */
[...]
>=20
> It would be beneficial to be able to fetch the route advmss, initcwnd,
> etc as well...
> But I take it the struct can't be extended?

The struct bpf_fib_lookup is exactly 1 cache-line (64 bytes) for
performance reasons.  I do believe that it can be extended, as Ahern
designed the BPF-helper API cleverly via a plen (detail below signature).

For accessing other route metric information like advmss and initcwnd,
I would expect Daniel to suggest to use BTF to access info from
dst_entry, or actually dst->_metrics. But looking at the details for
accessing dst->_metrics is complicated by macros, thus I expect BTF
would have a hard time.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

int bpf_fib_lookup(void *ctx, struct bpf_fib_lookup *params, int plen, u32 =
flags)

$ pahole -C bpf_fib_lookup
struct bpf_fib_lookup {
	__u8                       family;               /*     0     1 */
	__u8                       l4_protocol;          /*     1     1 */
	__be16                     sport;                /*     2     2 */
	__be16                     dport;                /*     4     2 */
	union {
		__u16              tot_len;              /*     6     2 */
		__u16              mtu;                  /*     6     2 */
	};                                               /*     6     2 */
	__u32                      ifindex;              /*     8     4 */
	union {
		__u8               tos;                  /*    12     1 */
		__be32             flowinfo;             /*    12     4 */
		__u32              rt_metric;            /*    12     4 */
	};                                               /*    12     4 */
	union {
		__be32             ipv4_src;             /*    16     4 */
		__u32              ipv6_src[4];          /*    16    16 */
	};                                               /*    16    16 */
	union {
		__be32             ipv4_dst;             /*    32     4 */
		__u32              ipv6_dst[4];          /*    32    16 */
	};                                               /*    32    16 */
	__be16                     h_vlan_proto;         /*    48     2 */
	__be16                     h_vlan_TCI;           /*    50     2 */
	__u8                       smac[6];              /*    52     6 */
	__u8                       dmac[6];              /*    58     6 */

	/* size: 64, cachelines: 1, members: 13 */
};


struct dst_metrics {
	u32		metrics[RTAX_MAX];
	refcount_t	refcnt;
} __aligned(4);		/* Low pointer bits contain DST_METRICS_FLAGS */

extern const struct dst_metrics dst_default_metrics;

#define DST_METRICS_READ_ONLY		0x1UL
#define DST_METRICS_REFCOUNTED		0x2UL
#define DST_METRICS_FLAGS		0x3UL
#define __DST_METRICS_PTR(Y)	\
	((u32 *)((Y) & ~DST_METRICS_FLAGS))
#define DST_METRICS_PTR(X)	__DST_METRICS_PTR((X)->_metrics)


static inline u32
dst_metric_raw(const struct dst_entry *dst, const int metric)
{
	u32 *p =3D DST_METRICS_PTR(dst);

	return p[metric-1];
}

static inline u32
dst_metric_advmss(const struct dst_entry *dst)
{
	u32 advmss =3D dst_metric_raw(dst, RTAX_ADVMSS);

	if (!advmss)
		advmss =3D dst->ops->default_advmss(dst);

	return advmss;
}

