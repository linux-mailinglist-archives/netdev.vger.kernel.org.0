Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB43422758
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbhJENI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:08:26 -0400
Received: from mail-vs1-f42.google.com ([209.85.217.42]:47072 "EHLO
        mail-vs1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234535AbhJENIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 09:08:25 -0400
Received: by mail-vs1-f42.google.com with SMTP id i30so2898849vsj.13;
        Tue, 05 Oct 2021 06:06:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r2FpP1EbIB3k8E1tVACO9N/+co9lYwbutThy1NWNMBI=;
        b=Hb/qWLS0I3OSPolQjAe8cx1XtMgRHKOIFl/c5mKNqkzBwD52fGcl3Kp1YYT4jKGAvn
         EqhtNwDgWueX5XpAxgV+HeoKIlPUf4fhO9/niRZ/8qQ0A1AFmoBgZBg8t2DlYlm8Lxxh
         Hu1XRDVqZpbWcyd79tEo1ZcCEfsIIro6mBL1udsFuYqcmiTcJmpC0sl8r5U9B0h19vR+
         jykIRnWidcRUYV9LVkB/kFWPpS4YkpUsHxuhVlfwQLi8rHoDEOm9CH0JdwG8JEtKFVSx
         CaGFt5vNfKSSVRQVVOK0FVUA0RpYNJjke//w0DUmC8yXb34kJK+DO58omxi7i5GqCtQE
         mSkA==
X-Gm-Message-State: AOAM53083HtSjMGzj+Y8YfZJa+5SZBlfZS2mEZizd2ZNzexZ6d8Mgy9i
        KS22Zcxja0iLUkiXuIEvKjL29EGVHXGNZWyiSMk=
X-Google-Smtp-Source: ABdhPJxTvG2ojdYPYMsbJ/4Jm5Wj/+UlW9UcAzFCl4WQahhFXULdNKY1N2oyhXOwzeZg7k2q9zxYAGey+YZBkpX9wcI=
X-Received: by 2002:a67:ac04:: with SMTP id v4mr9413870vse.50.1633439194150;
 Tue, 05 Oct 2021 06:06:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210924153113.10046-1-uli+renesas@fpond.eu> <20210924153113.10046-2-uli+renesas@fpond.eu>
In-Reply-To: <20210924153113.10046-2-uli+renesas@fpond.eu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 5 Oct 2021 15:06:22 +0200
Message-ID: <CAMuHMdXk2mZntTBe3skSVkcNVjC-PzMwEv_MbH85Mvn1ZkFpHw@mail.gmail.com>
Subject: Re: [PATCH 1/3] can: rcar_canfd: Add support for r8a779a0 SoC
To:     Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uli,

On Fri, Sep 24, 2021 at 5:38 PM Ulrich Hecht <uli+renesas@fpond.eu> wrote:
> Adds support for the CANFD IP variant in the V3U SoC.
>
> Differences to controllers in other SoCs are limited to an increase in
> the number of channels from two to eight, an absence of dedicated
> registers for "classic" CAN mode, and a number of differences in magic
> numbers (register offsets and layouts).
>
> Inspired by BSP patch by Kazuya Mizuguchi.
>
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>

Thanks for your patch!

> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -44,10 +44,13 @@
>  enum rcanfd_chip_id {
>         RENESAS_RCAR_GEN3 = 0,
>         RENESAS_RZG2L,
> +       RENESAS_R8A779A0,

RENESAS_RCAR_V3U? ...

>  };
>
>  /* Global register bits */
>
> +#define IS_V3U (gpriv->chip_id == RENESAS_R8A779A0)

... As you use V3U here.

> +
>  /* RSCFDnCFDGRMCFG */
>  #define RCANFD_GRMCFG_RCMC             BIT(0)
>
> @@ -79,6 +82,7 @@ enum rcanfd_chip_id {
>  #define RCANFD_GSTS_GNOPM              (BIT(0) | BIT(1) | BIT(2) | BIT(3))
>
>  /* RSCFDnCFDGERFL / RSCFDnGERFL */
> +#define RCANFD_GERFL_EEF0_7            GENMASK(23, 16)
>  #define RCANFD_GERFL_EEF1              BIT(17)
>  #define RCANFD_GERFL_EEF0              BIT(16)
>  #define RCANFD_GERFL_CMPOF             BIT(3)  /* CAN FD only */
> @@ -86,20 +90,24 @@ enum rcanfd_chip_id {
>  #define RCANFD_GERFL_MES               BIT(1)
>  #define RCANFD_GERFL_DEF               BIT(0)
>
> -#define RCANFD_GERFL_ERR(gpriv, x)     ((x) & (RCANFD_GERFL_EEF1 |\
> -                                       RCANFD_GERFL_EEF0 | RCANFD_GERFL_MES |\
> -                                       (gpriv->fdmode ?\
> -                                        RCANFD_GERFL_CMPOF : 0)))
> +#define RCANFD_GERFL_ERR(gpriv, x)     ((x) & ((IS_V3U ? RCANFD_GERFL_EEF0_7 : \
> +                                       (RCANFD_GERFL_EEF0 | RCANFD_GERFL_EEF1)) | \
> +                                       RCANFD_GERFL_MES | ((gpriv)->fdmode ? \
> +                                       RCANFD_GERFL_CMPOF : 0)))

I'm wondering if some of these IS_V3U checks can be avoided, improving
legibility, by storing a feature struct instead of a chip_id in
rcar_canfd_of_table[].data?

>  /* RSCFDnCFDRFCCx / RSCFDnRFCCx */
> -#define RCANFD_RFCC(x)                 (0x00b8 + (0x04 * (x)))
> +#define RCANFD_RFCC(x)                 ((IS_V3U ? 0x00c0 : 0x00b8) + \
> +                                        (0x04 * (x)))
>  /* RSCFDnCFDRFSTSx / RSCFDnRFSTSx */
> -#define RCANFD_RFSTS(x)                        (0x00d8 + (0x04 * (x)))
> +#define RCANFD_RFSTS(x)                        ((IS_V3U ? 0x00e0 : 0x00d8) + \
> +                                        (0x04 * (x)))
>  /* RSCFDnCFDRFPCTRx / RSCFDnRFPCTRx */
> -#define RCANFD_RFPCTR(x)               (0x00f8 + (0x04 * (x)))
> +#define RCANFD_RFPCTR(x)               ((IS_V3U ? 0x0100 : 0x00f8) + \
> +                                        (0x04 * (x)))

There's some logic in the offsets: they're 32 bytes apart, regardless
of IS_V3U. Can we make use of that?

>
>  /* Common FIFO Control registers */
>
>  /* RSCFDnCFDCFCCx / RSCFDnCFCCx */
> -#define RCANFD_CFCC(ch, idx)           (0x0118 + (0x0c * (ch)) + \
> -                                        (0x04 * (idx)))
> +#define RCANFD_CFCC(ch, idx)           ((IS_V3U ? 0x0120 : 0x0118) + \
> +                                        (0x0c * (ch)) + (0x04 * (idx)))
>  /* RSCFDnCFDCFSTSx / RSCFDnCFSTSx */
> -#define RCANFD_CFSTS(ch, idx)          (0x0178 + (0x0c * (ch)) + \
> -                                        (0x04 * (idx)))
> +#define RCANFD_CFSTS(ch, idx)          ((IS_V3U ? 0x01e0 : 0x0178) + \
> +                                        (0x0c * (ch)) + (0x04 * (idx)))
>  /* RSCFDnCFDCFPCTRx / RSCFDnCFPCTRx */
> -#define RCANFD_CFPCTR(ch, idx)         (0x01d8 + (0x0c * (ch)) + \
> -                                        (0x04 * (idx)))
> +#define RCANFD_CFPCTR(ch, idx)         ((IS_V3U ? 0x0240 : 0x01d8) + \
> +                                        (0x0c * (ch)) + (0x04 * (idx)))

Same here, 96 bytes spacing.

> @@ -1488,22 +1545,29 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
>  static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
>  {
>         struct net_device_stats *stats = &priv->ndev->stats;
> +       struct rcar_canfd_global *gpriv = priv->gpriv;
>         struct canfd_frame *cf;
>         struct sk_buff *skb;
>         u32 sts = 0, id, dlc;
>         u32 ch = priv->channel;
>         u32 ridx = ch + RCANFD_RFFIFO_IDX;
>
> -       if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
> +       if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) ||
> +           gpriv->chip_id == RENESAS_R8A779A0) {
>                 id = rcar_canfd_read(priv->base, RCANFD_F_RFID(ridx));
>                 dlc = rcar_canfd_read(priv->base, RCANFD_F_RFPTR(ridx));
>
>                 sts = rcar_canfd_read(priv->base, RCANFD_F_RFFDSTS(ridx));
> -               if (sts & RCANFD_RFFDSTS_RFFDF)
> -                       skb = alloc_canfd_skb(priv->ndev, &cf);
> -               else
> +               if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
> +                       if (sts & RCANFD_RFFDSTS_RFFDF)
> +                               skb = alloc_canfd_skb(priv->ndev, &cf);
> +                       else
> +                               skb = alloc_can_skb(priv->ndev,
> +                                                   (struct can_frame **)&cf);
> +               } else {
>                         skb = alloc_can_skb(priv->ndev,
>                                             (struct can_frame **)&cf);

The two else branches do the same, so they can be combined.

> +               }
>         } else {
>                 id = rcar_canfd_read(priv->base, RCANFD_C_RFID(ridx));
>                 dlc = rcar_canfd_read(priv->base, RCANFD_C_RFPTR(ridx));

> @@ -1563,6 +1633,7 @@ static int rcar_canfd_rx_poll(struct napi_struct *napi, int quota)
>  {
>         struct rcar_canfd_channel *priv =
>                 container_of(napi, struct rcar_canfd_channel, napi);
> +       struct rcar_canfd_global *gpriv = priv->gpriv;
>         int num_pkts;
>         u32 sts;
>         u32 ch = priv->channel;
> @@ -1762,19 +1833,23 @@ static int rcar_canfd_probe(struct platform_device *pdev)
>         int g_err_irq, g_recc_irq;
>         bool fdmode = true;                     /* CAN FD only mode - default */
>         enum rcanfd_chip_id chip_id;
> +       int max_channels;
> +       char name[9];
> +       int i;
>
>         chip_id = (uintptr_t)of_device_get_match_data(&pdev->dev);
> +       max_channels = chip_id == RENESAS_R8A779A0 ? 8 : 2;

max_channels is a good candidate to store in the feature struct.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
