Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0D63F5823
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 08:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhHXGZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 02:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbhHXGZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 02:25:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CB8C061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 23:24:56 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1629786293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IycFmQLx+9zK6D5CdCxSRQBjjujbQXqbSPoN0u6h8i0=;
        b=JR9ea8/Vn/TNmFQ1fawTIWgwZvi2ws89aXGOuN5Fhw4Bf0Q0nK7xQyOfEG6oKEy/vOOuKG
        c4HvwXPkJ/8Db3cjowzUoHNbnvph4hdvs/XHd/XOBvj3L6jiS+9REne87opJS69AyRVCHH
        EETcqnq3L67yRmSJEuKHYAoHd8FIpQdBsfYsuqeIZ/Rr/cANSthpVAzrWOW0nojIiOAOPA
        sbvb9MCRFXOpO2Q5HGhfcHflSnA8bSkiIpJr+lUd6d6msj6J4TC7RTk1f6mBeIaOWBZ+4F
        MgV/HLx4k2C10Tm5ro76jEtbl2Ucvw2Q56p0Hn1ZLbBMC8Xb6PG1NW2Yf/WUJw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1629786293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IycFmQLx+9zK6D5CdCxSRQBjjujbQXqbSPoN0u6h8i0=;
        b=HSgLY7jiayTvwpcvLVh9WJP4xBA5WgpVl4O/jKphIcoC188hc8AEycVsVnbUzgRN+ynzyZ
        yLSowgb+gn9n+xBA==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: let drivers state that they
 need VLAN filtering while standalone
In-Reply-To: <20210823212258.3190699-5-vladimir.oltean@nxp.com>
References: <20210823212258.3190699-1-vladimir.oltean@nxp.com>
 <20210823212258.3190699-5-vladimir.oltean@nxp.com>
Date:   Tue, 24 Aug 2021 08:24:52 +0200
Message-ID: <87tujfpdfv.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Aug 24 2021, Vladimir Oltean wrote:
> As explained in commit e358bef7c392 ("net: dsa: Give drivers the chance
> to veto certain upper devices"), the hellcreek driver uses some tricks
> to comply with the network stack expectations: it enforces port
> separation in standalone mode using VLANs. For untagged traffic,
> bridging between ports is prevented by using different PVIDs, and for
> VLAN-tagged traffic, it never accepts 8021q uppers with the same VID on
> two ports, so packets with one VLAN cannot leak from one port to another.
>
> That is almost fine*, and has worked because hellcreek relied on an
> implicit behavior of the DSA core that was changed by the previous
> patch: the standalone ports declare the 'rx-vlan-filter' feature as 'on
> [fixed]'. Since most of the DSA drivers are actually VLAN-unaware in
> standalone mode, that feature was actually incorrectly reflecting the
> hardware/driver state, so there was a desire to fix it. This leaves the
> hellcreek driver in a situation where it has to explicitly request this
> behavior from the DSA framework.
>
> We configure the ports as follows:
>
> - Standalone: 'rx-vlan-filter' is on. An 8021q upper on top of a
>   standalone hellcreek port will go through dsa_slave_vlan_rx_add_vid
>   and will add a VLAN to the hardware tables, giving the driver the
>   opportunity to refuse it through .port_prechangeupper.
>
> - Bridged with vlan_filtering=0: 'rx-vlan-filter' is off. An 8021q upper
>   on top of a bridged hellcreek port will not go through
>   dsa_slave_vlan_rx_add_vid, because there will not be any attempt to
>   offload this VLAN. The driver already disables VLAN awareness, so that
>   upper should receive the traffic it needs.
>
> - Bridged with vlan_filtering=1: 'rx-vlan-filter' is on. An 8021q upper
>   on top of a bridged hellcreek port will call dsa_slave_vlan_rx_add_vid,
>   and can again be vetoed through .port_prechangeupper.
>
> *It is not actually completely fine, because if I follow through
> correctly, we can have the following situation:
>
> ip link add br0 type bridge vlan_filtering 0
> ip link set lan0 master br0 # lan0 now becomes VLAN-unaware
> ip link set lan0 nomaster # lan0 fails to become VLAN-aware again, therefore breaking isolation
>
> This patch fixes that corner case by extending the DSA core logic, based
> on this requested attribute, to change the VLAN awareness state of the
> switch (port) when it leaves the bridge.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Acked-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmEkkLQTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwplyCEACtKTtf0k7TnewKZaWQg0sq//nY5Q6l
6ah4W04w/xJ698/0jJ7KkuOHpQ1iFuC979XGfJLaQveF34votNPL/zE0qppqTO1l
Sr3KmONN0LiSIN5oyoBe2Ma/1dfvk0juYa18tqFpFxFmQsOPb28l5VbOgWaSDAUn
LN6pS2a6aOHQKnLHRJF/cj8PrpC9IGjvVp9LMCbp35JSat8/GCIz1zV79VQTGnwU
ikcvg58M/9bJMT2soIEvKj/Z6/Wv5/lS62qjR0U2uUK46CptzBUkrsJzcRXBUU1W
goqndlN0zUINtUxBhDIgIRr+05XaOB+t1gM2E5iWsQfxWQ6it4DlJf+2oUk+Nmkw
i6CFGO5+EAiw3jehjpjYZkRncgI+L8Hk4Y8Ct2ai4cbSW60JUOnlFt0fP7WvxgPG
w1unKJC+pSFpO5mAebFTiRR2GLvn8Es5dnIkjz8Bz/ia0Gp77TiKKgt1dIrVzQtm
FujN4OyL7v/fHj8RQ6IQ7SIHlLJxluVg4FzUqhyLcSuzid0LPnO/+PkyVdMiWz6B
qlULfcuutZdS7MGvB9SITGVqyCeL7zun919vj2bklPa+4J17JaYA6iBLmVs9SyLy
lsr/XjB2RagLKkPDXdZoG/HOj/JWMOc7Zl+lhusvgUBlmbaZKbayksX8fAxot8TI
SMB+Aivb4r5Gkw==
=eSo+
-----END PGP SIGNATURE-----
--=-=-=--
