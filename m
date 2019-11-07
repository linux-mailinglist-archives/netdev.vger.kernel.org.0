Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A693F38C5
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 20:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfKGTi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 14:38:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:36394 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbfKGTi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 14:38:57 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 11:38:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,279,1569308400"; 
   d="asc'?scan'208";a="213087116"
Received: from karaker-mobl.amr.corp.intel.com ([10.254.95.244])
  by fmsmga001.fm.intel.com with ESMTP; 07 Nov 2019 11:38:56 -0800
Message-ID: <d078d3efc784805a67ba1a1c6e94fb4ec1c0aec6.camel@intel.com>
Subject: Re: [EXTERNAL] RE: [PATCH net] i40e/iavf: Fix msg interface between
 VF and PF
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>,
        "Creeley, Brett" <brett.creeley@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Arkady Gilinsky <arcadyg@gmail.com>
Date:   Thu, 07 Nov 2019 11:38:55 -0800
In-Reply-To: <1573018214.10368.1.camel@harmonicinc.com>
References: <1572845537.13810.225.camel@harmonicinc.com>
         <3508A0C5D531054DBDD98909F6FA64FA11B3936D@ORSMSX113.amr.corp.intel.com>
         <1572931430.13810.227.camel@harmonicinc.com>
         <3508A0C5D531054DBDD98909F6FA64FA11B39863@ORSMSX113.amr.corp.intel.com>
         <1573018214.10368.1.camel@harmonicinc.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-MzFWk4p9XUgHtDSfiW/a"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-MzFWk4p9XUgHtDSfiW/a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-11-06 at 05:30 +0000, Arkady Gilinsky wrote:
> On Tue, 2019-11-05 at 16:55 +0000, Creeley, Brett wrote:
> > > -----Original Message-----
> > > From: Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>
> > > Sent: Monday, November 4, 2019 9:24 PM
> > > To: Creeley, Brett <brett.creeley@intel.com>;=20
> > > intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Kirsher,
> > > Jeffrey T
> > > <jeffrey.t.kirsher@intel.com>
> > > Cc: Arkady Gilinsky <arcadyg@gmail.com>
> > > Subject: Re: [EXTERNAL] RE: [PATCH net] i40e/iavf: Fix msg interface
> > > between VF and PF
> > > > static bool i40e_vc_verify_vqs_bitmaps(struct virtchnl_queue_select
> > > > *vqs)
> > > > {
> > > >    /* this will catch any changes made to the virtchnl_queue_select
> > > > bitmap */
> > > >    if (sizeof(vqs->rx_queues) !=3D sizeof(u32) ||
> > > >         sizeof(vqs->tx_queues) !=3D sizeof(u32))
> > > >            return false;
> > >=20
> > > If so, then is it better to check the type of the fields in compile-
> > > time rather than in runtime ?
> > > Something like this:
> > > BUILD_BUG_ON(sizeof(vqs->rx_queues) !=3D sizeof(u32));
> > > BUILD_BUG_ON(sizeof(vqs->tx_queues) !=3D sizeof(u32));
> > > This is not required comparison each time when function is called and
> > > made code more optimized.
> >=20
> > I don't think this is required with the change you suggested below.
> Agree.
> If other code in driver not need to be adjusted/verified, then this check
> is not needed.
> > > >    if ((vqs->rx_queues =3D=3D 0 && vqs->tx_queues =3D=3D 0) ||
> > > >          hweight32(vqs->rx_queues) > I40E_MAX_VF_QUEUES ||
> > > >          hweight32(vqs->tx_queues) > I40E_MAX_VF_QUEUES)
> > > >            return false;
> > >=20
> > > Again, from optimization POV it is better to have constant changed
> > > than variable,
> > > since it is compile time and not run time action:
> > >      if ((vqs->rx_queues =3D=3D 0 && vqs->tx_queues =3D=3D 0) ||
> > >            vqs->rx_queues >=3D (BIT(I40E_MAX_VF_QUEUES)) ||
> > >=20
> > >       vqs->tx_queues >=3D (BIT(I40E_MAX_VF_QUEUES)))
> > >              return false;
> >=20
> > This seems much better than my solution. It fixes the original issue,
> > handles if the
> > vqs->[r|t]x_queues variables have changed in size, and the queue bitmap
> > comparison
> > uses a constant. Thanks!
> Thanks to you for feedback.
> I am trying to understand if this patch will enter into official kernel
> tree
> and, not less important from my POV, to official Intel drivers.
> Brett/Jeffrey, could you, please, assist to make sure that this fix, or
> fix suggested by Brett,
> will be integrated into Intel i40e/iavf drivers ?
> Or may be I should write mail straight to Intel support ?

As Brett pointed out, there are issues with this patch. Please make the
suggested changes and re-submit the patch to=20
intel-wired-lan@lists.osuosl.org

--=-MzFWk4p9XUgHtDSfiW/a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl3Ecs8ACgkQ5W/vlVpL
7c4yUg/+NqjJAoBF4G0FSEUbD8d2nwfHPMA7aKLRl5IS1TCRf6+49ks0eXVtPZmT
Kk9jYyf4ESWe1xJvLVr0EpNZYDa2iosxZcvwno38q1O4LOEIsTyK/bGzjem0YESP
Il8WGp/wLfPiJ5ZmEm/TeIsECA5oqkklPfzlFQtpZLNX989xesns46kAPixwFwOn
Z5nZqTB/Ev3wh7+pDd6A92N7cvav65p4eQIrSBpLVHiMAbLf2INBlk/ldhKTu/3Z
m/oTO5DT7EMq3YE98okVIfeqBP/fNFlrCZ0VW5Yk3lCA7jc5PCvzb4Jf36xWB9Ex
PO7qs+b37UMoTZfCf6Nk+UbCGin0T/4OI9BJL2DaS8BrbjvXhDRu1qDxNRU+ECCZ
SgJB0zPaamjtgUHE+KIHQHRQSGZvB2ZASTXcyRdqhvCKNzSUqvHkJglQrVOgtaRb
+qwiTdlRpcZLlZY4o/GwnBy3dtKribORDjziOcHAZQXLByvK/JhuqsncfKlING2A
LfXQKg/Bdm32jWXA06EASupVWGqSnnGzp3F0/Q7Eu8vFXBIor2W6Y/1Q0yCNkMTH
2CTGc7QXqWf712K7rvbm9WzVledThRDUU7Vc7ybeLbApbyFI9Lwni6Qo7iJ+l21/
lsYeCrZTOUKAdq1+GciufazF9dPrhEYsdUlC4P0n72sIQI3XFik=
=m1co
-----END PGP SIGNATURE-----

--=-MzFWk4p9XUgHtDSfiW/a--

