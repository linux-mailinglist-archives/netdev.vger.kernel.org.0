Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1C418C173
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 21:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgCSUdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 16:33:45 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:50572 "EHLO
        script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgCSUdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 16:33:45 -0400
X-DKIM: Courier DKIM Filter v0.50+pk-2017-10-25 mail.cs.helsinki.fi Thu, 19 Mar 2020 22:33:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.helsinki.fi;
         h=date:from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type; s=dkim20130528; bh=SAnJOdfd6Sr+2Q3KZ
        EWzQqrrkTbV182u9jiaj1x0Rp8=; b=TwfyFKQRP3mm2HD2L/oGTe3DgsynOeXjW
        QfxnatEZOjMJ1QMrTP4MmPk01gaFia/26pD1x/n8FPrbGIwU/S5VHRM5nmgM7Eig
        UFR4ZKAPYRQ6BDPqrJtxsc5/256Jgo6ask6PN082sIYCaDXMCGzJ+NjF1q+yqhjp
        vu/KwLZBr8=
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
  (TLS: TLSv1/SSLv3,256bits,AES256-GCM-SHA384)
  by mail.cs.helsinki.fi with ESMTPS; Thu, 19 Mar 2020 22:33:43 +0200
  id 00000000005A0146.000000005E73D727.000023D1
Date:   Thu, 19 Mar 2020 22:33:43 +0200 (EET)
From:   "=?ISO-8859-15?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@cs.helsinki.fi>
X-X-Sender: ijjarvin@whs-18.cs.helsinki.fi
To:     Eric Dumazet <eric.dumazet@gmail.com>
cc:     Netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: Re: [RFC PATCH 24/28] tcp: try to fit AccECN option with SACK
In-Reply-To: <4ae2c8be-3235-9158-a2a7-7f9d30a20c04@gmail.com>
Message-ID: <alpine.DEB.2.20.2003192225360.5256@whs-18.cs.helsinki.fi>
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi> <1584524612-24470-25-git-send-email-ilpo.jarvinen@helsinki.fi> <4ae2c8be-3235-9158-a2a7-7f9d30a20c04@gmail.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=_script-9193-1584650023-0001-2"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_script-9193-1584650023-0001-2
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Mar 2020, Eric Dumazet wrote:

>=20
>=20
> On 3/18/20 2:43 AM, Ilpo J=E4rvinen wrote:
> > From: Ilpo J=E4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> >=20
> > As SACK blocks tend to eat all option space when there are
> > many holes, it is useful to compromise on sending many SACK
> > blocks in every ACK and try to fit AccECN option there
> > by reduction the number of SACK blocks. But never go below
> > two SACK blocks because of AccECN option.
> >=20
> > As AccECN option is often not put to every ACK, the space
> > hijack is usually only temporary.
> >=20
> > Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> > ---
> >  net/ipv4/tcp_output.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >=20
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index 4cc590a47f43..0aec2c57a9cc 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -756,6 +756,21 @@ static int tcp_options_fit_accecn(struct tcp_out=
_options *opts, int required,
> >  =09if (opts->num_ecn_bytes < required)
> >  =09=09return 0;
>=20
> Have you tested this patch ?
>=20
> (You forgot to remove the prior 2 lines)
>=20
> > =20
> > +=09if (opts->num_ecn_bytes < required) {

Yes and no. There was no unit test for this particular condition but
I added a few now (with and w/o timestamps). I also managed to find and=20
fix a byte-order related bug related to non-fullsized option while making=20
those tests.

(I didn't actually forget to remove it. I managed to add the problem=20
during a botched conflict merge when I reorganized some of the code.)

Thanks for taking a look.

--=20
 i.
--=_script-9193-1584650023-0001-2--
