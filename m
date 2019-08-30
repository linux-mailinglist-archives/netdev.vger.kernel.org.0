Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41306A2E14
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 06:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfH3ETQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 00:19:16 -0400
Received: from ozlabs.org ([203.11.71.1]:39567 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbfH3ETQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 00:19:16 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46KR7h2fpxz9sN6;
        Fri, 30 Aug 2019 14:19:11 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1567138752;
        bh=Y28Rt2oHTcK3rAJXH2EwjpFaRwubHNhkaQ77jcR6V2M=;
        h=Date:From:To:Cc:Subject:From;
        b=TCO8AFFb3Js4ZpiaaRix1u3cV4IboctQreVNI5hQlP4K8/o+1ajakWCJVFdbHC8BF
         yWx3qY/bNEi4OzgOdK19jy6SF4InWSXZQ1zYiBEV7XUfDicb3vGhCJSUogKmJXKzoe
         uWVQg9YSKWFKPeAoz8dXGghpOVklfcvzLj5jIjk1q3NmYT6XmhmIP/ng+BHxIHTdT+
         1rPTY+J3yYnPGH+C3LU1rW9gmLvIjaf8A0yH5fMpxYKrxNKG/fpoMOJzdzCnKz2Uci
         Lxq6WHkc/wTTac8LEBaNVUqmFWdAzn3tmwlHxzJOw+ox7kONMHYUKvPcN/O2qVWWAX
         Zlueh1hrGxhqQ==
Date:   Fri, 30 Aug 2019 14:19:09 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20190830141909.5f15665b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/wwgfcYaOG4hTzMAi=gguok2";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/wwgfcYaOG4hTzMAi=gguok2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/usb/r8152.c

between commits:

  49d4b14113ca ("Revert "r8152: napi hangup fix after disconnect"")
  973dc6cfc0e2 ("r8152: remove calling netif_napi_del")

from the net tree and commit:

  d2187f8e4454 ("r8152: divide the tx and rx bottom functions")

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

diff --cc drivers/net/usb/r8152.c
index 04137ac373b0,c6fa0c17c13d..000000000000
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@@ -4021,7 -4214,9 +4214,8 @@@ static int rtl8152_close(struct net_dev
  #ifdef CONFIG_PM_SLEEP
  	unregister_pm_notifier(&tp->pm_notifier);
  #endif
+ 	tasklet_disable(&tp->tx_tl);
 -	if (!test_bit(RTL8152_UNPLUG, &tp->flags))
 -		napi_disable(&tp->napi);
 +	napi_disable(&tp->napi);
  	clear_bit(WORK_ENABLE, &tp->flags);
  	usb_kill_urb(tp->intr_urb);
  	cancel_delayed_work_sync(&tp->schedule);
@@@ -5352,6 -5604,8 +5603,7 @@@ static int rtl8152_probe(struct usb_int
  	return 0;
 =20
  out1:
 -	netif_napi_del(&tp->napi);
+ 	tasklet_kill(&tp->tx_tl);
  	usb_set_intfdata(intf, NULL);
  out:
  	free_netdev(netdev);
@@@ -5366,7 -5620,9 +5618,8 @@@ static void rtl8152_disconnect(struct u
  	if (tp) {
  		rtl_set_unplug(tp);
 =20
 -		netif_napi_del(&tp->napi);
  		unregister_netdev(tp->netdev);
+ 		tasklet_kill(&tp->tx_tl);
  		cancel_delayed_work_sync(&tp->hw_phy_work);
  		tp->rtl_ops.unload(tp);
  		free_netdev(tp->netdev);

--Sig_/wwgfcYaOG4hTzMAi=gguok2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1oo70ACgkQAVBC80lX
0GxS1wf+KE4PnrM0gqqjDBWhlcyXJPXnXkH95eZHgh675yq5rKVb8tNabUDa3RC4
kb24uCR7pb5jyzmciS5HOlKNiOvYhxlCcfwuBuDpAaD+FQwIkFOj2fbP45/+dSl9
M5vDzlXx9x7GBKgxumEBL8XuxMWk3EhVT5UcD/Kl9qTTYXrJbXSTz3/Dr5HODRFq
mBzaerKJhS4UkD7fWEOyR6QzUKOGMKgG2Nqobcccd3Bh4j/8r86MXMvrK0N8zcJ1
PW6zNA7vidxMU5A97v/arZgAF6L0KI1ERCusb/aZlkIfBT1cEf0TL7Cc55zovPnb
nsCHbQ1rvOfuTecdRL1H+17lw+De4Q==
=RD4p
-----END PGP SIGNATURE-----

--Sig_/wwgfcYaOG4hTzMAi=gguok2--
