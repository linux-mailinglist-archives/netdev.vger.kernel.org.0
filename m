Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B15C6806DE
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 09:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbjA3IFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 03:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjA3IFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 03:05:45 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8DF18AA7
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 00:05:44 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id m2so28808433ejb.8
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 00:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zwWRE+0olfDX1VbFTUqyQdFklO8UyRuhXcXaCE/un2Q=;
        b=nRZoVszSKvNj67fZQpPLOB4CWLrkli8Oes1/BU+PksuTNVUCfY474wvemLaGfzwbaM
         kmN2xwRZ1XtakuWaNeu23EWu5S+CxPALatl41cu4nV7EeqPoZifpLshopqYhdEvfkLwS
         xJo+8aWOZCk4ncMqa8wpQ6jh0bVORrQ6/Od/+rZozOoZQJixTByGvxYGIMWbKzIlVtu+
         yPQL4O1dmZU9QlMPjQWIoUh4ia/4h6I8PFhQwRQqlHydTL/TD+CYAIBrdgboqVy1Yk7L
         7LPfza/rkBAZiibkGVYAOVOev1N81TL4VxoSuhbht7h0ms4JExqQqKlKIFiAtxf7zk63
         c8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zwWRE+0olfDX1VbFTUqyQdFklO8UyRuhXcXaCE/un2Q=;
        b=k3Hx9P5QAfLuyyANcZNaL0Y23Qlfp7A9PIrwbUSMVd7KaMEPJoLE9U3rkoe+Og4tSZ
         AtgG4p0p3R0y0XjBboQDxDvNPq6ZckE7KOFMWnN6sJKBqWdcYoL5+7BFnc3A9tjB8vl7
         rWDkaCJAlPAvWjLdSpoOuAl4sgmTy5VevIDg3055OM+mYCoPH5xjadEYEd8YuypnmriS
         fIz/J0n5d+FjpT+kplKx17uIsy6taKPD9Ah8f6HK+qAtwwX1vJNMNPH1zjTqe9pbQgLe
         9gA6f3Iq85uuXg2H7c+4SmZ+MolB7FgmJ9lHXDejbVDbVeJPF8SeQdCPfDcHjk+btye2
         KTyQ==
X-Gm-Message-State: AO0yUKXfM1EyGAIKrj7+vrFjQNzjzv1tJz+cmj67UekgHnd/OyT4yzIT
        SLm2tOSIbhHZSVSAfJApr08lgg==
X-Google-Smtp-Source: AK7set+6F5Jz5Px+Y5hqS8n5cYswVY+/IFWspfybYl8W0Us4K8lmwKoRgIi2f0235FHZDjMJyfaxPg==
X-Received: by 2002:a17:907:a641:b0:886:5a3d:661b with SMTP id vu1-20020a170907a64100b008865a3d661bmr5843451ejc.57.1675065942497;
        Mon, 30 Jan 2023 00:05:42 -0800 (PST)
Received: from blmsp ([2001:4091:a247:815f:d5ca:514b:67d4:fc9f])
        by smtp.gmail.com with ESMTPSA id v18-20020a1709064e9200b0084c7f96d023sm6533357eju.147.2023.01.30.00.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 00:05:42 -0800 (PST)
Date:   Mon, 30 Jan 2023 09:05:41 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 18/18] can: m_can: Implement transmit submission
 coalescing
Message-ID: <20230130080541.b7lnbc44qrfylyyx@blmsp>
References: <20230125195059.630377-1-msp@baylibre.com>
 <20230125195059.630377-19-msp@baylibre.com>
 <CAMZ6RqJrCxWTkY1tZKXcXTKSJyQFS9kqgL_JwxL6j99ysY+JgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMZ6RqJrCxWTkY1tZKXcXTKSJyQFS9kqgL_JwxL6j99ysY+JgA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

On Sun, Jan 29, 2023 at 12:00:48AM +0900, Vincent MAILHOL wrote:
> Hi Markus,
> 
> I did not have time for a deep review yet. But so far, I didn't find
> anything odd aside from two nitpicks.
> 
> On Thu. 26 Jan 2023 à 04:53, Markus Schneider-Pargmann
> <msp@baylibre.com> a écrit :
> >
> > m_can supports submitting mulitple transmits with one register write.
>                             ^^^^^^^^
> multiple
> 
> > This is an interesting option to reduce the number of SPI transfers for
> > peripheral chips.
> >
> > The m_can_tx_op is extended with a bool that signals if it is the last
> > transmission and the submit should be executed immediately.
> >
> > The worker then writes the skb to the FIFO and submits it only if the
> > submit bool is set. If it isn't set, the worker will write the next skb
> > which is waiting in the workqueue to the FIFO, etc.
> >
> > Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> > ---
> >
> > Notes:
> >     Notes:
> >     - I ran into lost messages in the receive FIFO when using this
> >       implementation. I guess this only shows up with my test setup in
> >       loopback mode and maybe not enough CPU power.
> >     - I put this behind the tx-frames ethtool coalescing option as we do
> >       wait before submitting packages but it is something different than the
> >       tx-frames-irq option. I am not sure if this is the correct option,
> >       please let me know.
> >
> >  drivers/net/can/m_can/m_can.c | 55 ++++++++++++++++++++++++++++++++---
> >  drivers/net/can/m_can/m_can.h |  6 ++++
> >  2 files changed, 57 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> > index c6a09369d1aa..99bfcfec3775 100644
> > --- a/drivers/net/can/m_can/m_can.c
> > +++ b/drivers/net/can/m_can/m_can.c
> > @@ -1504,6 +1504,9 @@ static int m_can_start(struct net_device *dev)
> >         if (ret)
> >                 return ret;
> >
> > +       netdev_queue_set_dql_min_limit(netdev_get_tx_queue(cdev->net, 0),
> > +                                      cdev->tx_max_coalesced_frames);
> > +
> >         cdev->can.state = CAN_STATE_ERROR_ACTIVE;
> >
> >         m_can_enable_all_interrupts(cdev);
> > @@ -1813,8 +1816,13 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
> >                  */
> >                 can_put_echo_skb(skb, dev, putidx, frame_len);
> >
> > -               /* Enable TX FIFO element to start transfer  */
> > -               m_can_write(cdev, M_CAN_TXBAR, (1 << putidx));
> > +               if (cdev->is_peripheral) {
> > +                       /* Delay enabling TX FIFO element */
> > +                       cdev->tx_peripheral_submit |= BIT(putidx);
> > +               } else {
> > +                       /* Enable TX FIFO element to start transfer  */
> > +                       m_can_write(cdev, M_CAN_TXBAR, BIT(putidx));
> > +               }
> >                 cdev->tx_fifo_putidx = (++cdev->tx_fifo_putidx >= cdev->can.echo_skb_max ?
> >                                         0 : cdev->tx_fifo_putidx);
> >         }
> > @@ -1827,6 +1835,17 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
> >         return NETDEV_TX_BUSY;
> >  }
> >
> > +static void m_can_tx_submit(struct m_can_classdev *cdev)
> > +{
> > +       if (cdev->version == 30)
> > +               return;
> > +       if (!cdev->is_peripheral)
> > +               return;
> > +
> > +       m_can_write(cdev, M_CAN_TXBAR, cdev->tx_peripheral_submit);
> > +       cdev->tx_peripheral_submit = 0;
> > +}
> > +
> >  static void m_can_tx_work_queue(struct work_struct *ws)
> >  {
> >         struct m_can_tx_op *op = container_of(ws, struct m_can_tx_op, work);
> > @@ -1835,11 +1854,15 @@ static void m_can_tx_work_queue(struct work_struct *ws)
> >
> >         op->skb = NULL;
> >         m_can_tx_handler(cdev, skb);
> > +       if (op->submit)
> > +               m_can_tx_submit(cdev);
> >  }
> >
> > -static void m_can_tx_queue_skb(struct m_can_classdev *cdev, struct sk_buff *skb)
> > +static void m_can_tx_queue_skb(struct m_can_classdev *cdev, struct sk_buff *skb,
> > +                              bool submit)
> >  {
> >         cdev->tx_ops[cdev->next_tx_op].skb = skb;
> > +       cdev->tx_ops[cdev->next_tx_op].submit = submit;
> >         queue_work(cdev->tx_wq, &cdev->tx_ops[cdev->next_tx_op].work);
> >
> >         ++cdev->next_tx_op;
> > @@ -1851,6 +1874,7 @@ static netdev_tx_t m_can_start_peripheral_xmit(struct m_can_classdev *cdev,
> >                                                struct sk_buff *skb)
> >  {
> >         netdev_tx_t err;
> > +       bool submit;
> >
> >         if (cdev->can.state == CAN_STATE_BUS_OFF) {
> >                 m_can_clean(cdev->net);
> > @@ -1861,7 +1885,15 @@ static netdev_tx_t m_can_start_peripheral_xmit(struct m_can_classdev *cdev,
> >         if (err != NETDEV_TX_OK)
> >                 return err;
> >
> > -       m_can_tx_queue_skb(cdev, skb);
> > +       ++cdev->nr_txs_without_submit;
> > +       if (cdev->nr_txs_without_submit >= cdev->tx_max_coalesced_frames ||
> > +           !netdev_xmit_more()) {
> > +               cdev->nr_txs_without_submit = 0;
> > +               submit = true;
> > +       } else {
> > +               submit = false;
> > +       }
> > +       m_can_tx_queue_skb(cdev, skb, submit);
> >
> >         return NETDEV_TX_OK;
> >  }
> > @@ -1993,6 +2025,7 @@ static int m_can_get_coalesce(struct net_device *dev,
> >
> >         ec->rx_max_coalesced_frames_irq = cdev->rx_max_coalesced_frames_irq;
> >         ec->rx_coalesce_usecs_irq = cdev->rx_coalesce_usecs_irq;
> > +       ec->tx_max_coalesced_frames = cdev->tx_max_coalesced_frames;
> >         ec->tx_max_coalesced_frames_irq = cdev->tx_max_coalesced_frames_irq;
> >         ec->tx_coalesce_usecs_irq = cdev->tx_coalesce_usecs_irq;
> >
> > @@ -2037,6 +2070,18 @@ static int m_can_set_coalesce(struct net_device *dev,
> >                 netdev_err(dev, "tx-frames-irq and tx-usecs-irq can only be set together\n");
> >                 return -EINVAL;
> >         }
> > +       if (ec->tx_max_coalesced_frames > cdev->mcfg[MRAM_TXE].num) {
> > +               netdev_err(dev, "tx-frames (%u) greater than the TX event FIFO (%u)\n",
>                                              ^^^^
>           ^^^^
> Avoid parenthesis.
> Ref: https://www.kernel.org/doc/html/latest/process/coding-style.html#printing-kernel-messages:
> 
>   Printing numbers in parentheses (%d) adds no value and should be avoided.
> 
> This comment applies to other patches in the series as well.

Thank you for having a look and pointing this out, I wasn't aware of
that. I will fix these for the next version.

Best,
Markus

> 
> > +                          ec->tx_max_coalesced_frames,
> > +                          cdev->mcfg[MRAM_TXE].num);
> > +               return -EINVAL;
> > +       }
> > +       if (ec->tx_max_coalesced_frames > cdev->mcfg[MRAM_TXB].num) {
> > +               netdev_err(dev, "tx-frames (%u) greater than the TX FIFO (%u)\n",
> > +                          ec->tx_max_coalesced_frames,
> > +                          cdev->mcfg[MRAM_TXB].num);
> > +               return -EINVAL;
> > +       }
> >         if (ec->rx_coalesce_usecs_irq != 0 && ec->tx_coalesce_usecs_irq != 0 &&
> >             ec->rx_coalesce_usecs_irq != ec->tx_coalesce_usecs_irq) {
> >                 netdev_err(dev, "rx-usecs-irq (%u) needs to be equal to tx-usecs-irq (%u) if both are enabled\n",
> > @@ -2047,6 +2092,7 @@ static int m_can_set_coalesce(struct net_device *dev,
> >
> >         cdev->rx_max_coalesced_frames_irq = ec->rx_max_coalesced_frames_irq;
> >         cdev->rx_coalesce_usecs_irq = ec->rx_coalesce_usecs_irq;
> > +       cdev->tx_max_coalesced_frames = ec->tx_max_coalesced_frames;
> >         cdev->tx_max_coalesced_frames_irq = ec->tx_max_coalesced_frames_irq;
> >         cdev->tx_coalesce_usecs_irq = ec->tx_coalesce_usecs_irq;
> >
> > @@ -2064,6 +2110,7 @@ static const struct ethtool_ops m_can_ethtool_ops = {
> >         .supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS_IRQ |
> >                 ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ |
> >                 ETHTOOL_COALESCE_TX_USECS_IRQ |
> > +               ETHTOOL_COALESCE_TX_MAX_FRAMES |
> >                 ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ,
> >         .get_ts_info = ethtool_op_get_ts_info,
> >         .get_coalesce = m_can_get_coalesce,
> > diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
> > index bfef2c89e239..e209de81b5a4 100644
> > --- a/drivers/net/can/m_can/m_can.h
> > +++ b/drivers/net/can/m_can/m_can.h
> > @@ -74,6 +74,7 @@ struct m_can_tx_op {
> >         struct m_can_classdev *cdev;
> >         struct work_struct work;
> >         struct sk_buff *skb;
> > +       bool submit;
> >  };
> >
> >  struct m_can_classdev {
> > @@ -103,6 +104,7 @@ struct m_can_classdev {
> >         u32 active_interrupts;
> >         u32 rx_max_coalesced_frames_irq;
> >         u32 rx_coalesce_usecs_irq;
> > +       u32 tx_max_coalesced_frames;
> >         u32 tx_max_coalesced_frames_irq;
> >         u32 tx_coalesce_usecs_irq;
> >
> > @@ -117,6 +119,10 @@ struct m_can_classdev {
> >         int tx_fifo_size;
> >         int next_tx_op;
> >
> > +       int nr_txs_without_submit;
> > +       /* bitfield of fifo elements that will be submitted together */
> > +       u32 tx_peripheral_submit;
> > +
> >         struct mram_cfg mcfg[MRAM_CFG_NUM];
> >  };
