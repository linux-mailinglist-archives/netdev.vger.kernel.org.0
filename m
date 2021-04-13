Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5EC35E4E3
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 19:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347125AbhDMRVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 13:21:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47374 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbhDMRVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 13:21:22 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1618334461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/FIguiC0JpPqnEHwTEVTe/PehrMSgAq174+EKyhr82I=;
        b=2ls2iDkJEgxLT8BBbuxpsz+mBg1wpRLaZvIiJwhFSRwgoiRMRnJzbT0sYoJa4inNSgR7n+
        yUBE8eyjM1W4GLKVGy2FAZbaqa99UbF2JxojJdoSpuVrV+Lgu3IpVtB0uw71Bb/TdOs0lH
        lj+1e99uaxO9VNKrRsD3NzbXge6FqqhohbcsoUHjPXr+qj7ED0Pofah6oLDFDg2JYcgqwD
        mQDojXqvWnX1rlEtXGPBu0JZRmSWr345WSwhsX+zYTuxXSBbAzGtaeCOolXeXbgsMSo5n2
        YoVytbBJ6VCsPsJ9spHa95w6rfgnfj40aRiyEFkhM88KW948okBz7aQPZev+Hg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1618334461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/FIguiC0JpPqnEHwTEVTe/PehrMSgAq174+EKyhr82I=;
        b=cvPB+KjZ1ydaw7+/5jmL7AtRi2v45vBIWXzrEbqnaXnlvGRBOeJQzWM2dzpHFR670qb0/5
        pSegCUAMuXU7XPCg==
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH RFC net] igb: Fix XDP with PTP enabled
In-Reply-To: <CAKgT0UekqPNQxV6PzpEeis69z3e3YNcaFyot=nD7w26hLxPX2Q@mail.gmail.com>
References: <20210412101713.15161-1-kurt@linutronix.de> <20210412162846.42706d99@carbon> <CAKgT0UekqPNQxV6PzpEeis69z3e3YNcaFyot=nD7w26hLxPX2Q@mail.gmail.com>
Date:   Tue, 13 Apr 2021 19:21:00 +0200
Message-ID: <87fszuyubn.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Apr 13 2021, Alexander Duyck wrote:
> On Mon, Apr 12, 2021 at 7:29 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
>> > +ktime_t igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va)
>> >  {
>> >       struct igb_adapter *adapter = q_vector->adapter;
>> > +     struct skb_shared_hwtstamps ts;
>> >       __le64 *regval = (__le64 *)va;
>> >       int adjust = 0;
>> >
>> >       if (!(adapter->ptp_flags & IGB_PTP_ENABLED))
>> > -             return IGB_RET_PTP_DISABLED;
>> > +             return 0;
>> >
>> >       /* The timestamp is recorded in little endian format.
>> >        * DWORD: 0        1        2        3
>> > @@ -888,10 +887,9 @@ int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
>> >
>> >       /* check reserved dwords are zero, be/le doesn't matter for zero */
>> >       if (regval[0])
>> > -             return IGB_RET_PTP_INVALID;
>> > +             return 0;
>> >
>
> One thing that needs to be cleaned up in the patch is that if it is
> going to drop these return values it should probably drop the defines
> for them since I don't think they are used anywhere else.

Yes, of course. I'll clean it up before sending a non RFC version.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmB10vwACgkQeSpbgcuY
8Kae6A//Y46kXPei0XtDNGOtHdy8H2HDncTe48K7rSLmFB2pYeSlsBGsh5LrXJeK
7o5qc8ZQ5dZq1zkdJZvvfZurP7/t2S/c4+rh3w0fEUH/UF1Zpu0P4ZNEcA6zOBrb
cPm/nLQZydrfreTcN3bJ2PM3/+80K8FLfF74M/wc47Wi7biCYx94ls2mNoihvy1z
2TWwTY7EeoN4YElwyIXFGKIqgkuTCMt3hgBtVFnzLCnl7xRu9snHLiCFo5PiNKRT
qpC79qUHcqtu39VQHlkvHM9tQvnaMj08okgllnvbLX+XftX+ZyEROO5O5AGjS79E
h5ftqZ6TBqxrOGT3z1M88vlSSBClw2+ZoOXBMCg87Ir4eO5vZwCblvmzipZ5m5Io
aVqPmUsi3gGNwdvySsBGAweJ4cTrteHyHVBDmB4pd+87IpxCPHh/vj3b1v+kjMcJ
aUx7Ken6cu9Sx5YifWE33Ad5PbcR1dXjBIQUuf3HKTodX6swudzLSEsKdEN1Nz88
Ekg+V/YXuV7zDYH9i02OfUTJovD4+AplgNSE/JE3VqQa9G7UrPekMpBJp2DkjwEL
1N/d0pYPARMDC90TpGbaD1FmXjKPs45Zwe6NEJtoF2d5nHrQWa+biNgs/EnGkfOx
9ZTEhIBgfmdjG1yetmoQmXZtlPTyKYMoaTV4HjrQ/aGnE4zOKhw=
=HXr0
-----END PGP SIGNATURE-----
--=-=-=--
