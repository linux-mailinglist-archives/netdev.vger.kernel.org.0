Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FEB2675DA
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgIKW0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgIKW0p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 18:26:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3F6B221EB;
        Fri, 11 Sep 2020 22:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599863204;
        bh=yOjknxlLcen/3xo7dj7u4vMkZ5aWaIFXMK+QrZqbCEk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cbCOLmwosXUMuyrw0XT+WYM3nGbltR1pWRqrkmLqrxVpdJvzWc/RLHFCvmoq3t0Vq
         DTQ+0hjEFfp3zmLRKIkKBMHLG8cDFHOFKROwQLFHqQM+cnk1HT6AfhAj8Giu08gvDK
         tlhn2F/F2sQ1jFpYr3MTR3Gx5cgxmk3sLaOb4Hd8=
Date:   Fri, 11 Sep 2020 15:26:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>
Subject: Re: [RFC PATCH net-next v1 11/11] drivers/net/ethernet: clean up
 mis-targeted comments
Message-ID: <20200911152642.62923ba2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e2e637ae-8cda-c9a4-91ce-93dbd475fc0c@solarflare.com>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
        <20200911012337.14015-12-jesse.brandeburg@intel.com>
        <227d2fe4-ddf8-89c9-b80b-142674c2cca0@solarflare.com>
        <20200911144207.00005619@intel.com>
        <e2e637ae-8cda-c9a4-91ce-93dbd475fc0c@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 22:55:54 +0100 Edward Cree wrote:
> On 11/09/2020 22:42, Jesse Brandeburg wrote:
> > Thanks Ed, I think I might just remove the /** on that function then
> > (removing it from kdoc processing) =20
> I dunno, that means
> a) kerneldoc won't generate html for this struct
> b) new additions to the struct without corresponding kerneldoc won't
> =C2=A0=C2=A0 generate warnings
> =C2=A0both of which are not ideal outcomes.
> I realise there's value in having totally warning-clean code, but in
> =C2=A0this case I think this one warning, even though it's indicating a
> =C2=A0toolchain problem rather than a codebase problem, should better stay
> =C2=A0(if only to put pressure on the toolchain to fix it).
> Otherwise, when and if the toolchain is fixed, what's the chance we'll
> =C2=A0remember to put the /** back?
>=20
> That's just my opinion, though; I won't block patches that disagree.

"Toolchain" sounds a little grand in this context, the script that
parses kdoc does basic regexps to convert the standard kernel macros:

	# replace DECLARE_BITMAP
	$members =3D~ s/__ETHTOOL_DECLARE_LINK_MODE_MASK\s*\(([^\)]+)\)/DECLARE_BI=
TMAP($1, __ETHTOOL_LINK_MODE_MASK_NBITS)/gos;
	$members =3D~ s/DECLARE_BITMAP\s*\(([^,)]+),\s*([^,)]+)\)/unsigned long $1=
\[BITS_TO_LONGS($2)\]/gos;
	# replace DECLARE_HASHTABLE
	$members =3D~ s/DECLARE_HASHTABLE\s*\(([^,)]+),\s*([^,)]+)\)/unsigned long=
 $1\[1 << (($2) - 1)\]/gos;
	# replace DECLARE_KFIFO
	$members =3D~ s/DECLARE_KFIFO\s*\(([^,)]+),\s*([^,)]+),\s*([^,)]+)\)/$2 \*=
$1/gos;
	# replace DECLARE_KFIFO_PTR
	$members =3D~ s/DECLARE_KFIFO_PTR\s*\(([^,)]+),\s*([^,)]+)\)/$2 \*$1/gos;

IDK if we can expect it to understand random driver's macros..


This is the only use of _MCDI_DECLARE_BUF() in the tree, how about
converting the declaration to:

#declare _MCDI_BUF_LEN(_len)   DIV_ROUND_UP(_len, 4)

	efx_dword_t txbuf[_MCDI_BUF_LEN(MC_CMD_PTP_IN_TRANSMIT_LENMAX)];

Would that work?
