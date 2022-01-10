Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90358488DF7
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbiAJBMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbiAJBML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:12:11 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4326C06173F;
        Sun,  9 Jan 2022 17:12:10 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JXG526KP9z4xdd;
        Mon, 10 Jan 2022 12:12:06 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1641777129;
        bh=+EEgq+InNwGoZQSeDBe5vynY7rMJF9rZjCwUWpyr6T4=;
        h=Date:From:To:Cc:Subject:From;
        b=l5B80r/2NpiXiHcetH/5zPuh7AjPfLKKsHHMUjA4rLHElGlu1cWF2D6TlWPqcsxFI
         gPEW2cFz4qIZ9165jA6MeP4p8SRL8gnTOpeH4NayuQMG65eSrMRswhTNN7Wa2iPjF7
         y6yl33tfb03TD5E9cfV+u2uNg24D3E4AZHzTJT+8pIMDHM+5PvuRdupD72ls6QGftG
         DcyZKWqudGwDB//ipJFgZqxVdKGEZL04lX8vp4bJ2EYLLesTVdgR2vy3bjsaI3SkPq
         24B+R6i18LT5YIL+UUMIOF7FeqZWTwm7vk+FyEweNhcXcWLqtKt+FK3x+EahJ/gO5e
         42ebDH9p51J+g==
Date:   Mon, 10 Jan 2022 12:12:05 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: linux-next: manual merge of the tip tree with the net-next tree
Message-ID: <20220110121205.1bf54032@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/9G=xNMZ2T_tZk4A5hv9ic5b";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/9G=xNMZ2T_tZk4A5hv9ic5b
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c

between commit:

  5256a46bf538 ("net/mlx5: Introduce control IRQ request API")
  30c6afa735db ("net/mlx5: Move affinity assignment into irq_request")

from the net-next tree and commits:

  7451e9ea8e20 ("net/mlx5: Use irq_set_affinity_and_hint()")
  0422fe2666ae ("Merge branch 'linus' into irq/core, to fix conflict")

from the tip tree.

I fixed it up (I think, see below) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 90fec0649ef5,fd7a671eda33..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@@ -236,10 -244,6 +236,10 @@@ struct mlx5_irq *mlx5_irq_alloc(struct=20
  		err =3D -ENOMEM;
  		goto err_cpumask;
  	}
 +	if (affinity) {
 +		cpumask_copy(irq->mask, affinity);
- 		irq_set_affinity_hint(irq->irqn, irq->mask);
++		irq_set_affinity_and_hint(irq->irqn, irq->mask);
 +	}
  	irq->pool =3D pool;
  	irq->refcount =3D 1;
  	irq->index =3D i;
@@@ -251,7 -255,6 +251,7 @@@
  	}
  	return irq;
  err_xa:
- 	irq_set_affinity_hint(irq->irqn, NULL);
++	irq_set_affinity_and_hint(irq->irqn, NULL);
  	free_cpumask_var(irq->mask);
  err_cpumask:
  	free_irq(irq->irqn, &irq->nh);

--Sig_/9G=xNMZ2T_tZk4A5hv9ic5b
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHbh+UACgkQAVBC80lX
0GzbOQf/fmez3TTY/hreb4bHbcNvGU91IBdl68jHtumY0ZbiDNBs2Q9aCWDBq1b9
NZBJzF1k7qW77L4efAkhwRxzJHmIlxqPTVJezmBA75OvwrKiDqll53nQiAvvlxA+
v3f0HbzxAAVZhHYYDdYwAsJN0Zy+4CWPMM+fcRw6Pvu2y0UzzdaOY5W8/lIVQ9li
lpMGUTdVuv74cr/E+otx9YOUYDJPPpp2iVh7LKbVjT8ohDJT8ZYHstHTY6jJSlYm
fPqfI2Ipkf+SLYzcemwyH1TjTxkVIho5jRI7bLuZdZrDF+C1x0AimXqjGTyEKhqp
+muNUnZdRL3y638+tRXNO6hoF5EeTw==
=feda
-----END PGP SIGNATURE-----

--Sig_/9G=xNMZ2T_tZk4A5hv9ic5b--
