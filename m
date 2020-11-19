Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C0D2B9A43
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 19:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbgKSR7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:59:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:59360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729265AbgKSR7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 12:59:30 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 382EC2225B;
        Thu, 19 Nov 2020 17:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605808770;
        bh=Ta3tsz+YYOgNDaVSrDSReSog0hdPUxrDoz7tjhPgBp8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v4ZtqpY2LAz/9Nfm6jgZ5XJMCJesqYR/Z4WxVWn3ygJvWBVacjqbC2MVHDaO5xuuV
         KHOQFQoHiIvHJ3UeOFKgiRAX5aVTwFGJ4B5NeinELaVuWGB3/aMAetQHqBghFvPb03
         xS+00bjvrJE6FVTSlRLcXq9sfIhkgFS9Elb6L0wg=
Date:   Thu, 19 Nov 2020 09:59:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Tao Ren <rentao.bupt@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Jean Delvare <jdelvare@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, openbmc@lists.ozlabs.org, taoren@fb.com,
        mikechoi@fb.com
Subject: Re: XDP maintainer match (Was  [PATCH v2 0/2] hwmon: (max127) Add
 Maxim MAX127 hardware monitoring)
Message-ID: <20201119095928.01fd10e0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <088057533a9feb330964bdab0b1b8d2f69b7a22c.camel@perches.com>
References: <20201118230929.18147-1-rentao.bupt@gmail.com>
        <20201118232719.GI1853236@lunn.ch>
        <20201118234252.GA18681@taoren-ubuntu-R90MNF91>
        <20201119010119.GA248686@roeck-us.net>
        <20201119012653.GA249502@roeck-us.net>
        <20201119074634.2e9cb21b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201119173535.1474743d@carbon>
        <088057533a9feb330964bdab0b1b8d2f69b7a22c.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 09:09:53 -0800 Joe Perches wrote:
> On Thu, 2020-11-19 at 17:35 +0100, Jesper Dangaard Brouer wrote:
> > On Thu, 19 Nov 2020 07:46:34 -0800 Jakub Kicinski <kuba@kernel.org> wro=
te: =20
>=20
> > I think it is a good idea to change the keyword (K:), but I'm not sure
> > this catch what we want, maybe it does.  The pattern match are meant to
> > catch drivers containing XDP related bits.
> >=20
> > Previously Joe Perches <joe@perches.com> suggested this pattern match,
> > which I don't fully understand... could you explain Joe?
> >=20
> > =C2=A0=C2=A0(?:\b|_)xdp(?:\b|_) =20
>=20
> This regex matches only:
>=20
> 	xdp
> 	xdp_<anything>
> 	<anything>_xdp_<anything>
> 	<anything>_xdp
>=20
> > For the filename (N:) regex match, I'm considering if we should remove
> > it and list more files explicitly.  I think normal glob * pattern
> > works, which should be sufficient. =20
>=20
> Lists are generally more specific than regex globs.

Checking like Alexei did it seems Joe's version is faster and better:

$ git grep -l -E "[^a-z0-9]xdp[^a-z0-9]" | wc -l
295
$ git grep -l -E '(\b|_)xdp(\b|_)' | wc -l
297
$ time git grep -l -E '(\b|_)xdp(\b|_)' > /tmp/a

real	0m5.171s
user	0m32.657s
sys	0m0.664s
$ time git grep -l -E "[^a-z0-9]xdp[^a-z0-9]" > /tmp/b

real	0m16.627s
user	1m48.149s
sys	0m0.977s
09:56 linux$ diff /tmp/a /tmp/b
4d3
< Documentation/networking/index.rst
189d187
< samples/bpf/.gitignore


Joe would you like to send a patch, or should I?
