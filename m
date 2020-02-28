Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46A7217357A
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 11:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgB1KmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 05:42:18 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21637 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726063AbgB1KmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 05:42:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582886536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wlYYRATcRw1REN9gQxnb1xLG+z0JVZsLAObIn2DKGmc=;
        b=BRHH6fmXCb2zqGmmZk+CL0+WTGQC9K40vxccHg+s9ZvMlBw34gCZht/cE8KmY5TrGxh+Et
        FkOF4CL57lHNgE5mZVdQsHROtUESdyRsDR6FJcfH0ViM5yIRW84roqwbLuJl1KZandv44j
        MMHI47tS2GRKRiEwigejQrr9SYKxvco=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-pSUkARetOyK5IsLxdZyWNg-1; Fri, 28 Feb 2020 05:42:14 -0500
X-MC-Unique: pSUkARetOyK5IsLxdZyWNg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 175CEDBA5;
        Fri, 28 Feb 2020 10:42:12 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7FDF51CB;
        Fri, 28 Feb 2020 10:41:56 +0000 (UTC)
Date:   Fri, 28 Feb 2020 11:41:55 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     David Ahern <dahern@digitalocean.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dsahern@kernel.org>, brouer@redhat.com
Subject: Re: [PATCH RFC v4 bpf-next 03/11] xdp: Add xdp_txq_info to xdp_buff
Message-ID: <20200228114155.648f897e@carbon>
In-Reply-To: <87o8tjuisk.fsf@toke.dk>
References: <20200227032013.12385-1-dsahern@kernel.org>
        <20200227032013.12385-4-dsahern@kernel.org>
        <20200227090046.3e3177b3@carbon>
        <423dd8d6-6e84-01d4-c529-ce85d84fa24b@digitalocean.com>
        <87o8tjuisk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Feb 2020 11:07:23 +0100
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> David Ahern <dahern@digitalocean.com> writes:
>=20
> > On 2/27/20 1:00 AM, Jesper Dangaard Brouer wrote: =20
> >>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> >>> index 7850f8683b81..5e3f8aefad41 100644
> >>> --- a/include/uapi/linux/bpf.h
> >>> +++ b/include/uapi/linux/bpf.h
> >>> @@ -3334,8 +3334,10 @@ struct xdp_md {
> >>>  	__u32 data;
> >>>  	__u32 data_end;
> >>>  	__u32 data_meta;
> >>> -	/* Below access go through struct xdp_rxq_info */
> >>> -	__u32 ingress_ifindex; /* rxq->dev->ifindex */
> >>> +	union {
> >>> +		__u32 ingress_ifindex; /* rxq->dev->ifindex */
> >>> +		__u32 egress_ifindex;  /* txq->dev->ifindex */
> >>> +	}; =20
> >>=20
> >> Are we sure it is wise to "union share" (struct) xdp_md as the
> >> XDP-context in the XDP programs, with different expected_attach_type?
> >> As this allows the XDP-programmer to code an EGRESS program that access
> >> ctx->ingress_ifindex, this will under the hood be translated to
> >> ctx->egress_ifindex, because from the compilers-PoV this will just be =
an
> >> offset.
> >>=20
> >> We are setting up the XDP-programmer for a long debugging session, as
> >> she will be expecting to read 'ingress_ifindex', but will be getting
> >> 'egress_ifindex'.  (As the compiler cannot warn her, and it is also
> >> correct seen from the verifier). =20
> >
> > It both cases it means the device handling the packet. ingress_ifindex
> > =3D=3D device handling the Rx, egress_ifindex =3D=3D device handling th=
e Tx.
> > Really, it is syntactic sugar for program writers. It would have been
> > better had xdp_md only called it ifindex from the beginning. =20
>=20
> Telling users that they are doing it wrong is not going to make their
> debugging session any less frustrating :)
>=20
> If we keep rx_ifindex a separate field we can unambiguously reject a TX
> program that tries to access it, *and* we keep the option of allowing
> access to it later if it does turn out to be useful. IMO that is worth
> the four extra bytes.

I agree. We need unambiguously to help the program writer.

This is the wrong kind of 'syntactic sugar'.  If you want a straight
'ifindex', that translates to the running_ifindex, when you need to add
a new member 'ifindex' that does this rewriting based on attach type.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

