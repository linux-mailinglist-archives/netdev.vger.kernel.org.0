Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341EE2AF74D
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 18:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgKKRUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 12:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgKKRUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 12:20:40 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B68C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 09:20:40 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id l12so2679566ilo.1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 09:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W65q5vjU8QIMmPwAqQiSNfKcBSLh45/GQsvO52/9IC8=;
        b=n1CA+jaLLC4Y7hVyZ0VekQLp1ZUhNHqoJv0gqzkFpt7IW/e05FxdS3aJx1jo8oQGqY
         Knf/302YIWX7wvw9Fy6KzkG6q0aXkelh/6JF8wkGlFrOzQOe5jACA0CJ/MR4WZlkg4QS
         3zmI/983kmbyXurPbzpJ3PGWR5DV5E3s3TejVu38lEoHM4ToTFZ7k/LBXgnnFcy7YyzG
         ZrY32ghJ7CgXHdRGLe+cAW/9/4kO9cDsPXnBDpnILds1vqgJTuGT8aQbV3AkmENfMUMC
         gPNdD+FvprjDjND/8k8YLgIbexvPUusS+3Kz83XWFY7oC3+17s9IbAeMIPn2X/oTX6zU
         n0yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W65q5vjU8QIMmPwAqQiSNfKcBSLh45/GQsvO52/9IC8=;
        b=nYnrRlLBDYyxcxL1JgpL9nB4EVdhJgtHv0prr+uNNqbfhA1gg1oYj3O/vpjMLAO+Pk
         eJ9SzbfTbroeqmWZ+jkPpOCf/cons3aXhP7vDURXVEXrRf8zstqtPd1qapFVdFwsHiP/
         +YfdwNV1s1Dedh1qkM/+5+wzV7TkvD1gnRsqZrRwHeli3etQeGXU/mes5ZV40ANvoCvj
         JaxdjjHexWk/WgtD+84AV17KuVcY9Xf944ucWqwY47CW9nts815F82QwGLS7OuoOqFqi
         YXk4WHBR2uSIUZd91w7+2CUl8G+RJ0aMYUUNBcvQZm+wije9qrq75sm7HbwERkpVVZOS
         MlMg==
X-Gm-Message-State: AOAM533L4NFSm5a424HBGm/Djm+3Dh+xsVqFzS4d5Qd4Kg5+qOTZqySS
        QIqGhD0nNp8Nw4Qxp13YN8BM3MKTS1eEPo1CGls=
X-Google-Smtp-Source: ABdhPJxrKhmJly8SuWwHoqMR6MxtfZafxoeLmuhXDip5AGvzWdof9NNPZWiRPGG1H47v8FWVwQO9zxs5XIAscwif8Sg=
X-Received: by 2002:a92:6706:: with SMTP id b6mr20063754ilc.42.1605115239568;
 Wed, 11 Nov 2020 09:20:39 -0800 (PST)
MIME-Version: 1.0
References: <20201109233659.1953461-1-awogbemila@google.com> <20201109233659.1953461-3-awogbemila@google.com>
In-Reply-To: <20201109233659.1953461-3-awogbemila@google.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 11 Nov 2020 09:20:28 -0800
Message-ID: <CAKgT0Ufx7NS0BDwx_egT9-Q9GwbUsBEWiAY8H5YyLFP1h2WQmw@mail.gmail.com>
Subject: Re: [PATCH net-next v6 2/4] gve: Add support for raw addressing to
 the rx path
To:     David Awogbemila <awogbemila@google.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 3:39 PM David Awogbemila <awogbemila@google.com> wrote:
>
> From: Catherine Sullivan <csully@google.com>
>
> Add support to use raw dma addresses in the rx path. Due to this new
> support we can alloc a new buffer instead of making a copy.
>
> RX buffers are handed to the networking stack and are
> re-allocated as needed, avoiding the need to use
> skb_copy_to_linear_data() as in "qpl" mode.
>
> Reviewed-by: Yangchun Fu <yangchun@google.com>
> Signed-off-by: Catherine Sullivan <csully@google.com>
> Signed-off-by: David Awogbemila <awogbemila@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve.h        |   6 +-
>  drivers/net/ethernet/google/gve/gve_adminq.c |  14 +-
>  drivers/net/ethernet/google/gve/gve_desc.h   |  10 +-
>  drivers/net/ethernet/google/gve/gve_main.c   |   3 +-
>  drivers/net/ethernet/google/gve/gve_rx.c     | 224 +++++++++++++++----
>  5 files changed, 200 insertions(+), 57 deletions(-)
>
> diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
> index 80cdae06ee39..a8c589dd14e4 100644
> --- a/drivers/net/ethernet/google/gve/gve.h
> +++ b/drivers/net/ethernet/google/gve/gve.h
> @@ -68,6 +68,7 @@ struct gve_rx_data_queue {
>         dma_addr_t data_bus; /* dma mapping of the slots */
>         struct gve_rx_slot_page_info *page_info; /* page info of the buffers */
>         struct gve_queue_page_list *qpl; /* qpl assigned to this queue */
> +       bool raw_addressing; /* use raw_addressing? */
>  };

Again, if you care about alignment at all in this structure you should
probably use u8 instead of bool.

>
>  struct gve_priv;
> @@ -82,6 +83,7 @@ struct gve_rx_ring {
>         u32 cnt; /* free-running total number of completed packets */
>         u32 fill_cnt; /* free-running total number of descs and buffs posted */
>         u32 mask; /* masks the cnt and fill_cnt to the size of the ring */
> +       u32 db_threshold; /* threshold for posting new buffs and descs */
>         u64 rx_copybreak_pkt; /* free-running count of copybreak packets */
>         u64 rx_copied_pkt; /* free-running total number of copied packets */
>         u64 rx_skb_alloc_fail; /* free-running count of skb alloc fails */
> @@ -194,7 +196,7 @@ struct gve_priv {
>         u16 tx_desc_cnt; /* num desc per ring */
>         u16 rx_desc_cnt; /* num desc per ring */
>         u16 tx_pages_per_qpl; /* tx buffer length */
> -       u16 rx_pages_per_qpl; /* rx buffer length */
> +       u16 rx_data_slot_cnt; /* rx buffer length */
>         u64 max_registered_pages;
>         u64 num_registered_pages; /* num pages registered with NIC */
>         u32 rx_copybreak; /* copy packets smaller than this */
> @@ -444,7 +446,7 @@ static inline u32 gve_num_tx_qpls(struct gve_priv *priv)
>   */
>  static inline u32 gve_num_rx_qpls(struct gve_priv *priv)
>  {
> -       return priv->rx_cfg.num_queues;
> +       return priv->raw_addressing ? 0 : priv->rx_cfg.num_queues;
>  }
>
>  /* Returns a pointer to the next available tx qpl in the list of qpls
> diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
> index 3e6de659b274..711d135c6b1a 100644
> --- a/drivers/net/ethernet/google/gve/gve_adminq.c
> +++ b/drivers/net/ethernet/google/gve/gve_adminq.c
> @@ -369,8 +369,10 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
>  {
>         struct gve_rx_ring *rx = &priv->rx[queue_index];
>         union gve_adminq_command cmd;
> +       u32 qpl_id;
>         int err;
>
> +       qpl_id = priv->raw_addressing ? GVE_RAW_ADDRESSING_QPL_ID : rx->data.qpl->id;
>         memset(&cmd, 0, sizeof(cmd));
>         cmd.opcode = cpu_to_be32(GVE_ADMINQ_CREATE_RX_QUEUE);
>         cmd.create_rx_queue = (struct gve_adminq_create_rx_queue) {
> @@ -381,7 +383,7 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
>                 .queue_resources_addr = cpu_to_be64(rx->q_resources_bus),
>                 .rx_desc_ring_addr = cpu_to_be64(rx->desc.bus),
>                 .rx_data_ring_addr = cpu_to_be64(rx->data.data_bus),
> -               .queue_page_list_id = cpu_to_be32(rx->data.qpl->id),
> +               .queue_page_list_id = cpu_to_be32(qpl_id),
>         };
>
>         err = gve_adminq_issue_cmd(priv, &cmd);
> @@ -526,11 +528,11 @@ int gve_adminq_describe_device(struct gve_priv *priv)
>         mac = descriptor->mac;
>         dev_info(&priv->pdev->dev, "MAC addr: %pM\n", mac);
>         priv->tx_pages_per_qpl = be16_to_cpu(descriptor->tx_pages_per_qpl);
> -       priv->rx_pages_per_qpl = be16_to_cpu(descriptor->rx_pages_per_qpl);
> -       if (priv->rx_pages_per_qpl < priv->rx_desc_cnt) {
> -               dev_err(&priv->pdev->dev, "rx_pages_per_qpl cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
> -                       priv->rx_pages_per_qpl);
> -               priv->rx_desc_cnt = priv->rx_pages_per_qpl;
> +       priv->rx_data_slot_cnt = be16_to_cpu(descriptor->rx_pages_per_qpl);
> +       if (priv->rx_data_slot_cnt < priv->rx_desc_cnt) {
> +               dev_err(&priv->pdev->dev, "rx_data_slot_cnt cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
> +                       priv->rx_data_slot_cnt);
> +               priv->rx_desc_cnt = priv->rx_data_slot_cnt;
>         }
>         priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
>         dev_opt = (void *)(descriptor + 1);
> diff --git a/drivers/net/ethernet/google/gve/gve_desc.h b/drivers/net/ethernet/google/gve/gve_desc.h
> index 54779871d52e..0aad314aefaf 100644
> --- a/drivers/net/ethernet/google/gve/gve_desc.h
> +++ b/drivers/net/ethernet/google/gve/gve_desc.h
> @@ -72,12 +72,14 @@ struct gve_rx_desc {
>  } __packed;
>  static_assert(sizeof(struct gve_rx_desc) == 64);
>
> -/* As with the Tx ring format, the qpl_offset entries below are offsets into an
> - * ordered list of registered pages.
> +/* If the device supports raw dma addressing then the addr in data slot is
> + * the dma address of the buffer.
> + * If the device only supports registered segments than the addr is a byte

s/than/then/

> + * offset into the registered segment (an ordered list of pages) where the
> + * buffer is.
>   */
>  struct gve_rx_data_slot {
> -       /* byte offset into the rx registered segment of this slot */
> -       __be64 qpl_offset;
> +       __be64 addr;
>  };

So this is either the qpl_offset or an address correct? In such a case
shouldn't this be a union? I'm just wanting to make sure that this
isn't something where we are just calling it all addr now even though
there are still cases where it is the qpl_offset.

>  /* GVE Recive Packet Descriptor Seq No */
> diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
> index 70685c10db0e..225e17dd1ae5 100644
> --- a/drivers/net/ethernet/google/gve/gve_main.c
> +++ b/drivers/net/ethernet/google/gve/gve_main.c
> @@ -596,6 +596,7 @@ int gve_alloc_page(struct gve_priv *priv, struct device *dev,
>         if (dma_mapping_error(dev, *dma)) {
>                 priv->dma_mapping_error++;
>                 put_page(*page);
> +               *page = NULL;
>                 return -ENOMEM;
>         }
>         return 0;

This piece seems like a bug fix for the exception handling path.
Should it be pulled out into a separate patch so that it could be
backported if needed.

> @@ -694,7 +695,7 @@ static int gve_alloc_qpls(struct gve_priv *priv)
>         }
>         for (; i < num_qpls; i++) {
>                 err = gve_alloc_queue_page_list(priv, i,
> -                                               priv->rx_pages_per_qpl);
> +                                               priv->rx_data_slot_cnt);
>                 if (err)
>                         goto free_qpls;
>         }
> diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
> index 008fa897a3e6..49646caf930c 100644
> --- a/drivers/net/ethernet/google/gve/gve_rx.c
> +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> @@ -16,12 +16,39 @@ static void gve_rx_remove_from_block(struct gve_priv *priv, int queue_idx)
>         block->rx = NULL;
>  }
>
> +static void gve_rx_free_buffer(struct device *dev,
> +                              struct gve_rx_slot_page_info *page_info,
> +                              struct gve_rx_data_slot *data_slot)
> +{
> +       dma_addr_t dma = (dma_addr_t)(be64_to_cpu(data_slot->addr) -
> +                                     page_info->page_offset);
> +

Why bother with subtraction when you are adding the page offset via an
xor? It seems like you should be able to just mask off the page offset
and not need to bother to store it anywhere. Either the DMA address is
page aligned in which case you can xor in and out the value and just
use an &= operator to strip it, or it isn't in which case you should
be using addition and subtraction everywhere and only bitflip page
offset as a single bit somewhere.

> +       gve_free_page(dev, page_info->page, dma, DMA_FROM_DEVICE);
> +}
> +
> +static void gve_rx_unfill_pages(struct gve_priv *priv, struct gve_rx_ring *rx)
> +{
> +       u32 slots = rx->mask + 1;
> +       int i;
> +
> +       if (rx->data.raw_addressing) {

The declaration of slots and I could be moved here since they aren't
used anywhere else in this function.

> +               for (i = 0; i < slots; i++)
> +                       gve_rx_free_buffer(&priv->pdev->dev, &rx->data.page_info[i],
> +                                          &rx->data.data_ring[i]);
> +       } else {
> +               gve_unassign_qpl(priv, rx->data.qpl->id);
> +               rx->data.qpl = NULL;
> +       }
> +       kvfree(rx->data.page_info);
> +       rx->data.page_info = NULL;
> +}
> +
>  static void gve_rx_free_ring(struct gve_priv *priv, int idx)
>  {
>         struct gve_rx_ring *rx = &priv->rx[idx];
>         struct device *dev = &priv->pdev->dev;
> +       u32 slots = rx->mask + 1;
>         size_t bytes;
> -       u32 slots;
>
>         gve_rx_remove_from_block(priv, idx);
>
> @@ -33,11 +60,8 @@ static void gve_rx_free_ring(struct gve_priv *priv, int idx)
>                           rx->q_resources, rx->q_resources_bus);
>         rx->q_resources = NULL;
>
> -       gve_unassign_qpl(priv, rx->data.qpl->id);
> -       rx->data.qpl = NULL;
> -       kvfree(rx->data.page_info);
> +       gve_rx_unfill_pages(priv, rx);
>
> -       slots = rx->mask + 1;
>         bytes = sizeof(*rx->data.data_ring) * slots;
>         dma_free_coherent(dev, bytes, rx->data.data_ring,
>                           rx->data.data_bus);
> @@ -52,14 +76,36 @@ static void gve_setup_rx_buffer(struct gve_rx_slot_page_info *page_info,
>         page_info->page = page;
>         page_info->page_offset = 0;
>         page_info->page_address = page_address(page);
> -       slot->qpl_offset = cpu_to_be64(addr);
> +       slot->addr = cpu_to_be64(addr);
> +}
> +
> +static int gve_rx_alloc_buffer(struct gve_priv *priv, struct device *dev,
> +                              struct gve_rx_slot_page_info *page_info,
> +                              struct gve_rx_data_slot *data_slot,
> +                              struct gve_rx_ring *rx)
> +{
> +       struct page *page;
> +       dma_addr_t dma;
> +       int err;
> +
> +       err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE);
> +       if (err) {
> +               u64_stats_update_begin(&rx->statss);
> +               rx->rx_buf_alloc_fail++;
> +               u64_stats_update_end(&rx->statss);
> +               return err;
> +       }

This just feels really clumsy to me. Do the stats really need to be
invoked in all cases? It seems like you could pull this code out and
put it in an exception path somewhere rather than in the middle of the
function. That way you don't need to carry around the rx ring which
isn't used for anything else. So for example when you are prefilling
the buffers it looks like you are already returning an error to the
user. In such a case the stats update might be redundant as the
interface wasn't allowed to come up in the first place.

> +
> +       gve_setup_rx_buffer(page_info, data_slot, dma, page);
> +       return 0;
>  }
>
>  static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
>  {
>         struct gve_priv *priv = rx->gve;
>         u32 slots;
> -       int i;
> +       int err;
> +       int i, j;
>
>         /* Allocate one page per Rx queue slot. Each page is split into two
>          * packet buffers, when possible we "page flip" between the two.
> @@ -71,17 +117,32 @@ static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
>         if (!rx->data.page_info)
>                 return -ENOMEM;
>
> -       rx->data.qpl = gve_assign_rx_qpl(priv);
> -
> +       if (!rx->data.raw_addressing)
> +               rx->data.qpl = gve_assign_rx_qpl(priv);
>         for (i = 0; i < slots; i++) {
> -               struct page *page = rx->data.qpl->pages[i];
> -               dma_addr_t addr = i * PAGE_SIZE;
> -
> -               gve_setup_rx_buffer(&rx->data.page_info[i],
> -                                   &rx->data.data_ring[i], addr, page);
> +               struct page *page;
> +               dma_addr_t addr;
> +
> +               if (!rx->data.raw_addressing) {
> +                       page = rx->data.qpl->pages[i];
> +                       addr = i * PAGE_SIZE;
> +                       gve_setup_rx_buffer(&rx->data.page_info[i],
> +                                           &rx->data.data_ring[i], addr, page);
> +                       continue;
> +               }
> +               err = gve_rx_alloc_buffer(priv, &priv->pdev->dev, &rx->data.page_info[i],
> +                                         &rx->data.data_ring[i], rx);
> +               if (err)
> +                       goto alloc_err;
>         }
>
>         return slots;
> +alloc_err:
> +       for (j = 0; j < i; j++)
> +               gve_rx_free_buffer(&priv->pdev->dev,
> +                                  &rx->data.page_info[j],
> +                                  &rx->data.data_ring[j]);

Instead of adding another variable you could just change this loop to
be based on "while(i--)" and then use i as you work your way backwards
through buffers you previously allocated.

> +       return err;
>  }
>
>  static void gve_rx_add_to_block(struct gve_priv *priv, int queue_idx)
> @@ -110,8 +171,9 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
>         rx->gve = priv;
>         rx->q_num = idx;
>
> -       slots = priv->rx_pages_per_qpl;
> +       slots = priv->rx_data_slot_cnt;
>         rx->mask = slots - 1;
> +       rx->data.raw_addressing = priv->raw_addressing;
>
>         /* alloc rx data ring */
>         bytes = sizeof(*rx->data.data_ring) * slots;
> @@ -156,8 +218,8 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
>                 err = -ENOMEM;
>                 goto abort_with_q_resources;
>         }
> -       rx->mask = slots - 1;
>         rx->cnt = 0;
> +       rx->db_threshold = priv->rx_desc_cnt / 2;
>         rx->desc.seqno = 1;
>         gve_rx_add_to_block(priv, idx);
>
> @@ -168,7 +230,7 @@ static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
>                           rx->q_resources, rx->q_resources_bus);
>         rx->q_resources = NULL;
>  abort_filled:
> -       kvfree(rx->data.page_info);
> +       gve_rx_unfill_pages(priv, rx);
>  abort_with_slots:
>         bytes = sizeof(*rx->data.data_ring) * slots;
>         dma_free_coherent(hdev, bytes, rx->data.data_ring, rx->data.data_bus);
> @@ -251,8 +313,7 @@ static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
>         return skb;
>  }
>
> -static struct sk_buff *gve_rx_add_frags(struct net_device *dev,
> -                                       struct napi_struct *napi,
> +static struct sk_buff *gve_rx_add_frags(struct napi_struct *napi,
>                                         struct gve_rx_slot_page_info *page_info,
>                                         u16 len)
>  {
> @@ -271,11 +332,25 @@ static struct sk_buff *gve_rx_add_frags(struct net_device *dev,
>  static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info,
>                              struct gve_rx_data_slot *data_ring)
>  {
> -       u64 addr = be64_to_cpu(data_ring->qpl_offset);
> +       u64 addr = be64_to_cpu(data_ring->addr);
>
>         page_info->page_offset ^= PAGE_SIZE / 2;
>         addr ^= PAGE_SIZE / 2;
> -       data_ring->qpl_offset = cpu_to_be64(addr);
> +       data_ring->addr = cpu_to_be64(addr);

This code is far more inefficient than it needs to be. Instead of byte
swapping addr it should be byte swapping PAGE_SIZE / 2 since it is a
constant. A bitwise operation should work fine as long as you are only
performing it on two be64 values.

Also as I mentioned before if you are just using the xor on the
address directly then you don't need the page offset as you can use a
mask to pull it out of the addr.

> +}
> +
> +static struct sk_buff *
> +gve_rx_raw_addressing(struct device *dev, struct net_device *netdev,
> +                     struct gve_rx_slot_page_info *page_info, u16 len,
> +                     struct napi_struct *napi,
> +                     struct gve_rx_data_slot *data_slot)
> +{
> +       struct sk_buff *skb = gve_rx_add_frags(napi, page_info, len);
> +
> +       if (!skb)
> +               return NULL;
> +
> +       return skb;
>  }
>

I'm not sure I see the point of this function. It seems like you
should just replace all references to it with gve_rx_add_frags until
you actually have something else going on here. I am assuming this is
addressed in a later patch.


>  static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
> @@ -285,7 +360,9 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
>         struct gve_priv *priv = rx->gve;
>         struct napi_struct *napi = &priv->ntfy_blocks[rx->ntfy_id].napi;
>         struct net_device *dev = priv->dev;
> -       struct sk_buff *skb;
> +       struct gve_rx_data_slot *data_slot;
> +       struct sk_buff *skb = NULL;
> +       dma_addr_t page_bus;
>         int pagecount;
>         u16 len;
>
> @@ -294,18 +371,18 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
>                 u64_stats_update_begin(&rx->statss);
>                 rx->rx_desc_err_dropped_pkt++;
>                 u64_stats_update_end(&rx->statss);
> -               return true;
> +               return false;
>         }
>
>         len = be16_to_cpu(rx_desc->len) - GVE_RX_PAD;
>         page_info = &rx->data.page_info[idx];
> -       dma_sync_single_for_cpu(&priv->pdev->dev, rx->data.qpl->page_buses[idx],
> -                               PAGE_SIZE, DMA_FROM_DEVICE);
>
> -       /* gvnic can only receive into registered segments. If the buffer
> -        * can't be recycled, our only choice is to copy the data out of
> -        * it so that we can return it to the device.
> -        */
> +       data_slot = &rx->data.data_ring[idx];
> +       page_bus = (rx->data.raw_addressing) ?
> +                                       be64_to_cpu(data_slot->addr) - page_info->page_offset :
> +                                       rx->data.qpl->page_buses[idx];
> +       dma_sync_single_for_cpu(&priv->pdev->dev, page_bus,
> +                               PAGE_SIZE, DMA_FROM_DEVICE);
>
>         if (PAGE_SIZE == 4096) {
>                 if (len <= priv->rx_copybreak) {
> @@ -316,6 +393,12 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
>                         u64_stats_update_end(&rx->statss);
>                         goto have_skb;
>                 }
> +               if (rx->data.raw_addressing) {
> +                       skb = gve_rx_raw_addressing(&priv->pdev->dev, dev,
> +                                                   page_info, len, napi,
> +                                                    data_slot);
> +                       goto have_skb;
> +               }
>                 if (unlikely(!gve_can_recycle_pages(dev))) {
>                         skb = gve_rx_copy(rx, dev, napi, page_info, len);
>                         goto have_skb;
> @@ -326,12 +409,12 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
>                          * the page fragment to a new SKB and pass it up the
>                          * stack.
>                          */
> -                       skb = gve_rx_add_frags(dev, napi, page_info, len);
> +                       skb = gve_rx_add_frags(napi, page_info, len);
>                         if (!skb) {
>                                 u64_stats_update_begin(&rx->statss);
>                                 rx->rx_skb_alloc_fail++;
>                                 u64_stats_update_end(&rx->statss);
> -                               return true;
> +                               return false;
>                         }
>                         /* Make sure the kernel stack can't release the page */
>                         get_page(page_info->page);
> @@ -347,7 +430,12 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
>                         return false;
>                 }
>         } else {
> -               skb = gve_rx_copy(rx, dev, napi, page_info, len);
> +               if (rx->data.raw_addressing)
> +                       skb = gve_rx_raw_addressing(&priv->pdev->dev, dev,
> +                                                   page_info, len, napi,
> +                                                   data_slot);
> +               else
> +                       skb = gve_rx_copy(rx, dev, napi, page_info, len);
>         }
>
>  have_skb:
> @@ -358,7 +446,7 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
>                 u64_stats_update_begin(&rx->statss);
>                 rx->rx_skb_alloc_fail++;
>                 u64_stats_update_end(&rx->statss);
> -               return true;
> +               return false;
>         }
>
>         if (likely(feat & NETIF_F_RXCSUM)) {
> @@ -399,19 +487,45 @@ static bool gve_rx_work_pending(struct gve_rx_ring *rx)
>         return (GVE_SEQNO(flags_seq) == rx->desc.seqno);
>  }
>
> +static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
> +{
> +       bool empty = rx->fill_cnt == rx->cnt;
> +       u32 fill_cnt = rx->fill_cnt;
> +
> +       while (empty || ((fill_cnt & rx->mask) != (rx->cnt & rx->mask))) {

So one question I would have is why do you need to mask fill_cnt and
cnt here, but not above? Something doesn't match up.

> +               struct gve_rx_slot_page_info *page_info;
> +               struct device *dev = &priv->pdev->dev;
> +               struct gve_rx_data_slot *data_slot;
> +               u32 idx = fill_cnt & rx->mask;
> +
> +               page_info = &rx->data.page_info[idx];
> +               data_slot = &rx->data.data_ring[idx];
> +               gve_rx_free_buffer(dev, page_info, data_slot);
> +               page_info->page = NULL;
> +               if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot, rx))
> +                       break;
> +               empty = false;
> +               fill_cnt++;
> +       }
> +       rx->fill_cnt = fill_cnt;
> +       return true;
> +}
> +
>  bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
>                        netdev_features_t feat)
>  {
>         struct gve_priv *priv = rx->gve;
> +       u32 work_done = 0, packets = 0;
>         struct gve_rx_desc *desc;
>         u32 cnt = rx->cnt;
>         u32 idx = cnt & rx->mask;
> -       u32 work_done = 0;
>         u64 bytes = 0;
>
>         desc = rx->desc.desc_ring + idx;
>         while ((GVE_SEQNO(desc->flags_seq) == rx->desc.seqno) &&
>                work_done < budget) {
> +               bool dropped;
> +
>                 netif_info(priv, rx_status, priv->dev,
>                            "[%d] idx=%d desc=%p desc->flags_seq=0x%x\n",
>                            rx->q_num, idx, desc, desc->flags_seq);
> @@ -419,9 +533,11 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
>                            "[%d] seqno=%d rx->desc.seqno=%d\n",
>                            rx->q_num, GVE_SEQNO(desc->flags_seq),
>                            rx->desc.seqno);
> -               bytes += be16_to_cpu(desc->len) - GVE_RX_PAD;
> -               if (!gve_rx(rx, desc, feat, idx))
> -                       gve_schedule_reset(priv);
> +               dropped = !gve_rx(rx, desc, feat, idx);
> +               if (!dropped) {
> +                       bytes += be16_to_cpu(desc->len) - GVE_RX_PAD;
> +                       packets++;
> +               }
>                 cnt++;
>                 idx = cnt & rx->mask;
>                 desc = rx->desc.desc_ring + idx;
> @@ -429,15 +545,35 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
>                 work_done++;
>         }
>
> -       if (!work_done)
> +       if (!work_done && rx->fill_cnt - cnt > rx->db_threshold) {
>                 return false;

Since you are returning here you don't really need the else below. You
can just drop the braces and use an if instead. However since
everything you are doing here can be done even if work_done is 0 I
would say to just drop the elseif entirely and instead leave the code
as it was.

> +       } else if (work_done) {
> +               u64_stats_update_begin(&rx->statss);
> +               rx->rpackets += packets;
> +               rx->rbytes += bytes;
> +               u64_stats_update_end(&rx->statss);
> +               rx->cnt = cnt;
> +       }

The block below seems much better than optimizing for an unlikely case
where there is no work done.


> -       u64_stats_update_begin(&rx->statss);
> -       rx->rpackets += work_done;
> -       rx->rbytes += bytes;
> -       u64_stats_update_end(&rx->statss);
> -       rx->cnt = cnt;
> -       rx->fill_cnt += work_done;
> +       /* restock ring slots */
> +       if (!rx->data.raw_addressing) {
> +               /* In QPL mode buffs are refilled as the desc are processed */
> +               rx->fill_cnt += work_done;
> +       } else if (rx->fill_cnt - cnt <= rx->db_threshold) {
> +               /* In raw addressing mode buffs are only refilled if the avail
> +                * falls below a threshold.
> +                */
> +               if (!gve_rx_refill_buffers(priv, rx))
> +                       return false;
> +
> +               /* If we were not able to completely refill buffers, we'll want
> +                * to schedule this queue for work again to refill buffers.
> +                */
> +               if (rx->fill_cnt - cnt <= rx->db_threshold) {
> +                       gve_rx_write_doorbell(priv, rx);
> +                       return true;
> +               }
> +       }
>
>         gve_rx_write_doorbell(priv, rx);
>         return gve_rx_work_pending(rx);
> --
> 2.29.2.222.g5d2a92d10f8-goog
>
