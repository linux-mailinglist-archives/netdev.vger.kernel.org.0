Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1387667F7C0
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 13:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbjA1MGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 07:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbjA1MGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 07:06:43 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09974790A8
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:06:43 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674907601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f1FgczhDvLPJmHjtpcnbO+YCaifoisVTvSctMpuOSWc=;
        b=L7RGBwX1P7FwJoFgjOLWL1Xx0vWVzIqA3Kgj05fTNcMsBxrAc0wA8JOMEkKmdfnDSqd5ZI
        aORT57KwIHwR5PXWRdnyNPrQRj2PbEkBLkhiVt3hUOXk8Werk53bPlR6j5HBEgKhZRmw34
        QRylsoZgu8FpI9k206RlFwos+/mA9u1bghaswzhrBCQFUoy2BIkhWUDxuE/diQlDkbQs8O
        DqkN+H3QVUCNjR3fZDURIPaKCZS4SisyIeIo5j6AkZD0LGowp+4usJwMfxLjDCzza/lEmN
        3Aw+u6M73Q84+bu9vErlpkqgWD5Uqx36lFOhGlsuCRDcR/P5qD0adGIcQsYnYg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674907601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f1FgczhDvLPJmHjtpcnbO+YCaifoisVTvSctMpuOSWc=;
        b=Ju3zS+BAGJZJCwG6jDik4ppYTDH05dGk6U7MeVZUelaEZFyl9iV5L/EwH44eLItgCXLUh7
        JyAv2VuQ7rcZtuAw==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 12/15] net/sched: keep the max_frm_len
 information inside struct sched_gate_list
In-Reply-To: <20230128010719.2182346-13-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-13-vladimir.oltean@nxp.com>
Date:   Sat, 28 Jan 2023 13:06:40 +0100
Message-ID: <87zga2ualr.fsf@kurt>
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
> I have one practical reason for doing this and one concerning correctness.
>
> The practical reason has to do with a follow-up patch, which aims to mix
> 2 sources of max_sdu (one coming from the user and the other automatically
> calculated based on TC gate durations @current link speed). Among those
> 2 sources of input, we must always select the smaller max_sdu value, but
> this can change at various link speeds. So the max_sdu coming from the
> user must be kept separated from the value that is operationally used
> (the minimum of the 2), because otherwise we overwrite it and forget
> what the user asked us to do.
>
> To solve that, this patch proposes that struct sched_gate_list contains
> the operationally active max_frm_len, and q->max_sdu contains just what
> was requested by the user.
>
> The reason having to do with correctness lies on the following
> observation: the admin sched_gate_list becomes operational at a given
> base_time in the future. Until then, it is inactive and applies no
> shaping, all gates are open, etc. So the queueMaxSDU dropping shouldn't
> apply either (this is a mechanism to ensure that packets smaller than
> the largest gate duration for that TC don't hang the port; clearly it
> makes little sense if the gates are always open).
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPVD9ATHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzghtID/4kS5BpWs2lawiQy/a8Snqcy5OIQDg0
kdUgX43tEL7o0Pe6zvsJjNgso+NlSTY7b2RXXeeatHR2hZFumA9S4Xk9Wi0c+yE4
KULoW12dC3ZqfjxfgWXsGKFoTxnMb8Fub32k0gBAZZSFCoNNdnGHpsMdd/Frh7VH
lYtgUyGY/mAcjGVoOXZo8q6FahL9Cif9xeDKSQfy1mGRTO4R6IKigrw0NbSB+3kN
DbiRKtFzWEuSSUpm8vvF1vCjbDDagOVX+5PWP2a/PzhD5md7SDflTGRbicCHrD2s
mrGPpcWSO8na5+Cbj3gR/bOhDvIkLrJXqBFHRdkEpeK0tpazG/lVVBCgs9KKjBeD
XJI0Mvhsl5uyvSq27vsDU8pfJVggJiVariQ+AAUqHFaFE9TzJQduIefZFqlflMHj
TLPvzMjTU1xTUij1lb8VN3OYm8hMk4htTvwpUhU29dO/P1cJ59UYOfP69en+fqx2
1PTLQzePT63/KdHnjM4PJNFbR4ZZgP089e/yGnptY+4FenQEQ7zhpN1udPAB+oVz
OP5/k3Nyj63kj21u6K8ErKlAj4TEiAaATVpDDOEdlU8q0CPvqAZdW7vC5aFAxzjO
kw7Oz/ICH6B16cU4n2vA2evwgkDOSa1a3gBp/5ltr01xol60ywUUZSlreaK7Gmq8
OZZaPqUfGbUdYg==
=oCkv
-----END PGP SIGNATURE-----
--=-=-=--
