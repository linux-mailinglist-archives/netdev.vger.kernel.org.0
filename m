Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C4C109E00
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 13:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfKZMbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 07:31:51 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34637 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbfKZMbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 07:31:50 -0500
Received: by mail-ed1-f67.google.com with SMTP id cx19so8442522edb.1
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 04:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ucnjl+xWEWgXZurPFvhxMDytoknkCl3I3jXU/btS2IE=;
        b=gAfFV6N0cEKqk5q45ujN6XbdFbEpdJmASsGAGmQhYYQiez6YERtwehqh6rgZbDLkFI
         a2PAXkBODTkCpDmMXoK8nhnTNB4ZzTzpUitE9oDwBpIXAcNY/HETyq3iRXGqDYEKAxbK
         tt5qe5WE+UfmQDgdbvXYvcGWdJaFHP8EiHpKyEiL4FSq/c2jQv+ehL2PnWVUSPj4V4hh
         YLFgbdPfsn3YTxxbhDcH4cNpzNQLMHKCkpceSTu+6fXWkGHIQ5jgXafYRYAU0UnIZvPR
         pce22eSe9TtiE0p8jnBkMIN0mDzMikExlII3/zlReVTbICA0I/lRVNe8GP4Ajgli+2Qf
         9xyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ucnjl+xWEWgXZurPFvhxMDytoknkCl3I3jXU/btS2IE=;
        b=YcZmdUiHISa9JjpIpVIeAFQV5MFjvsPM/477k+a4n+rZm1n74GAi3z9wrbWat5pH3i
         6sks+2IAafOnubh/o2aDzJnV5UQQKEPV9JQEWYG/FNLVBE3B6l3lNVkgVyFVEXVMaXtd
         vCelTm3hPAsBGPtJXF+rQSmPlkp6IWvs8yPiR4I/fzcFDG4CiqhM/RyRDF60TqGduNtg
         qFYQZ0id8V8pXOLKtq0OSV1CUZ2vU3PM7RZhFB/E4gYe8pnTPgd9PKxQJySRqv/aU5Ko
         3LYZrfsNZsWRjutnwgNusxJ/xAP9nMKz6aIpiRlGhjFHVi93oDI0q/5beuN+GYRZDEdS
         Ddzg==
X-Gm-Message-State: APjAAAXRl7T/J3avmkIjgorBhQPPcekuPyOBuog2jLEAcGZwJMF9nm5n
        plqt2RngQ/WRMgPjNfTpoODOPmL2jddlsYPmG8I=
X-Google-Smtp-Source: APXvYqwRcIhXClv4WgxddL4p0fkqYjajyTXuWlKroxFKWl4wADUrbLCorb93Cmdse1XsNUgUKRoS7Ux2h2xPhj6SCaE=
X-Received: by 2002:a17:906:b819:: with SMTP id dv25mr25008715ejb.182.1574771506914;
 Tue, 26 Nov 2019 04:31:46 -0800 (PST)
MIME-Version: 1.0
References: <20191126104403.46717-1-yangbo.lu@nxp.com>
In-Reply-To: <20191126104403.46717-1-yangbo.lu@nxp.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 26 Nov 2019 14:31:35 +0200
Message-ID: <CA+h21hq9rgvQzjYO5bbxXs9wmVy-1Fomnre+veUS_+P-mwLUdg@mail.gmail.com>
Subject: Re: [PATCH] net: mscc: ocelot: fix potential issues accessing skbs list
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yangbo,

On Tue, 26 Nov 2019 at 14:22, Yangbo Lu <yangbo.lu@nxp.com> wrote:
>
> Fix two prtential issues accessing skbs list.
> - Protect skbs list in case of competing for accessing.
> - Break the matching loop when find the matching skb to
>   avoid consuming more skbs incorrectly. The ID is only
>   from 0 to 3, but the FIFO supports 128 timestamps at most.
>
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---

Don't you want to convert struct ocelot_skb to a proper struct
sk_buff_head skb_queue, which has its own lock when calling
skb_dequeue? The timestamp ID can be held in skb->cb.

>  drivers/net/ethernet/mscc/ocelot.c | 11 +++++++++++
>  include/soc/mscc/ocelot.h          |  2 ++
>  2 files changed, 13 insertions(+)
>
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 0e96ffa..5d842d8 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -580,6 +580,7 @@ int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
>  {
>         struct skb_shared_info *shinfo = skb_shinfo(skb);
>         struct ocelot *ocelot = ocelot_port->ocelot;
> +       unsigned long flags;
>
>         if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
>             ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> @@ -594,7 +595,9 @@ int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
>                 oskb->skb = skb;
>                 oskb->id = ocelot_port->ts_id % 4;
>
> +               spin_lock_irqsave(&ocelot_port->skbs_lock, flags);
>                 list_add_tail(&oskb->head, &ocelot_port->skbs);
> +               spin_unlock_irqrestore(&ocelot_port->skbs_lock, flags);
>                 return 0;
>         }
>         return -ENODATA;
> @@ -702,6 +705,7 @@ static void ocelot_get_hwtimestamp(struct ocelot *ocelot,
>  void ocelot_get_txtstamp(struct ocelot *ocelot)
>  {
>         int budget = OCELOT_PTP_QUEUE_SZ;
> +       unsigned long flags;
>
>         while (budget--) {
>                 struct skb_shared_hwtstamps shhwtstamps;
> @@ -727,6 +731,7 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
>                 /* Retrieve its associated skb */
>                 port = ocelot->ports[txport];
>
> +               spin_lock_irqsave(&port->skbs_lock, flags);
>                 list_for_each_safe(pos, tmp, &port->skbs) {
>                         entry = list_entry(pos, struct ocelot_skb, head);
>                         if (entry->id != id)
> @@ -736,7 +741,9 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
>
>                         list_del(pos);
>                         kfree(entry);
> +                       break;

I think this should be a separate patch, since it is unrelated to locking.

>                 }
> +               spin_unlock_irqrestore(&port->skbs_lock, flags);
>
>                 /* Next ts */
>                 ocelot_write(ocelot, SYS_PTP_NXT_PTP_NXT, SYS_PTP_NXT);
> @@ -2205,6 +2212,7 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
>  {
>         struct ocelot_port *ocelot_port = ocelot->ports[port];
>
> +       spin_lock_init(&ocelot_port->skbs_lock);
>         INIT_LIST_HEAD(&ocelot_port->skbs);
>
>         /* Basic L2 initialization */
> @@ -2493,6 +2501,7 @@ void ocelot_deinit(struct ocelot *ocelot)
>         struct list_head *pos, *tmp;
>         struct ocelot_port *port;
>         struct ocelot_skb *entry;
> +       unsigned long flags;
>         int i;
>
>         cancel_delayed_work(&ocelot->stats_work);
> @@ -2503,6 +2512,7 @@ void ocelot_deinit(struct ocelot *ocelot)
>         for (i = 0; i < ocelot->num_phys_ports; i++) {
>                 port = ocelot->ports[i];
>
> +               spin_lock_irqsave(&port->skbs_lock, flags);
>                 list_for_each_safe(pos, tmp, &port->skbs) {
>                         entry = list_entry(pos, struct ocelot_skb, head);
>
> @@ -2510,6 +2520,7 @@ void ocelot_deinit(struct ocelot *ocelot)
>                         dev_kfree_skb_any(entry->skb);
>                         kfree(entry);
>                 }
> +               spin_unlock_irqrestore(&port->skbs_lock, flags);
>         }
>  }
>  EXPORT_SYMBOL(ocelot_deinit);
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index e1108a5..7973458 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -426,6 +426,8 @@ struct ocelot_port {
>
>         u8                              ptp_cmd;
>         struct list_head                skbs;
> +       /* Protects the skbs list */
> +       spinlock_t                      skbs_lock;
>         u8                              ts_id;
>  };
>
> --
> 2.7.4
>

Regards,
-Vladimir
