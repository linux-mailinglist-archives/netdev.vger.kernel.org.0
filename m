Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C5244F8AD
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 16:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhKNPOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 10:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhKNPOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 10:14:40 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273A4C061746;
        Sun, 14 Nov 2021 07:11:46 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636902703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1kkq3dBvp9yP0qQAQfqCNJaAwZ1cH/dykhm1gc7U1DE=;
        b=vYJ8tPv3bsai8XxzNGduhUb1IKvTJSSmuIbZBy3nMOcGzBMjYZyqnHuz9yCL5HIEuRDB7H
        97XC5Tsd6kSgTG5DQh8YFUHji/NG/fVBzcazmlSZpxo+8BtTbIA5L/Yuwcnys7USo0y1Fl
        UIrZtMrV/qQJguy9Mw8h5uA1/06LHdbQuduD2ehZhlrzz4zFj8zTTm13lkFyFYprl68vy0
        MrMGNV9J4B+GByCzXVHqNh8JBY9SdTyd4Zu+zL8PRVCeQVF1elcybURbXbsFKpFrUdcyUU
        sckfG46gRzJTkbE6w799xEITQFSR99CfVIi4z6nneK83T0zkM1RZyy0E42H+Hw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636902703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1kkq3dBvp9yP0qQAQfqCNJaAwZ1cH/dykhm1gc7U1DE=;
        b=qWwEbKfHle08FAuryZkVz3s5AzyG3q0EEIWSwNf5liyxjKTuIrjIq6uSqr4mqvwYJNEON0
        pD3CKRcpWl55prDA==
To:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        alexandre.torgue@foss.st.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH net-next 1/1] net: stmmac: enhance XDP ZC driver level
 switching performance
In-Reply-To: <20211111143949.2806049-1-boon.leong.ong@intel.com>
References: <20211111143949.2806049-1-boon.leong.ong@intel.com>
Date:   Sun, 14 Nov 2021 16:11:41 +0100
Message-ID: <87v90urcuq.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Thu Nov 11 2021, Ong Boon Leong wrote:
> The previous stmmac_xdp_set_prog() implementation uses stmmac_release()
> and stmmac_open() which tear down the PHY device and causes undesirable
> autonegotiation which causes a delay whenever AFXDP ZC is setup.
>
> This patch introduces two new functions that just sufficiently tear
> down DMA descriptors, buffer, NAPI process, and IRQs and reestablish
> them accordingly in both stmmac_xdp_release() and stammac_xdp_open().
>
> As the results of this enhancement, we get rid of transient state
> introduced by the link auto-negotiation:
>
> $ ./xdpsock -i eth0 -t -z
>
>  sock0@eth0:0 txonly xdp-drv
>                    pps            pkts           1.00
> rx                 0              0
> tx                 634444         634560
>
>  sock0@eth0:0 txonly xdp-drv
>                    pps            pkts           1.00
> rx                 0              0
> tx                 632330         1267072
>
>  sock0@eth0:0 txonly xdp-drv
>                    pps            pkts           1.00
> rx                 0              0
> tx                 632438         1899584
>
>  sock0@eth0:0 txonly xdp-drv
>                    pps            pkts           1.00
> rx                 0              0
> tx                 632502         2532160
>
> Reported-by: Kurt Kanzenbach <kurt@linutronix.de>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

Tested-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGRJy0THGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpivSD/0e/X3EiWzkobuBPwRB+/E+Anc/4S4/
lsMxq95qm2fzteKb8nUBUDNOxEtW+/tZv3SfBkt0waa1o3AR8Z70VVvE0lw4JXEb
PoavzUhFWiRTZSDCuv6ANnlid1DH74eDkvZC9ICX95bDQ7XrqtHM6YpCFh3BAesw
eZsYOfXOBgXXgBu9uUWQvYXelvyfMikSygUjQuSlHfGiuqRy1AmbYRFDUJFv4T1d
DLjo2wNIyc+Nml/mitvwm6hHyG0YVd/zwkVD4EfEIp04ZcEgnJABsI/dOAoevjLa
YaGWwnCSJDxb8PR5crfre74DwtypEgWbGg+p3fwbMy4EJ1rvJ7u44cUNafPJPmKs
Juo5CFeeElks3qJ/S/gN5ssVWGb9QcnKgQu5MDTfu3/U21/LnoUg/Wbvrkn2275c
srycG2sc7UH9oV6qxaxyG4l5xfZ8jOVLRB+rTRapv047wZuThETrxIg7Y2f7whf9
vY4mUYx1N3H0EJMGAqlUCKlIV8OWOLSx/NftbYKK+LkIsuDs8HQCD+xPJbSPXdS+
6mVT0So4v5wX00LwP5bnoCmPCzMG2vGuYFFHNuT9QzRzSUQotS5W7blWY7hdpDYh
aKNTbCwKvuL5Ao8bvbOYi+oVhribjafnM0O41ScxIatYg7diemQKuYi7DQ/kysr/
u+KICu9nMU5lZA==
=Lx50
-----END PGP SIGNATURE-----
--=-=-=--
