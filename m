Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFE62DA5FB
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgLOCJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:09:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgLOCJW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 21:09:22 -0500
Date:   Mon, 14 Dec 2020 18:08:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607998121;
        bh=FE6KKUTNzDCK6CpjKMKQeTaijRnfVtUbJSj6JPYTTIk=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=eHqrBur6uCq4V2GjGP3BEIrncWANYiNxMWNrSzT6GnZJeB2pp13/r1QjluBfupKij
         aT/tQUgNzmTuwhmvPd0/NdTRRjkBZ3zx5wII17wtDdA6SDis6usALwe1eX7S3U+Bkt
         xSe8w03SiQm1Xk1BCmDn8iItdCHuT0rM/4hpV7Lg0dvVdZ4ipUPFukTpUxmsBVZG/x
         Z49Mi8fF8xZrfspqa0ZmDUecFOf+Ycc0FDtQdXVckpaySRVz3PpgCGaFXrovkQGwa0
         c5U6GBirzCHW24bhxENHvWQcnkxbvHrqRpG/ncJ1NZgRxq4ELmuStYgyotra4+qfHr
         XS9Hyd4FNrdNA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cambda Zhu <cambda@linux.alibaba.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: Re: [PATCH net-next] net: Limit logical shift left of TCP probe0
 timeout
Message-ID: <20201214180840.601055a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <25F89086-3260-48BD-BD69-CCE04821CAE4@linux.alibaba.com>
References: <20201208091910.37618-1-cambda@linux.alibaba.com>
        <20201212143259.581aadae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <25F89086-3260-48BD-BD69-CCE04821CAE4@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 13 Dec 2020 21:59:45 +0800 Cambda Zhu wrote:
> > On Dec 13, 2020, at 06:32, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue,  8 Dec 2020 17:19:10 +0800 Cambda Zhu wrote: =20
> >> For each TCP zero window probe, the icsk_backoff is increased by one a=
nd
> >> its max value is tcp_retries2. If tcp_retries2 is greater than 63, the
> >> probe0 timeout shift may exceed its max bits. On x86_64/ARMv8/MIPS, the
> >> shift count would be masked to range 0 to 63. And on ARMv7 the result =
is
> >> zero. If the shift count is masked, only several probes will be sent
> >> with timeout shorter than TCP_RTO_MAX. But if the timeout is zero, it
> >> needs tcp_retries2 times probes to end this false timeout. Besides,
> >> bitwise shift greater than or equal to the width is an undefined
> >> behavior. =20
> >=20
> > If icsk_backoff can reach 64, can it not also reach 256 and wrap? =20
>=20
> If tcp_retries2 is set greater than 255, it can be wrapped. But for TCP p=
robe0,
> it seems to be not a serious problem. The timeout will be icsk_rto and ba=
ckoff
> again. And considering icsk_backoff is 8 bits, not only it may always be =
lesser
> than tcp_retries2, but also may always be lesser than tcp_orphan_retries.=
 And
> the icsk_probes_out is 8 bits too. So if the max_probes is greater than 2=
55,
> the connection won=E2=80=99t abort even if it=E2=80=99s an orphan sock in=
 some cases.
>=20
> We can change the type of icsk_backoff/icsk_probes_out to fix these probl=
ems.
> But I think maybe the retries greater than 255 have no sense indeed and t=
he RFC
> only requires the timeout(R2) greater than 100s at least. Could it be bet=
ter to
> limit the min/max ranges of their sysctls?

All right, I think the patch is good as is, applied for 5.11, thank you!
