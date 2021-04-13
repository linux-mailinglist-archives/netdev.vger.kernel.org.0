Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE7235D8F4
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239946AbhDMHfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:35:15 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44352 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbhDMHfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 03:35:14 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1618299290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/LfaSmfHgZ7FhwZDnDyWBTYgSSsbi4xbqPkH3xgE2QA=;
        b=U1rYNIyYBvJL7cg2KvL30AZRInQmZ8/etlrwjB2BxBSUhLQV1jUCQ3t+U7CwqVtPP3hyYH
        nGVVqejphQx69o113MhPCVJmXusUelycu12rByi6KEXVPcKt7ehQyY6uTFRFxhzSOFFdxq
        oNpMDwjEA5Mhz6+RddV6/c9aqPrp1JF1t9t+pTfW8DJc7WyjH1qt1HnP+PhjvLZDvz+LOa
        FFIFL0e2/IAQs1igq9iqHwi95xeJEk1wFEHdYkvSHQ1lYJPK0SOb18aROwKuZQDLssJWn1
        J5hQzKxkThZWaIgrYnsMnV7uByZWv+YUDO+uCjgmoWNHWbYeG4SCm6Ep0H3Naw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1618299290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/LfaSmfHgZ7FhwZDnDyWBTYgSSsbi4xbqPkH3xgE2QA=;
        b=xmTfrrOSQsQaStYrHcrKkgH3R0zQpU6/tfqmMYiJP2/o6AFOHBQmn/QsVV3C2WTpdXk7AW
        ozpGAPJzKEbnhiCA==
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, Jesse Brandeburg <jesse.brandeburg@intel.com>,
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
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH RFC net] igb: Fix XDP with PTP enabled
In-Reply-To: <20210412162846.42706d99@carbon>
References: <20210412101713.15161-1-kurt@linutronix.de> <20210412162846.42706d99@carbon>
Date:   Tue, 13 Apr 2021 09:34:49 +0200
Message-ID: <874kga1vty.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon Apr 12 2021, Jesper Dangaard Brouer wrote:
> On Mon, 12 Apr 2021 12:17:13 +0200
> Kurt Kanzenbach <kurt@linutronix.de> wrote:
>
>> When using native XDP with the igb driver, the XDP frame data doesn't po=
int to
>> the beginning of the packet. It's off by 16 bytes. Everything works as e=
xpected
>> with XDP skb mode.
>>=20
>> Actually these 16 bytes are used to store the packet timestamps. Therefo=
re, pull
>> the timestamp before executing any XDP operations and adjust all other c=
ode
>> accordingly. The igc driver does it like that as well.
>
> (Cc. Alexander Duyck)

Thanks.

>
> Do we have enough room for the packet page-split tricks when these 16
> bytes are added?

I think so. AFAICT the timestamp header is accounted. There is
IGB_2K_TOO_SMALL_WITH_PADDING. If 2k isn't sufficient, then 3k buffers
are used.

The only thing this patch does, is adjusting the xdp->data pointer
before executing igb_run_xdp() instead of doing it afterwards. So, that
in the eBPF program `data' points to the packet data, and not to the
timestamp.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmB1SZkACgkQeSpbgcuY
8Kbblw/9GEZbAegavmAgPDxBCxupwmoVoxdsy+i7Nw2V5vk1L1eSVSwJwHiXL0Rs
00Dhns8rjS/FBS+mmDFdyAkz0OvADLsLf6bWE25RtJvgvetKidyq4Y/KhscOvU/7
Y07ll2KvpxoDT1Au4z3igJHllYt46KJSYnWrS2Id5rtWt9TQS+bC9EtDwMSaGAkK
krMikylRNHKwFAy4dzO+guThRSDwO0PlCATtVQ3vON47J+MxqcE/Z+5Jl5vP691X
+oXtpcodQ1lVbqxcX66BCduI+QnjBDxgYWhtDOZiDVhU+sqSDldG+MjTbfTdCOUv
PekfeQT64IaEYFocgIiYX570V0b++7fagSBSNnG7eV4+HNo4ujsWcfjnZCF11KMU
7qITP/BLK/n+OtpCnpQM6rv+AgSMY3+f3YswiEvF8at3/K77SStNRlB8mtqw3xaF
wxPQFIepGGzRHq60W3JX7KunyKIpGmg2IzMpi93p3VA1TG2uYAyDMOdqXcy6OcML
4LDlylLmHvfHRNwEZaQDbWXXdvGoj7A2p74QsoY/cSObVs7wCGL/D++BVramrSmY
jdgQrmpBJNNtZNzjjNrUE6Dm60dmbeSSHCssgUplCzL2sY+T2C+EwHpsuEXDjZyn
Djd6091Bcbo6bXfpDjY5ISyTuNI5N9XAGtis4uyr9HhgggET3dc=
=sh9o
-----END PGP SIGNATURE-----
--=-=-=--
