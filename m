Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC002347542
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 11:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbhCXKDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 06:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbhCXKC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 06:02:56 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69FDC061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 03:02:56 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616580174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sBlYKwphcRZXzs6TAGxPKDWDzFdMZU3u7zEYSywiDWM=;
        b=fS6+VOzGMTEhQGeXgrZWNt/9iumZg6wThAikBn/P203zQhxb1HfSDs8f6ks9QwsxY6cSd0
        xEfEbw7fimnybgM7y2s0WeD86GYRFSZC5iY47vK0NXGLU541Dn9iLlz5LwcF1nTPcF9dGP
        p4V0Kq3SOue1EAphAOkYs4cSSw6FFPntz1pqand2m/J8B5PEaGQlsYGHnKSmX28M7qCvHT
        +fj+E7rawfxeaJoAxDQN56T0UxcjS1/k6JRaTnX1qJPkh2gp3n8UCyN73QSDc8DjCQMNFC
        F3MUXHw9tMyb+G+Z03ttig1VLQChU30sqLpTezJuThjxpOWrdk0Wa0LK7PygCA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616580174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sBlYKwphcRZXzs6TAGxPKDWDzFdMZU3u7zEYSywiDWM=;
        b=ejwvVzITK3GssFv+mzPR2hKe5rthc98Bdl6WZkj+wPlspQaRvOiODa05l8zDD0KpX1v8Uz
        OqxPcVVUXtAkFDDQ==
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v3 net] net: dsa: only unset VLAN filtering when last port leaves last VLAN-aware bridge
In-Reply-To: <20210324095639.1354700-1-olteanv@gmail.com>
References: <20210324095639.1354700-1-olteanv@gmail.com>
Date:   Wed, 24 Mar 2021 11:02:53 +0100
Message-ID: <874kh0swc2.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Wed Mar 24 2021, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> DSA is aware of switches with global VLAN filtering since the blamed
> commit, but it makes a bad decision when multiple bridges are spanning
> the same switch:
>
> ip link add br0 type bridge vlan_filtering 1
> ip link add br1 type bridge vlan_filtering 1
> ip link set swp2 master br0
> ip link set swp3 master br0
> ip link set swp4 master br1
> ip link set swp5 master br1
> ip link set swp5 nomaster
> ip link set swp4 nomaster
> [138665.939930] sja1105 spi0.1: port 3: dsa_core: VLAN filtering is a global setting
> [138665.947514] DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE
>
> When all ports leave br1, DSA blindly attempts to disable VLAN filtering
> on the switch, ignoring the fact that br0 still exists and is VLAN-aware
> too. It fails while doing that.
>
> This patch checks whether any port exists at all and is under a
> VLAN-aware bridge.
>
> Fixes: d371b7c92d19 ("net: dsa: Unset vlan_filtering when ports leave the bridge")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmBbDk0ACgkQeSpbgcuY
8KYtug/9FkSnCykK3nqOGGV/ZJhLyvWFKmUTCxU9aTsq0HuAcOZ5b4Qkcg2cbtTB
IASs/nhPOP9LJi3sDgX5BTJ+kWU7v2IUhaldEE5kvQdTVP/IqRg53cvH5GNoU1Tv
nqGFiFAjlxmkLUZM71xPB6soN3XMZVisKvTl2n21beBlCZAHv2OaQlvlTaCeJjRs
glcgIIFyGbQHOQTC03XpaQ4cdWIWoyzzpcpkxG3puYV2n5YeNcXsEtjNBuIjAlDy
wEwkXbFmHwogIF9tbRE9oX+qlIwSafabtCUsxMPps0DIoqgk3vkHAvDrx+SregN7
TAJAWJi0QjyJbBm9LJALS4kCsK5gsckoIHUok5FgiGzsjkoj9PIKj/lh/GqMTpdV
+sbp8BWkDoYut/iAzZ5jRHCZX2D7X89g20DuXyXKRU4nlAftlIm1RnxASzBdg1X/
j+Iwjm9LAlCJk5pJVjZpJELiMtKY4nyXVXx6UBybUf6BD8KTqFBy9RIpYg1M1unZ
JK4hw/EPASudtnE9RyIxnt19uiq47jBTLSM2CwQFV4dil0lldyBwOVBt2ErmYpmg
3aVUdrE7jZJiHHDJoyXtpsxVqkYLKsef7h+aeMz+m/cLGybcjO4Bm/3khPFN6qyz
MeMNJ+dYecDT7zGVOnZ8iF76dHY+qtx8LaP39bHFT2ZyYhux4NM=
=KFyT
-----END PGP SIGNATURE-----
--=-=-=--
