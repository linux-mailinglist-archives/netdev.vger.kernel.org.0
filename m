Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BBC3FAFA3
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 03:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236149AbhH3B7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 21:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhH3B7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 21:59:20 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF32C061575;
        Sun, 29 Aug 2021 18:58:25 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GyYPq2DjCz9sWS;
        Mon, 30 Aug 2021 11:58:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1630288703;
        bh=kxlR1klsPZgGVM2D33mZhq1N/hW61SVezFJMuFy0JTY=;
        h=Date:From:To:Cc:Subject:From;
        b=lNJI9fcs/1UaY/y7sout5p/iZVZ1Wo2QO9dYPYKmK6Wg68hvGlZ+4co2BC0i3xpMz
         RIBera302KhYvY7C0b65RV7LeSlNtbm6UIFZRHJZBgDQtRJUYBS+JkPrf1lqGR+XZC
         OfWRUc1L23rwOqDNeh85q1LblyqOp1JVNHKXSp3Qf2p02mETpOINhnqJmeiK8sUjjY
         y7+MOAgmWjA8HSngOcU9LP7z4DM8KnZKVCh8DWE1RVHq2LUuoKs/M8GnfABcOqxuTp
         AxHPAlxLu0dmwY86tuyXrIXuE3gaD1GAL1sFcsQZTDMd9T3eZp2WH77p8o0COBDPT7
         Q4r9AyGRXIfsw==
Date:   Mon, 30 Aug 2021 11:58:22 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Peter Collingbourne <pcc@google.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210830115822.0821e249@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/UBWiXmiEq4xr_6CFk5SD7eZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/UBWiXmiEq4xr_6CFk5SD7eZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  include/linux/netdevice.h
  net/socket.c

between commit:

  d0efb16294d1 ("net: don't unconditionally copy_from_user a struct ifreq f=
or socket ioctls")

from the net tree and commits:

  876f0bf9d0d5 ("net: socket: simplify dev_ifconf handling")
  29c4964822aa ("net: socket: rework compat_ifreq_ioctl()")

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

diff --cc include/linux/netdevice.h
index d65ce093e5a7,6fd3a4d42668..000000000000
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@@ -4012,14 -4027,12 +4027,16 @@@ int netdev_rx_handler_register(struct n
  void netdev_rx_handler_unregister(struct net_device *dev);
 =20
  bool dev_valid_name(const char *name);
 +static inline bool is_socket_ioctl_cmd(unsigned int cmd)
 +{
 +	return _IOC_TYPE(cmd) =3D=3D SOCK_IOC_TYPE;
 +}
+ int get_user_ifreq(struct ifreq *ifr, void __user **ifrdata, void __user =
*arg);
+ int put_user_ifreq(struct ifreq *ifr, void __user *arg);
  int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
- 		bool *need_copyout);
- int dev_ifconf(struct net *net, struct ifconf *, int);
- int dev_ethtool(struct net *net, struct ifreq *);
+ 		void __user *data, bool *need_copyout);
+ int dev_ifconf(struct net *net, struct ifconf __user *ifc);
+ int dev_ethtool(struct net *net, struct ifreq *ifr, void __user *userdata=
);
  unsigned int dev_get_flags(const struct net_device *);
  int __dev_change_flags(struct net_device *dev, unsigned int flags,
  		       struct netlink_ext_ack *extack);
diff --cc net/socket.c
index 8808b3617dac,3c10504e46d9..000000000000
--- a/net/socket.c
+++ b/net/socket.c
@@@ -1100,27 -1124,13 +1124,16 @@@ static long sock_do_ioctl(struct net *n
  	if (err !=3D -ENOIOCTLCMD)
  		return err;
 =20
- 	if (cmd =3D=3D SIOCGIFCONF) {
- 		struct ifconf ifc;
- 		if (copy_from_user(&ifc, argp, sizeof(struct ifconf)))
- 			return -EFAULT;
- 		rtnl_lock();
- 		err =3D dev_ifconf(net, &ifc, sizeof(struct ifreq));
- 		rtnl_unlock();
- 		if (!err && copy_to_user(argp, &ifc, sizeof(struct ifconf)))
- 			err =3D -EFAULT;
- 	} else if (is_socket_ioctl_cmd(cmd)) {
- 		struct ifreq ifr;
- 		bool need_copyout;
- 		if (copy_from_user(&ifr, argp, sizeof(struct ifreq)))
++	if (!is_socket_ioctl_cmd(cmd))
++		return -ENOTTY;
++
+ 	if (get_user_ifreq(&ifr, &data, argp))
+ 		return -EFAULT;
+ 	err =3D dev_ioctl(net, cmd, &ifr, data, &need_copyout);
+ 	if (!err && need_copyout)
+ 		if (put_user_ifreq(&ifr, argp))
  			return -EFAULT;
- 		err =3D dev_ioctl(net, cmd, &ifr, &need_copyout);
- 		if (!err && need_copyout)
- 			if (copy_to_user(argp, &ifr, sizeof(struct ifreq)))
- 				return -EFAULT;
- 	} else {
- 		err =3D -ENOTTY;
- 	}
+=20
  	return err;
  }
 =20
@@@ -3306,99 -3216,13 +3219,15 @@@ static int compat_ifr_data_ioctl(struc
  				 struct compat_ifreq __user *u_ifreq32)
  {
  	struct ifreq ifreq;
- 	u32 data32;
+ 	void __user *data;
 =20
 +	if (!is_socket_ioctl_cmd(cmd))
 +		return -ENOTTY;
- 	if (copy_from_user(ifreq.ifr_name, u_ifreq32->ifr_name, IFNAMSIZ))
- 		return -EFAULT;
- 	if (get_user(data32, &u_ifreq32->ifr_data))
- 		return -EFAULT;
- 	ifreq.ifr_data =3D compat_ptr(data32);
-=20
- 	return dev_ioctl(net, cmd, &ifreq, NULL);
- }
-=20
- static int compat_ifreq_ioctl(struct net *net, struct socket *sock,
- 			      unsigned int cmd,
- 			      struct compat_ifreq __user *uifr32)
- {
- 	struct ifreq __user *uifr;
- 	int err;
-=20
- 	/* Handle the fact that while struct ifreq has the same *layout* on
- 	 * 32/64 for everything but ifreq::ifru_ifmap and ifreq::ifru_data,
- 	 * which are handled elsewhere, it still has different *size* due to
- 	 * ifreq::ifru_ifmap (which is 16 bytes on 32 bit, 24 bytes on 64-bit,
- 	 * resulting in struct ifreq being 32 and 40 bytes respectively).
- 	 * As a result, if the struct happens to be at the end of a page and
- 	 * the next page isn't readable/writable, we get a fault. To prevent
- 	 * that, copy back and forth to the full size.
- 	 */
-=20
- 	uifr =3D compat_alloc_user_space(sizeof(*uifr));
- 	if (copy_in_user(uifr, uifr32, sizeof(*uifr32)))
- 		return -EFAULT;
-=20
- 	err =3D sock_do_ioctl(net, sock, cmd, (unsigned long)uifr);
-=20
- 	if (!err) {
- 		switch (cmd) {
- 		case SIOCGIFFLAGS:
- 		case SIOCGIFMETRIC:
- 		case SIOCGIFMTU:
- 		case SIOCGIFMEM:
- 		case SIOCGIFHWADDR:
- 		case SIOCGIFINDEX:
- 		case SIOCGIFADDR:
- 		case SIOCGIFBRDADDR:
- 		case SIOCGIFDSTADDR:
- 		case SIOCGIFNETMASK:
- 		case SIOCGIFPFLAGS:
- 		case SIOCGIFTXQLEN:
- 		case SIOCGMIIPHY:
- 		case SIOCGMIIREG:
- 		case SIOCGIFNAME:
- 			if (copy_in_user(uifr32, uifr, sizeof(*uifr32)))
- 				err =3D -EFAULT;
- 			break;
- 		}
- 	}
- 	return err;
- }
-=20
- static int compat_sioc_ifmap(struct net *net, unsigned int cmd,
- 			struct compat_ifreq __user *uifr32)
- {
- 	struct ifreq ifr;
- 	struct compat_ifmap __user *uifmap32;
- 	int err;
-=20
- 	uifmap32 =3D &uifr32->ifr_ifru.ifru_map;
- 	err =3D copy_from_user(&ifr, uifr32, sizeof(ifr.ifr_name));
- 	err |=3D get_user(ifr.ifr_map.mem_start, &uifmap32->mem_start);
- 	err |=3D get_user(ifr.ifr_map.mem_end, &uifmap32->mem_end);
- 	err |=3D get_user(ifr.ifr_map.base_addr, &uifmap32->base_addr);
- 	err |=3D get_user(ifr.ifr_map.irq, &uifmap32->irq);
- 	err |=3D get_user(ifr.ifr_map.dma, &uifmap32->dma);
- 	err |=3D get_user(ifr.ifr_map.port, &uifmap32->port);
- 	if (err)
+ 	if (get_user_ifreq(&ifreq, &data, u_ifreq32))
  		return -EFAULT;
+ 	ifreq.ifr_data =3D data;
 =20
- 	err =3D dev_ioctl(net, cmd, &ifr, NULL);
-=20
- 	if (cmd =3D=3D SIOCGIFMAP && !err) {
- 		err =3D copy_to_user(uifr32, &ifr, sizeof(ifr.ifr_name));
- 		err |=3D put_user(ifr.ifr_map.mem_start, &uifmap32->mem_start);
- 		err |=3D put_user(ifr.ifr_map.mem_end, &uifmap32->mem_end);
- 		err |=3D put_user(ifr.ifr_map.base_addr, &uifmap32->base_addr);
- 		err |=3D put_user(ifr.ifr_map.irq, &uifmap32->irq);
- 		err |=3D put_user(ifr.ifr_map.dma, &uifmap32->dma);
- 		err |=3D put_user(ifr.ifr_map.port, &uifmap32->port);
- 		if (err)
- 			err =3D -EFAULT;
- 	}
- 	return err;
+ 	return dev_ioctl(net, cmd, &ifreq, data, NULL);
  }
 =20
  /* Since old style bridge ioctl's endup using SIOCDEVPRIVATE

--Sig_/UBWiXmiEq4xr_6CFk5SD7eZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEsOz4ACgkQAVBC80lX
0GxoEgf/bvy5ZXwLP29H53j264CT5l/2I0Pscli4wWnbUcwPWqIK334T2rT54PDp
vhFgfXHm8CPsgWeKyk4IqDKVKhkacYDg6jd9uOHV1VqaeJYpgrCsENS0DJGCHrOY
gENzAWEeVE1WdjcEZNBh1yi6ixzVlSppwfhKi4VT58ghL27AVtPbhe3BhEWQiqWl
EcJBe/hTF32b4E9ErcV7BbO7qCNPOBlQTy1/tfGS8SqRIw8uUQSruukNE3B/IV7u
uJaGZ0QtzFIewvH87qZ7z8FMM1QHhZk8P+kxTvHI6bwfRdt+NbmP7ke8kOTOxTIo
8Y3ulk49hXfbKQnpAJ3k2qP8jsu3gg==
=Carw
-----END PGP SIGNATURE-----

--Sig_/UBWiXmiEq4xr_6CFk5SD7eZ--
