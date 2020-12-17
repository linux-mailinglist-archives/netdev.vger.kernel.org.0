Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBADD2DD1E6
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 14:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgLQNIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 08:08:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbgLQNIb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 08:08:31 -0500
Date:   Thu, 17 Dec 2020 13:07:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608210470;
        bh=lVsy2G3PdyS4QvfvMSCeT2JO0KYkPtZ6DgGn8pv6Jp8=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=JglEr8u0Klnf9OQlxLN2VLsIS4jdS4YyHoTGFWnZeMJjWhOBp25E1cCo2k4Im/Qgk
         vSoKJn1uaZ2ju+SNkrspVBpLWyYayWOmey1497JdpWeNdGTyANTgawzGslfYyJpKfn
         7a0kpZ32anGSB13Uq9M3bp0Pyg9tbHGFsKu6rUS8N2bUeXytTpbudQuUxNJgXIDbmd
         aKr/DG0N6qyLdprou7fke3bZhYHQRAVS71HgL0ShyB+9vDiv0SOnMnYctqo883IyOU
         mvkRMjsACENYtIU7Feg+haz1968n2fT/8WutlZCrBFSUP47fDfozcewmcu5YLsgmE4
         CbCkCRuxWchOg==
From:   Mark Brown <broonie@kernel.org>
To:     Seth Forshee <seth.forshee@canonical.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Daniel Diaz <daniel.diaz@linaro.org>,
        Veronika Kabatova <vkabatov@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Kevin Hilman <khilman@baylibre.com>
Subject: Re: [PATCH] selftests: Skip BPF seftests by default
Message-ID: <20201217130735.GA4708@sirena.org.uk>
References: <20201210185233.28091-1-broonie@kernel.org>
 <X9qExiKXPVmk3BJI@ubuntu-x1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <X9qExiKXPVmk3BJI@ubuntu-x1>
X-Cookie: I'll eat ANYTHING that's BRIGHT BLUE!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 16, 2020 at 04:05:58PM -0600, Seth Forshee wrote:
> On Thu, Dec 10, 2020 at 06:52:33PM +0000, Mark Brown wrote:

> > as part of the wider kselftest build by specifying SKIP_TARGETS,
> > including setting an empty SKIP_TARGETS to build everything.  They can
> > also continue to build the BPF selftests individually in cases where
> > they are specifically focused on BPF.

> Why not just remove the line which adds bpf to TARGETS? This has the
> same effect, but doesn't require an emtpy SKIP_TARGETS to run them. We
> have testing scripts which use 'make TARGETS=bpf ...' which will have to
> be updated, and I doubt we are the only ones.

> I also feel like this creates confusing semantics around SKIP_TARGETS.
> If I don't supply a value then I don't get the bpf selftests, but then
> if I try to use SKIP_TARGETS to skip some other test suddenly I do get
> them. That's counterintuitive.

That's what I did first, it's also messy just differently.  If you
don't add bpf to TARGETS then if you do what's needed to get it building
it becomes inconvenient to run it as part of running everything else at
the top level since you need to enumerate all the targets.  It felt like
skipping is what we're actually doing here and it seems like those
actively working with BPF will be used to having to update things in
their environment.  People who start using SKIP_TARGETS are *probably*
going to find out about it from the Makefile anyway so will see the
default that's there.

Fundamentally having such demanding build dependencies is always going
to result in some kind of mess, it's just where we push it.

> I also wanted to point out that the net/test_bpf.sh selftest requires
> having the test_bpf module from the bpf selftest build. So when the bpf
> selftests aren't built this test is guaranteed to fail. Though it would
> be nice if the net selftests didn't require building the bpf self tests
> in order to pass.

Right, that's a separate issue - the net tests should really skip that
if they don't have BPF, as we do for other runtime detectable
dependencies.  It's nowhere near as severe as failing to build though.

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/bWBcACgkQJNaLcl1U
h9CI7Qf/dFnJBcdvSuzBCAbwNK6RJwenUCBcuGORFGRCDhvwfAZrdR/TP4LgtrwL
SAjzWHn0ezKuUNw9sQc0LQYKE85E8GgzbEPMq5WMnJRmnKBwKDEFVcR3XJuwuvCR
vVTIaF1Wv0/eiByX9bfw9tsMEpotGNKdIgvi/VfyE4OI1YmFpEz72VXroWbEItRL
LfQepUr+u/Ot6pBvk1FH/2dBDQDLS71GmF77nwB1qzmhtWb70fbKkLMFPcis7B9K
/bUJ+Gs8A7R7mlVGR/beQUO1ZWTj7YTIpAAzRdf1dn3G47o7/tIWVupkgr+qUxmV
s8CmwqptUdTGytxjqNemtT6o4ygMxg==
=E8Cw
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
