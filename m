Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B903847D87
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 10:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfFQIrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 04:47:53 -0400
Received: from ozlabs.org ([203.11.71.1]:37889 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbfFQIrx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 04:47:53 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45S4bm4m4dz9sBr;
        Mon, 17 Jun 2019 18:47:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1560761270;
        bh=X7PpLpe30RNOPYo/shn55CyBL4b5EtCNqA4N6iz5I0c=;
        h=Date:From:To:Cc:Subject:From;
        b=MIys2p1bth7aJCVDjD8gPb/+n9+1uMqPSvxqjLbMkrm5nL5F8+OMnoLeB2oJhYL8U
         VJiCBx/vb8Yv0bOZc1WkoLJCaVihHK4E4EbF/bMapImxsLF+lQrXBiiPs0LEczdWNF
         vFweaKHvJuxd0VdCBnQEB6Oa7SdAMF4tIQ881uumv20dorL4gTW/i8oov4+Gi7yCcQ
         HwRLG3Ly/hoK6MmWAo4olu5pI3O+aIFNpqZxAWM6S94pXYpC1dBxHhsUPIUjiRE10Y
         f7kug+zPMPTDFvDY04CC/2S81JXy/THt9Y65PNUuvijhxTK3WoAYdQ02GvA1gSvJm3
         hHWLaLnaa43NQ==
Date:   Mon, 17 Jun 2019 18:47:46 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: linux-next: manual merge of the akpm tree with the net and net-next
 trees
Message-ID: <20190617184746.252a2d16@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/CuFUfqb.NIFNy_3G/dcI0Uy"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/CuFUfqb.NIFNy_3G/dcI0Uy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm tree got conflicts in:

  net/ipv4/sysctl_net_ipv4.c
  kernel/sysctl.c

between commit:

  a8e11e5c5611 ("sysctl: define proc_do_static_key()")

from the net tree, commit:

  363887a2cdfe ("ipv4: Support multipath hashing on inner IP pkts for GRE t=
unnel")

from the net-next tree and patch:

  "proc/sysctl: add shared variables for range check"

from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc kernel/sysctl.c
index d2a7398a5543,f9c1a8390d95..000000000000
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@@ -3367,21 -3371,13 +3364,21 @@@ int proc_do_large_bitmap(struct ctl_tab
 =20
  #endif /* CONFIG_PROC_SYSCTL */
 =20
 -#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_SYSCTL)
 -static int proc_dointvec_minmax_bpf_stats(struct ctl_table *table, int wr=
ite,
 -					  void __user *buffer, size_t *lenp,
 -					  loff_t *ppos)
 +#if defined(CONFIG_SYSCTL)
 +int proc_do_static_key(struct ctl_table *table, int write,
 +		       void __user *buffer, size_t *lenp,
 +		       loff_t *ppos)
  {
 -	int ret, bpf_stats =3D *(int *)table->data;
 -	struct ctl_table tmp =3D *table;
 +	struct static_key *key =3D (struct static_key *)table->data;
 +	static DEFINE_MUTEX(static_key_mutex);
 +	int val, ret;
 +	struct ctl_table tmp =3D {
 +		.data   =3D &val,
 +		.maxlen =3D sizeof(val),
 +		.mode   =3D table->mode,
- 		.extra1 =3D &zero,
- 		.extra2 =3D &one,
++		.extra1 =3D SYSCTL_ZERO,
++		.extra2 =3D SYSCTL_ONE,
 +	};
 =20
  	if (write && !capable(CAP_SYS_ADMIN))
  		return -EPERM;
diff --cc net/ipv4/sysctl_net_ipv4.c
index 356e8cf6f78d,cf5b4462fd42..000000000000
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@@ -1019,8 -1005,8 +1017,8 @@@ static struct ctl_table ipv4_net_table[
  		.maxlen		=3D sizeof(int),
  		.mode		=3D 0644,
  		.proc_handler	=3D proc_fib_multipath_hash_policy,
- 		.extra1		=3D &zero,
+ 		.extra1		=3D SYSCTL_ZERO,
 -		.extra2		=3D SYSCTL_ONE,
 +		.extra2		=3D &two,
  	},
  #endif
  	{

--Sig_/CuFUfqb.NIFNy_3G/dcI0Uy
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0HU7IACgkQAVBC80lX
0Gx3xwf+M/j6l0SFxF7830+VeATNkI/HK4vALdHEm+RloOGRF9TMY7e97nBDFWoE
qHzpA3nuiyzaVG6AnLp+m4DJ+aILzJlidgnaLzn28IumV7K3qrmAamNubnDl5Xic
aWMOuuaeMoRQM6JPGYxkAhsz/X00c/dzYH0pMGtwIpTA1/NrQwA+xBZhZPxGF9jy
CGbj759+wzxWy3Ad9FwobWwYUmk/U53TDDOWTDJQTBDwpXytvqZbLGTY/X8VpXNy
9V5oNOQaR/BuyGOkRWPPEuomWtV9GTiFfOMbuG5Gxx0JxqS9Mim/gA2eKNvsHNlL
ugULi4MQXWtUvSaAuDIv5PuNtycVTw==
=DWm3
-----END PGP SIGNATURE-----

--Sig_/CuFUfqb.NIFNy_3G/dcI0Uy--
