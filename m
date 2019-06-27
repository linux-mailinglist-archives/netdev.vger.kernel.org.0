Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FECB579F3
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 05:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfF0D0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 23:26:53 -0400
Received: from ozlabs.org ([203.11.71.1]:54321 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbfF0D0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 23:26:52 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45Z50m5DVdz9s8m;
        Thu, 27 Jun 2019 13:26:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561606008;
        bh=fioyDfZ6iV0lAjh6dnzcxDZgGjkSbI2ctnoo5TEIlmQ=;
        h=Date:From:To:Cc:Subject:From;
        b=erGJC9T8J2ZWaEWagIgtzGZlCz7cUj/4cEzUxNHmcGioDAs7YTjTCv8haIx0RwGjL
         gPTSDboJSnYzPLH1KrUZYEQoGJwaGwv0WkGCHrw63wRB6BOeZ4R8DO4xX7qibL3QzL
         Vm1M7KFV7m+oQy2GNGHk5Gyv3vDztwNRxquK8HiQjhAxWcnHsgwEZHq9vFo/XChqJG
         FwSvuU+TWGyf7a1pyy1hMHn0iKWqPEK4nqn5fBwvch05f1LQawAzcfyGU6EkXN0Lje
         DFKqxl9RNhRJVy0ue1qRO7yvthtncZ+8q71s6o10cXuwF6JcYqpoOcla8qe4Rj3GVZ
         6KyZKgNeNa2Zw==
Date:   Thu, 27 Jun 2019 13:26:46 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20190627132646.30cd8f93@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/HiQ912kM5wP9j1s8erTIXTn"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/HiQ912kM5wP9j1s8erTIXTn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/ipv4/ip_output.c

between commit:

  5b18f1289808 ("ipv4: reset rt_iif for recirculated mcast/bcast out pkts")

from the net tree and commit:

  956fe2190820 ("bpf: Update BPF_CGROUP_RUN_PROG_INET_EGRESS calls")

from the net-next tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
This is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/ipv4/ip_output.c
index 8c2ec35b6512,cdd6c3418b9e..000000000000
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@@ -322,7 -330,12 +331,26 @@@ static int ip_mc_finish_output(struct n
  	int ret;
 =20
  	ret =3D BPF_CGROUP_RUN_PROG_INET_EGRESS(sk, skb);
- 	if (ret) {
+ 	switch (ret) {
++	case NET_XMIT_SUCCESS:
++	case NET_XMIT_CN:
++		/* Reset rt_iif so that inet_iif() will return skb->skb_iif.
++		 * Setting this to non-zero causes ipi_ifindex in in_pktinfo
++		 * to be overwritten, see ipv4_pktinfo_prepare().
++		 */
++		new_rt =3D rt_dst_clone(net->loopback_dev, skb_rtable(skb));
++		if (new_rt) {
++			new_rt->rt_iif =3D 0;
++			skb_dst_drop(skb);
++			skb_dst_set(skb, &new_rt->dst);
++		}
++	}
++	switch (ret) {
+ 	case NET_XMIT_SUCCESS:
+ 		return dev_loopback_xmit(net, sk, skb);
+ 	case NET_XMIT_CN:
+ 		return dev_loopback_xmit(net, sk, skb) ? : ret;
+ 	default:
  		kfree_skb(skb);
  		return ret;
  	}

--Sig_/HiQ912kM5wP9j1s8erTIXTn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0UN3YACgkQAVBC80lX
0GysGAf9EHNugxIFKbA7mXh4q7glaJkXl2hDvhz8BuqdzVgbYPtn1qSHo4QuUjNk
ot2ldjtM7rANOarTu+B8ercn6MMKTmQv92/ya30mSen+1pgmpnIS8TKs7DecKFIv
OhzVpyUSPuU7HF+efaFO4rMIKW+kW1aoeiNBrEE1ojUw/DBL6UDaaEwaiptRpoiA
elYKe56bqkPH6/DWUp7bJVfCTrVaq0ypps/0Y3tBwiFkFr0j8tZAg2f0x4iae+yb
bDosnmlzCZWF7GNR2v7hR2ZCYESn70mhJOsDsWVsQXln7ltz18LX1pQH/J0GWa3T
1e7JnXkfUPtPkkbESHgB9Y6s8ttvcQ==
=cV+D
-----END PGP SIGNATURE-----

--Sig_/HiQ912kM5wP9j1s8erTIXTn--
