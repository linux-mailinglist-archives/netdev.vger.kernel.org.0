Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0C125125D
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 08:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgHYGuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 02:50:37 -0400
Received: from ozlabs.org ([203.11.71.1]:51733 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729116AbgHYGug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 02:50:36 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BbKPh4TtCz9sTK;
        Tue, 25 Aug 2020 16:50:32 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1598338234;
        bh=j9NrgxUjqWGE3IxuHRcqD4UBKle0ICvlV8D9udyUimw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dp8HZQrQc6wRe+J1BEAo9CUpupQ4h3iULERXYZPL5jpU/z3dxhpNHZzB006zesX39
         HtQINc6Nzi8aX9qEhXj7kzGOz5b8duQIhe9FBbcGaN63dtynXRWNbfcbEFUAzsNFIJ
         Gh9ISm8vtrlNPHxMSHq0Orx7EFHsj/vLDfxQCPxnYIcdF+Yn5eb4BPvxpJo5QrGuyy
         XrHr3K8ZApY+qSZkh09vMK9KJwxa5xv5yNJbDuDmgWjjUUr252P9Qx950effgVYJn+
         +Jhm6Tuyy93fMvANbLxIGwK8FtO27IIutMZjl23AdPo9Ps4Q/onET+FmbMGuntn8OK
         +1NRusNoUGGSA==
Date:   Tue, 25 Aug 2020 16:50:29 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20200825165029.795a8428@canb.auug.org.au>
In-Reply-To: <CAADnVQKGf7o8gJ60m_zjh+QcmRTNH+y1ha_B2q-1ixcCSAoHaw@mail.gmail.com>
References: <20200821111111.6c04acd6@canb.auug.org.au>
        <20200825112020.43ce26bb@canb.auug.org.au>
        <CAADnVQLr8dU799ZrUnrBBDCtDxPyybZwrMFs5CAOHHW5pnLHHA@mail.gmail.com>
        <20200825130445.655885f8@canb.auug.org.au>
        <CAADnVQKGf7o8gJ60m_zjh+QcmRTNH+y1ha_B2q-1ixcCSAoHaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/tDU.O6cX1D9IrOpNIJF9IC5";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/tDU.O6cX1D9IrOpNIJF9IC5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Alexei,

On Mon, 24 Aug 2020 20:27:28 -0700 Alexei Starovoitov <alexei.starovoitov@g=
mail.com> wrote:
>
> I didn't receive the first email you've replied to.
> The build error is:
> "
> No libelf found
> make[5]: *** [Makefile:284: elfdep] Error 1
> "
> and build process stops because libelf is not found, right?
> That is expected and necessary.
> bpf_preload needs libbpf that depends on libelf.
> The only 'fix' is to turn off bpf_preload.
> It's off by default.
> allmodconfig cannot build bpf_preload umd if there is no libelf.
> There is CC_CAN_LINK that does feature detection.
> We can extend scripts/cc-can-link.sh or add another script that
> will do CC_CAN_LINK_LIBELF, but such approach doesn't scale.
> imo it's cleaner to rely on feature detection by libbpf Makefile with
> an error above instead of adding such knobs to top Kconfig.
> Does it make sense?

Sorry, but if this is not necessary to build the kernel, then an
allmodconfig build needs to succeed so you need to do the detection and
turn it off automatically.  Or you could make it so that it has to be
manually enabled in all circumstances.

--=20
Cheers,
Stephen Rothwell

--Sig_/tDU.O6cX1D9IrOpNIJF9IC5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9EtLUACgkQAVBC80lX
0GwK6gf8DesCk38JfwT0m8g2BShvJEsTqH87hEuvVInFsGPaKvYcQTntETkYPPQa
bF4jfkYOh5VlMGkgCLMGUw+GP48RuHKXt75oohyPzAEnDSwJhVAdG2q4LD4qhDJJ
P+vN1s1VQ/qxreEGn0kqy66UJSWzavy1NKn2JXeEkacGKdQBqPhm1o1D+Cqay948
+JGt4A1kCx9uR+a1lWoafFLsdRgkMCbnKM+qTAhU+pnm67xsk+gO81MtmfX2/0Tw
ocs0Uo2yl1K5u3RVciU83Ad7htWkqBvuFFiCXKIaGKNRPRKIZEnHG+X4hdAp9EdM
Sbh7fMGJHGmjUV4MUvCVgzhUD65p+A==
=Geul
-----END PGP SIGNATURE-----

--Sig_/tDU.O6cX1D9IrOpNIJF9IC5--
