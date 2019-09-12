Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30C7B12A3
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 18:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732578AbfILQTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 12:19:42 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50069 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbfILQTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 12:19:41 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46TkVs6hnCz9s4Y;
        Fri, 13 Sep 2019 02:19:32 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1568305178;
        bh=/2FPKAkeV/GqFBXmtJHyD6OTSwjC5DdIye1DxxJG+bU=;
        h=Date:From:To:Cc:Subject:From;
        b=dlAyYQmu6QIeoRsXsY2UiWSCjojsWozTt+7JZk9Qz5peGumGPklYw5WM8Ecujlegj
         GHkdCoaNsKHR6bbWJlh/cN4OIR0wVNkfr+aMCkd8nlZlwASLViCy8Ub+NlmvgddqpG
         JUs1qETiufPI9b30kMF/bbDy0z7dQBCHp14glZG6BsczknnOjOUkjYlRszMQRivjKC
         5WvKv6Zi0Sr4yxB6I8MhYZTo+QfmvPMMFnR3c/sUyXX/WbANWfULBArjWvcW7q9aMC
         DAUaW7WxcMe20QjjeOkHkVy/NRBqN+RRo0IM/JKxmvNv3J7Ffl7T2OCIyWBymNa4u6
         P2qg5sM0mI4oA==
Date:   Fri, 13 Sep 2019 02:19:34 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Alex Lu <alex_lu@realsil.com.cn>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20190913021934.42fc0fea@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/DHejPnzil1gYOiEe_UgS/SN";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/DHejPnzil1gYOiEe_UgS/SN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/bluetooth/btusb.c

between commit:

  1ffdb51f28e8 ("Revert "Bluetooth: btusb: driver to enable the usb-wakeup =
feature"")

from the net tree and commit:

  9e45524a0111 ("Bluetooth: btusb: Fix suspend issue for Realtek devices")

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

diff --cc drivers/bluetooth/btusb.c
index ba4149054304,ed455de598ea..000000000000
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@@ -1173,7 -1201,18 +1204,14 @@@ static int btusb_open(struct hci_dev *h
  	}
 =20
  	data->intf->needs_remote_wakeup =3D 1;
 -	/* device specific wakeup source enabled and required for USB
 -	 * remote wakeup while host is suspended
 -	 */
 -	device_wakeup_enable(&data->udev->dev);
 =20
+ 	/* Disable device remote wakeup when host is suspended
+ 	 * For Realtek chips, global suspend without
+ 	 * SET_FEATURE (DEVICE_REMOTE_WAKEUP) can save more power in device.
+ 	 */
+ 	if (test_bit(BTUSB_WAKEUP_DISABLE, &data->flags))
+ 		device_wakeup_disable(&data->udev->dev);
+=20
  	if (test_and_set_bit(BTUSB_INTR_RUNNING, &data->flags))
  		goto done;
 =20
@@@ -1237,6 -1276,12 +1275,11 @@@ static int btusb_close(struct hci_dev *
  		goto failed;
 =20
  	data->intf->needs_remote_wakeup =3D 0;
+=20
+ 	/* Enable remote wake up for auto-suspend */
+ 	if (test_bit(BTUSB_WAKEUP_DISABLE, &data->flags))
+ 		data->intf->needs_remote_wakeup =3D 1;
+=20
 -	device_wakeup_disable(&data->udev->dev);
  	usb_autopm_put_interface(data->intf);
 =20
  failed:

--Sig_/DHejPnzil1gYOiEe_UgS/SN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl16cBYACgkQAVBC80lX
0Gwr6Qf/bnj3thivjfhtUCKcq2fFSjVC8yiV3r3cvRvfQdp78EXm2gDvhuDFjZn8
0bdmo4QfuAmiITwGeV8TFGqADbKoyc3hzBJO5VKx71pUKENtpXss6LbBO3KzsnG3
Xac2cninNVptOlR1HQ3VmRRITnQOKOejWw0omCaLJtqX8juJLw4+RzKRwWz+/1Kl
vIHHxNZiHDGd7mK/UVP7j7JoekOqyV0hTkyeY6YgQP4Q8llnRxEHPTcTNMbvKgsf
zUop+uROxGQJzu5zzBCvywIzcMIyCqyH6r5TE4jc3NGmK/dcbiTqHf6ms51Qmy4s
NE1yNNnAAt9gdYIzbezZJzeQOTm0ug==
=tcmK
-----END PGP SIGNATURE-----

--Sig_/DHejPnzil1gYOiEe_UgS/SN--
