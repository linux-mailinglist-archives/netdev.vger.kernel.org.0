Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA97350AB77
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 00:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442445AbiDUW0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 18:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238958AbiDUW0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 18:26:32 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A28043ED6;
        Thu, 21 Apr 2022 15:23:41 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KksWb2SRcz4x7V;
        Fri, 22 Apr 2022 08:23:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1650579820;
        bh=TzHIXgU5u/YplLhlszLssgysBQ7/yxlO9oWuBK20+KM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LjPPjNGaLnByyley8u/CKpOkpIka/Fq6k6Lp7V8y0VY4JL+f4DamjahPVwCbw6QxM
         rdoFXZOYPhbdCjaPE9ONjlRbN9iU5VFW5D2slrEontLHI/Z9pX/8sek/fSpHjjP1Xt
         Eemi5gvs6qYyCocbayqJUXOKknmaaRxuYu5FLMyD9gGB64l0LUAyBM8JYn7LiQTzTX
         BJZAbje9+G547XxOu0MEz3oSFeogJaAjg2yET3+r8Mk0DxXIn0c/ges7Aykmc14C68
         FASoofHkKe7/wDra2TH5FBAuWwqCbPM2tJz0f47oWDl0pBAgKdE/LP5RRipI76Cpy6
         A7N/XiLm7k7BA==
Date:   Fri, 22 Apr 2022 08:23:38 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, linux-next@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/2] ixgbe: xsk: get rid of redundant
 'fallthrough'
Message-ID: <20220422082338.60f83db5@canb.auug.org.au>
In-Reply-To: <20220421132126.471515-2-maciej.fijalkowski@intel.com>
References: <20220421132126.471515-1-maciej.fijalkowski@intel.com>
        <20220421132126.471515-2-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/9n3j1gY63unMTPsMS+EbEV.";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/9n3j1gY63unMTPsMS+EbEV.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Maciej,

On Thu, 21 Apr 2022 15:21:25 +0200 Maciej Fijalkowski <maciej.fijalkowski@i=
ntel.com> wrote:
>
> Intel drivers translate actions returned from XDP programs to their own
> return codes that have the following mapping:
>=20
> XDP_REDIRECT -> IXGBE_XDP_{REDIR,CONSUMED}
> XDP_TX -> IXGBE_XDP_{TX,CONSUMED}
> XDP_DROP -> IXGBE_XDP_CONSUMED
> XDP_ABORTED -> IXGBE_XDP_CONSUMED
> XDP_PASS -> IXGBE_XDP_PASS
>=20
> Commit c7dd09fd4628 ("ixgbe, xsk: Terminate Rx side of NAPI when XSK Rx
> queue gets full") introduced new translation
>=20
> XDP_REDIRECT -> IXGBE_XDP_EXIT
>=20
> which is set when XSK RQ gets full and to indicate that driver should
> stop further Rx processing. This happens for unsuccessful
> xdp_do_redirect() so it is valuable to call trace_xdp_exception() for
> this case. In order to avoid IXGBE_XDP_EXIT -> IXGBE_XDP_CONSUMED
> overwrite, XDP_DROP case was moved above which in turn made the
> 'fallthrough' that is in XDP_ABORTED useless as it became the last label
> in the switch statement.
>=20
> Simply drop this leftover.
>=20
> Fixes: c7dd09fd4628 ("ixgbe, xsk: Terminate Rx side of NAPI when XSK Rx q=
ueue gets full")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Reported-by ?
--=20
Cheers,
Stephen Rothwell

--Sig_/9n3j1gY63unMTPsMS+EbEV.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJh2WoACgkQAVBC80lX
0Gw+cwf+N8M5S1MhHohxOATD49rBNfc9/Hnb6CBz48Zg8cscfgYG6Iqv5znZvYaB
4IZPWo6IQgAGFlH7CKm4n87T9W8G2i8Wv3P6LClfz7MbfIdyHWfJvA8ApGAluGmv
kigTWFEsFcwegxCI/FYQgkHkz5fs7NG4qmZk64wtxG7YyDUZDusTg25eRTWpnluw
+G/t+AsOsZBmufACsKtavzL43BIqhsJoB1r0NAEJSYWprONED65KDCGeSFAe0sj/
SYHauF6gd/pG4ZAw7vOG/d0hjIxJWle4FnDUSxJDVGNg7HbKsNYPO5UdywFkqCjo
4KPDAKZ/Xq8cJd1hNfs6TdQBuuHyLA==
=Sh6i
-----END PGP SIGNATURE-----

--Sig_/9n3j1gY63unMTPsMS+EbEV.--
