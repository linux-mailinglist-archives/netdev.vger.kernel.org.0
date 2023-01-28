Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA6067F7BA
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 13:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbjA1MFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 07:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbjA1MFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 07:05:13 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A742F34311
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:05:12 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674907511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O2uDKmODwmxdpe/qs+XoVbGVsSu3BZpb5VjANJEX830=;
        b=jBy4LIa76ZtxEx/gFiIdtRbK6yeA39IWqAJ9nsO6JJM7RBJWgcDHGOMqRr30UnrD4rhUks
        wjLWrl/iyqw7FpPyhv5s7Dv+hDSozsc8ihlhcPujaYs+vZyZIZLnbZ2j3zj9O4ztMlKN6J
        NvNmVVoK/N3L0CV/GLzR/roNdZ4Y3mbevlP5lqlQuMzxtB5nZfOYYnINtU7xFfiVrnriSN
        MTF0KCTcUytDEb+4Z2ZiL2hpPG1cHpFYoJtC52LHfzXBedF6zqdvLg37PEnjlLuenxhqMj
        gH1jO2ukdSr1AY+HlKgP71RZDQPMveD9CSQWJGk2aDB8Zj2Y2xNHT9eXDoDtvg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674907511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O2uDKmODwmxdpe/qs+XoVbGVsSu3BZpb5VjANJEX830=;
        b=2H/gmQ+ERR2/+qPUaRDJPXhUmFkU2IYKAX2EaPFxPz9uEiy0htgPhGebA1TXvPPOCRT1iO
        HuxnYCUlnnhe0/Cg==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 06/15] net/sched: taprio: calculate tc gate
 durations
In-Reply-To: <20230128010719.2182346-7-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-7-vladimir.oltean@nxp.com>
Date:   Sat, 28 Jan 2023 13:05:09 +0100
Message-ID: <87h6wavp8q.fsf@kurt>
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
> Current taprio code operates on a very simplistic (and incorrect)
> assumption: that egress scheduling for a traffic class can only take
> place for the duration of the current interval, or i.o.w., it assumes
> that at the end of each schedule entry, there is a "gate close" event
> for all traffic classes.
>
> As an example, traffic sent with the schedule below will be jumpy, even
> though all 8 TC gates are open, so there is absolutely no "gate close"
> event (effectively a transition from BIT(tc)==1 to BIT(tc)==0 in
> consecutive schedule entries):
>
> tc qdisc replace dev veth0 parent root taprio \
> 	num_tc 2 \
> 	map 0 1 \
> 	queues 1@0 1@1 \
> 	base-time 0 \
> 	sched-entry S 0xff 4000000000 \
> 	clockid CLOCK_TAI \
> 	flags 0x0
>
> This qdisc simply does not have what it takes in terms of logic to
> *actually* compute the durations of traffic classes. Also, it does not
> recognize the need to use this information on a per-traffic-class basis:
> it always looks at entry->interval and entry->close_time.
>
> This change proposes that each schedule entry has an array called
> tc_gate_duration[tc]. This holds the information: "for how long will
> this traffic class gate remain open, starting from *this* schedule
> entry". If the traffic class gate is always open, that value is equal to
> the cycle time of the schedule.
>
> We'll also need to keep track, for the purpose of queueMaxSDU[tc]
> calculation, what is the maximum time duration for a traffic class
> having an open gate. This gives us directly what is the maximum sized
> packet that this traffic class will have to accept. For everything else
> it has to qdisc_drop() it in qdisc_enqueue().
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPVD3UTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgplVEACH/0pm5DyPCwvrXcjNs5r+M7mTJBMG
53peFg//85AGcqMUSASjA6k4LKCMCjWJ1kIT/xo8c3sbKrusqXGh2Oc6KmzW21x0
oLiKH/yPN2CHhlbIicb54ARm9dwqUBCoVvrIUDLojUoxbE1dVNUa2tXQZYT7a6EZ
zsA8zZOqkGtt0na+zh6iiWdUQjg/q2CmHwwAXoeeiRAnnbQjusjjQgF6Nf1mFMCo
XiGOxZn1i8PQxgbrmG6ICfQvlsnVXFEGmujzwaScmuxAeqfb0XRKxd+WgwxJ2FpH
qZsXD/XgJjtNFjWvrj+qecnQFlTZ1ZOviO4e65Lwp6OwW7hsQ1Y3QOL3XTHL4OTm
dWF2y2CKfgTn+vy0wJ3qjazkWUvHx4wngj9bp5Phl+LXy/zu6RViq0TP1ICEjdKo
/ODXN5v8fywcs3hvuiH4aXxW97fqCkX8utxSN96Pg8ibpkEteg8znhuZjHazUA4p
5UV6h7Frw8lytrFklegLMIePQZPPuuW1uabhgT3A7E61pgQ9k8PZAtk00ccsgvIQ
61F0xCDgvRv3AROovbNu/Y2lKhVjCe7E958BUsiEQoW6txj6Q1wKFsgb5vm/0Jvn
uSougQ3kQAOefR/VttiAAbq3RU43a74qTiOFxZF6K74i9C/ASlk4aWHIIJSrPp03
jRe8UFDk08zZNw==
=kCTa
-----END PGP SIGNATURE-----
--=-=-=--
