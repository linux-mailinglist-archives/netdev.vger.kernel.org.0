Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB327421B51
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 02:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhJEA6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 20:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhJEA6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 20:58:32 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36560C061745;
        Mon,  4 Oct 2021 17:56:42 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HNfKz5qMrz4xbQ;
        Tue,  5 Oct 2021 11:56:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1633395399;
        bh=BJx3d+iMRLmlvADPU/KIuamhxlcDbXGaAkEgkznrmnw=;
        h=Date:From:To:Cc:Subject:From;
        b=O1lgCBw6gGiKJ60IyHeVNbhbDDHQh88XDD8SaeE79L4d4Rkd9bLV9i2zKXLdxqq74
         8XLfukLKG7MV8FyYyvgrHk6m3bboe56iRgBUJTzLeU6p3F4fSITyO94Sj9MK5ShJNj
         QZzqJdTKgEoIXSuzWii8/F4RQzgCNFu093+f7j/hXmhA0KK6OMmnmaPETqLwDg86QN
         GFCmPpIke67ism2oYTzjfXe4V8+D7rfxDN30yBTtVrCgLUnsdhTY7b0iEO7qAMKzH1
         DZ3whukvb9BzrMzAvlvOAb0MeDeCTC7rxnwytiWsG9wB4RVtG86DkYZgYhQMkmm1TK
         2gpaVZ1rp5AfQ==
Date:   Tue, 5 Oct 2021 11:56:37 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20211005115637.3eacc45f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6hcYF3hGO.iGVsbj4.nP4M6";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/6hcYF3hGO.iGVsbj4.nP4M6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/net/ethernet/ibm/ehea/ehea_main.c: In function 'ehea_setup_single_p=
ort':
drivers/net/ethernet/ibm/ehea/ehea_main.c:2989:23: error: passing argument =
2 of 'eth_hw_addr_set' from incompatible pointer type [-Werror=3Dincompatib=
le-pointer-types]
 2989 |  eth_hw_addr_set(dev, &port->mac_addr);
      |                       ^~~~~~~~~~~~~~~
      |                       |
      |                       u64 * {aka long long unsigned int *}
In file included from include/linux/if_vlan.h:11,
                 from include/linux/filter.h:19,
                 from include/net/sock.h:59,
                 from include/linux/tcp.h:19,
                 from drivers/net/ethernet/ibm/ehea/ehea_main.c:20:
include/linux/etherdevice.h:309:70: note: expected 'const u8 *' {aka 'const=
 unsigned char *'} but argument is of type 'u64 *' {aka 'long long unsigned=
 int *'}
  309 | static inline void eth_hw_addr_set(struct net_device *dev, const u8=
 *addr)
      |                                                            ~~~~~~~~=
~~^~~~
cc1: some warnings being treated as errors

Caused by commit

  a96d317fb1a3 ("ethernet: use eth_hw_addr_set()")

I have used the net-next tree from next-20211001 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/6hcYF3hGO.iGVsbj4.nP4M6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFbosUACgkQAVBC80lX
0GxRNgf9HU6AmdI4mMfxpZfYBUFrivixE9iXM+3wljKNkRnhdNLvsu5ZuR8MD0yA
5BoFI2s/ovXngR7f3p3NJ3dhcllbzncRg8xaXipH+tCNXMx+CAmlGiJcAg0hncPW
1cHxgY2Mv+cmPNZF+Z6XkHFq0ExKG+A8KseAvO2e+UMWc7VPapfmlHDUx3llrIh9
H7aYZKHQLS5yNQRYyES7se1FA/CA9Wfb1DM5uvlTlZB26dG1uUWMJgO8baUoyaFN
x/dlDha6A2Kg8D6ZEFJTfx89pTbknCrXiWDBnfINpoip3j6l9umodVwA0VjlziPw
TxwVI/51oIiZYBoCLBf3MgQ7DTF/EA==
=7frF
-----END PGP SIGNATURE-----

--Sig_/6hcYF3hGO.iGVsbj4.nP4M6--
