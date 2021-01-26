Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53D53055F8
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S316875AbhAZXL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:11:28 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:43346 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393038AbhAZUME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 15:12:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611691923; x=1643227923;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Iud4u6y9O0BVCeDjBLb2YvF7/PXS8yWU9m/W37EPe78=;
  b=ER/u1Z9/N9p7djvxsy26SRN1Bdy6J9Uvz8HkYbsSBfuxWayXmucsy7PB
   PTW90YxFStiphJb38AfbEqNb74n2J5bAprpiijTacIePlsyCdK/eTdSZF
   6ovWH8qs4QCv4rcw4wt/25oFj3AnDTb1P2Q+AZTZg2vk1EuKtDTSDShNI
   IN2iXuZ17w2q7GFap9xMnYLOcN05mYrcNNQfN4UJhnFCxV78VNQAnzJJl
   hz6qXp4o5TJ109kExLVhv7S6PFjez8QCrkcxCAtkZ/7KDZT+OopMnMK+a
   tFHJ4LJ37zrl/GOy5YmQaLVFnKtKVWfiv+9vIJUVh3m02cp5VxB5clHKn
   A==;
IronPort-SDR: 0M4uwziWPEJ2AaoDRexoomEz25B4S+FDGRwi003VDQ/rlUWPQaG5K19rMgnLz9tgWgQwy7TcNC
 Vt+ACcI5C9SE55h16OkYJNZlaaNGyA70y0i6VSHuPbZHncfP1sal6j/aqJU48jAEg+YkXWeQC6
 BQSbC+AN5g/B/Tr4UfHRmbaGOr+ARCegQttUtQREx5SL24NsaSymq71sf5WQ9tRyO+THabsx+i
 OR/Qo7pSgBmOqH4S2H06p0ULzc2bbGTRcMFuxeqr+eOD5dXZVMkUI8M1h5zZVJpX/4SiYJKQdO
 GCU=
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="41858671"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jan 2021 13:10:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 26 Jan 2021 13:10:35 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 26 Jan 2021 13:10:35 -0700
Date:   Tue, 26 Jan 2021 21:10:34 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     =?utf-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        <ivecera@redhat.com>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 3/4] bridge: mrp: Extend br_mrp_switchdev to
 detect better the errors
Message-ID: <20210126201034.ihjwtyfsnkxk2pwo@soft-dev3.localdomain>
References: <20210123161812.1043345-1-horatiu.vultur@microchip.com>
 <20210123161812.1043345-4-horatiu.vultur@microchip.com>
 <CAF=yD-KdqagGYZwzke-tX257JbtbPwi-2p0esOV1EFX3DN_ZUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CAF=yD-KdqagGYZwzke-tX257JbtbPwi-2p0esOV1EFX3DN_ZUg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/25/2021 19:06, Willem de Bruijn wrote:
> On Sat, Jan 23, 2021 at 11:23 AM Horatiu Vultur
> <horatiu.vultur@microchip.com> wrote:

Hi Willem,

> >
> > This patch extends the br_mrp_switchdev functions to be able to have a
> > better understanding what cause the issue and if the SW needs to be used
> > as a backup.
> >
> > There are the following cases:
> > - when the code is compiled without CONFIG_NET_SWITCHDEV. In this case
> >   return success so the SW can continue with the protocol. Depending on
> >   the function it returns 0 or BR_MRP_SW.
> > - when code is compiled with CONFIG_NET_SWITCHDEV and the driver doesn't
> >   implement any MRP callbacks, then the HW can't run MRP so it just
> >   returns -EOPNOTSUPP. So the SW will stop further to configure the
> >   node.
> > - when code is compiled with CONFIG_NET_SWITCHDEV and the driver fully
> >   supports any MRP functionality then the SW doesn't need to do
> >   anything.  The functions will return 0 or BR_MRP_HW.
> > - when code is compiled with CONFIG_NET_SWITCHDEV and the HW can't run
> >   completely the protocol but it can help the SW to run it.  For
> >   example, the HW can't support completely MRM role(can't detect when it
> >   stops receiving MRP Test frames) but it can redirect these frames to
> >   CPU. In this case it is possible to have a SW fallback. The SW will
> >   try initially to call the driver with sw_backup set to false, meaning
> >   that the HW can implement completely the role. If the driver returns
> >   -EOPNOTSUPP, the SW will try again with sw_backup set to false,
> >   meaning that the SW will detect when it stops receiving the frames. In
> >   case the driver returns 0 then the SW will continue to configure the
> >   node accordingly.
> >
> > In this way is more clear when the SW needs to stop configuring the
> > node, or when the SW is used as a backup or the HW can implement the
> > functionality.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> 
> > -int br_mrp_switchdev_set_ring_role(struct net_bridge *br,
> > -                                  struct br_mrp *mrp,
> > -                                  enum br_mrp_ring_role_type role)
> > +enum br_mrp_hw_support
> > +br_mrp_switchdev_set_ring_role(struct net_bridge *br, struct br_mrp *mrp,
> > +                              enum br_mrp_ring_role_type role)
> >  {
> >         struct switchdev_obj_ring_role_mrp mrp_role = {
> >                 .obj.orig_dev = br->dev,
> >                 .obj.id = SWITCHDEV_OBJ_ID_RING_ROLE_MRP,
> >                 .ring_role = role,
> >                 .ring_id = mrp->ring_id,
> > +               .sw_backup = false,
> >         };
> >         int err;
> >
> > +       /* If switchdev is not enabled then just run in SW */
> > +       if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
> > +               return BR_MRP_SW;
> > +
> > +       /* First try to see if HW can implement comptletly the role in HW */
> 
> typo: completely
> 
> >         if (role == BR_MRP_RING_ROLE_DISABLED)
> >                 err = switchdev_port_obj_del(br->dev, &mrp_role.obj);
> >         else
> >                 err = switchdev_port_obj_add(br->dev, &mrp_role.obj, NULL);
> >
> > -       return err;
> > +       /* In case of success then just return and notify the SW that doesn't
> > +        * need to do anything
> > +        */
> > +       if (!err)
> > +               return BR_MRP_HW;
> > +
> > +       /* There was some issue then is not possible at all to have this role so
> > +        * just return failire
> 
> typo: failure
> 
> > +        */
> > +       if (err != -EOPNOTSUPP)
> > +               return BR_MRP_NONE;
> > +
> > +       /* In case the HW can't run complety in HW the protocol, we try again
> 
> typo: completely. Please proofread your comments closely. I saw at
> least one typo in the commit messages too.

Sorry for that. I will fix those in the next version.
> 
> More in general comments that say what the code does can generally be eschewed.
> 
> > +        * and this time to allow the SW to help, but the HW needs to redirect
> > +        * the frames to CPU.
> > +        */
> > +       mrp_role.sw_backup = true;
> > +       err = switchdev_port_obj_add(br->dev, &mrp_role.obj, NULL);
> 
> This calls the same function. I did not see code that changes behavior
> based on sw_backup. Will this not give the same result?

No, because is the driver responsibility to check that flag and
implement what it can support. If the sw_backup is false, then it is
expected the driver to implement completely the functionality in HW. If
sw_backup is true it just needs to help the SW to run. So the driver can
check this flag and decide what to do.

> 
> Also, this lacks the role test (add or del). Is that because if
> falling back onto SW mode during add, this code does not get called at
> all on delete?

Good catch!. It should have the check.

> 
> > +
> > +       /* In case of success then notify the SW that it needs to help with the
> > +        * protocol
> > +        */
> > +       if (!err)
> > +               return BR_MRP_SW;
> > +
> > +       return BR_MRP_NONE;
> >  }
> >
> > -int br_mrp_switchdev_send_ring_test(struct net_bridge *br,
> > -                                   struct br_mrp *mrp, u32 interval,
> > -                                   u8 max_miss, u32 period,
> > -                                   bool monitor)
> > +enum br_mrp_hw_support
> > +br_mrp_switchdev_send_ring_test(struct net_bridge *br, struct br_mrp *mrp,
> > +                               u32 interval, u8 max_miss, u32 period,
> > +                               bool monitor)
> >  {
> >         struct switchdev_obj_ring_test_mrp test = {
> >                 .obj.orig_dev = br->dev,
> > @@ -79,12 +106,29 @@ int br_mrp_switchdev_send_ring_test(struct net_bridge *br,
> >         };
> >         int err;
> >
> > +       /* If switchdev is not enabled then just run in SW */
> > +       if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
> > +               return BR_MRP_SW;
> > +
> >         if (interval == 0)
> >                 err = switchdev_port_obj_del(br->dev, &test.obj);
> >         else
> >                 err = switchdev_port_obj_add(br->dev, &test.obj, NULL);
> >
> > -       return err;
> > +       /* If everything succeed then the HW can send this frames, so the SW
> > +        * doesn't need to generate them
> > +        */
> > +       if (!err)
> > +               return BR_MRP_HW;
> > +
> > +       /* There was an error when the HW was configured so the SW return
> > +        * failure
> > +        */
> > +       if (err != -EOPNOTSUPP)
> > +               return BR_MRP_NONE;
> > +
> > +       /* So the HW can't generate these frames so allow the SW to do that */
> > +       return BR_MRP_SW;
> 
> This is the same ternary test as above. It recurs a few times. Perhaps
> it can use a helper.

Yes, I will try to have a look.

-- 
/Horatiu
