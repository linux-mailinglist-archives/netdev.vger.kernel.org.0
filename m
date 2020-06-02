Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544541EB7C4
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 10:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgFBI7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 04:59:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25468 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726160AbgFBI7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 04:59:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591088361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r51f9Yl8IkbzgTP6qaG1uuW9x8a13vtMoUbBALLSsYc=;
        b=d8C8Gt0rUMPvwmTq7COlBTEvBvPwrJn612kBK2i4SpjpaI/5hhzAC9j9qxxu9cQGfjQ0e6
        CR7dKDcB2LRQIDPtNGv/p/NesHpE2EKvzM+fDNB5pWWywwe+rtfIxpigdwR6cy0hI85QNK
        jmcfANiHtb7UFjSIBI9nV2NWMa3CwS8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-VeLhq4KlM7epGP4TVzYZUQ-1; Tue, 02 Jun 2020 04:59:19 -0400
X-MC-Unique: VeLhq4KlM7epGP4TVzYZUQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23572100A8E7;
        Tue,  2 Jun 2020 08:59:18 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B83E579A3;
        Tue,  2 Jun 2020 08:59:10 +0000 (UTC)
Date:   Tue, 2 Jun 2020 10:59:08 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next RFC 2/3] bpf: devmap dynamic map-value storage
 area based on BTF
Message-ID: <20200602105908.19254e0f@carbon>
In-Reply-To: <87tuzyzodv.fsf@toke.dk>
References: <159076794319.1387573.8722376887638960093.stgit@firesoul>
        <159076798566.1387573.8417040652693679408.stgit@firesoul>
        <87tuzyzodv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 18:39:40 +0200
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>=20
> > The devmap map-value can be read from BPF-prog side, and could be used =
for a
> > storage area per device. This could e.g. contain info on headers that n=
eed
> > to be added when packet egress this device.
> >
> > This patchset adds a dynamic storage member to struct bpf_devmap_val. M=
ore
> > importantly the struct bpf_devmap_val is made dynamic via leveraging and
> > requiring BTF for struct sizes above 4. The only mandatory struct membe=
r is
> > 'ifindex' with a fixed offset of zero.
> >
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  kernel/bpf/devmap.c |  216 +++++++++++++++++++++++++++++++++++++++++++=
+-------
> >  1 file changed, 185 insertions(+), 31 deletions(-)
> >
> > diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> > index 4ab67b2d8159..9cf2dadcc0fe 100644
[...]
> > @@ -60,13 +61,30 @@ struct xdp_dev_bulk_queue {
> >  	unsigned int count;
> >  };
> > =20
> > -/* DEVMAP values */
> > +/* DEVMAP map-value layout.
> > + *
> > + * The struct data-layout of map-value is a configuration interface.
> > + * BPF-prog side have read-only access to this memory.
> > + *
> > + * The layout might be different than below, because some struct membe=
rs are
> > + * optional.  This is made dynamic by requiring userspace provides an =
BTF
> > + * description of the struct layout, when creating the BPF-map. Struct=
 names
> > + * are important and part of API, as BTF use these names to identify m=
embers.
> > + */
> >  struct bpf_devmap_val {
> > -	__u32 ifindex;   /* device index */
> > +	__u32 ifindex;   /* device index - mandatory */
> >  	union {
> >  		int   fd;  /* prog fd on map write */
> >  		__u32 id;  /* prog id on map read */
> >  	} bpf_prog;
> > +	struct {
> > +		/* This 'storage' member is meant as a dynamically sized area,
> > +		 * that BPF developer can redefine.  As other members are added
> > +		 * overtime, this area can shrink, as size can be regained by
> > +		 * not using members above. Add new members above this struct.
> > +		 */
> > +		unsigned char data[24];
> > +	} storage; =20
>=20
> Why is this needed? Userspace already passes in the value_size, so why
> can't the kernel just use the BTF to pick out the values it cares about
> and let the rest be up to userspace?

The kernel cannot just ignore unknown struct members, due to forward
compatibility. An older kernel that sees a new struct member, cannot
know what this struct member is used for.  Thus, later I'm rejecting
map creation if I detect members kernel doesn't know about.

This means, that I need to create a named area (e.g. named 'storage')
that users can define their own layout within.

This might be difficult to comprehend for other kernel developers,
because usually we create forward compatibility via walking the binary
struct and then assume that if an unknown area (in end-of-struct)
contains zeros, then it means end-user isn't using that unknown feature.
This doesn't work when the default value, as in this exact case, need
to be minus-1 do describe "unused" as this is a file descriptor.

Forward compatibility is different here.  If the end-user include the
member in their BTF description, that means they intend to use it.
Thus, kernel need to reject map-create if it sees unknown members.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

