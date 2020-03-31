Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B87611996C4
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 14:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbgCaMqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 08:46:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20878 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730642AbgCaMqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 08:46:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585658772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MhLmTwRYGfbNwqSZwO73yTglY5xr4MOCIRtIOTonrUU=;
        b=ENXio1l1kPQ0HqwV0sL0sjxBzy0KxQtWn5IWnBeqqxSng4eMr2zx6AKD+ZSTA4wxHU4k/q
        NwXGwLB4MMSdhqjKsm2Hk+ZcH11ltjiK4WaHOOWv0edcZ9JwHy8yZTHTZyBFH+MP4lk5ai
        /TPUE0GevlthkgtyD+G4Tc48avXPeEM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-aMgtP6qpM1-Nh3uoByGlaQ-1; Tue, 31 Mar 2020 08:46:09 -0400
X-MC-Unique: aMgtP6qpM1-Nh3uoByGlaQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 416981085939;
        Tue, 31 Mar 2020 12:46:07 +0000 (UTC)
Received: from localhost (ovpn-116-139.gru2.redhat.com [10.97.116.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C98285DA60;
        Tue, 31 Mar 2020 12:46:06 +0000 (UTC)
Date:   Tue, 31 Mar 2020 09:46:05 -0300
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH v2] net/bpfilter: fix dprintf usage for /dev/kmsg
Message-ID: <20200331124605.GG10754@glitch>
References: <CALidq=VmXZ5erdNOeBdXE087QHO7SZVn4rb5+M26GrB56dpYpQ@mail.gmail.com>
 <20200330131313.GA10754@glitch>
MIME-Version: 1.0
In-Reply-To: <20200330131313.GA10754@glitch>
X-PGP-Key: http://keys.gnupg.net/pks/lookup?op=get&search=0x3823031E4660608D
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xQmOcGOVkeO43v2v"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--xQmOcGOVkeO43v2v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 30, 2020 at 10:13:15AM -0300, Bruno Meneguele wrote:
> On Mon, Mar 30, 2020 at 03:48:12PM +0300, Martin Zaharinov wrote:
> > Hi Bruno
> > i see after release kernel 5.6.0 with your latest patch have strange
> > messages please check:
> >=20
> > [   31.025483] bpfilter: Loaded bpfilter_umh pid 2689
> > [   31.025533] Started bpfilter
> > [   31.042586] testing the buffer
> > [   31.050822] testing the buffer
> > [   31.059304] testing the buffer
> > [   31.067747] testing the buffer
> > [   31.148789] testing the buffer
> > [   31.156130] testing the buffer
> > [   31.164012] testing the buffer
> > [   31.170685] testing the buffer
> > [   31.176886] testing the buffer
> >=20
> > when drop bpfilter module stop enter new messages in kmsg.
> >=20
>=20
> Hi Martin,
>=20
> these aren't really "strange messages", but the correct ones. They
> started to appear now because before my patch the log wasn't working at
> all. I'm not really aware what is the logic behind the bpfilter_umh
> module, but AFAIK each iptable rule sent from kernel side to UMH
> userspace code will generate one "testing the buffer" message.
>=20
> I think we can silence it by limiting it to print only once, but I would
> need to check with Alexei Starovoitov <ast@kernel.org> if it would be
> fine (CC'ing here).
>=20
> Thanks for the heads up :).
>=20

Wow, forget about all of that! That's actually my mistake!
This "testing the buffer" was actually added by my own patch! How could
I not see that? I'm really sorry and /thanks/ at the same time Martin.
I'm going to send a new patch removing it.


--=20
bmeneg=20
PGP Key: http://bmeneg.com/pubkey.txt

--xQmOcGOVkeO43v2v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEdWo6nTbnZdbDmXutYdRkFR+RokMFAl6DO40ACgkQYdRkFR+R
okPFrQgAu10gME44DnFRT25F5xGXRKi2Qobh5YM7/nH9pxEiQmi545D/ctUMfWXr
6TzVdwsdC81ycnZ6P1UU1/JWPwcqFSLZQIETDYwaiBBf4bVDW38NSd6sWeO6/BNN
CdYH1PHKSrvkZtWUscwq42JrdR/R3Av6WDQtdnyPkRNt7ci8h2BTAgCWmzoMb+A3
9nj85Q/p/rIVIZZNbblTOXZvk9IZW4zoWwMPjieUeTi0gtZkO9gHBwT+CvpClLTN
r0UCy6vYDXcj24015pKpcsnADLWPtcdtclHX6rNPskyo9mi2Ryg7/sMUhmL7TfpZ
2Yep/MgElRPkCOrW15UYm3alL6rsWQ==
=VK6V
-----END PGP SIGNATURE-----

--xQmOcGOVkeO43v2v--

