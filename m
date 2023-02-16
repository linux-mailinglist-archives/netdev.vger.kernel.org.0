Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A5B698FC5
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 10:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjBPJ1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 04:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjBPJ1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 04:27:51 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C2723119;
        Thu, 16 Feb 2023 01:27:46 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1676539664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jw3PZ7MODFX9HxX9q5lGVWQ7M8L+9vkiuEiADAQGJS8=;
        b=hT3rr/afUadWcQ3Y5HoN90bLPMD9UQV+3jSGwtwqlvnNbZeIyh47kgoXBS88ORqQ/IFhR/
        2tQe3hr1+Q1n3paRhsSRAnMjinwC5rkXhh3VfGDCMfqIE+Y1uq0HW79MzqX8QReGh5SqIK
        NluzDAtVIhg/pHDv4as71w+xjliE0+yBS376uJDg6dKdvnoN8Ts6+CwPS28eSdI4qnSQ7L
        yn9uWBXy9aDIUInKqOG0HIKZZKWtXi3Ec2AEMwOXxze/JKWaLE0Lp+oXxehhzJ5w03CM+7
        V3G4KC+yN8/GcQe/oECmAvtw2e2KVjvae2GGlw2xBBpcGZHMPAeYM6FXHUGBfw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1676539664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jw3PZ7MODFX9HxX9q5lGVWQ7M8L+9vkiuEiADAQGJS8=;
        b=Q2R40o0xtkF3OjUbI4RAPRCNftTce6zbJGSYaffgUM0JnhlCiPfjrSrLnr/rWqngPTw2VP
        ikZp/SXYNSlGJQBQ==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net/sched: taprio: fix calculation of
 maximum gate durations
In-Reply-To: <20230215224632.2532685-2-vladimir.oltean@nxp.com>
References: <20230215224632.2532685-1-vladimir.oltean@nxp.com>
 <20230215224632.2532685-2-vladimir.oltean@nxp.com>
Date:   Thu, 16 Feb 2023 10:27:41 +0100
Message-ID: <87ilg2ot82.fsf@kurt>
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

On Thu Feb 16 2023, Vladimir Oltean wrote:
> taprio_calculate_gate_durations() depends on netdev_get_num_tc() and
> this returns 0. So it calculates the maximum gate durations for no
> traffic class.
>
> I had tested the blamed commit only with another patch in my tree, one
> which in the end I decided isn't valuable enough to submit ("net/sched:
> taprio: mask off bits in gate mask that exceed number of TCs").
>
> The problem is that having this patch threw off my testing. By moving
> the netdev_set_num_tc() call earlier, we implicitly gave to
> taprio_calculate_gate_durations() the information it needed.
>
> Extract only the portion from the unsubmitted change which applies the
> mqprio configuration to the netdev earlier.
>
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230130173145.475943-15-vladimir.oltean@nxp.com/
> Fixes: a306a90c8ffe ("net/sched: taprio: calculate tc gate durations")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPt9w0THGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgiLWD/sEsgU4uIw/hKRfG8XNgX+JjTAvMbuy
xBGaj8M+l6+U975oDQ7Blw5r9vXNwKPenNJrWUAKbFQdGS6/iuA3h/6cYsYzlMZZ
RPI7sxu0cvwnI48CjaXRAQdZwopMDx+Tyz6Lo6Gdzqbzy007EgKYv3KL5asPkHR+
SNjhcUgdcBDy6B0hyNO3oYDw2jlNuU9T+xelfRd034RploGRTh2EQ3jbAAYhOD1Y
Q3f4S3eqoz50PlkwnTxM4RWIQjkmxtdyke4lU/E8/XUPx392anzuwW9srdNzR/3t
fg5bcd/bF+m7cJ5GIYh6gKdqFs8dH4tJ0EpKF0sMw/wzy2iafSNB6AGTXSQSTMe1
ty2+xpyG4NVAhthS4ieMMWRTvZKjfnEzfwQ8xrRK2n+P3hN3UOdcq+IkVJsi+wQ3
RmxLNQr9ExNcUvYMUm+ZHHrGhwHQwCWRnlN8I74VuWN5Vbe4J0xLHeh+KtVAU2Q0
tcH7bhyKUIqp8B9CZ1wzMuHLnMB4xRFIK64kEZU3TvBghWnWNKsUGGXGTBWj4Kh5
1WAMb/FfDjZfai36fliwlo/fieMWpJmCIhrClIaEUi1o17LaPJ0lV1P++Ohfw0a9
wV0j8VhG67BRQKmzx6go4S69R49+vwfDf87BkuuEPY0SMLgG6YFhz28jD97Ufo5p
FpGqkr1f3T34IQ==
=br6z
-----END PGP SIGNATURE-----
--=-=-=--
