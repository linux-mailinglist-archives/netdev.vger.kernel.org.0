Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E256C569797
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 03:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbiGGBdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 21:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234862AbiGGBdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 21:33:44 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F3E23A;
        Wed,  6 Jul 2022 18:33:41 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Ldf7m1QfVz4xD9;
        Thu,  7 Jul 2022 11:33:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1657157620;
        bh=o2mvmB8hCKA7jsrgS0QGh/u8Z4/iePcfoI4h8hcwjg4=;
        h=Date:From:To:Cc:Subject:From;
        b=V872+8ryHnBgymafsjtHcruTlVU+nP5ZES9bPmwkgjODC/p3V+dNTNgQxFYPgPmba
         TtTHMP5hohqp3yjn29PQbUku4wsXYilaYhbwvtU4Di6HmR2UvXqUHeggJqGkA5/fAL
         hL5V4DC8RHEj7XtVuxtTQ4DRrBUQiGu3iveGvBlNUsvBenIkzzMgzHlkhXvARIlmGE
         E0XG8s26oAgnJmsqVRQuegA6Y+mR+hPitOzJmLjaTV7nHhtrR8AqLlOM+JoLnOXN7c
         bC+egvGygPgtoB2VFUbI/1pfUXmQWxL7zgJskCDYbKnkyXoudvMAZzouR6w9Cbq+9q
         Op37xbHW47DrA==
Date:   Thu, 7 Jul 2022 11:00:15 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Ratheesh Kannoth <rkannoth@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20220707110015.3549e789@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/kw9F5Dw.1YnB.dLGxmFw.ch";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/kw9F5Dw.1YnB.dLGxmFw.ch
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.=
c:14:
drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h:15120:28: error: 'n=
pc_mkex_default' defined but not used [-Werror=3Dunused-variable]
15120 | static struct npc_mcam_kex npc_mkex_default =3D {
      |                            ^~~~~~~~~~~~~~~~
drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h:15000:30: error: 'n=
pc_lt_defaults' defined but not used [-Werror=3Dunused-variable]
15000 | static struct npc_lt_def_cfg npc_lt_defaults =3D {
      |                              ^~~~~~~~~~~~~~~
drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h:14901:31: error: 'n=
pc_kpu_profiles' defined but not used [-Werror=3Dunused-variable]
14901 | static struct npc_kpu_profile npc_kpu_profiles[] =3D {
      |                               ^~~~~~~~~~~~~~~~
drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h:483:38: error: 'ikp=
u_action_entries' defined but not used [-Werror=3Dunused-variable]
  483 | static struct npc_kpu_profile_action ikpu_action_entries[] =3D {
      |                                      ^~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

Caused by commit

  c6238bc0614d ("octeontx2-af: Drop rules for NPC MCAM")

I do wonder why static structs are declared in a header file ...

I have used the net-next tree from next-20220706 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/kw9F5Dw.1YnB.dLGxmFw.ch
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmLGMB8ACgkQAVBC80lX
0Gwqtwf/QHFMflRfq7shMIVehGd1lTrxfD85OiFJRAnmZzYyh/aRB73JlujeV5pR
oWoDyqFXxvgyog6YmTeQFYnVLP4KJPUbLpqSbBVqE8iuCMgoe0DvLOnYKKsBgZ7w
FHq5S6Z7iIqhxOQPrNn06Jq78wGZduDYyXiM6GcU7fhnGRyg0Wgsr7FzvUoXLRe2
a1hEupgb5QD2WLRyL3jyguE9wJqElyh/pcpZ+SzCZ/Cabn6xkioM1nDclqELdZQB
pnoBI+7T1dkLALUjdwgRJnGrkLwyFRxp74BVabw2dJWukQQb2ldLRyJ8mgo5q7LT
LZHjmLcWSIfi1Ou0Vnq3yE4R2B8K+w==
=d1Hc
-----END PGP SIGNATURE-----

--Sig_/kw9F5Dw.1YnB.dLGxmFw.ch--
