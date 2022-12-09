Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06ADB648826
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 19:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiLISGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 13:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLISGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 13:06:12 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D177F880
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 10:06:11 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7330721AAB;
        Fri,  9 Dec 2022 18:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670609170; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ts/iJlAMqRbtErQLc4MD/a8QDdlTuD0oaNigeIVSQOA=;
        b=Mjl5AmRVfxI9GlR4a4IsMqYrOsh2NvWJdKQqb1GW7YhKJPkZmT5YQe7AiXxBtNvviWWPoL
        MOwpxOMhJ5OuTPtsOdVQcScvpg4/mD9hluJjoN98PW+zfKZVNS55oTPCONOuo2r5A+ANF4
        I4xuWXuhS+qfKNtIfe688a/FtUsp+q4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670609170;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ts/iJlAMqRbtErQLc4MD/a8QDdlTuD0oaNigeIVSQOA=;
        b=1GjIU2XWS71BV+NT+Z5cfYr0czB9qO5aydok182tWQpfgOQmBkqAtgVeadgPR6HPFCJnVK
        Ad5rmyg7/PHP6FDA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6A1DA2C141;
        Fri,  9 Dec 2022 18:06:10 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 3818B6045E; Fri,  9 Dec 2022 19:06:10 +0100 (CET)
Date:   Fri, 9 Dec 2022 19:06:10 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 07/13] ethtool: avoid null pointer dereference
Message-ID: <20221209180610.b43ttow2qugq7ont@lion.mk-sys.cz>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-8-jesse.brandeburg@intel.com>
 <20221208062312.2emtsvurflldumsr@lion.mk-sys.cz>
 <c62825b9-e2b2-9293-e36e-c34d83c0d7e6@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4tkzegi5lrooa23b"
Content-Disposition: inline
In-Reply-To: <c62825b9-e2b2-9293-e36e-c34d83c0d7e6@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4tkzegi5lrooa23b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 09, 2022 at 09:36:54AM -0800, Jesse Brandeburg wrote:
> Here is the callchain, for reference:
> This is from the command
> # ethtool -s eth0 wol pumbag
>=20
> #0  nl_parse_char_bitset
> #1  in nl_parser at netlink/parser.c:1099
> #2  in nl_sset at netlink/settings.c:1247
> #3  in netlink_run_handler at netlink/netlink.c:493
> #4  in main at ethtool.c:6425
>=20
> and in the #0 frame above, *nlctx->argp =3D "pumbag"
> in the callchain above, scan-build doesn't like us de-referencing argp
> because it doesn't have proof it's not null.
>=20
> Further I tried putting the check in every element of the stack frame abo=
ve
> and they all fail the scan-build check still, probably because the pointer
> is advanced to the "pumbag" argument later in the code.

This should be guaranteed by min_argc beeing set to 1 in the relevant
member of sset_params[] array in netlink/setings.c. The dispatcher code
in nl_parser() checks that there are at least ->min_argc parameters left
before calling specific ->handler(). So as long as argc and argv[] are
consistent, we should be safe.

But I suppose we cannot expect the static checker to be smart enough to
see through that logic.

Michal

--4tkzegi5lrooa23b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmOTeQ0ACgkQ538sG/LR
dpUN6Qf7BULFXGMqYQFtCSjUKY93tF/Mpfi1v+F1plOBkgFtpKaytNcKZonMJVW8
u0s9KWYVQ9+xg1i/7Xaxj4kSxo3kxF+QYQ8pQgJo81UKEWFriUMm70odDrt5m+w9
urlTVTq7rbddBC9+aK+NNHmO8RoXimmVIEr0IZ5zj9JE0zmB+GDCYVa7Cbl88h2x
A03Ow0KZ1ZiXgVjCh65KdYmWpakxPCHqgQYPH0YXBMqgt2SeCOviI3qAu3G4hBFe
n9U2Pshz3fbX1PlUHrwEidmYd1uHcrlxYZ95ibapPy9Z4weZ7/c+b4HxmS9Aq+wQ
7xkcpcM3zUME5f1SwKr+lCKndHm0fQ==
=/Z6X
-----END PGP SIGNATURE-----

--4tkzegi5lrooa23b--
