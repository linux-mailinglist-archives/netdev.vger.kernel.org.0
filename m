Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57D867F8EB
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbjA1PBG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 28 Jan 2023 10:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjA1PBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:01:04 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E980222F9;
        Sat, 28 Jan 2023 07:01:00 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id o13so7366541pjg.2;
        Sat, 28 Jan 2023 07:01:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yAZMBsWa/6Gj8z0UZm5kYTpyxtgEhS+Ozrwd+/jjUIM=;
        b=OflhhovJCkUfts9+UdX5rYLBzyaA64Fjrdt+TJ84othvYPSoX/LiBcmDsj+3W0aROn
         tewLx1W777uaml17hUPHAiswZbQadA7qhTnRakrBtqqGhEvJpn65t5EDzXV6rKEJN4t0
         snDYoJGACLYDJ3cWr1APPofwkNalEedDemVRIwEXOWz+8hFOwNJfns0gnNObv0fIBB8T
         c8ZGL60zHxcATGGgZh0/NzVsLLBJD8hZvBKuaJFejZII+jEh5Iw25Rz4s0gBohhHh2xH
         ik9V0YoNvePFHV2QARClfLbpZRVCPWSBNFodCB632mwj8nZ5viy5CfyqB2xS1GN+MjSX
         ODMQ==
X-Gm-Message-State: AO0yUKXOnmND8IscOQTLEZpVLDUQ1lT2sNSR8VfZDM9bcJvm7be79W3r
        mbII1m9PML1wDS94NqP/kOp+GxYCunzhTsthCcE=
X-Google-Smtp-Source: AK7set9eoPVelrdKbVjrAyOjFXKRRSXgo2IBG60bOnw6g3xrWlgrjhWBVYTcfShR5SThGspOkMzdlA8UgnRGijUpTfc=
X-Received: by 2002:a17:902:7d8a:b0:196:3232:f49b with SMTP id
 a10-20020a1709027d8a00b001963232f49bmr1928623plm.4.1674918059656; Sat, 28 Jan
 2023 07:00:59 -0800 (PST)
MIME-Version: 1.0
References: <20230125195059.630377-1-msp@baylibre.com> <20230125195059.630377-19-msp@baylibre.com>
In-Reply-To: <20230125195059.630377-19-msp@baylibre.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sun, 29 Jan 2023 00:00:48 +0900
Message-ID: <CAMZ6RqJrCxWTkY1tZKXcXTKSJyQFS9kqgL_JwxL6j99ysY+JgA@mail.gmail.com>
Subject: Re: [PATCH v2 18/18] can: m_can: Implement transmit submission coalescing
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Markus,

I did not have time for a deep review yet. But so far, I didn't find
anything odd aside from two nitpicks.

On Thu. 26 Jan 2023 à 04:53, Markus Schneider-Pargmann
<msp@baylibre.com> a écrit :
>
> m_can supports submitting mulitple transmits with one register write.
                            ^^^^^^^^
multiple

> This is an interesting option to reduce the number of SPI transfers for
> peripheral chips.
>
> The m_can_tx_op is extended with a bool that signals if it is the last
> transmission and the submit should be executed immediately.
>
> The worker then writes the skb to the FIFO and submits it only if the
> submit bool is set. If it isn't set, the worker will write the next skb
> which is waiting in the workqueue to the FIFO, etc.
>
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> ---
>
> Notes:
>     Notes:
>     - I ran into lost messages in the receive FIFO when using this
>       implementation. I guess this only shows up with my test setup in
>       loopback mode and maybe not enough CPU power.
>     - I put this behind the tx-frames ethtool coalescing option as we do
>       wait before submitting packages but it is something different than the
>       tx-frames-irq option. I am not sure if this is the correct option,
>       please let me know.
>
>  drivers/net/can/m_can/m_can.c | 55 ++++++++++++++++++++++++++++++++---
>  drivers/net/can/m_can/m_can.h |  6 ++++
>  2 files changed, 57 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index c6a09369d1aa..99bfcfec3775 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1504,6 +1504,9 @@ static int m_can_start(struct net_device *dev)
>         if (ret)
>                 return ret;
>
> +       netdev_queue_set_dql_min_limit(netdev_get_tx_queue(cdev->net, 0),
> +                                      cdev->tx_max_coalesced_frames);
> +
>         cdev->can.state = CAN_STATE_ERROR_ACTIVE;
>
>         m_can_enable_all_interrupts(cdev);
> @@ -1813,8 +1816,13 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
>                  */
>                 can_put_echo_skb(skb, dev, putidx, frame_len);
>
> -               /* Enable TX FIFO element to start transfer  */
> -               m_can_write(cdev, M_CAN_TXBAR, (1 << putidx));
> +               if (cdev->is_peripheral) {
> +                       /* Delay enabling TX FIFO element */
> +                       cdev->tx_peripheral_submit |= BIT(putidx);
> +               } else {
> +                       /* Enable TX FIFO element to start transfer  */
> +                       m_can_write(cdev, M_CAN_TXBAR, BIT(putidx));
> +               }
>                 cdev->tx_fifo_putidx = (++cdev->tx_fifo_putidx >= cdev->can.echo_skb_max ?
>                                         0 : cdev->tx_fifo_putidx);
>         }
> @@ -1827,6 +1835,17 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
>         return NETDEV_TX_BUSY;
>  }
>
> +static void m_can_tx_submit(struct m_can_classdev *cdev)
> +{
> +       if (cdev->version == 30)
> +               return;
> +       if (!cdev->is_peripheral)
> +               return;
> +
> +       m_can_write(cdev, M_CAN_TXBAR, cdev->tx_peripheral_submit);
> +       cdev->tx_peripheral_submit = 0;
> +}
> +
>  static void m_can_tx_work_queue(struct work_struct *ws)
>  {
>         struct m_can_tx_op *op = container_of(ws, struct m_can_tx_op, work);
> @@ -1835,11 +1854,15 @@ static void m_can_tx_work_queue(struct work_struct *ws)
>
>         op->skb = NULL;
>         m_can_tx_handler(cdev, skb);
> +       if (op->submit)
> +               m_can_tx_submit(cdev);
>  }
>
> -static void m_can_tx_queue_skb(struct m_can_classdev *cdev, struct sk_buff *skb)
> +static void m_can_tx_queue_skb(struct m_can_classdev *cdev, struct sk_buff *skb,
> +                              bool submit)
>  {
>         cdev->tx_ops[cdev->next_tx_op].skb = skb;
> +       cdev->tx_ops[cdev->next_tx_op].submit = submit;
>         queue_work(cdev->tx_wq, &cdev->tx_ops[cdev->next_tx_op].work);
>
>         ++cdev->next_tx_op;
> @@ -1851,6 +1874,7 @@ static netdev_tx_t m_can_start_peripheral_xmit(struct m_can_classdev *cdev,
>                                                struct sk_buff *skb)
>  {
>         netdev_tx_t err;
> +       bool submit;
>
>         if (cdev->can.state == CAN_STATE_BUS_OFF) {
>                 m_can_clean(cdev->net);
> @@ -1861,7 +1885,15 @@ static netdev_tx_t m_can_start_peripheral_xmit(struct m_can_classdev *cdev,
>         if (err != NETDEV_TX_OK)
>                 return err;
>
> -       m_can_tx_queue_skb(cdev, skb);
> +       ++cdev->nr_txs_without_submit;
> +       if (cdev->nr_txs_without_submit >= cdev->tx_max_coalesced_frames ||
> +           !netdev_xmit_more()) {
> +               cdev->nr_txs_without_submit = 0;
> +               submit = true;
> +       } else {
> +               submit = false;
> +       }
> +       m_can_tx_queue_skb(cdev, skb, submit);
>
>         return NETDEV_TX_OK;
>  }
> @@ -1993,6 +2025,7 @@ static int m_can_get_coalesce(struct net_device *dev,
>
>         ec->rx_max_coalesced_frames_irq = cdev->rx_max_coalesced_frames_irq;
>         ec->rx_coalesce_usecs_irq = cdev->rx_coalesce_usecs_irq;
> +       ec->tx_max_coalesced_frames = cdev->tx_max_coalesced_frames;
>         ec->tx_max_coalesced_frames_irq = cdev->tx_max_coalesced_frames_irq;
>         ec->tx_coalesce_usecs_irq = cdev->tx_coalesce_usecs_irq;
>
> @@ -2037,6 +2070,18 @@ static int m_can_set_coalesce(struct net_device *dev,
>                 netdev_err(dev, "tx-frames-irq and tx-usecs-irq can only be set together\n");
>                 return -EINVAL;
>         }
> +       if (ec->tx_max_coalesced_frames > cdev->mcfg[MRAM_TXE].num) {
> +               netdev_err(dev, "tx-frames (%u) greater than the TX event FIFO (%u)\n",
                                             ^^^^
          ^^^^
Avoid parenthesis.
Ref: https://www.kernel.org/doc/html/latest/process/coding-style.html#printing-kernel-messages:

  Printing numbers in parentheses (%d) adds no value and should be avoided.

This comment applies to other patches in the series as well.

> +                          ec->tx_max_coalesced_frames,
> +                          cdev->mcfg[MRAM_TXE].num);
> +               return -EINVAL;
> +       }
> +       if (ec->tx_max_coalesced_frames > cdev->mcfg[MRAM_TXB].num) {
> +               netdev_err(dev, "tx-frames (%u) greater than the TX FIFO (%u)\n",
> +                          ec->tx_max_coalesced_frames,
> +                          cdev->mcfg[MRAM_TXB].num);
> +               return -EINVAL;
> +       }
>         if (ec->rx_coalesce_usecs_irq != 0 && ec->tx_coalesce_usecs_irq != 0 &&
>             ec->rx_coalesce_usecs_irq != ec->tx_coalesce_usecs_irq) {
>                 netdev_err(dev, "rx-usecs-irq (%u) needs to be equal to tx-usecs-irq (%u) if both are enabled\n",
> @@ -2047,6 +2092,7 @@ static int m_can_set_coalesce(struct net_device *dev,
>
>         cdev->rx_max_coalesced_frames_irq = ec->rx_max_coalesced_frames_irq;
>         cdev->rx_coalesce_usecs_irq = ec->rx_coalesce_usecs_irq;
> +       cdev->tx_max_coalesced_frames = ec->tx_max_coalesced_frames;
>         cdev->tx_max_coalesced_frames_irq = ec->tx_max_coalesced_frames_irq;
>         cdev->tx_coalesce_usecs_irq = ec->tx_coalesce_usecs_irq;
>
> @@ -2064,6 +2110,7 @@ static const struct ethtool_ops m_can_ethtool_ops = {
>         .supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS_IRQ |
>                 ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ |
>                 ETHTOOL_COALESCE_TX_USECS_IRQ |
> +               ETHTOOL_COALESCE_TX_MAX_FRAMES |
>                 ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ,
>         .get_ts_info = ethtool_op_get_ts_info,
>         .get_coalesce = m_can_get_coalesce,
> diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
> index bfef2c89e239..e209de81b5a4 100644
> --- a/drivers/net/can/m_can/m_can.h
> +++ b/drivers/net/can/m_can/m_can.h
> @@ -74,6 +74,7 @@ struct m_can_tx_op {
>         struct m_can_classdev *cdev;
>         struct work_struct work;
>         struct sk_buff *skb;
> +       bool submit;
>  };
>
>  struct m_can_classdev {
> @@ -103,6 +104,7 @@ struct m_can_classdev {
>         u32 active_interrupts;
>         u32 rx_max_coalesced_frames_irq;
>         u32 rx_coalesce_usecs_irq;
> +       u32 tx_max_coalesced_frames;
>         u32 tx_max_coalesced_frames_irq;
>         u32 tx_coalesce_usecs_irq;
>
> @@ -117,6 +119,10 @@ struct m_can_classdev {
>         int tx_fifo_size;
>         int next_tx_op;
>
> +       int nr_txs_without_submit;
> +       /* bitfield of fifo elements that will be submitted together */
> +       u32 tx_peripheral_submit;
> +
>         struct mram_cfg mcfg[MRAM_CFG_NUM];
>  };
