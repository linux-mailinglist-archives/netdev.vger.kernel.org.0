Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A751EB909
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 12:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgFBKBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 06:01:35 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31324 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725811AbgFBKBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 06:01:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591092093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PmTtQ3ibqfrrDHlho+FTT5b9gEDz+ZOULuQ1xKCm2Mg=;
        b=SqIK+I8+UEvAPF1wBDQ56QipZgE5tFdf0lIm09Npj3ne3sWJcz9+oHuBDPIV2JyOFaIXrK
        IHRLE1eefGK3Mhw145Q6uPwitVvYqbyUWBmiYTJu8ysFAZjyO9Iui0Unjo44dzTd7GCZCM
        vtZIDX3zy/zHO9HKJP0UzBTnSthau+A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-g2HrNGMeNk-z552ZKhR-OA-1; Tue, 02 Jun 2020 06:01:30 -0400
X-MC-Unique: g2HrNGMeNk-z552ZKhR-OA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 711BF107ACF2;
        Tue,  2 Jun 2020 10:01:29 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 363F619C4F;
        Tue,  2 Jun 2020 10:01:21 +0000 (UTC)
Date:   Tue, 2 Jun 2020 12:01:20 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next RFC 2/3] bpf: devmap dynamic map-value storage
 area based on BTF
Message-ID: <20200602120120.15d07304@carbon>
In-Reply-To: <87a71lzur7.fsf@toke.dk>
References: <159076794319.1387573.8722376887638960093.stgit@firesoul>
        <159076798566.1387573.8417040652693679408.stgit@firesoul>
        <87tuzyzodv.fsf@toke.dk>
        <20200602105908.19254e0f@carbon>
        <87a71lzur7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 02 Jun 2020 11:23:24 +0200
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>=20
> > On Fri, 29 May 2020 18:39:40 +0200
> > Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
> > =20
> >> Jesper Dangaard Brouer <brouer@redhat.com> writes:
> >>  =20
> >> > The devmap map-value can be read from BPF-prog side, and could be us=
ed for a
> >> > storage area per device. This could e.g. contain info on headers tha=
t need
> >> > to be added when packet egress this device.
> >> >
> >> > This patchset adds a dynamic storage member to struct bpf_devmap_val=
. More
> >> > importantly the struct bpf_devmap_val is made dynamic via leveraging=
 and
> >> > requiring BTF for struct sizes above 4. The only mandatory struct me=
mber is
> >> > 'ifindex' with a fixed offset of zero.
> >> >
> >> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >> > ---
> >> >  kernel/bpf/devmap.c |  216 ++++++++++++++++++++++++++++++++++++++++=
++++-------
> >> >  1 file changed, 185 insertions(+), 31 deletions(-)
> >> >
> >> > diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> >> > index 4ab67b2d8159..9cf2dadcc0fe 100644 =20
> > [...] =20
> >> > @@ -60,13 +61,30 @@ struct xdp_dev_bulk_queue {
> >> >  	unsigned int count;
> >> >  };
> >> > =20
> >> > -/* DEVMAP values */
> >> > +/* DEVMAP map-value layout.
> >> > + *
> >> > + * The struct data-layout of map-value is a configuration interface.
> >> > + * BPF-prog side have read-only access to this memory.
> >> > + *
> >> > + * The layout might be different than below, because some struct me=
mbers are
> >> > + * optional.  This is made dynamic by requiring userspace provides =
an BTF
> >> > + * description of the struct layout, when creating the BPF-map. Str=
uct names
> >> > + * are important and part of API, as BTF use these names to identif=
y members.
> >> > + */
> >> >  struct bpf_devmap_val {
> >> > -	__u32 ifindex;   /* device index */
> >> > +	__u32 ifindex;   /* device index - mandatory */
> >> >  	union {
> >> >  		int   fd;  /* prog fd on map write */
> >> >  		__u32 id;  /* prog id on map read */
> >> >  	} bpf_prog;
> >> > +	struct {
> >> > +		/* This 'storage' member is meant as a dynamically sized area,
> >> > +		 * that BPF developer can redefine.  As other members are added
> >> > +		 * overtime, this area can shrink, as size can be regained by
> >> > +		 * not using members above. Add new members above this struct.
> >> > +		 */
> >> > +		unsigned char data[24];
> >> > +	} storage;   =20
> >>=20
> >> Why is this needed? Userspace already passes in the value_size, so why
> >> can't the kernel just use the BTF to pick out the values it cares about
> >> and let the rest be up to userspace? =20
> >
> > The kernel cannot just ignore unknown struct members, due to forward
> > compatibility. An older kernel that sees a new struct member, cannot
> > know what this struct member is used for.  Thus, later I'm rejecting
> > map creation if I detect members kernel doesn't know about.
> >
> > This means, that I need to create a named area (e.g. named 'storage')
> > that users can define their own layout within.
> >
> > This might be difficult to comprehend for other kernel developers,
> > because usually we create forward compatibility via walking the binary
> > struct and then assume that if an unknown area (in end-of-struct)
> > contains zeros, then it means end-user isn't using that unknown feature.
> > This doesn't work when the default value, as in this exact case, need
> > to be minus-1 do describe "unused" as this is a file descriptor.
> >
> > Forward compatibility is different here.  If the end-user include the
> > member in their BTF description, that means they intend to use it.
> > Thus, kernel need to reject map-create if it sees unknown members. =20
>=20
> Ah, right, of course. You could still allow such a "user-defined" member
> to be any size userspace likes, though, couldn't you?

Yes.  In this implementation the "user-defined" member 'storage' do have
variable size (and can be non-existing).  Do you mean that I have
limited the total size of the struct to be 32 bytes?
(Which is true, and that can also be made dynamic, but I was trying to
limit the scope of patch.  It is hard enough to wrap head around the
binary struct from userspace is becoming dynamic)

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

