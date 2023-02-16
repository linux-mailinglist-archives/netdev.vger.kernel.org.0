Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41886698FC8
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 10:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjBPJ2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 04:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjBPJ2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 04:28:10 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D312234EF;
        Thu, 16 Feb 2023 01:28:01 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1676539679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tcMp2NeFrtsdaQ5utl7VB4w5fsTtu8Iituq4/x3dpGo=;
        b=z4qRPKkmrEiAq9xqnzwI1RWrh9tIYtt2TRCBkL/EwIVMVulxo73tjXSFsuIGmr6m4y8K8U
        GSOOWDSuOg6zktkxUM1lygds0Q7o6uERPNvF3+aI7FfnieJNB8QjKIvQvK9zqu7kturPob
        ArCutBUNbrV/6Bj5Fbs5wEkcP/t0/GFMJOi0xp8ghR43dqunjOqjufC4VuxxdDBGjGrfbE
        BhCwWzsjjPJs1ORTIE+l9MN0QF1laB7AlXak4LTfFF+l5y0Qqr5X8YVzPj4RecaGGZCKCg
        Z6YgqHsvTMaxgyg3XMl7lBdaNU8RgI3bc6L1rw/dMxOnzAByiSIWEPCCKV8ZdA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1676539679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tcMp2NeFrtsdaQ5utl7VB4w5fsTtu8Iituq4/x3dpGo=;
        b=nmSmAtXr9qbv9LyUxLGEiErkOx7W5jhUU762OeKbadNMw3I00O6orFTx8RsQuC05KUmD6d
        d//i3vDPPAkBBIBw==
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
Subject: Re: [PATCH net-next 2/3] net/sched: taprio: don't allow dynamic
 max_sdu to go negative after stab adjustment
In-Reply-To: <20230215224632.2532685-3-vladimir.oltean@nxp.com>
References: <20230215224632.2532685-1-vladimir.oltean@nxp.com>
 <20230215224632.2532685-3-vladimir.oltean@nxp.com>
Date:   Thu, 16 Feb 2023 10:27:57 +0100
Message-ID: <87fsb6ot7m.fsf@kurt>
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
> The overhead specified in the size table comes from the user. With small
> time intervals (or gates always closed), the overhead can be larger than
> the max interval for that traffic class, and their difference is
> negative.
>
> What we want to happen is for max_sdu_dynamic to have the smallest
> non-zero value possible (1) which means that all packets on that traffic
> class are dropped on enqueue. However, since max_sdu_dynamic is u32, a
> negative is represented as a large value and oversized dropping never
> happens.
>
> Use max_t with int to force a truncation of max_frm_len to no smaller
> than dev->hard_header_len + 1, which in turn makes max_sdu_dynamic no
> smaller than 1.
>
> Fixes: fed87cc6718a ("net/sched: taprio: automatically calculate queueMaxSDU based on TC gate durations")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPt9x0THGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgrSfD/0dzbaEWaE8Wsjj8p+/pmPWhssengiT
qf9tC2iiCiOcdiRYVt44VMGGa8kgPvAB7v2lsLfRXs7HqpXgtpOpPpwfr0l/oecy
ruvtwZNesMPQyOpjpwJcTR/PJ8T6LxoIZRMILUuLzmuU3XTDmmrlBllme0NR96/F
pSUbZXRgaTHJO8l2hmlurMou4saoteyMoUbYgge9rwNlsWLBTD8Rd4rfKUFS14md
wgk6vCU4cWQD9MpDtoDr3Shb8a9Y/dH/igWIDtjxyvuT+sbqzJloNhIuxVADNDDN
NkIeMM+8/KKBTY2UhzKCchdxs9Y5fHsyIG6NEhhDFy26GpSe+M3sV5Aes+qJO0nh
+/SH1GmobOHfh8IQeDK5GLPWL5ZXXr8rDf+P8cpsnXMULjMrMURqn+21ESoTr7xm
LsrP1QdS9xDnUYjt/pTGxKQQep5qPmFMC+hlmzw6iKgCIzIJcldSV9mafSUgCte+
+h6WaNzsmJ1tZE/4JawPPBe63MbA62vqzaSVwcwSatTPZb1zMQ8MEZL1qCujmPKK
tKpc2ct6i7aPB3cJHzHSa3K6xSf1C7iMc/CT7fykAuc9C4Vf3oA5Gg3TpG9tQ9/L
JPogykOhpbDK59c3V1vS+rbuH1bENVDgnL3ltCI1C0WLRmvEk2kXMpqxZr+RUMgo
Y1i819pgIZw4jQ==
=nBVu
-----END PGP SIGNATURE-----
--=-=-=--
