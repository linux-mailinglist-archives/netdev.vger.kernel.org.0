Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A085F5446AB
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242602AbiFII4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242833AbiFII4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:56:20 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8704D157E83;
        Thu,  9 Jun 2022 01:55:46 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id r82so40602973ybc.13;
        Thu, 09 Jun 2022 01:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YH73zntbjDUPK6OxayMeLVDIl0HlwRQITf42qe8fKuo=;
        b=V6GXE9peuDL15Kn9hH/D5RcvvDtZzc/UqNccmvPVX4+vnl6NSYdtdsX6IqwMyO/R8G
         xw3uApaEFLyYdGyZmdPL76UuJJTHu3z5E+Jb4VhLRhrnGhG2Kv+iexJUfvbTYY9aQbqd
         XzylGOiBliWtrO7pcAtc6HmgTeIfAsaP04Km60f333K6TbBup0KdeiY2/b4anYGtekeP
         zB11DEhfAL2Sf/ig3pIx2sDyFYixMIudkRRwEXy3w2b6UfVpaEpiGdGJbnpU3hqTysfb
         sQMaeORA5belOJKz/Xt2RynpK7yUUwG/NZOCNv2j0g1aITHyTUmjbbsYuW+CSlEr3eaM
         +IXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YH73zntbjDUPK6OxayMeLVDIl0HlwRQITf42qe8fKuo=;
        b=g/rEwQJDQyhl5qhII6AL0f7inKGRi+oLw4eLIu89dAjWm+UgJZixvr+zqBkdoo1orF
         XnZOAXZIeBbxqRsUNqqIM6uPKQXmMKL1tMbT2h3sJA61l5IP3yuhhKZtNiHOpORoVQLX
         LLLdmjjZzIsgSti52JfjFm9kFySwmID4A+zGODdNLfSrwPC5BF8E7o4P4n8IfHIxMNlF
         +OQNSAQ2tXO+3jaZz5H140+yWSFWJKggcSR5f5IuNFtbqFE4JTMM+TVGXMT9mUZ/M74d
         LWfW4CfjXxxLIxOa7GuoVR39+cWz+lFdb/ZFiTNUnOk/izz8KXAHId47YuzhaDUTxxEf
         zJdQ==
X-Gm-Message-State: AOAM533v9g0F7H7ifJW/kjBqhq0KnwjfhlRwi7RWRdeCKIzuN2KE/tMy
        ojnkEObUoIhhWBXHi9WFLM5WzpWCMNYEchF8dmg=
X-Google-Smtp-Source: ABdhPJxsJRoMtdmiUSWdD7H2QGFbayIfQxyv+5R2CkLBeT/bm2uKCoL1UfBGNybBb8z8O4zASBhYCf8uw7euDH3XXAc=
X-Received: by 2002:a25:3145:0:b0:64e:ac9a:eb27 with SMTP id
 x66-20020a253145000000b0064eac9aeb27mr37767832ybx.630.1654764945428; Thu, 09
 Jun 2022 01:55:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220609082433.1191060-1-srinivas.neeli@xilinx.com>
 <20220609082433.1191060-3-srinivas.neeli@xilinx.com> <20220609083139.sx2adt4raptu2jif@pengutronix.de>
In-Reply-To: <20220609083139.sx2adt4raptu2jif@pengutronix.de>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Thu, 9 Jun 2022 17:55:34 +0900
Message-ID: <CAMZ6RqKbdbuxiN8gEQxynnhP=Mmpyureho6dC1fVoPzFb0LfmQ@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] can: xilinx_can: Add Transmitter delay
 compensation (TDC) feature support
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Srinivas Neeli <srinivas.neeli@xilinx.com>, wg@grandegger.com,
        davem@davemloft.net, edumazet@google.com, srinivas.neeli@amd.com,
        neelisrinivas18@gmail.com, appana.durga.rao@xilinx.com,
        sgoud@xilinx.com, michal.simek@xilinx.com, kuba@kernel.org,
        pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, git@xilinx.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 9 juin 2022 at 17:34, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 09.06.2022 13:54:33, Srinivas Neeli wrote:
> > Added Transmitter delay compensation (TDC) feature support.
> > In the case of higher measured loop delay with higher baud rates,
> > observed bit stuff errors. By enabling the TDC feature in
> > CANFD controllers, will compensate for the measure loop delay in
> > the receive path.
> >
> > Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
> > ---
> > Changes in V3:
> > -Implemented GENMASK,FIELD_PERP & FIELD_GET Calls.
> > -Implemented TDC feature for all Xilinx CANFD controllers.
> > -corrected prescalar to prescaler(typo).
> > Changes in V2:
> > -Created two patchs one for revert another for TDC support.
> > ---
> >  drivers/net/can/xilinx_can.c | 48 ++++++++++++++++++++++++++++++++----
> >  1 file changed, 43 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.=
c
> > index e179d311aa28..288be69c0aed 100644
> > --- a/drivers/net/can/xilinx_can.c
> > +++ b/drivers/net/can/xilinx_can.c
> > @@ -1,7 +1,7 @@
> >  // SPDX-License-Identifier: GPL-2.0-or-later
> >  /* Xilinx CAN device driver
> >   *
> > - * Copyright (C) 2012 - 2014 Xilinx, Inc.
> > + * Copyright (C) 2012 - 2022 Xilinx, Inc.
> >   * Copyright (C) 2009 PetaLogix. All rights reserved.
> >   * Copyright (C) 2017 - 2018 Sandvik Mining and Construction Oy
> >   *
> > @@ -9,6 +9,7 @@
> >   * This driver is developed for Axi CAN IP and for Zynq CANPS Controll=
er.
> >   */
> >
> > +#include <linux/bitfield.h>
> >  #include <linux/clk.h>
> >  #include <linux/errno.h>
> >  #include <linux/init.h>
> > @@ -99,6 +100,7 @@ enum xcan_reg {
> >  #define XCAN_ESR_STER_MASK           0x00000004 /* Stuff error */
> >  #define XCAN_ESR_FMER_MASK           0x00000002 /* Form error */
> >  #define XCAN_ESR_CRCER_MASK          0x00000001 /* CRC error */
> > +#define XCAN_SR_TDCV_MASK            GENMASK(22, 16) /* TDCV Value */
> >  #define XCAN_SR_TXFLL_MASK           0x00000400 /* TX FIFO is full */
> >  #define XCAN_SR_ESTAT_MASK           0x00000180 /* Error status */
> >  #define XCAN_SR_ERRWRN_MASK          0x00000040 /* Error warning */
> > @@ -132,6 +134,8 @@ enum xcan_reg {
> >  #define XCAN_DLCR_BRS_MASK           0x04000000 /* BRS Mask in DLC */
> >
> >  /* CAN register bit shift - XCAN_<REG>_<BIT>_SHIFT */
> > +#define XCAN_BRPR_TDCO_SHIFT         GENMASK(13, 8)  /* Transmitter De=
lay Compensation Offset */
>                           ^^^^^
> This is a MASK.
>
> > +#define XCAN_BRPR_TDC_ENABLE         BIT(16) /* Transmitter Delay Comp=
ensation (TDC) Enable */
> >  #define XCAN_BTR_SJW_SHIFT           7  /* Synchronous jump width */
> >  #define XCAN_BTR_TS2_SHIFT           4  /* Time segment 2 */
> >  #define XCAN_BTR_SJW_SHIFT_CANFD     16 /* Synchronous jump width */
> > @@ -276,6 +280,16 @@ static const struct can_bittiming_const xcan_data_=
bittiming_const_canfd2 =3D {
> >       .brp_inc =3D 1,
> >  };
> >
> > +/* Transmission Delay Compensation constants for CANFD2.0 and Versal  =
*/
> > +static const struct can_tdc_const xcan_tdc_const =3D {
> > +     .tdcv_min =3D 0,
> > +     .tdcv_max =3D 0, /* Manual mode not supported. */
> > +     .tdco_min =3D 0,
> > +     .tdco_max =3D 64,
> > +     .tdcf_min =3D 0, /* Filter window not supported */
> > +     .tdcf_max =3D 0,
> > +};
> > +
> >  /**
> >   * xcan_write_reg_le - Write a value to the device register little end=
ian
> >   * @priv:    Driver private data structure
> > @@ -405,7 +419,7 @@ static int xcan_set_bittiming(struct net_device *nd=
ev)
> >               return -EPERM;
> >       }
> >
> > -     /* Setting Baud Rate prescalar value in BRPR Register */
> > +     /* Setting Baud Rate prescaler value in BRPR Register */
>
> unrelated change, please make it a separate patch
>
> >       btr0 =3D (bt->brp - 1);
> >
> >       /* Setting Time Segment 1 in BTR Register */
> > @@ -422,8 +436,12 @@ static int xcan_set_bittiming(struct net_device *n=
dev)
> >
> >       if (priv->devtype.cantype =3D=3D XAXI_CANFD ||
> >           priv->devtype.cantype =3D=3D XAXI_CANFD_2_0) {
> > -             /* Setting Baud Rate prescalar value in F_BRPR Register *=
/
> > +             /* Setting Baud Rate prescaler value in F_BRPR Register *=
/
>
> same
>
> >               btr0 =3D dbt->brp - 1;
> > +             if (can_tdc_is_enabled(&priv->can))
> > +                     btr0 |=3D
> > +                     FIELD_PREP(XCAN_BRPR_TDCO_SHIFT, priv->can.tdc.td=
co) |
> > +                     XCAN_BRPR_TDC_ENABLE;
> >
> >               /* Setting Time Segment 1 in BTR Register */
> >               btr1 =3D dbt->prop_seg + dbt->phase_seg1 - 1;
> > @@ -1483,6 +1501,22 @@ static int xcan_get_berr_counter(const struct ne=
t_device *ndev,
> >       return 0;
> >  }
> >
> > +/**
> > + * xcan_get_auto_tdcv - Get Transmitter Delay Compensation Value
> > + * @ndev:    Pointer to net_device structure
> > + * @tdcv:    Pointer to TDCV value
> > + *
> > + * Return: 0 on success
> > + */
> > +static int xcan_get_auto_tdcv(const struct net_device *ndev, u32 *tdcv=
)
> > +{
> > +     struct xcan_priv *priv =3D netdev_priv(ndev);
> > +
> > +     *tdcv =3D FIELD_GET(XCAN_SR_TDCV_MASK, priv->read_reg(priv, XCAN_=
SR_OFFSET));
> > +
> > +     return 0;
> > +}
> > +
> >  static const struct net_device_ops xcan_netdev_ops =3D {
> >       .ndo_open       =3D xcan_open,
> >       .ndo_stop       =3D xcan_close,
> > @@ -1744,8 +1778,12 @@ static int xcan_probe(struct platform_device *pd=
ev)
> >                       &xcan_data_bittiming_const_canfd2;
> >
> >       if (devtype->cantype =3D=3D XAXI_CANFD ||
> > -         devtype->cantype =3D=3D XAXI_CANFD_2_0)
> > -             priv->can.ctrlmode_supported |=3D CAN_CTRLMODE_FD;
> > +         devtype->cantype =3D=3D XAXI_CANFD_2_0) {
> > +             priv->can.ctrlmode_supported |=3D CAN_CTRLMODE_FD |
> > +                                             CAN_CTRLMODE_TDC_AUTO;
> > +             priv->can.do_get_auto_tdcv =3D xcan_get_auto_tdcv;
> > +             priv->can.tdc_const =3D &xcan_tdc_const;
> > +     }
> >
> >       priv->reg_base =3D addr;
> >       priv->tx_max =3D tx_max;
> > --
> > 2.25.1
> >
> >
>
> Otherwise looks good.

Same for me. Also, thanks for using the TDC framework. You are the
first one to use it after I created it!

Assuming you address all of Marc=E2=80=99s comment, please add this in your=
 v4:
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>


Yours sincerely,
Vincent Mailhol
