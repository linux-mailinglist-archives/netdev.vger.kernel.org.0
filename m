Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F9067F7BF
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 13:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbjA1MGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 07:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbjA1MGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 07:06:31 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49482790A1
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:06:30 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674907589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ExXKvvBQ5TPqCs9WDxXUtzILosZH8yXJTkD6Vwls2Co=;
        b=z+hiv3UE2IZvwvZ4gr92MCAbyOYygG6jx/opgenxzxxZHRyh008+f/go8nBT2PvTjN1bdP
        KLc1YTlcGmonaIQZTQ0NFwaaYleMAdnnyg/GjA9n/BxgaKYBePQ6tOqQv+ZSs0xvWRghrI
        /8XX2g6WiH9qF+9LrJn76YuNh+ia9zjIEIpkgVVjeowxBe2CMhOMLp/VQ9STzO6J3ynPkA
        cG+Zq8ngop60/wrkSHWa229HZhnsiB2w63grx5y87tkSyyzdxTLxFQAsC4PyKHbsLAgpCq
        nYdK+TYDymWUyFGfhMAZpkog5KQcm6GE/K3ALJ1Mu+2tj6RF3wLbKFxybOjDzQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674907589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ExXKvvBQ5TPqCs9WDxXUtzILosZH8yXJTkD6Vwls2Co=;
        b=q4gxdAc0pFHMRxm/s2m3oP5Y8PCd5V041SOEgmLKl341jlxxBlChCGE6mrSz3k79Pr5Eje
        KBk4haU3sYAt2lCQ==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 11/15] net/sched: taprio: warn about
 missing size table
In-Reply-To: <20230128010719.2182346-12-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-12-vladimir.oltean@nxp.com>
Date:   Sat, 28 Jan 2023 13:06:28 +0100
Message-ID: <87357uvp6j.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sat Jan 28 2023, Vladimir Oltean wrote:
> Vinicius intended taprio to take the L1 overhead into account when
> estimating packet transmission time through user input, specifically
> through the qdisc size table (man tc-stab).
>
> Something like this:
>
> tc qdisc replace dev $eth root stab overhead 24 taprio \
> 	num_tc 8 \
> 	map 0 1 2 3 4 5 6 7 \
> 	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
> 	base-time 0 \
> 	sched-entry S 0x7e 9000000 \
> 	sched-entry S 0x82 1000000 \
> 	max-sdu 0 0 0 0 0 0 0 200 \
> 	flags 0x0 clockid CLOCK_TAI
>
> Without the overhead being specified, transmission times will be
> underestimated and will cause late transmissions.
>
> We can't make it mandatory, but we can warn the user with a netlink
> extack.
>
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20220505160357.298794-1-vladimir.oltean@nxp.com/
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPVD8QTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgmfUD/9L4vFXJ5Ym6FNdInB0JDw2tagLNpZ4
jY/JY5YUsHSPhVdyzFkU17XcA4aX33PrjM16Tb29ja4xM7ugWW0jkgxLZ4ITCmu6
V/Ms3hG8e6BCJVh9uKihIn9kX+rJlpCcVceXh3xN4IYC8YvH9mahSqVkfgzyl1+M
wnw/XGJAfoaiVkcGgtjDM++zx8aax2LHRhi4gM+XivCoiNC1nR1XYseXzZXzCKsc
iDXnytpMZMEJGbh+YvL3y6m6LRm9I+JRrYCCA8UnyGMgOZJakYlrJai3tMyEIYWG
zjURYuo85dBOmq45YwzXe6g+dp4XrBZ1QtzUM8CPgaddIywZugvyZFp30aBj93nJ
SzOPjdqHRw6WwXqwoULPEADs7qRRhGBfi1piDNMVXYP99Jf2dzF9UIYqMsVT59VL
X2bp6z7KWCY2IX+wGsbP16z/rioTP/qD/2NVfsvoj8GO0JkneIOJw790NVyGBLG6
gP+IUCn3a9I4nu6lMXpXJU/Amo3x11w/fvCjtuROX/hUnVJ+nJ06VDfj4n7522oz
XuzYy57DoqL4aHSCAkocif5fTcbcdoC7eOCcWyBvXCvRcBv2gv68h2DK1etYOIz9
tHq3ST3UCjv2u22cvd2uVXnmUOBxxkwbptQNdF+2eNw23EKGOJUGYZKrHGaZlIcU
RJdUCz5kBDyyzA==
=eDMK
-----END PGP SIGNATURE-----
--=-=-=--
