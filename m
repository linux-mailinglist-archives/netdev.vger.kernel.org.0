Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90F22D3378
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgLHUTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:19:33 -0500
Received: from mail-oo1-f65.google.com ([209.85.161.65]:47077 "EHLO
        mail-oo1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgLHUTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 15:19:32 -0500
Received: by mail-oo1-f65.google.com with SMTP id w9so4306053ooh.13;
        Tue, 08 Dec 2020 12:19:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qJqe5GlOkGactXd+UvB7dTXx80iqow5kmSOsvIg6D6I=;
        b=JMte+yBzXc54RycI7zmJZ7ViAtJBEKDyXCwy5RoczN+Ih8URQd0zLgbz4l320cyvR9
         +dpztvlGOz1cL6Gem6/fj43E5K8Wh+r1q25Ekp910SmY0ynm0dQxDm6Kd8wNJbs87vAK
         uGIW3k+Q6ItieuuQ2NC6ni87NMNWv3R8j8Uy3jesb//JT5a0K3XhxbvOlNUtHdRqAKmB
         u1DSFJngSLK/zbsI/qndHHADQRHp2DqcZ1vO3VS2+AIHsLWlC0jJTk34//MQGaTOXHfL
         Df24rSXr8Yutuis+z5f6YJsEjz4+rNzWOhswvyF/lHdT4+mkufV3Id2HxpBWMNJOmy+0
         B96w==
X-Gm-Message-State: AOAM531b0VGmTaR3q6uwpQVDHzbGuWFlcZ4FIoxaP8DyvVNhDReNpNQ1
        RbXRcr8eDwuTNb6v5d8+G7P2CbMUryY=
X-Google-Smtp-Source: ABdhPJyohR4+NEfd+FsNhU97NOvVZGH8m4xZj91j3ggzvzPvVw4xK9srVqzrhy+M28mnTo8E9/CNaw==
X-Received: by 2002:a9d:7a97:: with SMTP id l23mr17875856otn.232.1607454859563;
        Tue, 08 Dec 2020 11:14:19 -0800 (PST)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com. [209.85.210.52])
        by smtp.gmail.com with ESMTPSA id e81sm3877935oia.30.2020.12.08.11.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 11:14:18 -0800 (PST)
Received: by mail-ot1-f52.google.com with SMTP id b62so16833557otc.5;
        Tue, 08 Dec 2020 11:14:18 -0800 (PST)
X-Received: by 2002:a9d:711b:: with SMTP id n27mr17989008otj.221.1607454858711;
 Tue, 08 Dec 2020 11:14:18 -0800 (PST)
MIME-Version: 1.0
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk> <20201205191744.7847-3-rasmus.villemoes@prevas.dk>
In-Reply-To: <20201205191744.7847-3-rasmus.villemoes@prevas.dk>
From:   Li Yang <leoyang.li@nxp.com>
Date:   Tue, 8 Dec 2020 13:14:06 -0600
X-Gmail-Original-Message-ID: <CADRPPNTgqwd37VSqiUcv2otGVr4mnQbuv6r887w_yCp=ha1dvA@mail.gmail.com>
Message-ID: <CADRPPNTgqwd37VSqiUcv2otGVr4mnQbuv6r887w_yCp=ha1dvA@mail.gmail.com>
Subject: Re: [PATCH 02/20] ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Netdev <netdev@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 5, 2020 at 1:21 PM Rasmus Villemoes
<rasmus.villemoes@prevas.dk> wrote:
>
> Table 8-53 in the QUICC Engine Reference manual shows definitions of
> fields up to a size of 192 bytes, not just 128. But in table 8-111,
> one does find the text
>
>   Base Address of the Global Transmitter Parameter RAM Page. [...]
>   The user needs to allocate 128 bytes for this page. The address must
>   be aligned to the page size.
>
> I've checked both rev. 7 (11/2015) and rev. 9 (05/2018) of the manual;
> they both have this inconsistency (and the table numbers are the
> same).

This does seem to be an inconsistency.  I will try to see if I can
find someone who is familiar with this as this is really an old IP.

Figure 8-61 does mention that size = 128 byte + 64 byte if ....    But
this part is not clear also.  Not sure if the size of the parameter
RAM is really conditional.

>
> Adding a bit of debug printing, on my board the struct
> ucc_geth_tx_global_pram is allocated at offset 0x880, while
> the (opaque) ucc_geth_thread_data_tx gets allocated immediately
> afterwards, at 0x900. So whatever the engine writes into the thread
> data overlaps with the tail of the global tx pram (and devmem says
> that something does get written during a simple ping).

The overlapping does seem to be a problem.  Maybe these global
parameters are not sampled at runtime or the parameter RAM is really
only using 128byte depending on the operation mode.

Are you getting useful information by reading from the additional 64
bytes, or getting changed behavior for setting these bytes after your
changes?

>
> I haven't observed any failure that could be attributed to this, but
> it seems to be the kind of thing that would be extremely hard to
> debug. So extend the struct definition so that we do allocate 192
> bytes.
>
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---
>  drivers/net/ethernet/freescale/ucc_geth.h | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/freescale/ucc_geth.h b/drivers/net/ethernet/freescale/ucc_geth.h
> index 3fe903972195..c80bed2c995c 100644
> --- a/drivers/net/ethernet/freescale/ucc_geth.h
> +++ b/drivers/net/ethernet/freescale/ucc_geth.h
> @@ -575,7 +575,14 @@ struct ucc_geth_tx_global_pram {
>         u32 vtagtable[0x8];     /* 8 4-byte VLAN tags */
>         u32 tqptr;              /* a base pointer to the Tx Queues Memory
>                                    Region */
> -       u8 res2[0x80 - 0x74];
> +       u8 res2[0x78 - 0x74];
> +       u64 snums_en;
> +       u32 l2l3baseptr;        /* top byte consists of a few other bit fields */
> +
> +       u16 mtu[8];
> +       u8 res3[0xa8 - 0x94];
> +       u32 wrrtablebase;       /* top byte is reserved */
> +       u8 res4[0xc0 - 0xac];
>  } __packed;
>
>  /* structure representing Extended Filtering Global Parameters in PRAM */
> --
> 2.23.0
>
