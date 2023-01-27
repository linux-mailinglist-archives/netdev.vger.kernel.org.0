Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5F967DB5A
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 02:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbjA0Bkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 20:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjA0Bkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 20:40:31 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF7F2BF06;
        Thu, 26 Jan 2023 17:40:30 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P30dP71YXz4xHV;
        Fri, 27 Jan 2023 12:40:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1674783626;
        bh=PLtF02aVJ+GCU7siqAV3NJZdF9KV0wnZTg3eFmVMFrc=;
        h=Date:From:To:Cc:Subject:From;
        b=Ki+2DIaGGUqdXDH653sqZRBuSBqMxMjNjtz8qVDeoLCCc/bcDCEWk2aCociLZap6M
         4Lbsy2RCobm/aE2BmLK0W/eWKR95wk+EoDfesIauVBjpVpLKGrqeZrZmOnw3sNuMml
         /gt2OBcth9IZOuMts6aCicdG8sffUmirVZ8syTYasyPZr83e20p7Dzt8H7SJnAkF+I
         62azNd5LzKosDn0oWxuAGO1yWI3YUuiFHVoayyRTtGoBwG1JutMLuVdKoD88AiXyKy
         bJ3XuiDe91gXTFGye+53VZmsznb1AsjpBABRjIOE9HJ7q9AK105s5mZGwd0JYm1Dv4
         ARUI5hx5JeUSA==
Date:   Fri, 27 Jan 2023 12:40:25 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230127124025.0dacef40@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/jv1Dzu7Dkr.uT/eDcU+9g8W";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/jv1Dzu7Dkr.uT/eDcU+9g8W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/intel/ice/ice_main.c

between commit:

  418e53401e47 ("ice: move devlink port creation/deletion")

from the net tree and commit:

  643ef23bd9dd ("ice: Introduce local var for readability")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/ethernet/intel/ice/ice_main.c
index 237ede2cffb0,cb870da5c317..000000000000
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@@ -5090,8 -5083,7 +5091,8 @@@ static void ice_remove(struct pci_dev *
  		ice_remove_arfs(pf);
  	ice_setup_mc_magic_wake(pf);
  	ice_vsi_release_all(pf);
- 	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
+ 	mutex_destroy(&hw->fdir_fltr_lock);
 +	ice_devlink_destroy_pf_port(pf);
  	ice_set_wake(pf);
  	ice_free_irq_msix_misc(pf);
  	ice_for_each_vsi(pf, i) {

--Sig_/jv1Dzu7Dkr.uT/eDcU+9g8W
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPTK4kACgkQAVBC80lX
0GwAgQf+Pd46a0WfoU+dZxCnIHLSz/IOFmT+5lFUfDX8BEJ0rYOSZIgT9DXpgH5E
RO/1PcJkHkcxISxjLDtPU19N0AefmC8z99EsJ1rkXQFLWBlOVhvvolv5sT3nk1Cc
lD//6T4xY8yCnuGO/aS/H+476vckAoTj3cRgBMzgDzxrOULglLCrT2He1LVF92kA
WFX53LEKc9CoFmKZ54FmrV/Ez3irQI7nN8n3eT1ejWj9NqtBruCtRxLP7Ki6OU9Y
QLVFX5OaxBNQIytsbkdGQmamOKtwWZMFc4iSHe4dELa5guUeMfF+ZPRZTeR6xmOO
GVeZhgUIWFTj99IZXTpUDNSbXTko8A==
=ZZFN
-----END PGP SIGNATURE-----

--Sig_/jv1Dzu7Dkr.uT/eDcU+9g8W--
