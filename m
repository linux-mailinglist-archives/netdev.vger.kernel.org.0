Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC27953FA94
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 11:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240484AbiFGJ54 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Jun 2022 05:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240449AbiFGJ5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 05:57:31 -0400
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0998C2C10B;
        Tue,  7 Jun 2022 02:57:20 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id v22so30264846ybd.5;
        Tue, 07 Jun 2022 02:57:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1o6qvv4aZHKs7XMCFadyrE8xTLQ95GJxFv1Dwo+Wjzw=;
        b=o2E8PHTg5OllqDq6GVg33q/MJFloPbC19QCKRSOfJfF71Q0wWb2PNmXZkEd39OsqtY
         tdyKIbZIyYYhXB629zjafKU/zvsZWBpIe+iqRLozZnjbFY7044poB7LV4XJEnxxfgJA2
         TaTVDsu4m42Tppiz5c2B99EUaStKjGbLiFm/jAe4cU0TBCVUNUdsMugbO6O2MMslS6qZ
         xmskxJkB4UC52Me7qqRf2V95kUrzXFduOclSkLkQUFxGpl16ITwp4PpUORl4SUJJdK0j
         8en05qbE1rcTvcYtbSpVd5KhskefH5C+wvBvT4W6BijR/baZ/wfLpHelvEmtvuq4BCRX
         xSsQ==
X-Gm-Message-State: AOAM5332AF0kn+otR+8tcepcrTKPLNVTJ0llqs8xmTQpt8qcFZDdMGbT
        UAsim0uyVpCw8GzF13TvWNIayJgFFcB6dxUlRYg=
X-Google-Smtp-Source: ABdhPJzauMa/Ot0U1RgZij3q0h3HTyM94KvNcvA/aLGZgnTSLbgGKZh+P9FTLJm1IVkyPxWffemDBYZqA+0CcqEX7dA=
X-Received: by 2002:a25:6588:0:b0:65d:57b9:c470 with SMTP id
 z130-20020a256588000000b0065d57b9c470mr29863596ybb.142.1654595840050; Tue, 07
 Jun 2022 02:57:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220607085654.4178-1-srinivas.neeli@xilinx.com>
 <20220607085654.4178-3-srinivas.neeli@xilinx.com> <20220607091952.gls5bgwplytbhmoq@pengutronix.de>
In-Reply-To: <20220607091952.gls5bgwplytbhmoq@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 7 Jun 2022 18:57:09 +0900
Message-ID: <CAMZ6Rq+XjBThwqXK4DmdxChutJp_N8Jm83Bd2b3EdXVQrhO_GA@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] can: xilinx_can: Add Transmitter delay
 compensation (TDC) feature support
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Srinivas Neeli <srinivas.neeli@xilinx.com>, wg@grandegger.com,
        davem@davemloft.net, edumazet@google.com,
        appana.durga.rao@xilinx.com, sgoud@xilinx.com,
        michal.simek@xilinx.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 On Tue. 7 Jun. 2022 at 18:19, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> Hello Srinivas Neeli,
>
> thanks for your patch!
>
> On 07.06.2022 14:26:54, Srinivas Neeli wrote:
> > Added Transmitter delay compensation (TDC) feature support.
> > In the case of higher measured loop delay with higher baud rates,
> > observed bit stuff errors. By enabling the TDC feature in a controller,
> > will compensate for the measure loop delay in the receive path.
>
> Wich controllers support TDC?
>
> XAXI_CANFD doesn't have do_get_auto_tdc assigned, but
> CAN_CTRLMODE_TDC_AUTO is set.
>
> > Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
> > ---
> >  drivers/net/can/xilinx_can.c | 46 +++++++++++++++++++++++++++++++++---
> >  1 file changed, 43 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
> > index e179d311aa28..d0edd1bca33c 100644
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
> > @@ -99,6 +99,7 @@ enum xcan_reg {
> >  #define XCAN_ESR_STER_MASK           0x00000004 /* Stuff error */
> >  #define XCAN_ESR_FMER_MASK           0x00000002 /* Form error */
> >  #define XCAN_ESR_CRCER_MASK          0x00000001 /* CRC error */
> > +#define XCAN_SR_TDCV_MASK            0x007F0000 /* TDCV Value */
> >  #define XCAN_SR_TXFLL_MASK           0x00000400 /* TX FIFO is full */
> >  #define XCAN_SR_ESTAT_MASK           0x00000180 /* Error status */
> >  #define XCAN_SR_ERRWRN_MASK          0x00000040 /* Error warning */
> > @@ -132,6 +133,8 @@ enum xcan_reg {
> >  #define XCAN_DLCR_BRS_MASK           0x04000000 /* BRS Mask in DLC */
> >
> >  /* CAN register bit shift - XCAN_<REG>_<BIT>_SHIFT */
> > +#define XCAN_BRPR_TDCO_SHIFT         8  /* Transmitter Delay Compensation Offset */
> > +#define XCAN_BRPR_TDC_ENABLE         BIT(16) /* Transmitter Delay Compensation (TDC) Enable */
> >  #define XCAN_BTR_SJW_SHIFT           7  /* Synchronous jump width */
> >  #define XCAN_BTR_TS2_SHIFT           4  /* Time segment 2 */
> >  #define XCAN_BTR_SJW_SHIFT_CANFD     16 /* Synchronous jump width */
> > @@ -140,6 +143,7 @@ enum xcan_reg {
> >  #define XCAN_IDR_ID2_SHIFT           1  /* Extended Message Identifier */
> >  #define XCAN_DLCR_DLC_SHIFT          28 /* Data length code */
> >  #define XCAN_ESR_REC_SHIFT           8  /* Rx Error Count */
> > +#define XCAN_SR_TDCV_SHIFT           16 /* TDCV Value */
> >
> >  /* CAN frame length constants */
> >  #define XCAN_FRAME_MAX_DATA_LEN              8
> > @@ -276,6 +280,16 @@ static const struct can_bittiming_const xcan_data_bittiming_const_canfd2 = {
> >       .brp_inc = 1,
> >  };
> >
> > +/* Transmission Delay Compensation constants for CANFD2.0 and Versal  */
> > +static const struct can_tdc_const xcan_tdc_const = {
> > +     .tdcv_min = 0,
> > +     .tdcv_max = 0, /* Manual mode not supported. */
> > +     .tdco_min = 0,
> > +     .tdco_max = 64,
> > +     .tdcf_min = 0, /* Filter window not supported */
> > +     .tdcf_max = 0,
> > +};
> > +
> >  /**
> >   * xcan_write_reg_le - Write a value to the device register little endian
> >   * @priv:    Driver private data structure
> > @@ -424,6 +438,11 @@ static int xcan_set_bittiming(struct net_device *ndev)
> >           priv->devtype.cantype == XAXI_CANFD_2_0) {> >               /* Setting Baud Rate prescalar value in F_BRPR Register */
                                       ^^^^^^^^^
Not related to this patch, but this is a typo. prescalar -> prescaler.

> >               btr0 = dbt->brp - 1;
> > +             if (can_tdc_is_enabled(&priv->can)) {
> > +                     btr0 = btr0 |
>
> Make use of "|=" and properly indent.
>
> > +                     priv->can.tdc.tdco << XCAN_BRPR_TDCO_SHIFT |
>
> Please include <linux/bitfield.h> and make use of "FIELD_PREP".
>
> > +                     XCAN_BRPR_TDC_ENABLE;
> > +             }
> >
> >               /* Setting Time Segment 1 in BTR Register */
> >               btr1 = dbt->prop_seg + dbt->phase_seg1 - 1;
> > @@ -1483,6 +1502,23 @@ static int xcan_get_berr_counter(const struct net_device *ndev,
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
> > +static int xcan_get_auto_tdcv(const struct net_device *ndev, u32 *tdcv)
> > +{
> > +     struct xcan_priv *priv = netdev_priv(ndev);
> > +
> > +     *tdcv = (priv->read_reg(priv, XCAN_SR_OFFSET) & XCAN_SR_TDCV_MASK) >>
> > +              XCAN_SR_TDCV_SHIFT;
>
> Please use FIELD_GET.
>
> > +
> > +     return 0;
> > +}
> > +
> >  static const struct net_device_ops xcan_netdev_ops = {
> >       .ndo_open       = xcan_open,
> >       .ndo_stop       = xcan_close,
> > @@ -1734,18 +1770,22 @@ static int xcan_probe(struct platform_device *pdev)
> >       priv->can.do_get_berr_counter = xcan_get_berr_counter;
> >       priv->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
> >                                       CAN_CTRLMODE_BERR_REPORTING;
> > +     priv->can.do_get_auto_tdcv = xcan_get_auto_tdcv;
>
> I'm not sure, if it has any side effects, if you assign do_get_auto_tdc
> for all controllers, even the ones that don't support it. Vincent can
> probably clarify this.

It should be fine. can_priv::do_get_auto_tdcv() gets called in one
single location in can_tdc_fill_info(). c.f.
https://elixir.bootlin.com/linux/v5.18/source/drivers/net/can/dev/netlink.c#L464

can_tdc_fill_info() returns if can_priv::tdc_const is not populated.
https://elixir.bootlin.com/linux/v5.18/source/drivers/net/can/dev/netlink.c#L438

Below, you only assign tdc_const only for XAXI_CANFD_2_0, so this
should be safe. *BUT*, I do not think this helps for the code
readability so I encourage you to only populate
can_priv::do_get_auto_tdcv() for the controllers which do support TDC.

> >
> >       if (devtype->cantype == XAXI_CANFD)
> >               priv->can.data_bittiming_const =
> >                       &xcan_data_bittiming_const_canfd;
> >
> > -     if (devtype->cantype == XAXI_CANFD_2_0)
> > +     if (devtype->cantype == XAXI_CANFD_2_0) {
> >               priv->can.data_bittiming_const =
> >                       &xcan_data_bittiming_const_canfd2;
> > +             priv->can.tdc_const = &xcan_tdc_const;

Here, you only populate tdc_const for XAXI_CANFD_2_0...

> > +     }
> >
> >       if (devtype->cantype == XAXI_CANFD ||
> >           devtype->cantype == XAXI_CANFD_2_0)
> > -             priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
> > +             priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD |
> > +                                             CAN_CTRLMODE_TDC_AUTO;

...but here, you set the CAN_CTRLMODE_TDC_AUTO for both XAXI_CANFD and
XAXI_CANFD_2_0. Isn’t this a mismatch?

I suggest to have a single if block in which you populate all the TDC
fields at once:
|         if (devtype->cantype == XAXI_CANFD_2_0) {
|                 priv->can.data_bittiming_const =
|                         &xcan_data_bittiming_const_canfd2;
|                 priv->can.tdc_const = &xcan_tdc_const;
|                 priv->can.do_get_auto_tdcv = xcan_get_auto_tdcv;
|                 priv->can.ctrlmode_supported |= CAN_CTRLMODE_TDC_AUTO;
|         }

> >       priv->reg_base = addr;
> >       priv->tx_max = tx_max;


Yours sincerely,
Vincent Mailhol
