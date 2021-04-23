Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B36368D4E
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 08:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbhDWGqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 02:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbhDWGql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 02:46:41 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81650C061574;
        Thu, 22 Apr 2021 23:46:05 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1619160362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=COpI2hRP60Vs2lnyODeiD9EhKAi0HtjdTtgcT2kw3Hc=;
        b=Tat9RtrgjoUdU2WZNdvnghT6Etxjtfc9mkKhkXJIVA7dzvtLJqNjYSKisckLvjSwoIiUIV
        RnMLSK7XGcAGMJbZVYoHOa3MntLf/UMEOwqqXqn/4fBBJqwRut1oNsy+1L624nLYAM/9zE
        +PYsVB9Z2U+8dPtXvxGu0Fp+RNT2u5CfuOLZDovLGYQiVGepJa8rgWaJD75aga2EObBYQ6
        ITXgCRNnB1Rfqej4THc5QfPj8CQwFtAnt10Oat2ujzWeJR9ewWPWJpPpFHJ0ymOl04lT4T
        lm3/FuwwHsB+vORaCX36YerTLoAI4Tq1mBWQvpCOp5MfTjff4MO8bj4GtfSaEg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1619160362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=COpI2hRP60Vs2lnyODeiD9EhKAi0HtjdTtgcT2kw3Hc=;
        b=XVXMIiSoL7ZehE5pRQd2hsow7veSTYahNLh/QvNIKx3Es3yPioDrWLNDxXFPibFmxfQvUf
        XN71MyCQfFRc7LDg==
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net v3] igb: Fix XDP with PTP enabled
In-Reply-To: <20210422101129.GB44289@ranger.igk.intel.com>
References: <20210422052617.17267-1-kurt@linutronix.de> <20210422101129.GB44289@ranger.igk.intel.com>
Date:   Fri, 23 Apr 2021 08:45:52 +0200
Message-ID: <878s59qz1b.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Apr 22 2021, Maciej Fijalkowski wrote:
> On Thu, Apr 22, 2021 at 07:26:17AM +0200, Kurt Kanzenbach wrote:
>> +		/* pull rx packet timestamp if available and valid */
>> +		if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
>> +			timestamp =3D igb_ptp_rx_pktstamp(rx_ring->q_vector,
>> +							pktbuf);
>> +
>> +			if (timestamp) {
>> +				pkt_offset +=3D IGB_TS_HDR_LEN;
>> +				size -=3D IGB_TS_HDR_LEN;
>> +			}
>> +		}
>
> Small nit: since this is a hot path, maybe we could omit the additional
> branch that you're introducing above and make igb_ptp_rx_pktstamp() to
> return either 0 for error cases and IGB_TS_HDR_LEN if timestamp was fine?
> timestamp itself would be passed as an arg.
>
> So:
> 		if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
> 			ts_offset =3D igb_ptp_rx_pktstamp(rx_ring->q_vector,
> 							pktbuf, &timestamp);
> 			pkt_offset +=3D ts_offset;
> 			size -=3D ts_offset;
> 		}
>
> Thoughts? I feel like if we see that desc has timestamp enabled then let's
> optimize it for successful case.

Yes, this should work as well. Actually I didn't like the if statement
either. Only one comment: It's not an offset but rather the timestamp
header length. I'd call it 'ts_len'.

>
>>=20=20
>>  		/* retrieve a buffer from the ring */
>>  		if (!skb) {
>> -			unsigned int offset =3D igb_rx_offset(rx_ring);
>> -			unsigned char *hard_start;
>> +			unsigned char *hard_start =3D pktbuf - igb_rx_offset(rx_ring);
>> +			unsigned int offset =3D pkt_offset + igb_rx_offset(rx_ring);
>
> Probably we could do something similar in flavour of:
> https://lore.kernel.org/bpf/20210118151318.12324-10-maciej.fijalkowski@in=
tel.com/
>
> which broke XDP_REDIRECT and got fixed in:
> https://lore.kernel.org/bpf/20210303153928.11764-2-maciej.fijalkowski@int=
el.com/
>
> You get the idea.

Yes, I do. However, I think such a change doesn't belong in this patch,
which is a bugfix for XDP. It looks like an optimization. Should I split
it into two patches and rather target net-next instead of net?

Thanks for your review.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmCCbSAACgkQeSpbgcuY
8KZFcw//eFr5BqqCeafT7m7sSMhiuiG0plalsTXxSK877VCcoGMIMMjAks4moTNv
3oL7Mz6NkGsMCi/BXwwBTer/orNzEfEPphWV/HcShgnBErsaJtHydiFkL+KaKFBm
HPkghjIfN9bOehDLrLmXNWWLuLx7I1YWak+LeH7NGCNo4oAu2IvaDPxhJNDEpywk
5hC3oSsGdHLv81SqKc8pkGSEhdiNloAOuPDuOxAJTmC3eEgXszSMk5MYdLK8huDs
FzkHiGWNZgYRMR1lWePzhlrTIMQPf7J0Kg3zk5urmwQxNP3xg6ljsNOs3yMATKM5
DTyvE3PsRQjMRDIsGhBCk3N6OezoOfM0Iqz7bJLOJNwMgffyeFHQgvE1x0qSHatV
bLWl2pr5SaoGsPxrrmUgpbF/DoXRwfZhrC3fk9vznzHNNHL7HiP2soE+K1EgyYCZ
/7HbwRlaMjeELhtwueh2fuSXQoHJDq5QzoqnceJOirgXJmGiJTNZn9CptHtYQHsL
OCe9BC6XPcB53Tmyqf5IGqkdS40Uw6vqV7aAp/gB1HJfPHGE6F4Bqg5U5Cdzlqr5
PUH12N0JhvcbUnXpX/Rl0fnXDcmSbtv6heH0e+rQowJK5E1MlVz+wJoKpq8sndJB
WWpn5MbDOHzpzXxImgyJL9zY1HuS1sIZb4vjDfmiKHShgqXIXEs=
=yxE8
-----END PGP SIGNATURE-----
--=-=-=--
