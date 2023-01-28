Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC5367F7B8
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 13:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbjA1MEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 07:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbjA1MEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 07:04:40 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EDE790A2
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:04:39 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674907478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5AotKWJ56DuXwWarl6aYeMKXu6k5f8gViBw8hYDWfFE=;
        b=gfhF3yN5Da0HKgRXW4nV3iaDaE/VGshSpsRXf4891N5MHLv6gMB6DlUl/RR1UJa52H9USU
        oHns8/ZY6Bbaim+ceX2poIqfdpZpbk0+TwVInNGfCkl7Z7c8YuFg2FZ80ACOhxJ/E0DfLe
        uXw2Lo2ejGSwBMz1TUYvb3ErbOjw/jV/VImOcNJCSznADucDW/5sg5jZ8ySH0t6d72bP4T
        kk8yNZVvDllilQw7YwhZ9Wkvzz0dZdG/qmTB9He4c4SuX49eY1KIt21UrtQ5UgeNct6Y9O
        x2gFrv8E6ft+LeI4NeRIvS1lpQ50Pcc5xigATJNHaCuceqOE/mrbMZnHXUGgNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674907478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5AotKWJ56DuXwWarl6aYeMKXu6k5f8gViBw8hYDWfFE=;
        b=LsfC95i4ttQdIMcOsHozAUH1BIngzJ/YmyM2yN3X2gg5PZ7m+J+KhwpJpMwrvSAz9KgAUl
        KO0MDQbLb1RakeAA==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 05/15] net/sched: taprio: give higher
 priority to higher TCs in software dequeue mode
In-Reply-To: <20230128010719.2182346-6-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-6-vladimir.oltean@nxp.com>
Date:   Sat, 28 Jan 2023 13:04:37 +0100
Message-ID: <87k016vp9m.fsf@kurt>
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
> Currently taprio iterates over child qdiscs in increasing order of TXQ
> index, therefore giving higher xmit priority to TXQ 0 and lower to TXQ N.
>
> However, to the best of my understanding, we should prioritize based on
> the traffic class, so we should really dequeue starting with the highest
> traffic class and going down from there. We get to the TXQ using the
> tc_to_txq[] netdev property.
>
> TXQs within the same TC have the same (strict) priority, so we should
> pick from them as fairly as we can. Implement something very similar to
> q->curband from multiq_dequeue().

Totally makes sense to me...

>
> Something tells me Vinicius won't like the way in which this patch
> interacts with TXTIME_ASSIST_IS_ENABLED(q->flags) and NICs where TXQ 0
> really has higher priority than TXQ 1....

However, this change may be problematic for i210/i225/i226 NIC(s).

AFAIK the Tx queue priorities for i225/i226 are configurable. Meaning
the default could be adjusted to have Tx queue 4 with higher priority
than 3 and so on. For i210 I don't know. Also Tx Launch Time only works
for the lower queues. Hm.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPVD1UTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgk/0D/0VzJyh1Qtuz+0/k/+ZEMvyINZEUzVN
WHcfblOJU4GNqgZOjFvgxvZtF07cjgMG5ro0lCVOOisWfePhL//Fms5v+f31Ykdf
mKm71m5h4G9XaV3/O6a1iGZZp7lp2L8RAnRfv5kHiMzZHQ8V6H3bIcNhdRW2GiZs
s+nUmFwyZWGwtTX8TOLth2Sq0IeWQtUWkm3lVa1S1FCznszHvLIOCbSyvrfK4R9e
zd3wmHslD7BzSfZ7+MOiG2J9vrbW9KjT6gHgmvxDXnk00MOAM1/I0IsGMKxQWm7U
IYiiz9or7HtHs4iYrkzsSd+txQzMuIjSE95C+7pOvTVkSdxFKZRx/ZCvSwd0GV7d
dXsIVOJtNGfSADFFh/QGC0fE7H/uU/LDAlXIXeo3IqvQW5eaRBR+GeqnYIxR0Sr6
1Nk7drLjF2B+SYZ5C0f7famtk21xcQDHWtRXJjYxjCs/V6i4onJLaalwvtSe/VXP
z070+Acve1WDkFzOPCgjpbAwx7vF5zlxpeUTC8yRucCeZiyk71JW6YMcDkPRLfn7
Pt/0bmFlLI57Irr/HoUDpJbdWxJRH5f2J7sWOGC5RnR416TqaEPHLkGMh+wyRrun
w52x8mLybzIE4sSMUhyrOw93I/6hVytqfBCDk27AkuCPzXvSVctuGVNwUwGT/F47
C1l1+kp0YneLLg==
=VDMz
-----END PGP SIGNATURE-----
--=-=-=--
