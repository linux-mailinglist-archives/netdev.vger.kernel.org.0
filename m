Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB8967F7CC
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 13:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbjA1MVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 07:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjA1MU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 07:20:58 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E480223C58
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:20:57 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674908456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A1XIVaucNSXynT0+YGvZAYgzlAp2UVil4HlRsF4dvhI=;
        b=0Pr2Y/sKLram3Oq97WEparvyi76diWyGXlxnE/X67qfmKyCCzFai8Aw1YeYqDYv1fdHxNu
        kUCmrHPNJphccZ1FKHlS4x/Kr8COC7qVJuPzUHQFJ90NjVw2txgNKwI4A33qf7SjFwU6Ia
        oO2LCd0oqlIYFXeFMBUsUxHjcVNNXfxsPNHlO+Y5VvAD5adnNbvhROkq65w741+Ayn54sT
        SP5m2266gH+nXp96kuxGXNNhbfu6VwB6EB8xCt2mQwXXbBkn8TVjWM1HZSa11HHy+7v04s
        gC4UYx/NDVAndv4Yu8AMU1KMfEg5glacnpt7Lp0YqiIV8TbT1gnEhqQTmCsWCA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674908456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A1XIVaucNSXynT0+YGvZAYgzlAp2UVil4HlRsF4dvhI=;
        b=CQtUDFJX2Q3aNYDuBeYQMs4iqhsSHlN4+paPUhD9jA0xarDoVGe4PJHji2qaODdj75FWhE
        pvWE56sRt+lr/pAA==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 00/15] taprio fixprovements
In-Reply-To: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
Date:   Sat, 28 Jan 2023 13:20:55 +0100
Message-ID: <87o7qiu9y0.fsf@kurt>
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
> I started to pull on a small thread and the whole thing unraveled :(
>
> While trying to ignite a more serious discussion about how the i225/i226
> hardware prioritization model seems to have affected the generic taprio
> software implementation (patch 05/15), I noticed 2 things:
> - taprio_peek() is dead code (patch 01/15)
> - taprio has a ridiculously low iperf3 performance when all gates are
>   open and it behave as a work-conserving qdisc. Patches 06/15 -> 09/15
>   and 13/15 -> 15/15 collectively work to address some of that.
>
> I had to put a hard stop for today (and at the patch limit of 15), but
> now that taprio calculates the durations of contiguously open TC gates,
> part 2 would be the communication of this information to offloading
> drivers via ndo_setup_tc(), and the deletion of duplicated logic from
> vsc9959_tas_guard_bands_update(). But that's for another day - I'm not
> quite sure how that's going to work out. The gate durations change at
> each link speed change, and this might mean that reoffloading is
> necessary.
>
> Another huge issue I'm seeing at small intervals with software
> scheduling is simply the amount of RCU stalls. I can't get Kurt's
> schedule from commit 497cc00224cf ("taprio: Handle short intervals
> and large packets") to work reliably on my system even without these
> patches. Eventually the system dies unless I increase the entry
> intervals from the posted 500 us - my CPUs just don't do much of
> anything else. Maybe someone has any idea what to do.

Thanks for investing the time and improving the software
scheduling. Especially the calculations of TC durations and
incorporating the max. frame lengths in a better way. I went over this
series and it looks good to me. Except for one patch.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPVEycTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgl08D/sGlp/gJ/xqiHUtoVQC2c0omIYDqp8h
MPiR0TESgqYphArDs3p1W4+LZsICeC2oQTpuOZEnpK182/38P1f61h3AObWJMCaf
bOdBRrWxhkOA8eSAHeE1hp67qi590/73bWTe+LQk1lzG3pLGB3ggfQlRuG4UI2oR
cA0nXB+R5hZaOYWWjScsP4OZUZ5UXMuRH4Cf3C9yeLTTIyQGaHOZ4aHt4I2QWkya
v5WBOQqUsNvba7hhJ+6GoF9OMyn6uTR4IQO2MwC7ck9o4g7LYbkGTWZCN8/OYhTJ
XDq8KZbtg1GuXqj1JPwmg6LkK9b8VrfvEoMnipiPZ8aLPSU2N8GcQn+dqHl0n4mJ
yKFvH3AelTP0lkBP7PkYC1POstMPhO9z29Tpvc4gLJHFwftDyW8B79pMh7s4ARz3
yJ1I1f3YKJmOKbZPatoHXAT8lQjkXzREUb4dTW8elIeVIVKspDxAarjSn0xXNFB+
QClDTrB22Qv1ORFOlD3jSi0aDANCP9dEur0WVJvikVad4k1cda9rEYhXr957WV6f
3JuAcAKP13UnzLBDupeTdUJ5LljESTPjndBfkCr0lIqESUTQi7DY6D1lu6wihjHO
ZeXYeuRyVfWqjZsP4aLnAH0E+DGYSvaFxddQFLOhILEvVu8qCbnmPJmR8uIG5eTP
bR0QerqyLLoyvQ==
=MTvu
-----END PGP SIGNATURE-----
--=-=-=--
