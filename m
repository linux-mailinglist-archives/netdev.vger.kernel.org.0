Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1A630492B
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387628AbhAZFaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:30:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731841AbhAYTdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 14:33:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B7C321D79;
        Mon, 25 Jan 2021 19:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611603152;
        bh=+PPjBpw9iumIdesQ8VOZeMYYXa4HtrBTzlEGzCaGB6U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FsMpNpNw7fl/sXo4/N11KW3MC96IzllRElgwfNiD2ef84SmbaQTof7xw7jUG8qANy
         wpCfhBFsdUGlju4CM6Y+9fS5zEmY/g/+WuPCMCzmd5EOmmYwYPwERGsONzFyazopW/
         85ilj/4/TK9pJ2Uti6og/wCt/K3ngma7m2i7BGhAYkXRSbGOJMMNMBX5Hhf3zAsOmh
         URfDhMi5XVgalmzqTspPcMZUKOh34oadfbGNrVxAkLD4wrFEZGGQOcdKsWTfFDzNzq
         t3kUO/kA6D5VAxIvRxlr7FhN1bEnYMcrG9gwUT7X+Qkw62kUaazrstGKB2hmT8TSYZ
         go3rahlNx7/JQ==
Date:   Mon, 25 Jan 2021 11:32:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org,
        davem@davemloft.net, alex aring <alex.aring@gmail.com>
Subject: Re: [PATCH net 1/1] uapi: fix big endian definition of
 ipv6_rpl_sr_hdr
Message-ID: <20210125113231.3fac0e10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fd7957e7-ab5c-d2c2-9338-76879563460e@gmail.com>
References: <20210121220044.22361-1-justin.iurman@uliege.be>
        <20210121220044.22361-2-justin.iurman@uliege.be>
        <20210123205444.5e1df187@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <55663307.1072450.1611482265804.JavaMail.zimbra@uliege.be>
        <fd7957e7-ab5c-d2c2-9338-76879563460e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Jan 2021 11:57:03 -0700 David Ahern wrote:
> On 1/24/21 2:57 AM, Justin Iurman wrote:
> >> De: "Jakub Kicinski" <kuba@kernel.org>
> >> =C3=80: "Justin Iurman" <justin.iurman@uliege.be>
> >> Cc: netdev@vger.kernel.org, davem@davemloft.net, "alex aring" <alex.ar=
ing@gmail.com>
> >> Envoy=C3=A9: Dimanche 24 Janvier 2021 05:54:44
> >> Objet: Re: [PATCH net 1/1] uapi: fix big endian definition of ipv6_rpl=
_sr_hdr =20
> >  =20
> >> On Thu, 21 Jan 2021 23:00:44 +0100 Justin Iurman wrote: =20
> >>> Following RFC 6554 [1], the current order of fields is wrong for big
> >>> endian definition. Indeed, here is how the header looks like:
> >>>
> >>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >>> |  Next Header  |  Hdr Ext Len  | Routing Type  | Segments Left |
> >>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >>> | CmprI | CmprE |  Pad  |               Reserved                |
> >>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >>>
> >>> This patch reorders fields so that big endian definition is now corre=
ct.
> >>>
> >>>   [1] https://tools.ietf.org/html/rfc6554#section-3
> >>>
> >>> Signed-off-by: Justin Iurman <justin.iurman@uliege.be> =20
> >>
> >> Are you sure? This looks right to me. =20
> >=20
> > AFAIK, yes. Did you mean the old (current) one looks right, or the new =
one?=20

Old one / existing is correct.

> > If you meant the old/current one, well, I don't understand why the big =
endian definition would look like this:
> >=20
> > #elif defined(__BIG_ENDIAN_BITFIELD)
> > 	__u32	reserved:20,
> > 		pad:4,
> > 		cmpri:4,
> > 		cmpre:4;
> >=20
> > When the RFC defines the header as follows:
> >=20
> > +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> > | CmprI | CmprE |  Pad  |               Reserved                |
> > +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >=20
> > The little endian definition looks fine. But, when it comes to big endi=
an, you define fields as you see them on the wire with the same order, righ=
t? So the current big endian definition makes no sense. It looks like it wa=
s a wrong mix with the little endian conversion.

Well, you don't list the bit positions in the quote from the RFC, and
I'm not familiar with the IETF parlor. I'm only comparing the LE
definition with the BE. If you claim the BE is wrong, then the LE is
wrong, too.

> >>> diff --git a/include/uapi/linux/rpl.h b/include/uapi/linux/rpl.h
> >>> index 1dccb55cf8c6..708adddf9f13 100644
> >>> --- a/include/uapi/linux/rpl.h
> >>> +++ b/include/uapi/linux/rpl.h
> >>> @@ -28,10 +28,10 @@ struct ipv6_rpl_sr_hdr {
> >>>  		pad:4,
> >>>  		reserved1:16;
> >>>  #elif defined(__BIG_ENDIAN_BITFIELD)
> >>> -	__u32	reserved:20,
> >>> +	__u32	cmpri:4,
> >>> +		cmpre:4,
> >>>  		pad:4,
> >>> -		cmpri:4,
> >>> -		cmpre:4;
> >>> +		reserved:20;
> >>>  #else
> >>>  #error  "Please fix <asm/byteorder.h>"
> >>>  #endif =20
>=20
> cross-checking with other headers - tcp and vxlan-gpe - this patch looks
> correct.

What are you cross-checking?
