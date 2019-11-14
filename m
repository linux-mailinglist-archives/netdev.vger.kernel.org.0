Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1294AFC41F
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfKNK0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:26:44 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33155 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfKNK0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:26:44 -0500
Received: by mail-oi1-f193.google.com with SMTP id m193so4814655oig.0;
        Thu, 14 Nov 2019 02:26:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3vUDOlw9rgqYts0sc3QrMbEJy6hhphDrJ0qLpT2W6Kk=;
        b=Qdc0tdUJLAr8U0OAThpSaOvKWmyP7jGe8hO/YYQP1PA+vnWRTbdqBsJtCC7hOupsEr
         Zv9rZ4mVi4hmJ+j2k09+fnup7QIn0yvVCDPzBcAqYMB9N91kMb0fLkX77fUoyNsC0dpB
         zQSiQ3dzFWyQwHttoOhD95gOw0i0g7EXntfuQURFYDX6z/uVNetoYhVEsZR2qFbyRs6h
         /8opQl2QqZRnCXBN7d42ztdkzJdSoGXZwYctr2L9o7Sm4hAh2FczsCNv/G0ZH98wT7MF
         3Xa0YL11sG1X9ZjaCrPy1rhwIijY97702PXMzXY26kTKlncJZ6xJbJ3suQFy0vzHWU9d
         sfOg==
X-Gm-Message-State: APjAAAVtiGy1Tl+SXfo92bSMuHkQ6reOMXCNeFb5B5NpoVMVHyOrcvvL
        OuGdjZlU+5LtF2j4EdKx0pP8k1TPPhIW0CwkpfI=
X-Google-Smtp-Source: APXvYqwb80FhTz2bEnA3PnpDXQY9l6Wa1/lnm+RNM3EX71mRDcq8pcV8pdWolx33gUXkD108qj5rLIbvV2O1oPaoPBM=
X-Received: by 2002:a05:6808:5d9:: with SMTP id d25mr1344251oij.54.1573727203050;
 Thu, 14 Nov 2019 02:26:43 -0800 (PST)
MIME-Version: 1.0
References: <20191114014949.31057-1-uli+renesas@fpond.eu>
In-Reply-To: <20191114014949.31057-1-uli+renesas@fpond.eu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 14 Nov 2019 11:26:31 +0100
Message-ID: <CAMuHMdXZQpYwAU4DE-Odnm0=EZMUDJ+0WLJjeErbVZJ8PkC5Dg@mail.gmail.com>
Subject: Re: [PATCH v4] ravb: implement MTU change while device is up
To:     Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Wolfram Sang <wsa@the-dreams.de>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uli,

On Thu, Nov 14, 2019 at 2:50 AM Ulrich Hecht <uli+renesas@fpond.eu> wrote:
> Pre-allocates buffers sufficient for the maximum supported MTU (2026) in
> order to eliminate the possibility of resource exhaustion when changing the
> MTU while the device is up.
>
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>

Thanks for your patch!

> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -293,9 +293,9 @@ static void ravb_ring_format(struct net_device *ndev, int q)
>         for (i = 0; i < priv->num_rx_ring[q]; i++) {
>                 /* RX descriptor */
>                 rx_desc = &priv->rx_ring[q][i];
> -               rx_desc->ds_cc = cpu_to_le16(priv->rx_buf_sz);
> +               rx_desc->ds_cc = cpu_to_le16(RX_BUF_SZ);

So the RAVB hardware will always see the full buffer size.
Hence if it receives a frame that is larger than the configured MTU, it will
still happily pass it to the driver, and to the network stack, which will
reject it, presumably?

Note that the driver doesn't seem to configure the Reception Truncation
Configuration register, so it will never reject frames up to 4092 bytes (unless
the boot loader has changed that).

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
