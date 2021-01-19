Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A6C2FC241
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 22:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbhASVZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 16:25:20 -0500
Received: from mail-oo1-f42.google.com ([209.85.161.42]:34296 "EHLO
        mail-oo1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729240AbhASSqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 13:46:18 -0500
Received: by mail-oo1-f42.google.com with SMTP id x23so5168785oop.1
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 10:46:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZF7gsWe6vETmHWG11Fxl+LOq5ZQwIQwrV/49tlIIu/4=;
        b=bTTaWbGn7eOB9DAPgF8E4Ap4/Rjkd37att0VgwakzXoLKH+Ap3I5VbhkA/1SoAxTat
         YVttTE0aR7B7kqa29c9MWJBrM5rVW/Eih6XQv4QFZIYfwPT+e2Y8zUi90XiMKCmpGTHC
         EqvcV7l812o2ngLc3qom8U3coh+I+bP4j1axvC5bXEoarb9Wx0CEpkHbKJvK6WvF3cFh
         W+Lgpl1KvtMHf1GA+Si0kpErYbVhEtCCDHG2hZMbTLOfn9zrl0fvdCfd6TeuN0UW/mh4
         ZpSh1jHNGiD/LC5MOaDMuwpbUKq5YDHvMdZZH27l6l2imJWC2hdZ0VCxmk4EbK8APM5Y
         A7aQ==
X-Gm-Message-State: AOAM532LV3qIDpz6LNBqVm2J/qtqFMaMLnaHtxQ8bDwyafJfhvvVIqif
        KPAPGD18JooG3ldlfug3IpI6F2tpEWc=
X-Google-Smtp-Source: ABdhPJwjSCC+uKY3S2LDGy3mMEy4szflcxSVXUdgv3nkdbXJRk/9lRH7aw7LH4lyDJh29CcMo6C1Mg==
X-Received: by 2002:a4a:81:: with SMTP id 123mr3827949ooh.46.1611081936036;
        Tue, 19 Jan 2021 10:45:36 -0800 (PST)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com. [209.85.210.52])
        by smtp.gmail.com with ESMTPSA id a96sm2145869otb.12.2021.01.19.10.45.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 10:45:35 -0800 (PST)
Received: by mail-ot1-f52.google.com with SMTP id n42so20765370ota.12
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 10:45:35 -0800 (PST)
X-Received: by 2002:a9d:711b:: with SMTP id n27mr4468082otj.221.1611081934073;
 Tue, 19 Jan 2021 10:45:34 -0800 (PST)
MIME-Version: 1.0
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk> <20210119150802.19997-4-rasmus.villemoes@prevas.dk>
In-Reply-To: <20210119150802.19997-4-rasmus.villemoes@prevas.dk>
From:   Li Yang <leoyang.li@nxp.com>
Date:   Tue, 19 Jan 2021 12:45:22 -0600
X-Gmail-Original-Message-ID: <CADRPPNQB1SddpgC8f5XLP1SsqfaLk5nupkmQNdt4Wwo1rzxLew@mail.gmail.com>
Message-ID: <CADRPPNQB1SddpgC8f5XLP1SsqfaLk5nupkmQNdt4Wwo1rzxLew@mail.gmail.com>
Subject: Re: [PATCH net-next v2 03/17] soc: fsl: qe: store muram_vbase as a
 void pointer instead of u8
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 9:16 AM Rasmus Villemoes
<rasmus.villemoes@prevas.dk> wrote:
>
> The two functions cpm_muram_offset() and cpm_muram_dma() both need a
> cast currently, one casts muram_vbase to do the pointer arithmetic on
> void pointers, the other casts the passed-in address u8*.
>
> It's simpler and more consistent to just always use void* and drop all
> the casting.
>
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Acked-by: Li Yang <leoyang.li@nxp.com>

> ---
>  drivers/soc/fsl/qe/qe_common.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/soc/fsl/qe/qe_common.c b/drivers/soc/fsl/qe/qe_common.c
> index 0fbdc965c4cb..303cc2f5eb4a 100644
> --- a/drivers/soc/fsl/qe/qe_common.c
> +++ b/drivers/soc/fsl/qe/qe_common.c
> @@ -27,7 +27,7 @@
>
>  static struct gen_pool *muram_pool;
>  static spinlock_t cpm_muram_lock;
> -static u8 __iomem *muram_vbase;
> +static void __iomem *muram_vbase;
>  static phys_addr_t muram_pbase;
>
>  struct muram_block {
> @@ -225,7 +225,7 @@ EXPORT_SYMBOL(cpm_muram_addr);
>
>  unsigned long cpm_muram_offset(const void __iomem *addr)
>  {
> -       return addr - (void __iomem *)muram_vbase;
> +       return addr - muram_vbase;
>  }
>  EXPORT_SYMBOL(cpm_muram_offset);
>
> @@ -235,6 +235,6 @@ EXPORT_SYMBOL(cpm_muram_offset);
>   */
>  dma_addr_t cpm_muram_dma(void __iomem *addr)
>  {
> -       return muram_pbase + ((u8 __iomem *)addr - muram_vbase);
> +       return muram_pbase + (addr - muram_vbase);
>  }
>  EXPORT_SYMBOL(cpm_muram_dma);
> --
> 2.23.0
>
