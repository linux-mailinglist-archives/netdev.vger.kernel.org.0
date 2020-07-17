Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A241E224407
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgGQTNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbgGQTNE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 15:13:04 -0400
Received: from localhost (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC4CD2064C;
        Fri, 17 Jul 2020 19:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595013184;
        bh=wAykMgVs1HLRv17sBu9pt0MpmQPM85Wg6tWWls25qTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WzvBvnLjB4PJfPfCmT5UGbJFmxzTD6mNzeK5xXsvzz7dSHAlgb3Zp2gtLvmFlvBx+
         po0Z7bAeWI/5P9pkUfOQF3U8uEjlfGeQEk4xk9xbP0yKDoeGLhMdX/ooyufyMoORY0
         lBKkM4Gd1Mfy4bWELEh9DZ+fu/LpLvdkgq3q3lS8=
Date:   Fri, 17 Jul 2020 21:12:59 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH v7 bpf-next 0/9] introduce support for XDP programs in
 CPUMAP
Message-ID: <20200717191259.GB633625@localhost.localdomain>
References: <cover.1594734381.git.lorenzo@kernel.org>
 <20200717120013.0926a74e@toad>
 <20200717110136.GA1683270@localhost.localdomain>
 <20200717171333.3fe979e6@toad>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <20200717171333.3fe979e6@toad>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 17 Jul 2020 13:01:36 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20

[...]

>=20
> HTH,
> -jkbs

Hi Jakub,

can you please test the patch below when you have some free cycles? It fixes
the issue in my setup.

Regards,
Lorenzo

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 4c95d0615ca2..f1c46529929b 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -453,24 +453,27 @@ __cpu_map_entry_alloc(struct bpf_cpumap_val *value, u=
32 cpu, int map_id)
 	rcpu->map_id =3D map_id;
 	rcpu->value.qsize  =3D value->qsize;
=20
+	if (fd > 0 && __cpu_map_load_bpf_program(rcpu, fd))
+		goto free_ptr_ring;
+
 	/* Setup kthread */
 	rcpu->kthread =3D kthread_create_on_node(cpu_map_kthread_run, rcpu, numa,
 					       "cpumap/%d/map:%d", cpu, map_id);
 	if (IS_ERR(rcpu->kthread))
-		goto free_ptr_ring;
+		goto free_prog;
=20
 	get_cpu_map_entry(rcpu); /* 1-refcnt for being in cmap->cpu_map[] */
 	get_cpu_map_entry(rcpu); /* 1-refcnt for kthread */
=20
-	if (fd > 0 && __cpu_map_load_bpf_program(rcpu, fd))
-		goto free_ptr_ring;
-
 	/* Make sure kthread runs on a single CPU */
 	kthread_bind(rcpu->kthread, cpu);
 	wake_up_process(rcpu->kthread);
=20
 	return rcpu;
=20
+free_prog:
+	if (rcpu->prog)
+		bpf_prog_put(rcpu->prog);
 free_ptr_ring:
 	ptr_ring_cleanup(rcpu->queue, NULL);
 free_queue:

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXxH4OAAKCRA6cBh0uS2t
rIv4AP44ZzwGIpA8U8pNJhsgDZ3Av/tSe3uXND4ijzBducFaugD+M+R2XODovdyv
7Qq68XVFVf7OwZy8+PIsBbvnL3ideQw=
=kmKz
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
