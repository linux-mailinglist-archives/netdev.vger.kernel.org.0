Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB42569D810
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 02:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbjBUBkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 20:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbjBUBkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 20:40:14 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5675B22008;
        Mon, 20 Feb 2023 17:40:12 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PLMRZ35bRz4x5c;
        Tue, 21 Feb 2023 12:40:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1676943610;
        bh=R633ZxmFQr05Wn7nHXnT2zdbX27p0BgtOVKvAKbviB4=;
        h=Date:From:To:Cc:Subject:From;
        b=NvSHKmlLYKF5iVuCmrtMCLfnFJiduJnzuarxfAQ1r6XLc7NgznUX/O32CzqoM5ZYC
         dlj4/O9GCcXVqX6YNwADoSoY1LEqpLXpECmQrUnqwjesl2J/Xdt+BomGV0370BSJJ3
         vaoTYCWS5HMMhpfg2hVpdAv0nLs0SwTI1Jy2eE58I2XHQ9HZ5h//638k8T89SttKRs
         HgdeAA0oB2QR2VjQxAeu1Le9aFVCob+if44Qx46Sbr+XJ3oAGcRCdyzIO7c1GtlyO3
         jlZhOWaleq5ftMEJB0WTmvIWicKiSDhyG9o5bXA+4VCGo4fJCNI1ucRNsQ3eE/NLXk
         OksIm0aGuyTrA==
Date:   Tue, 21 Feb 2023 12:40:08 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     "D. Wythe" <alibuda@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20230221124008.6303c330@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/q.NHokfwG8o5oNYogd0b7kn";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/q.NHokfwG8o5oNYogd0b7kn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from include/linux/notifier.h:14,
                 from arch/x86/include/asm/uprobes.h:13,
                 from include/linux/uprobes.h:49,
                 from include/linux/mm_types.h:16,
                 from include/linux/buildid.h:5,
                 from include/linux/module.h:14,
                 from net/smc/af_smc.c:22:
net/smc/af_smc.c: In function 'smcr_serv_conf_first_link':
net/smc/af_smc.c:1842:20: error: passing argument 1 of 'mutex_lock_nested' =
from incompatible pointer type [-Werror=3Dincompatible-pointer-types]
 1842 |         mutex_lock(&link->lgr->llc_conf_mutex);
      |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~
      |                    |
      |                    struct rw_semaphore *
include/linux/mutex.h:187:44: note: in definition of macro 'mutex_lock'
  187 | #define mutex_lock(lock) mutex_lock_nested(lock, 0)
      |                                            ^~~~
include/linux/mutex.h:178:45: note: expected 'struct mutex *' but argument =
is of type 'struct rw_semaphore *'
  178 | extern void mutex_lock_nested(struct mutex *lock, unsigned int subc=
lass);
      |                               ~~~~~~~~~~~~~~^~~~
net/smc/af_smc.c:1845:22: error: passing argument 1 of 'mutex_unlock' from =
incompatible pointer type [-Werror=3Dincompatible-pointer-types]
 1845 |         mutex_unlock(&link->lgr->llc_conf_mutex);
      |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
      |                      |
      |                      struct rw_semaphore *
include/linux/mutex.h:218:40: note: expected 'struct mutex *' but argument =
is of type 'struct rw_semaphore *'
  218 | extern void mutex_unlock(struct mutex *lock);
      |                          ~~~~~~~~~~~~~~^~~~

Caused by commit

  b5dd4d698171 ("net/smc: llc_conf_mutex refactor, replace it with rw_semap=
hore")

interacting with commit

  e40b801b3603 ("net/smc: fix potential panic dues to unprotected smc_llc_s=
rv_add_link()")

from the net tree.

I applied the following merge resolution patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 21 Feb 2023 12:30:46 +1100
Subject: [PATCH] fix up for "net/smc: llc_conf_mutex refactor, replace it w=
ith rw_semaphore"

interacting with "net/smc: fix potential panic dues to unprotected smc_llc_=
srv_add_link()"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/smc/af_smc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 0f6a61e44e93..a4cccdfdc00a 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1839,10 +1839,10 @@ static int smcr_serv_conf_first_link(struct smc_soc=
k *smc)
 	smc_llc_link_active(link);
 	smcr_lgr_set_type(link->lgr, SMC_LGR_SINGLE);
=20
-	mutex_lock(&link->lgr->llc_conf_mutex);
+	down_write(&link->lgr->llc_conf_mutex);
 	/* initial contact - try to establish second link */
 	smc_llc_srv_add_link(link, NULL);
-	mutex_unlock(&link->lgr->llc_conf_mutex);
+	up_write(&link->lgr->llc_conf_mutex);
 	return 0;
 }
=20
--=20
2.39.1


--=20
Cheers,
Stephen Rothwell

--Sig_/q.NHokfwG8o5oNYogd0b7kn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmP0IPgACgkQAVBC80lX
0Gy7Dgf8DyiUAhmBBjXWXvL9D7J02tPw9+FDi7zqJ5JTGVfk+WT7g+ZhYpOsFLfh
6H2NVRJvHSwI7vJEdJb8gD56NAj7HaxiH+SaFG6zpUFFGXj41qdu8gyphbrkBZ3m
UlW2+TJuxpKzgTLAQwKIhb1s3aMzMiBd2/CRWr+DNEr/GfHuwDyoFwNbvsPFvX+n
W2PvG/ZUP6UWJKL8blnD94mNkyWNA6x1BsMa/PABnWvlFtXC/AtoXaxOBvx4NBQp
MBnpkoCjXIq+Bi4Juzn+JtuDmatDoAo8+ZdfGW6zcgfRj7daVZhZcpiSYH0BS6bc
cRtpJ2mrR3aDgWuqQCIFhuSaStDqaw==
=SfSQ
-----END PGP SIGNATURE-----

--Sig_/q.NHokfwG8o5oNYogd0b7kn--
