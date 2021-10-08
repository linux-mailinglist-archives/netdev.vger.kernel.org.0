Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4149842664C
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 11:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhJHJEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 05:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhJHJEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 05:04:09 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727A8C061570;
        Fri,  8 Oct 2021 02:02:14 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1633683732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AsnAEiR07nmfJb6cEuO6yKy89hFR9dwNr3/JNgXMJAk=;
        b=ewCyeYUXhurvjU8Bwa9RIWrhsKx/a9Vei7/jgsu1iBLcGblZ7uAdA7sQ9blBo/DVQRnzp4
        Lp3zN+R0V0ybadl0GvGz8ylz44J8VN2+JnOBx517BsvpOoF3hSGzlPhWUlKpnxBEKaKAyj
        5ybbU3nh+aU/C6YmltOwN7ZvZ2ECtg8=
Date:   Fri, 08 Oct 2021 09:02:12 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <25d22c8ed06748bb5b0d4968b737351b@linux.dev>
Subject: Re: [PATCH net-next] net: dev_addr_list: Introduce
 __dev_addr_add() and __dev_addr_del()
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211008085354.9961-1-yajun.deng@linux.dev>
References: <20211008085354.9961-1-yajun.deng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, There are still some problems with this patch.=0A=0A=0AOctober 8, =
2021 4:53 PM, "Yajun Deng" <yajun.deng@linux.dev> =E5=86=99=E5=88=B0:=0A=
=0A> Introduce helper functions __dev_addr_add() and __dev_addr_del() for=
=0A> the same code, make the code more concise.=0A> =0A> Signed-off-by: Y=
ajun Deng <yajun.deng@linux.dev>=0A> ---=0A> net/core/dev_addr_lists.c | =
117 ++++++++++++++++----------------------=0A> 1 file changed, 48 inserti=
ons(+), 69 deletions(-)=0A> =0A> diff --git a/net/core/dev_addr_lists.c b=
/net/core/dev_addr_lists.c=0A> index f0cb38344126..f6e33bdc0a30 100644=0A=
> --- a/net/core/dev_addr_lists.c=0A> +++ b/net/core/dev_addr_lists.c=0A>=
 @@ -614,6 +614,38 @@ int dev_addr_del(struct net_device *dev, const unsi=
gned char *addr,=0A> }=0A> EXPORT_SYMBOL(dev_addr_del);=0A> =0A> +static =
int __dev_addr_add(struct net_device *dev, const unsigned char *addr,=0A>=
 + unsigned char addr_type, bool global, bool sync,=0A> + bool exclusive)=
=0A> +{=0A> + int err;=0A> +=0A> + netif_addr_lock_bh(dev);=0A> + err =3D=
 __hw_addr_add_ex(&dev->uc, addr, dev->addr_len,=0A> + addr_type, global,=
 sync,=0A> + 0, exclusive);=0A> + if (!err)=0A> + __dev_set_rx_mode(dev);=
=0A> + netif_addr_unlock_bh(dev);=0A> +=0A> + return err;=0A> +}=0A> +=0A=
> +static int __dev_addr_del(struct net_device *dev, const unsigned char =
*addr,=0A> + unsigned char addr_type, bool global, bool sync)=0A> +{=0A> =
+ int err;=0A> +=0A> + netif_addr_lock_bh(dev);=0A> + err =3D __hw_addr_d=
el_ex(&dev->uc, addr, dev->addr_len,=0A> + addr_type, global, sync);=0A> =
+ if (!err)=0A> + __dev_set_rx_mode(dev);=0A> + netif_addr_unlock_bh(dev)=
;=0A> +=0A> + return err;=0A> +}=0A> +=0A> /*=0A> * Unicast list handling=
 functions=0A> */=0A> @@ -625,16 +657,9 @@ EXPORT_SYMBOL(dev_addr_del);=
=0A> */=0A> int dev_uc_add_excl(struct net_device *dev, const unsigned ch=
ar *addr)=0A> {=0A> - int err;=0A> =0A> - netif_addr_lock_bh(dev);=0A> - =
err =3D __hw_addr_add_ex(&dev->uc, addr, dev->addr_len,=0A> - NETDEV_HW_A=
DDR_T_UNICAST, true, false,=0A> - 0, true);=0A> - if (!err)=0A> - __dev_s=
et_rx_mode(dev);=0A> - netif_addr_unlock_bh(dev);=0A> - return err;=0A> +=
 return __dev_addr_add(dev, addr, NETDEV_HW_ADDR_T_UNICAST,=0A> + true, f=
alse, true);=0A> }=0A> EXPORT_SYMBOL(dev_uc_add_excl);=0A> =0A> @@ -648,1=
5 +673,8 @@ EXPORT_SYMBOL(dev_uc_add_excl);=0A> */=0A> int dev_uc_add(str=
uct net_device *dev, const unsigned char *addr)=0A> {=0A> - int err;=0A> =
-=0A> - netif_addr_lock_bh(dev);=0A> - err =3D __hw_addr_add(&dev->uc, ad=
dr, dev->addr_len,=0A> - NETDEV_HW_ADDR_T_UNICAST);=0A> - if (!err)=0A> -=
 __dev_set_rx_mode(dev);=0A> - netif_addr_unlock_bh(dev);=0A> - return er=
r;=0A> + return __dev_addr_add(dev, addr, NETDEV_HW_ADDR_T_UNICAST,=0A> +=
 false, false, false);=0A> }=0A> EXPORT_SYMBOL(dev_uc_add);=0A> =0A> @@ -=
670,15 +688,8 @@ EXPORT_SYMBOL(dev_uc_add);=0A> */=0A> int dev_uc_del(str=
uct net_device *dev, const unsigned char *addr)=0A> {=0A> - int err;=0A> =
-=0A> - netif_addr_lock_bh(dev);=0A> - err =3D __hw_addr_del(&dev->uc, ad=
dr, dev->addr_len,=0A> - NETDEV_HW_ADDR_T_UNICAST);=0A> - if (!err)=0A> -=
 __dev_set_rx_mode(dev);=0A> - netif_addr_unlock_bh(dev);=0A> - return er=
r;=0A> + return __dev_addr_del(dev, addr, NETDEV_HW_ADDR_T_UNICAST,=0A> +=
 false, false);=0A> }=0A> EXPORT_SYMBOL(dev_uc_del);=0A> =0A> @@ -810,33 =
+821,11 @@ EXPORT_SYMBOL(dev_uc_init);=0A> */=0A> int dev_mc_add_excl(str=
uct net_device *dev, const unsigned char *addr)=0A> {=0A> - int err;=0A> =
-=0A> - netif_addr_lock_bh(dev);=0A> - err =3D __hw_addr_add_ex(&dev->mc,=
 addr, dev->addr_len,=0A> - NETDEV_HW_ADDR_T_MULTICAST, true, false,=0A> =
- 0, true);=0A> - if (!err)=0A> - __dev_set_rx_mode(dev);=0A> - netif_add=
r_unlock_bh(dev);=0A> - return err;=0A> + return __dev_addr_add(dev, addr=
, NETDEV_HW_ADDR_T_MULTICAST,=0A> + true, false, true);=0A> }=0A> EXPORT_=
SYMBOL(dev_mc_add_excl);=0A> =0A> -static int __dev_mc_add(struct net_dev=
ice *dev, const unsigned char *addr,=0A> - bool global)=0A> -{=0A> - int =
err;=0A> -=0A> - netif_addr_lock_bh(dev);=0A> - err =3D __hw_addr_add_ex(=
&dev->mc, addr, dev->addr_len,=0A> - NETDEV_HW_ADDR_T_MULTICAST, global, =
false,=0A> - 0, false);=0A> - if (!err)=0A> - __dev_set_rx_mode(dev);=0A>=
 - netif_addr_unlock_bh(dev);=0A> - return err;=0A> -}=0A> /**=0A> * dev_=
mc_add - Add a multicast address=0A> * @dev: device=0A> @@ -847,7 +836,8 =
@@ static int __dev_mc_add(struct net_device *dev, const unsigned char *a=
ddr,=0A> */=0A> int dev_mc_add(struct net_device *dev, const unsigned cha=
r *addr)=0A> {=0A> - return __dev_mc_add(dev, addr, false);=0A> + return =
__dev_addr_add(dev, addr, NETDEV_HW_ADDR_T_MULTICAST,=0A> + false, false,=
 false);=0A> }=0A> EXPORT_SYMBOL(dev_mc_add);=0A> =0A> @@ -860,24 +850,11=
 @@ EXPORT_SYMBOL(dev_mc_add);=0A> */=0A> int dev_mc_add_global(struct ne=
t_device *dev, const unsigned char *addr)=0A> {=0A> - return __dev_mc_add=
(dev, addr, true);=0A> + return __dev_addr_add(dev, addr, NETDEV_HW_ADDR_=
T_MULTICAST,=0A> + true, false, false);=0A> }=0A> EXPORT_SYMBOL(dev_mc_ad=
d_global);=0A> =0A> -static int __dev_mc_del(struct net_device *dev, cons=
t unsigned char *addr,=0A> - bool global)=0A> -{=0A> - int err;=0A> -=0A>=
 - netif_addr_lock_bh(dev);=0A> - err =3D __hw_addr_del_ex(&dev->mc, addr=
, dev->addr_len,=0A> - NETDEV_HW_ADDR_T_MULTICAST, global, false);=0A> - =
if (!err)=0A> - __dev_set_rx_mode(dev);=0A> - netif_addr_unlock_bh(dev);=
=0A> - return err;=0A> -}=0A> -=0A> /**=0A> * dev_mc_del - Delete a multi=
cast address.=0A> * @dev: device=0A> @@ -888,7 +865,8 @@ static int __dev=
_mc_del(struct net_device *dev, const unsigned char *addr,=0A> */=0A> int=
 dev_mc_del(struct net_device *dev, const unsigned char *addr)=0A> {=0A> =
- return __dev_mc_del(dev, addr, false);=0A> + return __dev_addr_del(dev,=
 addr, NETDEV_HW_ADDR_T_MULTICAST,=0A> + false, false);=0A> }=0A> EXPORT_=
SYMBOL(dev_mc_del);=0A> =0A> @@ -902,7 +880,8 @@ EXPORT_SYMBOL(dev_mc_del=
);=0A> */=0A> int dev_mc_del_global(struct net_device *dev, const unsigne=
d char *addr)=0A> {=0A> - return __dev_mc_del(dev, addr, true);=0A> + ret=
urn __dev_addr_del(dev, addr, NETDEV_HW_ADDR_T_MULTICAST,=0A> + true, fal=
se);=0A> }=0A> EXPORT_SYMBOL(dev_mc_del_global);=0A> =0A> -- =0A> 2.32.0
