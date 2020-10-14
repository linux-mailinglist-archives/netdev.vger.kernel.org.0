Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE35728E5B5
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 19:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgJNRtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 13:49:04 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:17446 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgJNRtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 13:49:04 -0400
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMGXsh6lyA="
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id D0b41cw9EHmeX6a
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 14 Oct 2020 19:48:40 +0200 (CEST)
Subject: Re: [PATCH net] can: peak_usb: add range checking in decode
 operations
To:     =?UTF-8?Q?St=c3=a9phane_Grosjean?= <s.grosjean@peak-system.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andri Yngvason <andri.yngvason@marel.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>
References: <20200813140604.GA456946@mwanda>
 <VI1PR03MB50536300783DBBEAFC7B0367D6050@VI1PR03MB5053.eurprd03.prod.outlook.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <169f62c4-ee2d-6ba2-2a78-640df8edcde0@hartkopp.net>
Date:   Wed, 14 Oct 2020 19:48:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <VI1PR03MB50536300783DBBEAFC7B0367D6050@VI1PR03MB5053.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephane,

On 14.10.20 15:22, Stéphane Grosjean wrote:
> Hello Dan,
> 
> Don't know if this patch is still relevant, but:
> 
> - there is absolutely no reason for the device firmware to provide a channel index greater than or equal to 2, because the IP core of these USB devices handles 2 channels only. Anyway, these changes are correct.
> - considering the verification of the length "cfd->len" on the other hand, this one comes directly from can_send() via dev_queue_xmit() AFAIK and it seems to me that the underlying driver can assume that its value is smaller than 64.

In fact there are many inbound checks e.g. with 
can_dropped_invalid_skb() to make sure the network layer gets proper CAN 
skbs (with ETH_P_CAN(FD) ethertypes).

On the outgoing path the CAN driver gets these ETH_P_CAN(FD) CAN skbs an 
just copies the CAN ID and the up to 64 bytes of data from that skb.

But remember that you can also generate CAN frames via AF_PACKET sockets 
which does not perform the sanity checks from can_send():
https://github.com/linux-can/can-tests/blob/master/netlayer/tst-packet.c

Copying 64 byte from the skb into an I/O attached CAN controller is 
always a safe operation - but when you send the content through another 
medium (e.g. USB) the length values should be checked.

Best regards,
Oliver

> 
> Regards,
> ---
> Stéphane Grosjean
> PEAK-System France
> 132, rue André Bisiaux
> F-54320 MAXEVILLE
> Tél : +(33) 9.72.54.51.97
> 
> 
> 
> De : Dan Carpenter <dan.carpenter@oracle.com>
> Envoyé : jeudi 13 août 2020 16:06
> À : Wolfgang Grandegger <wg@grandegger.com>; Stéphane Grosjean <s.grosjean@peak-system.com>
> Cc : Marc Kleine-Budde <mkl@pengutronix.de>; David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Andri Yngvason <andri.yngvason@marel.com>; Oliver Hartkopp <socketcan@hartkopp.net>; linux-can@vger.kernel.org <linux-can@vger.kernel.org>; netdev@vger.kernel.org <netdev@vger.kernel.org>; kernel-janitors@vger.kernel.org <kernel-janitors@vger.kernel.org>
> Objet : [PATCH net] can: peak_usb: add range checking in decode operations
> 
> These values come from skb->data so Smatch considers them untrusted.  I
> believe Smatch is correct but I don't have a way to test this.
> 
> The usb_if->dev[] array has 2 elements but the index is in the 0-15
> range without checks.  The cfd->len can be up to 255 but the maximum
> valid size is CANFD_MAX_DLEN (64) so that could lead to memory
> corruption.
> 
> Fixes: 0a25e1f4f185 ("can: peak_usb: add support for PEAK new CANFD USB adapters")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 48 +++++++++++++++++-----
>   1 file changed, 37 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
> index 47cc1ff5b88e..dee3e689b54d 100644
> --- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
> +++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
> @@ -468,12 +468,18 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_usb_fd_if *usb_if,
>                                        struct pucan_msg *rx_msg)
>   {
>           struct pucan_rx_msg *rm = (struct pucan_rx_msg *)rx_msg;
> -       struct peak_usb_device *dev = usb_if->dev[pucan_msg_get_channel(rm)];
> -       struct net_device *netdev = dev->netdev;
> +       struct peak_usb_device *dev;
> +       struct net_device *netdev;
>           struct canfd_frame *cfd;
>           struct sk_buff *skb;
>           const u16 rx_msg_flags = le16_to_cpu(rm->flags);
> 
> +       if (pucan_msg_get_channel(rm) >= ARRAY_SIZE(usb_if->dev))
> +               return -ENOMEM;
> +
> +       dev = usb_if->dev[pucan_msg_get_channel(rm)];
> +       netdev = dev->netdev;
> +
>           if (rx_msg_flags & PUCAN_MSG_EXT_DATA_LEN) {
>                   /* CANFD frame case */
>                   skb = alloc_canfd_skb(netdev, &cfd);
> @@ -519,15 +525,21 @@ static int pcan_usb_fd_decode_status(struct pcan_usb_fd_if *usb_if,
>                                        struct pucan_msg *rx_msg)
>   {
>           struct pucan_status_msg *sm = (struct pucan_status_msg *)rx_msg;
> -       struct peak_usb_device *dev = usb_if->dev[pucan_stmsg_get_channel(sm)];
> -       struct pcan_usb_fd_device *pdev =
> -                       container_of(dev, struct pcan_usb_fd_device, dev);
> +       struct pcan_usb_fd_device *pdev;
>           enum can_state new_state = CAN_STATE_ERROR_ACTIVE;
>           enum can_state rx_state, tx_state;
> -       struct net_device *netdev = dev->netdev;
> +       struct peak_usb_device *dev;
> +       struct net_device *netdev;
>           struct can_frame *cf;
>           struct sk_buff *skb;
> 
> +       if (pucan_stmsg_get_channel(sm) >= ARRAY_SIZE(usb_if->dev))
> +               return -ENOMEM;
> +
> +       dev = usb_if->dev[pucan_stmsg_get_channel(sm)];
> +       pdev = container_of(dev, struct pcan_usb_fd_device, dev);
> +       netdev = dev->netdev;
> +
>           /* nothing should be sent while in BUS_OFF state */
>           if (dev->can.state == CAN_STATE_BUS_OFF)
>                   return 0;
> @@ -579,9 +591,14 @@ static int pcan_usb_fd_decode_error(struct pcan_usb_fd_if *usb_if,
>                                       struct pucan_msg *rx_msg)
>   {
>           struct pucan_error_msg *er = (struct pucan_error_msg *)rx_msg;
> -       struct peak_usb_device *dev = usb_if->dev[pucan_ermsg_get_channel(er)];
> -       struct pcan_usb_fd_device *pdev =
> -                       container_of(dev, struct pcan_usb_fd_device, dev);
> +       struct pcan_usb_fd_device *pdev;
> +       struct peak_usb_device *dev;
> +
> +       if (pucan_ermsg_get_channel(er) >= ARRAY_SIZE(usb_if->dev))
> +               return -EINVAL;
> +
> +       dev = usb_if->dev[pucan_ermsg_get_channel(er)];
> +       pdev = container_of(dev, struct pcan_usb_fd_device, dev);
> 
>           /* keep a trace of tx and rx error counters for later use */
>           pdev->bec.txerr = er->tx_err_cnt;
> @@ -595,11 +612,17 @@ static int pcan_usb_fd_decode_overrun(struct pcan_usb_fd_if *usb_if,
>                                         struct pucan_msg *rx_msg)
>   {
>           struct pcan_ufd_ovr_msg *ov = (struct pcan_ufd_ovr_msg *)rx_msg;
> -       struct peak_usb_device *dev = usb_if->dev[pufd_omsg_get_channel(ov)];
> -       struct net_device *netdev = dev->netdev;
> +       struct peak_usb_device *dev;
> +       struct net_device *netdev;
>           struct can_frame *cf;
>           struct sk_buff *skb;
> 
> +       if (pufd_omsg_get_channel(ov) >= ARRAY_SIZE(usb_if->dev))
> +               return -EINVAL;
> +
> +       dev = usb_if->dev[pufd_omsg_get_channel(ov)];
> +       netdev = dev->netdev;
> +
>           /* allocate an skb to store the error frame */
>           skb = alloc_can_err_skb(netdev, &cf);
>           if (!skb)
> @@ -716,6 +739,9 @@ static int pcan_usb_fd_encode_msg(struct peak_usb_device *dev,
>           u16 tx_msg_size, tx_msg_flags;
>           u8 can_dlc;
> 
> +       if (cfd->len > CANFD_MAX_DLEN)
> +               return -EINVAL;
> +
>           tx_msg_size = ALIGN(sizeof(struct pucan_tx_msg) + cfd->len, 4);
>           tx_msg->size = cpu_to_le16(tx_msg_size);
>           tx_msg->type = cpu_to_le16(PUCAN_MSG_CAN_TX);
> --
> 2.28.0
> 
> --
> PEAK-System Technik GmbH
> Sitz der Gesellschaft Darmstadt - HRB 9183
> Geschaeftsfuehrung: Alexander Gach / Uwe Wilhelm
> Unsere Datenschutzerklaerung mit wichtigen Hinweisen
> zur Behandlung personenbezogener Daten finden Sie unter
> www.peak-system.com/Datenschutz.483.0.html
> 
