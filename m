Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD904D9A88
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 12:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347976AbiCOLpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 07:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241589AbiCOLpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 07:45:38 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90AB2AE1A;
        Tue, 15 Mar 2022 04:44:25 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KHs533hsNz4xL3;
        Tue, 15 Mar 2022 22:44:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1647344664;
        bh=I1kvJkvdwUyhlOvf9ZD2jpbUo7A7tXOZ/UJA5p1xLvU=;
        h=Date:From:To:Cc:Subject:From;
        b=aKa5VHgybScX95rsy/FeQcFWJc8w1L4qbc49YtztRZxBN/YsxkndP0eVFQ87bNezg
         rqo7efNlC5pwWpnH852tboZgDw8TEWZ6dMMN2axOONrxTcwr0KqoCZ9wwzccoV4MPj
         kXmuqmyIiJUKtb40MqfXV683yVeXO25zDgLZ/btmLngl7Zx2nUr1+l9spwGxpSQJ4Q
         V7MuvmC0DGye9E/f724pXIW3VYoZwWRiQ3G7sHpVZdZfwcf/WoydCMSSVEBzDxPAuc
         H1h1evmiCifwP3peDVu7+a/EIyUV+ZSD4DMcnsaNcHMltoIV2PCHQziC0eQ9ECnGys
         X2JzeKsno8pLg==
Date:   Tue, 15 Mar 2022 22:44:21 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20220315224421.23a8def1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/u9Y+4SMt+b9MeJhzmI11hoN";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/u9Y+4SMt+b9MeJhzmI11hoN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (arm64
defconfig) failed like this:

drivers/net/ethernet/mscc/ocelot.c: In function 'ocelot_port_set_default_pr=
io':
drivers/net/ethernet/mscc/ocelot.c:2920:21: error: 'IEEE_8021QAZ_MAX_TCS' u=
ndeclared (first use in this function)
 2920 |         if (prio >=3D IEEE_8021QAZ_MAX_TCS)
      |                     ^~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mscc/ocelot.c:2920:21: note: each undeclared identifie=
r is reported only once for each function it appears in
drivers/net/ethernet/mscc/ocelot.c: In function 'ocelot_port_add_dscp_prio':
drivers/net/ethernet/mscc/ocelot.c:2962:21: error: 'IEEE_8021QAZ_MAX_TCS' u=
ndeclared (first use in this function)
 2962 |         if (prio >=3D IEEE_8021QAZ_MAX_TCS)
      |                     ^~~~~~~~~~~~~~~~~~~~

Caused by commit

  978777d0fb06 ("net: dsa: felix: configure default-prio and dscp prioritie=
s")

I have applied the following fix up patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 15 Mar 2022 22:34:25 +1100
Subject: [PATCH] fixup for "net: dsa: felix: configure default-prio and dsc=
p priorities"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/mscc/ocelot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc=
/ocelot.c
index 41dbb1e326c4..7c4bd3f8e7ec 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -7,6 +7,7 @@
 #include <linux/dsa/ocelot.h>
 #include <linux/if_bridge.h>
 #include <linux/ptp_classify.h>
+#include <net/dcbnl.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include "ocelot.h"
 #include "ocelot_vcap.h"
--=20
2.34.1



--=20
Cheers,
Stephen Rothwell

--Sig_/u9Y+4SMt+b9MeJhzmI11hoN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIwfBUACgkQAVBC80lX
0GyMbQgAgahDoiC6FAzw9S27/y1ElyAuLOYwCXFN7I+bbv98pI22SUm0XhaufTOz
OuipKroQN/w5C15nyMbAKiw5tvCXUIM1Bd4TlvUxZS65qBQ+8Aaci1ASWunMpC0T
1eZVUXrwhbwjumciKrlC+deEGWVW09MQ+yUCI2DDRFXofftbJNXlWVe3AC45/MBd
l6AJTzun5HcO3HzisgOFL+VEfVzOh/sh98vmLedRg9La2hJYYhvrcTqEw12gQRlr
AcXuPwrwTmND1URg/UB3qrYXJxELOq8A50i53Qb3uAl9nGWErnlGT2efV6QzaRQu
uhuMfv69fs9HB5d4XQ2kbUpmbb/PBA==
=/JqO
-----END PGP SIGNATURE-----

--Sig_/u9Y+4SMt+b9MeJhzmI11hoN--
