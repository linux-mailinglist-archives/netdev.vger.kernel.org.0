Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6429FE191F
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 13:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405014AbfJWLdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 07:33:55 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:40643 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390678AbfJWLdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 07:33:55 -0400
Received: by mail-il1-f195.google.com with SMTP id d83so10077823ilk.7
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 04:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w9EMXwTzi2G53AXGJ5eGxtmMpWQK79Y5WHtLxDhYubo=;
        b=J0usiRN1ezlKbpvTsC7ZALKt9X4luDSIKl5lq+Xn34vX8JwcH8X5h0S4u8E8zMSV4F
         etm10JONOHY9SST4MI5OdB0v+NPcjpJqGEO610hKfR73WA3o9dRr8YUjCdHsgVhsdJGl
         FaXMbzO1itsKg3iEIBNTG38H87MrMEYsJvW/wJtSgjU9dXwDJ1HxLjx1NoUuUxUhK/PX
         ZQQ8ctiAvrrASD1gxnOD1tlcHvInmuOubyx0JrHlTEPQB9JWTVuty6y+bne3vukK/00w
         iCPYwiurKBZm64Zmjh5Bj8mEbZDrfRcxzByKzTvgiCbkyQn6rMPUkwRfsCjIGK+Zfn0E
         isTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w9EMXwTzi2G53AXGJ5eGxtmMpWQK79Y5WHtLxDhYubo=;
        b=ciSLnsZoX/zbpUXO/xETfERDrhBOPEtibK5pO0WyIqf7JHTa71rJ1zgSLC6XY3XVf/
         4C5ScE3nvsocACO0ME2+sG8WI1h+6RrEn+tPbSFKJegv75fwFMuvwLPm0O6dS47U/KgB
         TaLt6sFPNPNKs/v1uua36zmu/SuIHjN51n09I+xj5Lq7MuGZjIVyIp7sSdSy7Qp9d+21
         ZWDXuxYEXPYR8AFnHc2OWlNlK0Q5IyUrErUssChHl0zeILinCWpGAFoUGwkORofpRuss
         HKt9ic+WZO2MIuM2KJGFM+njJr2+kKXPTMmofhnjNniJC57o3tqbIaw0JXc5IKtEvQdm
         o22Q==
X-Gm-Message-State: APjAAAVZDMEACnUoxRCFdo4WSVDcqSMILGm9uRvXFfNyczlYc7xNo5fF
        SftK1NrVTwI0fJHv5+uRTLmRxm+O3Vv4jfjXazE=
X-Google-Smtp-Source: APXvYqzh7zSVzdI/DO36hXP+yWepgOSPwp1rWT2sZ6XUbpymwU4ZRsoMRpSRcZvbyCZTPhozs8XIUUek/n/gZpDa+S4=
X-Received: by 2002:a92:a308:: with SMTP id a8mr35954589ili.65.1571830434412;
 Wed, 23 Oct 2019 04:33:54 -0700 (PDT)
MIME-Version: 1.0
References: <1571737634-5830-1-git-send-email-yanjun.zhu@oracle.com>
In-Reply-To: <1571737634-5830-1-git-send-email-yanjun.zhu@oracle.com>
From:   Rain River <rain.1986.08.12@gmail.com>
Date:   Wed, 23 Oct 2019 19:39:56 +0800
Message-ID: <CAJr_XRCeYZ0C1+UwC3Kh=kfG2qRyr+59bm5gbHmr94f1OK4o_Q@mail.gmail.com>
Subject: Re: [PATCHv2 1/1] net: forcedeth: add xmit_more support
To:     Zhu Yanjun <yanjun.zhu@oracle.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 5:38 PM Zhu Yanjun <yanjun.zhu@oracle.com> wrote:
>
> This change adds support for xmit_more based on the igb commit 6f19e12f6230
> ("igb: flush when in xmit_more mode and under descriptor pressure") and
> commit 6b16f9ee89b8 ("net: move skb->xmit_more hint to softnet data") that
> were made to igb to support this feature. The function netif_xmit_stopped
> is called to check if transmit queue on device is currently unable to send
> to determine if we must write the tail because we can add no further
> buffers.
> When normal packets and/or xmit_more packets fill up tx_desc, it is
> necessary to trigger NIC tx reg.
>
> Tested:
>   - pktgen (xmit_more packets) SMP x86_64 ->
>     Test command:
>     ./pktgen_sample03_burst_single_flow.sh ... -b 8 -n 1000000
>     Test results:
>     Params:
>     ...
>     burst: 8
>     ...
>     Result: OK: 12194004(c12188996+d5007) usec, 1000001 (1500byte,0frags)
>     82007pps 984Mb/sec (984084000bps) errors: 0
>
>   - iperf (normal packets) SMP x86_64 ->
>     Test command:
>     Server: iperf -s
>     Client: iperf -c serverip
>     Result:
>     TCP window size: 85.0 KByte (default)
>     ------------------------------------------------------------
>     [ ID] Interval       Transfer     Bandwidth
>     [  3]  0.0-10.0 sec  1.10 GBytes   942 Mbits/sec
>
> CC: Joe Jin <joe.jin@oracle.com>
> CC: JUNXIAO_BI <junxiao.bi@oracle.com>
> Reported-and-tested-by: Nan san <nan.1986san@gmail.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Thanks.
Acked-by: Rain River <rain.1986.08.12@gmail.com>

> ---
> V1->V2: use the lower case label.
> ---
>  drivers/net/ethernet/nvidia/forcedeth.c | 37 +++++++++++++++++++++++++++------
>  1 file changed, 31 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
> index 05d2b47..e2bb0cd 100644
> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> @@ -2225,6 +2225,7 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
>         struct nv_skb_map *prev_tx_ctx;
>         struct nv_skb_map *tmp_tx_ctx = NULL, *start_tx_ctx = NULL;
>         unsigned long flags;
> +       netdev_tx_t ret = NETDEV_TX_OK;
>
>         /* add fragments to entries count */
>         for (i = 0; i < fragments; i++) {
> @@ -2240,7 +2241,12 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
>                 netif_stop_queue(dev);
>                 np->tx_stop = 1;
>                 spin_unlock_irqrestore(&np->lock, flags);
> -               return NETDEV_TX_BUSY;
> +
> +               /* When normal packets and/or xmit_more packets fill up
> +                * tx_desc, it is necessary to trigger NIC tx reg.
> +                */
> +               ret = NETDEV_TX_BUSY;
> +               goto txkick;
>         }
>         spin_unlock_irqrestore(&np->lock, flags);
>
> @@ -2357,8 +2363,14 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
>
>         spin_unlock_irqrestore(&np->lock, flags);
>
> -       writel(NVREG_TXRXCTL_KICK|np->txrxctl_bits, get_hwbase(dev) + NvRegTxRxControl);
> -       return NETDEV_TX_OK;
> +txkick:
> +       if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
> +               u32 txrxctl_kick = NVREG_TXRXCTL_KICK | np->txrxctl_bits;
> +
> +               writel(txrxctl_kick, get_hwbase(dev) + NvRegTxRxControl);
> +       }
> +
> +       return ret;
>  }
>
>  static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
> @@ -2381,6 +2393,7 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
>         struct nv_skb_map *start_tx_ctx = NULL;
>         struct nv_skb_map *tmp_tx_ctx = NULL;
>         unsigned long flags;
> +       netdev_tx_t ret = NETDEV_TX_OK;
>
>         /* add fragments to entries count */
>         for (i = 0; i < fragments; i++) {
> @@ -2396,7 +2409,13 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
>                 netif_stop_queue(dev);
>                 np->tx_stop = 1;
>                 spin_unlock_irqrestore(&np->lock, flags);
> -               return NETDEV_TX_BUSY;
> +
> +               /* When normal packets and/or xmit_more packets fill up
> +                * tx_desc, it is necessary to trigger NIC tx reg.
> +                */
> +               ret = NETDEV_TX_BUSY;
> +
> +               goto txkick;
>         }
>         spin_unlock_irqrestore(&np->lock, flags);
>
> @@ -2542,8 +2561,14 @@ static netdev_tx_t nv_start_xmit_optimized(struct sk_buff *skb,
>
>         spin_unlock_irqrestore(&np->lock, flags);
>
> -       writel(NVREG_TXRXCTL_KICK|np->txrxctl_bits, get_hwbase(dev) + NvRegTxRxControl);
> -       return NETDEV_TX_OK;
> +txkick:
> +       if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
> +               u32 txrxctl_kick = NVREG_TXRXCTL_KICK | np->txrxctl_bits;
> +
> +               writel(txrxctl_kick, get_hwbase(dev) + NvRegTxRxControl);
> +       }
> +
> +       return ret;
>  }
>
>  static inline void nv_tx_flip_ownership(struct net_device *dev)
> --
> 2.7.4
>
