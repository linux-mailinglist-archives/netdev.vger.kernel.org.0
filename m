Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1415C2CF248
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbgLDQtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:49:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731021AbgLDQtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 11:49:36 -0500
Date:   Fri, 4 Dec 2020 08:48:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607100535;
        bh=JJBc0oKKVKBC674Jsv6D0kDtsMyoYn4CD3dcs+/DWDg=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=jLBS54sEPRvk14T/mMiqbNydMh9J0yoo0Ee6Vu/Y6gsr4iOdUKyauO2bFNuQ4UbBJ
         ft6jZ4qoNKUlOChRn0WTz9ySvV7l8PnWGXKsSxQU63Lr1uT2iozlrmu0NCxQo123iy
         RkjhsSxa9nCOkfIlHyhYuinbutkIdPIh49Sd9n5ae7zHWVxemSra/EzENW3/Dtomw7
         LOcLVIpgMI5/yJ5dtLm0Ear4DFhaNNu66dJb9wY5hMJYARKsiduA6YXvdHHSqf0rKr
         /ieZvDNwIEt93OpXiaz7V77vOBVKLVXV7MEwfYuG+0r1zHw4RP/4GEKeQ7YaEkHXOz
         SO8ZVkn6tzpAA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Simon Horman <simon.horman@netronome.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jiri Benc <jbenc@redhat.com>, oss-drivers@netronome.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf 1/7] xdp: remove the xdp_attachment_flags_ok()
 callback
Message-ID: <20201204084847.04d9dc46@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <87o8j99aip.fsf@toke.dk>
References: <160703131710.162669.9632344967082582016.stgit@toke.dk>
        <160703131819.162669.2776807312730670823.stgit@toke.dk>
        <20201203174217.7717ea84@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <87o8j99aip.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Dec 2020 10:38:06 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > On Thu, 03 Dec 2020 22:35:18 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wro=
te: =20
> >> Since we offloaded and non-offloaded programs can co-exist there doesn=
't
> >> really seem to be any reason for the check anyway, and it's only used =
in
> >> three drivers so let's just get rid of the callback entirely. =20
> >
> > I don't remember exactly now, but I think the concern was that using=20
> > the unspecified mode is pretty ambiguous when interface has multiple
> > programs attached. =20
>=20
> Right. I did scratch my head a bit for why the check was there in the
> first place, but that makes sense, actually :)
>=20
> So how about we disallow unload without specifying a mode, but only if
> more than one program is loaded?

Are you including replacing as a form of unload? :)

IMHO the simpler the definition of the API / constraint the better.
"You must specify the same flags" is pretty simple, as is copying=20
the old behavior rather than trying to come up with new rules.

But up to you, I don't mind either way, really..

> Since the core code tracks all the programs now, this could just be
> enforced there and we would avoid all the weird interactions with the
> drivers trying to enforce it...

Yup, enforcing in the core now would make perfect sense.
