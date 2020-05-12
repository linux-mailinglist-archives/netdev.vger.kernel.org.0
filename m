Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D3E1CEB76
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgELDa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:30:57 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:33765 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728708AbgELDa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 23:30:57 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49Ljxn2RTMz9sSr;
        Tue, 12 May 2020 13:30:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1589254254;
        bh=FphsOl3KgUXiT3QcYA5xL+rsNqjxWWtwhaXiLT+4PTM=;
        h=Date:From:To:Cc:Subject:From;
        b=M/8EZGHnX4NjCx2RZE+LjXi4DfcJ70425RYXyichnh+rApAkZ5gO8HLzfEKmkVW44
         KAam3iTvT7TVIBSw7zG/CRQ3cVFzAIXsl2fuJhcATC7xhWIsL5LTCz+4IftGrmFC0k
         BIUdgbrHQEaYv2uDuWWo0z+afBqnp0BpTTjOCQkcvFLfjfJvvj3adi/I07VqkdwjBB
         /OHSv1w18mwY+3mEulLE07J2WJoxS5VlSa8++ckAi4oZWkpxzzaazqEfmjIeXt50RQ
         hQXUw4hX3cijerTYcSpLocLWQLdIcYiG8g5+WHzutdCJbNMLSGzkyQSmeEolOxZpBh
         ncYdPFRNYKFMg==
Date:   Tue, 12 May 2020 13:30:51 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Luo bin <luobin9@huawei.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200512133051.7d740613@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/T=S4n1j5VzSFQ5DwcovfOOZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/T=S4n1j5VzSFQ5DwcovfOOZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
  drivers/net/ethernet/huawei/hinic/hinic_main.c

between commit:

  e8a1b0efd632 ("hinic: fix a bug of ndo_stop")

from the net tree and commit:

  7dd29ee12865 ("hinic: add sriov feature support")

from the net-next tree.

I fixed it up (I think, see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
index 992908e6eebf,eef855f11a01..000000000000
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@@ -358,12 -353,13 +358,16 @@@ int hinic_msg_to_mgmt(struct hinic_pf_t
  		return -EINVAL;
  	}
 =20
 +	if (cmd =3D=3D HINIC_PORT_CMD_SET_FUNC_STATE)
 +		timeout =3D SET_FUNC_PORT_MGMT_TIMEOUT;
 +
- 	return msg_to_mgmt_sync(pf_to_mgmt, mod, cmd, buf_in, in_size,
+ 	if (HINIC_IS_VF(hwif))
+ 		return hinic_mbox_to_pf(pf_to_mgmt->hwdev, mod, cmd, buf_in,
+ 					in_size, buf_out, out_size, 0);
+ 	else
+ 		return msg_to_mgmt_sync(pf_to_mgmt, mod, cmd, buf_in, in_size,
  				buf_out, out_size, MGMT_DIRECT_SEND,
 -				MSG_NOT_RESP);
 +				MSG_NOT_RESP, timeout);
  }
 =20
  /**
diff --cc drivers/net/ethernet/huawei/hinic/hinic_main.c
index 63b92f6cc856,3d6569d7bac8..000000000000
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@@ -496,9 -501,23 +500,12 @@@ static int hinic_close(struct net_devic
 =20
  	up(&nic_dev->mgmt_lock);
 =20
+ 	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
+ 		hinic_notify_all_vfs_link_changed(nic_dev->hwdev, 0);
+=20
 -	err =3D hinic_port_set_func_state(nic_dev, HINIC_FUNC_PORT_DISABLE);
 -	if (err) {
 -		netif_err(nic_dev, drv, netdev,
 -			  "Failed to set func port state\n");
 -		nic_dev->flags |=3D (flags & HINIC_INTF_UP);
 -		return err;
 -	}
 +	hinic_port_set_state(nic_dev, HINIC_PORT_DISABLE);
 =20
 -	err =3D hinic_port_set_state(nic_dev, HINIC_PORT_DISABLE);
 -	if (err) {
 -		netif_err(nic_dev, drv, netdev, "Failed to set port state\n");
 -		nic_dev->flags |=3D (flags & HINIC_INTF_UP);
 -		return err;
 -	}
 +	hinic_port_set_func_state(nic_dev, HINIC_FUNC_PORT_DISABLE);
 =20
  	if (nic_dev->flags & HINIC_RSS_ENABLE) {
  		hinic_rss_deinit(nic_dev);

--Sig_/T=S4n1j5VzSFQ5DwcovfOOZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl66GGsACgkQAVBC80lX
0GzUqgf9H210eMf2pTEcnhuuNCdOcz21Jmkbxx328d6TL4M1B2TKjy5hS5395pvd
cZufyzhAsGUMproWW5Zl1rPwVZWBfZ17RXV5/jorpztwwLNBwOUwUduNr9EiKVKc
/ubchtpGaPHrX1RfUEKL8qgpiZTVLMuwfLjEjUpWTdJoqCMD7/YrOKWFoeh0biAt
M6NJ2FU2CfXCWbqTE7Kn/Rj0C/wqG5pOF/143ejziCT5poqIc6yhBgj1SGieFOxz
3nRkw/whTlg1OPKJJt73r3oyU/8fSDvP2Rl6FadUjgRvSvFePVg+NbpViDXfBiOT
orTC2vrS0VcIud3ihZFGa7gS/MBaQQ==
=+OCm
-----END PGP SIGNATURE-----

--Sig_/T=S4n1j5VzSFQ5DwcovfOOZ--
