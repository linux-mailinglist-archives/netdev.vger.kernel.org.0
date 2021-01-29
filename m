Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558F9308FDC
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 23:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbhA2WMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 17:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbhA2WMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 17:12:39 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C2CC06174A;
        Fri, 29 Jan 2021 14:11:58 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id bl23so15136493ejb.5;
        Fri, 29 Jan 2021 14:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cXyr/v9qWIo4HYAvBPFXOSn8P1D1cMwUipH5grrma0A=;
        b=K4QHfhlxFsRWrtQRUalbbkEAThcI8Phkq/NUFE2a+xsHYrjlNGbio960rdqBdwmNG1
         x++M6y/ZSlwUmlU/Yirk9DQANEjRfAZP8vTLi7FRZB9SLA3cgXvf3rkJXbxeZXXkUi7u
         +9MuxgbvNPuQzuYhnpWSZo/qVdrR+rXaA8HJpqG0W3qS5RJM5racLswPkVKLFmvez4sN
         wtIXqkFIx1Erbmij8Fa3MtAfU2o7sYTlr0pbvaZJTwksrFfLgEtTBS5EVsGQv2WvLd5U
         538Ou4IvmvTGtGtVBLOmIRmqxYmkK+GMzp48709ChW6mDCDLYCAuIGFMhoHPejLz8Xe9
         H4Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cXyr/v9qWIo4HYAvBPFXOSn8P1D1cMwUipH5grrma0A=;
        b=kb6+2leJdeab4UnHTiNA9qD6S028bTxdouIopA+uG1mZUxxUrlw8cvuMACnHB8nNut
         fgXmLYcWRlcKBnF4pNJsxSrOw5mg4gZvjALQgI/nHqSBJtS2tmvugs33zkQVmW0naHBy
         60Kq7Epvd9+WKPEHeCwew56S5Na6DX16W8Cc8Oj0QMePdgMMZSfEppa+xI+V9UwXFpUR
         Kiv74Z294Et/YCIEwBwJVohcovbstXR2Aat4Dmz7aCqG4QNvond0mkUfmWZDUZ+a619q
         v9Qn0MU4nxReDOX43NCTKJb4sffmby7lc9jAQ5+lnGlZxqfW3XtXDFdakBeT56Uaumik
         vNnw==
X-Gm-Message-State: AOAM532/mkfzljJSLZcRSW5qGenGwOZmBs0t/BDgHbMhqS5W1siyW9r5
        AWPzWkXbqus2ASVaAdDdlBpILSz9UzLzq1TU6AM=
X-Google-Smtp-Source: ABdhPJyYrR1ZY6qoXbxk+gFkkR+wSG+PRANN9VrtPaouhr9YOOM2cxs0xY+ACs6UXJgV7u+PpF3FmJ63xQoln6mMhZE=
X-Received: by 2002:a17:906:3f8d:: with SMTP id b13mr6460747ejj.464.1611958317342;
 Fri, 29 Jan 2021 14:11:57 -0800 (PST)
MIME-Version: 1.0
References: <20210129195240.31871-1-TheSven73@gmail.com> <20210129195240.31871-3-TheSven73@gmail.com>
In-Reply-To: <20210129195240.31871-3-TheSven73@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 29 Jan 2021 17:11:20 -0500
Message-ID: <CAF=yD-KBc=1SvpLET_NKjdaCTUP4r6P9hRU8QteBkw6W3qeP_A@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/6] lan743x: support rx multi-buffer packets
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com, David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Anders_R=C3=B8nningen?= <anders@ronningen.priv.no>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 2:56 PM Sven Van Asbroeck <thesven73@gmail.com> wro=
te:
>
> From: Sven Van Asbroeck <thesven73@gmail.com>
>
> Multi-buffer packets enable us to use rx ring buffers smaller than
> the mtu. This will allow us to change the mtu on-the-fly, without
> having to stop the network interface in order to re-size the rx
> ring buffers.
>
> This is a big change touching a key driver function (process_packet),
> so care has been taken to test this extensively:
>
> Tests with debug logging enabled (add #define DEBUG).
>
> 1. Limit rx buffer size to 500, so mtu (1500) takes 3 buffers.
>    Ping to chip, verify correct packet size is sent to OS.
>    Ping large packets to chip (ping -s 1400), verify correct
>      packet size is sent to OS.
>    Ping using packets around the buffer size, verify number of
>      buffers is changing, verify correct packet size is sent
>      to OS:
>      $ ping -s 472
>      $ ping -s 473
>      $ ping -s 992
>      $ ping -s 993
>    Verify that each packet is followed by extension processing.
>
> 2. Limit rx buffer size to 500, so mtu (1500) takes 3 buffers.
>    Run iperf3 -s on chip, verify that packets come in 3 buffers
>      at a time.
>    Verify that packet size is equal to mtu.
>    Verify that each packet is followed by extension processing.
>
> 3. Set chip and host mtu to 2000.
>    Limit rx buffer size to 500, so mtu (2000) takes 4 buffers.
>    Run iperf3 -s on chip, verify that packets come in 4 buffers
>      at a time.
>    Verify that packet size is equal to mtu.
>    Verify that each packet is followed by extension processing.
>
> Tests with debug logging DISabled (remove #define DEBUG).
>
> 4. Limit rx buffer size to 500, so mtu (1500) takes 3 buffers.
>    Run iperf3 -s on chip, note sustained rx speed.
>    Set chip and host mtu to 2000, so mtu takes 4 buffers.
>    Run iperf3 -s on chip, note sustained rx speed.
>    Verify no packets are dropped in both cases.
>
> Tests with DEBUG_KMEMLEAK on:
>  $ mount -t debugfs nodev /sys/kernel/debug/
>  $ echo scan > /sys/kernel/debug/kmemleak
>
> 5. Limit rx buffer size to 500, so mtu (1500) takes 3 buffers.
>    Run the following tests concurrently for at least one hour:
>    - iperf3 -s on chip
>    - ping -> chip
>    Monitor reported memory leaks.
>
> 6. Set chip and host mtu to 2000.
>    Limit rx buffer size to 500, so mtu (2000) takes 4 buffers.
>    Run the following tests concurrently for at least one hour:
>    - iperf3 -s on chip
>    - ping -> chip
>    Monitor reported memory leaks.
>
> 7. Simulate low-memory in lan743x_rx_allocate_skb(): fail every
>      100 allocations.
>    Repeat (5) and (6).
>    Monitor reported memory leaks.
>
> 8. Simulate  low-memory in lan743x_rx_allocate_skb(): fail 10
>      allocations in a row in every 100.
>    Repeat (5) and (6).
>    Monitor reported memory leaks.
>
> 9. Simulate  low-memory in lan743x_rx_trim_skb(): fail 1 allocation
>      in every 100.
>    Repeat (5) and (6).
>    Monitor reported memory leaks.
>
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> ---
>
> Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git # =
46eb3c108fe1
>
> To: Bryan Whitehead <bryan.whitehead@microchip.com>
> To: UNGLinuxDriver@microchip.com
> To: "David S. Miller" <davem@davemloft.net>
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Alexey Denisov <rtgbnm@gmail.com>
> Cc: Sergej Bauer <sbauer@blackbox.su>
> Cc: Tim Harvey <tharvey@gateworks.com>
> Cc: Anders R=C3=B8nningen <anders@ronningen.priv.no>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org (open list)
>
>  drivers/net/ethernet/microchip/lan743x_main.c | 321 ++++++++----------
>  drivers/net/ethernet/microchip/lan743x_main.h |   2 +
>  2 files changed, 143 insertions(+), 180 deletions(-)


> +static struct sk_buff *
> +lan743x_rx_trim_skb(struct sk_buff *skb, int frame_length)
> +{
> +       if (skb_linearize(skb)) {

Is this needed? That will be quite expensive

> +               dev_kfree_skb_irq(skb);
> +               return NULL;
> +       }
> +       frame_length =3D max_t(int, 0, frame_length - RX_HEAD_PADDING - 2=
);
> +       if (skb->len > frame_length) {
> +               skb->tail -=3D skb->len - frame_length;
> +               skb->len =3D frame_length;
> +       }
> +       return skb;
> +}
> +
>  static int lan743x_rx_process_packet(struct lan743x_rx *rx)
>  {
> -       struct skb_shared_hwtstamps *hwtstamps =3D NULL;
> +       struct lan743x_rx_descriptor *descriptor, *desc_ext;
>         int result =3D RX_PROCESS_RESULT_NOTHING_TO_DO;
>         int current_head_index =3D le32_to_cpu(*rx->head_cpu_ptr);
>         struct lan743x_rx_buffer_info *buffer_info;
> -       struct lan743x_rx_descriptor *descriptor;
> +       struct skb_shared_hwtstamps *hwtstamps;
> +       int frame_length, buffer_length;
> +       struct sk_buff *skb;
>         int extension_index =3D -1;
> -       int first_index =3D -1;
> -       int last_index =3D -1;
> +       bool is_last, is_first;
>
>         if (current_head_index < 0 || current_head_index >=3D rx->ring_si=
ze)
>                 goto done;
> @@ -2068,170 +2075,126 @@ static int lan743x_rx_process_packet(struct lan=
743x_rx *rx)
>         if (rx->last_head < 0 || rx->last_head >=3D rx->ring_size)
>                 goto done;
>
> -       if (rx->last_head !=3D current_head_index) {
> -               descriptor =3D &rx->ring_cpu_ptr[rx->last_head];
> -               if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_OWN_)
> -                       goto done;
> +       if (rx->last_head =3D=3D current_head_index)
> +               goto done;

Is it possible to avoid the large indentation change, or else do that
in a separate patch? It makes it harder to follow the functional
change.

>
> -               if (!(le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_FS_)=
)
> -                       goto done;
> +       descriptor =3D &rx->ring_cpu_ptr[rx->last_head];
> +       if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_OWN_)
> +               goto done;
> +       buffer_info =3D &rx->buffer_info[rx->last_head];
>
> -               first_index =3D rx->last_head;
> -               if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_LS_) {
> -                       last_index =3D rx->last_head;
> -               } else {
> -                       int index;
> -
> -                       index =3D lan743x_rx_next_index(rx, first_index);
> -                       while (index !=3D current_head_index) {
> -                               descriptor =3D &rx->ring_cpu_ptr[index];
> -                               if (le32_to_cpu(descriptor->data0) & RX_D=
ESC_DATA0_OWN_)
> -                                       goto done;
> -
> -                               if (le32_to_cpu(descriptor->data0) & RX_D=
ESC_DATA0_LS_) {
> -                                       last_index =3D index;
> -                                       break;
> -                               }
> -                               index =3D lan743x_rx_next_index(rx, index=
);
> -                       }
> -               }
> -               if (last_index >=3D 0) {
> -                       descriptor =3D &rx->ring_cpu_ptr[last_index];
> -                       if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA=
0_EXT_) {
> -                               /* extension is expected to follow */
> -                               int index =3D lan743x_rx_next_index(rx,
> -                                                                 last_in=
dex);
> -                               if (index !=3D current_head_index) {
> -                                       descriptor =3D &rx->ring_cpu_ptr[=
index];
> -                                       if (le32_to_cpu(descriptor->data0=
) &
> -                                           RX_DESC_DATA0_OWN_) {
> -                                               goto done;
> -                                       }
> -                                       if (le32_to_cpu(descriptor->data0=
) &
> -                                           RX_DESC_DATA0_EXT_) {
> -                                               extension_index =3D index=
;
> -                                       } else {
> -                                               goto done;
> -                                       }
> -                               } else {
> -                                       /* extension is not yet available=
 */
> -                                       /* prevent processing of this pac=
ket */
> -                                       first_index =3D -1;
> -                                       last_index =3D -1;
> -                               }
> -                       }
> -               }
> +       is_last =3D le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_LS_;
> +       is_first =3D le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_FS_;
> +
> +       if (is_last && le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_EXT=
_) {
> +               /* extension is expected to follow */
> +               int index =3D lan743x_rx_next_index(rx, rx->last_head);
> +
> +               if (index =3D=3D current_head_index)
> +                       /* extension not yet available */
> +                       goto done;
> +               desc_ext =3D &rx->ring_cpu_ptr[index];
> +               if (le32_to_cpu(desc_ext->data0) & RX_DESC_DATA0_OWN_)
> +                       /* extension not yet available */
> +                       goto done;
> +               if (!(le32_to_cpu(desc_ext->data0) & RX_DESC_DATA0_EXT_))
> +                       goto move_forward;
> +               extension_index =3D index;
>         }
> -       if (first_index >=3D 0 && last_index >=3D 0) {
> -               int real_last_index =3D last_index;
> -               struct sk_buff *skb =3D NULL;
> -               u32 ts_sec =3D 0;
> -               u32 ts_nsec =3D 0;
> -
> -               /* packet is available */
> -               if (first_index =3D=3D last_index) {
> -                       /* single buffer packet */
> -                       struct sk_buff *new_skb =3D NULL;
> -                       int packet_length;
> -
> -                       new_skb =3D lan743x_rx_allocate_skb(rx);
> -                       if (!new_skb) {
> -                               /* failed to allocate next skb.
> -                                * Memory is very low.
> -                                * Drop this packet and reuse buffer.
> -                                */
> -                               lan743x_rx_reuse_ring_element(rx, first_i=
ndex);
> -                               goto process_extension;
> -                       }
>
> -                       buffer_info =3D &rx->buffer_info[first_index];
> -                       skb =3D buffer_info->skb;
> -                       descriptor =3D &rx->ring_cpu_ptr[first_index];
> -
> -                       /* unmap from dma */
> -                       packet_length =3D RX_DESC_DATA0_FRAME_LENGTH_GET_
> -                                       (descriptor->data0);
> -                       if (buffer_info->dma_ptr) {
> -                               dma_sync_single_for_cpu(&rx->adapter->pde=
v->dev,
> -                                                       buffer_info->dma_=
ptr,
> -                                                       packet_length,
> -                                                       DMA_FROM_DEVICE);
> -                               dma_unmap_single_attrs(&rx->adapter->pdev=
->dev,
> -                                                      buffer_info->dma_p=
tr,
> -                                                      buffer_info->buffe=
r_length,
> -                                                      DMA_FROM_DEVICE,
> -                                                      DMA_ATTR_SKIP_CPU_=
SYNC);
> -                               buffer_info->dma_ptr =3D 0;
> -                               buffer_info->buffer_length =3D 0;
> -                       }
> -                       buffer_info->skb =3D NULL;
> -                       packet_length =3D RX_DESC_DATA0_FRAME_LENGTH_GET_
> -                                       (le32_to_cpu(descriptor->data0));
> -                       skb_put(skb, packet_length - 4);
> -                       skb->protocol =3D eth_type_trans(skb,
> -                                                      rx->adapter->netde=
v);
> -                       lan743x_rx_init_ring_element(rx, first_index, new=
_skb);
> -               } else {
> -                       int index =3D first_index;
> +       /* Only the last buffer in a multi-buffer frame contains the tota=
l frame
> +        * length. All other buffers have a zero frame length. The chip
> +        * occasionally sends more buffers than strictly required to reac=
h the
> +        * total frame length.
> +        * Handle this by adding all buffers to the skb in their entirety=
.
> +        * Once the real frame length is known, trim the skb.
> +        */
> +       frame_length =3D
> +               RX_DESC_DATA0_FRAME_LENGTH_GET_(le32_to_cpu(descriptor->d=
ata0));
> +       buffer_length =3D buffer_info->buffer_length;
>
> -                       /* multi buffer packet not supported */
> -                       /* this should not happen since buffers are alloc=
ated
> -                        * to be at least the mtu size configured in the =
mac.
> -                        */
> +       netdev_dbg(rx->adapter->netdev, "%s%schunk: %d/%d",
> +                  is_first ? "first " : "      ",
> +                  is_last  ? "last  " : "      ",
> +                  frame_length, buffer_length);
>
> -                       /* clean up buffers */
> -                       if (first_index <=3D last_index) {
> -                               while ((index >=3D first_index) &&
> -                                      (index <=3D last_index)) {
> -                                       lan743x_rx_reuse_ring_element(rx,
> -                                                                     ind=
ex);
> -                                       index =3D lan743x_rx_next_index(r=
x,
> -                                                                     ind=
ex);
> -                               }
> -                       } else {
> -                               while ((index >=3D first_index) ||
> -                                      (index <=3D last_index)) {
> -                                       lan743x_rx_reuse_ring_element(rx,
> -                                                                     ind=
ex);
> -                                       index =3D lan743x_rx_next_index(r=
x,
> -                                                                     ind=
ex);
> -                               }
> -                       }
> -               }
> +       /* unmap from dma */
> +       if (buffer_info->dma_ptr) {
> +               dma_unmap_single(&rx->adapter->pdev->dev,
> +                                buffer_info->dma_ptr,
> +                                buffer_info->buffer_length,
> +                                DMA_FROM_DEVICE);
> +               buffer_info->dma_ptr =3D 0;
> +               buffer_info->buffer_length =3D 0;
> +       }
> +       skb =3D buffer_info->skb;
>
> -process_extension:
> -               if (extension_index >=3D 0) {
> -                       descriptor =3D &rx->ring_cpu_ptr[extension_index]=
;
> -                       buffer_info =3D &rx->buffer_info[extension_index]=
;
> -
> -                       ts_sec =3D le32_to_cpu(descriptor->data1);
> -                       ts_nsec =3D (le32_to_cpu(descriptor->data2) &
> -                                 RX_DESC_DATA2_TS_NS_MASK_);
> -                       lan743x_rx_reuse_ring_element(rx, extension_index=
);
> -                       real_last_index =3D extension_index;
> -               }
> +       /* allocate new skb and map to dma */
> +       if (lan743x_rx_init_ring_element(rx, rx->last_head)) {
> +               /* failed to allocate next skb.
> +                * Memory is very low.
> +                * Drop this packet and reuse buffer.
> +                */
> +               lan743x_rx_reuse_ring_element(rx, rx->last_head);
> +               goto process_extension;
> +       }
> +
> +       /* add buffers to skb via skb->frag_list */
> +       if (is_first) {
> +               skb_reserve(skb, RX_HEAD_PADDING);
> +               skb_put(skb, buffer_length - RX_HEAD_PADDING);
> +               if (rx->skb_head)
> +                       dev_kfree_skb_irq(rx->skb_head);
> +               rx->skb_head =3D skb;
> +       } else if (rx->skb_head) {
> +               skb_put(skb, buffer_length);
> +               if (skb_shinfo(rx->skb_head)->frag_list)
> +                       rx->skb_tail->next =3D skb;
> +               else
> +                       skb_shinfo(rx->skb_head)->frag_list =3D skb;

Instead of chaining skbs into frag_list, you could perhaps delay skb
alloc until after reception, allocate buffers stand-alone, and link
them into the skb as skb_frags? That might avoid a few skb alloc +
frees. Though a bit change, not sure how feasible.

> +               rx->skb_tail =3D skb;
> +               rx->skb_head->len +=3D skb->len;
> +               rx->skb_head->data_len +=3D skb->len;
> +               rx->skb_head->truesize +=3D skb->truesize;
> +       } else {
> +               rx->skb_head =3D skb;
> +       }
>
> -               if (!skb) {
> -                       result =3D RX_PROCESS_RESULT_PACKET_DROPPED;
> -                       goto move_forward;
> +process_extension:
> +       if (extension_index >=3D 0) {
> +               u32 ts_sec;
> +               u32 ts_nsec;
> +
> +               ts_sec =3D le32_to_cpu(desc_ext->data1);
> +               ts_nsec =3D (le32_to_cpu(desc_ext->data2) &
> +                         RX_DESC_DATA2_TS_NS_MASK_);
> +               if (rx->skb_head) {
> +                       hwtstamps =3D skb_hwtstamps(rx->skb_head);
> +                       if (hwtstamps)

This is always true.

You can just call skb_hwtstamps(skb)->hwtstamp =3D ktime_set(ts_sec, ts_nse=
c);

Though I see that this is existing code just moved due to
aforementioned indentation change.
