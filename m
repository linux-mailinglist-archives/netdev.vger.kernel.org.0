Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26ABC30A46D
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 10:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbhBAJe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 04:34:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47061 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232623AbhBAJeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 04:34:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612171975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xDtpb7Q+oiMPNub1GlQ+l80Sp6rhVvOc99y/YWzp/ho=;
        b=OeG/PL6KYI08LnD3muH/qGsdi2b1STFf/CANQIdnyCsppnR42QznQZExRtQeG71h7CP/CX
        9nTQX7UM82BB02P5ZKm9OCm/irGftDLMR+tgdo5u6A9lmvdKs0vwtqTg+SAb+rRkqWdGO9
        uehEyQ4P/Nn6RxOdvug/xR5YCRaZvlA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-rKHNXwO3Omqlb5dzavWi2A-1; Mon, 01 Feb 2021 04:32:11 -0500
X-MC-Unique: rKHNXwO3Omqlb5dzavWi2A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13AB81005D4D;
        Mon,  1 Feb 2021 09:32:09 +0000 (UTC)
Received: from carbon (unknown [10.36.110.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3F9B10013C0;
        Mon,  1 Feb 2021 09:32:01 +0000 (UTC)
Date:   Mon, 1 Feb 2021 10:31:58 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, kuba@kernel.org,
        jonathan.lemon@gmail.com, maximmi@nvidia.com, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com
Subject: Re: [RFC PATCH bpf-next] bpf, xdp: per-map bpf_redirect_map
 functions for XDP
Message-ID: <20210201103158.6afccf33@carbon>
In-Reply-To: <e77f259a-2381-1a6e-6e2c-f5afceb35c51@intel.com>
References: <20210129153215.190888-1-bjorn.topel@gmail.com>
        <87im7fy9nc.fsf@toke.dk>
        <e77f259a-2381-1a6e-6e2c-f5afceb35c51@intel.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 07:27:57 +0100
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> wrote:

> On 2021-01-29 17:45, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
> >  =20
> >> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >>
> >> Currently the bpf_redirect_map() implementation dispatches to the
> >> correct map-lookup function via a switch-statement. To avoid the
> >> dispatching, this change adds one bpf_redirect_map() implementation per
> >> map. Correct function is automatically selected by the BPF verifier.
> >>
> >> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >> ---
> >> Hi XDP-folks!
> >>
> >> This is another take on my bpf_redirect_xsk() patch [1]. I figured I
> >> send it as an RFC for some early input. My plan is to include it as
> >> part of the xdp_do_redirect() optimization of [1]. =20
> >=20
> > Assuming the maintainers are OK with the special-casing in the verifier,
> > this looks like a neat way to avoid the runtime overhead to me. The
> > macro hackery is not the prettiest; I wonder if the same effect could be
> > achieved by using inline functions? If not, at least a comment
> > explaining the reasoning (and that the verifier will substitute the
> > right function) might be nice? Mostly in relation to this bit:
> > =20
>=20
> Yeah, I agree with the macro part. I'll replace it with a
> __always_inline function, instead.
>=20

Yes, I also prefer __always_inline over the macro.


> >>   static const struct bpf_func_proto bpf_xdp_redirect_map_proto =3D {
> >> -	.func           =3D bpf_xdp_redirect_map,
> >> +	.func           =3D bpf_xdp_redirect_devmap, =20
> > =20
>=20
> I'll try to clean this up as well.

I do like the optimization of having the verifier call the right map
func directly.  Could you please add a descriptive comment that
describe this above "bpf_xdp_redirect_map_proto", that this is
happening in fixup_bpf_calls and use get_xdp_redirect_func (what you
define).  It is a cool trick, but people reading the code will have a
hard time following.

Surprisingly people do read this code and tries to follow.  I've had
discussions on the Cilium Slack channel, where people misunderstood how
our bpf_fib_lookup() calls gets mapped to two different functions
depending on context (SKB vs XDP).  And that remapping happens in the
same file (net/core/filter.c).

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

