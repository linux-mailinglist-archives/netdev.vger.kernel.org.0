Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE9A5A18B3
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242651AbiHYSVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239089AbiHYSV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:21:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993C889839;
        Thu, 25 Aug 2022 11:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E374B82853;
        Thu, 25 Aug 2022 18:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D530DC43144;
        Thu, 25 Aug 2022 18:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661451684;
        bh=wVc03IqlubuXAOqXJ2gmSZKR3a5bbQkXHMLhzFsQke0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=C5OByZVEwUfSkcCh+io9ipi8kZbbneck2aly4OWVja6cACq3yNvDpGiNsL7Q6g3/8
         sev7RHZsIrRo6eLt146i4jwiLiavM5FkKfpXdV8dBIxpQwevameOPiVtj2WJjFnvOB
         ToNf1V2vebnNTZTFWQGIAjF2fCVlQ+E11ETgE/GUb7C8VQ5QThJz9uCJIA6sYhytXS
         adFGnBKMMp8ZhnQU7toyjvcaGkOjPdLKWYy8vbQx/6UTOmIQsSLlLlbHjyVIR2ZzBh
         Vqm6wr74QZnCwLRCx2J5VDJzpYDXcqOtFVUDS/+5Ro3Hwu1Js4JtVUafw7/EPWhVOX
         6dAclr3/5lT0g==
Received: by mail-ed1-f54.google.com with SMTP id s11so27151064edd.13;
        Thu, 25 Aug 2022 11:21:24 -0700 (PDT)
X-Gm-Message-State: ACgBeo0hzc71aA4oSALQAJ/BWGEYWbLojpbYKeC4MDudz2Q4kPUfb+FI
        jzQddelqCFidXatB07L899rpsnIahWrTKZEGMyU=
X-Google-Smtp-Source: AA6agR43BzUtBg/G5aW5QBnzNsvI37mZfgSJ8U+jcWdAWxdZj/Ja5kpYaVwMi1533wDHBuNDlqaXiZHcUtKFhsrxPtM=
X-Received: by 2002:a05:6402:5201:b0:446:cfe7:9f0c with SMTP id
 s1-20020a056402520100b00446cfe79f0cmr4211219edd.16.1661451682918; Thu, 25 Aug
 2022 11:21:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220825134449.18803-1-harald.mommer@opensynergy.com>
In-Reply-To: <20220825134449.18803-1-harald.mommer@opensynergy.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 25 Aug 2022 20:21:06 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1biW1qygRS8Mf0F5n8e6044+W-5v+Gnv+gh+Cyzj-Vjg@mail.gmail.com>
Message-ID: <CAK8P3a1biW1qygRS8Mf0F5n8e6044+W-5v+Gnv+gh+Cyzj-Vjg@mail.gmail.com>
Subject: Re: [virtio-dev] [RFC PATCH 1/1] can: virtio: Initial virtio CAN driver.
To:     Harald Mommer <harald.mommer@opensynergy.com>
Cc:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Harald Mommer <hmo@opensynergy.com>,
        Stratos Mailing List <stratos-dev@op-lists.linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

() b
On Thu, Aug 25, 2022 at 3:44 PM Harald Mommer
<harald.mommer@opensynergy.com> wrote:
>
> - CAN Control
>
>   - "ip link set up can0" starts the virtual CAN controller,
>   - "ip link set up can0" stops the virtual CAN controller
>
> - CAN RX
>
>   Receive CAN frames. CAN frames can be standard or extended, classic or
>   CAN FD. Classic CAN RTR frames are supported.
>
> - CAN TX
>
>   Send CAN frames. CAN frames can be standard or extended, classic or
>   CAN FD. Classic CAN RTR frames are supported.
>
> - CAN Event indication (BusOff)
>
>   The bus off handling is considered code complete but until now bus off
>   handling is largely untested.
>
> Signed-off-by: Harald Mommer <hmo@opensynergy.com>

This looks nice overall, but as you say there is still some work needed in all
the details. I've done a rough first pass at reviewing it, but I have
no specific
understanding of CAN, so these are mostly generic comments about
coding style or network drivers.

>  drivers/net/can/Kconfig                 |    1 +
>  drivers/net/can/Makefile                |    1 +
>  drivers/net/can/virtio_can/Kconfig      |   12 +
>  drivers/net/can/virtio_can/Makefile     |    5 +
>  drivers/net/can/virtio_can/virtio_can.c | 1176 +++++++++++++++++++++++
>  include/uapi/linux/virtio_can.h         |   69 ++

Since the driver is just one file, you probably don't need the subdirectory.

> +struct virtio_can_tx {
> +       struct list_head list;
> +       int prio; /* Currently always 0 "normal priority" */
> +       int putidx;
> +       struct virtio_can_tx_out tx_out;
> +       struct virtio_can_tx_in tx_in;
> +};

Having a linked list of these appears to add a little extra complexity.
If they are always processed in sequence, using an array would be
much simpler, as you just need to remember the index.

> +#ifdef DEBUG
> +static void __attribute__((unused))
> +virtio_can_hexdump(const void *data, size_t length, size_t base)
> +{
> +#define VIRTIO_CAN_MAX_BYTES_PER_LINE 16u

This seems to duplicate print_hex_dump(), maybe just use that?

> +
> +       while (!virtqueue_get_buf(vq, &len) && !virtqueue_is_broken(vq))
> +               cpu_relax();
> +
> +       mutex_unlock(&priv->ctrl_lock);

A busy loop is probably not what you want here. Maybe just
wait_for_completion() until the callback happens?

> +       /* Push loopback echo. Will be looped back on TX interrupt/TX NAPI */
> +       can_put_echo_skb(skb, dev, can_tx_msg->putidx, 0);
> +
> +       err = virtqueue_add_sgs(vq, sgs, 1u, 1u, can_tx_msg, GFP_ATOMIC);
> +       if (err != 0) {
> +               list_del(&can_tx_msg->list);
> +               virtio_can_free_tx_idx(priv, can_tx_msg->prio,
> +                                      can_tx_msg->putidx);
> +               netif_stop_queue(dev);
> +               spin_unlock_irqrestore(&priv->tx_lock, flags);
> +               kfree(can_tx_msg);
> +               if (err == -ENOSPC)
> +                       netdev_info(dev, "TX: Stop queue, no space left\n");
> +               else
> +                       netdev_warn(dev, "TX: Stop queue, reason = %d\n", err);
> +               return NETDEV_TX_BUSY;
> +       }
> +
> +       if (!virtqueue_kick(vq))
> +               netdev_err(dev, "%s(): Kick failed\n", __func__);
> +
> +       spin_unlock_irqrestore(&priv->tx_lock, flags);

There should not be a need for a spinlock or disabling interrupts
in the xmit function. What exactly are you protecting against here?

As a further optimization, you may want to use the xmit_more()
function, as the virtqueue kick is fairly expensive and can be
batched here.

> +       kfree(can_tx_msg);
> +
> +       /* Flow control */
> +       if (netif_queue_stopped(dev)) {
> +               netdev_info(dev, "TX ACK: Wake up stopped queue\n");
> +               netif_wake_queue(dev);
> +       }

You may want to add netdev_sent_queue()/netdev_completed_queue()
based BQL flow control here as well, so you don't have to rely on the
queue filling up completely.

> +static int virtio_can_probe(struct virtio_device *vdev)
> +{
> +       struct net_device *dev;
> +       struct virtio_can_priv *priv;
> +       int err;
> +       unsigned int echo_skb_max;
> +       unsigned int idx;
> +       u16 lo_tx = VIRTIO_CAN_ECHO_SKB_MAX;
> +
> +       BUG_ON(!vdev);

Not a useful debug check, just remove the BUG_ON(!vdev), here and elsewhere

> +
> +       echo_skb_max = lo_tx;
> +       dev = alloc_candev(sizeof(struct virtio_can_priv), echo_skb_max);
> +       if (!dev)
> +               return -ENOMEM;
> +
> +       priv = netdev_priv(dev);
> +
> +       dev_info(&vdev->dev, "echo_skb_max = %u\n", priv->can.echo_skb_max);

Also remove the prints, I assume this is left over from
initial debugging.

> +       priv->can.do_set_mode = virtio_can_set_mode;
> +       priv->can.state = CAN_STATE_STOPPED;
> +       /* Set Virtio CAN supported operations */
> +       priv->can.ctrlmode_supported = CAN_CTRLMODE_BERR_REPORTING;
> +       if (virtio_has_feature(vdev, VIRTIO_CAN_F_CAN_FD)) {
> +               dev_info(&vdev->dev, "CAN FD is supported\n");

> +       } else {
> +               dev_info(&vdev->dev, "CAN FD not supported\n");
> +       }

Same here. There should be a way to see CAN FD support as an interactive
user, but there is no point printing it to the console.

> +
> +       register_virtio_can_dev(dev);
> +
> +       /* Initialize virtqueues */
> +       err = virtio_can_find_vqs(priv);
> +       if (err != 0)
> +               goto on_failure;

Should the register_virtio_can_dev() be done here? I would expect this to be
the last thing after setting up the queues.

> +static struct virtio_driver virtio_can_driver = {
> +       .feature_table = features,
> +       .feature_table_size = ARRAY_SIZE(features),
> +       .feature_table_legacy = NULL,
> +       .feature_table_size_legacy = 0u,
> +       .driver.name =  KBUILD_MODNAME,
> +       .driver.owner = THIS_MODULE,
> +       .id_table =     virtio_can_id_table,
> +       .validate =     virtio_can_validate,
> +       .probe =        virtio_can_probe,
> +       .remove =       virtio_can_remove,
> +       .config_changed = NULL,
> +#ifdef CONFIG_PM_SLEEP
> +       .freeze =       virtio_can_freeze,
> +       .restore =      virtio_can_restore,
> +#endif

You can remove the #ifdef here and above, and replace that with the
pm_sleep_ptr() macro in the assignment.

> diff --git a/include/uapi/linux/virtio_can.h b/include/uapi/linux/virtio_can.h
> new file mode 100644
> index 000000000000..0ca75c7a98ee
> --- /dev/null
> +++ b/include/uapi/linux/virtio_can.h
> @@ -0,0 +1,69 @@
> +/* SPDX-License-Identifier: BSD-3-Clause */
> +/*
> + * Copyright (C) 2021 OpenSynergy GmbH
> + */
> +#ifndef _LINUX_VIRTIO_VIRTIO_CAN_H
> +#define _LINUX_VIRTIO_VIRTIO_CAN_H
> +
> +#include <linux/types.h>
> +#include <linux/virtio_types.h>
> +#include <linux/virtio_ids.h>
> +#include <linux/virtio_config.h>

Maybe a link to the specification here? I assume the definitions in this file
are all lifted from that document, rather than specific to the driver, right?

         Arnd
