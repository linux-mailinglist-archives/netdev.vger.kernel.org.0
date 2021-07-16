Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197DB3CB128
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 05:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbhGPDkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 23:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhGPDki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 23:40:38 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA87C06175F;
        Thu, 15 Jul 2021 20:37:43 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GQxl72GCdz9sWq;
        Fri, 16 Jul 2021 13:37:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1626406660;
        bh=c/+0RngVoUmF3ZMyOrfkI3149vXfqWPL3fp4p18FB4Q=;
        h=Date:From:To:Cc:Subject:From;
        b=XKeRkGhOUnue6xIiT7k4E50bqBiIRxuAio39mHEAd5PGIPuuWSp40i83zoQLgpb1o
         ViY5ObBXh/yKnkLQ0jWj/Y6lySON1rt7om/4CwjCrowxZ4sQ/nqBIbykXf1cL0iF9s
         0Eqvh1IUL2b8azQUyUTunHrvhfKqacfu852ilXez+Z/kNsgrcxUyuyfEtlmVMkOqAn
         Y1Jn3qEfniKq1KcJneiENbMeGLvnnk8V2VyXFUDF+zZmSUrP1W6qY7fYERvFoZTgJV
         Zr2AkFTFk2D39cbYX6LiJNKqqqHzK50NyVVK5Wx//p9GyER4UaNTHz5kjtmCmCbaOG
         DHzuXcHSbld1g==
Date:   Fri, 16 Jul 2021 13:37:38 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Richard Laing <richard.laing@alliedtelesis.co.nz>
Subject: linux-next: manual merge of the mhi tree with the net-next tree
Message-ID: <20210716133738.0d163701@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/L_qhwSo=RcXGM8bDaEoaq=F";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/L_qhwSo=RcXGM8bDaEoaq=F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mhi tree got a conflict in:

  drivers/bus/mhi/pci_generic.c

between commit:

  5c2c85315948 ("bus: mhi: pci-generic: configurable network interface MRU")

from the net-next tree and commit:

  156ffb7fb7eb ("bus: mhi: pci_generic: Apply no-op for wake using sideband=
 wake boolean")

from the mhi tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/bus/mhi/pci_generic.c
index 19413daa0917,8bc6149249e3..000000000000
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@@ -32,7 -32,8 +32,9 @@@
   * @edl: emergency download mode firmware path (if any)
   * @bar_num: PCI base address register to use for MHI MMIO register space
   * @dma_data_width: DMA transfer word size (32 or 64 bits)
 + * @mru_default: default MRU size for MBIM network packets
+  * @sideband_wake: Devices using dedicated sideband GPIO for wakeup inste=
ad
+  *		   of inband wake support (such as sdx24)
   */
  struct mhi_pci_dev_info {
  	const struct mhi_controller_config *config;
@@@ -41,7 -42,7 +43,8 @@@
  	const char *edl;
  	unsigned int bar_num;
  	unsigned int dma_data_width;
 +	unsigned int mru_default;
+ 	bool sideband_wake;
  };
 =20
  #define MHI_CHANNEL_CONFIG_UL(ch_num, ch_name, el_count, ev_ring) \
@@@ -254,7 -256,7 +258,8 @@@ static const struct mhi_pci_dev_info mh
  	.config =3D &modem_qcom_v1_mhiv_config,
  	.bar_num =3D MHI_PCI_DEFAULT_BAR_NUM,
  	.dma_data_width =3D 32,
 +	.mru_default =3D 32768
+ 	.sideband_wake =3D false,
  };
 =20
  static const struct mhi_pci_dev_info mhi_qcom_sdx24_info =3D {
@@@ -643,11 -686,13 +689,14 @@@ static int mhi_pci_probe(struct pci_de
  	mhi_cntrl->status_cb =3D mhi_pci_status_cb;
  	mhi_cntrl->runtime_get =3D mhi_pci_runtime_get;
  	mhi_cntrl->runtime_put =3D mhi_pci_runtime_put;
- 	mhi_cntrl->wake_get =3D mhi_pci_wake_get_nop;
- 	mhi_cntrl->wake_put =3D mhi_pci_wake_put_nop;
- 	mhi_cntrl->wake_toggle =3D mhi_pci_wake_toggle_nop;
 +	mhi_cntrl->mru =3D info->mru_default;
 =20
+ 	if (info->sideband_wake) {
+ 		mhi_cntrl->wake_get =3D mhi_pci_wake_get_nop;
+ 		mhi_cntrl->wake_put =3D mhi_pci_wake_put_nop;
+ 		mhi_cntrl->wake_toggle =3D mhi_pci_wake_toggle_nop;
+ 	}
+=20
  	err =3D mhi_pci_claim(mhi_cntrl, info->bar_num, DMA_BIT_MASK(info->dma_d=
ata_width));
  	if (err)
  		return err;

--Sig_/L_qhwSo=RcXGM8bDaEoaq=F
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDw/wIACgkQAVBC80lX
0GxvrwgAhHs+4N4xz7OCN/fwodR13D40FT3TthtaQmP9kl/G644J+8n/jjJ1kh3K
59/z7+EwkIDIquM6sB3pk8mCLTLaRwqbGCJcceAQwmCEVuyBqDgQJjzW2vCcGSsK
2jVj6dTpojPU4opGijTtB1qwQ8fz0HbpUvXfuUWGaM/USXmWHsORQJUVZG60zvMg
yZC6uSMTuEIdQEPdzlfLH6Gd+jp9Cwrzt8zI8wFbdDcDfkew7yqbJxFSh3TMrEuQ
jeLFGoOW9a01t0oAEPAxEBWdcc7ZLnFchAxeeAbjiVZq0RSwxJR9+VOL27h837L2
gysI3uDmQS9rc2WtURw1FjEmWIzE1g==
=wHNW
-----END PGP SIGNATURE-----

--Sig_/L_qhwSo=RcXGM8bDaEoaq=F--
